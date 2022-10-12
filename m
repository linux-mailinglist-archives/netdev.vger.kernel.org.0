Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF515FC325
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 11:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiJLJfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 05:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbiJLJfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 05:35:17 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53ED43B72B;
        Wed, 12 Oct 2022 02:35:16 -0700 (PDT)
Received: from kwepemi500015.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MnS9k4zWDz1CDyg;
        Wed, 12 Oct 2022 17:32:42 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemi500015.china.huawei.com
 (7.221.188.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 12 Oct
 2022 17:35:13 +0800
From:   Lu Wei <luwei32@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] tcp: fix a signed-integer-overflow bug in tcp_add_backlog()
Date:   Wed, 12 Oct 2022 18:38:44 +0800
Message-ID: <20221012103844.1095777-1-luwei32@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500015.china.huawei.com (7.221.188.92)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The type of sk_rcvbuf and sk_sndbuf in struct sock is int, and
in tcp_add_backlog(), the variable limit is caculated by adding
sk_rcvbuf, sk_sndbuf and 64 * 1024, it may exceed the max value
of u32 and be truncated. So change it to u64 to avoid a potential
signed-integer-overflow, which leads to opposite result is returned
in the following function.

Signed-off-by: Lu Wei <luwei32@huawei.com>
---
 include/net/sock.h  | 4 ++--
 net/ipv4/tcp_ipv4.c | 6 ++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 08038a385ef2..fc0fa29d8865 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1069,7 +1069,7 @@ static inline void __sk_add_backlog(struct sock *sk, struct sk_buff *skb)
  * Do not take into account this skb truesize,
  * to allow even a single big packet to come.
  */
-static inline bool sk_rcvqueues_full(const struct sock *sk, unsigned int limit)
+static inline bool sk_rcvqueues_full(const struct sock *sk, u64 limit)
 {
 	unsigned int qsize = sk->sk_backlog.len + atomic_read(&sk->sk_rmem_alloc);
 
@@ -1078,7 +1078,7 @@ static inline bool sk_rcvqueues_full(const struct sock *sk, unsigned int limit)
 
 /* The per-socket spinlock must be held here. */
 static inline __must_check int sk_add_backlog(struct sock *sk, struct sk_buff *skb,
-					      unsigned int limit)
+					      u64 limit)
 {
 	if (sk_rcvqueues_full(sk, limit))
 		return -ENOBUFS;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 6376ad915765..3d4f9ac64165 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1769,7 +1769,8 @@ int tcp_v4_early_demux(struct sk_buff *skb)
 bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb,
 		     enum skb_drop_reason *reason)
 {
-	u32 limit, tail_gso_size, tail_gso_segs;
+	u32 tail_gso_size, tail_gso_segs;
+	u64 limit;
 	struct skb_shared_info *shinfo;
 	const struct tcphdr *th;
 	struct tcphdr *thtail;
@@ -1878,7 +1879,8 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb,
 	 * to reduce memory overhead, so add a little headroom here.
 	 * Few sockets backlog are possibly concurrently non empty.
 	 */
-	limit = READ_ONCE(sk->sk_rcvbuf) + READ_ONCE(sk->sk_sndbuf) + 64*1024;
+	limit = (u64)READ_ONCE(sk->sk_rcvbuf) +
+		(u64)READ_ONCE(sk->sk_sndbuf) + 64*1024;
 
 	if (unlikely(sk_add_backlog(sk, skb, limit))) {
 		bh_unlock_sock(sk);
-- 
2.31.1

