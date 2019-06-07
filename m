Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4B73956D
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 21:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729998AbfFGTVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 15:21:02 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:51131 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729379AbfFGTVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 15:21:02 -0400
Received: from localhost ([127.0.0.1] helo=flow.W.breakpoint.cc)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1hZKQ5-0004YF-VL; Fri, 07 Jun 2019 21:20:58 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     netdev@vger.kernel.org
Cc:     tglx@linutronix.de, "David S. Miller" <davem@davemloft.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH v2 net-next 1/7] net: Don't disable interrupts in napi_alloc_frag()
Date:   Fri,  7 Jun 2019 21:20:34 +0200
Message-Id: <20190607192040.19367-2-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190607192040.19367-1-bigeasy@linutronix.de>
References: <20190607192040.19367-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netdev_alloc_frag() can be used from any context and is used by NAPI
and non-NAPI drivers. Non-NAPI drivers use it in interrupt context
and NAPI drivers use it during initial allocation (->ndo_open() or
->ndo_change_mtu()). Some NAPI drivers share the same function for the
initial allocation and the allocation in their NAPI callback.

The interrupts are disabled in order to ensure locked access from every
context to `netdev_alloc_cache'.

Let netdev_alloc_frag() check if interrupts are disabled. If they are,
use `netdev_alloc_cache' otherwise disable BH and invoke
__napi_alloc_frag() for the allocation. The IRQ check is cheaper
compared to disabling & enabling interrupts and memory allocation with
disabled interrupts does not work on -RT.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/core/skbuff.c | 53 ++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 28 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 47c1aa9ee0454..e246120bdd1b4 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -365,34 +365,6 @@ struct napi_alloc_cache {
 static DEFINE_PER_CPU(struct page_frag_cache, netdev_alloc_cache);
 static DEFINE_PER_CPU(struct napi_alloc_cache, napi_alloc_cache);
 
-static void *__netdev_alloc_frag(unsigned int fragsz, gfp_t gfp_mask)
-{
-	struct page_frag_cache *nc;
-	unsigned long flags;
-	void *data;
-
-	local_irq_save(flags);
-	nc = this_cpu_ptr(&netdev_alloc_cache);
-	data = page_frag_alloc(nc, fragsz, gfp_mask);
-	local_irq_restore(flags);
-	return data;
-}
-
-/**
- * netdev_alloc_frag - allocate a page fragment
- * @fragsz: fragment size
- *
- * Allocates a frag from a page for receive buffer.
- * Uses GFP_ATOMIC allocations.
- */
-void *netdev_alloc_frag(unsigned int fragsz)
-{
-	fragsz = SKB_DATA_ALIGN(fragsz);
-
-	return __netdev_alloc_frag(fragsz, GFP_ATOMIC);
-}
-EXPORT_SYMBOL(netdev_alloc_frag);
-
 static void *__napi_alloc_frag(unsigned int fragsz, gfp_t gfp_mask)
 {
 	struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
@@ -408,6 +380,31 @@ void *napi_alloc_frag(unsigned int fragsz)
 }
 EXPORT_SYMBOL(napi_alloc_frag);
 
+/**
+ * netdev_alloc_frag - allocate a page fragment
+ * @fragsz: fragment size
+ *
+ * Allocates a frag from a page for receive buffer.
+ * Uses GFP_ATOMIC allocations.
+ */
+void *netdev_alloc_frag(unsigned int fragsz)
+{
+	struct page_frag_cache *nc;
+	void *data;
+
+	fragsz = SKB_DATA_ALIGN(fragsz);
+	if (in_irq() || irqs_disabled()) {
+		nc = this_cpu_ptr(&netdev_alloc_cache);
+		data = page_frag_alloc(nc, fragsz, GFP_ATOMIC);
+	} else {
+		local_bh_disable();
+		data = __napi_alloc_frag(fragsz, GFP_ATOMIC);
+		local_bh_enable();
+	}
+	return data;
+}
+EXPORT_SYMBOL(netdev_alloc_frag);
+
 /**
  *	__netdev_alloc_skb - allocate an skbuff for rx on a specific device
  *	@dev: network device to receive on
-- 
2.20.1

