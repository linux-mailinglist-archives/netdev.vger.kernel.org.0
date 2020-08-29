Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2749A256629
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 11:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgH2JDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 05:03:33 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:50820 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726748AbgH2JDc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Aug 2020 05:03:32 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id CFC64CC2069505D02394;
        Sat, 29 Aug 2020 17:03:24 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Sat, 29 Aug 2020
 17:03:01 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH] net: ipv4: remove unused arg exact_dif in compute_score
Date:   Sat, 29 Aug 2020 05:01:51 -0400
Message-ID: <20200829090151.61891-1-linmiaohe@huawei.com>
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
 net/ipv4/inet_hashtables.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

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

