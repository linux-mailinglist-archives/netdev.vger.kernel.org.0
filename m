Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE2F1AE8DB
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 02:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgDRAE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 20:04:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45560 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbgDRAE1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 20:04:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uF2w8pHsSMCHxvg8n1ReKtpYE6xeN6VRn3oRropG0uU=; b=07QCHlzQHfkgAgVRYtLTh+Sp6V
        JL6wgvALyWyvDhH6IUwKn/H9TRR+TYy7GBIjKwQ0NQM3RlShlPfCNG3aMlslsMxrfQHOMHIhDGYG9
        +CXXFwpvm+EKdaYUFajYBk3rl8bukCB0tR/h2Whlj1JQqPm8cvjchuphBaRc1NpELuPk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jPaxs-003NKf-SC; Sat, 18 Apr 2020 02:04:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, fugang.duan@nxp.com,
        Andrew Lunn <andrew@lunn.ch>,
        Chris Healy <Chris.Healy@zii.aero>
Subject: [PATCH net-next v2 3/3] net: ethernet: fec: Allow the MDIO preamble to be disabled
Date:   Sat, 18 Apr 2020 02:03:55 +0200
Message-Id: <20200418000355.804617-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.0.rc2
In-Reply-To: <20200418000355.804617-1-andrew@lunn.ch>
References: <20200418000355.804617-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An MDIO transaction normally starts with 32 1s as a preamble. However
not all devices requires such a preamble. Add a device tree property
which allows the preamble to be suppressed. This will half the size of
the MDIO transaction, allowing faster transactions.

Suggested-by: Chris Healy <Chris.Healy@zii.aero>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 Documentation/devicetree/bindings/net/mdio.yaml | 4 ++++
 drivers/net/ethernet/freescale/fec_main.c       | 9 ++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/mdio.yaml b/Documentation/devicetree/bindings/net/mdio.yaml
index bcd457c54cd7..41ed4019f8ca 100644
--- a/Documentation/devicetree/bindings/net/mdio.yaml
+++ b/Documentation/devicetree/bindings/net/mdio.yaml
@@ -43,6 +43,10 @@ properties:
     description:
       Desired MDIO bus clock frequency in Hz.
 
+  suppress-preamble:
+        description: The 32 bit preamble should be suppressed.
+        type: boolean
+
 patternProperties:
   "^ethernet-phy@[0-9a-f]+$":
     type: object
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 28ef0abfa660..3404e085c657 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2064,6 +2064,7 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 	static struct mii_bus *fec0_mii_bus;
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct fec_enet_private *fep = netdev_priv(ndev);
+	bool suppress_preamble = false;
 	struct device_node *node;
 	int err = -ENXIO;
 	u32 mii_speed, holdtime;
@@ -2097,8 +2098,11 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 
 	bus_freq = 2500000; /* 2.5MHz by default */
 	node = of_get_child_by_name(pdev->dev.of_node, "mdio");
-	if (node)
+	if (node) {
 		of_property_read_u32(node, "clock-frequency", &bus_freq);
+		suppress_preamble = of_property_read_bool(node,
+							  "suppress-preamble");
+	}
 
 	/*
 	 * Set MII speed (= clk_get_rate() / 2 * phy_speed)
@@ -2135,6 +2139,9 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 
 	fep->phy_speed = mii_speed << 1 | holdtime << 8;
 
+	if (suppress_preamble)
+		fep->phy_speed |= BIT(7);
+
 	writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
 
 	/* Clear any pending transaction complete indication */
-- 
2.26.1

