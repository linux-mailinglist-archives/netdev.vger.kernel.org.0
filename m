Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2463956E
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 21:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730008AbfFGTVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 15:21:02 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:51133 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729895AbfFGTVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 15:21:02 -0400
Received: from localhost ([127.0.0.1] helo=flow.W.breakpoint.cc)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1hZKQ6-0004YF-F7; Fri, 07 Jun 2019 21:20:58 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     netdev@vger.kernel.org
Cc:     tglx@linutronix.de, "David S. Miller" <davem@davemloft.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH v2 net-next 2/7] net: Don't disable interrupts in __netdev_alloc_skb()
Date:   Fri,  7 Jun 2019 21:20:35 +0200
Message-Id: <20190607192040.19367-3-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190607192040.19367-1-bigeasy@linutronix.de>
References: <20190607192040.19367-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__netdev_alloc_skb() can be used from any context and is used by NAPI
and non-NAPI drivers. Non-NAPI drivers use it in interrupt context and
NAPI drivers use it during initial allocation (->ndo_open() or
->ndo_change_mtu()). Some NAPI drivers share the same function for the
initial allocation and the allocation in their NAPI callback.

The interrupts are disabled in order to ensure locked access from every
context to `netdev_alloc_cache'.

Let __netdev_alloc_skb() check if interrupts are disabled. If they are, use
`netdev_alloc_cache'. Otherwise disable BH and use `napi_alloc_cache.page'.
The IRQ check is cheaper compared to disabling & enabling interrupts and
memory allocation with disabled interrupts does not work on -RT.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/core/skbuff.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e246120bdd1b4..c7680f0b64c3b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -422,7 +422,6 @@ struct sk_buff *__netdev_alloc_skb(struct net_device *dev, unsigned int len,
 				   gfp_t gfp_mask)
 {
 	struct page_frag_cache *nc;
-	unsigned long flags;
 	struct sk_buff *skb;
 	bool pfmemalloc;
 	void *data;
@@ -443,13 +442,17 @@ struct sk_buff *__netdev_alloc_skb(struct net_device *dev, unsigned int len,
 	if (sk_memalloc_socks())
 		gfp_mask |= __GFP_MEMALLOC;
 
-	local_irq_save(flags);
-
-	nc = this_cpu_ptr(&netdev_alloc_cache);
-	data = page_frag_alloc(nc, len, gfp_mask);
-	pfmemalloc = nc->pfmemalloc;
-
-	local_irq_restore(flags);
+	if (in_irq() || irqs_disabled()) {
+		nc = this_cpu_ptr(&netdev_alloc_cache);
+		data = page_frag_alloc(nc, len, gfp_mask);
+		pfmemalloc = nc->pfmemalloc;
+	} else {
+		local_bh_disable();
+		nc = this_cpu_ptr(&napi_alloc_cache.page);
+		data = page_frag_alloc(nc, len, gfp_mask);
+		pfmemalloc = nc->pfmemalloc;
+		local_bh_enable();
+	}
 
 	if (unlikely(!data))
 		return NULL;
-- 
2.20.1

