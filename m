Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 364E2596E89
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 14:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238909AbiHQMdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 08:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231828AbiHQMdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 08:33:05 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33AC861F5;
        Wed, 17 Aug 2022 05:33:03 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 094851C0004;
        Wed, 17 Aug 2022 12:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1660739582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xVWN5PxBhZIwLb93ut/eDZPEDDFTMNIGRTSGWGj2JKU=;
        b=OKQl5XXmtgSgmp7EcRPFIDbk3sBDvMr6ueYAMEMHHix7CiRyBtcPkESvU6HHwaj9zo6E+g
        dUdKCevbyBWrW5ZXFUuWu0rWA75rLzOuUVJlcyofGTX2aAOc9YJ4JlSP6ffeoedLvlbqD/
        CyXmkzPmKvvdK73066S7aIdBSPFsvRdC9IhKBMdebdg34jDgxptRWWGMM5ltXueMiodGcS
        HAoaaoMuGbwmW9+WOjbeBLiLuMaeB08e4Rzn8Nh1E2QJNjbhN0jH8aJqLsTj7WN96l4xxT
        nxFsbB++HPNCT1ZSMgOD5c7TSpHfm30twHfmJ/o6OAZ0ppnR6x4AqR+dmoT1Cw==
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
Subject: [PATCH net-next RESEND v4 1/4] net: phy: Introduce QUSGMII PHY mode
Date:   Wed, 17 Aug 2022 14:32:52 +0200
Message-Id: <20220817123255.111130-2-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220817123255.111130-1-maxime.chevallier@bootlin.com>
References: <20220817123255.111130-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
V1->V2 : No changes
V2->v3 : Added missing documentation on the new enum value
V3->V4 : Added Andrew's R'd-by

 Documentation/networking/phy.rst | 9 +++++++++
 drivers/net/phy/phylink.c        | 3 +++
 include/linux/phy.h              | 4 ++++
 3 files changed, 16 insertions(+)

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
index 87638c55d844..9eeab9b9a74c 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -115,6 +115,7 @@ extern const int phy_10gbit_features_array[1];
  * @PHY_INTERFACE_MODE_25GBASER: 25G BaseR
  * @PHY_INTERFACE_MODE_USXGMII:  Universal Serial 10GE MII
  * @PHY_INTERFACE_MODE_10GKR: 10GBASE-KR - with Clause 73 AN
+ * @PHY_INTERFACE_MODE_QUSGMII: Quad Universal SGMII
  * @PHY_INTERFACE_MODE_MAX: Book keeping
  *
  * Describes the interface between the MAC and PHY.
@@ -152,6 +153,7 @@ typedef enum {
 	PHY_INTERFACE_MODE_USXGMII,
 	/* 10GBASE-KR - with Clause 73 AN */
 	PHY_INTERFACE_MODE_10GKR,
+	PHY_INTERFACE_MODE_QUSGMII,
 	PHY_INTERFACE_MODE_MAX,
 } phy_interface_t;
 
@@ -267,6 +269,8 @@ static inline const char *phy_modes(phy_interface_t interface)
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

