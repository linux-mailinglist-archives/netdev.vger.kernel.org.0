Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553F5324F24
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 12:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235326AbhBYL1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 06:27:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235663AbhBYLZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 06:25:42 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C84C06178B
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 03:24:20 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id c6so6407432ede.0
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 03:24:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=583t56G3s7iRO/HGosiDWVrhXGL3vp1/ZgnI4z9w72w=;
        b=WnQUuDiF+n0AnoUaOG7WTzl8XLgE/kmhFrH+Bo60nMSc6uuEflQr/GyhM+kvQAycJF
         Zf3fst4FQbMFkyJJuEd5eP0TO3iV7VuKDgjItM5Vl++cs9V1G81gkwVdT5GwJ5WDeXFT
         ebQiwXvR+p58I/F1MPoT7QrsRxYuBjdbdGYumNRklFI2s+Il7Jz+S6EaAeQrcgAhnYlV
         6a7e450hanjioCXOyc3wXDTUFhIRsPWQCribHEteao5jZ1ukTaE7UAi6OvHIZp+nkIzY
         qd+75bvDXypUGFU1ADdZ7pdY8M21KsZKySCongIf6vwdet9dlhSGOP1FbOQHet8eyT2r
         acTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=583t56G3s7iRO/HGosiDWVrhXGL3vp1/ZgnI4z9w72w=;
        b=ZLIZ1HjE9YPNe73CKc6TR1ndOGCJ/sn/zE0XrpoN0pOqcax0IYW2jZdubnIvUuOgPU
         Z+0kA48uB4fcZStPY+YDyuErV/2zaf46rFVUhbf60Z3hcOiEjkxjv5SXBwS0gbbmRJCE
         cayjMFbb9oqyvdLYY5NjLZ7lwZNfsj4GTzsMrTzvUDfPH6EG76fG1S/CFJCEGS8Mq59N
         fdn+WpNUMurZOOYgg4fRBZidd743TVlhj9xdG0q1keJOpBQXOm+VITU6HvquwnYz0/Vx
         QdeQDvXRqqvdCqLO2o58F+ROuHxjMZo+b0/CY+33z1BGDONsr12J1ZqZN3C82UJscWTW
         Ne2w==
X-Gm-Message-State: AOAM5320cgHTRy70bw+munqnmxTTBwNgAR0CarhwF3Vrq2C+aY/22FKH
        0ldfk/TpnuVbjnGv0jCkBlucnvktPP0=
X-Google-Smtp-Source: ABdhPJyTg0ghWr8FsvrJ3KwOhxjkqYfKRMHm0MaHGOaevkdhDIcO1RR8x6RQoYNX4GVhN9kMGQqqjQ==
X-Received: by 2002:aa7:cd8d:: with SMTP id x13mr2309809edv.286.1614252259516;
        Thu, 25 Feb 2021 03:24:19 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id v12sm2977156ejh.94.2021.02.25.03.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 03:24:19 -0800 (PST)
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
Subject: [PATCH net 6/6] net: enetc: force the RGMII speed and duplex instead of operating in inband mode
Date:   Thu, 25 Feb 2021 13:23:57 +0200
Message-Id: <20210225112357.3785911-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210225112357.3785911-1-olteanv@gmail.com>
References: <20210225112357.3785911-1-olteanv@gmail.com>
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
index 49681a0566ed..796f19b00e1a 100644
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
@@ -492,15 +492,26 @@ static void enetc_configure_port_mac(struct enetc_hw *hw)
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
+		val &= ENETC_PM0_IFM_IFMODE_MASK;
+		val |= ENETC_PM0_IFM_IFMODE_GMII | ENETC_PM0_IFM_RG;
+		if (phylink_autoneg_inband(mode))
+			val |= ENETC_PM0_IFM_EN_AUTO;
+		else
+			val &= ~ENETC_PM0_IFM_EN_AUTO;
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
@@ -925,13 +936,38 @@ static void enetc_pl_mac_config(struct phylink_config *config,
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
+	u32 val;
+
+	val = enetc_port_rd(hw, ENETC_PM0_IF_MODE);
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
+	enetc_port_wr(hw, ENETC_PM0_IF_MODE, val);
+}
+
 static void enetc_pl_mac_link_up(struct phylink_config *config,
 				 struct phy_device *phy, unsigned int mode,
 				 phy_interface_t interface, int speed,
@@ -945,6 +981,10 @@ static void enetc_pl_mac_link_up(struct phylink_config *config,
 		enetc_sched_speed_set(priv, speed);
 
 	enetc_mac_enable(&pf->si->hw, true);
+
+	if (!phylink_autoneg_inband(mode) &&
+	    phy_interface_mode_is_rgmii(interface))
+		enetc_force_rgmii_mac(&pf->si->hw, speed, duplex);
 }
 
 static void enetc_pl_mac_link_down(struct phylink_config *config,
-- 
2.25.1

