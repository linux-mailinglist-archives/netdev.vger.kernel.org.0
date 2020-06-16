Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1814C1FAB41
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 10:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbgFPIby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 04:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727876AbgFPIbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 04:31:52 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD99C05BD43
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 01:31:52 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1jl70Q-0002wZ-Oz; Tue, 16 Jun 2020 10:31:42 +0200
Received: from sha by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1jl70P-0002HP-4b; Tue, 16 Jun 2020 10:31:41 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel@pengutronix.de, Russell King <linux@armlinux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 1/2] net: ethernet: mvneta: Fix Serdes configuration for SoCs without comphy
Date:   Tue, 16 Jun 2020 10:31:39 +0200
Message-Id: <20200616083140.8498-1-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MVNETA_SERDES_CFG register is only available on older SoCs like the
Armada XP. On newer SoCs like the Armada 38x the fields are moved to
comphy. This patch moves the writes to this register next to the comphy
initialization, so that depending on the SoC either comphy or
MVNETA_SERDES_CFG is configured.
With this we no longer write to the MVNETA_SERDES_CFG on SoCs where it
doesn't exist.

Suggested-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/net/ethernet/marvell/mvneta.c | 80 +++++++++++++++------------
 1 file changed, 44 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 51889770958d8..9933eb4577d43 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -106,6 +106,7 @@
 #define      MVNETA_TX_IN_PRGRS                  BIT(1)
 #define      MVNETA_TX_FIFO_EMPTY                BIT(8)
 #define MVNETA_RX_MIN_FRAME_SIZE                 0x247c
+/* Only exists on Armada XP and Armada 370 */
 #define MVNETA_SERDES_CFG			 0x24A0
 #define      MVNETA_SGMII_SERDES_PROTO		 0x0cc7
 #define      MVNETA_QSGMII_SERDES_PROTO		 0x0667
@@ -3514,26 +3515,55 @@ static int mvneta_setup_txqs(struct mvneta_port *pp)
 	return 0;
 }
 
-static int mvneta_comphy_init(struct mvneta_port *pp)
+static int mvneta_comphy_init(struct mvneta_port *pp, phy_interface_t interface)
 {
 	int ret;
 
-	if (!pp->comphy)
-		return 0;
-
-	ret = phy_set_mode_ext(pp->comphy, PHY_MODE_ETHERNET,
-			       pp->phy_interface);
+	ret = phy_set_mode_ext(pp->comphy, PHY_MODE_ETHERNET, interface);
 	if (ret)
 		return ret;
 
 	return phy_power_on(pp->comphy);
 }
 
+static int mvneta_config_interface(struct mvneta_port *pp,
+				   phy_interface_t interface)
+{
+	int ret = 0;
+
+	if (pp->comphy) {
+		if (interface == PHY_INTERFACE_MODE_SGMII ||
+		    interface == PHY_INTERFACE_MODE_1000BASEX ||
+		    interface == PHY_INTERFACE_MODE_2500BASEX) {
+			ret = mvneta_comphy_init(pp, interface);
+		}
+	} else {
+		switch (interface) {
+		case PHY_INTERFACE_MODE_QSGMII:
+			mvreg_write(pp, MVNETA_SERDES_CFG,
+				    MVNETA_QSGMII_SERDES_PROTO);
+			break;
+
+		case PHY_INTERFACE_MODE_SGMII:
+		case PHY_INTERFACE_MODE_1000BASEX:
+			mvreg_write(pp, MVNETA_SERDES_CFG,
+				    MVNETA_SGMII_SERDES_PROTO);
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+
+	pp->phy_interface = interface;
+
+	return ret;
+}
+
 static void mvneta_start_dev(struct mvneta_port *pp)
 {
 	int cpu;
 
-	WARN_ON(mvneta_comphy_init(pp));
+	WARN_ON(mvneta_config_interface(pp, pp->phy_interface));
 
 	mvneta_max_rx_size_set(pp, pp->pkt_size);
 	mvneta_txq_max_tx_size_set(pp, pp->pkt_size);
@@ -3907,14 +3937,10 @@ static void mvneta_mac_config(struct phylink_config *config, unsigned int mode,
 	if (state->speed == SPEED_2500)
 		new_ctrl4 |= MVNETA_GMAC4_SHORT_PREAMBLE_ENABLE;
 
-	if (pp->comphy && pp->phy_interface != state->interface &&
-	    (state->interface == PHY_INTERFACE_MODE_SGMII ||
-	     state->interface == PHY_INTERFACE_MODE_1000BASEX ||
-	     state->interface == PHY_INTERFACE_MODE_2500BASEX)) {
-		pp->phy_interface = state->interface;
-
-		WARN_ON(phy_power_off(pp->comphy));
-		WARN_ON(mvneta_comphy_init(pp));
+	if (pp->phy_interface != state->interface) {
+		if (pp->comphy)
+			WARN_ON(phy_power_off(pp->comphy));
+		WARN_ON(mvneta_config_interface(pp, state->interface));
 	}
 
 	if (new_ctrl0 != gmac_ctrl0)
@@ -4958,20 +4984,10 @@ static void mvneta_conf_mbus_windows(struct mvneta_port *pp,
 }
 
 /* Power up the port */
-static int mvneta_port_power_up(struct mvneta_port *pp, int phy_mode)
+static void mvneta_port_power_up(struct mvneta_port *pp, int phy_mode)
 {
 	/* MAC Cause register should be cleared */
 	mvreg_write(pp, MVNETA_UNIT_INTR_CAUSE, 0);
-
-	if (phy_mode == PHY_INTERFACE_MODE_QSGMII)
-		mvreg_write(pp, MVNETA_SERDES_CFG, MVNETA_QSGMII_SERDES_PROTO);
-	else if (phy_mode == PHY_INTERFACE_MODE_SGMII ||
-		 phy_interface_mode_is_8023z(phy_mode))
-		mvreg_write(pp, MVNETA_SERDES_CFG, MVNETA_SGMII_SERDES_PROTO);
-	else if (!phy_interface_mode_is_rgmii(phy_mode))
-		return -EINVAL;
-
-	return 0;
 }
 
 /* Device initialization routine */
@@ -5157,11 +5173,7 @@ static int mvneta_probe(struct platform_device *pdev)
 	if (err < 0)
 		goto err_netdev;
 
-	err = mvneta_port_power_up(pp, phy_mode);
-	if (err < 0) {
-		dev_err(&pdev->dev, "can't power up port\n");
-		goto err_netdev;
-	}
+	mvneta_port_power_up(pp, phy_mode);
 
 	/* Armada3700 network controller does not support per-cpu
 	 * operation, so only single NAPI should be initialized.
@@ -5315,11 +5327,7 @@ static int mvneta_resume(struct device *device)
 		}
 	}
 	mvneta_defaults_set(pp);
-	err = mvneta_port_power_up(pp, pp->phy_interface);
-	if (err < 0) {
-		dev_err(device, "can't power up port\n");
-		return err;
-	}
+	mvneta_port_power_up(pp, pp->phy_interface);
 
 	netif_device_attach(dev);
 
-- 
2.27.0

