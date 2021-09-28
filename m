Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC2741A80F
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 07:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239673AbhI1GBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 02:01:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239437AbhI1F7e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 01:59:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E1A96124B;
        Tue, 28 Sep 2021 05:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808625;
        bh=fvfh8yN3DDXYJ+M12dUjOYlWYBVTtwZpl4APIYlurcc=;
        h=From:To:Cc:Subject:Date:From;
        b=KJKAUxhpiQ9IzykXe08TjO9K9CR2nCbYcuBUmLg3o+akjoz5X+3NBXCFXAZTAa2ac
         i5Y/mosheQiI/FyvA9cltFvF+loMWn+PpBg+YzEFma2H9TBGon9RMU7HTTHNY9pqKU
         92eityM2rTVH994WywqJ5Qrpeke9k3v0F6SdQ1YbyAHot/6v1cfxLpbU6KnE3twjhU
         /tQb7W92No0eqI2+k5UuOiKOozvybZSit5mEwTnsLcyWdmw1b4/cmu5tj0FMN/rKBn
         SJDwEsqw+mhPG3QVVC3ipMW+HPaoLSojJJzhbP8F8gItFU4Jxkvr3BaAiO5y07TWX1
         GBZMsN/igq61A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, hkallweit1@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 01/11] net: mdio: introduce a shutdown method to mdio device drivers
Date:   Tue, 28 Sep 2021 01:56:54 -0400
Message-Id: <20210928055704.172814-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
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
index c1d345c3cab3..b2dd293fc87e 100644
--- a/drivers/net/phy/mdio_device.c
+++ b/drivers/net/phy/mdio_device.c
@@ -180,6 +180,16 @@ static int mdio_remove(struct device *dev)
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
  * @new_driver: new mdio_driver to register
@@ -194,6 +204,7 @@ int mdio_driver_register(struct mdio_driver *drv)
 	mdiodrv->driver.bus = &mdio_bus_type;
 	mdiodrv->driver.probe = mdio_probe;
 	mdiodrv->driver.remove = mdio_remove;
+	mdiodrv->driver.shutdown = mdio_shutdown;
 
 	retval = driver_register(&mdiodrv->driver);
 	if (retval) {
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index a7604248777b..0f1f784de80e 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -64,6 +64,9 @@ struct mdio_driver {
 
 	/* Clears up any memory if needed */
 	void (*remove)(struct mdio_device *mdiodev);
+
+	/* Quiesces the device on system shutdown, turns off interrupts etc */
+	void (*shutdown)(struct mdio_device *mdiodev);
 };
 #define to_mdio_driver(d)						\
 	container_of(to_mdio_common_driver(d), struct mdio_driver, mdiodrv)
-- 
2.33.0

