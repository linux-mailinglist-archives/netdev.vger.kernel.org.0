Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2C547A8AC
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 12:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbhLTL3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 06:29:55 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:28335 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbhLTL3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 06:29:54 -0500
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JHcn70QlvzbjSv;
        Mon, 20 Dec 2021 19:29:31 +0800 (CST)
Received: from ubuntu1804.huawei.com (10.67.174.58) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 20 Dec 2021 19:29:52 +0800
From:   Xiu Jianfeng <xiujianfeng@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH bpf-next] bpf: Use struct_size() helper
Date:   Mon, 20 Dec 2021 19:30:48 +0800
Message-ID: <20211220113048.2859-1-xiujianfeng@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.174.58]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In an effort to avoid open-coded arithmetic in the kernel, use the
struct_size() helper instead of open-coded calculation.

Link: https://github.com/KSPP/linux/issues/160
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
---
 kernel/bpf/local_storage.c   | 3 +--
 kernel/bpf/reuseport_array.c | 6 +-----
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index 035e9e3a7132..23f7f9d08a62 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -163,8 +163,7 @@ static int cgroup_storage_update_elem(struct bpf_map *map, void *key,
 		return 0;
 	}
 
-	new = bpf_map_kmalloc_node(map, sizeof(struct bpf_storage_buffer) +
-				   map->value_size,
+	new = bpf_map_kmalloc_node(map, struct_size(new, data, map->value_size),
 				   __GFP_ZERO | GFP_ATOMIC | __GFP_NOWARN,
 				   map->numa_node);
 	if (!new)
diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
index 93a55391791a..556a769b5b80 100644
--- a/kernel/bpf/reuseport_array.c
+++ b/kernel/bpf/reuseport_array.c
@@ -152,16 +152,12 @@ static struct bpf_map *reuseport_array_alloc(union bpf_attr *attr)
 {
 	int numa_node = bpf_map_attr_numa_node(attr);
 	struct reuseport_array *array;
-	u64 array_size;
 
 	if (!bpf_capable())
 		return ERR_PTR(-EPERM);
 
-	array_size = sizeof(*array);
-	array_size += (u64)attr->max_entries * sizeof(struct sock *);
-
 	/* allocate all map elements and zero-initialize them */
-	array = bpf_map_area_alloc(array_size, numa_node);
+	array = bpf_map_area_alloc(struct_size(array, ptrs, attr->max_entries), numa_node);
 	if (!array)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.17.1

