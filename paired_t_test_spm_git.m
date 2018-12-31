%%-----------------------------------------------------------------------
% Batch Script: Paired-T Test in SPM12 + Cluster level correction
% The soul of the script was crafted by 'the SPM meta-level aware': Ravi ji

% the slight modifications were done by vin
%%-----------------------------------------------------------------------

if ( ~exist('rootdir','var') || isempty(rootdir) )
    rootdir = spm_select(1, 'dir','Select root dir');
end

% add slash to rootdir (needed for SPM12)
if (~strcmp(rootdir(end),'/'))
 rootdir=[rootdir '/'];
end


matlabbatch{1}.spm.stats.factorial_design.dir = {rootdir};

files_pair_1=(spm_select(inf, 'image', ['Choose images (channel - ANY number']));
files_pair_1_cstr = cellstr(files_pair_1);

files_pair_2=(spm_select(inf, 'image', ['Choose images (channel - ANY number']));
files_pair_2_cstr = cellstr(files_pair_2);

for i = 1:size(files_pair_1_cstr,1)
    
    matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(i).scans = {files_pair_1_cstr{i}
        files_pair_2_cstr{i}
        };
end

matlabbatch{1}.spm.stats.factorial_design.des.pt.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.pt.ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'C1-C2';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'C2-C1';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [-1 1];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;
matlabbatch{4}.spm.stats.results.spmmat(1) = cfg_dep('Contrast Manager: SPM.mat File', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{4}.spm.stats.results.conspec(1).titlestr = '';
matlabbatch{4}.spm.stats.results.conspec(1).contrasts = 1;
matlabbatch{4}.spm.stats.results.conspec(1).threshdesc = 'none';  %%CHANGE: choises (FWE, FDR, none)
matlabbatch{4}.spm.stats.results.conspec(1).thresh = 0.001;  %% CHANGE
matlabbatch{4}.spm.stats.results.conspec(1).extent = 81;   %% CHANGE 
matlabbatch{4}.spm.stats.results.conspec(1).conjunction = 1;
matlabbatch{4}.spm.stats.results.conspec(1).mask.none = 1;
matlabbatch{4}.spm.stats.results.conspec(2).titlestr = '';
matlabbatch{4}.spm.stats.results.conspec(2).contrasts = 2;
matlabbatch{4}.spm.stats.results.conspec(2).threshdesc = 'none';  %%CHANGE: choises (FWE, FDR, none)
matlabbatch{4}.spm.stats.results.conspec(2).thresh = 0.001; %% CHANGE
matlabbatch{4}.spm.stats.results.conspec(2).extent = 81; %% CHANGE
matlabbatch{4}.spm.stats.results.conspec(2).conjunction = 1;
matlabbatch{4}.spm.stats.results.conspec(2).mask.none = 1;
matlabbatch{4}.spm.stats.results.units = 1;
matlabbatch{4}.spm.stats.results.export{1}.ps = true;


%spm_jobman('interactive',matlabbatch)
%Runs interactively
spm_jobman('run',matlabbatch)

%% Run cluster threshold, Determines how much threshold to set.
disp('1. Download files from the following website 2. run the above code 3. look at the threshold 4. change the values in the script #CHANGE')
%https://github.com/CyclotronResearchCentre/SPM_ClusterSizeThreshold
k_thresh = cp_cluster_Pthresh(xSPM, 0.001)
k_thresh = cp_cluster_Pthresh(xSPM, 0.05)
