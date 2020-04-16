Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22B141ACC50
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 17:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503066AbgDPP5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 11:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2442004AbgDPP5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 11:57:49 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56921C061A0C
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 08:57:48 -0700 (PDT)
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1jP6tY-0000hT-55; Thu, 16 Apr 2020 17:57:40 +0200
Date:   Thu, 16 Apr 2020 17:57:40 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     netdev@vger.kernel.org
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net] amd-xgbe: Use __napi_schedule() in BH context
Message-ID: <20200416155740.o3mzl7c73g4xkrmr@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver uses __napi_schedule_irqoff() which is fine as long as it is
invoked with disabled interrupts by everybody. Since the commit
mentioned below the driver may invoke xgbe_isr_task() in tasklet/softirq
context. This may lead to list corruption if another driver uses
__napi_schedule_irqoff() in IRQ context.

Use __napi_schedule() which safe to use from IRQ and softirq context.

Fixes: 85b85c853401d ("amd-xgbe: Re-issue interrupt if interrupt status not cleared")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
---

Repost of
  https://lore.kernel.org/r/20191126222013.1904785-2-bigeasy@linutronix.de

+ Tom's Ack collected.

 drivers/net/ethernet/amd/xgbe/xgbe-drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index b71f9b04a51e1..a87264f95f1a4 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -514,7 +514,7 @@ static void xgbe_isr_task(unsigned long data)
 				xgbe_disable_rx_tx_ints(pdata);
 
 				/* Turn on polling */
-				__napi_schedule_irqoff(&pdata->napi);
+				__napi_schedule(&pdata->napi);
 			}
 		} else {
 			/* Don't clear Rx/Tx status if doing per channel DMA
-- 
2.26.1

