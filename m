Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD1662DF0B
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 16:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfE2OAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 10:00:02 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:43611 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727014AbfE2OAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 10:00:02 -0400
X-Originating-IP: 90.88.147.134
Received: from localhost (aaubervilliers-681-1-27-134.w90-88.abo.wanadoo.fr [90.88.147.134])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 7C810FF804;
        Wed, 29 May 2019 13:59:59 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, stefanc@marvell.com, mw@semihalf.com
Subject: [PATCH net] net: mvpp2: fix bad MVPP2_TXQ_SCHED_TOKEN_CNTR_REG queue value
Date:   Wed, 29 May 2019 15:59:48 +0200
Message-Id: <20190529135948.32483-1-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MVPP2_TXQ_SCHED_TOKEN_CNTR_REG() expects the logical queue id but
the current code is passing the global tx queue offset, so it ends
up writing to unknown registers (between 0x8280 and 0x82fc, which
seemed to be unused by the hardware). This fixes the issue by using
the logical queue id instead.

Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index d38952eb7aa9..7a67e23a2c2b 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1455,7 +1455,7 @@ static inline void mvpp2_xlg_max_rx_size_set(struct mvpp2_port *port)
 /* Set defaults to the MVPP2 port */
 static void mvpp2_defaults_set(struct mvpp2_port *port)
 {
-	int tx_port_num, val, queue, ptxq, lrxq;
+	int tx_port_num, val, queue, lrxq;
 
 	if (port->priv->hw_version == MVPP21) {
 		/* Update TX FIFO MIN Threshold */
@@ -1476,11 +1476,9 @@ static void mvpp2_defaults_set(struct mvpp2_port *port)
 	mvpp2_write(port->priv, MVPP2_TXP_SCHED_FIXED_PRIO_REG, 0);
 
 	/* Close bandwidth for all queues */
-	for (queue = 0; queue < MVPP2_MAX_TXQ; queue++) {
-		ptxq = mvpp2_txq_phys(port->id, queue);
+	for (queue = 0; queue < MVPP2_MAX_TXQ; queue++)
 		mvpp2_write(port->priv,
-			    MVPP2_TXQ_SCHED_TOKEN_CNTR_REG(ptxq), 0);
-	}
+			    MVPP2_TXQ_SCHED_TOKEN_CNTR_REG(queue), 0);
 
 	/* Set refill period to 1 usec, refill tokens
 	 * and bucket size to maximum
@@ -2336,7 +2334,7 @@ static void mvpp2_txq_deinit(struct mvpp2_port *port,
 	txq->descs_dma         = 0;
 
 	/* Set minimum bandwidth for disabled TXQs */
-	mvpp2_write(port->priv, MVPP2_TXQ_SCHED_TOKEN_CNTR_REG(txq->id), 0);
+	mvpp2_write(port->priv, MVPP2_TXQ_SCHED_TOKEN_CNTR_REG(txq->log_id), 0);
 
 	/* Set Tx descriptors queue starting address and size */
 	thread = mvpp2_cpu_to_thread(port->priv, get_cpu());
-- 
2.21.0

