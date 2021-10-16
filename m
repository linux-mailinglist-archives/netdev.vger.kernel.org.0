Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECB04302A2
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 14:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240434AbhJPMfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 08:35:21 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:25197 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240423AbhJPMfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 08:35:20 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HWjFF1Jhwz8tZY;
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
Subject: [PATCH bpf-next v2 4/5] bpf: hook .test_run for struct_ops program
Date:   Sat, 16 Oct 2021 20:48:05 +0800
Message-ID: <20211016124806.1547989-5-houtao1@huawei.com>
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

bpf_struct_ops_test_run() will be used to run struct_ops program
from bpf_dummy_ops and now its main purpose is to test the handling
of return value and multiple arguments.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 kernel/bpf/bpf_struct_ops.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 44be101f2562..ceedc9f0f786 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -11,6 +11,9 @@
 #include <linux/refcount.h>
 #include <linux/mutex.h>
 
+static int bpf_struct_ops_test_run(struct bpf_prog *prog,
+				   const union bpf_attr *kattr,
+				   union bpf_attr __user *uattr);
 enum bpf_struct_ops_state {
 	BPF_STRUCT_OPS_STATE_INIT,
 	BPF_STRUCT_OPS_STATE_INUSE,
@@ -93,6 +96,7 @@ const struct bpf_verifier_ops bpf_struct_ops_verifier_ops = {
 };
 
 const struct bpf_prog_ops bpf_struct_ops_prog_ops = {
+	.test_run = bpf_struct_ops_test_run,
 };
 
 static const struct btf_type *module_type;
@@ -667,3 +671,16 @@ void bpf_struct_ops_put(const void *kdata)
 		call_rcu(&st_map->rcu, bpf_struct_ops_put_rcu);
 	}
 }
+
+static int bpf_struct_ops_test_run(struct bpf_prog *prog,
+				   const union bpf_attr *kattr,
+				   union bpf_attr __user *uattr)
+{
+	const struct bpf_struct_ops *st_ops;
+
+	st_ops = bpf_struct_ops_find(prog->aux->attach_btf_id);
+	if (st_ops != &bpf_bpf_dummy_ops)
+		return -EOPNOTSUPP;
+
+	return bpf_dummy_struct_ops_test_run(prog, kattr, uattr);
+}
-- 
2.29.2

