Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E953E2573B2
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 08:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbgHaG1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 02:27:33 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:52668 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725794AbgHaG1c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 02:27:32 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id BA34CD707844E969AFE0;
        Mon, 31 Aug 2020 14:27:30 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Mon, 31 Aug 2020
 14:27:21 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH v2] net: ipv6: remove unused arg exact_dif in compute_score
Date:   Mon, 31 Aug 2020 02:26:10 -0400
Message-ID: <20200831062610.8078-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.175]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The arg exact_dif is not used anymore, remove it. inet6_exact_dif_match()
is no longer needed after the above is removed, remove it too.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 include/linux/ipv6.h        | 11 -----------
 net/ipv6/inet6_hashtables.c |  6 ++----
 2 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index a44789d027cc..4d6b03803379 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -177,17 +177,6 @@ static inline int inet6_sdif(const struct sk_buff *skb)
 	return 0;
 }
 
-/* can not be used in TCP layer after tcp_v6_fill_cb */
-static inline bool inet6_exact_dif_match(struct net *net, struct sk_buff *skb)
-{
-#if defined(CONFIG_NET_L3_MASTER_DEV)
-	if (!net->ipv4.sysctl_tcp_l3mdev_accept &&
-	    skb && ipv6_l3mdev_skb(IP6CB(skb)->flags))
-		return true;
-#endif
-	return false;
-}
-
 struct tcp6_request_sock {
 	struct tcp_request_sock	  tcp6rsk_tcp;
 };
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index 2d3add9e6116..55c290d55605 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -94,7 +94,7 @@ EXPORT_SYMBOL(__inet6_lookup_established);
 static inline int compute_score(struct sock *sk, struct net *net,
 				const unsigned short hnum,
 				const struct in6_addr *daddr,
-				const int dif, const int sdif, bool exact_dif)
+				const int dif, const int sdif)
 {
 	int score = -1;
 
@@ -138,15 +138,13 @@ static struct sock *inet6_lhash2_lookup(struct net *net,
 		const __be16 sport, const struct in6_addr *daddr,
 		const unsigned short hnum, const int dif, const int sdif)
 {
-	bool exact_dif = inet6_exact_dif_match(net, skb);
 	struct inet_connection_sock *icsk;
 	struct sock *sk, *result = NULL;
 	int score, hiscore = 0;
 
 	inet_lhash2_for_each_icsk_rcu(icsk, &ilb2->head) {
 		sk = (struct sock *)icsk;
-		score = compute_score(sk, net, hnum, daddr, dif, sdif,
-				      exact_dif);
+		score = compute_score(sk, net, hnum, daddr, dif, sdif);
 		if (score > hiscore) {
 			result = lookup_reuseport(net, sk, skb, doff,
 						  saddr, sport, daddr, hnum);
-- 
2.19.1

