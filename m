Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDAF4564087
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 16:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbiGBOCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 10:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232207AbiGBOB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 10:01:56 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6FC78D135;
        Sat,  2 Jul 2022 07:01:54 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.92,240,1650898800"; 
   d="scan'208";a="126437020"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 02 Jul 2022 23:01:54 +0900
Received: from localhost.localdomain (unknown [10.226.92.2])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 4D03643676A3;
        Sat,  2 Jul 2022 23:01:49 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH 3/6] can: sja1000: Add Quirks for RZ/N1 SJA1000 CAN controller
Date:   Sat,  2 Jul 2022 15:01:27 +0100
Message-Id: <20220702140130.218409-4-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220702140130.218409-1-biju.das.jz@bp.renesas.com>
References: <20220702140130.218409-1-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chapter 6.5.16 of the RZ/N1 Peripheral Manual mentions the below
differences compared to the reference Philips SJA1000 device.

Handling of Transmitted Messages:
 * The CAN controller does not copy transmitted messages to the receive
   buffer, unlike the reference device.

Clock Divider Register:
 * This register is not supported

This patch adds device quirks to handle these differences.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
 drivers/net/can/sja1000/sja1000.c | 17 +++++++++++------
 drivers/net/can/sja1000/sja1000.h |  4 +++-
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
index 2e7638f98cf1..49cf4fc4d896 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -183,8 +183,9 @@ static void chipset_init(struct net_device *dev)
 {
 	struct sja1000_priv *priv = netdev_priv(dev);
 
-	/* set clock divider and output control register */
-	priv->write_reg(priv, SJA1000_CDR, priv->cdr | CDR_PELICAN);
+	if (!(priv->flags & SJA1000_NO_CDR_REG_QUIRK))
+		/* set clock divider and output control register */
+		priv->write_reg(priv, SJA1000_CDR, priv->cdr | CDR_PELICAN);
 
 	/* set acceptance filter (accept all) */
 	priv->write_reg(priv, SJA1000_ACCC0, 0x00);
@@ -208,9 +209,11 @@ static void sja1000_start(struct net_device *dev)
 	if (priv->can.state != CAN_STATE_STOPPED)
 		set_reset_mode(dev);
 
-	/* Initialize chip if uninitialized at this stage */
-	if (!(priv->read_reg(priv, SJA1000_CDR) & CDR_PELICAN))
-		chipset_init(dev);
+	if (!(priv->flags & SJA1000_NO_CDR_REG_QUIRK)) {
+		/* Initialize chip if uninitialized at this stage */
+		if (!(priv->read_reg(priv, SJA1000_CDR) & CDR_PELICAN))
+			chipset_init(dev);
+	}
 
 	/* Clear error counters and error code capture */
 	priv->write_reg(priv, SJA1000_TXERR, 0x0);
@@ -652,12 +655,14 @@ static const struct net_device_ops sja1000_netdev_ops = {
 
 int register_sja1000dev(struct net_device *dev)
 {
+	struct sja1000_priv *priv = netdev_priv(dev);
 	int ret;
 
 	if (!sja1000_probe_chip(dev))
 		return -ENODEV;
 
-	dev->flags |= IFF_ECHO;	/* we support local echo */
+	if (!(priv->flags & SJA1000_NO_HW_LOOPBACK_QUIRK))
+		dev->flags |= IFF_ECHO;	/* we support local echo */
 	dev->netdev_ops = &sja1000_netdev_ops;
 
 	set_reset_mode(dev);
diff --git a/drivers/net/can/sja1000/sja1000.h b/drivers/net/can/sja1000/sja1000.h
index 9d46398f8154..d0b8ce3f70ec 100644
--- a/drivers/net/can/sja1000/sja1000.h
+++ b/drivers/net/can/sja1000/sja1000.h
@@ -145,7 +145,9 @@
 /*
  * Flags for sja1000priv.flags
  */
-#define SJA1000_CUSTOM_IRQ_HANDLER 0x1
+#define SJA1000_CUSTOM_IRQ_HANDLER	BIT(0)
+#define SJA1000_NO_CDR_REG_QUIRK	BIT(1)
+#define SJA1000_NO_HW_LOOPBACK_QUIRK	BIT(2)
 
 /*
  * SJA1000 private data structure
-- 
2.25.1

