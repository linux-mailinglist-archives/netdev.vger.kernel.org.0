Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 278232A9731
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 14:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbgKFNna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 08:43:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727214AbgKFNn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 08:43:29 -0500
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4251BC0613CF;
        Fri,  6 Nov 2020 05:43:29 -0800 (PST)
Received: by mail-qv1-xf44.google.com with SMTP id t20so432234qvv.8;
        Fri, 06 Nov 2020 05:43:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=rT5j7lshCQKdRQ8BD7rr8LbaYu7bliJO6etuVPyr5xQ=;
        b=D9EbxljdOaXZFwnPRux0q8niprrBKG0AYKRzqVN9vXa6fvSDsQ+ZHk0isyy7Rp8FxH
         azHBbOEgK6VmXmb17KCpYcbUM/X85DBKC7Bj0dRRvXyQJC4/xEmMuMnMr0GVYvhWRHRw
         iKgonrpXS4PNk2A3euxEo556xvwok+Y4j3tUaxEklGYJaztCvgSs9T/KRQuJf4k4wIYj
         RkoIj7H7OJWn1jZeXLdehMjH0Rpu6PBmoxDtX4IDCwaZJYQt5bZyKu8VwEKEWUPnrRfU
         8orKwnM0/BTmTT9JUSeQTuk89T6qx/rW7ruy6T9lpOy3cpbYsyrXUUpfpaujRvozBVEZ
         Q7Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rT5j7lshCQKdRQ8BD7rr8LbaYu7bliJO6etuVPyr5xQ=;
        b=H9cAUww0gCVup2MtsxsAaAy0yZe6JUeTE0Yi4S/CTI0sqxnW8VNeGrCIrFOuRYEsT4
         wrdrAoS7tgtJmx8jN9RkqaFqEo/N4cIy+TR2VTnRc0akegEg/N2aPIzQzanpN3LqLUfH
         xrXY0dBsnIP2RO8BPmVVXRzbP4Im9iqkVRHP0afVCSeoxFJVQL+s+TdBWGCRHQEd1Rf+
         UTg5MMgfdMtmrFdLGan6DcTBz1OW7NEdV7Sx12A2qD2ykfjY6rmttZn3bb/C2i9Qbt2B
         d6gz3ZOw7qon/7UWShcheRrCn9cnEocQQURKiEhHL9azUHpdRnpiH7eTWRDrNjY6yuBO
         /1sQ==
X-Gm-Message-State: AOAM5339O7BLC06nLleTLfparXk77BSm7Hux0pJdQRQt7ahC9N9Baum4
        TV+NKIZRqnBNlcMLcM+UsYo=
X-Google-Smtp-Source: ABdhPJw0kcd+LQmw0wkvinIOTnlZd08P/fBU7Na2c8IwjRsw5TeLlPCwiEde35TrU5VNKuigVPKqig==
X-Received: by 2002:a0c:d6cb:: with SMTP id l11mr1562405qvi.9.1604670208346;
        Fri, 06 Nov 2020 05:43:28 -0800 (PST)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id w45sm514772qtw.96.2020.11.06.05.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 05:43:27 -0800 (PST)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Roelof Berg <rberg@berg-solutions.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] lan743x: correctly handle chips with internal PHY
Date:   Fri,  6 Nov 2020 08:43:24 -0500
Message-Id: <20201106134324.20656-1-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

Commit 6f197fb63850 ("lan743x: Added fixed link and RGMII support")
assumes that chips with an internal PHY will never have a devicetree
entry. This is incorrect: even for these chips, a devicetree entry
can be useful e.g. to pass the mac address from bootloader to chip:

    &pcie {
            status = "okay";

            host@0 {
                    reg = <0 0 0 0 0>;

                    #address-cells = <3>;
                    #size-cells = <2>;

                    lan7430: ethernet@0 {
                            /* LAN7430 with internal PHY */
                            compatible = "microchip,lan743x";
                            status = "okay";
                            reg = <0 0 0 0 0>;
                            /* filled in by bootloader */
                            local-mac-address = [00 00 00 00 00 00];
                    };
            };
    };

