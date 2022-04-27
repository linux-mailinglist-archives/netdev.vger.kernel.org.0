Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1121B511166
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 08:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358217AbiD0GpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 02:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242894AbiD0GpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 02:45:02 -0400
Received: from mailout1.hostsharing.net (mailout1.hostsharing.net [83.223.95.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906561D0CE;
        Tue, 26 Apr 2022 23:41:52 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout1.hostsharing.net (Postfix) with ESMTPS id 0E0401007A26C;
        Wed, 27 Apr 2022 08:41:51 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id D28186000F33;
        Wed, 27 Apr 2022 08:41:50 +0200 (CEST)
X-Mailbox-Line: From 6710d8c18ff54139cdc538763ba544187c5a0cee Mon Sep 17 00:00:00 2001
Message-Id: <6710d8c18ff54139cdc538763ba544187c5a0cee.1651041411.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Wed, 27 Apr 2022 08:41:49 +0200
Subject: [PATCH net] usbnet: smsc95xx: Fix deadlock on runtime resume
To:     Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 05b35e7eb9a1 ("smsc95xx: add phylib support") amended
smsc95xx_resume() to call phy_init_hw().  That function waits for the
device to runtime resume even though it is placed in the runtime resume
path, causing a deadlock.

The problem is that phy_init_hw() calls down to smsc95xx_mdiobus_read(),
which never uses the _nopm variant of usbnet_read_cmd().  Amend it to
autosense that it's called from the runtime resume/suspend path and use
the _nopm variant if so.

Stacktrace for posterity:

  INFO: task kworker/2:1:49 blocked for more than 122 seconds.
  Workqueue: usb_hub_wq hub_event
  schedule
  rpm_resume
  __pm_runtime_resume
  usb_autopm_get_interface
  usbnet_read_cmd
  __smsc95xx_read_reg
  __smsc95xx_phy_wait_not_busy
  __smsc95xx_mdio_read
  smsc95xx_mdiobus_read
  __mdiobus_read
  mdiobus_read
  smsc_phy_reset
  phy_init_hw
  smsc95xx_resume
  usb_resume_interface
  usb_resume_both
  usb_runtime_resume
  __rpm_callback
  rpm_callback
  rpm_resume
  __pm_runtime_resume
  usb_autoresume_device
  hub_event
  process_one_work

Fixes: 05b35e7eb9a1 ("smsc95xx: add phylib support")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v5.10+
Cc: Andre Edich <andre.edich@microchip.com>
---
 drivers/net/usb/smsc95xx.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 4ef61f6b85df..82b8feaa5162 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -285,11 +285,21 @@ static void smsc95xx_mdio_write_nopm(struct usbnet *dev, int idx, int regval)
 	__smsc95xx_mdio_write(dev, pdata->phydev->mdio.addr, idx, regval, 1);
 }
 
+static bool smsc95xx_in_pm(struct usbnet *dev)
+{
+#ifdef CONFIG_PM
+	return dev->udev->dev.power.runtime_status == RPM_RESUMING ||
+	       dev->udev->dev.power.runtime_status == RPM_SUSPENDING;
+#else
+	return false;
+#endif
+}
+
 static int smsc95xx_mdiobus_read(struct mii_bus *bus, int phy_id, int idx)
 {
 	struct usbnet *dev = bus->priv;
 
-	return __smsc95xx_mdio_read(dev, phy_id, idx, 0);
+	return __smsc95xx_mdio_read(dev, phy_id, idx, smsc95xx_in_pm(dev));
 }
 
 static int smsc95xx_mdiobus_write(struct mii_bus *bus, int phy_id, int idx,
@@ -297,7 +307,7 @@ static int smsc95xx_mdiobus_write(struct mii_bus *bus, int phy_id, int idx,
 {
 	struct usbnet *dev = bus->priv;
 
-	__smsc95xx_mdio_write(dev, phy_id, idx, regval, 0);
+	__smsc95xx_mdio_write(dev, phy_id, idx, regval, smsc95xx_in_pm(dev));
 	return 0;
 }
 
-- 
2.35.2

