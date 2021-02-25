Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14DF324FD0
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 13:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbhBYMU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 07:20:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232821AbhBYMUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 07:20:16 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42BEC06178B
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 04:19:01 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id k13so8514186ejs.10
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 04:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FiES+3UgGYLpdM59Kc2UDrkEsGRRziOOcwBPRyl6dV0=;
        b=FtiPUlPHcy3uhDYPmpVY39TLLVunvGaGFQFXlTc0nJCUc/8jPiSifvsoeVYG6fS6y4
         rUfyTPtcmQ5lhrcnWDOSkZeH6Cd25dm5JWAWKz0C9bd1EbI9pH7R1qgCr9ahIAo10tPn
         f2mdO+8K6W9HA84PNtMNmucfoecqOYmlHRvGLwZcyigwHrhWGLMKCW98zfzYQucS9qf3
         JJOPlDEsIGKkatkYoZQzn+gd80s6vsKkcTpCqkGT0HGwvzJxy3Pq2TLi//gtG+B7Tjvy
         QCUFqW6ostOVKE95roXrzWEsuHByL0Ueo0/3RHliEnFn+vDdybeBK4i6RhCzrEIQoZCC
         Ofpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FiES+3UgGYLpdM59Kc2UDrkEsGRRziOOcwBPRyl6dV0=;
        b=e6qUA7i9rBKz4Oiln2SNwjxyaRX0yPpdnUoYwXcTvoyVNsRc1iHFwjUjTcMS1Cztm1
         UijgP4CvvvtnbP53ZkUH8KrUH73y1qObWjXh/pXiRvpu+27N45wklFpotS/EmKjdk5Uu
         mJAjw14oP5EzLntd33LPeAQ5V99yHM/ErTDeOtktrHFxiDlTBAfpbTT9L/tG0AWiEbjW
         Q6BuTQlOPeVDgMzsqeLatYv6aEcOOfvL8Z7f0GCRZGBQEs60WxfVicfrkq2/C0ddhjmN
         NFt4DSoTp7AJi1b5eDfyTvPDX7IpK+beDAUxIxLtVPmTVG/AMWCHb29/RixvCtBMsM8/
         Omtw==
X-Gm-Message-State: AOAM5319Gzq1TjMVqFoWpJVwcOXgfrvo5pOrQaZfJIDA93UDroilQNXD
        Jmn95ahgX49AWLdKw4tAm4w=
X-Google-Smtp-Source: ABdhPJzBf/0Im0NnueMyvsoh8b8or3DBCu8igSVvK/coLnT7ALKTKQDuvciHBvINZicufmlZJJ6Whw==
X-Received: by 2002:a17:906:a293:: with SMTP id i19mr2404283ejz.267.1614255540446;
        Thu, 25 Feb 2021 04:19:00 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id x25sm3420925edv.65.2021.02.25.04.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 04:19:00 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH v2 net 6/6] net: enetc: force the RGMII speed and duplex instead of operating in inband mode
Date:   Thu, 25 Feb 2021 14:18:35 +0200
Message-Id: <20210225121835.3864036-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210225121835.3864036-1-olteanv@gmail.com>
References: <20210225121835.3864036-1-olteanv@gmail.com>
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
---
Changes in v2:
- Don't write to the MAC if speed and duplex did not change.
- Don't update the speed with the MAC enabled.
- Remove the logic for enabling in-band signaling in enetc_mac_config.

 .../net/ethernet/freescale/enetc/enetc_hw.h   | 13 ++++-
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 58 ++++++++++++++++---
 2 files changed, 59 insertions(+), 12 deletions(-)

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
index 49681a0566ed..e0c2e8db4801 100644
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
@@ -492,15 +492,23 @@ static void enetc_configure_port_mac(struct enetc_hw *hw)
 		      ENETC_PM0_CMD_TXP	| ENETC_PM0_PROMISC);
 }
 
-static void enetc_mac_config(struct enetc_hw *hw, phy_interface_t phy_mode)
+static void enetc_mac_config(struct enetc_hw *hw, phy_interface_t phy_mode,
+			     unsigned int mode)
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
@@ -925,13 +933,41 @@ static void enetc_pl_mac_config(struct phylink_config *config,
 	struct enetc_pf *pf = phylink_to_enetc_pf(config);
 	struct enetc_ndev_priv *priv;
 
-	enetc_mac_config(&pf->si->hw, state->interface);
+	enetc_mac_config(&pf->si->hw, state->interface, mode);
 
 	priv = netdev_priv(pf->si->ndev);
 	if (pf->pcs)
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
@@ -944,6 +980,10 @@ static void enetc_pl_mac_link_up(struct phylink_config *config,
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

