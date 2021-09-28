Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB8C41A59E
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 04:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238751AbhI1CkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 22:40:14 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:22254 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238723AbhI1CkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 22:40:12 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HJNvn0Xgsz8tV4;
        Tue, 28 Sep 2021 10:37:41 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 28 Sep 2021 10:38:31 +0800
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Tue, 28 Sep
 2021 10:38:31 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next 3/5] bpf: do .test_run in dummy BPF STRUCT_OPS
Date:   Tue, 28 Sep 2021 10:52:26 +0800
Message-ID: <20210928025228.88673-4-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210928025228.88673-1-houtao1@huawei.com>
References: <20210928025228.88673-1-houtao1@huawei.com>
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

Now only program for bpf_dummy_ops::init() is supported. The following
two cases are exercised in bpf_dummy_st_ops_test_run():

(1) test and check the value returned from state arg in init(state)
The content of state is copied from data_in before calling init() and
copied back to data_out after calling, so test program could use
data_in to pass the input state and use data_out to get the
output state.

(2) test and check the return value of init(NULL)
data_in_size is set as 0, so the state will be NULL and there will be
no copy-in & copy-out.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 include/linux/bpf_dummy_ops.h  |  13 ++-
 net/bpf/bpf_dummy_struct_ops.c | 176 +++++++++++++++++++++++++++++++++
 2 files changed, 188 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf_dummy_ops.h b/include/linux/bpf_dummy_ops.h
index a594ae830eba..5049484e6693 100644
--- a/include/linux/bpf_dummy_ops.h
+++ b/include/linux/bpf_dummy_ops.h
@@ -5,10 +5,21 @@
 #ifndef _BPF_DUMMY_OPS_H
 #define _BPF_DUMMY_OPS_H
 
-typedef int (*bpf_dummy_ops_init_t)(void);
+#include <linux/bpf.h>
+#include <linux/filter.h>
+
+struct bpf_dummy_ops_state {
+	int val;
+};
+
+typedef int (*bpf_dummy_ops_init_t)(struct bpf_dummy_ops_state *cb);
 
 struct bpf_dummy_ops {
 	bpf_dummy_ops_init_t init;
 };
 
+extern int bpf_dummy_st_ops_test_run(struct bpf_prog *prog,
+				     const union bpf_attr *kattr,
+				     union bpf_attr __user *uattr);
+
 #endif
diff --git a/net/bpf/bpf_dummy_struct_ops.c b/net/bpf/bpf_dummy_struct_ops.c
index 1249e4bb4ccb..da77736cd093 100644
--- a/net/bpf/bpf_dummy_struct_ops.c
+++ b/net/bpf/bpf_dummy_struct_ops.c
@@ -10,12 +10,188 @@
 
 extern struct bpf_struct_ops bpf_bpf_dummy_ops;
 
