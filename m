Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3DA5DFC1
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 10:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbfGCI07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 04:26:59 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8690 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727241AbfGCI06 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 04:26:58 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 02220F79422AA3A77CC8;
        Wed,  3 Jul 2019 16:26:56 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Wed, 3 Jul 2019
 16:26:49 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <sdf@google.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH v2 bpf-next] bpf: cgroup: Fix build error without CONFIG_NET
Date:   Wed, 3 Jul 2019 16:26:30 +0800
Message-ID: <20190703082630.51104-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
In-Reply-To: <fd312c26-db8e-cae3-1c14-869d8e3a62ae@fb.com>
References: <fd312c26-db8e-cae3-1c14-869d8e3a62ae@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_NET is not set and CONFIG_CGROUP_BPF=y,
gcc building fails:

kernel/bpf/cgroup.o: In function `cg_sockopt_func_proto':
cgroup.c:(.text+0x237e): undefined reference to `bpf_sk_storage_get_proto'
cgroup.c:(.text+0x2394): undefined reference to `bpf_sk_storage_delete_proto'
kernel/bpf/cgroup.o: In function `__cgroup_bpf_run_filter_getsockopt':
(.text+0x2a1f): undefined reference to `lock_sock_nested'
(.text+0x2ca2): undefined reference to `release_sock'
kernel/bpf/cgroup.o: In function `__cgroup_bpf_run_filter_setsockopt':
(.text+0x3006): undefined reference to `lock_sock_nested'
(.text+0x32bb): undefined reference to `release_sock'

Reported-by: Hulk Robot <hulkci@huawei.com>
Suggested-by: Stanislav Fomichev <sdf@fomichev.me>
Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
v2: use ifdef macro
---
 kernel/bpf/cgroup.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 76fa007..0a00eac 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -939,6 +939,7 @@ int __cgroup_bpf_run_filter_sysctl(struct ctl_table_header *head,
 }
 EXPORT_SYMBOL(__cgroup_bpf_run_filter_sysctl);
 
+#ifdef CONFIG_NET
 static bool __cgroup_bpf_prog_array_is_empty(struct cgroup *cgrp,
 					     enum bpf_attach_type attach_type)
 {
@@ -1120,6 +1121,7 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 	return ret;
 }
 EXPORT_SYMBOL(__cgroup_bpf_run_filter_getsockopt);
+#endif
 
 static ssize_t sysctl_cpy_dir(const struct ctl_dir *dir, char **bufp,
 			      size_t *lenp)
@@ -1386,10 +1388,12 @@ static const struct bpf_func_proto *
 cg_sockopt_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
 	switch (func_id) {
+#ifdef CONFIG_NET
 	case BPF_FUNC_sk_storage_get:
 		return &bpf_sk_storage_get_proto;
 	case BPF_FUNC_sk_storage_delete:
 		return &bpf_sk_storage_delete_proto;
+#endif
 #ifdef CONFIG_INET
 	case BPF_FUNC_tcp_sock:
 		return &bpf_tcp_sock_proto;
-- 
2.7.4


