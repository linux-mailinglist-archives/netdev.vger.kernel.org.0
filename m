Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72103258250
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 22:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729086AbgHaUQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 16:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbgHaUQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 16:16:54 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85684C061573;
        Mon, 31 Aug 2020 13:16:54 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id 2so453209pjx.5;
        Mon, 31 Aug 2020 13:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2z4HpOUlB6WzgytIiLCNVNzsMPhzbkwXcOU3/HqLSb8=;
        b=J3pmVSN5nellGe9k1MK5b4SNKV/QgZ08HihrZzMA/gYRttaeeL6SY1lq8HC+UGMsxh
         wOfSzh8IslEjLvhOAGVQai+pd3hU56f6Zq1ve8cXBbmSOZfApxaPK02x+SVznt8ZTdwl
         bRsM2lue55v+vtZX73zqNgLzmkcGzpN/Ioy5CSOIgX/QS0vWMWAZb5+PEa14LlcBkYvm
         rtCgbexF+KV3OHVhBx8V3KCFEVAEliUiM9xp93CVP0yZ1jqbgseJ+qthMFSQUWIyM9k2
         vSySbtuLxmQDcvVkmG6YJmt4911KCf2bvJUjX+nXu5lwfcu2QoOupM9FOyo2XP/oVlXo
         aT6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2z4HpOUlB6WzgytIiLCNVNzsMPhzbkwXcOU3/HqLSb8=;
        b=QV72/E0UK3AjKld7/Pw0Usj/U1FbXtMCVfZTgXTCdCGwVXO1Z+OCq8VoaI6h1urxxu
         ysYSEzBU0oqZv/aUw2QE02YyMIuytktKoeH1gVU0MlpL2tx8VFSG5BzXA/tpkf6+aslg
         GxdsMW02f17GIX72ixM13078SMfPnN59Kvsc0FDJzx7HF6/B6KSrM6hrQWmoVG1x9e7X
         TbxbvGwRKsKk6ELk+N8H7V3fTzdVRaBzpV1KXTKn20pLu3LwvrwvRzRFy5sP3bhrLCS2
         3On1SUZC2ZkardLNzXfOPEyU4AKnzdXOuGvsraErc+Fq/zGCluM6r/eMYE35UimimuOQ
         jTWw==
X-Gm-Message-State: AOAM531DrZibzEpl4oV0HNrRVq46y6dCUBjZfpYci3OLJEBux04+4hOd
        MUhkClqfZeNaIGBZg1Gc3FBfA68CXE8=
X-Google-Smtp-Source: ABdhPJz0TTOJK8Kvhm85Y2r1kSovTZWZ73jZ7dsDa/UD8o51RQwF+9MvzRXli1OIC4mSKpMnBf0XFQ==
X-Received: by 2002:a17:90b:14d5:: with SMTP id jz21mr917158pjb.229.1598905013939;
        Mon, 31 Aug 2020 13:16:53 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id w66sm9418724pfb.126.2020.08.31.13.16.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 31 Aug 2020 13:16:53 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next] bpf: Remove bpf_lsm_file_mprotect from sleepable list.
Date:   Mon, 31 Aug 2020 13:16:51 -0700
Message-Id: <20200831201651.82447-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Technically the bpf programs can sleep while attached to bpf_lsm_file_mprotect,
but such programs need to access user memory. So they're in might_fault()
category. Which means they cannot be called from file_mprotect lsm hook that
takes write lock on mm->mmap_lock.
Adjust the test accordingly.

Also add might_fault() to __bpf_prog_enter_sleepable() to catch such deadlocks early.

Reported-by: Yonghong Song <yhs@fb.com>
Fixes: 1e6c62a88215 ("bpf: Introduce sleepable BPF programs")
Fixes: e68a144547fc ("selftests/bpf: Add sleepable tests")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/trampoline.c                 |  1 +
 kernel/bpf/verifier.c                   |  1 -
 tools/testing/selftests/bpf/progs/lsm.c | 34 ++++++++++++-------------
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index c2b76545153c..7dd523a7e32d 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -409,6 +409,7 @@ void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start)
 void notrace __bpf_prog_enter_sleepable(void)
 {
 	rcu_read_lock_trace();
+	might_fault();
 }
 
 void notrace __bpf_prog_exit_sleepable(void)
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b4c22b5ce5a2..b4e9c56b8b32 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11006,7 +11006,6 @@ static int check_attach_modify_return(struct bpf_prog *prog, unsigned long addr)
 /* non exhaustive list of sleepable bpf_lsm_*() functions */
 BTF_SET_START(btf_sleepable_lsm_hooks)
 #ifdef CONFIG_BPF_LSM
-BTF_ID(func, bpf_lsm_file_mprotect)
 BTF_ID(func, bpf_lsm_bprm_committed_creds)
 #else
 BTF_ID_UNUSED
diff --git a/tools/testing/selftests/bpf/progs/lsm.c b/tools/testing/selftests/bpf/progs/lsm.c
index 49fa6ca99755..ff4d343b94b5 100644
--- a/tools/testing/selftests/bpf/progs/lsm.c
+++ b/tools/testing/selftests/bpf/progs/lsm.c
@@ -36,14 +36,10 @@ int monitored_pid = 0;
 int mprotect_count = 0;
 int bprm_count = 0;
 
-SEC("lsm.s/file_mprotect")
+SEC("lsm/file_mprotect")
 int BPF_PROG(test_int_hook, struct vm_area_struct *vma,
 	     unsigned long reqprot, unsigned long prot, int ret)
 {
-	char args[64];
-	__u32 key = 0;
-	__u64 *value;
-
 	if (ret != 0)
 		return ret;
 
@@ -53,18 +49,6 @@ int BPF_PROG(test_int_hook, struct vm_area_struct *vma,
 	is_stack = (vma->vm_start <= vma->vm_mm->start_stack &&
 		    vma->vm_end >= vma->vm_mm->start_stack);
 
-	bpf_copy_from_user(args, sizeof(args), (void *)vma->vm_mm->arg_start);
-
-	value = bpf_map_lookup_elem(&array, &key);
-	if (value)
-		*value = 0;
-	value = bpf_map_lookup_elem(&hash, &key);
-	if (value)
-		*value = 0;
-	value = bpf_map_lookup_elem(&lru_hash, &key);
-	if (value)
-		*value = 0;
-
 	if (is_stack && monitored_pid == pid) {
 		mprotect_count++;
 		ret = -EPERM;
@@ -77,10 +61,26 @@ SEC("lsm.s/bprm_committed_creds")
 int BPF_PROG(test_void_hook, struct linux_binprm *bprm)
 {
 	__u32 pid = bpf_get_current_pid_tgid() >> 32;
+	char args[64];
+	__u32 key = 0;
+	__u64 *value;
 
 	if (monitored_pid == pid)
 		bprm_count++;
 
+	bpf_copy_from_user(args, sizeof(args), (void *)bprm->vma->vm_mm->arg_start);
+	bpf_copy_from_user(args, sizeof(args), (void *)bprm->mm->arg_start);
+
+	value = bpf_map_lookup_elem(&array, &key);
+	if (value)
+		*value = 0;
+	value = bpf_map_lookup_elem(&hash, &key);
+	if (value)
+		*value = 0;
+	value = bpf_map_lookup_elem(&lru_hash, &key);
+	if (value)
+		*value = 0;
+
 	return 0;
 }
 SEC("lsm/task_free") /* lsm/ is ok, lsm.s/ fails */
-- 
2.23.0

