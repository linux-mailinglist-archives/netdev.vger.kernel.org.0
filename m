Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7846D37F3AE
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 09:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbhEMHrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 03:47:25 -0400
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:40717 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbhEMHqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 03:46:17 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d84 with ME
        id 47l52500E21Fzsu037l5tW; Thu, 13 May 2021 09:45:06 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 13 May 2021 09:45:06 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, david.daney@cavium.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH V2] net: mdio: thunder: Fix a double free issue in the .remove function
Date:   Thu, 13 May 2021 09:44:49 +0200
Message-Id: <f8ad9a9e6d7df4cb02731a71a418acca18353380.1620890611.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'bus->mii_bus' have been allocated with 'devm_mdiobus_alloc_size()' in the
probe function. So it must not be freed explicitly or there will be a
double free.

Remove the incorrect 'mdiobus_free' in the remove function.

Fixes: 379d7ac7ca31 ("phy: mdio-thunder: Add driver for Cavium Thunder SoC MDIO buses.")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
v2: indicate in the subject which mdio bus driver has a double free
---
 drivers/net/mdio/mdio-thunder.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/mdio/mdio-thunder.c b/drivers/net/mdio/mdio-thunder.c
index cb1761693b69..822d2cdd2f35 100644
--- a/drivers/net/mdio/mdio-thunder.c
+++ b/drivers/net/mdio/mdio-thunder.c
@@ -126,7 +126,6 @@ static void thunder_mdiobus_pci_remove(struct pci_dev *pdev)
 			continue;
 
 		mdiobus_unregister(bus->mii_bus);
-		mdiobus_free(bus->mii_bus);
 		oct_mdio_writeq(0, bus->register_base + SMI_EN);
 	}
 	pci_release_regions(pdev);
-- 
2.30.2

