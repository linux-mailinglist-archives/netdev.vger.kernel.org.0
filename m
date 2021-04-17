Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A20362D37
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 05:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235640AbhDQDdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 23:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233892AbhDQDdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 23:33:49 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE108C061756;
        Fri, 16 Apr 2021 20:32:28 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id m6-20020a17090a8586b02901507e1acf0fso132789pjn.3;
        Fri, 16 Apr 2021 20:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=k56GHdoWz8WzRp9Nim5HgxmEMJyOzhOyZKSiF5l8YXY=;
        b=M2OiZHLj0rfRm1YElIWiBU/lYov6/wYwqxnlylFg1yK42S6id+UnFn9zqOuqdoSO/L
         j9C52daTBIryqHy8GhVpxiECwfGPGEn7uJ/FRPVzIEesOoGwZrMyLu5lYC1Sj9S9ZpsB
         NDtoXGM742Ihd8lS8RA7pBye8bR8iKhkEPCDH6LlORDLQiIwK4YQp7B6pNP51sJVYUec
         HQ7cl3o3vQyciT6BzXkoFxu56FwTApvzxR5aRA8wezNSTHsBtbP7aXZLCPNJSwglD5iI
         WfeCq6xkeOH6RSKQMVaATh6Sy5/rYKdODhRGm7B+hXynVH3+ZhMgkmokmJpH+pQn6aHi
         q1pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=k56GHdoWz8WzRp9Nim5HgxmEMJyOzhOyZKSiF5l8YXY=;
        b=uOvirXlbsrj4G1xIRs8mqUPkG6wro91vq9pBN+96J09m29eYNYXjTXAI3uZshLBQlb
         A+2jNIl4R3S3MeL/TGyYPgjbC5GmQU10ogL/3UF66uXfoBsoZAFLwyVDJX7qUcqsD2CT
         eMpAoE/RP5mUW63a0aZZ0p8nv2Sx0nSOxs8hWv7gHthnzDE037TSuw+2THkWEd9PE/On
         x5EEqECwIMaaTllpMOOjbXt5w1ItfZcDsEu7KF2PLiGxCqnIxn0NY4EF8tl/YB0tJhi4
         SJOYjeCeXfH908adslcVY79nzTguIFTv6Z8PNuNIhmSt3L1jnAZsFbklMjjdHRRma0gW
         4aKQ==
X-Gm-Message-State: AOAM5308JuutIgYO91qp21MwNG97KJ7rbsGlEgpEDge4Rmh1oZDCoHKu
        IPmSxqN+EtKJo+rbdtuGFAE=
X-Google-Smtp-Source: ABdhPJzNK3cCnUf9CiSkNIj6aZYeXap4YNDn04Md/Mb4dK3FTlUgiLEXScKB3TBFLdUrmFSWzWhlGA==
X-Received: by 2002:a17:903:149:b029:eb:6372:9be0 with SMTP id r9-20020a1709030149b02900eb63729be0mr12612370plc.53.1618630348351;
        Fri, 16 Apr 2021 20:32:28 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id h1sm6069870pgv.88.2021.04.16.20.32.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Apr 2021 20:32:27 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 01/15] bpf: Introduce bpf_sys_bpf() helper and program type.
Date:   Fri, 16 Apr 2021 20:32:10 -0700
Message-Id: <20210417033224.8063-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
References: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Add placeholders for bpf_sys_bpf() helper and new program type.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf.h            | 10 ++++++++
 include/linux/bpf_types.h      |  2 ++
 include/uapi/linux/bpf.h       |  8 ++++++
 kernel/bpf/syscall.c           | 46 ++++++++++++++++++++++++++++++++++
 net/bpf/test_run.c             | 43 +++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  8 ++++++
 6 files changed, 117 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index ff8cd68c01b3..f2e77ac3d5eb 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1823,6 +1823,9 @@ static inline bool bpf_map_is_dev_bound(struct bpf_map *map)
 
 struct bpf_map *bpf_map_offload_map_alloc(union bpf_attr *attr);
 void bpf_map_offload_map_free(struct bpf_map *map);
+int bpf_prog_test_run_syscall(struct bpf_prog *prog,
+			      const union bpf_attr *kattr,
+			      union bpf_attr __user *uattr);
 #else
 static inline int bpf_prog_offload_init(struct bpf_prog *prog,
 					union bpf_attr *attr)
@@ -1848,6 +1851,13 @@ static inline struct bpf_map *bpf_map_offload_map_alloc(union bpf_attr *attr)
 static inline void bpf_map_offload_map_free(struct bpf_map *map)
 {
 }
+
+static inline int bpf_prog_test_run_syscall(struct bpf_prog *prog,
+					    const union bpf_attr *kattr,
+					    union bpf_attr __user *uattr)
+{
+	return -ENOTSUPP;
+}
 #endif /* CONFIG_NET && CONFIG_BPF_SYSCALL */
 
 #if defined(CONFIG_INET) && defined(CONFIG_BPF_SYSCALL)
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index f883f01a5061..a9db1eae6796 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -77,6 +77,8 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_LSM, lsm,
 	       void *, void *)
 #endif /* CONFIG_BPF_LSM */
 #endif
