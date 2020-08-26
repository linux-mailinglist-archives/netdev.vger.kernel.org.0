Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 818AB252AB8
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 11:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbgHZJvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 05:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727997AbgHZJvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 05:51:45 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D68C061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:51:45 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1kAs5m-0006RB-IR; Wed, 26 Aug 2020 11:51:42 +0200
Received: from sha by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1kAs5l-0001Lu-VQ; Wed, 26 Aug 2020 11:51:41 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH] net: mdiobus: fix device unregistering in mdiobus_register
Date:   Wed, 26 Aug 2020 11:51:41 +0200
Message-Id: <20200826095141.5156-1-s.hauer@pengutronix.de>
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

__mdiobus_register() can fail between calling device_register() and
setting bus->state to MDIOBUS_REGISTERED. When this happens the caller
will call mdiobus_free() which then frees the mdio bus structure. This
is not allowed as the embedded struct device is already registered, thus
must be freed dropping the reference count using put_device(). To
accomplish this set bus->state to MDIOBUS_UNREGISTERED after having
registered the device. With this mdiobus_free() correctly calls
put_device() instead of freeing the mdio bus structure directly.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/net/phy/mdio_bus.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 0af20faad69d..85cbaab4a591 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -540,6 +540,8 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 		return -EINVAL;
 	}
 
+	bus->state = MDIOBUS_UNREGISTERED;
+
 	mutex_init(&bus->mdio_lock);
 	mutex_init(&bus->shared_lock);
 
-- 
2.28.0

