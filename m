Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 245301743CB
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 01:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgB2A2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 19:28:21 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:57987 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbgB2A2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 19:28:20 -0500
X-Originating-IP: 71.238.64.75
Received: from localhost (c-71-238-64-75.hsd1.or.comcast.net [71.238.64.75])
        (Authenticated sender: josh@joshtriplett.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 265AFC0009;
        Sat, 29 Feb 2020 00:28:15 +0000 (UTC)
Date:   Fri, 28 Feb 2020 16:28:13 -0800
From:   Josh Triplett <josh@joshtriplett.org>
To:     Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Zorik Machulsky <zorik@amazon.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ena: Speed up initialization 90x by reducing poll delays
Message-ID: <20200229002813.GA177044@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before initializing completion queue interrupts, the ena driver uses
polling to wait for responses on the admin command queue. The ena driver
waits 5ms between polls, but the hardware has generally finished long
before that. Reduce the poll time to 10us.

On a c5.12xlarge, this improves ena initialization time from 173.6ms to
1.920ms, an improvement of more than 90x. This improves server boot time
and time to network bringup.

Before:
[    0.531722] calling  ena_init+0x0/0x63 @ 1
[    0.531722] ena: Elastic Network Adapter (ENA) v2.1.0K
[    0.531751] ena 0000:00:05.0: Elastic Network Adapter (ENA) v2.1.0K
[    0.531946] PCI Interrupt Link [LNKD] enabled at IRQ 11
[    0.547425] ena: ena device version: 0.10
[    0.547427] ena: ena controller version: 0.0.1 implementation version 1
[    0.709497] ena 0000:00:05.0: Elastic Network Adapter (ENA) found at mem febf4000, mac addr 06:c4:22:0e:dc:da, Placement policy: Low Latency
[    0.709508] initcall ena_init+0x0/0x63 returned 0 after 173616 usecs

After:
[    0.526965] calling  ena_init+0x0/0x63 @ 1
[    0.526966] ena: Elastic Network Adapter (ENA) v2.1.0K
[    0.527056] ena 0000:00:05.0: Elastic Network Adapter (ENA) v2.1.0K
[    0.527196] PCI Interrupt Link [LNKD] enabled at IRQ 11
[    0.527211] ena: ena device version: 0.10
[    0.527212] ena: ena controller version: 0.0.1 implementation version 1
[    0.528925] ena 0000:00:05.0: Elastic Network Adapter (ENA) found at mem febf4000, mac addr 06:c4:22:0e:dc:da, Placement policy: Low Latency
[    0.528934] initcall ena_init+0x0/0x63 returned 0 after 1920 usecs

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 1fb58f9ad80b..203b2130d707 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -62,7 +62,7 @@
 
 #define ENA_REGS_ADMIN_INTR_MASK 1
 
-#define ENA_POLL_MS	5
+#define ENA_POLL_US	10
 
 /*****************************************************************************/
 /*****************************************************************************/
@@ -572,7 +572,7 @@ static int ena_com_wait_and_process_admin_cq_polling(struct ena_comp_ctx *comp_c
 			goto err;
 		}
 
-		msleep(ENA_POLL_MS);
+		usleep_range(ENA_POLL_US, 2 * ENA_POLL_US);
 	}
 
 	if (unlikely(comp_ctx->status == ENA_CMD_ABORTED)) {
@@ -943,12 +943,13 @@ static void ena_com_io_queue_free(struct ena_com_dev *ena_dev,
 static int wait_for_reset_state(struct ena_com_dev *ena_dev, u32 timeout,
 				u16 exp_state)
 {
-	u32 val, i;
+	u32 val;
+	unsigned long timeout_jiffies;
 
-	/* Convert timeout from resolution of 100ms to ENA_POLL_MS */
-	timeout = (timeout * 100) / ENA_POLL_MS;
+	/* Convert timeout from resolution of 100ms */
+	timeout_jiffies = jiffies + msecs_to_jiffies(timeout * 100);
 
-	for (i = 0; i < timeout; i++) {
+	while (1) {
 		val = ena_com_reg_bar_read32(ena_dev, ENA_REGS_DEV_STS_OFF);
 
 		if (unlikely(val == ENA_MMIO_READ_TIMEOUT)) {
@@ -960,10 +961,11 @@ static int wait_for_reset_state(struct ena_com_dev *ena_dev, u32 timeout,
 			exp_state)
 			return 0;
 
-		msleep(ENA_POLL_MS);
-	}
+		if (time_is_before_jiffies(timeout_jiffies))
+			return -ETIME;
 
-	return -ETIME;
+		usleep_range(ENA_POLL_US, 2 * ENA_POLL_US);
+	}
 }
 
 static bool ena_com_check_supported_feature_id(struct ena_com_dev *ena_dev,
@@ -1458,7 +1460,7 @@ void ena_com_wait_for_abort_completion(struct ena_com_dev *ena_dev)
 	spin_lock_irqsave(&admin_queue->q_lock, flags);
 	while (atomic_read(&admin_queue->outstanding_cmds) != 0) {
 		spin_unlock_irqrestore(&admin_queue->q_lock, flags);
-		msleep(ENA_POLL_MS);
+		usleep_range(ENA_POLL_US, 2 * ENA_POLL_US);
 		spin_lock_irqsave(&admin_queue->q_lock, flags);
 	}
 	spin_unlock_irqrestore(&admin_queue->q_lock, flags);
-- 
2.25.1