+BPF_PROG_TYPE(BPF_PROG_TYPE_SYSCALL, bpf_syscall,
+	      void *, void *)
 
 BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_ARRAY, percpu_array_map_ops)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index df164a44bb41..ce3e76ff08cd 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -937,6 +937,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_EXT,
 	BPF_PROG_TYPE_LSM,
 	BPF_PROG_TYPE_SK_LOOKUP,
+	BPF_PROG_TYPE_SYSCALL,
 };
 
 enum bpf_attach_type {
@@ -4708,6 +4709,12 @@ union bpf_attr {
  *	Return
  *		The number of traversed map elements for success, **-EINVAL** for
  *		invalid **flags**.
+ *
+ * long bpf_sys_bpf(u32 cmd, void *attr, u32 attr_size)
+ * 	Description
+ * 		Execute bpf syscall with given arguments.
+ * 	Return
+ * 		A syscall result.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -4875,6 +4882,7 @@ union bpf_attr {
 	FN(sock_from_file),		\
 	FN(check_mtu),			\
 	FN(for_each_map_elem),		\
+	FN(sys_bpf),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index fd495190115e..0e4ece4d57e0 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4497,3 +4497,49 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 
 	return err;
 }
+
+static bool syscall_prog_is_valid_access(int off, int size,
+					 enum bpf_access_type type,
+					 const struct bpf_prog *prog,
+					 struct bpf_insn_access_aux *info)
+{
+	if (off < 0 || off >= U16_MAX)
+		return false;
+	if (off % size != 0)
+		return false;
+	return true;
+}
+
+BPF_CALL_3(bpf_sys_bpf, int, cmd, void *, attr, u32, attr_size)
+{
+	return -EINVAL;
+}
+
+const struct bpf_func_proto bpf_sys_bpf_proto = {
+	.func		= bpf_sys_bpf,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_ANYTHING,
+	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg3_type	= ARG_CONST_SIZE,
+};
+
+static const struct bpf_func_proto *
+syscall_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+	switch (func_id) {
+	case BPF_FUNC_sys_bpf:
+		return &bpf_sys_bpf_proto;
+	default:
+		return bpf_base_func_proto(func_id);
+	}
+}
+
+const struct bpf_verifier_ops bpf_syscall_verifier_ops = {
+	.get_func_proto  = syscall_prog_func_proto,
+	.is_valid_access = syscall_prog_is_valid_access,
+};
+
+const struct bpf_prog_ops bpf_syscall_prog_ops = {
+	.test_run = bpf_prog_test_run_syscall,
+};
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index a5d72c48fb66..1783ea77b95c 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -918,3 +918,46 @@ int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog, const union bpf_attr *kat
 	kfree(user_ctx);
 	return ret;
 }
+
+int bpf_prog_test_run_syscall(struct bpf_prog *prog,
+			      const union bpf_attr *kattr,
+			      union bpf_attr __user *uattr)
+{
+	void __user *ctx_in = u64_to_user_ptr(kattr->test.ctx_in);
+	__u32 ctx_size_in = kattr->test.ctx_size_in;
+	void *ctx = NULL;
+	u32 retval;
+	int err = 0;
+
+	/* doesn't support data_in/out, ctx_out, duration, or repeat or flags */
+	if (kattr->test.data_in || kattr->test.data_out ||
+	    kattr->test.ctx_out || kattr->test.duration ||
+	    kattr->test.repeat || kattr->test.flags)
+		return -EINVAL;
+
+	if (ctx_size_in < prog->aux->max_ctx_offset ||
+	    ctx_size_in > U16_MAX)
+		return -EINVAL;
+
+	if (ctx_size_in) {
+		ctx = kzalloc(ctx_size_in, GFP_USER);
+		if (!ctx)
+			return -ENOMEM;
+		if (copy_from_user(ctx, ctx_in, ctx_size_in)) {
+			err = -EFAULT;
+			goto out;
+		}
+	}
+	retval = bpf_prog_run_pin_on_cpu(prog, ctx);
+
+	if (copy_to_user(&uattr->test.retval, &retval, sizeof(u32)))
+		err = -EFAULT;
+	if (ctx_size_in)
+		if (copy_to_user(ctx_in, ctx, ctx_size_in)) {
+			err = -EFAULT;
+			goto out;
+		}
+out:
+	kfree(ctx);
+	return err;
+}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index df164a44bb41..ce3e76ff08cd 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -937,6 +937,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_EXT,
 	BPF_PROG_TYPE_LSM,
 	BPF_PROG_TYPE_SK_LOOKUP,
+	BPF_PROG_TYPE_SYSCALL,
 };
 
 enum bpf_attach_type {
@@ -4708,6 +4709,12 @@ union bpf_attr {
  *	Return
  *		The number of traversed map elements for success, **-EINVAL** for
  *		invalid **flags**.
+ *
+ * long bpf_sys_bpf(u32 cmd, void *attr, u32 attr_size)
+ * 	Description
+ * 		Execute bpf syscall with given arguments.
+ * 	Return
+ * 		A syscall result.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -4875,6 +4882,7 @@ union bpf_attr {
 	FN(sock_from_file),		\
 	FN(check_mtu),			\
 	FN(for_each_map_elem),		\
+	FN(sys_bpf),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.30.2

