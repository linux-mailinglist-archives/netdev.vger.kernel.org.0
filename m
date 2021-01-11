Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644142F129A
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 13:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbhAKMyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 07:54:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbhAKMyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 07:54:46 -0500
Received: from mail-out.m-online.net (mail-out.m-online.net [IPv6:2001:a60:0:28:0:1:25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CF2C061786
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 04:53:50 -0800 (PST)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4DDttj3XVbz1rx85;
        Mon, 11 Jan 2021 13:53:49 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4DDttj339tz1qr4N;
        Mon, 11 Jan 2021 13:53:49 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id qjYfmKHtiE35; Mon, 11 Jan 2021 13:53:48 +0100 (CET)
X-Auth-Info: yDttlOLt8cm0sylkFT5IXjxlPmM9q7Pk9LNbrJWrEbc=
Received: from tr.lan (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Mon, 11 Jan 2021 13:53:48 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: [PATCH net-next] net: ks8851: Connect and start/stop the internal PHY
Date:   Mon, 11 Jan 2021 13:53:37 +0100
Message-Id: <20210111125337.36513-1-marex@denx.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unless the internal PHY is connected and started, the phylib will not
poll the PHY for state and produce state updates. Connect the PHY and
start/stop it.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Lukas Wunner <lukas@wunner.de>
---
 drivers/net/ethernet/micrel/ks8851.h        |  2 ++
 drivers/net/ethernet/micrel/ks8851_common.c | 28 +++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/drivers/net/ethernet/micrel/ks8851.h b/drivers/net/ethernet/micrel/ks8851.h
index e2eb0caeac82..ef13929036cf 100644
--- a/drivers/net/ethernet/micrel/ks8851.h
+++ b/drivers/net/ethernet/micrel/ks8851.h
@@ -359,6 +359,7 @@ union ks8851_tx_hdr {
  * @vdd_io: Optional digital power supply for IO
  * @gpio: Optional reset_n gpio
  * @mii_bus: Pointer to MII bus structure
+ * @phy_dev: Pointer to PHY device structure
  * @lock: Bus access lock callback
  * @unlock: Bus access unlock callback
  * @rdreg16: 16bit register read callback
@@ -405,6 +406,7 @@ struct ks8851_net {
 	struct regulator	*vdd_io;
 	int			gpio;
 	struct mii_bus		*mii_bus;
+	struct phy_device	*phy_dev;
 
 	void			(*lock)(struct ks8851_net *ks,
 					unsigned long *flags);
diff --git a/drivers/net/ethernet/micrel/ks8851_common.c b/drivers/net/ethernet/micrel/ks8851_common.c
index 058fd99bd483..a3716fd2d858 100644
--- a/drivers/net/ethernet/micrel/ks8851_common.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.c
@@ -432,6 +432,11 @@ static void ks8851_flush_tx_work(struct ks8851_net *ks)
 		ks->flush_tx_work(ks);
 }
 
+static void ks8851_handle_link_change(struct net_device *net)
+{
+	phy_print_status(net->phydev);
+}
+
 /**
  * ks8851_net_open - open network device
  * @dev: The network device being opened.
@@ -445,11 +450,22 @@ static int ks8851_net_open(struct net_device *dev)
 	unsigned long flags;
 	int ret;
 
+	ret = phy_connect_direct(ks->netdev, ks->phy_dev,
+				 &ks8851_handle_link_change,
+				 PHY_INTERFACE_MODE_INTERNAL);
+	if (ret) {
+		netdev_err(dev, "failed to attach PHY\n");
+		return ret;
+	}
+
+	phy_attached_info(ks->phy_dev);
+
 	ret = request_threaded_irq(dev->irq, NULL, ks8851_irq,
 				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
 				   dev->name, ks);
 	if (ret < 0) {
 		netdev_err(dev, "failed to get irq\n");
+		phy_disconnect(ks->phy_dev);
 		return ret;
 	}
 
@@ -507,6 +523,7 @@ static int ks8851_net_open(struct net_device *dev)
 	netif_dbg(ks, ifup, ks->netdev, "network device up\n");
 
 	ks8851_unlock(ks, &flags);
+	phy_start(ks->phy_dev);
 	mii_check_link(&ks->mii);
 	return 0;
 }
@@ -528,6 +545,9 @@ static int ks8851_net_stop(struct net_device *dev)
 
 	netif_stop_queue(dev);
 
+	phy_stop(ks->phy_dev);
+	phy_disconnect(ks->phy_dev);
+
 	ks8851_lock(ks, &flags);
 	/* turn off the IRQs and ack any outstanding */
 	ks8851_wrreg16(ks, KS_IER, 0x0000);
@@ -1084,6 +1104,7 @@ int ks8851_resume(struct device *dev)
 
 static int ks8851_register_mdiobus(struct ks8851_net *ks, struct device *dev)
 {
+	struct phy_device *phy_dev;
 	struct mii_bus *mii_bus;
 	int ret;
 
@@ -1103,10 +1124,17 @@ static int ks8851_register_mdiobus(struct ks8851_net *ks, struct device *dev)
 	if (ret)
 		goto err_mdiobus_register;
 
+	phy_dev = phy_find_first(mii_bus);
+	if (!phy_dev)
+		goto err_find_phy;
+
 	ks->mii_bus = mii_bus;
+	ks->phy_dev = phy_dev;
 
 	return 0;
 
+err_find_phy:
+	mdiobus_unregister(mii_bus);
 err_mdiobus_register:
 	mdiobus_free(mii_bus);
 	return ret;
-- 
2.29.2

