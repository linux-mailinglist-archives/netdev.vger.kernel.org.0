Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9920E2AAB51
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 15:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728482AbgKHOHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 09:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727958AbgKHOG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 09:06:59 -0500
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5DBC0613CF;
        Sun,  8 Nov 2020 06:06:59 -0800 (PST)
Received: by mail-qk1-x742.google.com with SMTP id v143so1083130qkb.2;
        Sun, 08 Nov 2020 06:06:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=VNq4s6RSIspVZEj1oA+Z7Yg3dUDGldhxJE/AFhpqYV4=;
        b=gphR+06wSDl/Eyjj+unEraBqgAWaPWBpfOxB6Gf2HgzxTtIO8xZ/bssGB4Nx2xIA90
         IzSbD0zSCH1RZuqacoGaE5xQtq6KdYKbhOWroWqd1QZRN9eVykSV1PxtpjM2rLk9aUYy
         bsCsjcY4VTsp8KLsDKcJHAg3Gs2SQrMR9IL2IUE1o7nc0O2l5mp0Z7StZyEeifv+F8r1
         NqjYdNHDi+65v4DuHvq1Z9TQIwrDJzwghzX1g/W/CiHKXZhqCIEoBAbpcrsMjnLYQvZv
         bm0rhqdLqGXbYoP8xlZFfY8P4wUqv92aQOpLEAVgzROiVO1jgvRtjy0OfUzNtPm2dRNg
         aiag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=VNq4s6RSIspVZEj1oA+Z7Yg3dUDGldhxJE/AFhpqYV4=;
        b=cFKKYnS1cWc5oJq680DLZuqhxJxQpDiLTnZ3xWePfwan7Qav907b5aVxnYcfWFPaOo
         dlKSx8zedxim4VoVdKKrEiWYU98fD0I1dwnjd9RYkW3k9AfGs0G7lh+A29gJTviN8+DI
         J8AygNBLoB+EbNZZyP3SwusoPYOyeD2yiQZHkq04SK7yM0i/j2G9J5pcsnrBCax525S5
         W8Q0vocnDit4rWJvTJcdtqrLj4tx5MHxmYiXe6n++bimQR4mcaYPsShbjTY+lQeZ3GEd
         M0EMGMTSvJbCVyf+cV/5ytSza2jQDJ6ZT4bhSSEPu2KvCIjxh4qLetKL/I0MKuY189tY
         ViIQ==
X-Gm-Message-State: AOAM533FJdXsFflEn9SJNFkO3Q4C4PuicxKdYVXpqOsAJCM/pLDFnpRG
        iHISqOVML5fP9yKmiXfQsXs=
X-Google-Smtp-Source: ABdhPJwb8H5QlCegUQMisBoWAYuxXZKUTL/zEX6wQdZeODHHLGFu4mpqrbtbXOqkUDYvi4rDKCRitw==
X-Received: by 2002:a37:5347:: with SMTP id h68mr10003194qkb.497.1604844417580;
        Sun, 08 Nov 2020 06:06:57 -0800 (PST)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id r19sm4014319qtm.4.2020.11.08.06.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2020 06:06:57 -0800 (PST)
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
Subject: [PATCH v3] lan743x: correctly handle chips with internal PHY
Date:   Sun,  8 Nov 2020 09:06:53 -0500
Message-Id: <20201108140653.15967-1-TheSven73@gmail.com>
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

v2 -> v3:
    Andrew Lunn: make patch truly minimal.

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

 drivers/net/ethernet/microchip/lan743x_main.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index f2d13e8d20f0..54d721ef3084 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1021,9 +1021,9 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
 
 	netdev = adapter->netdev;
 	phynode = of_node_get(adapter->pdev->dev.of_node);
-	adapter->phy_mode = PHY_INTERFACE_MODE_GMII;
 
 	if (phynode) {
+		/* try devicetree phy, or fixed link */
 		of_get_phy_mode(phynode, &adapter->phy_mode);
 
 		if (of_phy_is_fixed_link(phynode)) {
@@ -1039,13 +1039,15 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
 					lan743x_phy_link_status_change, 0,
 					adapter->phy_mode);
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
 
+		adapter->phy_mode = PHY_INTERFACE_MODE_GMII;
 		ret = phy_connect_direct(netdev, phydev,
 					 lan743x_phy_link_status_change,
 					 adapter->phy_mode);
-- 
2.17.1

