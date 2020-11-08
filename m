Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296782AAC92
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 18:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728631AbgKHRMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 12:12:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727844AbgKHRMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 12:12:31 -0500
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F070C0613CF;
        Sun,  8 Nov 2020 09:12:31 -0800 (PST)
Received: by mail-qt1-x843.google.com with SMTP id h12so4444547qtc.9;
        Sun, 08 Nov 2020 09:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=MClHgAP5hHmr0+woa8Qy2J28YcTU2KN4DXYiX9v2Los=;
        b=sE6E2R1HheNfLBxQjyY7TA5GFa2k5+mTI8nGVvfST3hDzZ5qlqMaYKMp3DwzdAO6Ty
         3NPg9k9XBwaiIYblOi3DBq6eogtzOEnrPmZtzM/sbavyaVWCo49/lwgPPyqkRVlvjszr
         wDwvxe/9UCFFEAMza5ghMn0lBOZ0eHnbZO8obGQ22DHq555JwydPHRUg7FVHXpESynns
         xSpJRw3o2jlKkRil+0NNOaLWV1CHf5fan4gJsIVMGhmko/EQRjZy7tnqXWphada7ycoX
         kN5I+4UZOTsWkh1TF4z3glsbx+3YTp5WvCQxqDIo8XWJGp7PyWQZmQZ6CAVPEH6W8M34
         HaNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MClHgAP5hHmr0+woa8Qy2J28YcTU2KN4DXYiX9v2Los=;
        b=nRO5RloZXAeFVKRZDilcOJU3rFtxC0ihFuc/zdoytYvHh0FeKOWvWgoWwvrZrBZ3bi
         Dvrx7oz1UCHusJ0HNKvxXFU0Fy1BvFWoIhgHnnuzBFYBRQbW7EVAKTx5Yu0qP78u7gnH
         0yKYH8Q+kmDUfhTAlr4DFlu5HJhTcK30P4/dIfKxX6TgKxQyfo3ZN2ogOc056hbO8Lgd
         B+DRybXneJeuq+2ev4z9c5LKRyQegmw5vXZAN6XVz/8LZ4ul87gdAjfv5LkbcEE4Qwau
         uSKR9/i2vF2R3NlfleQ0bPvngA73ZF/dm9H4XyCzYOh4RjtJJ/+rpdtmON5vVhoM08zR
         wyTA==
X-Gm-Message-State: AOAM532tTlhpZnUtvBVy+q5hTRsi6X7ZYuDLdwt2lKa2x29cwaQ22rbw
        Vcz3KwOWjhjZ2Tsf2I+5ORg=
X-Google-Smtp-Source: ABdhPJxil7462uTbny4Lg0h8PFdH8xIOWRIKADmMxJj2nk1gGfvgmXs5k7u/U0WnCvFkj9u2KUMOhQ==
X-Received: by 2002:ac8:5c05:: with SMTP id i5mr10012326qti.34.1604855548783;
        Sun, 08 Nov 2020 09:12:28 -0800 (PST)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id d140sm672958qke.59.2020.11.08.09.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2020 09:12:28 -0800 (PST)
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
Subject: [PATCH net v4] lan743x: correctly handle chips with internal PHY
Date:   Sun,  8 Nov 2020 12:12:24 -0500
Message-Id: <20201108171224.23829-1-TheSven73@gmail.com>
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
---

v3 -> v4:
    Andrew Lunn:
        - create patch against davem/net tree
        - add his Reviewed-by tag

v2 -> v3:
    Andrew Lunn: make patch truly minimal.

v1 -> v2:
    Andrew Lunn: keep patch minimal and correct, so keep open-coded version
    of of_phy_get_and_connect().

    Jakub Kicinski: fix e-mail address case.

Tree: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git # 4e0396c59559

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
index a1938842f828..bd77877cf1cc 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1026,9 +1026,9 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
 
 	netdev = adapter->netdev;
 	phynode = of_node_get(adapter->pdev->dev.of_node);
-	adapter->phy_mode = PHY_INTERFACE_MODE_GMII;
 
 	if (phynode) {
+		/* try devicetree phy, or fixed link */
 		of_get_phy_mode(phynode, &adapter->phy_mode);
 
 		if (of_phy_is_fixed_link(phynode)) {
@@ -1044,13 +1044,15 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
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

