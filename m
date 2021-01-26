Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D10304490
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 18:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbhAZRDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 12:03:04 -0500
Received: from atl4mhfb03.myregisteredsite.com ([209.17.115.119]:35594 "EHLO
        atl4mhfb03.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389599AbhAZHpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 02:45:09 -0500
Received: from jax4mhob02.registeredsite.com (jax4mhob02.myregisteredsite.com [64.69.218.82])
        by atl4mhfb03.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id 10Q7ZjQh028135
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 02:35:46 -0500
Received: from mailpod.hostingplatform.com ([10.30.71.206])
        by jax4mhob02.registeredsite.com (8.14.4/8.14.4) with ESMTP id 10Q7Xwl6002079
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 02:33:59 -0500
Received: (qmail 22912 invoked by uid 0); 26 Jan 2021 07:33:58 -0000
X-TCPREMOTEIP: 83.128.90.119
X-Authenticated-UID: mike@milosoftware.com
Received: from unknown (HELO phenom.domain?not?set.invalid) (mike@milosoftware.com@83.128.90.119)
  by 0 with ESMTPA; 26 Jan 2021 07:33:58 -0000
From:   Mike Looijmans <mike.looijmans@topic.nl>
To:     netdev@vger.kernel.org
Cc:     Mike Looijmans <mike.looijmans@topic.nl>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: mdiobus: Prevent spike on MDIO bus reset signal
Date:   Tue, 26 Jan 2021 08:33:37 +0100
Message-Id: <20210126073337.20393-1-mike.looijmans@topic.nl>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mdio_bus reset code first de-asserted the reset by allocating with
GPIOD_OUT_LOW, then asserted and de-asserted again. In other words, if
the reset signal defaulted to asserted, there'd be a short "spike"
before the reset.

Instead, directly assert the reset signal using GPIOD_OUT_HIGH, this
removes the spike and also removes a line of code since the signal
is already high.

Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>

---

 drivers/net/phy/mdio_bus.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 2b42e46066b4..34e98ae75110 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -543,8 +543,8 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	mutex_init(&bus->mdio_lock);
 	mutex_init(&bus->shared_lock);
 
-	/* de-assert bus level PHY GPIO reset */
-	gpiod = devm_gpiod_get_optional(&bus->dev, "reset", GPIOD_OUT_LOW);
+	/* assert bus level PHY GPIO reset */
+	gpiod = devm_gpiod_get_optional(&bus->dev, "reset", GPIOD_OUT_HIGH);
 	if (IS_ERR(gpiod)) {
 		err = dev_err_probe(&bus->dev, PTR_ERR(gpiod),
 				    "mii_bus %s couldn't get reset GPIO\n",
@@ -553,8 +553,6 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 		return err;
 	} else	if (gpiod) {
 		bus->reset_gpiod = gpiod;
-
-		gpiod_set_value_cansleep(gpiod, 1);
 		fsleep(bus->reset_delay_us);
 		gpiod_set_value_cansleep(gpiod, 0);
 		if (bus->reset_post_delay_us > 0)
-- 
2.17.1

