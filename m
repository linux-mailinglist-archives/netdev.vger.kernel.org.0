Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EADA06D7823
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 11:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237435AbjDEJ1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 05:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237301AbjDEJ1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 05:27:48 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148324ED7
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 02:27:35 -0700 (PDT)
Received: from dude02.red.stw.pengutronix.de ([2a0a:edc0:0:1101:1d::28])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <m.felsch@pengutronix.de>)
        id 1pjzQ1-0004pA-8W; Wed, 05 Apr 2023 11:27:05 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
Date:   Wed, 05 Apr 2023 11:26:54 +0200
Subject: [PATCH 03/12] net: phy: add phy_device_set_miits helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230405-net-next-topic-net-phy-reset-v1-3-7e5329f08002@pengutronix.de>
References: <20230405-net-next-topic-net-phy-reset-v1-0-7e5329f08002@pengutronix.de>
In-Reply-To: <20230405-net-next-topic-net-phy-reset-v1-0-7e5329f08002@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de
X-Mailer: b4 0.12.1
X-SA-Exim-Connect-IP: 2a0a:edc0:0:1101:1d::28
X-SA-Exim-Mail-From: m.felsch@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide a small setter helper to set the mii timestamper. The helper
detects possible overrides and hides the phydev internal from the
driver.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 drivers/net/phy/bcm-phy-ptp.c     |  2 +-
 drivers/net/phy/dp83640.c         |  2 +-
 drivers/net/phy/micrel.c          |  2 +-
 drivers/net/phy/mscc/mscc_ptp.c   |  2 +-
 drivers/net/phy/nxp-c45-tja11xx.c |  2 +-
 drivers/net/phy/phy_device.c      | 16 ++++++++++++++++
 include/linux/phy.h               |  2 ++
 7 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/bcm-phy-ptp.c b/drivers/net/phy/bcm-phy-ptp.c
index ef00d6163061..08bd3d96ce04 100644
--- a/drivers/net/phy/bcm-phy-ptp.c
+++ b/drivers/net/phy/bcm-phy-ptp.c
@@ -905,7 +905,7 @@ static void bcm_ptp_init(struct bcm_ptp_private *priv)
 	priv->mii_ts.hwtstamp = bcm_ptp_hwtstamp;
 	priv->mii_ts.ts_info = bcm_ptp_ts_info;
 
-	priv->phydev->mii_ts = &priv->mii_ts;
+	phy_device_set_miits(priv->phydev, &priv->mii_ts);
 }
 
 struct bcm_ptp_private *bcm_ptp_probe(struct phy_device *phydev)
diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index ef8b14135133..144c264cb4eb 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -1456,7 +1456,7 @@ static int dp83640_probe(struct phy_device *phydev)
 	for (i = 0; i < MAX_RXTS; i++)
 		list_add(&dp83640->rx_pool_data[i].list, &dp83640->rxpool);
 
-	phydev->mii_ts = &dp83640->mii_ts;
+	phy_device_set_miits(phydev, &dp83640->mii_ts);
 	phydev->priv = dp83640;
 
 	spin_lock_init(&dp83640->rx_lock);
diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 2184b1e859ae..d01c4157f704 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -3054,7 +3054,7 @@ static void lan8814_ptp_init(struct phy_device *phydev)
 	ptp_priv->mii_ts.hwtstamp = lan8814_hwtstamp;
 	ptp_priv->mii_ts.ts_info  = lan8814_ts_info;
 
-	phydev->mii_ts = &ptp_priv->mii_ts;
+	phy_device_set_miits(phydev, &ptp_priv->mii_ts);
 }
 
 static int lan8814_ptp_probe_once(struct phy_device *phydev)
diff --git a/drivers/net/phy/mscc/mscc_ptp.c b/drivers/net/phy/mscc/mscc_ptp.c
index cf728bfd83e2..8c38b4efcedc 100644
--- a/drivers/net/phy/mscc/mscc_ptp.c
+++ b/drivers/net/phy/mscc/mscc_ptp.c
@@ -1485,7 +1485,7 @@ static int __vsc8584_init_ptp(struct phy_device *phydev)
 	vsc8531->mii_ts.txtstamp = vsc85xx_txtstamp;
 	vsc8531->mii_ts.hwtstamp = vsc85xx_hwtstamp;
 	vsc8531->mii_ts.ts_info  = vsc85xx_ts_info;
-	phydev->mii_ts = &vsc8531->mii_ts;
+	phy_device_set_miits(phydev, &vsc8531->mii_ts);
 
 	memcpy(&vsc8531->ptp->caps, &vsc85xx_clk_caps, sizeof(vsc85xx_clk_caps));
 
diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 5813b07242ce..360812cea6d6 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -1326,7 +1326,7 @@ static int nxp_c45_probe(struct phy_device *phydev)
 		priv->mii_ts.txtstamp = nxp_c45_txtstamp;
 		priv->mii_ts.hwtstamp = nxp_c45_hwtstamp;
 		priv->mii_ts.ts_info = nxp_c45_ts_info;
-		phydev->mii_ts = &priv->mii_ts;
+		phy_device_set_miits(phydev, &priv->mii_ts);
 		ret = nxp_c45_init_ptp_clock(priv);
 	} else {
 		phydev_dbg(phydev, "PTP support not enabled even if the phy supports it");
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 64292e47e3fc..e4d08dcfed70 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -732,6 +732,22 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 }
 EXPORT_SYMBOL(phy_device_create);
 
+void phy_device_set_miits(struct phy_device *phydev,
+			  struct mii_timestamper *mii_ts)
+{
+	if (!phydev)
+		return;
+
+	if (phydev->mii_ts) {
+		phydev_dbg(phydev,
+			   "MII timestamper already set -> skip set\n");
+		return;
+	}
+
+	phydev->mii_ts = mii_ts;
+}
+EXPORT_SYMBOL(phy_device_set_miits);
+
 /* phy_c45_probe_present - checks to see if a MMD is present in the package
  * @bus: the target MII bus
  * @prtad: PHY package address on the MII bus
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 2f83cfc206e5..c17a98712555 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1541,6 +1541,8 @@ int phy_modify_paged(struct phy_device *phydev, int page, u32 regnum,
 struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 				     bool is_c45,
 				     struct phy_c45_device_ids *c45_ids);
+void phy_device_set_miits(struct phy_device *phydev,
+			  struct mii_timestamper *mii_ts);
 #if IS_ENABLED(CONFIG_PHYLIB)
 int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id);
 struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode);

-- 
2.39.2

