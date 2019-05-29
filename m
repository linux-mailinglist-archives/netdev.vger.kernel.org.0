Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B50B2E7E9
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 00:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfE2WPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 18:15:31 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:49914 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726508AbfE2WPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 18:15:30 -0400
Received: from localhost ([127.0.0.1] helo=flow.W.breakpoint.cc)
        by Chamillionaire.breakpoint.cc with esmtp (Exim 4.89)
        (envelope-from <sebastian@breakpoint.cc>)
        id 1hW6r2-0008F3-6L; Thu, 30 May 2019 00:15:28 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     netdev@vger.kernel.org
Cc:     tglx@linutronix.de, "David S. Miller" <davem@davemloft.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 1/7] net: Don't disable interrupts in napi_alloc_frag()
Date:   Thu, 30 May 2019 00:15:17 +0200
Message-Id: <20190529221523.22399-2-bigeasy@linutronix.de>
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
index e89be62826937..8a5ff67e14d90 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -369,34 +369,6 @@ struct napi_alloc_cache {
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
@@ -412,6 +384,31 @@ void *napi_alloc_frag(unsigned int fragsz)
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
+	if (irqs_disabled()) {
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

