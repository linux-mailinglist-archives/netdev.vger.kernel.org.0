Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0B14584242
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 16:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbiG1OxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 10:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232246AbiG1OxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 10:53:05 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579236050A;
        Thu, 28 Jul 2022 07:53:02 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 0114760004;
        Thu, 28 Jul 2022 14:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1659019980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9EcP+9/stfB5EXECkZZmXmTw+rS+fOUz4yGICEAjfH8=;
        b=KzhElMPONR6+NIurGD5gkalAb09py/fu3eojj4JomY45vNUMiCL22n14frh3xePoj1IUkJ
        t5IYFf0kTkDfsl2esrdkLFHjuWZld120suUITNrcjTsiSvFv9AmCXTjTqPDnAfHP5CZD6C
        SqcK6ZmVICBrU6HfSnxXX3rQTjXZ//B3xpERrYJkN1yHKDUSD3abCfG6kn9szq9Atqv0cg
        5PXq+qDGC5NTnyrG5v84UB5rzDZRlGBxbHYv/HhPt8h8FK7UIFlf6cObLKPD9S9GWc6nKk
        FTgFHraNbu4ysljHM9gzzxNoA+3J4sb9Qgn99R7atdIS1lGLcl0CBKTbRlDLuw==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Horatiu.Vultur@microchip.com,
        Allan.Nielsen@microchip.com, UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 1/4] net: phy: Introduce QUSGMII PHY mode
Date:   Thu, 28 Jul 2022 16:52:49 +0200
Message-Id: <20220728145252.439201-2-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220728145252.439201-1-maxime.chevallier@bootlin.com>
References: <20220728145252.439201-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The QUSGMII mode is a derivative of Cisco's USXGMII standard. This
standard is pretty similar to SGMII, but allows for faster speeds, and
has the build-in bits for Quad and Octa variants (like QSGMII).

The main difference with SGMII/QSGMII is that USXGMII/QUSGMII re-uses
the preamble to carry various information, named 'Extensions'.

As of today, the USXGMII standard only mentions the "PCH" extension,
which is used to convey timestamps, allowing in-band signaling of PTP
timestamps without having to modify the frame itself.

This commit adds support for that mode. When no extension is in use, it
behaves exactly like QSGMII, although it's not compatible with QSGMII.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
V1->V2 : No changes

 Documentation/networking/phy.rst | 9 +++++++++
 drivers/net/phy/phylink.c        | 3 +++
 include/linux/phy.h              | 3 +++
 3 files changed, 15 insertions(+)

diff --git a/Documentation/networking/phy.rst b/Documentation/networking/phy.rst
index 704f31da5167..712e44caebd0 100644
--- a/Documentation/networking/phy.rst
+++ b/Documentation/networking/phy.rst
@@ -308,6 +308,15 @@ Some of the interface modes are described below:
     rate of 125Mpbs using a 4B/5B encoding scheme, resulting in an underlying
     data rate of 100Mpbs.
 
+``PHY_INTERFACE_MODE_QUSGMII``
+    This defines the Cisco the Quad USGMII mode, which is the Quad variant of
+    the USGMII (Universal SGMII) link. It's very similar to QSGMII, but uses
+    a Packet Control Header (PCH) instead of the 7 bytes preamble to carry not
+    only the port id, but also so-called "extensions". The only documented
+    extension so-far in the specification is the inclusion of timestamps, for
+    PTP-enabled PHYs. This mode isn't compatible with QSGMII, but offers the
+    same capabilities in terms of link speed and negociation.
+
 Pause frames / flow control
 ===========================
 
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 9bd69328dc4d..d2455df1d8d2 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -321,6 +321,7 @@ void phylink_get_linkmodes(unsigned long *linkmodes, phy_interface_t interface,
 	case PHY_INTERFACE_MODE_RGMII_ID:
 	case PHY_INTERFACE_MODE_RGMII:
 	case PHY_INTERFACE_MODE_QSGMII:
+	case PHY_INTERFACE_MODE_QUSGMII:
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_GMII:
 		caps |= MAC_1000HD | MAC_1000FD;
@@ -632,6 +633,7 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 		switch (pl->link_config.interface) {
 		case PHY_INTERFACE_MODE_SGMII:
 		case PHY_INTERFACE_MODE_QSGMII:
+		case PHY_INTERFACE_MODE_QUSGMII:
 			phylink_set(pl->supported, 10baseT_Half);
 			phylink_set(pl->supported, 10baseT_Full);
 			phylink_set(pl->supported, 100baseT_Half);
@@ -2929,6 +2931,7 @@ void phylink_mii_c22_pcs_decode_state(struct phylink_link_state *state,
 
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_QSGMII:
+	case PHY_INTERFACE_MODE_QUSGMII:
 		phylink_decode_sgmii_word(state, lpa);
 		break;
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 87638c55d844..6b96b810a4d8 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -152,6 +152,7 @@ typedef enum {
 	PHY_INTERFACE_MODE_USXGMII,
 	/* 10GBASE-KR - with Clause 73 AN */
 	PHY_INTERFACE_MODE_10GKR,
+	PHY_INTERFACE_MODE_QUSGMII,
 	PHY_INTERFACE_MODE_MAX,
 } phy_interface_t;
 
@@ -267,6 +268,8 @@ static inline const char *phy_modes(phy_interface_t interface)
 		return "10gbase-kr";
 	case PHY_INTERFACE_MODE_100BASEX:
 		return "100base-x";
+	case PHY_INTERFACE_MODE_QUSGMII:
+		return "qusgmii";
 	default:
 		return "unknown";
 	}
-- 
2.37.1

