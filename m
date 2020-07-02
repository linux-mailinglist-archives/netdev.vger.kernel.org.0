Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB10211897
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 03:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgGBBXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 21:23:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:53936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728307AbgGBBXX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 21:23:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 904B82083E;
        Thu,  2 Jul 2020 01:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653002;
        bh=SDsC3WYUWbDqFtf8OSpck0pZHtY5L6+8Nqok/8gyQcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FcJ9tKB7j5g8j0a8UwBj1bJpJHKPL05A85WevbZuVsbSxtQAfi6ZmcdL3/KY8WdvH
         pQIScTwQmIwERSZOn4lP7IoNN/cn778izu71RLwNRtel9SetSiDRq9asBiBlJUz1ot
         MdXVWJSBXleo40+8G+YkZtpwQ9/c4gXM1m/HQUEA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 22/53] net: ethernet: mvneta: Fix Serdes configuration for SoCs without comphy
Date:   Wed,  1 Jul 2020 21:21:31 -0400
Message-Id: <20200702012202.2700645-22-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012202.2700645-1-sashal@kernel.org>
References: <20200702012202.2700645-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit b4748553f53f2971e07d2619f13d461daac0f3bb ]

The MVNETA_SERDES_CFG register is only available on older SoCs like the
Armada XP. On newer SoCs like the Armada 38x the fields are moved to
comphy. This patch moves the writes to this register next to the comphy
initialization, so that depending on the SoC either comphy or
MVNETA_SERDES_CFG is configured.
With this we no longer write to the MVNETA_SERDES_CFG on SoCs where it
doesn't exist.

Suggested-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 80 +++++++++++++++------------
 1 file changed, 44 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 43b44a1e8f69e..401eeeca89660 100644
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
@@ -3523,26 +3524,55 @@ static int mvneta_setup_txqs(struct mvneta_port *pp)
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
@@ -3920,14 +3950,10 @@ static void mvneta_mac_config(struct phylink_config *config, unsigned int mode,
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
@@ -4971,20 +4997,10 @@ static void mvneta_conf_mbus_windows(struct mvneta_port *pp,
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
@@ -5170,11 +5186,7 @@ static int mvneta_probe(struct platform_device *pdev)
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
@@ -5328,11 +5340,7 @@ static int mvneta_resume(struct device *device)
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
2.25.1

