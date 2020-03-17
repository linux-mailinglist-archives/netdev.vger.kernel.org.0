Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B937B188823
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 15:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgCQOxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 10:53:30 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40996 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgCQOxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 10:53:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=zy40pSnnLPpjvBORId3UuXxIFCVRHdxNligFP4pP/e0=; b=n+KG9/UbqaX6zOQN/6dQMF2dyu
        5RQFRroaYN4ORg2TDwxd6XTPlNk231l1n7gNtlCL4s0F11cAH6vKgIarwT8POHcl8bX3FTHIb7hDU
        /5muV2cjfHo5ndwFMTr1miLZPki40WXSlkusCPCLfWQQ9c0ZfbLGDBWJHa3PWJqQ1lk4v0JldqZ91
        GqLjZr/pvOraqUifDfys9qnnScMidFNXVFKDCa83D96YIMu59/ryp/MHF1IgfnNXbNvF+c1/IDdxP
        N7DTqWgFGdrn1DpMA2GjuxExbFNLOEOs6UsZBcW6rnwynr+5SH7fArbei1XGibenZxglbAmVbJOZM
        wcCS08Qw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:44368 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jEDaf-0007is-1K; Tue, 17 Mar 2020 14:53:09 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jEDac-0008Jd-Vq; Tue, 17 Mar 2020 14:53:07 +0000
In-Reply-To: <20200317144944.GP25745@shell.armlinux.org.uk>
References: <20200317144944.GP25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>
Subject: [RFC net-next 5/5] dpaa2-mac: add 10GBASE-R PCS support
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jEDac-0008Jd-Vq@rmk-PC.armlinux.org.uk>
Date:   Tue, 17 Mar 2020 14:53:06 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

*NOT FOR MERGING*

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index e7b2dc366338..38f8d31bf426 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -27,6 +27,10 @@ static void dpaa2_mac_pcs_get_state(struct phylink_config *config,
 		phylink_mii_c22_pcs_get_state(pcs, state);
 		break;
 
+	case PHY_INTERFACE_MODE_10GBASER:
+		phylink_mii_c45_pcs_get_state(pcs, state);
+		break;
+
 	default:
 		break;
 	}
@@ -131,6 +135,10 @@ static int phy_mode(enum dpmac_eth_if eth_if, phy_interface_t *if_mode)
 		*if_mode = PHY_INTERFACE_MODE_SGMII;
 		break;
 
+	case DPMAC_ETH_IF_XFI:
+		*if_mode = PHY_INTERFACE_MODE_10GBASER;
+		break;
+
 	default:
 		return -EINVAL;
 	}
@@ -191,6 +199,7 @@ static bool dpaa2_mac_phy_mode_mismatch(struct dpaa2_mac *mac,
 	case PHY_INTERFACE_MODE_RGMII_ID:
 	case PHY_INTERFACE_MODE_RGMII_RXID:
 	case PHY_INTERFACE_MODE_RGMII_TXID:
+	case PHY_INTERFACE_MODE_10GBASER:
 		return (interface != mac->if_mode);
 	default:
 		return true;
@@ -216,6 +225,17 @@ static void dpaa2_mac_validate(struct phylink_config *config,
 
 	switch (state->interface) {
 	case PHY_INTERFACE_MODE_NA:
+	case PHY_INTERFACE_MODE_10GBASER:
+		phylink_set(mask, 10000baseT_Full);
+		phylink_set(mask, 10000baseKR_Full);
+		phylink_set(mask, 10000baseCR_Full);
+		phylink_set(mask, 10000baseSR_Full);
+		phylink_set(mask, 10000baseLR_Full);
+		phylink_set(mask, 10000baseLRM_Full);
+		phylink_set(mask, 10000baseER_Full);
+		if (state->interface != PHY_INTERFACE_MODE_NA)
+			break;
+		/* fallthrough */
 	case PHY_INTERFACE_MODE_1000BASEX:
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_RGMII:
-- 
2.20.1

