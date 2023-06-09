Return-Path: <netdev+bounces-9465-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 580A7729475
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 11:14:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A687228184B
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 09:14:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00502134B9;
	Fri,  9 Jun 2023 09:13:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C3012B8F
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:13:10 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF09849D1
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 02:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ZHWijGJtmkjAdNJ3epNx1+PdAwLQDCdz/WHVB8d93To=; b=toGW+cMXFNxxE3uplAj0l6ldf2
	KezlnZZl9whY/nT4iN67FayKhXipsvHsGc/H1OuMrKVlZ7X1diW+9JNRfeMSkmcvoOhW8kcmWQ3hc
	kxvf3MCzJvpo6ypbi39Oe6jPacAEMROjWfgYqo19gvAlWnoUnjUYRzgUX1xVm1sAr6O+Rf+vACaxI
	iVUQJwP/lRyMzXFBeEgzCMBddAVXviWXCdzQx5r9ic844mIakfpacwfpbIt32HhFU/HUujYHkkymw
	690HTzSGdNGsGNXo9PTunblAxwatihvk3xuIG8XK0bXTP9PCZCkViXdFFcmnbqD68skQZxSt06/u3
	7ZI8P4sA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:42424 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q7Y9X-0001jo-6c; Fri, 09 Jun 2023 10:11:27 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q7Y9W-00DI8m-Jo; Fri, 09 Jun 2023 10:11:26 +0100
In-Reply-To: <ZILsqV0gkSMMdinU@shell.armlinux.org.uk>
References: <ZILsqV0gkSMMdinU@shell.armlinux.org.uk>
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Marcin Wojtas <mw@semihalf.com>,
	netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH RFC net-next 3/4] net: mvneta: convert to phylink EEE
 implementation
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q7Y9W-00DI8m-Jo@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Fri, 09 Jun 2023 10:11:26 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Convert mvneta to use phylink's EEE implementation, which means we just
need to implement the two methods for LPI control, and adding the
initial configuration.

Disabling LPI requires clearing a single bit. Enabling LPI needs a full
configuration of several values, as the timer values are dependent on
the MAC operating speed.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvneta.c | 95 +++++++++++++++++----------
 1 file changed, 61 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index e2abc00d0472..c634ec5d3f9a 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -284,8 +284,10 @@
 					  MVNETA_TXQ_BUCKET_REFILL_PERIOD))
 
 #define MVNETA_LPI_CTRL_0                        0x2cc0
+#define      MVNETA_LPI_CTRL_0_TS                0xff << 8
 #define MVNETA_LPI_CTRL_1                        0x2cc4
 #define      MVNETA_LPI_REQUEST_ENABLE           BIT(0)
+#define      MVNETA_LPI_CTRL_1_TW                0xfff << 4
 #define MVNETA_LPI_CTRL_2                        0x2cc8
 #define MVNETA_LPI_STATUS                        0x2ccc
 
@@ -541,10 +543,6 @@ struct mvneta_port {
 	struct mvneta_bm_pool *pool_short;
 	int bm_win_id;
 
-	bool eee_enabled;
-	bool eee_active;
-	bool tx_lpi_enabled;
-
 	u64 ethtool_stats[ARRAY_SIZE(mvneta_statistics)];
 
 	u32 indir[MVNETA_RSS_LU_TABLE_SIZE];
@@ -4232,9 +4230,6 @@ static void mvneta_mac_link_down(struct phylink_config *config,
 		val |= MVNETA_GMAC_FORCE_LINK_DOWN;
 		mvreg_write(pp, MVNETA_GMAC_AUTONEG_CONFIG, val);
 	}
-
-	pp->eee_active = false;
-	mvneta_set_eee(pp, false);
 }
 
 static void mvneta_mac_link_up(struct phylink_config *config,
@@ -4283,11 +4278,57 @@ static void mvneta_mac_link_up(struct phylink_config *config,
 	}
 
 	mvneta_port_up(pp);
+}
+
+static void mvneta_mac_disable_tx_lpi(struct phylink_config *config)
+{
+	struct mvneta_port *pp = netdev_priv(to_net_dev(config->dev));
+	u32 lpi1;
+
+	lpi1 = mvreg_read(pp, MVNETA_LPI_CTRL_1);
+	lpi1 &= ~MVNETA_LPI_REQUEST_ENABLE;
+	mvreg_write(pp, MVNETA_LPI_CTRL_1, lpi1);
+}
 
