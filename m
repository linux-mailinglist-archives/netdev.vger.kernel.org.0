Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51BE7191291
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 15:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbgCXOOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 10:14:18 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54707 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbgCXOOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 10:14:18 -0400
Received: by mail-wm1-f68.google.com with SMTP id c81so3361014wmd.4
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 07:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1iBFFgLcJmT0udFPOHTPwJoN0ZRAA1zD3fe/aZ74L+4=;
        b=fzBd3Ux/vB6083aN//0mc2HUklcg048w2teniWx4e3DAVcx97IZGCPTKjHdoA0UIYY
         hUTnp75HauP/IuAeeNYRBc/7KLxGi5+C4vRzeykVZXiJ/y3DFZaWNIzQL21TqEZSo19J
         YJYDq3E+UeszqnKWgzLq4xsCJh+xWK0lF0DnJXEpQ/rRkFUB1cv821MgWk/4bpCeSSaN
         mFdZOMgRdpzgYPPTmzQrzKLdVf/nrTCv1p/EJC9xLrjiPYartEvePwyRKja96UdcN/qd
         dRUWsjAxl1E07xTF3Rf9Zvkfz+XpSBmFnylZ7Q3/TpOBAFK8a1fh4kIzR+f/kGWrx1kd
         4jxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1iBFFgLcJmT0udFPOHTPwJoN0ZRAA1zD3fe/aZ74L+4=;
        b=o3zAGD3RWVfAO5n7caaS/ST43nCRxIQsWgSqaF60l/Ka9gRbXtzWq92nfWoNP9PAK/
         7QKz1gT6YxcEDbTGFOwuB/CTKsqS6zQ7q6BzQ3mECoKgzZdNLoRwKeXYK3t+E3xwR6kG
         qNumABILCvmwxuQiP/0hmc6KF61lv5mvuhcdeiopl004ScbkR25X3XYvOTHKOeKYH/kz
         Qy+rVbBkOTYk+FyJLqXsSWdReu9rna9zq0oZNsDQtK9c3la5CKZO8Z/sGuY9YpO9IVyP
         EcCOXGOVW5F/tvQsDk/wS5cI9F9AQw1GzoQV/GHq89DXBcaHhNtEWkoXnItNFhlgbjmz
         FR0g==
X-Gm-Message-State: ANhLgQ3i+ueAhja9AotK8KXtnH4ZhY6PbK4SxYJaXGqNbAtvOTObiZlf
        rRtaqf1IyhiMgmMZ2UvdLMI=
X-Google-Smtp-Source: ADFU+vucxMhS57jNODqfb59llD+SUqWYXKC9veQjwPdcFn4C0tNYpnoY38wFf5CMRbh4sD6srv/HQw==
X-Received: by 2002:a1c:c3c3:: with SMTP id t186mr6054053wmf.118.1585059253763;
        Tue, 24 Mar 2020 07:14:13 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id t126sm4702871wmb.27.2020.03.24.07.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 07:14:13 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, antoine.tenart@bootlin.com
Subject: [PATCH net-next] net: phy: mscc: consolidate a common RGMII delay implementation
Date:   Tue, 24 Mar 2020 16:13:58 +0200
Message-Id: <20200324141358.4341-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

It looks like the VSC8584 PHY driver is rolling its own RGMII delay
configuration code, despite the fact that the logic is mostly the same.

