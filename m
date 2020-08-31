Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56E532573B5
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 08:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgHaG17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 02:27:59 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:10738 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725794AbgHaG16 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 02:27:58 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 2EB4BFA26646CA0B97BD;
        Mon, 31 Aug 2020 14:27:56 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Mon, 31 Aug 2020
 14:27:47 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH v2] net: ipv4: remove unused arg exact_dif in compute_score
Date:   Mon, 31 Aug 2020 02:26:34 -0400
Message-ID: <20200831062634.8481-1-linmiaohe@huawei.com>
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

The arg exact_dif is not used anymore, remove it. inet_exact_dif_match()
is no longer needed after the above is removed, so remove it too.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 include/net/tcp.h          | 10 ----------
 net/ipv4/inet_hashtables.c |  6 ++----
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index eab6c7510b5b..0d11db6436c8 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -941,16 +941,6 @@ INDIRECT_CALLABLE_DECLARE(void tcp_v6_early_demux(struct sk_buff *skb));
 
 #endif
 
-static inline bool inet_exact_dif_match(struct net *net, struct sk_buff *skb)
-{
-#if IS_ENABLED(CONFIG_NET_L3_MASTER_DEV)
-	if (!net->ipv4.sysctl_tcp_l3mdev_accept &&
-	    skb && ipv4_l3mdev_skb(IPCB(skb)->flags))
-		return true;
-#endif
-	return false;
-}
-
 /* TCP_SKB_CB reference means this can not be used from early demux */
 static inline int tcp_v4_sdif(struct sk_buff *skb)
 {
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 239e54474b65..8cbe74313f38 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -228,7 +228,7 @@ static void inet_unhash2(struct inet_hashinfo *h, struct sock *sk)
 
 static inline int compute_score(struct sock *sk, struct net *net,
 				const unsigned short hnum, const __be32 daddr,
-				const int dif, const int sdif, bool exact_dif)
+				const int dif, const int sdif)
 {
 	int score = -1;
 
@@ -277,15 +277,13 @@ static struct sock *inet_lhash2_lookup(struct net *net,
 				const __be32 daddr, const unsigned short hnum,
 				const int dif, const int sdif)
 {
-	bool exact_dif = inet_exact_dif_match(net, skb);
 	struct inet_connection_sock *icsk;
 	struct sock *sk, *result = NULL;
 	int score, hiscore = 0;
 
 	inet_lhash2_for_each_icsk_rcu(icsk, &ilb2->head) {
 		sk = (struct sock *)icsk;
-		score = compute_score(sk, net, hnum, daddr,
-				      dif, sdif, exact_dif);
+		score = compute_score(sk, net, hnum, daddr, dif, sdif);
 		if (score > hiscore) {
 			result = lookup_reuseport(net, sk, skb, doff,
 						  saddr, sport, daddr, hnum);
-- 
2.19.1

