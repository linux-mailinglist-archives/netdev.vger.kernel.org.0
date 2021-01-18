Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF552FA434
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 16:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393057AbhARPKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 10:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405408AbhARPJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 10:09:42 -0500
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF6CC061575
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 07:09:01 -0800 (PST)
Received: from ramsan.of.borg ([84.195.186.194])
        by laurent.telenet-ops.be with bizsmtp
        id JF8z2400T4C55Sk01F8zQZ; Mon, 18 Jan 2021 16:08:59 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1l1W9L-004cql-1j; Mon, 18 Jan 2021 16:08:59 +0100
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1l1W9K-003LKg-LI; Mon, 18 Jan 2021 16:08:58 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Steve Glendinning <steve.glendinning@shawell.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] net: smsc911x: Make Runtime PM handling more fine-grained
Date:   Mon, 18 Jan 2021 16:08:57 +0100
Message-Id: <20210118150857.796943-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the smsc911x driver has mininal power management: during
driver probe, the device is powered up, and during driver remove, it is
powered down.

Improve power management by making it more fine-grained:
  1. Power the device down when driver probe is finished,
  2. Power the device (down) when it is opened (closed),
  3. Make sure the device is powered during PHY access.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
Tested on r8a73a4/ape6evm, where the LAN9220 is connected to a
power-managed bus, and any attempt to access a device register while the
device is suspended will trigger an asynchronous external abort.
---
 drivers/net/ethernet/smsc/smsc911x.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index 823d9a7184fe6aa1..606c79de93a68146 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -557,6 +557,7 @@ static int smsc911x_mii_read(struct mii_bus *bus, int phyaddr, int regidx)
 	unsigned int addr;
 	int i, reg;
 
+	pm_runtime_get_sync(bus->parent);
 	spin_lock_irqsave(&pdata->mac_lock, flags);
 
 	/* Confirm MII not busy */
@@ -582,6 +583,7 @@ static int smsc911x_mii_read(struct mii_bus *bus, int phyaddr, int regidx)
 
 out:
 	spin_unlock_irqrestore(&pdata->mac_lock, flags);
+	pm_runtime_put(bus->parent);
 	return reg;
 }
 
@@ -594,6 +596,7 @@ static int smsc911x_mii_write(struct mii_bus *bus, int phyaddr, int regidx,
 	unsigned int addr;
 	int i, reg;
 
+	pm_runtime_get_sync(bus->parent);
 	spin_lock_irqsave(&pdata->mac_lock, flags);
 
 	/* Confirm MII not busy */
@@ -623,6 +626,7 @@ static int smsc911x_mii_write(struct mii_bus *bus, int phyaddr, int regidx,
 
 out:
 	spin_unlock_irqrestore(&pdata->mac_lock, flags);
+	pm_runtime_put(bus->parent);
 	return reg;
 }
 
@@ -1589,6 +1593,8 @@ static int smsc911x_open(struct net_device *dev)
 	int retval;
 	int irq_flags;
 
+	pm_runtime_get_sync(dev->dev.parent);
+
 	/* find and start the given phy */
 	if (!dev->phydev) {
 		retval = smsc911x_mii_probe(dev);
@@ -1735,6 +1741,7 @@ static int smsc911x_open(struct net_device *dev)
 	phy_disconnect(dev->phydev);
 	dev->phydev = NULL;
 out:
+	pm_runtime_put(dev->dev.parent);
 	return retval;
 }
 
@@ -1766,6 +1773,7 @@ static int smsc911x_stop(struct net_device *dev)
 		dev->phydev = NULL;
 	}
 	netif_carrier_off(dev);
+	pm_runtime_put(dev->dev.parent);
 
 	SMSC_TRACE(pdata, ifdown, "Interface stopped");
 	return 0;
@@ -2334,7 +2342,6 @@ static int smsc911x_drv_remove(struct platform_device *pdev)
 
 	free_netdev(dev);
 
-	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
 	return 0;
@@ -2540,6 +2547,7 @@ static int smsc911x_drv_probe(struct platform_device *pdev)
 	}
 
 	spin_unlock_irq(&pdata->mac_lock);
+	pm_runtime_put(&pdev->dev);
 
 	netdev_info(dev, "MAC Address: %pM\n", dev->dev_addr);
 
-- 
2.25.1

