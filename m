Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 628FD5646DA
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 12:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbiGCKrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 06:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232431AbiGCKrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 06:47:37 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7467BAE56;
        Sun,  3 Jul 2022 03:47:30 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.92,241,1650898800"; 
   d="scan'208";a="126488408"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 03 Jul 2022 19:47:30 +0900
Received: from localhost.localdomain (unknown [10.226.92.2])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 2B67A427AC5C;
        Sun,  3 Jul 2022 19:47:24 +0900 (JST)
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
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 3/6] can: sja1000: Add Quirk for RZ/N1 SJA1000 CAN controller
Date:   Sun,  3 Jul 2022 11:47:02 +0100
Message-Id: <20220703104705.341070-4-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220703104705.341070-1-biju.das.jz@bp.renesas.com>
References: <20220703104705.341070-1-biju.das.jz@bp.renesas.com>
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

As per Chapter 6.5.16 of the RZ/N1 Peripheral Manual, The SJA1000
CAN controller does not support Clock Divider Register compared to
the reference Philips SJA1000 device.

This patch adds a device quirk to handle this difference.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
v1->v2:
 * Updated commit description
 * Removed the quirk macro SJA1000_NO_HW_LOOPBACK_QUIRK
 * Added prefix SJA1000_QUIRK_* for quirk macro.
---
 drivers/net/can/sja1000/sja1000.c | 13 ++++++++-----
 drivers/net/can/sja1000/sja1000.h |  3 ++-
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
index 2e7638f98cf1..e9c55f5aa3c3 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -183,8 +183,9 @@ static void chipset_init(struct net_device *dev)
 {
 	struct sja1000_priv *priv = netdev_priv(dev);
 
-	/* set clock divider and output control register */
-	priv->write_reg(priv, SJA1000_CDR, priv->cdr | CDR_PELICAN);
+	if (!(priv->flags & SJA1000_QUIRK_NO_CDR_REG))
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
+	if (!(priv->flags & SJA1000_QUIRK_NO_CDR_REG)) {
+		/* Initialize chip if uninitialized at this stage */
+		if (!(priv->read_reg(priv, SJA1000_CDR) & CDR_PELICAN))
+			chipset_init(dev);
+	}
 
 	/* Clear error counters and error code capture */
 	priv->write_reg(priv, SJA1000_TXERR, 0x0);
diff --git a/drivers/net/can/sja1000/sja1000.h b/drivers/net/can/sja1000/sja1000.h
index 9d46398f8154..7f736f1df547 100644
--- a/drivers/net/can/sja1000/sja1000.h
+++ b/drivers/net/can/sja1000/sja1000.h
@@ -145,7 +145,8 @@
 /*
  * Flags for sja1000priv.flags
  */
-#define SJA1000_CUSTOM_IRQ_HANDLER 0x1
+#define SJA1000_CUSTOM_IRQ_HANDLER	BIT(0)
+#define SJA1000_QUIRK_NO_CDR_REG	BIT(1)
 
 /*
  * SJA1000 private data structure
-- 
2.25.1

