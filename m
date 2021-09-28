Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F98941A59D
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 04:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238739AbhI1CkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 22:40:12 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:22253 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238594AbhI1CkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 22:40:11 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HJNvm0qJbz8tRN;
        Tue, 28 Sep 2021 10:37:40 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 28 Sep 2021 10:38:30 +0800
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Tue, 28 Sep
 2021 10:38:30 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next 1/5] bpf: add dummy BPF STRUCT_OPS for test purpose
Date:   Tue, 28 Sep 2021 10:52:24 +0800
Message-ID: <20210928025228.88673-2-houtao1@huawei.com>
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

Currently the test of BPF STRUCT_OPS depends on the specific bpf
implementation of tcp_congestion_ops, but it can not cover all
basic functionalities (e.g, return value handling), so introduce
a dummy BPF STRUCT_OPS for test purpose.

Loading a bpf_dummy_ops implementation from userspace is prohibited,
and its only purpose is to run BPF_PROG_TYPE_STRUCT_OPS program
through bpf(BPF_PROG_TEST_RUN).

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 include/linux/bpf_dummy_ops.h     | 14 ++++++++++
 kernel/bpf/bpf_struct_ops_types.h |  2 ++
 net/bpf/Makefile                  |  3 +++
 net/bpf/bpf_dummy_struct_ops.c    | 44 +++++++++++++++++++++++++++++++
 4 files changed, 63 insertions(+)
 create mode 100644 include/linux/bpf_dummy_ops.h
 create mode 100644 net/bpf/bpf_dummy_struct_ops.c

diff --git a/include/linux/bpf_dummy_ops.h b/include/linux/bpf_dummy_ops.h
new file mode 100644
index 000000000000..a594ae830eba
--- /dev/null
+++ b/include/linux/bpf_dummy_ops.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2021. Huawei Technologies Co., Ltd
+ */
+#ifndef _BPF_DUMMY_OPS_H
+#define _BPF_DUMMY_OPS_H
+
+typedef int (*bpf_dummy_ops_init_t)(void);
+
+struct bpf_dummy_ops {
+	bpf_dummy_ops_init_t init;
+};
+
+#endif
diff --git a/kernel/bpf/bpf_struct_ops_types.h b/kernel/bpf/bpf_struct_ops_types.h
index 066d83ea1c99..02c86cf9c207 100644
--- a/kernel/bpf/bpf_struct_ops_types.h
+++ b/kernel/bpf/bpf_struct_ops_types.h
@@ -2,6 +2,8 @@
 /* internal file - do not include directly */
 
 #ifdef CONFIG_BPF_JIT
+#include <linux/bpf_dummy_ops.h>
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
index 000000000000..1249e4bb4ccb
--- /dev/null
+++ b/net/bpf/bpf_dummy_struct_ops.c
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021. Huawei Technologies Co., Ltd
+ */
+#include <linux/kernel.h>
+#include <linux/bpf_verifier.h>
+#include <linux/bpf.h>
+#include <linux/btf.h>
+#include <linux/bpf_dummy_ops.h>
+
+extern struct bpf_struct_ops bpf_bpf_dummy_ops;
+
+static int bpf_dummy_init(struct btf *btf)
+{
+	return 0;
+}
+
+static const struct bpf_verifier_ops bpf_dummy_verifier_ops = {
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

