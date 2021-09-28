Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0637641A778
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 07:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238943AbhI1F5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 01:57:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238908AbhI1F5H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 01:57:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A45F3610E6;
        Tue, 28 Sep 2021 05:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808528;
        bh=1Q9zkv9hvEGhiHeTzej8p7/NKlx/c2gGz6LQ7Bg1QQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cbUZn2kixGhZg6rAqbJMy0SyNTvnzVoBKFKBdz3zFa+/W2Kc9lEPEmZBg8+MMnykD
         41NrGZyuh2v/mWrDRexxflWIFA3HT06nN/Pft+p1/+4DymFo32D/g0viDakgfG59mH
         gleCO4KQbjRjXEsSaVxw+3yPK79HhKws7iF2E4UsXIEps56rY4gOhv/ua5quiDezoV
         qm2MgbBS432S0yGvkvPEAmPDHFZAoH8HLaPWlZ0R5+B2HTuhlIpJ+qRCyvMeUFZP1A
         kpRUEHHB00dPYKUtniUqsHtzDQpHZMDiAFOwIMDAZfdFhC07GxaYuLPitwt6kd7P00
         /OAhMlLUybBJw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, hkallweit1@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 08/40] net: mdio: introduce a shutdown method to mdio device drivers
Date:   Tue, 28 Sep 2021 01:54:52 -0400
Message-Id: <20210928055524.172051-8-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055524.172051-1-sashal@kernel.org>
References: <20210928055524.172051-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit cf9579976f724ad517cc15b7caadea728c7e245c ]

MDIO-attached devices might have interrupts and other things that might
need quiesced when we kexec into a new kernel. Things are even more
creepy when those interrupt lines are shared, and in that case it is
absolutely mandatory to disable all interrupt sources.

Moreover, MDIO devices might be DSA switches, and DSA needs its own
shutdown method to unlink from the DSA master, which is a new
requirement that appeared after commit 2f1e8ea726e9 ("net: dsa: link
interfaces with the DSA master to get rid of lockdep warnings").

So introduce a ->shutdown method in the MDIO device driver structure.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mdio_device.c | 11 +++++++++++
 include/linux/mdio.h          |  3 +++
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/phy/mdio_device.c b/drivers/net/phy/mdio_device.c
index c94cb5382dc9..250742ffdfd9 100644
--- a/drivers/net/phy/mdio_device.c
+++ b/drivers/net/phy/mdio_device.c
@@ -179,6 +179,16 @@ static int mdio_remove(struct device *dev)
 	return 0;
 }
 
+static void mdio_shutdown(struct device *dev)
+{
+	struct mdio_device *mdiodev = to_mdio_device(dev);
+	struct device_driver *drv = mdiodev->dev.driver;
+	struct mdio_driver *mdiodrv = to_mdio_driver(drv);
+
+	if (mdiodrv->shutdown)
+		mdiodrv->shutdown(mdiodev);
+}
+
 /**
  * mdio_driver_register - register an mdio_driver with the MDIO layer
  * @drv: new mdio_driver to register
@@ -193,6 +203,7 @@ int mdio_driver_register(struct mdio_driver *drv)
 	mdiodrv->driver.bus = &mdio_bus_type;
 	mdiodrv->driver.probe = mdio_probe;
 	mdiodrv->driver.remove = mdio_remove;
+	mdiodrv->driver.shutdown = mdio_shutdown;
 
 	retval = driver_register(&mdiodrv->driver);
 	if (retval) {
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index ffb787d5ebde..5e6dc38f418e 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -80,6 +80,9 @@ struct mdio_driver {
 
 	/* Clears up any memory if needed */
 	void (*remove)(struct mdio_device *mdiodev);
+
+	/* Quiesces the device on system shutdown, turns off interrupts etc */
+	void (*shutdown)(struct mdio_device *mdiodev);
 };
 
 static inline struct mdio_driver *
-- 
2.33.0

