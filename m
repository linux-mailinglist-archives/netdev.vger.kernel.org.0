Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D0E40BE27
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 05:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236154AbhIODZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 23:25:18 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:19977 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236078AbhIODZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 23:25:17 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4H8QSR4d1RzbmVT;
        Wed, 15 Sep 2021 11:19:51 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 11:23:51 +0800
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Wed, 15 Sep
 2021 11:23:51 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <houtao1@huawei.com>
Subject: [RFC PATCH bpf-next 1/3] bpf: add dummy BPF STRUCT_OPS for test purpose
Date:   Wed, 15 Sep 2021 11:37:51 +0800
Message-ID: <20210915033753.1201597-2-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210915033753.1201597-1-houtao1@huawei.com>
References: <20210915033753.1201597-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the test of BPF STRUCT_OPS depends on the specific bpf
implementation of tcp_congestion_ops, and it can not cover all
basic functionalities (e.g, return value handling), so introduce
a dummy BPF STRUCT_OPS for test purpose.

Dummy BPF STRUCT_OPS may not being needed for release kernel, so
adding a kconfig option BPF_DUMMY_STRUCT_OPS to enable it separatedly.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 include/linux/bpf_dummy_ops.h     |  28 +++++
 kernel/bpf/Kconfig                |   7 ++
 kernel/bpf/Makefile               |   2 +
 kernel/bpf/bpf_dummy_struct_ops.c | 173 ++++++++++++++++++++++++++++++
 kernel/bpf/bpf_struct_ops_types.h |   4 +
 5 files changed, 214 insertions(+)
 create mode 100644 include/linux/bpf_dummy_ops.h
 create mode 100644 kernel/bpf/bpf_dummy_struct_ops.c

diff --git a/include/linux/bpf_dummy_ops.h b/include/linux/bpf_dummy_ops.h
new file mode 100644
index 000000000000..b2aad3e6e2fe
--- /dev/null
+++ b/include/linux/bpf_dummy_ops.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2021. Huawei Technologies Co., Ltd
+ */
+#ifndef _BPF_DUMMY_OPS_H
+#define _BPF_DUMMY_OPS_H
+
+#ifdef CONFIG_BPF_DUMMY_STRUCT_OPS
+#include <linux/module.h>
+
+struct bpf_dummy_ops_state {
+	int val;
+};
+
+struct bpf_dummy_ops {
+	int (*init)(struct bpf_dummy_ops_state *state);
+	struct module *owner;
+};
+
+extern struct bpf_dummy_ops *bpf_get_dummy_ops(void);
+extern void bpf_put_dummy_ops(struct bpf_dummy_ops *ops);
+#else
+struct bpf_dummy_ops {}；
+static inline struct bpf_dummy_ops *bpf_get_dummy_ops(void) { return NULL; }
+static inline void bpf_put_dummy_ops(struct bpf_dummy_ops *ops) {}
+#endif
+
+#endif
diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
index a82d6de86522..4a11eca42791 100644
--- a/kernel/bpf/Kconfig
+++ b/kernel/bpf/Kconfig
@@ -86,4 +86,11 @@ config BPF_LSM
 
 	  If you are unsure how to answer this question, answer N.
 
+config BPF_DUMMY_STRUCT_OPS
+	bool "Enable dummy struct ops"
+	depends on BPF_SYSCALL && BPF_JIT
+	help
+	  Enables dummy struct ops to test the basic functionalities of
+	  BPF STRUCT_OPS.
+
 endmenu # "BPF subsystem"
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index 7f33098ca63f..17e2bb59cceb 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -33,6 +33,8 @@ obj-$(CONFIG_DEBUG_INFO_BTF) += sysfs_btf.o
 endif
 ifeq ($(CONFIG_BPF_JIT),y)
 obj-$(CONFIG_BPF_SYSCALL) += bpf_struct_ops.o
+obj-$(CONFIG_BPF_SYSCALL) += bpf_dummy_struct_ops.o
 obj-${CONFIG_BPF_LSM} += bpf_lsm.o
 endif
+obj-$(CONFIG_BPF_DUMMY_STRUCT_OPS) += bpf_dummy_struct_ops.o
 obj-$(CONFIG_BPF_PRELOAD) += preload/
