Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08224AD78B
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 13:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730250AbfIILDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 07:03:03 -0400
Received: from forward102p.mail.yandex.net ([77.88.28.102]:42375 "EHLO
        forward102p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726141AbfIILDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 07:03:03 -0400
Received: from mxback17g.mail.yandex.net (mxback17g.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:317])
        by forward102p.mail.yandex.net (Yandex) with ESMTP id 939321D4066E;
        Mon,  9 Sep 2019 14:02:58 +0300 (MSK)
Received: from smtp3o.mail.yandex.net (smtp3o.mail.yandex.net [2a02:6b8:0:1a2d::27])
        by mxback17g.mail.yandex.net (nwsmtp/Yandex) with ESMTP id CMBORa51HB-2wwOk3Fl;
        Mon, 09 Sep 2019 14:02:58 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cloudbear.ru; s=mail; t=1568026978;
        bh=0+ecBJRsOXSQYRlJC3FkaXovpWQqTByAx4bW09jHaJk=;
        h=In-Reply-To:Subject:To:From:Cc:References:Date:Message-Id;
        b=ek7JVAEtKkSIVddRiYqVd4FT1A/LUM0LlTCAlKsX9/Wg7GQAe6xDbsmP+3kckRmru
         5J9rGHgDEE49mPVZZmvEDywc0xmi584Qh87n1mhMDepJSVys2oFQsHNHcto/vaI2A8
         nsewKvoIi2XIlbDMmlO3JUeTngoUcRJR7h/hwC5c=
Authentication-Results: mxback17g.mail.yandex.net; dkim=pass header.i=@cloudbear.ru
Received: by smtp3o.mail.yandex.net (nwsmtp/Yandex) with ESMTPSA id O2jPUuSQ2C-2uFKnK07;
        Mon, 09 Sep 2019 14:02:57 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Vitaly Gaiduk <vitaly.gaiduk@cloudbear.ru>
To:     davem@davemloft.net, robh+dt@kernel.org, f.fainelli@gmail.com
Cc:     Vitaly Gaiduk <vitaly.gaiduk@cloudbear.ru>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Trent Piepho <tpiepho@impinj.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] net: phy: dp83867: Add SGMII mode type switching
Date:   Mon,  9 Sep 2019 14:02:22 +0300
Message-Id: <1568026945-3857-1-git-send-email-vitaly.gaiduk@cloudbear.ru>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567700761-14195-2-git-send-email-vitaly.gaiduk@cloudbear.ru>
References: <1567700761-14195-2-git-send-email-vitaly.gaiduk@cloudbear.ru>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds ability to switch beetween two PHY SGMII modes.
Some hardware, for example, FPGA IP designs may use 6-wire mode
which enables differential SGMII clock to MAC.

Signed-off-by: Vitaly Gaiduk <vitaly.gaiduk@cloudbear.ru>
---
Changes in v2:
- changed variable sgmii_type name to sgmii_ref_clk_en

 drivers/net/phy/dp83867.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 1f1ecee..cd6260e 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -37,6 +37,7 @@
 #define DP83867_STRAP_STS2	0x006f
 #define DP83867_RGMIIDCTL	0x0086
 #define DP83867_IO_MUX_CFG	0x0170
+#define DP83867_SGMIICTL	0x00D3
 #define DP83867_10M_SGMII_CFG   0x016F
 #define DP83867_10M_SGMII_RATE_ADAPT_MASK BIT(7)

@@ -61,6 +62,9 @@
 #define DP83867_RGMII_TX_CLK_DELAY_EN		BIT(1)
 #define DP83867_RGMII_RX_CLK_DELAY_EN		BIT(0)

+/* SGMIICTL bits */
+#define DP83867_SGMII_TYPE		BIT(14)
+
 /* STRAP_STS1 bits */
 #define DP83867_STRAP_STS1_RESERVED		BIT(11)

@@ -109,6 +113,7 @@ struct dp83867_private {
 	bool rxctrl_strap_quirk;
 	bool set_clk_output;
 	u32 clk_output_sel;
+	bool sgmii_ref_clk_en;
 };

 static int dp83867_ack_interrupt(struct phy_device *phydev)
@@ -197,6 +202,9 @@ static int dp83867_of_init(struct phy_device *phydev)
 	dp83867->rxctrl_strap_quirk = of_property_read_bool(of_node,
 					"ti,dp83867-rxctrl-strap-quirk");

+	dp83867->sgmii_ref_clk_en = of_property_read_bool(of_node,
+					"ti,sgmii-ref-clock-output-enable");
+
 	/* Existing behavior was to use default pin strapping delay in rgmii
 	 * mode, but rgmii should have meant no delay.  Warn existing users.
 	 */
@@ -389,6 +397,14 @@ static int dp83867_config_init(struct phy_device *phydev)

 		if (ret)
 			return ret;
+
+		/* SGMII type is set to 4-wire mode by default */
+		if (dp83867->sgmii_ref_clk_en) {
+			/* Switch on 6-wire mode */
+			val = phy_read_mmd(phydev, DP83867_DEVADDR, DP83867_SGMIICTL);
+			val |= DP83867_SGMII_TYPE;
+			phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_SGMIICTL, val);
+		}
 	}

 	/* Enable Interrupt output INT_OE in CFG3 register */
--
2.7.4

