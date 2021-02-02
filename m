Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3C830C1E7
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 15:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234626AbhBBOfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 09:35:38 -0500
Received: from atl4mhfb01.myregisteredsite.com ([209.17.115.55]:56480 "EHLO
        atl4mhfb01.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234624AbhBBOed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 09:34:33 -0500
Received: from jax4mhob08.registeredsite.com (jax4mhob08.myregisteredsite.com [64.69.218.88])
        by atl4mhfb01.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id 112EXhdA013145
        for <netdev@vger.kernel.org>; Tue, 2 Feb 2021 09:33:44 -0500
Received: from mailpod.hostingplatform.com ([10.30.71.204])
        by jax4mhob08.registeredsite.com (8.14.4/8.14.4) with ESMTP id 112EWkri002309
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <netdev@vger.kernel.org>; Tue, 2 Feb 2021 09:32:46 -0500
Received: (qmail 12776 invoked by uid 0); 2 Feb 2021 14:32:45 -0000
X-TCPREMOTEIP: 83.128.90.119
X-Authenticated-UID: mike@milosoftware.com
Received: from unknown (HELO phenom.domain?not?set.invalid) (mike@milosoftware.com@83.128.90.119)
  by 0 with ESMTPA; 2 Feb 2021 14:32:45 -0000
From:   Mike Looijmans <mike.looijmans@topic.nl>
To:     netdev@vger.kernel.org
Cc:     Mike Looijmans <mike.looijmans@topic.nl>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: mdiobus: Prevent spike on MDIO bus reset signal
Date:   Tue,  2 Feb 2021 15:32:39 +0100
Message-Id: <20210202143239.10714-1-mike.looijmans@topic.nl>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mdio_bus reset code first de-asserted the reset by allocating with
GPIOD_OUT_LOW, then asserted and de-asserted again. In other words, if
the reset signal defaulted to asserted, there'd be a short "spike"
before the reset.

Here is what happens depending on the pre-existing state of the reset
signal:
Reset (previously asserted):   ~~~|_|~~~~|_______
Reset (previously deasserted): _____|~~~~|_______
                                  ^ ^    ^
                                  A B    C

At point A, the low going transition is because the reset line is
requested using GPIOD_OUT_LOW. If the line is successfully requested,
the first thing we do is set it high _without_ any delay. This is
point B. So, a glitch occurs between A and B.

We then fsleep() and finally set the GPIO low at point C.

Requesting the line using GPIOD_OUT_HIGH eliminates the A and B
transitions. Instead we get:

Reset (previously asserted)  : ~~~~~~~~~~|______
Reset (previously deasserted): ____|~~~~~|______
                                   ^     ^
                                   A     C

Where A and C are the points described above in the code. Point B
has been eliminated.

The issue was found when we pulled down the reset signal for the
Marvell 88E1512P PHY (because it requires at least 50ms after POR with
an active clock). Looking at the reset signal with a scope revealed a
short spike, point B in the artwork above.

Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>

---

Changes in v2:
Put more explanation into the commit text, and the artwork from Russell King

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

