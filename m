Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC276253E96
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 09:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbgH0HG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 03:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726123AbgH0HGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 03:06:25 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A99C061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 00:06:24 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1kBBzL-0006Wd-Cz; Thu, 27 Aug 2020 09:06:23 +0200
Received: from sha by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1kBBzL-00076D-3Z; Thu, 27 Aug 2020 09:06:23 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCHi v2] net: mdiobus: fix device unregistering in mdiobus_register
Date:   Thu, 27 Aug 2020 09:06:18 +0200
Message-Id: <20200827070618.26754-1-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After device_register has been called the device structure may not be
freed anymore, put_device() has to be called instead. This gets violated
when device_register() or any of the following steps before the mdio
bus is fully registered fails. In this case the caller will call
mdiobus_free() which then directly frees the mdio bus structure.

Set bus->state to MDIOBUS_UNREGISTERED right before calling
device_register(). With this mdiobus_free() calls put_device() instead
as it ought to be.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---

Changes since v1:
- set bus->state before calling device_register(), not afterwards

 drivers/net/phy/mdio_bus.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 0af20faad69d..9434b04a11c8 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -534,6 +534,8 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	bus->dev.groups = NULL;
 	dev_set_name(&bus->dev, "%s", bus->id);
 
+	bus->state = MDIOBUS_UNREGISTERED;
+
 	err = device_register(&bus->dev);
 	if (err) {
 		pr_err("mii_bus %s failed to register\n", bus->id);
-- 
2.28.0

