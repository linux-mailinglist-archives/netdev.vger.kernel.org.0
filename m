Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D89327CFC
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 12:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbhCALTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 06:19:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbhCALTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 06:19:00 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14648C061356
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 03:18:41 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id d13so15116026edp.4
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 03:18:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gG4fa3Fc6yf+mOmtYOYZ0TJQvAaAscCQQkSVOKBJq9k=;
        b=g8xhFFRT9wNeRgEcHAIqXZnPZQK9DmUzqHlLY7L0neSsBeQVdi3j1vaEVNER/KjV59
         mg0O7aJYNVgbr0aCPbIM3jDutqQHrRgm/sgmWvGly5zw6NvsKIkpOuu1EZvgNOKfIwv7
         Iu9UCQ/CNXe6apYzrLYne6SFCzQ5GoRwyu4GWu7+D1FUA7VzhAvjVsOe1EEIcC0jR6Kp
         9Y3T2/rT2/HQ/lXTcJVJDZ+85VDMS1UdOA+vthy8OraGU2jqCF+CdBeExGBcC1Cs+ptQ
         54YmlSCbhaUrXQffFcvROgSWmvKZNbu6TellauvKytv9TZ/BnxufJIXNotUab6UfLVIi
         ADFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gG4fa3Fc6yf+mOmtYOYZ0TJQvAaAscCQQkSVOKBJq9k=;
        b=l4EwKPyhiJcCfA0TfsmQ/F9dRCTHLBWjJYB19MCR37WrfBSnbaV3o51IQo+HzGVS3B
         2PyCwBZNA7g6Bnls7yzAiiiUohpfATQ4OAH8acg797UPMwYb4vfScOdvaOVPaPWzYJPT
         DA4yHNJakLOdqJ+hJA0m0reVTzFIybi2fVkswJtFiXl91pM5R8loMfgCBhdjZupHcjHa
         lCmOQo3MZMRJO7hVOwaLuotErKytSUAr4E9aJZdRDJ1XGAGHaa1LFuUu0TfBoNuPnMU6
         GR/osHGAqgADXJcG7wv52cV3xMMuR0SZpB6LPpxf6YLrYxYG61LDlwHAuJnokOGmz90Y
         QD/Q==
X-Gm-Message-State: AOAM532FzADjLAV2wzhUwBAG/Umms2Csi7H2gA5egy9he1h2JcAqvz97
        nVsGC1O9WzMU/A0ziw/vcgg=
X-Google-Smtp-Source: ABdhPJz93xzBBydhk/Fh+7J/+hV2/NfH1f/2UTtWavhjJSubtFrXBEWkoxlButT1uxsMUepJjyTRhg==
X-Received: by 2002:aa7:ca57:: with SMTP id j23mr16092611edt.293.1614597519886;
        Mon, 01 Mar 2021 03:18:39 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id i13sm13586491ejj.2.2021.03.01.03.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 03:18:39 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH v3 net 6/8] net: enetc: force the RGMII speed and duplex instead of operating in inband mode
Date:   Mon,  1 Mar 2021 13:18:16 +0200
Message-Id: <20210301111818.2081582-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210301111818.2081582-1-olteanv@gmail.com>
References: <20210301111818.2081582-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The ENETC port 0 MAC supports in-band status signaling coming from a PHY
when operating in RGMII mode, and this feature is enabled by default.

It has been reported that RGMII is broken in fixed-link, and that is not
surprising considering the fact that no PHY is attached to the MAC in
that case, but a switch.

This brings us to the topic of the patch: the enetc driver should have
not enabled the optional in-band status signaling for RGMII unconditionally,
but should have forced the speed and duplex to what was resolved by
phylink.

Note that phylink does not accept the RGMII modes as valid for in-band
signaling, and these operate a bit differently than 1000base-x and SGMII
(notably there is no clause 37 state machine so no ACK required from the
MAC, instead the PHY sends extra code words on RXD[3:0] whenever it is
not transmitting something else, so it should be safe to leave a PHY
with this option unconditionally enabled even if we ignore it). The spec
talks about this here:
https://e2e.ti.com/cfs-file/__key/communityserver-discussions-components-files/138/RGMIIv1_5F00_3.pdf

Fixes: 71b77a7a27a3 ("enetc: Migrate to PHYLINK and PCS_LYNX")
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
---
Changes in v3:
Removed the extra "mode" argument passed to enetc_mac_config which was a
leftover from v1 (we no longer look at it).

Changes in v2:
- Don't write to the MAC if speed and duplex did not change.
- Don't update the speed with the MAC enabled.
- Remove the logic for enabling in-band signaling in enetc_mac_config.

 .../net/ethernet/freescale/enetc/enetc_hw.h   | 13 +++--
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 53 ++++++++++++++++---
 2 files changed, 56 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index a62604a1e54e..de0d20b0f489 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -238,10 +238,17 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_PM_IMDIO_BASE	0x8030
 
 #define ENETC_PM0_IF_MODE	0x8300
-#define ENETC_PMO_IFM_RG	BIT(2)
+#define ENETC_PM0_IFM_RG	BIT(2)
 #define ENETC_PM0_IFM_RLP	(BIT(5) | BIT(11))
