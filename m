Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77BB37F730
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 13:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbhEMLxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 07:53:01 -0400
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:23201 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbhEMLw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 07:52:58 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d29 with ME
        id 4Bri2500321Fzsu03BriSG; Thu, 13 May 2021 13:51:46 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 13 May 2021 13:51:46 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, david.daney@cavium.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: mdio: thunder: Do not unregister buses that have not been registered
Date:   Thu, 13 May 2021 13:51:40 +0200
Message-Id: <918382e19fdeb172f3836234d07e706460b7d06b.1620906605.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the probe, if 'of_mdiobus_register()' fails, 'nexus->buses[i]' will
still have a non-NULL value.
So in the remove function, we will try to unregister a bus that has not
been registered.

In order to avoid that NULLify 'nexus->buses[i]'.
'oct_mdio_writeq(0,...)' must also be called here.

Suggested-by: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Fixes: 379d7ac7ca31 ("phy: mdio-thunder: Add driver for Cavium Thunder SoC MDIO buses.")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Calling 'devm_mdiobus_free()' would also be cleaner, IMHO.
I've not added it because:
   - it should be fine, even without it
   - I'm not sure how to use it

The best I could think-of (not even compile tested) is:
   devm_mdiobus_free(&pdev->dev, container_of(mii_bus, struct mdiobus_devres, mii));
which is not very nice looking.
(unless I missed something obvious!)

If I'm correct, just passing 'mii_bus' to have something that look logical
would require changing 'devm_mdiobus_alloc_size()' and
'devm_mdiobus_free()'.
---
 drivers/net/mdio/mdio-thunder.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/mdio/mdio-thunder.c b/drivers/net/mdio/mdio-thunder.c
index 822d2cdd2f35..140c405d4a41 100644
--- a/drivers/net/mdio/mdio-thunder.c
+++ b/drivers/net/mdio/mdio-thunder.c
@@ -97,8 +97,14 @@ static int thunder_mdiobus_pci_probe(struct pci_dev *pdev,
 		bus->mii_bus->write = cavium_mdiobus_write;
 
 		err = of_mdiobus_register(bus->mii_bus, node);
-		if (err)
+		if (err) {
 			dev_err(&pdev->dev, "of_mdiobus_register failed\n");
+			/* non-registered buses must not be unregistered in
+			 * the .remove function
+			 */
+			oct_mdio_writeq(0, bus->register_base + SMI_EN);
+			nexus->buses[i] = NULL;
+		}
 
 		dev_info(&pdev->dev, "Added bus at %llx\n", r.start);
 		if (i >= ARRAY_SIZE(nexus->buses))
-- 
2.30.2