-	if (phy && pp->eee_enabled) {
-		pp->eee_active = phy_init_eee(phy, false) >= 0;
-		mvneta_set_eee(pp, pp->eee_active && pp->tx_lpi_enabled);
+static void mvneta_mac_enable_tx_lpi(struct phylink_config *config, u32 timer)
+{
+	struct mvneta_port *pp = netdev_priv(to_net_dev(config->dev));
+	u32 ts, tw, lpi0, lpi1, status;
+
+	status = mvreg_read(pp, MVNETA_GMAC_STATUS);
+
+	if (status & MVNETA_GMAC_SPEED_1000) {
+		/* At 1G speeds, the timer resolution are 1us, and
+		 * 802.3 says tw is 16.5us. Round up to 17us.
+		 */
+		tw = 17;
+		ts = timer;
+	} else {
+		/* At 100M speeds, the timer resolutions are 10us, and
+		 * 802.3 says tw is 30us.
+		 */
+		tw = 3;
+		ts = DIV_ROUND_UP(timer, 10);
 	}
+
+	if (ts > 255)
+		ts = 255;
+
+	/* Ensure LPI generation is disabled */
+	lpi1 = mvreg_read(pp, MVNETA_LPI_CTRL_1);
+	mvreg_write(pp, MVNETA_LPI_CTRL_1, lpi1 & ~MVNETA_LPI_REQUEST_ENABLE);
+
+	/* Configure ts */
+	lpi0 = mvreg_read(pp, MVNETA_LPI_CTRL_0) & ~MVNETA_LPI_CTRL_0_TS;
+	lpi0 |= FIELD_PREP(MVNETA_LPI_CTRL_0_TS, ts);
+	mvreg_write(pp, MVNETA_LPI_CTRL_0, lpi0);
+
+	/* Configure tw */
+	lpi1 &= ~MVNETA_LPI_CTRL_1_TW;
+	lpi1 |= FIELD_PREP(MVNETA_LPI_CTRL_1_TW, tw);
+
+	/* Enable LPI generation */
+	mvreg_write(pp, MVNETA_LPI_CTRL_1, lpi1 | MVNETA_LPI_REQUEST_ENABLE);
 }
 
 static const struct phylink_mac_ops mvneta_phylink_ops = {
@@ -4297,6 +4338,8 @@ static const struct phylink_mac_ops mvneta_phylink_ops = {
 	.mac_finish = mvneta_mac_finish,
 	.mac_link_down = mvneta_mac_link_down,
 	.mac_link_up = mvneta_mac_link_up,
+	.mac_disable_tx_lpi = mvneta_mac_disable_tx_lpi,
+	.mac_enable_tx_lpi = mvneta_mac_enable_tx_lpi,
 };
 
 static int mvneta_mdio_probe(struct mvneta_port *pp)
@@ -5087,14 +5130,6 @@ static int mvneta_ethtool_get_eee(struct net_device *dev,
 				  struct ethtool_eee *eee)
 {
 	struct mvneta_port *pp = netdev_priv(dev);
-	u32 lpi_ctl0;
-
-	lpi_ctl0 = mvreg_read(pp, MVNETA_LPI_CTRL_0);
-
-	eee->eee_enabled = pp->eee_enabled;
-	eee->eee_active = pp->eee_active;
-	eee->tx_lpi_enabled = pp->tx_lpi_enabled;
-	eee->tx_lpi_timer = (lpi_ctl0) >> 8; // * scale;
 
 	return phylink_ethtool_get_eee(pp->phylink, eee);
 }
@@ -5103,23 +5138,10 @@ static int mvneta_ethtool_set_eee(struct net_device *dev,
 				  struct ethtool_eee *eee)
 {
 	struct mvneta_port *pp = netdev_priv(dev);
-	u32 lpi_ctl0;
 
-	/* The Armada 37x documents do not give limits for this other than
-	 * it being an 8-bit register.
-	 */
-	if (eee->tx_lpi_enabled && eee->tx_lpi_timer > 255)
-		return -EINVAL;
-
-	lpi_ctl0 = mvreg_read(pp, MVNETA_LPI_CTRL_0);
-	lpi_ctl0 &= ~(0xff << 8);
-	lpi_ctl0 |= eee->tx_lpi_timer << 8;
-	mvreg_write(pp, MVNETA_LPI_CTRL_0, lpi_ctl0);
-
-	pp->eee_enabled = eee->eee_enabled;
-	pp->tx_lpi_enabled = eee->tx_lpi_enabled;
-
-	mvneta_set_eee(pp, eee->tx_lpi_enabled && eee->eee_enabled);
+	/* clamp tx_lpi_timer */
+	if (eee->tx_lpi_timer > 255)
+		eee->tx_lpi_timer = 255;
 
 	return phylink_ethtool_set_eee(pp->phylink, eee);
 }
@@ -5550,6 +5572,11 @@ static int mvneta_probe(struct platform_device *pdev)
 			  pp->phylink_config.supported_interfaces);
 	}
 
+	/* Setup EEE.  Choose 250us idle. */
+	pp->phylink_config.eee.eee_enabled = true;
+	pp->phylink_config.eee.tx_lpi_enabled = true;
+	pp->phylink_config.eee.tx_lpi_timer = 250;
+
 	phylink = phylink_create(&pp->phylink_config, pdev->dev.fwnode,
 				 phy_mode, &mvneta_phylink_ops);
 	if (IS_ERR(phylink)) {
-- 
2.30.2