diff --git a/kernel/bpf/bpf_dummy_struct_ops.c b/kernel/bpf/bpf_dummy_struct_ops.c
new file mode 100644
index 000000000000..f76c4a3733f0
--- /dev/null
+++ b/kernel/bpf/bpf_dummy_struct_ops.c
@@ -0,0 +1,173 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021. Huawei Technologies Co., Ltd
+ */
+#include <linux/kernel.h>
+#include <linux/spinlock.h>
+#include <linux/bpf_verifier.h>
+#include <linux/bpf.h>
+#include <linux/btf.h>
+#include <linux/bpf_dummy_ops.h>
+
+static struct bpf_dummy_ops *bpf_dummy_ops_singletion;
+static DEFINE_SPINLOCK(bpf_dummy_ops_lock);
+
+static const struct btf_type *dummy_ops_state;
+
+struct bpf_dummy_ops *bpf_get_dummy_ops(void)
+{
+	struct bpf_dummy_ops *ops;
+
+	spin_lock(&bpf_dummy_ops_lock);
+	ops = bpf_dummy_ops_singletion;
+	if (ops && !bpf_try_module_get(ops, ops->owner))
+		ops = NULL;
+	spin_unlock(&bpf_dummy_ops_lock);
+
+	return ops ? ops : ERR_PTR(-ENXIO);
+}
+EXPORT_SYMBOL_GPL(bpf_get_dummy_ops);
+
+void bpf_put_dummy_ops(struct bpf_dummy_ops *ops)
+{
+	bpf_module_put(ops, ops->owner);
+}
+EXPORT_SYMBOL_GPL(bpf_put_dummy_ops);
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
+static const struct bpf_func_proto *
+bpf_dummy_ops_get_func_proto(enum bpf_func_id func_id,
+			     const struct bpf_prog *prog)
+{
+	switch (func_id) {
+	case BPF_FUNC_map_lookup_elem:
+		return &bpf_map_lookup_elem_proto;
+	default:
+		return NULL;
+	}
+}
+
+static bool bpf_dummy_ops_is_valid_access(int off, int size,
+					  enum bpf_access_type type,
+					  const struct bpf_prog *prog,
+					  struct bpf_insn_access_aux *info)
+{
+	/* a common helper ? */
+	if (off < 0 || off >= sizeof(__u64) * MAX_BPF_FUNC_ARGS)
+		return false;
+	if (type != BPF_READ)
+		return false;
+	if (off % size != 0)
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
+static const struct bpf_verifier_ops bpf_dummy_verifier_ops = {
+	.get_func_proto = bpf_dummy_ops_get_func_proto,
+	.is_valid_access = bpf_dummy_ops_is_valid_access,
+	.btf_struct_access = bpf_dummy_ops_btf_struct_access,
+};
+
+static int bpf_dummy_check_member(const struct btf_type *t,
+				  const struct btf_member *member)
+{
+	return 0;
+}
+
+
+static int bpf_dummy_init_member(const struct btf_type *t,
+				 const struct btf_member *member,
+				 void *kdata, const void *udata)
+{
+	return 0;
+}
+
+static int bpf_dummy_reg(void *kdata)
+{
+	struct bpf_dummy_ops *ops = kdata;
+	int err = 0;
+
+	spin_lock(&bpf_dummy_ops_lock);
+	if (!bpf_dummy_ops_singletion)
+		bpf_dummy_ops_singletion = ops;
+	else
+		err = -EEXIST;
+	spin_unlock(&bpf_dummy_ops_lock);
+
+	return err;
+}
+
+static void bpf_dummy_unreg(void *kdata)
+{
+	struct bpf_dummy_ops *ops = kdata;
+
+	spin_lock(&bpf_dummy_ops_lock);
+	if (bpf_dummy_ops_singletion == ops)
+		bpf_dummy_ops_singletion = NULL;
+	else
+		WARN_ON(1);
+	spin_unlock(&bpf_dummy_ops_lock);
+}
+
+extern struct bpf_struct_ops bpf_bpf_dummy_ops;
+
+struct bpf_struct_ops bpf_bpf_dummy_ops = {
+	.verifier_ops = &bpf_dummy_verifier_ops,
+	.init = bpf_dummy_init,
+	.init_member = bpf_dummy_init_member,
+	.check_member = bpf_dummy_check_member,
+	.reg = bpf_dummy_reg,
+	.unreg = bpf_dummy_unreg,
+	.name = "bpf_dummy_ops",
+};
diff --git a/kernel/bpf/bpf_struct_ops_types.h b/kernel/bpf/bpf_struct_ops_types.h
index 7ec458ead497..6d24c75f4d70 100644
--- a/kernel/bpf/bpf_struct_ops_types.h
+++ b/kernel/bpf/bpf_struct_ops_types.h
@@ -2,6 +2,10 @@
 /* internal file - do not include directly */
 
 #ifdef CONFIG_BPF_JIT
+#ifdef CONFIG_BPF_DUMMY_STRUCT_OPS
+#include <linux/bpf_dummy_ops.h>
+BPF_STRUCT_OPS_TYPE(bpf_dummy_ops)
+#endif
 #ifdef CONFIG_INET
 #include <net/tcp.h>
 BPF_STRUCT_OPS_TYPE(tcp_congestion_ops)
-- 
2.29.2