-#define ENETC_PM0_IFM_RGAUTO	(BIT(15) | ENETC_PMO_IFM_RG | BIT(1))
-#define ENETC_PM0_IFM_XGMII	BIT(12)
+#define ENETC_PM0_IFM_EN_AUTO	BIT(15)
+#define ENETC_PM0_IFM_SSP_MASK	GENMASK(14, 13)
+#define ENETC_PM0_IFM_SSP_1000	(2 << 13)
+#define ENETC_PM0_IFM_SSP_100	(0 << 13)
+#define ENETC_PM0_IFM_SSP_10	(1 << 13)
+#define ENETC_PM0_IFM_FULL_DPX	BIT(12)
+#define ENETC_PM0_IFM_IFMODE_MASK GENMASK(1, 0)
+#define ENETC_PM0_IFM_IFMODE_XGMII 0
+#define ENETC_PM0_IFM_IFMODE_GMII 2
 #define ENETC_PSIDCAPR		0x1b08
 #define ENETC_PSIDCAPR_MSK	GENMASK(15, 0)
 #define ENETC_PSFCAPR		0x1b18
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 49681a0566ed..ca02f033bea2 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -315,7 +315,7 @@ static void enetc_set_loopback(struct net_device *ndev, bool en)
 	u32 reg;
 
 	reg = enetc_port_rd(hw, ENETC_PM0_IF_MODE);
-	if (reg & ENETC_PMO_IFM_RG) {
+	if (reg & ENETC_PM0_IFM_RG) {
 		/* RGMII mode */
 		reg = (reg & ~ENETC_PM0_IFM_RLP) |
 		      (en ? ENETC_PM0_IFM_RLP : 0);
@@ -494,13 +494,20 @@ static void enetc_configure_port_mac(struct enetc_hw *hw)
 
 static void enetc_mac_config(struct enetc_hw *hw, phy_interface_t phy_mode)
 {
-	/* set auto-speed for RGMII */
-	if (enetc_port_rd(hw, ENETC_PM0_IF_MODE) & ENETC_PMO_IFM_RG ||
-	    phy_interface_mode_is_rgmii(phy_mode))
-		enetc_port_wr(hw, ENETC_PM0_IF_MODE, ENETC_PM0_IFM_RGAUTO);
+	u32 val;
+
+	if (phy_interface_mode_is_rgmii(phy_mode)) {
+		val = enetc_port_rd(hw, ENETC_PM0_IF_MODE);
+		val &= ~ENETC_PM0_IFM_EN_AUTO;
+		val &= ENETC_PM0_IFM_IFMODE_MASK;
+		val |= ENETC_PM0_IFM_IFMODE_GMII | ENETC_PM0_IFM_RG;
+		enetc_port_wr(hw, ENETC_PM0_IF_MODE, val);
+	}
 
-	if (phy_mode == PHY_INTERFACE_MODE_USXGMII)
-		enetc_port_wr(hw, ENETC_PM0_IF_MODE, ENETC_PM0_IFM_XGMII);
+	if (phy_mode == PHY_INTERFACE_MODE_USXGMII) {
+		val = ENETC_PM0_IFM_FULL_DPX | ENETC_PM0_IFM_IFMODE_XGMII;
+		enetc_port_wr(hw, ENETC_PM0_IF_MODE, val);
+	}
 }
 
 static void enetc_mac_enable(struct enetc_hw *hw, bool en)
@@ -932,6 +939,34 @@ static void enetc_pl_mac_config(struct phylink_config *config,
 		phylink_set_pcs(priv->phylink, &pf->pcs->pcs);
 }
 
+static void enetc_force_rgmii_mac(struct enetc_hw *hw, int speed, int duplex)
+{
+	u32 old_val, val;
+
+	old_val = val = enetc_port_rd(hw, ENETC_PM0_IF_MODE);
+
+	if (speed == SPEED_1000) {
+		val &= ~ENETC_PM0_IFM_SSP_MASK;
+		val |= ENETC_PM0_IFM_SSP_1000;
+	} else if (speed == SPEED_100) {
+		val &= ~ENETC_PM0_IFM_SSP_MASK;
+		val |= ENETC_PM0_IFM_SSP_100;
+	} else if (speed == SPEED_10) {
+		val &= ~ENETC_PM0_IFM_SSP_MASK;
+		val |= ENETC_PM0_IFM_SSP_10;
+	}
+
+	if (duplex == DUPLEX_FULL)
+		val |= ENETC_PM0_IFM_FULL_DPX;
+	else
+		val &= ~ENETC_PM0_IFM_FULL_DPX;
+
+	if (val == old_val)
+		return;
+
+	enetc_port_wr(hw, ENETC_PM0_IF_MODE, val);
+}
+
 static void enetc_pl_mac_link_up(struct phylink_config *config,
 				 struct phy_device *phy, unsigned int mode,
 				 phy_interface_t interface, int speed,
@@ -944,6 +979,10 @@ static void enetc_pl_mac_link_up(struct phylink_config *config,
 	if (priv->active_offloads & ENETC_F_QBV)
 		enetc_sched_speed_set(priv, speed);
 
+	if (!phylink_autoneg_inband(mode) &&
+	    phy_interface_mode_is_rgmii(interface))
+		enetc_force_rgmii_mac(&pf->si->hw, speed, duplex);
+
 	enetc_mac_enable(&pf->si->hw, true);
 }
 
-- 
2.25.1

