Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5D443029F
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 14:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240431AbhJPMfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 08:35:21 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:25196 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235124AbhJPMfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 08:35:20 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HWjFF0RZNz8tWZ;
        Sat, 16 Oct 2021 20:32:01 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Sat, 16 Oct 2021 20:33:11 +0800
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Sat, 16 Oct
 2021 20:33:08 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next v2 3/5] bpf: add dummy BPF STRUCT_OPS for test purpose
Date:   Sat, 16 Oct 2021 20:48:04 +0800
Message-ID: <20211016124806.1547989-4-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211016124806.1547989-1-houtao1@huawei.com>
References: <20211016124806.1547989-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the test of BPF STRUCT_OPS depends on the specific bpf
implementation of tcp_congestion_ops, but it can not cover all
basic functionalities (e.g, return value handling), so introduce
a dummy BPF STRUCT_OPS for test purpose.

Loading a bpf_dummy_ops implementation from userspace is prohibited,
and its only purpose is to run BPF_PROG_TYPE_STRUCT_OPS program
through bpf(BPF_PROG_TEST_RUN). Now programs for test_1() & test_2()
are supported. The following three cases are exercised in
bpf_dummy_struct_ops_test_run():

(1) test and check the value returned from state arg in test_1(state)
The content of state is copied from userspace pointer and copied back
after calling test_1(state). The user pointer is saved in an u64 array
and the array address is passed through ctx_in.

(2) test and check the return value of test_1(NULL)
Just simulate the case in which an invalid input argument is passed in.

(3) test multiple arguments passing in test_2(state, ...)
5 arguments are passed through ctx_in in form of u64 array. The first
element of array is userspace pointer of state and others 4 arguments
follow.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 include/linux/bpf.h               |  14 ++
 kernel/bpf/bpf_struct_ops_types.h |   1 +
 net/bpf/Makefile                  |   3 +
 net/bpf/bpf_dummy_struct_ops.c    | 206 ++++++++++++++++++++++++++++++
 4 files changed, 224 insertions(+)
 create mode 100644 net/bpf/bpf_dummy_struct_ops.c

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index b503306da2ab..edcd84077bf1 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1016,6 +1016,20 @@ static inline void bpf_module_put(const void *data, struct module *owner)
 	else
 		module_put(owner);
 }
