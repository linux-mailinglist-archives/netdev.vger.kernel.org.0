Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0C51F23CF
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 01:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730300AbgFHXQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:16:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729739AbgFHXQd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:16:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABE2E20820;
        Mon,  8 Jun 2020 23:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658193;
        bh=/vbQSAarfWCrkIH4Xhngwau6L7c14Hu+WRKH7eUcJhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m2XAC9UN/tst8CXkIeUs4LN2tNdu0qKHCFL7gwvNNTZ69rycM1v6+8dpyZK/VhehV
         BAli82BrtAle8Pn83vKWnVgWe3HXCg6STYROU+QHDJnYGMboaZVb+XZILM0lk7O7aK
         7RXbbbj07B0Re5YcDfTSF15Z9FfJPKqs739GzQn8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Boris Sukholitko <boris.sukholitko@broadcom.com>,
        Edward Cree <ecree@solarflare.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 214/606] __netif_receive_skb_core: pass skb by reference
Date:   Mon,  8 Jun 2020 19:05:39 -0400
Message-Id: <20200608231211.3363633-214-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boris Sukholitko <boris.sukholitko@broadcom.com>

[ Upstream commit c0bbbdc32febd4f034ecbf3ea17865785b2c0652 ]

__netif_receive_skb_core may change the skb pointer passed into it (e.g.
in rx_handler). The original skb may be freed as a result of this
operation.

The callers of __netif_receive_skb_core may further process original skb
by using pt_prev pointer returned by __netif_receive_skb_core thus
leading to unpleasant effects.

The solution is to pass skb by reference into __netif_receive_skb_core.

v2: Added Fixes tag and comment regarding ppt_prev and skb invariant.

Fixes: 88eb1944e18c ("net: core: propagate SKB lists through packet_type lookup")
Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
Acked-by: Edward Cree <ecree@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index c7047b40f569..87fd5424e205 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4988,11 +4988,12 @@ static inline int nf_ingress(struct sk_buff *skb, struct packet_type **pt_prev,
 	return 0;
 }
 
-static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
+static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 				    struct packet_type **ppt_prev)
 {
 	struct packet_type *ptype, *pt_prev;
 	rx_handler_func_t *rx_handler;
+	struct sk_buff *skb = *pskb;
 	struct net_device *orig_dev;
 	bool deliver_exact = false;
 	int ret = NET_RX_DROP;
@@ -5023,8 +5024,10 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 		ret2 = do_xdp_generic(rcu_dereference(skb->dev->xdp_prog), skb);
 		preempt_enable();
 
-		if (ret2 != XDP_PASS)
-			return NET_RX_DROP;
+		if (ret2 != XDP_PASS) {
+			ret = NET_RX_DROP;
+			goto out;
+		}
 		skb_reset_mac_len(skb);
 	}
 
@@ -5174,6 +5177,13 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 	}
 
 out:
+	/* The invariant here is that if *ppt_prev is not NULL
+	 * then skb should also be non-NULL.
+	 *
+	 * Apparently *ppt_prev assignment above holds this invariant due to
+	 * skb dereferencing near it.
+	 */
+	*pskb = skb;
 	return ret;
 }
 
@@ -5183,7 +5193,7 @@ static int __netif_receive_skb_one_core(struct sk_buff *skb, bool pfmemalloc)
 	struct packet_type *pt_prev = NULL;
 	int ret;
 
-	ret = __netif_receive_skb_core(skb, pfmemalloc, &pt_prev);
+	ret = __netif_receive_skb_core(&skb, pfmemalloc, &pt_prev);
 	if (pt_prev)
 		ret = INDIRECT_CALL_INET(pt_prev->func, ipv6_rcv, ip_rcv, skb,
 					 skb->dev, pt_prev, orig_dev);
@@ -5261,7 +5271,7 @@ static void __netif_receive_skb_list_core(struct list_head *head, bool pfmemallo
 		struct packet_type *pt_prev = NULL;
 
 		skb_list_del_init(skb);
-		__netif_receive_skb_core(skb, pfmemalloc, &pt_prev);
+		__netif_receive_skb_core(&skb, pfmemalloc, &pt_prev);
 		if (!pt_prev)
 			continue;
 		if (pt_curr != pt_prev || od_curr != orig_dev) {
-- 
2.25.1

