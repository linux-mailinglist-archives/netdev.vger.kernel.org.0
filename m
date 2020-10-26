Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0230D2992F6
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 17:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1786547AbgJZQwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 12:52:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1786535AbgJZQvV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 12:51:21 -0400
Received: from localhost.localdomain (unknown [192.30.34.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B17B6221FC;
        Mon, 26 Oct 2020 16:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603731080;
        bh=wui+vcDuN0AcDCQeYoxVCBxoDJwguAl4YnYFKLeL30g=;
        h=From:To:Cc:Subject:Date:From;
        b=Vg2PW0f2/oEQRU77JJ8sJpl4t8on8IH1M7S+M3DFL+ISywnOueA1PKm9z0P5OhvbK
         WAHvIDIHoVbShq6CK5MRpVWSYcDJTHZc6m2ku+7Ijv0VS9MtcD3nrxwpZ/oY2hIo74
         pteQs+DtEVKkcdL4Ipb5n6usLYIDsKUolYVybJEM=
From:   Arnd Bergmann <arnd@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mdio: use inline functions for to_mdio_device() etc
Date:   Mon, 26 Oct 2020 17:51:09 +0100
Message-Id: <20201026165113.3723159-1-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Nesting container_of() causes warnings with W=2, and doing this
in a header means we see a lot of them, like:

In file included from drivers/net/mdio/of_mdio.c:11:
drivers/net/mdio/of_mdio.c: In function 'of_phy_find_device':
include/linux/kernel.h:852:8: warning: declaration of '__mptr' shadows a previous local [-Wshadow]
  852 |  void *__mptr = (void *)(ptr);     \
      |        ^~~~~~
include/linux/phy.h:655:26: note: in expansion of macro 'container_of'
  655 | #define to_phy_device(d) container_of(to_mdio_device(d), \
      |                          ^~~~~~~~~~~~
include/linux/mdio.h:52:27: note: in expansion of macro 'container_of'
   52 | #define to_mdio_device(d) container_of(d, struct mdio_device, dev)
      |                           ^~~~~~~~~~~~
include/linux/phy.h:655:39: note: in expansion of macro 'to_mdio_device'
  655 | #define to_phy_device(d) container_of(to_mdio_device(d), \
      |                                       ^~~~~~~~~~~~~~
drivers/net/mdio/of_mdio.c:379:10: note: in expansion of macro 'to_phy_device'
  379 |   return to_phy_device(&mdiodev->dev);
      |          ^~~~~~~~~~~~~
include/linux/kernel.h:852:8: note: shadowed declaration is here
  852 |  void *__mptr = (void *)(ptr);     \
      |        ^~~~~~
include/linux/phy.h:655:26: note: in expansion of macro 'container_of'
  655 | #define to_phy_device(d) container_of(to_mdio_device(d), \
      |                          ^~~~~~~~~~~~
drivers/net/mdio/of_mdio.c:379:10: note: in expansion of macro 'to_phy_device'
  379 |   return to_phy_device(&mdiodev->dev);
      |          ^~~~~~~~~~~~~

Redefine the macros in linux/mdio.h as inline functions to avoid this
problem.

Fixes: a9049e0c513c ("mdio: Add support for mdio drivers.")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/mdio.h | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index dbd69b3d170b..7c059cb8e069 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -49,7 +49,10 @@ struct mdio_device {
 	unsigned int reset_assert_delay;
 	unsigned int reset_deassert_delay;
 };
-#define to_mdio_device(d) container_of(d, struct mdio_device, dev)
+static inline struct mdio_device *to_mdio_device(struct device *dev)
+{
+	return container_of(dev, struct mdio_device, dev);
+}
 
 /* struct mdio_driver_common: Common to all MDIO drivers */
 struct mdio_driver_common {
@@ -57,8 +60,11 @@ struct mdio_driver_common {
 	int flags;
 };
 #define MDIO_DEVICE_FLAG_PHY		1
-#define to_mdio_common_driver(d) \
-	container_of(d, struct mdio_driver_common, driver)
+static inline struct mdio_driver_common *
+to_mdio_common_driver(struct device_driver *drv)
+{
+	return container_of(drv, struct mdio_driver_common, driver);
+}
 
 /* struct mdio_driver: Generic MDIO driver */
 struct mdio_driver {
@@ -73,8 +79,12 @@ struct mdio_driver {
 	/* Clears up any memory if needed */
 	void (*remove)(struct mdio_device *mdiodev);
 };
-#define to_mdio_driver(d)						\
-	container_of(to_mdio_common_driver(d), struct mdio_driver, mdiodrv)
+
+static inline struct mdio_driver *to_mdio_driver(struct device_driver *drv)
+{
+	struct mdio_driver_common *common = to_mdio_common_driver(drv);
+	return container_of(common, struct mdio_driver, mdiodrv);
+}
 
 /* device driver data */
 static inline void mdiodev_set_drvdata(struct mdio_device *mdio, void *data)
-- 
2.27.0

