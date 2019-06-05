Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 924E035EED
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 16:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbfFEOQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 10:16:51 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34574 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728337AbfFEOQv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 10:16:51 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id DA94464C6C58099965E1;
        Wed,  5 Jun 2019 22:16:45 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.439.0; Wed, 5 Jun 2019 22:16:37 +0800
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
To:     <linux-kernel@vger.kernel.org>
CC:     Kefeng Wang <wangkefeng.wang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Hideaki YOSHIFUJI" <yoshfuji@linux-ipv6.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        <netdev@vger.kernel.org>, <linux-sctp@vger.kernel.org>
Subject: [PATCH net-next] net: Drop unlikely before IS_ERR(_OR_NULL)
Date:   Wed, 5 Jun 2019 22:24:26 +0800
Message-ID: <20190605142428.84784-3-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190605142428.84784-1-wangkefeng.wang@huawei.com>
References: <20190605142428.84784-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IS_ERR(_OR_NULL) already contain an 'unlikely' compiler flag,
so no need to do that again from its callers. Drop it.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/net/udp.h           | 2 +-
 net/ipv4/fib_semantics.c    | 2 +-
 net/ipv4/inet_hashtables.c  | 2 +-
 net/ipv4/udp.c              | 2 +-
 net/ipv4/udp_offload.c      | 2 +-
 net/ipv6/inet6_hashtables.c | 2 +-
 net/ipv6/udp.c              | 2 +-
 net/sctp/socket.c           | 4 ++--
 8 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/net/udp.h b/include/net/udp.h
index 79d141d2103b..bad74f780831 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -480,7 +480,7 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
 	 * CB fragment
 	 */
 	segs = __skb_gso_segment(skb, features, false);
-	if (unlikely(IS_ERR_OR_NULL(segs))) {
+	if (IS_ERR_OR_NULL(segs)) {
 		int segs_nr = skb_shinfo(skb)->gso_segs;
 
 		atomic_add(segs_nr, &sk->sk_drops);
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index b80410673915..cd35bd0a4d8a 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1295,7 +1295,7 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 		goto failure;
 	fi->fib_metrics = ip_fib_metrics_init(fi->fib_net, cfg->fc_mx,
 					      cfg->fc_mx_len, extack);
-	if (unlikely(IS_ERR(fi->fib_metrics))) {
+	if (IS_ERR(fi->fib_metrics)) {
 		err = PTR_ERR(fi->fib_metrics);
 		kfree(fi);
 		return ERR_PTR(err);
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index c4503073248b..97824864e40d 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -316,7 +316,7 @@ struct sock *__inet_lookup_listener(struct net *net,
 				    saddr, sport, htonl(INADDR_ANY), hnum,
 				    dif, sdif);
 done:
-	if (unlikely(IS_ERR(result)))
+	if (IS_ERR(result))
 		return NULL;
 	return result;
 }
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 189144346cd4..8983afe2fe9e 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -478,7 +478,7 @@ struct sock *__udp4_lib_lookup(struct net *net, __be32 saddr,
 					  htonl(INADDR_ANY), hnum, dif, sdif,
 					  exact_dif, hslot2, skb);
 	}
-	if (unlikely(IS_ERR(result)))
+	if (IS_ERR(result))
 		return NULL;
 	return result;
 }
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 06b3e2c1fcdc..0112f64faf69 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -208,7 +208,7 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
 		gso_skb->destructor = NULL;
 
 	segs = skb_segment(gso_skb, features);
-	if (unlikely(IS_ERR_OR_NULL(segs))) {
+	if (IS_ERR_OR_NULL(segs)) {
 		if (copy_dtor)
 			gso_skb->destructor = sock_wfree;
 		return segs;
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index b2a55f300318..cf60fae9533b 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -174,7 +174,7 @@ struct sock *inet6_lookup_listener(struct net *net,
 				     saddr, sport, &in6addr_any, hnum,
 				     dif, sdif);
 done:
-	if (unlikely(IS_ERR(result)))
+	if (IS_ERR(result))
 		return NULL;
 	return result;
 }
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index b3418a7c5c74..693518350f79 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -215,7 +215,7 @@ struct sock *__udp6_lib_lookup(struct net *net,
 					  exact_dif, hslot2,
 					  skb);
 	}
-	if (unlikely(IS_ERR(result)))
+	if (IS_ERR(result))
 		return NULL;
 	return result;
 }
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 39ea0a37af09..c7b0f51c19d5 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -985,7 +985,7 @@ static int sctp_setsockopt_bindx(struct sock *sk,
 		return -EINVAL;
 
 	kaddrs = memdup_user(addrs, addrs_size);
-	if (unlikely(IS_ERR(kaddrs)))
+	if (IS_ERR(kaddrs))
 		return PTR_ERR(kaddrs);
 
 	/* Walk through the addrs buffer and count the number of addresses. */
@@ -1315,7 +1315,7 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
 		return -EINVAL;
 
 	kaddrs = memdup_user(addrs, addrs_size);
-	if (unlikely(IS_ERR(kaddrs)))
+	if (IS_ERR(kaddrs))
 		return PTR_ERR(kaddrs);
 
 	/* Allow security module to validate connectx addresses. */
-- 
2.20.1

