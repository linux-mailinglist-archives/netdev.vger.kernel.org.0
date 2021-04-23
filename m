Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EECB3689C3
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 02:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239992AbhDWA1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 20:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235569AbhDWA12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 20:27:28 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D20C061574;
        Thu, 22 Apr 2021 17:26:53 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id h20so24395848plr.4;
        Thu, 22 Apr 2021 17:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5WWPU+mTdVIgJ456hHtLJiF8mbUGPkZrgWKbDCAkeaM=;
        b=A9rZj6nk6GuEbpstF+7wer8rIem30Cy2Kl//1zPp/ypDdpqCtqVMsY6JoFMa5lmoOJ
         YTAt8uF4LuNWm1mGd6dK2XojYRJ4s+SM3S6xaK3fhjzJT96HlF2klr/N1FGH+A7BxCNe
         EWTsmfMTi26lepVYYkT55B5CIgsFE7gws3LZ/flOtg1UN0GxGRhkrQuIPMkPNKMKX0WS
         fVMFletZMonGMR7VK6TYVG01eXBJDH0D4VQbh3yDPbX1vTrcKko3Pw9uHhMMENBexHQ+
         JnbF8lxObrwtkTsO7eMvKOi7bVDm4wS+N7tq5B5Mitt5i852E/n7LByRlhc675dhZ6bH
         Tv5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5WWPU+mTdVIgJ456hHtLJiF8mbUGPkZrgWKbDCAkeaM=;
        b=H/E0ud6QlNL1OTjAb0dJsUX8Bk8RHh3taHlqgDMNEqMP99mzXfOumxE1vw1fks53Lx
         jg2rKrlXj+SQMwzT59KjbV+1ZxocLJah+1Sk+PAZy7VdSNs3RTaMoxyMiv6F0EczbMU5
         B4fN9e0dVvo6C7HFPwxpb2sPaNmATwV0Po+dfYLJ5O8CuyIhMNFA+wQAf6XAo6idUyAf
         7PTyZSQ7oNXZS3MxfDmUdvPOognLuK/xeNl3qeLEJEeR0l8334nXtX4jaHVAHk6s/nQk
         UWw0DrURpnX7Kehj2Lc9pj6hiREoV1c+mLBvd9hjWb8vzRCusZMYCx8p13W6mwFnc3Tv
         09JA==
X-Gm-Message-State: AOAM531iIslwOV53mG87llO2Sfa6X6rAY5J8wRmMGnTIF79qmaFuk6Md
        11oDIcCIHW17MGtTZBrYhiA=
X-Google-Smtp-Source: ABdhPJwN8YS0aQFBRoWZM9o3oztIubAEpppyxnD1+ClC2vqKibfSffpFdnF5Rv7zho9XvCrY0LAe2w==
X-Received: by 2002:a17:902:788b:b029:ec:c151:b5e with SMTP id q11-20020a170902788bb02900ecc1510b5emr1121314pll.75.1619137612769;
        Thu, 22 Apr 2021 17:26:52 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id u12sm6390987pji.45.2021.04.22.17.26.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Apr 2021 17:26:52 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 bpf-next 03/16] bpf: Prepare bpf syscall to be used from kernel and user space.
Date:   Thu, 22 Apr 2021 17:26:33 -0700
Message-Id: <20210423002646.35043-4-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

With the help from bpfptr_t prepare relevant bpf syscall commands
to be used from kernel and user space.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf.h   |   8 +--
 kernel/bpf/bpf_iter.c |  13 ++---
 kernel/bpf/syscall.c  | 113 +++++++++++++++++++++++++++---------------
 kernel/bpf/verifier.c |  34 +++++++------
 net/bpf/test_run.c    |   2 +-
 5 files changed, 104 insertions(+), 66 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index aed30bbffb54..0f841bd0cb85 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -22,6 +22,7 @@
 #include <linux/sched/mm.h>
 #include <linux/slab.h>
 #include <linux/percpu-refcount.h>
+#include <linux/bpfptr.h>
 
 struct bpf_verifier_env;
 struct bpf_verifier_log;