+static const struct btf_type *dummy_ops_state;
+
+static struct bpf_dummy_ops_state *
+init_dummy_ops_state(const union bpf_attr *kattr)
+{
+	__u32 size_in;
+	struct bpf_dummy_ops_state *state;
+	void __user *data_in;
+
+	size_in = kattr->test.data_size_in;
+	if (!size_in)
+		return NULL;
+
+	if (size_in != sizeof(*state))
+		return ERR_PTR(-EINVAL);
+
+	state = kzalloc(sizeof(*state), GFP_KERNEL);
+	if (!state)
+		return ERR_PTR(-ENOMEM);
+
+	data_in = u64_to_user_ptr(kattr->test.data_in);
+	if (copy_from_user(state, data_in, size_in)) {
+		kfree(state);
+		return ERR_PTR(-EFAULT);
+	}
+
+	return state;
+}
+
+static int copy_dummy_ops_state(struct bpf_dummy_ops_state *state,
+				const union bpf_attr *kattr,
+				union bpf_attr __user *uattr)
+{
+	int err = 0;
+	void __user *data_out;
+
+	if (!state)
+		return 0;
+
+	data_out = u64_to_user_ptr(kattr->test.data_out);
+	if (copy_to_user(data_out, state, sizeof(*state))) {
+		err = -EFAULT;
+		goto out;
+	}
+	if (put_user(sizeof(*state), &uattr->test.data_size_out)) {
+		err = -EFAULT;
+		goto out;
+	}
+out:
+	return err;
+}
+
+static inline void exit_dummy_ops_state(struct bpf_dummy_ops_state *state)
+{
+	kfree(state);
+}
+
+int bpf_dummy_st_ops_test_run(struct bpf_prog *prog,
+			      const union bpf_attr *kattr,
+			      union bpf_attr __user *uattr)
+{
+	const struct bpf_struct_ops *st_ops = &bpf_bpf_dummy_ops;
+	struct bpf_dummy_ops_state *state = NULL;
+	struct bpf_tramp_progs *tprogs = NULL;
+	void *image = NULL;
+	int err;
+	int prog_ret;
+
+	/* Now only support to call init(...) */
+	if (prog->expected_attach_type != 0) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	/* state will be NULL when data_size_in == 0 */
+	state = init_dummy_ops_state(kattr);
+	if (IS_ERR(state)) {
+		err = PTR_ERR(state);
+		state = NULL;
+		goto out;
+	}
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
+	err = bpf_prepare_st_ops_prog(tprogs, prog, &st_ops->func_models[0],
+				      image, image + PAGE_SIZE);
+	if (err < 0)
+		goto out;
+
+	set_memory_ro((long)image, 1);
+	set_memory_x((long)image, 1);
+	prog_ret = ((bpf_dummy_ops_init_t)image)(state);
+
+	err = copy_dummy_ops_state(state, kattr, uattr);
+	if (err)
+		goto out;
+	if (put_user(prog_ret, &uattr->test.retval))
+		err = -EFAULT;
+out:
+	exit_dummy_ops_state(state);
+	bpf_jit_free_exec(image);
+	kfree(tprogs);
+	return err;
+}
+
 static int bpf_dummy_init(struct btf *btf)
 {
+	s32 type_id;
+
+	type_id = btf_find_by_name_kind(btf, "bpf_dummy_ops_state",
+					BTF_KIND_STRUCT);
+	if (type_id < 0)
+		return -EINVAL;
+
+	dummy_ops_state = btf_type_by_id(btf, type_id);
+
 	return 0;
 }
 
+static bool bpf_dummy_ops_is_valid_access(int off, int size,
+					  enum bpf_access_type type,
+					  const struct bpf_prog *prog,
+					  struct bpf_insn_access_aux *info)
+{
+	/* init(state) only has one argument */
+	if (off || type != BPF_READ)
+		return false;
+
+	return btf_ctx_access(off, size, type, prog, info);
+}
+
+static int bpf_dummy_ops_btf_struct_access(struct bpf_verifier_log *log,
+					   const struct btf *btf,
+					   const struct btf_type *t, int off,
+					   int size, enum bpf_access_type atype,
+					   u32 *next_btf_id)
+{
+	size_t end;
+
+	if (atype == BPF_READ)
+		return btf_struct_access(log, btf, t, off, size, atype,
+					 next_btf_id);
+
+	if (t != dummy_ops_state) {
+		bpf_log(log, "only read is supported\n");
+		return -EACCES;
+	}
+
+	switch (off) {
+	case offsetof(struct bpf_dummy_ops_state, val):
+		end = offsetofend(struct bpf_dummy_ops_state, val);
+		break;
+	default:
+		bpf_log(log, "no write support to bpf_dummy_ops_state at off %d\n",
+			off);
+		return -EACCES;
+	}
+
+	if (off + size > end) {
+		bpf_log(log,
+			"write access at off %d with size %d beyond the member of bpf_dummy_ops_state ended at %zu\n",
+			off, size, end);
+		return -EACCES;
+	}
+
+	return NOT_INIT;
+}
+
 static const struct bpf_verifier_ops bpf_dummy_verifier_ops = {
+	.is_valid_access = bpf_dummy_ops_is_valid_access,
+	.btf_struct_access = bpf_dummy_ops_btf_struct_access,
 };
 
 static int bpf_dummy_init_member(const struct btf_type *t,
-- 
2.29.2

