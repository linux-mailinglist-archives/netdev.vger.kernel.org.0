Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEF961970B
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 14:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbiKDNGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 09:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbiKDNFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 09:05:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48BD2E9F8
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 06:05:44 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oqwOF-00086U-2C
        for netdev@vger.kernel.org; Fri, 04 Nov 2022 14:05:43 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 30F40112F23
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 13:05:42 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 5F6E8112EFE;
        Fri,  4 Nov 2022 13:05:39 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 71a4292f;
        Fri, 4 Nov 2022 13:05:36 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        Dariusz Stojaczyk <Dariusz.Stojaczyk@opensynergy.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Max Staudt <max@enpas.org>, stable@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 4/5] can: dev: fix skb drop check
Date:   Fri,  4 Nov 2022 14:05:34 +0100
Message-Id: <20221104130535.732382-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221104130535.732382-1-mkl@pengutronix.de>
References: <20221104130535.732382-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

In commit a6d190f8c767 ("can: skb: drop tx skb if in listen only
mode") the priv->ctrlmode element is read even on virtual CAN
interfaces that do not create the struct can_priv at startup. This
out-of-bounds read may lead to CAN frame drops for virtual CAN
interfaces like vcan and vxcan.

This patch mainly reverts the original commit and adds a new helper
for CAN interface drivers that provide the required information in
struct can_priv.

Fixes: a6d190f8c767 ("can: skb: drop tx skb if in listen only mode")
Reported-by: Dariusz Stojaczyk <Dariusz.Stojaczyk@opensynergy.com>
Cc: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc: Max Staudt <max@enpas.org>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Acked-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/20221102095431.36831-1-socketcan@hartkopp.net
Cc: stable@vger.kernel.org # 6.0.x
[mkl: patch pch_can, too]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/at91_can.c                       |  2 +-
 drivers/net/can/c_can/c_can_main.c               |  2 +-
 drivers/net/can/can327.c                         |  2 +-
 drivers/net/can/cc770/cc770.c                    |  2 +-
 drivers/net/can/ctucanfd/ctucanfd_base.c         |  2 +-
 drivers/net/can/dev/skb.c                        | 10 +---------
 drivers/net/can/flexcan/flexcan-core.c           |  2 +-
 drivers/net/can/grcan.c                          |  2 +-
 drivers/net/can/ifi_canfd/ifi_canfd.c            |  2 +-
 drivers/net/can/janz-ican3.c                     |  2 +-
 drivers/net/can/kvaser_pciefd.c                  |  2 +-
 drivers/net/can/m_can/m_can.c                    |  2 +-
 drivers/net/can/mscan/mscan.c                    |  2 +-
 drivers/net/can/pch_can.c                        |  2 +-
 drivers/net/can/peak_canfd/peak_canfd.c          |  2 +-
 drivers/net/can/rcar/rcar_can.c                  |  2 +-
 drivers/net/can/rcar/rcar_canfd.c                |  2 +-
 drivers/net/can/sja1000/sja1000.c                |  2 +-
 drivers/net/can/slcan/slcan-core.c               |  2 +-
 drivers/net/can/softing/softing_main.c           |  2 +-
 drivers/net/can/spi/hi311x.c                     |  2 +-
 drivers/net/can/spi/mcp251x.c                    |  2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-tx.c     |  2 +-
 drivers/net/can/sun4i_can.c                      |  2 +-
 drivers/net/can/ti_hecc.c                        |  2 +-
 drivers/net/can/usb/ems_usb.c                    |  2 +-
 drivers/net/can/usb/esd_usb.c                    |  2 +-
 drivers/net/can/usb/etas_es58x/es58x_core.c      |  2 +-
 drivers/net/can/usb/gs_usb.c                     |  2 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c |  2 +-
 drivers/net/can/usb/mcba_usb.c                   |  2 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c     |  2 +-
 drivers/net/can/usb/ucan.c                       |  2 +-
 drivers/net/can/usb/usb_8dev.c                   |  2 +-
 drivers/net/can/xilinx_can.c                     |  2 +-
 include/linux/can/dev.h                          | 16 ++++++++++++++++
 36 files changed, 51 insertions(+), 43 deletions(-)

diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index 3a2d109a3792..199cb200f2bd 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -452,7 +452,7 @@ static netdev_tx_t at91_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	unsigned int mb, prio;
 	u32 reg_mid, reg_mcr;
 
-	if (can_dropped_invalid_skb(dev, skb))
+	if (can_dev_dropped_skb(dev, skb))
 		return NETDEV_TX_OK;
 
 	mb = get_tx_next_mb(priv);
diff --git a/drivers/net/can/c_can/c_can_main.c b/drivers/net/can/c_can/c_can_main.c
index d6605dbb7737..c63f7fc1e691 100644
--- a/drivers/net/can/c_can/c_can_main.c
+++ b/drivers/net/can/c_can/c_can_main.c
@@ -457,7 +457,7 @@ static netdev_tx_t c_can_start_xmit(struct sk_buff *skb,
 	struct c_can_tx_ring *tx_ring = &priv->tx;
 	u32 idx, obj, cmd = IF_COMM_TX;
 
-	if (can_dropped_invalid_skb(dev, skb))
+	if (can_dev_dropped_skb(dev, skb))
 		return NETDEV_TX_OK;
 
 	if (c_can_tx_busy(priv, tx_ring))
diff --git a/drivers/net/can/can327.c b/drivers/net/can/can327.c
index 0aa1af31d0fe..094197780776 100644
--- a/drivers/net/can/can327.c
+++ b/drivers/net/can/can327.c
@@ -813,7 +813,7 @@ static netdev_tx_t can327_netdev_start_xmit(struct sk_buff *skb,
 	struct can327 *elm = netdev_priv(dev);
 	struct can_frame *frame = (struct can_frame *)skb->data;
 
-	if (can_dropped_invalid_skb(dev, skb))
+	if (can_dev_dropped_skb(dev, skb))
 		return NETDEV_TX_OK;
 
 	/* We shouldn't get here after a hardware fault:
diff --git a/drivers/net/can/cc770/cc770.c b/drivers/net/can/cc770/cc770.c
index 0b9dfc76e769..30909f3aab57 100644
--- a/drivers/net/can/cc770/cc770.c
+++ b/drivers/net/can/cc770/cc770.c
@@ -429,7 +429,7 @@ static netdev_tx_t cc770_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct cc770_priv *priv = netdev_priv(dev);
 	unsigned int mo = obj2msgobj(CC770_OBJ_TX);
 
-	if (can_dropped_invalid_skb(dev, skb))
+	if (can_dev_dropped_skb(dev, skb))
 		return NETDEV_TX_OK;
 
 	netif_stop_queue(dev);
diff --git a/drivers/net/can/ctucanfd/ctucanfd_base.c b/drivers/net/can/ctucanfd/ctucanfd_base.c
index b8da15ea6ad9..64c349fd4600 100644
--- a/drivers/net/can/ctucanfd/ctucanfd_base.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_base.c
@@ -600,7 +600,7 @@ static netdev_tx_t ctucan_start_xmit(struct sk_buff *skb, struct net_device *nde
 	bool ok;
 	unsigned long flags;
 
-	if (can_dropped_invalid_skb(ndev, skb))
+	if (can_dev_dropped_skb(ndev, skb))
 		return NETDEV_TX_OK;
 
 	if (unlikely(!CTU_CAN_FD_TXTNF(priv))) {
diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index 791a51e2f5d6..241ec636e91f 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -5,7 +5,6 @@
  */
 
 #include <linux/can/dev.h>
-#include <linux/can/netlink.h>
 #include <linux/module.h>
 
 #define MOD_DESC "CAN device driver interface"
@@ -337,8 +336,6 @@ static bool can_skb_headroom_valid(struct net_device *dev, struct sk_buff *skb)
 /* Drop a given socketbuffer if it does not contain a valid CAN frame. */
 bool can_dropped_invalid_skb(struct net_device *dev, struct sk_buff *skb)
 {
-	struct can_priv *priv = netdev_priv(dev);
-
 	switch (ntohs(skb->protocol)) {
 	case ETH_P_CAN:
 		if (!can_is_can_skb(skb))
@@ -359,13 +356,8 @@ bool can_dropped_invalid_skb(struct net_device *dev, struct sk_buff *skb)
 		goto inval_skb;
 	}
 
-	if (!can_skb_headroom_valid(dev, skb)) {
+	if (!can_skb_headroom_valid(dev, skb))
 		goto inval_skb;
-	} else if (priv->ctrlmode & CAN_CTRLMODE_LISTENONLY) {
-		netdev_info_once(dev,
-				 "interface in listen only mode, dropping skb\n");
-		goto inval_skb;
-	}
 
 	return false;
 
diff --git a/drivers/net/can/flexcan/flexcan-core.c b/drivers/net/can/flexcan/flexcan-core.c
index 5ee38e586fd8..9bdadd716f4e 100644
--- a/drivers/net/can/flexcan/flexcan-core.c
+++ b/drivers/net/can/flexcan/flexcan-core.c
@@ -742,7 +742,7 @@ static netdev_tx_t flexcan_start_xmit(struct sk_buff *skb, struct net_device *de
 	u32 ctrl = FLEXCAN_MB_CODE_TX_DATA | ((can_fd_len2dlc(cfd->len)) << 16);
 	int i;
 
-	if (can_dropped_invalid_skb(dev, skb))
+	if (can_dev_dropped_skb(dev, skb))
 		return NETDEV_TX_OK;
 
 	netif_stop_queue(dev);
diff --git a/drivers/net/can/grcan.c b/drivers/net/can/grcan.c
index 6c37aab93eb3..4bedcc3eea0d 100644
--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -1345,7 +1345,7 @@ static netdev_tx_t grcan_start_xmit(struct sk_buff *skb,
 	unsigned long flags;
 	u32 oneshotmode = priv->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT;
 
-	if (can_dropped_invalid_skb(dev, skb))
+	if (can_dev_dropped_skb(dev, skb))
 		return NETDEV_TX_OK;
 
 	/* Trying to transmit in silent mode will generate error interrupts, but
diff --git a/drivers/net/can/ifi_canfd/ifi_canfd.c b/drivers/net/can/ifi_canfd/ifi_canfd.c
index 8d42b7e6661f..07eaf724a572 100644
--- a/drivers/net/can/ifi_canfd/ifi_canfd.c
+++ b/drivers/net/can/ifi_canfd/ifi_canfd.c
@@ -860,7 +860,7 @@ static netdev_tx_t ifi_canfd_start_xmit(struct sk_buff *skb,
 	u32 txst, txid, txdlc;
 	int i;
 
-	if (can_dropped_invalid_skb(ndev, skb))
+	if (can_dev_dropped_skb(ndev, skb))
 		return NETDEV_TX_OK;
 
 	/* Check if the TX buffer is full */
diff --git a/drivers/net/can/janz-ican3.c b/drivers/net/can/janz-ican3.c
index 71a2caae0757..0732a5092141 100644
--- a/drivers/net/can/janz-ican3.c
+++ b/drivers/net/can/janz-ican3.c
@@ -1693,7 +1693,7 @@ static netdev_tx_t ican3_xmit(struct sk_buff *skb, struct net_device *ndev)
 	void __iomem *desc_addr;
 	unsigned long flags;
 
-	if (can_dropped_invalid_skb(ndev, skb))
+	if (can_dev_dropped_skb(ndev, skb))
 		return NETDEV_TX_OK;
 
 	spin_lock_irqsave(&mod->lock, flags);
diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
index 4e9680c8eb34..bcad11709bc9 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -772,7 +772,7 @@ static netdev_tx_t kvaser_pciefd_start_xmit(struct sk_buff *skb,
 	int nwords;
 	u8 count;
 
-	if (can_dropped_invalid_skb(netdev, skb))
+	if (can_dev_dropped_skb(netdev, skb))
 		return NETDEV_TX_OK;
 
 	nwords = kvaser_pciefd_prepare_tx_packet(&packet, can, skb);
diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index dcb582563d5e..00d11e95fd98 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1721,7 +1721,7 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
 {
 	struct m_can_classdev *cdev = netdev_priv(dev);
 
-	if (can_dropped_invalid_skb(dev, skb))
+	if (can_dev_dropped_skb(dev, skb))
 		return NETDEV_TX_OK;
 
 	if (cdev->is_peripheral) {
diff --git a/drivers/net/can/mscan/mscan.c b/drivers/net/can/mscan/mscan.c
index 2119fbb287ef..a6829cdc0e81 100644
--- a/drivers/net/can/mscan/mscan.c
+++ b/drivers/net/can/mscan/mscan.c
@@ -191,7 +191,7 @@ static netdev_tx_t mscan_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	int i, rtr, buf_id;
 	u32 can_id;
 
-	if (can_dropped_invalid_skb(dev, skb))
+	if (can_dev_dropped_skb(dev, skb))
 		return NETDEV_TX_OK;
 
 	out_8(&regs->cantier, 0);
diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index 0558ff67ec6a..de8c05a72eaf 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -882,7 +882,7 @@ static netdev_tx_t pch_xmit(struct sk_buff *skb, struct net_device *ndev)
 	int i;
 	u32 id2;
 
-	if (can_dropped_invalid_skb(ndev, skb))
+	if (can_dev_dropped_skb(dev, skb))
 		return NETDEV_TX_OK;
 
 	tx_obj_no = priv->tx_obj;
diff --git a/drivers/net/can/peak_canfd/peak_canfd.c b/drivers/net/can/peak_canfd/peak_canfd.c
index f8420cc1d907..31c9c127e24b 100644
--- a/drivers/net/can/peak_canfd/peak_canfd.c
+++ b/drivers/net/can/peak_canfd/peak_canfd.c
@@ -651,7 +651,7 @@ static netdev_tx_t peak_canfd_start_xmit(struct sk_buff *skb,
 	int room_left;
 	u8 len;
 
-	if (can_dropped_invalid_skb(ndev, skb))
+	if (can_dev_dropped_skb(ndev, skb))
 		return NETDEV_TX_OK;
 
 	msg_size = ALIGN(sizeof(*msg) + cf->len, 4);
diff --git a/drivers/net/can/rcar/rcar_can.c b/drivers/net/can/rcar/rcar_can.c
index 6ee968c59ac9..cc43c9c5e38c 100644
--- a/drivers/net/can/rcar/rcar_can.c
+++ b/drivers/net/can/rcar/rcar_can.c
@@ -590,7 +590,7 @@ static netdev_tx_t rcar_can_start_xmit(struct sk_buff *skb,
 	struct can_frame *cf = (struct can_frame *)skb->data;
 	u32 data, i;
 
-	if (can_dropped_invalid_skb(ndev, skb))
+	if (can_dev_dropped_skb(ndev, skb))
 		return NETDEV_TX_OK;
 
 	if (cf->can_id & CAN_EFF_FLAG)	/* Extended frame format */
diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 198da643ee6d..d530e986f7fa 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1481,7 +1481,7 @@ static netdev_tx_t rcar_canfd_start_xmit(struct sk_buff *skb,
 	unsigned long flags;
 	u32 ch = priv->channel;
 
-	if (can_dropped_invalid_skb(ndev, skb))
+	if (can_dev_dropped_skb(ndev, skb))
 		return NETDEV_TX_OK;
 
 	if (cf->can_id & CAN_EFF_FLAG) {
diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
index 1bb1129b0450..aac5956e4a53 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -291,7 +291,7 @@ static netdev_tx_t sja1000_start_xmit(struct sk_buff *skb,
 	u8 cmd_reg_val = 0x00;
 	int i;
 
-	if (can_dropped_invalid_skb(dev, skb))
+	if (can_dev_dropped_skb(dev, skb))
 		return NETDEV_TX_OK;
 
 	netif_stop_queue(dev);
diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
index 8d13fdf8c28a..fbb34139daa1 100644
--- a/drivers/net/can/slcan/slcan-core.c
+++ b/drivers/net/can/slcan/slcan-core.c
@@ -594,7 +594,7 @@ static netdev_tx_t slcan_netdev_xmit(struct sk_buff *skb,
 {
 	struct slcan *sl = netdev_priv(dev);
 
-	if (can_dropped_invalid_skb(dev, skb))
+	if (can_dev_dropped_skb(dev, skb))
 		return NETDEV_TX_OK;
 
 	spin_lock(&sl->lock);
diff --git a/drivers/net/can/softing/softing_main.c b/drivers/net/can/softing/softing_main.c
index a5ef57f415f7..c72f505d29fe 100644
--- a/drivers/net/can/softing/softing_main.c
+++ b/drivers/net/can/softing/softing_main.c
@@ -60,7 +60,7 @@ static netdev_tx_t softing_netdev_start_xmit(struct sk_buff *skb,
 	struct can_frame *cf = (struct can_frame *)skb->data;
 	uint8_t buf[DPRAM_TX_SIZE];
 
-	if (can_dropped_invalid_skb(dev, skb))
+	if (can_dev_dropped_skb(dev, skb))
 		return NETDEV_TX_OK;
 
 	spin_lock(&card->spin);
diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
index b87dc420428d..e1b8533a602e 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -373,7 +373,7 @@ static netdev_tx_t hi3110_hard_start_xmit(struct sk_buff *skb,
 		return NETDEV_TX_BUSY;
 	}
 
-	if (can_dropped_invalid_skb(net, skb))
+	if (can_dev_dropped_skb(net, skb))
 		return NETDEV_TX_OK;
 
 	netif_stop_queue(net);
diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index 24883a65ca66..79c4bab5f724 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -789,7 +789,7 @@ static netdev_tx_t mcp251x_hard_start_xmit(struct sk_buff *skb,
 		return NETDEV_TX_BUSY;
 	}
 
-	if (can_dropped_invalid_skb(net, skb))
+	if (can_dev_dropped_skb(net, skb))
 		return NETDEV_TX_OK;
 
 	netif_stop_queue(net);
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-tx.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-tx.c
index ffb6c36b7d9b..160528d3cc26 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-tx.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-tx.c
@@ -172,7 +172,7 @@ netdev_tx_t mcp251xfd_start_xmit(struct sk_buff *skb,
 	u8 tx_head;
 	int err;
 
-	if (can_dropped_invalid_skb(ndev, skb))
+	if (can_dev_dropped_skb(ndev, skb))
 		return NETDEV_TX_OK;
 
 	if (mcp251xfd_tx_busy(priv, tx_ring))
diff --git a/drivers/net/can/sun4i_can.c b/drivers/net/can/sun4i_can.c
index 525309da1320..2b78f9197681 100644
--- a/drivers/net/can/sun4i_can.c
+++ b/drivers/net/can/sun4i_can.c
@@ -429,7 +429,7 @@ static netdev_tx_t sun4ican_start_xmit(struct sk_buff *skb, struct net_device *d
 	canid_t id;
 	int i;
 
-	if (can_dropped_invalid_skb(dev, skb))
+	if (can_dev_dropped_skb(dev, skb))
 		return NETDEV_TX_OK;
 
 	netif_stop_queue(dev);
diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index b218fb3c6b76..27700f72eac2 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -470,7 +470,7 @@ static netdev_tx_t ti_hecc_xmit(struct sk_buff *skb, struct net_device *ndev)
 	u32 mbxno, mbx_mask, data;
 	unsigned long flags;
 
-	if (can_dropped_invalid_skb(ndev, skb))
+	if (can_dev_dropped_skb(ndev, skb))
 		return NETDEV_TX_OK;
 
 	mbxno = get_tx_head_mb(priv);
diff --git a/drivers/net/can/usb/ems_usb.c b/drivers/net/can/usb/ems_usb.c
index d31191686a54..050c0b49938a 100644
--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -747,7 +747,7 @@ static netdev_tx_t ems_usb_start_xmit(struct sk_buff *skb, struct net_device *ne
 	size_t size = CPC_HEADER_SIZE + CPC_MSG_HEADER_LEN
 			+ sizeof(struct cpc_can_msg);
 
-	if (can_dropped_invalid_skb(netdev, skb))
+	if (can_dev_dropped_skb(netdev, skb))
 		return NETDEV_TX_OK;
 
 	/* create a URB, and a buffer for it, and copy the data to the URB */
diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 1bcfad11b1e4..81b88e9e5bdc 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -725,7 +725,7 @@ static netdev_tx_t esd_usb_start_xmit(struct sk_buff *skb,
 	int ret = NETDEV_TX_OK;
 	size_t size = sizeof(struct esd_usb_msg);
 
-	if (can_dropped_invalid_skb(netdev, skb))
+	if (can_dev_dropped_skb(netdev, skb))
 		return NETDEV_TX_OK;
 
 	/* create a URB, and a buffer for it, and copy the data to the URB */
diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 51294b717040..25f863b4f5f0 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -1913,7 +1913,7 @@ static netdev_tx_t es58x_start_xmit(struct sk_buff *skb,
 	unsigned int frame_len;
 	int ret;
 
-	if (can_dropped_invalid_skb(netdev, skb)) {
+	if (can_dev_dropped_skb(netdev, skb)) {
 		if (priv->tx_urb)
 			goto xmit_commit;
 		return NETDEV_TX_OK;
diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index f0065d40eb24..9c2c25fde3d1 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -723,7 +723,7 @@ static netdev_tx_t gs_can_start_xmit(struct sk_buff *skb,
 	unsigned int idx;
 	struct gs_tx_context *txc;
 
-	if (can_dropped_invalid_skb(netdev, skb))
+	if (can_dev_dropped_skb(netdev, skb))
 		return NETDEV_TX_OK;
 
 	/* find an empty context to keep track of transmission */
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index e91648ed7386..802e27c0eced 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -570,7 +570,7 @@ static netdev_tx_t kvaser_usb_start_xmit(struct sk_buff *skb,
 	unsigned int i;
 	unsigned long flags;
 
-	if (can_dropped_invalid_skb(netdev, skb))
+	if (can_dev_dropped_skb(netdev, skb))
 		return NETDEV_TX_OK;
 
 	urb = usb_alloc_urb(0, GFP_ATOMIC);
diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index 69346c63021f..218b098b261d 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -311,7 +311,7 @@ static netdev_tx_t mcba_usb_start_xmit(struct sk_buff *skb,
 		.cmd_id = MBCA_CMD_TRANSMIT_MESSAGE_EV
 	};
 
-	if (can_dropped_invalid_skb(netdev, skb))
+	if (can_dev_dropped_skb(netdev, skb))
 		return NETDEV_TX_OK;
 
 	ctx = mcba_usb_get_free_ctx(priv, cf);
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
index 225697d70a9a..1d996d3320fe 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -351,7 +351,7 @@ static netdev_tx_t peak_usb_ndo_start_xmit(struct sk_buff *skb,
 	int i, err;
 	size_t size = dev->adapter->tx_buffer_size;
 
-	if (can_dropped_invalid_skb(netdev, skb))
+	if (can_dev_dropped_skb(netdev, skb))
 		return NETDEV_TX_OK;
 
 	for (i = 0; i < PCAN_USB_MAX_TX_URBS; i++)
diff --git a/drivers/net/can/usb/ucan.c b/drivers/net/can/usb/ucan.c
index 7c35f50fda4e..67c2ff407d06 100644
--- a/drivers/net/can/usb/ucan.c
+++ b/drivers/net/can/usb/ucan.c
@@ -1120,7 +1120,7 @@ static netdev_tx_t ucan_start_xmit(struct sk_buff *skb,
 	struct can_frame *cf = (struct can_frame *)skb->data;
 
 	/* check skb */
-	if (can_dropped_invalid_skb(netdev, skb))
+	if (can_dev_dropped_skb(netdev, skb))
 		return NETDEV_TX_OK;
 
 	/* allocate a context and slow down tx path, if fifo state is low */
diff --git a/drivers/net/can/usb/usb_8dev.c b/drivers/net/can/usb/usb_8dev.c
index 64c00abe91cf..8a5596ce4e46 100644
--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -602,7 +602,7 @@ static netdev_tx_t usb_8dev_start_xmit(struct sk_buff *skb,
 	int i, err;
 	size_t size = sizeof(struct usb_8dev_tx_msg);
 
-	if (can_dropped_invalid_skb(netdev, skb))
+	if (can_dev_dropped_skb(netdev, skb))
 		return NETDEV_TX_OK;
 
 	/* create a URB, and a buffer for it, and copy the data to the URB */
diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 5d3172795ad0..43c812ea1de0 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -743,7 +743,7 @@ static netdev_tx_t xcan_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	struct xcan_priv *priv = netdev_priv(ndev);
 	int ret;
 
-	if (can_dropped_invalid_skb(ndev, skb))
+	if (can_dev_dropped_skb(ndev, skb))
 		return NETDEV_TX_OK;
 
 	if (priv->devtype.flags & XCAN_FLAG_TX_MAILBOXES)
diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index 58f5431a5559..982ba245eb41 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -152,6 +152,22 @@ static inline bool can_is_canxl_dev_mtu(unsigned int mtu)
 	return (mtu >= CANXL_MIN_MTU && mtu <= CANXL_MAX_MTU);
 }
 
+/* drop skb if it does not contain a valid CAN frame for sending */
+static inline bool can_dev_dropped_skb(struct net_device *dev, struct sk_buff *skb)
+{
+	struct can_priv *priv = netdev_priv(dev);
+
+	if (priv->ctrlmode & CAN_CTRLMODE_LISTENONLY) {
+		netdev_info_once(dev,
+				 "interface in listen only mode, dropping skb\n");
+		kfree_skb(skb);
+		dev->stats.tx_dropped++;
+		return true;
+	}
+
+	return can_dropped_invalid_skb(dev, skb);
+}
+
 void can_setup(struct net_device *dev);
 
 struct net_device *alloc_candev_mqs(int sizeof_priv, unsigned int echo_skb_max,
-- 
2.35.1


