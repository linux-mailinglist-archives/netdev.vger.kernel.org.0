Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E56BB2A691C
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 17:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730012AbgKDQIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 11:08:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729840AbgKDQIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 11:08:52 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529AFC0613D3;
        Wed,  4 Nov 2020 08:08:52 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id x7so19826938ili.5;
        Wed, 04 Nov 2020 08:08:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=MganMYMYYjybcpcU88wzK3c1493PmTVrCCHT7bNkP+U=;
        b=SebTzKO0r84f/cdrZXygNg5FqSsLQ/DXpHqmL8oCIx5iKZayWP/jwE5V4mdQkK6ngF
         FAvxEn88FjDVR+lApK5YN6kZPBP9dUmgMnUC/oX/OLB+BSEcNJdDnrpmPdrAkbHeDRsN
         QCvdoI9Ol4KEQbGlnYpkWUYyQ/gv5eyiCEqILUr6LONFMJgrxOf8FDHdnxu2Sn8jyWYT
         RG5+rwb7AOnwBsbTfy9SuU/eJiP2CVOReHSLU4SfDj6s4KH39SzDUXWaQdjmDfORfpsG
         aiXbUx8t4Z994+g1aYo/9i0flj1RZajjFF7FJQOF8OSPJ3bN77fcjqgXPmV7I518AlzL
         xrLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MganMYMYYjybcpcU88wzK3c1493PmTVrCCHT7bNkP+U=;
        b=t7/a+QXLXQ+U7MRkK8cqeFSi6PDcwwYpfP3yX8TNSLAvWqXXO9K6vR+wDHTnhgzmw9
         AawjQX1lu8xdnnG5sx4nczOey0MwSf5wy+JHYXxOkZ/lExqxeIlXCYzEdpdN6v+sk4sD
         V0VYPp03et5haA7RlEm9YukYn1GC6PwEOIdjEY48ephrLXJpiAPJzUt7N3oW0qlu64//
         x9+W2Dry1rY+06ZV0X6c/K8XJvNyNpG6Y76rZyBpKpLffp9m6OpZHj7JP0Nw4/wPYqn4
         Pn6MQpTP6B0pHwVV3ZkqX9wOCaZSva01E7gR+y5YKLhBHl4k2kRPt5FzKwD9Mc8UIlam
         YssQ==
X-Gm-Message-State: AOAM532RQW+pirQJ3ghmKmpZtWCDyGh3CuAG0s6Rd/nkUv0DlzRVV+67
        KeB+DbAo570d5RKNJn1jA8T1CatGkX0=
X-Google-Smtp-Source: ABdhPJxKqTfBuBcOcWOv7poRFlax8YlsF1nPYSPoLc0L2aTYuhV9xPRNSg3PH1xSdMb9wD9lPv0gTg==
X-Received: by 2002:a92:c8c4:: with SMTP id c4mr12740652ilq.161.1604506131566;
        Wed, 04 Nov 2020 08:08:51 -0800 (PST)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id m86sm1705076ilb.44.2020.11.04.08.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 08:08:50 -0800 (PST)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Roelof Berg <rberg@berg-solutions.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1] lan743x: correctly handle chips with internal PHY
Date:   Wed,  4 Nov 2020 11:08:47 -0500
Message-Id: <20201104160847.30049-1-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 6f197fb63850 ("lan743x: Added fixed link and RGMII support")
assumes that chips with an internal PHY will not have a devicetree
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

This method no longer explicitly exposes the phy mode, but we can
get around that by querying the phy mode from the phydev. The
phy_mode member in the adapter private struct can then be removed.

Note that as a side-effect, the devicetree phy mode now no longer
has a default, and always needs to be specified explicitly (via
'phy-connection-type').

Tested on a LAN7430 with internal PHY. I cannot test a device using
fixed-link, as I do not have access to one.

Fixes: 6f197fb63850 ("lan743x: Added fixed link and RGMII support")
Tested-by: Sven Van Asbroeck <TheSven73@gmail.com> # lan7430
Signed-off-by: Sven Van Asbroeck <TheSven73@gmail.com>
---

Tree: v5.10-rc2

To: Bryan Whitehead <bryan.whitehead@microchip.com>
To: "David S. Miller" <davem@davemloft.net>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Roelof Berg <rberg@berg-solutions.de>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

 drivers/net/ethernet/microchip/lan743x_main.c | 32 ++++++-------------
 drivers/net/ethernet/microchip/lan743x_main.h |  1 -
 2 files changed, 9 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index f2d13e8d20f0..eb990e036611 100644
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
@@ -1021,34 +1021,19 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
 
 	netdev = adapter->netdev;
 	phynode = of_node_get(adapter->pdev->dev.of_node);
-	adapter->phy_mode = PHY_INTERFACE_MODE_GMII;
-
-	if (phynode) {
-		of_get_phy_mode(phynode, &adapter->phy_mode);
-
-		if (of_phy_is_fixed_link(phynode)) {
-			ret = of_phy_register_fixed_link(phynode);
-			if (ret) {
-				netdev_err(netdev,
-					   "cannot register fixed PHY\n");
-				of_node_put(phynode);
-				goto return_error;
-			}
-		}
-		phydev = of_phy_connect(netdev, phynode,
-					lan743x_phy_link_status_change, 0,
-					adapter->phy_mode);
-		of_node_put(phynode);
-		if (!phydev)
-			goto return_error;
-	} else {
+
+	/* try devicetree phy, or fixed link */
+	phydev = of_phy_get_and_connect(netdev, phynode,
+					lan743x_phy_link_status_change);
+	if (!phydev) {
+		/* try internal PHY */
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
@@ -1063,6 +1048,7 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
 
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

