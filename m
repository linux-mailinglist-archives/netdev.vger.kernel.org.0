Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE7E52D54F
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 15:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239273AbiESN5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 09:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238834AbiESN5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 09:57:08 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1C5E65;
        Thu, 19 May 2022 06:57:00 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id C27B9240018;
        Thu, 19 May 2022 13:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652968616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+OOpYFAzojc6pPu7a3Cjy9JL3eWpwDvEMOqBp/XLQgg=;
        b=dtLrrAdyCTFWwrLJm+qeQJGHpa3bmwxvW+UgOFJ2YIIByrWEe4gUjtmZGjssJ89W9srh8R
        kZUUlf/rHIlPTNDYwmaIVUZU1WPsbHJKInceDUATxGClPhC6AZXeJcAej8dgHMEoW0dq0E
        lYbranHyebS2g9nlHnKF1ZapApg5OPpr1GWEzmXkkxa2ZFeR2fqPG0GDXmowXSFxd5lFX/
        9e+Cg0cVQKmps3VHV4/wykA4TXYwrxEHWkfwDBp3Ybo7yQf2RO+YN26CKmh0edA2YauRGK
        dissJ8wdsdBTMbsA9chamCqVZRRQVvWCNiKLkCb7FvfgSTYn5wUCMwwP0sgdkA==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Richard Cochran <richardcochran@gmail.com>,
        Horatiu.Vultur@microchip.com, Allan.Nielsen@microchip.com,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 1/6] net: phy: Introduce QUSGMII PHY mode
Date:   Thu, 19 May 2022 15:56:42 +0200
Message-Id: <20220519135647.465653-2-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220519135647.465653-1-maxime.chevallier@bootlin.com>
References: <20220519135647.465653-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 Documentation/networking/phy.rst | 9 +++++++++
 drivers/net/phy/phylink.c        | 3 +++
 include/linux/phy.h              | 3 +++
 3 files changed, 15 insertions(+)

diff --git a/Documentation/networking/phy.rst b/Documentation/networking/phy.rst
index d43da709bf40..72c3c9fbce6f 100644
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
index 06943889d747..228eed5bc85a 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -320,6 +320,7 @@ void phylink_get_linkmodes(unsigned long *linkmodes, phy_interface_t interface,
 	case PHY_INTERFACE_MODE_RGMII_ID:
 	case PHY_INTERFACE_MODE_RGMII:
 	case PHY_INTERFACE_MODE_QSGMII:
+	case PHY_INTERFACE_MODE_QUSGMII:
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_GMII:
 		caps |= MAC_1000HD | MAC_1000FD;
@@ -631,6 +632,7 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 		switch (pl->link_config.interface) {
 		case PHY_INTERFACE_MODE_SGMII:
 		case PHY_INTERFACE_MODE_QSGMII:
+		case PHY_INTERFACE_MODE_QUSGMII:
 			phylink_set(pl->supported, 10baseT_Half);
 			phylink_set(pl->supported, 10baseT_Full);
 			phylink_set(pl->supported, 100baseT_Half);
@@ -2944,6 +2946,7 @@ void phylink_mii_c22_pcs_decode_state(struct phylink_link_state *state,
 
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_QSGMII:
+	case PHY_INTERFACE_MODE_QUSGMII:
 		phylink_decode_sgmii_word(state, lpa);
 		break;
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 36ca2b5c2253..4a2731c78590 100644
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
2.36.1