+
+/* Define it here to avoid the use of forward declaration */
+struct bpf_dummy_ops_state {
+	int val;
+};
+
+struct bpf_dummy_ops {
+	int (*test_1)(struct bpf_dummy_ops_state *cb);
+	int (*test_2)(struct bpf_dummy_ops_state *cb, int a1, unsigned short a2,
+		      char a3, unsigned long a4);
+};
+int bpf_dummy_struct_ops_test_run(struct bpf_prog *prog,
+				  const union bpf_attr *kattr,
+				  union bpf_attr __user *uattr);
 #else
 static inline const struct bpf_struct_ops *bpf_struct_ops_find(u32 type_id)
 {
diff --git a/kernel/bpf/bpf_struct_ops_types.h b/kernel/bpf/bpf_struct_ops_types.h
index 066d83ea1c99..74733ee012e4 100644
--- a/kernel/bpf/bpf_struct_ops_types.h
+++ b/kernel/bpf/bpf_struct_ops_types.h
@@ -2,6 +2,7 @@
 /* internal file - do not include directly */
 
 #ifdef CONFIG_BPF_JIT
+BPF_STRUCT_OPS_TYPE(bpf_dummy_ops)
 #ifdef CONFIG_INET
 #include <net/tcp.h>
 BPF_STRUCT_OPS_TYPE(tcp_congestion_ops)
diff --git a/net/bpf/Makefile b/net/bpf/Makefile
index 1c0a98d8c28f..1ebe270bde23 100644
--- a/net/bpf/Makefile
+++ b/net/bpf/Makefile
@@ -1,2 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_BPF_SYSCALL)	:= test_run.o
+ifeq ($(CONFIG_BPF_JIT),y)
+obj-$(CONFIG_BPF_SYSCALL)	+= bpf_dummy_struct_ops.o
+endif
diff --git a/net/bpf/bpf_dummy_struct_ops.c b/net/bpf/bpf_dummy_struct_ops.c
new file mode 100644
index 000000000000..478d7b656ab3
--- /dev/null
+++ b/net/bpf/bpf_dummy_struct_ops.c
@@ -0,0 +1,206 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021. Huawei Technologies Co., Ltd
+ */
+#include <linux/kernel.h>
+#include <linux/bpf_verifier.h>
+#include <linux/bpf.h>
+#include <linux/btf.h>
+
+extern struct bpf_struct_ops bpf_bpf_dummy_ops;
+
+/* A common type for test_N with return value in bpf_dummy_ops */
+typedef int (*dummy_ops_test_ret_fn)(struct bpf_dummy_ops_state *state, ...);
+
+struct bpf_dummy_ops_test_args {
+	u64 args[MAX_BPF_FUNC_ARGS];
+	struct bpf_dummy_ops_state state;
+};
+
+static const struct btf_type *dummy_ops_state;
+
+static struct bpf_dummy_ops_test_args *
+dummy_ops_init_args(const union bpf_attr *kattr, unsigned int nr)
+{
+	__u32 size_in;
+	struct bpf_dummy_ops_test_args *args;
+	void __user *ctx_in;
+	void __user *u_state;
+
+	if (!nr || nr > MAX_BPF_FUNC_ARGS)
+		return ERR_PTR(-EINVAL);
+
+	size_in = kattr->test.ctx_size_in;
+	if (size_in != sizeof(u64) * nr)
+		return ERR_PTR(-EINVAL);
+
+	args = kzalloc(sizeof(*args), GFP_KERNEL);
+	if (!args)
+		return ERR_PTR(-ENOMEM);
+
+	ctx_in = u64_to_user_ptr(kattr->test.ctx_in);
+	if (copy_from_user(args->args, ctx_in, size_in))
+		return ERR_PTR(-EFAULT);
+
+	u_state = u64_to_user_ptr(args->args[0]);
+	if (!u_state)
+		return args;
+
+	if (copy_from_user(&args->state, u_state, sizeof(args->state))) {
+		kfree(args);
+		return ERR_PTR(-EFAULT);
+	}
+
+	return args;
+}
+
+static int dummy_ops_copy_args(struct bpf_dummy_ops_test_args *args)
+{
+	void __user *u_state;
+
+	u_state = u64_to_user_ptr(args->args[0]);
+	if (!u_state)
+		return 0;
+
+	if (copy_to_user(u_state, &args->state, sizeof(args->state)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int dummy_ops_call_op(void *image, struct bpf_dummy_ops_test_args *args)
+{
+	dummy_ops_test_ret_fn test = (void *)image;
+	struct bpf_dummy_ops_state *state = NULL;
+
+	/* state needs to be NULL if args[0] is 0 */
+	if (args->args[0])
+		state = &args->state;
+	return test(state, args->args[1], args->args[2],
+		    args->args[3], args->args[4]);
+}
+
+int bpf_dummy_struct_ops_test_run(struct bpf_prog *prog,
+				  const union bpf_attr *kattr,
+				  union bpf_attr __user *uattr)
+{
+	const struct bpf_struct_ops *st_ops = &bpf_bpf_dummy_ops;
+	const struct btf_type *func_proto = prog->aux->attach_func_proto;
+	struct bpf_dummy_ops_test_args *args = NULL;
+	struct bpf_tramp_progs *tprogs = NULL;
+	void *image = NULL;
+	unsigned int op_idx;
+	int err;
+	int prog_ret;
+
+	args = dummy_ops_init_args(kattr, btf_type_vlen(func_proto));
+	if (IS_ERR(args))
+		return PTR_ERR(args);
+
+	tprogs = kcalloc(BPF_TRAMP_MAX, sizeof(*tprogs), GFP_KERNEL);
+	if (!tprogs) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	image = bpf_jit_alloc_exec(PAGE_SIZE);
+	if (!image) {
+		err = -ENOMEM;
+		goto out;
+	}
+	set_vm_flush_reset_perms(image);
+
+	op_idx = prog->expected_attach_type;
+	err = bpf_struct_ops_prepare_trampoline(tprogs, prog,
+						&st_ops->func_models[op_idx],
+						image, image + PAGE_SIZE);
+	if (err < 0)
+		goto out;
+
+	set_memory_ro((long)image, 1);
+	set_memory_x((long)image, 1);
+	prog_ret = dummy_ops_call_op(image, args);
+
+	err = dummy_ops_copy_args(args);
+	if (err)
+		goto out;
+	if (put_user(prog_ret, &uattr->test.retval))
+		err = -EFAULT;
+out:
+	kfree(args);
+	bpf_jit_free_exec(image);
+	kfree(tprogs);
+	return err;
+}
+
+static int bpf_dummy_init(struct btf *btf)
+{
+	s32 type_id;
+
+	type_id = btf_find_by_name_kind(btf, "bpf_dummy_ops_state",
+					BTF_KIND_STRUCT);
+	if (type_id < 0)
+		return -EINVAL;
+
+	dummy_ops_state = btf_type_by_id(btf, type_id);
+
+	return 0;
+}
+
+static bool bpf_dummy_ops_is_valid_access(int off, int size,
+					  enum bpf_access_type type,
+					  const struct bpf_prog *prog,
+					  struct bpf_insn_access_aux *info)
+{
+	return bpf_check_btf_func_ctx_access(off, size, type, prog, info);
+}
+
+static int bpf_dummy_ops_btf_struct_access(struct bpf_verifier_log *log,
+					   const struct btf *btf,
+					   const struct btf_type *t, int off,
+					   int size, enum bpf_access_type atype,
+					   u32 *next_btf_id)
+{
+	int err;
+
+	if (atype != BPF_READ && t != dummy_ops_state) {
+		bpf_log(log, "only write to bpf_dummy_ops_state is supported\n");
+		return -EACCES;
+	}
+
+	err = btf_struct_access(log, btf, t, off, size, atype, next_btf_id);
+	if (err < 0)
+		return err;
+
+	return atype == BPF_READ ? err : NOT_INIT;
+}
+
+static const struct bpf_verifier_ops bpf_dummy_verifier_ops = {
+	.is_valid_access = bpf_dummy_ops_is_valid_access,
+	.btf_struct_access = bpf_dummy_ops_btf_struct_access,
+};
+
+static int bpf_dummy_init_member(const struct btf_type *t,
+				 const struct btf_member *member,
+				 void *kdata, const void *udata)
+{
+	return -EOPNOTSUPP;
+}
+
+static int bpf_dummy_reg(void *kdata)
+{
+	return -EOPNOTSUPP;
+}
+
+static void bpf_dummy_unreg(void *kdata)
+{
+}
+
+struct bpf_struct_ops bpf_bpf_dummy_ops = {
+	.verifier_ops = &bpf_dummy_verifier_ops,
+	.init = bpf_dummy_init,
+	.init_member = bpf_dummy_init_member,
+	.reg = bpf_dummy_reg,
+	.unreg = bpf_dummy_unreg,
+	.name = "bpf_dummy_ops",
+};
-- 
2.29.2

