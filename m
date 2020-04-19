Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C861AFE84
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 00:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgDSWEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 18:04:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49094 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbgDSWEc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 18:04:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=satF3SuUdIafe9PlmZxQo+qdnD8rlQC61h8Rbjpr6hI=; b=QHe77lJ3OpLkHrOtCqkKuDcGbS
        5OhpbyYfgCrrnJ2LQsfY8bKlbr6vak+/+IrSxv/3JrmYoJEZ2/UJaBHXbguGHA/28xqLM64h0Icc8
        n6lwVA95Cu5we3NFZnUumph3DgNeC3EgcHNWHARViGApR2xoOnAG8B814TNIHMPgCTig=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jQI2w-003hqt-7C; Mon, 20 Apr 2020 00:04:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, fugang.duan@nxp.com,
        Andrew Lunn <andrew@lunn.ch>,
        Chris Healy <Chris.Healy@zii.aero>
Subject: [PATCH net-next v3 3/3] net: ethernet: fec: Allow the MDIO preamble to be disabled
Date:   Mon, 20 Apr 2020 00:04:02 +0200
Message-Id: <20200419220402.883493-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.0.rc2
In-Reply-To: <20200419220402.883493-1-andrew@lunn.ch>
References: <20200419220402.883493-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An MDIO transaction normally starts with 32 1s as a preamble. However
not all devices requires such a preamble. Add a device tree property
which allows the preamble to be suppressed. This will half the size of
the MDIO transaction, allowing faster transactions. But it should only
be used when all devices on the bus support suppressed preamble.

Suggested-by: Chris Healy <Chris.Healy@zii.aero>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/devicetree/bindings/net/mdio.yaml | 6 ++++++
 drivers/net/ethernet/freescale/fec_main.c       | 9 ++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/mdio.yaml b/Documentation/devicetree/bindings/net/mdio.yaml
index ab4a9df8b8e2..cd6c6ae6dabb 100644
--- a/Documentation/devicetree/bindings/net/mdio.yaml
+++ b/Documentation/devicetree/bindings/net/mdio.yaml
@@ -45,6 +45,12 @@ properties:
       defined 2.5MHz should only be used when all devices on the bus support
       the given clock speed.
 
+  suppress-preamble:
+    description:
+      The 32 bit preamble should be suppressed. In order for this to
+      work, all devices on the bus must support suppressed preamble.
+    type: boolean
+
 patternProperties:
   "^ethernet-phy@[0-9a-f]+$":
     type: object
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 832a24e2805c..1ae075a246a3 100644
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

