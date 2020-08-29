Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A55D25662D
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 11:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgH2JFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 05:05:43 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:10341 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726280AbgH2JFl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Aug 2020 05:05:41 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C718399ABF895FAE83FD;
        Sat, 29 Aug 2020 17:05:36 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Sat, 29 Aug 2020
 17:05:29 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH] net: ipv6: remove unused arg exact_dif in compute_score
Date:   Sat, 29 Aug 2020 05:04:20 -0400
Message-ID: <20200829090420.6351-1-linmiaohe@huawei.com>
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

The arg exact_dif is not used anymore, remove it.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/ipv6/inet6_hashtables.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

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

