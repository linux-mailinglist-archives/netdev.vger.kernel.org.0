Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA3FF030C
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 17:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390568AbfKEQdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 11:33:38 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:59431 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390345AbfKEQcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 11:32:42 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iS1l3-0002Hp-0k; Tue, 05 Nov 2019 17:32:41 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Joe Burmeister <joe.burmeister@devtank.co.uk>,
        linux-stable <stable@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 09/33] can: c_can: c_can_poll(): only read status register after status IRQ
Date:   Tue,  5 Nov 2019 17:31:51 +0100
Message-Id: <20191105163215.30194-10-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.0.rc1
In-Reply-To: <20191105163215.30194-1-mkl@pengutronix.de>
References: <20191105163215.30194-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>

When the status register is read without the status IRQ pending, the
chip may not raise the interrupt line for an upcoming status interrupt
and the driver may miss a status interrupt.

It is critical that the BUSOFF status interrupt is forwarded to the
higher layers, since no more interrupts will follow without
intervention.

Thanks to Wolfgang and Joe for bringing up the first idea.

Signed-off-by: Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Joe Burmeister <joe.burmeister@devtank.co.uk>
Fixes: fa39b54ccf28 ("can: c_can: Get rid of pointless interrupts")
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/c_can/c_can.c | 25 ++++++++++++++++++++-----
 drivers/net/can/c_can/c_can.h |  1 +
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 606b7d8ffe13..9b61bfbea6cd 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -97,6 +97,9 @@
 #define BTR_TSEG2_SHIFT		12
 #define BTR_TSEG2_MASK		(0x7 << BTR_TSEG2_SHIFT)
 
+/* interrupt register */
+#define INT_STS_PENDING		0x8000
+
 /* brp extension register */
 #define BRP_EXT_BRPE_MASK	0x0f
 #define BRP_EXT_BRPE_SHIFT	0
@@ -1029,10 +1032,16 @@ static int c_can_poll(struct napi_struct *napi, int quota)
 	u16 curr, last = priv->last_status;
 	int work_done = 0;
 
-	priv->last_status = curr = priv->read_reg(priv, C_CAN_STS_REG);
-	/* Ack status on C_CAN. D_CAN is self clearing */
-	if (priv->type != BOSCH_D_CAN)
-		priv->write_reg(priv, C_CAN_STS_REG, LEC_UNUSED);
+	/* Only read the status register if a status interrupt was pending */
+	if (atomic_xchg(&priv->sie_pending, 0)) {
+		priv->last_status = curr = priv->read_reg(priv, C_CAN_STS_REG);
+		/* Ack status on C_CAN. D_CAN is self clearing */
+		if (priv->type != BOSCH_D_CAN)
+			priv->write_reg(priv, C_CAN_STS_REG, LEC_UNUSED);
+	} else {
+		/* no change detected ... */
+		curr = last;
+	}
 
 	/* handle state changes */
 	if ((curr & STATUS_EWARN) && (!(last & STATUS_EWARN))) {
@@ -1083,10 +1092,16 @@ static irqreturn_t c_can_isr(int irq, void *dev_id)
 {
 	struct net_device *dev = (struct net_device *)dev_id;
 	struct c_can_priv *priv = netdev_priv(dev);
+	int reg_int;
 
-	if (!priv->read_reg(priv, C_CAN_INT_REG))
+	reg_int = priv->read_reg(priv, C_CAN_INT_REG);
+	if (!reg_int)
 		return IRQ_NONE;
 
+	/* save for later use */
+	if (reg_int & INT_STS_PENDING)
+		atomic_set(&priv->sie_pending, 1);
+
 	/* disable all interrupts and schedule the NAPI */
 	c_can_irq_control(priv, false);
 	napi_schedule(&priv->napi);
diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
index 8acdc7fa4792..d5567a7c1c6d 100644
--- a/drivers/net/can/c_can/c_can.h
+++ b/drivers/net/can/c_can/c_can.h
@@ -198,6 +198,7 @@ struct c_can_priv {
 	struct net_device *dev;
 	struct device *device;
 	atomic_t tx_active;
+	atomic_t sie_pending;
 	unsigned long tx_dir;
 	int last_status;
 	u16 (*read_reg) (const struct c_can_priv *priv, enum reg index);
-- 
2.24.0.rc1

