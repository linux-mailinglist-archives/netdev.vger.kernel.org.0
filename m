Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 142996CAB67
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbjC0RD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232187AbjC0RDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:03:01 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D34D63AA6
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 10:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=iS4wIdT9rIFWWe49wfqYAufc2jNUvnyBP/pf2+3egF4=; b=NL/UN+e6k/ny2ujD6mbQvgnKQY
        E0BH99amDmbUGjhvgAg9fSvhMRFnS5n5nKLqmLmLUYVvdOwiou4viQQkLt9djXRQxpRK0vwRjTBuf
        fcf4V/52IE47R5i/0jMYoLfmEYFvv7+90+ys/NqcGnzOXu49S4mDPo+Gcy+Oeiyub38M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pgqEV-008XtY-Ve; Mon, 27 Mar 2023 19:02:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [RFC/RFT 22/23] net: phylib: call phy_support_eee() in MAC drivers which support EEE
Date:   Mon, 27 Mar 2023 19:02:00 +0200
Message-Id: <20230327170201.2036708-23-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230327170201.2036708-1-andrew@lunn.ch>
References: <20230327170201.2036708-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For MAC drivers making use of phylib, and which support EEE, call
phy_support_eee() before starting the PHY.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/broadcom/genet/bcmmii.c    | 2 ++
 drivers/net/ethernet/freescale/fec_main.c       | 3 +++
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c | 3 +++
 drivers/net/usb/lan78xx.c                       | 2 ++
 4 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index 6c39839762a7..4175042865ec 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -376,6 +376,8 @@ int bcmgenet_mii_probe(struct net_device *dev)
 		}
 	}
 
+	phy_support_eee(dev->phydev);
+
 	/* Configure port multiplexer based on what the probed PHY device since
 	 * reading the 'max-speed' property determines the maximum supported
 	 * PHY speed which is needed for bcmgenet_mii_config() to configure
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index fda1f9ff32b9..09c55430c614 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2348,6 +2348,9 @@ static int fec_enet_mii_probe(struct net_device *ndev)
 	else
 		phy_set_max_speed(phy_dev, 100);
 
+	if (fep->quirks & FEC_QUIRK_HAS_EEE)
+		phy_support_eee(phy_dev);
+
 	fep->link = 0;
 	fep->full_duplex = 0;
 
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index cf549a524674..060280c4bc0a 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -286,6 +286,9 @@ static int sxgbe_init_phy(struct net_device *ndev)
 		return -ENODEV;
 	}
 
+	if (priv->hw_cap.eee)
+		phy_support_eee(phydev);
+
 	netdev_dbg(ndev, "%s: attached to PHY (UID 0x%x) Link = %d\n",
 		   __func__, phydev->phy_id, phydev->link);
 
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 3f12b67d7444..9b4a33f8e3b2 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -2400,6 +2400,8 @@ static int lan78xx_phy_init(struct lan78xx_net *dev)
 	mii_adv_to_linkmode_adv_t(fc, mii_adv);
 	linkmode_or(phydev->advertising, fc, phydev->advertising);
 
+	phy_support_eee(phydev);
+
 	if (phydev->mdio.dev.of_node) {
 		u32 reg;
 		int len;
-- 
2.39.2

