Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE2DF2E7EA
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 00:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbfE2WPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 18:15:31 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:49916 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726054AbfE2WPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 18:15:30 -0400
Received: from localhost ([127.0.0.1] helo=flow.W.breakpoint.cc)
        by Chamillionaire.breakpoint.cc with esmtp (Exim 4.89)
        (envelope-from <sebastian@breakpoint.cc>)
        id 1hW6r2-0008F3-R6; Thu, 30 May 2019 00:15:29 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     netdev@vger.kernel.org
Cc:     tglx@linutronix.de, "David S. Miller" <davem@davemloft.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 2/7] net: Don't disable interrupts in __netdev_alloc_skb()
Date:   Thu, 30 May 2019 00:15:18 +0200
Message-Id: <20190529221523.22399-3-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190529221523.22399-1-bigeasy@linutronix.de>
References: <20190529221523.22399-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Breakpoint-Spam-Score: -1.0
X-Breakpoint-Spam-Level: -
X-Breakpoint-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,HEADER_FROM_DIFFERENT_DOMAINS=0.001
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
index 8a5ff67e14d90..7f714a1196b90 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -426,7 +426,6 @@ struct sk_buff *__netdev_alloc_skb(struct net_device *dev, unsigned int len,
 				   gfp_t gfp_mask)
 {
 	struct page_frag_cache *nc;
-	unsigned long flags;
 	struct sk_buff *skb;
 	bool pfmemalloc;
 	void *data;
@@ -447,13 +446,17 @@ struct sk_buff *__netdev_alloc_skb(struct net_device *dev, unsigned int len,
 	if (sk_memalloc_socks())
 		gfp_mask |= __GFP_MEMALLOC;
 
-	local_irq_save(flags);
-
-	nc = this_cpu_ptr(&netdev_alloc_cache);
-	data = page_frag_alloc(nc, len, gfp_mask);
-	pfmemalloc = nc->pfmemalloc;
-
-	local_irq_restore(flags);
+	if (irqs_disabled()) {
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

