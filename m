Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 712073689C0
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 02:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239969AbhDWA12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 20:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235569AbhDWA11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 20:27:27 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DBF9C061574;
        Thu, 22 Apr 2021 17:26:50 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id e9so7411789plj.2;
        Thu, 22 Apr 2021 17:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Qz3N8e3CiMwxMuXV9RfUOV3WPHa8dXx7N42Tvs9AYCM=;
        b=ZGCMTPI5NngwL3vtSB389chFgAAuwTFuixS/8X6JRCDR8COs1cpgZajIzT1/E+pQ48
         DuUAUCkJ/15cDJPOl9rK4DbdStwkBbZlvkkeI33bXeY4yh0KMRBuCtv3V0bMmqIMmzZS
         72B1GBRT8bV4JmJl8AFUwIoN1E4JxErPdWJETzC7zQUvDvuSAm2AGIbQSwm1ktSbTsuj
         7aqXZh8msV5t+QkPpYsdnpQbgSpaIJoUxgOC2rCM2tanF3lPwA1Fp8lX9WNm2cO70yWT
         4SyKUu2zA75c5WF+OoTqQRAOxXHdBw1P9tAisj+tX9IFSk4BTc2ow0Pcd5QTMXJgprsF
         /rAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Qz3N8e3CiMwxMuXV9RfUOV3WPHa8dXx7N42Tvs9AYCM=;
        b=mR9ngi0YrNSZV6gNV53rF6pSma/oCCd/vilryQxuUxc0nvQmUzEPrWOb9zjBQCLOnp
         dxVGVgs5IbZxyelWEhIAi0prOR9QJV/EpgrkZCQQaJ/vSPGQst4qb84Lh32S9B28sSJB
         qxQKdi7EKzRBX74DG2u14knbqfOHAZ3gcUR2rGD/byb751eV2RPEyB8+PNNT9V8sdl4e
         jISxhRTEOl2NSOfUmNQRUK9zxuC0vn0UBEqopuSFc+d/VKDE7103xLBCx2GIxjvAtBqq
         rAjl0z6R+F56yqWvmqEnxEa+D0rcpPvH9F3HyTh2m6LKvNLmesdxQkId+JIblkVo9JCd
         emLQ==
X-Gm-Message-State: AOAM5326e1mUtce4/bIKdUmMyo2aRhHN2/eFMC4DhXXa4XCKIvJFTnVI
        ErhsVQda08O6XX1gX6SFVs4=
X-Google-Smtp-Source: ABdhPJzTQgz/B231aD/BqA+Lk1sz8neRPqe+sm+iu6pZ6V4dGTb4w6XBVauIvVdkJeajJZJ9lpwPmA==
X-Received: by 2002:a17:90a:4410:: with SMTP id s16mr1384028pjg.203.1619137610008;
        Thu, 22 Apr 2021 17:26:50 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id u12sm6390987pji.45.2021.04.22.17.26.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Apr 2021 17:26:49 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 bpf-next 01/16] bpf: Introduce bpf_sys_bpf() helper and program type.
Date:   Thu, 22 Apr 2021 17:26:31 -0700
Message-Id: <20210423002646.35043-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Add placeholders for bpf_sys_bpf() helper and new program type.

v1->v2:
- check that expected_attach_type is zero
- allow more helper functions to be used in this program type, since they will
  only execute from user context via bpf_prog_test_run.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf.h            | 10 +++++++
 include/linux/bpf_types.h      |  2 ++
 include/uapi/linux/bpf.h       |  8 +++++
 kernel/bpf/syscall.c           | 54 ++++++++++++++++++++++++++++++++++
 net/bpf/test_run.c             | 43 +++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  8 +++++
 6 files changed, 125 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f8a45f109e96..aed30bbffb54 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1824,6 +1824,9 @@ static inline bool bpf_map_is_dev_bound(struct bpf_map *map)
 
 struct bpf_map *bpf_map_offload_map_alloc(union bpf_attr *attr);
 void bpf_map_offload_map_free(struct bpf_map *map);
+int bpf_prog_test_run_syscall(struct bpf_prog *prog,
+			      const union bpf_attr *kattr,
+			      union bpf_attr __user *uattr);
 #else
 static inline int bpf_prog_offload_init(struct bpf_prog *prog,
 					union bpf_attr *attr)
@@ -1849,6 +1852,13 @@ static inline struct bpf_map *bpf_map_offload_map_alloc(union bpf_attr *attr)
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
index ec6d85a81744..c92648f38144 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -937,6 +937,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_EXT,
 	BPF_PROG_TYPE_LSM,
 	BPF_PROG_TYPE_SK_LOOKUP,
+	BPF_PROG_TYPE_SYSCALL, /* a program that can execute syscalls */
 };
 
 enum bpf_attach_type {
@@ -4735,6 +4736,12 @@ union bpf_attr {
  *		be zero-terminated except when **str_size** is 0.
  *
  *		Or **-EBUSY** if the per-CPU memory copy buffer is busy.
+ *
+ * long bpf_sys_bpf(u32 cmd, void *attr, u32 attr_size)
+ * 	Description
+ * 		Execute bpf syscall with given arguments.
+ * 	Return
+ * 		A syscall result.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -4903,6 +4910,7 @@ union bpf_attr {
 	FN(check_mtu),			\
 	FN(for_each_map_elem),		\
 	FN(snprintf),			\
+	FN(sys_bpf),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index fd495190115e..8636876f3e6b 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2014,6 +2014,7 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
 		if (expected_attach_type == BPF_SK_LOOKUP)
 			return 0;
 		return -EINVAL;
+	case BPF_PROG_TYPE_SYSCALL:
 	case BPF_PROG_TYPE_EXT:
 		if (expected_attach_type)
 			return -EINVAL;
@@ -4497,3 +4498,56 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 
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
+const struct bpf_func_proto * __weak
+tracing_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+
+	return bpf_base_func_proto(func_id);
+}
+
+static const struct bpf_func_proto *
+syscall_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+	switch (func_id) {
+	case BPF_FUNC_sys_bpf:
+		return &bpf_sys_bpf_proto;
+	default:
+		return tracing_prog_func_proto(func_id, prog);
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
index ec6d85a81744..0c13016d3d2c 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -937,6 +937,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_EXT,
 	BPF_PROG_TYPE_LSM,
 	BPF_PROG_TYPE_SK_LOOKUP,
+	BPF_PROG_TYPE_SYSCALL,
 };
 
 enum bpf_attach_type {
@@ -4735,6 +4736,12 @@ union bpf_attr {
  *		be zero-terminated except when **str_size** is 0.
  *
  *		Or **-EBUSY** if the per-CPU memory copy buffer is busy.
+ *
+ * long bpf_sys_bpf(u32 cmd, void *attr, u32 attr_size)
+ * 	Description
+ * 		Execute bpf syscall with given arguments.
+ * 	Return
+ * 		A syscall result.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -4903,6 +4910,7 @@ union bpf_attr {
 	FN(check_mtu),			\
 	FN(for_each_map_elem),		\
 	FN(snprintf),			\
+	FN(sys_bpf),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.30.2