In fact only the register layout and position for the RGMII controls has
changed. So we need to adapt and parameterize the PHY-dependent bit
fields when calling the new generic function.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Added back a comment containing the information from Antoine's patch.

 drivers/net/phy/mscc/mscc.h      | 28 ++++--------
 drivers/net/phy/mscc/mscc_main.c | 78 ++++++++++++++++----------------
 2 files changed, 49 insertions(+), 57 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index d983d3af66d6..030bf8b600df 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -161,25 +161,15 @@ enum rgmii_clock_delay {
 /* Extended Page 2 Registers */
 #define MSCC_PHY_CU_PMD_TX_CNTL		  16
 
-#define MSCC_PHY_RGMII_SETTINGS		  18
-#define RGMII_SKEW_RX_POS		  1
-#define RGMII_SKEW_TX_POS		  4
-
-/* RGMII skew values, in ns */
-#define VSC8584_RGMII_SKEW_0_2		  0
-#define VSC8584_RGMII_SKEW_0_8		  1
-#define VSC8584_RGMII_SKEW_1_1		  2
-#define VSC8584_RGMII_SKEW_1_7		  3
-#define VSC8584_RGMII_SKEW_2_0		  4
-#define VSC8584_RGMII_SKEW_2_3		  5
-#define VSC8584_RGMII_SKEW_2_6		  6
-#define VSC8584_RGMII_SKEW_3_4		  7
-
-#define MSCC_PHY_RGMII_CNTL		  20
-#define RGMII_RX_CLK_DELAY_MASK		  0x0070
-#define RGMII_RX_CLK_DELAY_POS		  4
-#define RGMII_TX_CLK_DELAY_MASK		  0x0007
-#define RGMII_TX_CLK_DELAY_POS		  0
+/* RGMII setting controls at address 18E2, for VSC8572 and similar */
+#define VSC8572_RGMII_CNTL		  18
+#define VSC8572_RGMII_RX_DELAY_MASK	  0x000E
+#define VSC8572_RGMII_TX_DELAY_MASK	  0x0070
+
+/* RGMII controls at address 20E2, for VSC8502 and similar */
+#define VSC8502_RGMII_CNTL		  20
+#define VSC8502_RGMII_RX_DELAY_MASK	  0x0070
+#define VSC8502_RGMII_TX_DELAY_MASK	  0x0007
 
 #define MSCC_PHY_WOL_LOWER_MAC_ADDR	  21
 #define MSCC_PHY_WOL_MID_MAC_ADDR	  22
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 19603081dd14..acddef79f4e8 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -520,28 +520,34 @@ static int vsc85xx_mac_if_set(struct phy_device *phydev,
 	return rc;
 }
 
-static int vsc85xx_default_config(struct phy_device *phydev)
+/* Set the RGMII RX and TX clock skews individually, according to the PHY
+ * interface type, to:
+ *  * 0.2 ns (their default, and lowest, hardware value) if delays should
+ *    not be enabled
+ *  * 2.0 ns (which causes the data to be sampled at exactly half way between
+ *    clock transitions at 1000 Mbps) if delays should be enabled
+ */
+static int vsc85xx_rgmii_set_skews(struct phy_device *phydev, u32 rgmii_cntl,
+				   u16 rgmii_rx_delay_mask,
+				   u16 rgmii_tx_delay_mask)
 {
+	u16 rgmii_rx_delay_pos = ffs(rgmii_rx_delay_mask) - 1;
+	u16 rgmii_tx_delay_pos = ffs(rgmii_tx_delay_mask) - 1;
 	u16 reg_val = 0;
 	int rc;
 
-	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
-
-	if (!phy_interface_mode_is_rgmii(phydev->interface))
-		return 0;
-
 	mutex_lock(&phydev->lock);
 
 	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID ||
 	    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
-		reg_val |= RGMII_CLK_DELAY_2_0_NS << RGMII_RX_CLK_DELAY_POS;
+		reg_val |= RGMII_CLK_DELAY_2_0_NS << rgmii_rx_delay_pos;
 	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID ||
 	    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
-		reg_val |= RGMII_CLK_DELAY_2_0_NS << RGMII_TX_CLK_DELAY_POS;
+		reg_val |= RGMII_CLK_DELAY_2_0_NS << rgmii_tx_delay_pos;
 
 	rc = phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_2,
-			      MSCC_PHY_RGMII_CNTL,
-			      RGMII_RX_CLK_DELAY_MASK | RGMII_TX_CLK_DELAY_MASK,
+			      rgmii_cntl,
+			      rgmii_rx_delay_mask | rgmii_tx_delay_mask,
 			      reg_val);
 
 	mutex_unlock(&phydev->lock);
@@ -549,6 +555,23 @@ static int vsc85xx_default_config(struct phy_device *phydev)
 	return rc;
 }
 
+static int vsc85xx_default_config(struct phy_device *phydev)
+{
+	int rc;
+
+	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
+
+	if (phy_interface_mode_is_rgmii(phydev->interface)) {
+		rc = vsc85xx_rgmii_set_skews(phydev, VSC8502_RGMII_CNTL,
+					     VSC8502_RGMII_RX_DELAY_MASK,
+					     VSC8502_RGMII_TX_DELAY_MASK);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
 static int vsc85xx_get_tunable(struct phy_device *phydev,
 			       struct ethtool_tunable *tuna, void *data)
 {
@@ -1301,32 +1324,6 @@ static bool vsc8584_is_pkg_init(struct phy_device *phydev, bool reversed)
 	return false;
 }
 
-static void vsc8584_rgmii_set_skews(struct phy_device *phydev)
-{
-	u32 skew_rx, skew_tx;
-
-	/* We first set the Rx and Tx skews to their default value in h/w
-	 * (0.2 ns).
-	 */
-	skew_rx = VSC8584_RGMII_SKEW_0_2;
-	skew_tx = VSC8584_RGMII_SKEW_0_2;
-
-	/* We then set the skews based on the interface mode. */
-	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
-	    phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID)
-		skew_rx = VSC8584_RGMII_SKEW_2_0;
-	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
-	    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
-		skew_tx = VSC8584_RGMII_SKEW_2_0;
-
-	/* Finally we apply the skews configuration. */
-	phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_2,
-			 MSCC_PHY_RGMII_SETTINGS,
-			 (0x7 << RGMII_SKEW_RX_POS) | (0x7 << RGMII_SKEW_TX_POS),
-			 (skew_rx << RGMII_SKEW_RX_POS) |
-			 (skew_tx << RGMII_SKEW_TX_POS));
-}
-
 static int vsc8584_config_init(struct phy_device *phydev)
 {
 	struct vsc8531_private *vsc8531 = phydev->priv;
@@ -1461,8 +1458,13 @@ static int vsc8584_config_init(struct phy_device *phydev)
 	if (ret)
 		return ret;
 
-	if (phy_interface_is_rgmii(phydev))
-		vsc8584_rgmii_set_skews(phydev);
+	if (phy_interface_is_rgmii(phydev)) {
+		ret = vsc85xx_rgmii_set_skews(phydev, VSC8572_RGMII_CNTL,
+					      VSC8572_RGMII_RX_DELAY_MASK,
+					      VSC8572_RGMII_TX_DELAY_MASK);
+		if (ret)
+			return ret;
+	}
 
 	ret = genphy_soft_reset(phydev);
 	if (ret)
-- 
2.17.1

