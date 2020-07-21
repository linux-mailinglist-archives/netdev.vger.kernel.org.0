Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0622E227B64
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 11:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbgGUJJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 05:09:11 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7804 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725984AbgGUJJL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 05:09:11 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A974C204CD9DEC23A132;
        Tue, 21 Jul 2020 17:09:07 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Tue, 21 Jul 2020
 17:08:57 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <kuba@kernel.org>,
        <wangchen@cn.fujitsu.com>, <herbert@gondor.apana.org.au>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH] net: udp: Fix wrong clean up for IS_UDPLITE macro
Date:   Tue, 21 Jul 2020 17:11:44 +0800
Message-ID: <1595322704-31548-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

We can't use IS_UDPLITE to replace udp_sk->pcflag when UDPLITE_RECV_CC is
checked.

Fixes: b2bf1e2659b1 ("[UDP]: Clean up for IS_UDPLITE macro")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/ipv4/udp.c | 2 +-
 net/ipv6/udp.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 1b7ebbcae497..c7d61db1fb38 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2051,7 +2051,7 @@ static int udp_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 	/*
 	 * 	UDP-Lite specific tests, ignored on UDP sockets
 	 */
-	if ((is_udplite & UDPLITE_RECV_CC)  &&  UDP_SKB_CB(skb)->partial_cov) {
+	if ((up->pcflag & UDPLITE_RECV_CC)  &&  UDP_SKB_CB(skb)->partial_cov) {
 
 		/*
 		 * MIB statistics other than incrementing the error count are
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 7d4151747340..1164dfe53bb3 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -643,7 +643,7 @@ static int udpv6_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 	/*
 	 * UDP-Lite specific tests, ignored on UDP sockets (see net/ipv4/udp.c).
 	 */
-	if ((is_udplite & UDPLITE_RECV_CC)  &&  UDP_SKB_CB(skb)->partial_cov) {
+	if ((up->pcflag & UDPLITE_RECV_CC)  &&  UDP_SKB_CB(skb)->partial_cov) {
 
 		if (up->pcrlen == 0) {          /* full coverage was set  */
 			net_dbg_ratelimited("UDPLITE6: partial coverage %d while full coverage %d requested\n",
-- 
2.19.1