@@ -1426,7 +1427,7 @@ struct bpf_iter__bpf_map_elem {
 int bpf_iter_reg_target(const struct bpf_iter_reg *reg_info);
 void bpf_iter_unreg_target(const struct bpf_iter_reg *reg_info);
 bool bpf_iter_prog_supported(struct bpf_prog *prog);
-int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog);
+int bpf_iter_link_attach(const union bpf_attr *attr, bpfptr_t uattr, struct bpf_prog *prog);
 int bpf_iter_new_fd(struct bpf_link *link);
 bool bpf_link_is_iter(struct bpf_link *link);
 struct bpf_prog *bpf_iter_get_info(struct bpf_iter_meta *meta, bool in_stop);
@@ -1457,7 +1458,7 @@ int bpf_fd_htab_map_update_elem(struct bpf_map *map, struct file *map_file,
 int bpf_fd_htab_map_lookup_elem(struct bpf_map *map, void *key, u32 *value);
 
 int bpf_get_file_flag(int flags);
-int bpf_check_uarg_tail_zero(void __user *uaddr, size_t expected_size,
+int bpf_check_uarg_tail_zero(bpfptr_t uaddr, size_t expected_size,
 			     size_t actual_size);
 
 /* memcpy that is used with 8-byte aligned pointers, power-of-8 size and
@@ -1477,8 +1478,7 @@ static inline void bpf_long_memcpy(void *dst, const void *src, u32 size)
 }
 
 /* verify correctness of eBPF program */
-int bpf_check(struct bpf_prog **fp, union bpf_attr *attr,
-	      union bpf_attr __user *uattr);
+int bpf_check(struct bpf_prog **fp, union bpf_attr *attr, bpfptr_t uattr);
 
 #ifndef CONFIG_BPF_JIT_ALWAYS_ON
 void bpf_patch_call_args(struct bpf_insn *insn, u32 stack_depth);
diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 931870f9cf56..2d4fbdbb194e 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -473,15 +473,16 @@ bool bpf_link_is_iter(struct bpf_link *link)
 	return link->ops == &bpf_iter_link_lops;
 }
 
-int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
+int bpf_iter_link_attach(const union bpf_attr *attr, bpfptr_t uattr,
+			 struct bpf_prog *prog)
 {
-	union bpf_iter_link_info __user *ulinfo;
 	struct bpf_link_primer link_primer;
 	struct bpf_iter_target_info *tinfo;
 	union bpf_iter_link_info linfo;
 	struct bpf_iter_link *link;
 	u32 prog_btf_id, linfo_len;
 	bool existed = false;
+	bpfptr_t ulinfo;
 	int err;
 
 	if (attr->link_create.target_fd || attr->link_create.flags)
@@ -489,18 +490,18 @@ int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 
 	memset(&linfo, 0, sizeof(union bpf_iter_link_info));
 
-	ulinfo = u64_to_user_ptr(attr->link_create.iter_info);
+	ulinfo = make_bpfptr(attr->link_create.iter_info, uattr.is_kernel);
 	linfo_len = attr->link_create.iter_info_len;
-	if (!ulinfo ^ !linfo_len)
+	if (bpfptr_is_null(ulinfo) ^ !linfo_len)
 		return -EINVAL;
 
-	if (ulinfo) {
+	if (!bpfptr_is_null(ulinfo)) {
 		err = bpf_check_uarg_tail_zero(ulinfo, sizeof(linfo),
 					       linfo_len);
 		if (err)
 			return err;
 		linfo_len = min_t(u32, linfo_len, sizeof(linfo));
-		if (copy_from_user(&linfo, ulinfo, linfo_len))
+		if (copy_from_bpfptr(&linfo, ulinfo, linfo_len))
 			return -EFAULT;
 	}
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 8636876f3e6b..2e9bc04fd821 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -72,11 +72,10 @@ static const struct bpf_map_ops * const bpf_map_types[] = {
  * copy_from_user() call. However, this is not a concern since this function is
  * meant to be a future-proofing of bits.
  */
-int bpf_check_uarg_tail_zero(void __user *uaddr,
+int bpf_check_uarg_tail_zero(bpfptr_t uaddr,
 			     size_t expected_size,
 			     size_t actual_size)
 {
-	unsigned char __user *addr = uaddr + expected_size;
 	int res;
 
 	if (unlikely(actual_size > PAGE_SIZE))	/* silly large */
@@ -85,7 +84,12 @@ int bpf_check_uarg_tail_zero(void __user *uaddr,
 	if (actual_size <= expected_size)
 		return 0;
 
-	res = check_zeroed_user(addr, actual_size - expected_size);
+	if (uaddr.is_kernel)
+		res = memchr_inv(uaddr.kernel + expected_size, 0,
+				 actual_size - expected_size) == NULL;
+	else
+		res = check_zeroed_user(uaddr.user + expected_size,
+					actual_size - expected_size);
 	if (res < 0)
 		return res;
 	return res ? 0 : -E2BIG;
@@ -1004,6 +1008,17 @@ static void *__bpf_copy_key(void __user *ukey, u64 key_size)
 	return NULL;
 }
 
+static void *___bpf_copy_key(bpfptr_t ukey, u64 key_size)
+{
+	if (key_size)
+		return memdup_bpfptr(ukey, key_size);
+
+	if (!bpfptr_is_null(ukey))
+		return ERR_PTR(-EINVAL);
+
+	return NULL;
+}
+
 /* last field in 'union bpf_attr' used by this command */
 #define BPF_MAP_LOOKUP_ELEM_LAST_FIELD flags
 
@@ -1074,10 +1089,10 @@ static int map_lookup_elem(union bpf_attr *attr)
 
 #define BPF_MAP_UPDATE_ELEM_LAST_FIELD flags
 
-static int map_update_elem(union bpf_attr *attr)
+static int map_update_elem(union bpf_attr *attr, bpfptr_t uattr)
 {
-	void __user *ukey = u64_to_user_ptr(attr->key);
-	void __user *uvalue = u64_to_user_ptr(attr->value);
+	bpfptr_t ukey = make_bpfptr(attr->key, uattr.is_kernel);
+	bpfptr_t uvalue = make_bpfptr(attr->value, uattr.is_kernel);
 	int ufd = attr->map_fd;
 	struct bpf_map *map;
 	void *key, *value;
@@ -1103,7 +1118,7 @@ static int map_update_elem(union bpf_attr *attr)
 		goto err_put;
 	}
 
-	key = __bpf_copy_key(ukey, map->key_size);
+	key = ___bpf_copy_key(ukey, map->key_size);
 	if (IS_ERR(key)) {
 		err = PTR_ERR(key);
 		goto err_put;
@@ -1123,7 +1138,7 @@ static int map_update_elem(union bpf_attr *attr)
 		goto free_key;
 
 	err = -EFAULT;
-	if (copy_from_user(value, uvalue, value_size) != 0)
+	if (copy_from_bpfptr(value, uvalue, value_size) != 0)
 		goto free_value;
 
 	err = bpf_map_update_value(map, f, key, value, attr->flags);
@@ -2076,7 +2091,7 @@ static bool is_perfmon_prog_type(enum bpf_prog_type prog_type)
 /* last field in 'union bpf_attr' used by this command */
 #define	BPF_PROG_LOAD_LAST_FIELD attach_prog_fd
 
-static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
+static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 {
 	enum bpf_prog_type type = attr->prog_type;
 	struct bpf_prog *prog, *dst_prog = NULL;
@@ -2101,8 +2116,9 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 		return -EPERM;
 
 	/* copy eBPF program license from user space */
-	if (strncpy_from_user(license, u64_to_user_ptr(attr->license),
-			      sizeof(license) - 1) < 0)
+	if (strncpy_from_bpfptr(license,
+				make_bpfptr(attr->license, uattr.is_kernel),
+				sizeof(license) - 1) < 0)
 		return -EFAULT;
 	license[sizeof(license) - 1] = 0;
 
@@ -2186,8 +2202,9 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 	prog->len = attr->insn_cnt;
 
 	err = -EFAULT;
-	if (copy_from_user(prog->insns, u64_to_user_ptr(attr->insns),
-			   bpf_prog_insn_size(prog)) != 0)
+	if (copy_from_bpfptr(prog->insns,
+			     make_bpfptr(attr->insns, uattr.is_kernel),
+			     bpf_prog_insn_size(prog)) != 0)
 		goto free_prog_sec;
 
 	prog->orig_prog = NULL;
@@ -3412,7 +3429,7 @@ static int bpf_prog_get_info_by_fd(struct file *file,
 	u32 ulen;
 	int err;
 
-	err = bpf_check_uarg_tail_zero(uinfo, sizeof(info), info_len);
+	err = bpf_check_uarg_tail_zero(USER_BPFPTR(uinfo), sizeof(info), info_len);
 	if (err)
 		return err;
 	info_len = min_t(u32, sizeof(info), info_len);
@@ -3691,7 +3708,7 @@ static int bpf_map_get_info_by_fd(struct file *file,
 	u32 info_len = attr->info.info_len;
 	int err;
 
-	err = bpf_check_uarg_tail_zero(uinfo, sizeof(info), info_len);
+	err = bpf_check_uarg_tail_zero(USER_BPFPTR(uinfo), sizeof(info), info_len);
 	if (err)
 		return err;
 	info_len = min_t(u32, sizeof(info), info_len);
@@ -3734,7 +3751,7 @@ static int bpf_btf_get_info_by_fd(struct file *file,
 	u32 info_len = attr->info.info_len;
 	int err;
 
-	err = bpf_check_uarg_tail_zero(uinfo, sizeof(*uinfo), info_len);
+	err = bpf_check_uarg_tail_zero(USER_BPFPTR(uinfo), sizeof(*uinfo), info_len);
 	if (err)
 		return err;
 
@@ -3751,7 +3768,7 @@ static int bpf_link_get_info_by_fd(struct file *file,
 	u32 info_len = attr->info.info_len;
 	int err;
 
-	err = bpf_check_uarg_tail_zero(uinfo, sizeof(info), info_len);
+	err = bpf_check_uarg_tail_zero(USER_BPFPTR(uinfo), sizeof(info), info_len);
 	if (err)
 		return err;
 	info_len = min_t(u32, sizeof(info), info_len);
@@ -4012,13 +4029,14 @@ static int bpf_map_do_batch(const union bpf_attr *attr,
 	return err;
 }
 
-static int tracing_bpf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
+static int tracing_bpf_link_attach(const union bpf_attr *attr, bpfptr_t uattr,
+				   struct bpf_prog *prog)
 {
 	if (attr->link_create.attach_type != prog->expected_attach_type)
 		return -EINVAL;
 
 	if (prog->expected_attach_type == BPF_TRACE_ITER)
-		return bpf_iter_link_attach(attr, prog);
+		return bpf_iter_link_attach(attr, uattr, prog);
 	else if (prog->type == BPF_PROG_TYPE_EXT)
 		return bpf_tracing_prog_attach(prog,
 					       attr->link_create.target_fd,
@@ -4027,7 +4045,7 @@ static int tracing_bpf_link_attach(const union bpf_attr *attr, struct bpf_prog *
 }
 
 #define BPF_LINK_CREATE_LAST_FIELD link_create.iter_info_len
-static int link_create(union bpf_attr *attr)
+static int link_create(union bpf_attr *attr, bpfptr_t uattr)
 {
 	enum bpf_prog_type ptype;
 	struct bpf_prog *prog;
@@ -4046,7 +4064,7 @@ static int link_create(union bpf_attr *attr)
 		goto out;
 
 	if (prog->type == BPF_PROG_TYPE_EXT) {
-		ret = tracing_bpf_link_attach(attr, prog);
+		ret = tracing_bpf_link_attach(attr, uattr, prog);
 		goto out;
 	}
 
@@ -4067,7 +4085,7 @@ static int link_create(union bpf_attr *attr)
 		ret = cgroup_bpf_link_attach(attr, prog);
 		break;
 	case BPF_PROG_TYPE_TRACING:
-		ret = tracing_bpf_link_attach(attr, prog);
+		ret = tracing_bpf_link_attach(attr, uattr, prog);
 		break;
 	case BPF_PROG_TYPE_FLOW_DISSECTOR:
 	case BPF_PROG_TYPE_SK_LOOKUP:
@@ -4355,7 +4373,7 @@ static int bpf_prog_bind_map(union bpf_attr *attr)
 	return ret;
 }
 
-SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, size)
+static int __sys_bpf(int cmd, bpfptr_t uattr, unsigned int size)
 {
 	union bpf_attr attr;
 	int err;
@@ -4370,7 +4388,7 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 
 	/* copy attributes from user space, may be less than sizeof(bpf_attr) */
 	memset(&attr, 0, sizeof(attr));
-	if (copy_from_user(&attr, uattr, size) != 0)
+	if (copy_from_bpfptr(&attr, uattr, size) != 0)
 		return -EFAULT;
 
 	err = security_bpf(cmd, &attr, size);
@@ -4385,7 +4403,7 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 		err = map_lookup_elem(&attr);
 		break;
 	case BPF_MAP_UPDATE_ELEM:
-		err = map_update_elem(&attr);
+		err = map_update_elem(&attr, uattr);
 		break;
 	case BPF_MAP_DELETE_ELEM:
 		err = map_delete_elem(&attr);
@@ -4412,21 +4430,21 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 		err = bpf_prog_detach(&attr);
 		break;
 	case BPF_PROG_QUERY:
-		err = bpf_prog_query(&attr, uattr);
+		err = bpf_prog_query(&attr, uattr.user);
 		break;
 	case BPF_PROG_TEST_RUN:
-		err = bpf_prog_test_run(&attr, uattr);
+		err = bpf_prog_test_run(&attr, uattr.user);
 		break;
 	case BPF_PROG_GET_NEXT_ID:
-		err = bpf_obj_get_next_id(&attr, uattr,
+		err = bpf_obj_get_next_id(&attr, uattr.user,
 					  &prog_idr, &prog_idr_lock);
 		break;
 	case BPF_MAP_GET_NEXT_ID:
-		err = bpf_obj_get_next_id(&attr, uattr,
+		err = bpf_obj_get_next_id(&attr, uattr.user,
 					  &map_idr, &map_idr_lock);
 		break;
 	case BPF_BTF_GET_NEXT_ID:
-		err = bpf_obj_get_next_id(&attr, uattr,
+		err = bpf_obj_get_next_id(&attr, uattr.user,
 					  &btf_idr, &btf_idr_lock);
 		break;
 	case BPF_PROG_GET_FD_BY_ID:
@@ -4436,7 +4454,7 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 		err = bpf_map_get_fd_by_id(&attr);
 		break;
 	case BPF_OBJ_GET_INFO_BY_FD:
-		err = bpf_obj_get_info_by_fd(&attr, uattr);
+		err = bpf_obj_get_info_by_fd(&attr, uattr.user);
 		break;
 	case BPF_RAW_TRACEPOINT_OPEN:
 		err = bpf_raw_tracepoint_open(&attr);
@@ -4448,26 +4466,26 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 		err = bpf_btf_get_fd_by_id(&attr);
 		break;
 	case BPF_TASK_FD_QUERY:
-		err = bpf_task_fd_query(&attr, uattr);
+		err = bpf_task_fd_query(&attr, uattr.user);
 		break;
 	case BPF_MAP_LOOKUP_AND_DELETE_ELEM:
 		err = map_lookup_and_delete_elem(&attr);
 		break;
 	case BPF_MAP_LOOKUP_BATCH:
-		err = bpf_map_do_batch(&attr, uattr, BPF_MAP_LOOKUP_BATCH);
+		err = bpf_map_do_batch(&attr, uattr.user, BPF_MAP_LOOKUP_BATCH);
 		break;
 	case BPF_MAP_LOOKUP_AND_DELETE_BATCH:
-		err = bpf_map_do_batch(&attr, uattr,
+		err = bpf_map_do_batch(&attr, uattr.user,
 				       BPF_MAP_LOOKUP_AND_DELETE_BATCH);
 		break;
 	case BPF_MAP_UPDATE_BATCH:
-		err = bpf_map_do_batch(&attr, uattr, BPF_MAP_UPDATE_BATCH);
+		err = bpf_map_do_batch(&attr, uattr.user, BPF_MAP_UPDATE_BATCH);
 		break;
 	case BPF_MAP_DELETE_BATCH:
-		err = bpf_map_do_batch(&attr, uattr, BPF_MAP_DELETE_BATCH);
+		err = bpf_map_do_batch(&attr, uattr.user, BPF_MAP_DELETE_BATCH);
 		break;
 	case BPF_LINK_CREATE:
-		err = link_create(&attr);
+		err = link_create(&attr, uattr);
 		break;
 	case BPF_LINK_UPDATE:
 		err = link_update(&attr);
@@ -4476,7 +4494,7 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 		err = bpf_link_get_fd_by_id(&attr);
 		break;
 	case BPF_LINK_GET_NEXT_ID:
-		err = bpf_obj_get_next_id(&attr, uattr,
+		err = bpf_obj_get_next_id(&attr, uattr.user,
 					  &link_idr, &link_idr_lock);
 		break;
 	case BPF_ENABLE_STATS:
@@ -4499,6 +4517,11 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 	return err;
 }
 
+SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, size)
+{
+	return __sys_bpf(cmd, USER_BPFPTR(uattr), size);
+}
+
 static bool syscall_prog_is_valid_access(int off, int size,
 					 enum bpf_access_type type,
 					 const struct bpf_prog *prog,
@@ -4513,7 +4536,19 @@ static bool syscall_prog_is_valid_access(int off, int size,
 
 BPF_CALL_3(bpf_sys_bpf, int, cmd, void *, attr, u32, attr_size)
 {
-	return -EINVAL;
+	switch (cmd) {
+	case BPF_MAP_CREATE:
+	case BPF_MAP_UPDATE_ELEM:
+	case BPF_MAP_FREEZE:
+	case BPF_PROG_LOAD:
+		break;
+	/* case BPF_PROG_TEST_RUN:
+	 * is not part of this list to prevent recursive test_run
+	 */
+	default:
+		return -EINVAL;
+	}
+	return __sys_bpf(cmd, KERNEL_BPFPTR(attr), attr_size);
 }
 
 const struct bpf_func_proto bpf_sys_bpf_proto = {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 58730872f7e5..76a18fb1e792 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9351,7 +9351,7 @@ static int check_abnormal_return(struct bpf_verifier_env *env)
 
 static int check_btf_func(struct bpf_verifier_env *env,
 			  const union bpf_attr *attr,
-			  union bpf_attr __user *uattr)
+			  bpfptr_t uattr)
 {
 	const struct btf_type *type, *func_proto, *ret_type;
 	u32 i, nfuncs, urec_size, min_size;
@@ -9360,7 +9360,7 @@ static int check_btf_func(struct bpf_verifier_env *env,
 	struct bpf_func_info_aux *info_aux = NULL;
 	struct bpf_prog *prog;
 	const struct btf *btf;
-	void __user *urecord;
+	bpfptr_t urecord;
 	u32 prev_offset = 0;
 	bool scalar_return;
 	int ret = -ENOMEM;
@@ -9388,7 +9388,7 @@ static int check_btf_func(struct bpf_verifier_env *env,
 	prog = env->prog;
 	btf = prog->aux->btf;
 
-	urecord = u64_to_user_ptr(attr->func_info);
+	urecord = make_bpfptr(attr->func_info, uattr.is_kernel);
 	min_size = min_t(u32, krec_size, urec_size);
 
 	krecord = kvcalloc(nfuncs, krec_size, GFP_KERNEL | __GFP_NOWARN);
@@ -9406,13 +9406,15 @@ static int check_btf_func(struct bpf_verifier_env *env,
 				/* set the size kernel expects so loader can zero
 				 * out the rest of the record.
 				 */
-				if (put_user(min_size, &uattr->func_info_rec_size))
+				if (copy_to_bpfptr_offset(uattr,
+							  offsetof(union bpf_attr, func_info_rec_size),
+							  &min_size, sizeof(min_size)))
 					ret = -EFAULT;
 			}
 			goto err_free;
 		}
 
-		if (copy_from_user(&krecord[i], urecord, min_size)) {
+		if (copy_from_bpfptr(&krecord[i], urecord, min_size)) {
 			ret = -EFAULT;
 			goto err_free;
 		}
@@ -9464,7 +9466,7 @@ static int check_btf_func(struct bpf_verifier_env *env,
 		}
 
 		prev_offset = krecord[i].insn_off;
-		urecord += urec_size;
+		bpfptr_add(&urecord, urec_size);
 	}
 
 	prog->aux->func_info = krecord;
@@ -9496,14 +9498,14 @@ static void adjust_btf_func(struct bpf_verifier_env *env)
 
 static int check_btf_line(struct bpf_verifier_env *env,
 			  const union bpf_attr *attr,
-			  union bpf_attr __user *uattr)
+			  bpfptr_t uattr)
 {
 	u32 i, s, nr_linfo, ncopy, expected_size, rec_size, prev_offset = 0;
 	struct bpf_subprog_info *sub;
 	struct bpf_line_info *linfo;
 	struct bpf_prog *prog;
 	const struct btf *btf;
-	void __user *ulinfo;
+	bpfptr_t ulinfo;
 	int err;
 
 	nr_linfo = attr->line_info_cnt;
@@ -9529,7 +9531,7 @@ static int check_btf_line(struct bpf_verifier_env *env,
 
 	s = 0;
 	sub = env->subprog_info;
-	ulinfo = u64_to_user_ptr(attr->line_info);
+	ulinfo = make_bpfptr(attr->line_info, uattr.is_kernel);
 	expected_size = sizeof(struct bpf_line_info);
 	ncopy = min_t(u32, expected_size, rec_size);
 	for (i = 0; i < nr_linfo; i++) {
@@ -9537,14 +9539,15 @@ static int check_btf_line(struct bpf_verifier_env *env,
 		if (err) {
 			if (err == -E2BIG) {
 				verbose(env, "nonzero tailing record in line_info");
-				if (put_user(expected_size,
-					     &uattr->line_info_rec_size))
+				if (copy_to_bpfptr_offset(uattr,
+							  offsetof(union bpf_attr, line_info_rec_size),
+							  &expected_size, sizeof(expected_size)))
 					err = -EFAULT;
 			}
 			goto err_free;
 		}
 
-		if (copy_from_user(&linfo[i], ulinfo, ncopy)) {
+		if (copy_from_bpfptr(&linfo[i], ulinfo, ncopy)) {
 			err = -EFAULT;
 			goto err_free;
 		}
@@ -9596,7 +9599,7 @@ static int check_btf_line(struct bpf_verifier_env *env,
 		}
 
 		prev_offset = linfo[i].insn_off;
-		ulinfo += rec_size;
+		bpfptr_add(&ulinfo, rec_size);
 	}
 
 	if (s != env->subprog_cnt) {
@@ -9618,7 +9621,7 @@ static int check_btf_line(struct bpf_verifier_env *env,
 
 static int check_btf_info(struct bpf_verifier_env *env,
 			  const union bpf_attr *attr,
-			  union bpf_attr __user *uattr)
+			  bpfptr_t uattr)
 {
 	struct btf *btf;
 	int err;
@@ -13192,8 +13195,7 @@ struct btf *bpf_get_btf_vmlinux(void)
 	return btf_vmlinux;
 }
 
-int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
-	      union bpf_attr __user *uattr)
+int bpf_check(struct bpf_prog **prog, union bpf_attr *attr, bpfptr_t uattr)
 {
 	u64 start_time = ktime_get_ns();
 	struct bpf_verifier_env *env;
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 1783ea77b95c..85f41fb8d5bf 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -409,7 +409,7 @@ static void *bpf_ctx_init(const union bpf_attr *kattr, u32 max_size)
 		return ERR_PTR(-ENOMEM);
 
 	if (data_in) {
-		err = bpf_check_uarg_tail_zero(data_in, max_size, size);
+		err = bpf_check_uarg_tail_zero(USER_BPFPTR(data_in), max_size, size);
 		if (err) {
 			kfree(data);
 			return ERR_PTR(err);
-- 
2.30.2

