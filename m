Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396862EACA3
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 15:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730012AbhAEOE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 09:04:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:56788 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727289AbhAEOEY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 09:04:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 34C54AD57;
        Tue,  5 Jan 2021 14:03:41 +0000 (UTC)
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vkoul@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Mark Brown <broonie@kernel.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-watchdog@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH 02/10] net: tc35815: Drop support for TX49XX boards
Date:   Tue,  5 Jan 2021 15:02:47 +0100
Message-Id: <20210105140305.141401-3-tsbogend@alpha.franken.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210105140305.141401-1-tsbogend@alpha.franken.de>
References: <20210105140305.141401-1-tsbogend@alpha.franken.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CPU support for TX49xx is getting removed, so remove support in network
drivers for it.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---
 drivers/net/ethernet/toshiba/tc35815.c | 29 --------------------------
 1 file changed, 29 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/tc35815.c b/drivers/net/ethernet/toshiba/tc35815.c
index 7a6e5ff8e5d4..d4712cd2e28c 100644
--- a/drivers/net/ethernet/toshiba/tc35815.c
+++ b/drivers/net/ethernet/toshiba/tc35815.c
@@ -687,39 +687,10 @@ static int tc_mii_init(struct net_device *dev)
 	return err;
 }
 
-#ifdef CONFIG_CPU_TX49XX
-/*
- * Find a platform_device providing a MAC address.  The platform code
- * should provide a "tc35815-mac" device with a MAC address in its
- * platform_data.
- */
-static int tc35815_mac_match(struct device *dev, const void *data)
-{
-	struct platform_device *plat_dev = to_platform_device(dev);
-	const struct pci_dev *pci_dev = data;
-	unsigned int id = pci_dev->irq;
-	return !strcmp(plat_dev->name, "tc35815-mac") && plat_dev->id == id;
-}
-
 static int tc35815_read_plat_dev_addr(struct net_device *dev)
 {
-	struct tc35815_local *lp = netdev_priv(dev);
-	struct device *pd = bus_find_device(&platform_bus_type, NULL,
-					    lp->pci_dev, tc35815_mac_match);
-	if (pd) {
-		if (pd->platform_data)
-			memcpy(dev->dev_addr, pd->platform_data, ETH_ALEN);
-		put_device(pd);
-		return is_valid_ether_addr(dev->dev_addr) ? 0 : -ENODEV;
-	}
 	return -ENODEV;
 }
-#else
-static int tc35815_read_plat_dev_addr(struct net_device *dev)
-{
-	return -ENODEV;
-}
-#endif
 
 static int tc35815_init_dev_addr(struct net_device *dev)
 {
-- 
2.29.2

