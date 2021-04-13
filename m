Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA11F35DBD9
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 11:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242959AbhDMJxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 05:53:10 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:36696 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241803AbhDMJwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 05:52:53 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R491e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0UVRaqpU_1618307550;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UVRaqpU_1618307550)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 13 Apr 2021 17:52:31 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     shuah@kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] selftests/bpf: use !E instead of comparing with NULL
Date:   Tue, 13 Apr 2021 17:52:29 +0800
Message-Id: <1618307549-78149-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warnings:
./tools/testing/selftests/bpf/progs/profiler.inc.h:189:7-11: WARNING
comparing pointer to 0, suggest !E
./tools/testing/selftests/bpf/progs/profiler.inc.h:361:7-11: WARNING
comparing pointer to 0, suggest !E
./tools/testing/selftests/bpf/progs/profiler.inc.h:386:14-18: WARNING
comparing pointer to 0, suggest !E
./tools/testing/selftests/bpf/progs/profiler.inc.h:402:14-18: WARNING
comparing pointer to 0, suggest !E
./tools/testing/selftests/bpf/progs/profiler.inc.h:433:7-11: WARNING
comparing pointer to 0, suggest !E
./tools/testing/selftests/bpf/progs/profiler.inc.h:534:14-18: WARNING
comparing pointer to 0, suggest !E
./tools/testing/selftests/bpf/progs/profiler.inc.h:625:7-11: WARNING
comparing pointer to 0, suggest !E
./tools/testing/selftests/bpf/progs/profiler.inc.h:767:7-11: WARNING
comparing pointer to 0, suggest !E

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 tools/testing/selftests/bpf/progs/profiler.inc.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/profiler.inc.h b/tools/testing/selftests/bpf/progs/profiler.inc.h
index 4896fdf8..a33066c 100644
--- a/tools/testing/selftests/bpf/progs/profiler.inc.h
+++ b/tools/testing/selftests/bpf/progs/profiler.inc.h
@@ -189,7 +189,7 @@ static INLINE void populate_ancestors(struct task_struct* task,
 #endif
 	for (num_ancestors = 0; num_ancestors < MAX_ANCESTORS; num_ancestors++) {
 		parent = BPF_CORE_READ(parent, real_parent);
-		if (parent == NULL)
+		if (!parent)
 			break;
 		ppid = BPF_CORE_READ(parent, tgid);
 		if (is_init_process(ppid))
@@ -361,7 +361,7 @@ static INLINE void* populate_var_metadata(struct var_metadata_t* metadata,
 	int zero = 0;
 	struct var_kill_data_t* kill_data = bpf_map_lookup_elem(&data_heap, &zero);
 
-	if (kill_data == NULL)
+	if (!kill_data)
 		return NULL;
 	struct task_struct* task = (struct task_struct*)bpf_get_current_task();
 
@@ -386,14 +386,14 @@ static INLINE int trace_var_sys_kill(void* ctx, int tpid, int sig)
 	u32 spid = get_userspace_pid();
 	struct var_kill_data_arr_t* arr_struct = bpf_map_lookup_elem(&var_tpid_to_data, &tpid);
 
-	if (arr_struct == NULL) {
+	if (!arr_struct) {
 		struct var_kill_data_t* kill_data = get_var_kill_data(ctx, spid, tpid, sig);
 		int zero = 0;
 
-		if (kill_data == NULL)
+		if (!kill_data)
 			return 0;
 		arr_struct = bpf_map_lookup_elem(&data_heap, &zero);
-		if (arr_struct == NULL)
+		if (!arr_struct)
 			return 0;
 		bpf_probe_read(&arr_struct->array[0], sizeof(arr_struct->array[0]), kill_data);
 	} else {
@@ -402,7 +402,7 @@ static INLINE int trace_var_sys_kill(void* ctx, int tpid, int sig)
 		if (index == -1) {
 			struct var_kill_data_t* kill_data =
 				get_var_kill_data(ctx, spid, tpid, sig);
-			if (kill_data == NULL)
+			if (!kill_data)
 				return 0;
 #ifdef UNROLL
 #pragma unroll
@@ -433,7 +433,7 @@ static INLINE int trace_var_sys_kill(void* ctx, int tpid, int sig)
 		} else {
 			struct var_kill_data_t* kill_data =
 				get_var_kill_data(ctx, spid, tpid, sig);
-			if (kill_data == NULL)
+			if (!kill_data)
 				return 0;
 			bpf_probe_read(&arr_struct->array[index],
 				       sizeof(arr_struct->array[index]),
@@ -534,14 +534,14 @@ static INLINE bool is_dentry_allowed_for_filemod(struct dentry* file_dentry,
 	*device_id = dev_id;
 	bool* allowed_device = bpf_map_lookup_elem(&allowed_devices, &dev_id);
 
-	if (allowed_device == NULL)
+	if (!allowed_device)
 		return false;
 
 	u64 ino = BPF_CORE_READ(file_dentry, d_inode, i_ino);
 	*file_ino = ino;
 	bool* allowed_file = bpf_map_lookup_elem(&allowed_file_inodes, &ino);
 
-	if (allowed_file == NULL)
+	if (!allowed_fil)
 		if (!is_ancestor_in_allowed_inodes(BPF_CORE_READ(file_dentry, d_parent)))
 			return false;
 	return true;
@@ -625,7 +625,7 @@ int raw_tracepoint__sched_process_exit(void* ctx)
 	struct var_kill_data_arr_t* arr_struct = bpf_map_lookup_elem(&var_tpid_to_data, &tpid);
 	struct var_kill_data_t* kill_data = bpf_map_lookup_elem(&data_heap, &zero);
 
-	if (arr_struct == NULL || kill_data == NULL)
+	if (!arr_struct || !kill_data)
 		goto out;
 
 	struct task_struct* task = (struct task_struct*)bpf_get_current_task();
@@ -767,7 +767,7 @@ int kprobe_ret__do_filp_open(struct pt_regs* ctx)
 
 	struct file* filp = (struct file*)PT_REGS_RC_CORE(ctx);
 
-	if (filp == NULL || IS_ERR(filp))
+	if (!filp || IS_ERR(filp))
 		goto out;
 	unsigned int flags = BPF_CORE_READ(filp, f_flags);
 	if ((flags & (O_RDWR | O_WRONLY)) == 0)
-- 
1.8.3.1

