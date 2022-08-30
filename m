Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 814AC5A6384
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 14:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiH3MiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 08:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiH3Mhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 08:37:53 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD896E9271
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 05:37:40 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MH6Ct5CQWzYcmm;
        Tue, 30 Aug 2022 20:33:14 +0800 (CST)
Received: from dggpemm500011.china.huawei.com (7.185.36.110) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 30 Aug 2022 20:37:37 +0800
Received: from localhost.localdomain (10.137.16.177) by
 dggpemm500011.china.huawei.com (7.185.36.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 30 Aug 2022 20:37:37 +0800
From:   Zhen Chen <chenzhen126@huawei.com>
To:     <edumazet@google.com>, <davem@davemloft.net>,
        <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>,
        <netdev@vger.kernel.org>
CC:     <yanan@huawei.com>, <caowangbao@huawei.com>
Subject: [PATCH] tcp: use linear buffer for small frames
Date:   Tue, 30 Aug 2022 20:33:45 +0800
Message-ID: <20220830123345.1909199-1-chenzhen126@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.137.16.177]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500011.china.huawei.com (7.185.36.110)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

472c2e07eef0 ("tcp: add one skb cache for tx") and related patches added a
machanism to relax slab layer in tcp stack, by caching one skb per socket.
The feature is disabled by default and the patch also dropped linear payload
for small frames, which caused about 5% of performance regression for small
packets because nic drivers would bother to deal with fraglist than before.

As d8b81175e412 ("tcp: remove sk_{tr}x_skb_cache") reverted the whole
machanism but skipped the linear part, just make the revert complete.

Signed-off-by: Zhen Chen <chenzhen126@huawei.com>
---
 net/ipv4/tcp.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e5011c136fdb..0b6010051598 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1154,6 +1154,30 @@ int tcp_sendpage(struct sock *sk, struct page *page, int offset,
 }
 EXPORT_SYMBOL(tcp_sendpage);
 
+/* Do not bother using a page frag for very small frames.
+ * But use this heuristic only for the first skb in write queue.
+ *
+ * Having no payload in skb->head allows better SACK shifting
+ * in tcp_shift_skb_data(), reducing sack/rack overhead, because
+ * write queue has less skbs.
+ * Each skb can hold up to MAX_SKB_FRAGS * 32Kbytes, or ~0.5 MB.
+ * This also speeds up tso_fragment(), since it wont fallback
+ * to tcp_fragment().
+ */
+static int linear_payload_sz(bool first_skb)
+{
+	if (first_skb)
+		return SKB_WITH_OVERHEAD(2048 - MAX_TCP_HEADER);
+	return 0;
+}
+
+static int select_size(bool first_skb, bool zc)
+{
+	if (zc)
+		return 0;
+	return linear_payload_sz(first_skb);
+}
+
 void tcp_free_fastopen_req(struct tcp_sock *tp)
 {
 	if (tp->fastopen_req) {
@@ -1311,6 +1335,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 
 		if (copy <= 0 || !tcp_skb_can_collapse_to(skb)) {
 			bool first_skb;
+			int linear;
 
 new_segment:
 			if (!sk_stream_memory_free(sk))
@@ -1322,7 +1347,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 					goto restart;
 			}
 			first_skb = tcp_rtx_and_write_queues_empty(sk);
-			skb = tcp_stream_alloc_skb(sk, 0, sk->sk_allocation,
+			linear = select_size(first_skb, zc);
+			skb = tcp_stream_alloc_skb(sk, linear, sk->sk_allocation,
 						   first_skb);
 			if (!skb)
 				goto wait_for_space;
-- 
2.23.0

