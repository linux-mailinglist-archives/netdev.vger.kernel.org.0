Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D14B94D8513
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 13:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237523AbiCNMe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 08:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245231AbiCNMcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 08:32:50 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A556457B09;
        Mon, 14 Mar 2022 05:26:56 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KHG2v2DTKzfYqR;
        Mon, 14 Mar 2022 20:25:27 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 14 Mar 2022 20:26:52 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <ast@kernel.org>, <john.fastabend@gmail.com>,
        <daniel@iogearbox.net>, <jakub@cloudflare.com>,
        <lmb@cloudflare.com>, <davem@davemloft.net>, <kafai@fb.com>,
        <dsahern@kernel.org>, <kuba@kernel.org>, <songliubraving@fb.com>,
        <yhs@fb.com>, <kpsingh@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Wang Yufen <wangyufen@huawei.com>
Subject: [PATCH bpf-next] bpf, sockmap: Manual deletion of sockmap elements in user mode is not allowed
Date:   Mon, 14 Mar 2022 20:44:32 +0800
Message-ID: <20220314124432.3050394-1-wangyufen@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A tcp socket in a sockmap. If user invokes bpf_map_delete_elem to delete
the sockmap element, the tcp socket will switch to use the TCP protocol
stack to send and receive packets. The switching process may cause some
issues, such as if some msgs exist in the ingress queue and are cleared
by sk_psock_drop(), the packets are lost, and the tcp data is abnormal.

Signed-off-by: Wang Yufen <wangyufen@huawei.com>
---
 include/uapi/linux/bpf.h | 3 +++
 kernel/bpf/syscall.c     | 2 ++
 net/core/sock_map.c      | 3 +++
 3 files changed, 8 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4eebea830613..1dab090f271c 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1218,6 +1218,9 @@ enum {
 
 /* Create a map that is suitable to be an inner map with dynamic max entries */
 	BPF_F_INNER_MAP		= (1U << 12),
+
+/* This should only be used for bpf_map_delete_elem called by user. */
+	BPF_F_TCP_SOCKMAP	= (1U << 13),
 };
 
 /* Flags for BPF_PROG_QUERY. */
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index db402ebc5570..57aa98087322 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1232,7 +1232,9 @@ static int map_delete_elem(union bpf_attr *attr)
 
 	bpf_disable_instrumentation();
 	rcu_read_lock();
+	map->map_flags |= BPF_F_TCP_SOCKMAP;
 	err = map->ops->map_delete_elem(map, key);
+	map->map_flags &= ~BPF_F_TCP_SOCKMAP;
 	rcu_read_unlock();
 	bpf_enable_instrumentation();
 	maybe_wait_bpf_programs(map);
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 2d213c4011db..5b90a35d1d23 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -914,6 +914,9 @@ static int sock_hash_delete_elem(struct bpf_map *map, void *key)
 	struct bpf_shtab_elem *elem;
 	int ret = -ENOENT;
 
+	if (map->map_flags & BPF_F_TCP_SOCKMAP)
+		return -EOPNOTSUPP;
+
 	hash = sock_hash_bucket_hash(key, key_size);
 	bucket = sock_hash_select_bucket(htab, hash);
 
-- 
2.25.1