If a devicetree entry is present, the driver will not attach the chip
to its internal phy, and the chip will be non-operational.

Fix by tweaking the phy connection algorithm:
- first try to connect to a phy specified in the devicetree
  (could be 'real' phy, or just a 'fixed-link')
- if that doesn't succeed, try to connect to an internal phy, even
  if the chip has a devnode

Tested on a LAN7430 with internal PHY. I cannot test a device using
fixed-link, as I do not have access to one.

Fixes: 6f197fb63850 ("lan743x: Added fixed link and RGMII support")
Tested-by: Sven Van Asbroeck <thesven73@gmail.com> # lan7430
Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
---

v1 -> v2:
    Andrew Lunn: keep patch minimal and correct, so keep open-coded version
    of of_phy_get_and_connect().

    Jakub Kicinski: fix e-mail address case.

Tree: v5.10-rc2

To: Andrew Lunn <andrew@lunn.ch>
To: Bryan Whitehead <bryan.whitehead@microchip.com>
To: "David S. Miller" <davem@davemloft.net>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc: Roelof Berg <rberg@berg-solutions.de>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

 drivers/net/ethernet/microchip/lan743x_main.c | 21 +++++++++++--------
 drivers/net/ethernet/microchip/lan743x_main.h |  1 -
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index f2d13e8d20f0..65e80d41c9bc 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -957,7 +957,7 @@ static void lan743x_phy_link_status_change(struct net_device *netdev)
 		data = lan743x_csr_read(adapter, MAC_CR);
 
 		/* set interface mode */
-		if (phy_interface_mode_is_rgmii(adapter->phy_mode))
+		if (phy_interface_is_rgmii(phydev))
 			/* RGMII */
 			data &= ~MAC_CR_MII_EN_;
 		else
@@ -1014,17 +1014,18 @@ static void lan743x_phy_close(struct lan743x_adapter *adapter)
 static int lan743x_phy_open(struct lan743x_adapter *adapter)
 {
 	struct lan743x_phy *phy = &adapter->phy;
+	struct phy_device *phydev = NULL;
 	struct device_node *phynode;
-	struct phy_device *phydev;
 	struct net_device *netdev;
+	phy_interface_t phy_mode;
 	int ret = -EIO;
 
 	netdev = adapter->netdev;
 	phynode = of_node_get(adapter->pdev->dev.of_node);
-	adapter->phy_mode = PHY_INTERFACE_MODE_GMII;
 
 	if (phynode) {
-		of_get_phy_mode(phynode, &adapter->phy_mode);
+		/* try devicetree phy, or fixed link */
+		of_get_phy_mode(phynode, &phy_mode);
 
 		if (of_phy_is_fixed_link(phynode)) {
 			ret = of_phy_register_fixed_link(phynode);
@@ -1037,18 +1038,19 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
 		}
 		phydev = of_phy_connect(netdev, phynode,
 					lan743x_phy_link_status_change, 0,
-					adapter->phy_mode);
+					phy_mode);
 		of_node_put(phynode);
-		if (!phydev)
-			goto return_error;
-	} else {
+	}
+
+	if (!phydev) {
+		/* try internal phy */
 		phydev = phy_find_first(adapter->mdiobus);
 		if (!phydev)
 			goto return_error;
 
 		ret = phy_connect_direct(netdev, phydev,
 					 lan743x_phy_link_status_change,
-					 adapter->phy_mode);
+					 PHY_INTERFACE_MODE_GMII);
 		if (ret)
 			goto return_error;
 	}
@@ -1063,6 +1065,7 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
 
 	phy_start(phydev);
 	phy_start_aneg(phydev);
+	phy_attached_info(phydev);
 	return 0;
 
 return_error:
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index a536f4a4994d..3a0e70daa88f 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -703,7 +703,6 @@ struct lan743x_rx {
 struct lan743x_adapter {
 	struct net_device       *netdev;
 	struct mii_bus		*mdiobus;
-	phy_interface_t		phy_mode;
 	int                     msg_enable;
 #ifdef CONFIG_PM
 	u32			wolopts;
-- 
2.17.1

