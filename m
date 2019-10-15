Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 328A3D77AF
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 15:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732172AbfJONtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 09:49:21 -0400
Received: from foss.arm.com ([217.140.110.172]:39126 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732106AbfJONtV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 09:49:21 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 893731000;
        Tue, 15 Oct 2019 06:49:20 -0700 (PDT)
Received: from eglon.cambridge.arm.com (unknown [10.1.196.105])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F32BC3F718;
        Tue, 15 Oct 2019 06:49:19 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     netdev@vger.kernel.org
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        "Dave S . Miller" <davem@davemloft.net>
Subject: [RFC PATCH net 1/2] amd-xgbe: Avoid sleeping in flush_workqueue() while holding a spinlock
Date:   Tue, 15 Oct 2019 14:49:10 +0100
Message-Id: <20191015134911.231121-2-james.morse@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191015134911.231121-1-james.morse@arm.com>
References: <20191015134911.231121-1-james.morse@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xgbe_powerdown() takes an irqsave spinlock, then calls flush_workqueue()
which takes a mutex. DEBUG_ATOMIC_SLEEP isn't happy about this:
| BUG: sleeping function called from invalid context at [...] mutex.c:281
| in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid: 2733, name: bash
| CPU: 4 PID: 2733 Comm: bash Tainted: G        W         5.4.0-rc3 #113
| Hardware name: AMD Seattle (Rev.B0) Development Board (Overdrive) (DT)
| Call trace:
|  show_stack+0x24/0x30
|  dump_stack+0xb0/0xf8
|  ___might_sleep+0x124/0x148
|  __might_sleep+0x54/0x90
|  mutex_lock+0x2c/0x80
|  flush_workqueue+0x84/0x420
|  xgbe_powerdown+0x6c/0x108
|  xgbe_platform_suspend+0x34/0x80
|  pm_generic_freeze+0x3c/0x58
|  acpi_subsys_freeze+0x2c/0x38
|  dpm_run_callback+0x3c/0x1e8
|  __device_suspend+0x130/0x468
|  dpm_suspend+0x114/0x388
|  hibernation_snapshot+0xe8/0x378
|  hibernate+0x18c/0x2f8

Drop the lock for the duration of xgbe_powerdown(). We have already
stopeed the timers, so service_work can't be re-queued. Move the
pdata->power_down flag earlier so that it can be used by the interrupt
handler to know not to re-queue the tx_tstamp_work.

Signed-off-by: James Morse <james.morse@arm.com>

---
RFC as I'm not familiar with this driver. I'm happy to test a better fix!
---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 98f8f2033154..bfba7effcf9f 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -480,6 +480,8 @@ static void xgbe_isr_task(unsigned long data)
 	struct xgbe_channel *channel;
 	unsigned int dma_isr, dma_ch_isr;
 	unsigned int mac_isr, mac_tssr, mac_mdioisr;
+	unsigned long flags;
+	bool power_down;
 	unsigned int i;
 
 	/* The DMA interrupt status register also reports MAC and MTL
@@ -558,8 +560,14 @@ static void xgbe_isr_task(unsigned long data)
 				/* Read Tx Timestamp to clear interrupt */
 				pdata->tx_tstamp =
 					hw_if->get_tx_tstamp(pdata);
-				queue_work(pdata->dev_workqueue,
-					   &pdata->tx_tstamp_work);
+
+				spin_lock_irqsave(&pdata->lock, flags);
+				power_down = pdata->power_down;
+				spin_unlock_irqrestore(&pdata->lock, flags);
+
+				if (!power_down)
+					queue_work(pdata->dev_workqueue,
+						   &pdata->tx_tstamp_work);
 			}
 		}
 
@@ -1256,16 +1264,22 @@ int xgbe_powerdown(struct net_device *netdev, unsigned int caller)
 
 	netif_tx_stop_all_queues(netdev);
 
+	/* Stop service_work being re-queued by the service_timer */
 	xgbe_stop_timers(pdata);
+
+	/* Stop tx_tstamp_work being re-queued after flush_workqueue() */
+	pdata->power_down = 1;
+
+	/* drop the lock to allow flush_workqueue() to sleep. */
+	spin_unlock_irqrestore(&pdata->lock, flags);
 	flush_workqueue(pdata->dev_workqueue);
+	spin_lock_irqsave(&pdata->lock, flags);
 
 	hw_if->powerdown_tx(pdata);
 	hw_if->powerdown_rx(pdata);
 
 	xgbe_napi_disable(pdata, 0);
 
-	pdata->power_down = 1;
-
 	spin_unlock_irqrestore(&pdata->lock, flags);
 
 	DBGPR("<--xgbe_powerdown\n");
-- 
2.20.1

