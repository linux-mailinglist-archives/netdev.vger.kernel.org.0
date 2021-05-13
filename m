Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8870C37F38E
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 09:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbhEMH0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 03:26:11 -0400
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:18199 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbhEMH0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 03:26:09 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d84 with ME
        id 47Qx2500821Fzsu037QxlK; Thu, 13 May 2021 09:24:59 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 13 May 2021 09:24:59 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: mdio: octeon: Fix some double free issues
Date:   Thu, 13 May 2021 09:24:55 +0200
Message-Id: <7adc1815237605a0b774efb31a2ab22df51462d3.1620890610.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'bus->mii_bus' has been allocated with 'devm_mdiobus_alloc_size()' in the
probe function. So it must not be freed explicitly or there will be a
double free.

Remove the incorrect 'mdiobus_free' in the error handling path of the
probe function and in remove function.

Suggested-By: Andrew Lunn <andrew@lunn.ch>
Fixes: 35d2aeac9810 ("phy: mdio-octeon: Use devm_mdiobus_alloc_size()")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
The 'smi_en.u64 = 0; oct_mdio_writeq()' looks odd to me. Usually the normal
path and the error handling path don't write the same value. Here, both
write 0.
Having '1' somewhere would 'look' more usual. :)
More over I think that 'smi_en.s.en = 1;' in the probe is useless.
I don't know what this code is supposed to do, so I leave it as-is.
But it looks like a left-over from a6d678645210.
---
 drivers/net/mdio/mdio-octeon.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/mdio/mdio-octeon.c b/drivers/net/mdio/mdio-octeon.c
index 8ce99c4888e1..e096e68ac667 100644
--- a/drivers/net/mdio/mdio-octeon.c
+++ b/drivers/net/mdio/mdio-octeon.c
@@ -71,7 +71,6 @@ static int octeon_mdiobus_probe(struct platform_device *pdev)
 
 	return 0;
 fail_register:
-	mdiobus_free(bus->mii_bus);
 	smi_en.u64 = 0;
 	oct_mdio_writeq(smi_en.u64, bus->register_base + SMI_EN);
 	return err;
@@ -85,7 +84,6 @@ static int octeon_mdiobus_remove(struct platform_device *pdev)
 	bus = platform_get_drvdata(pdev);
 
 	mdiobus_unregister(bus->mii_bus);
-	mdiobus_free(bus->mii_bus);
 	smi_en.u64 = 0;
 	oct_mdio_writeq(smi_en.u64, bus->register_base + SMI_EN);
 	return 0;
-- 
2.30.2

