Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B17BC51E1FB
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 01:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377627AbiEFWqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 18:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377293AbiEFWqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 18:46:08 -0400
Received: from smtp3.emailarray.com (smtp3.emailarray.com [65.39.216.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B10062A15
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 15:42:24 -0700 (PDT)
Received: (qmail 21520 invoked by uid 89); 6 May 2022 22:42:14 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp3.emailarray.com with SMTP; 6 May 2022 22:42:14 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        lasse@timebeat.app, clk@fb.com
Subject: [PATCH net-next v4 2/2] net: phy: broadcom: Add Broadcom PTP hooks to bcm-phy-lib
Date:   Fri,  6 May 2022 15:42:10 -0700
Message-Id: <20220506224210.1425817-3-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.34.3
In-Reply-To: <20220506224210.1425817-1-jonathan.lemon@gmail.com>
References: <20220506224210.1425817-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 'struct bcm_ptp_private' to bcm54xx_phy_priv which points to
an optional PTP structure attached to the PHY.  This is allocated
on probe if PHY PTP support is configured, and if the driver supports
PTP for the specified PHY.

Add the bcm_ptp_probe() and bcm_ptp_config_init() API functions
to the bcm-phy library.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/bcm-phy-lib.h | 14 ++++++++++++++
 drivers/net/phy/broadcom.c    | 23 +++++++++++++++++++----
 2 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/bcm-phy-lib.h b/drivers/net/phy/bcm-phy-lib.h
index c3842f87c33b..c2cc3c2766a1 100644
--- a/drivers/net/phy/bcm-phy-lib.h
+++ b/drivers/net/phy/bcm-phy-lib.h
@@ -87,4 +87,18 @@ int bcm_phy_cable_test_start_rdb(struct phy_device *phydev);
 int bcm_phy_cable_test_start(struct phy_device *phydev);
 int bcm_phy_cable_test_get_status(struct phy_device *phydev, bool *finished);
 
+#if IS_ENABLED(CONFIG_BCM_NET_PHYPTP)
+struct bcm_ptp_private *bcm_ptp_probe(struct phy_device *phydev);
+void bcm_ptp_config_init(struct phy_device *phydev);
+#else
+static inline struct bcm_ptp_private *bcm_ptp_probe(struct phy_device *phydev)
+{
+	return NULL;
+}
+
+static inline void bcm_ptp_config_init(struct phy_device *phydev)
+{
+}
+#endif
+
 #endif /* _LINUX_BCM_PHY_LIB_H */
diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index e36809aa6d30..a7722599b5f9 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -27,6 +27,11 @@ MODULE_DESCRIPTION("Broadcom PHY driver");
 MODULE_AUTHOR("Maciej W. Rozycki");
 MODULE_LICENSE("GPL");
 
+struct bcm54xx_phy_priv {
+	u64	*stats;
+	struct bcm_ptp_private *ptp;
+};
+
 static int bcm54xx_config_clock_delay(struct phy_device *phydev)
 {
 	int rc, val;
@@ -313,6 +318,14 @@ static void bcm54xx_adjust_rxrefclk(struct phy_device *phydev)
 		bcm_phy_write_shadow(phydev, BCM54XX_SHD_APD, val);
 }
 
+static void bcm54xx_ptp_config_init(struct phy_device *phydev)
+{
+	struct bcm54xx_phy_priv *priv = phydev->priv;
+
+	if (priv->ptp)
+		bcm_ptp_config_init(phydev);
+}
+
 static int bcm54xx_config_init(struct phy_device *phydev)
 {
 	int reg, err, val;
@@ -390,6 +403,8 @@ static int bcm54xx_config_init(struct phy_device *phydev)
 		bcm_phy_write_exp(phydev, BCM_EXP_MULTICOLOR, val);
 	}
 
+	bcm54xx_ptp_config_init(phydev);
+
 	return 0;
 }
 
@@ -741,10 +756,6 @@ static irqreturn_t brcm_fet_handle_interrupt(struct phy_device *phydev)
 	return IRQ_HANDLED;
 }
 
-struct bcm54xx_phy_priv {
-	u64	*stats;
-};
-
 static int bcm54xx_phy_probe(struct phy_device *phydev)
 {
 	struct bcm54xx_phy_priv *priv;
@@ -761,6 +772,10 @@ static int bcm54xx_phy_probe(struct phy_device *phydev)
 	if (!priv->stats)
 		return -ENOMEM;
 
+	priv->ptp = bcm_ptp_probe(phydev);
+	if (IS_ERR(priv->ptp))
+		return PTR_ERR(priv->ptp);
+
 	return 0;
 }
 
-- 
2.34.3

