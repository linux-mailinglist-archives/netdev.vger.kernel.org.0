Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5FB50CE72
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 04:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237689AbiDXC1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 22:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237678AbiDXC1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 22:27:02 -0400
Received: from smtp4.emailarray.com (smtp4.emailarray.com [65.39.216.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15A123BF0
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 19:24:02 -0700 (PDT)
Received: (qmail 73465 invoked by uid 89); 24 Apr 2022 02:24:01 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp4.emailarray.com with SMTP; 24 Apr 2022 02:24:01 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next v1 3/4] net: phy: broadcom: Hook up the PTP PHY functions
Date:   Sat, 23 Apr 2022 19:23:55 -0700
Message-Id: <20220424022356.587949-4-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220424022356.587949-1-jonathan.lemon@gmail.com>
References: <20220424022356.587949-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 'struct bcm_ptp_private' to bcm54xx_phy_priv which points to
an optional PTP structure attached to the PHY.  This is allocated
on probe, if PHY PTP support is configured, and if the PHY has a
PTP supported by the driver.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/net/phy/broadcom.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

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
2.31.1

