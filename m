Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26A35A08E7
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 19:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbfH1Rru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 13:47:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:20452 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbfH1Rru (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 13:47:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Aug 2019 10:47:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,442,1559545200"; 
   d="scan'208";a="192675244"
Received: from glass.png.intel.com ([172.30.181.95])
  by orsmga002.jf.intel.com with ESMTP; 28 Aug 2019 10:47:28 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     davem@davemloft.net, linux@armlinux.org.uk,
        mcoquelin.stm32@gmail.com, joabreu@synopsys.com,
        f.fainelli@gmail.com, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        weifeng.voon@intel.com
Subject: [RFC net-next v2 1/5] net: phy: make mdiobus_create_device() function callable from Eth driver
Date:   Thu, 29 Aug 2019 01:47:18 +0800
Message-Id: <20190828174722.6726-2-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190828174722.6726-1-boon.leong.ong@intel.com>
References: <20190828174722.6726-1-boon.leong.ong@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PHY converter and external PHY drivers depend on MDIO functions of Eth
driver and such MDIO read/write completion may fire IRQ. The ISR for MDIO
completion IRQ is done in the open() function of driver.

For PHY converter mdio driver that registers ISR event that uses MDIO
read/write function during its probe() function, the MDIO ISR should have
been performed a head of time before mdio driver probe() is called. It is
for reason as such, the mdio device creation and registration will need
to be callable from Eth driver open() function.

Why existing way to register mdio_device for PHY converter that is done
via mdiobus_register_board_info() is not feasible is the mdio device
creation and registration happens inside Eth driver probe() function,
specifically in mdiobus_setup_mdiodevfrom_board_info() that is called
by mdiobus_register().

Therefore, to fulfill the need mentioned above, we make mdiobus_create_
device() to be callable from Eth driver open().

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/phy/mdio_bus.c | 5 +++--
 include/linux/phy.h        | 7 +++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index bd04fe762056..06658d9197a1 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -338,8 +338,8 @@ static inline void of_mdiobus_link_mdiodev(struct mii_bus *mdio,
  *
  * Returns 0 on success or < 0 on error.
  */
-static int mdiobus_create_device(struct mii_bus *bus,
-				 struct mdio_board_info *bi)
+int mdiobus_create_device(struct mii_bus *bus,
+			  struct mdio_board_info *bi)
 {
 	struct mdio_device *mdiodev;
 	int ret = 0;
@@ -359,6 +359,7 @@ static int mdiobus_create_device(struct mii_bus *bus,
 
 	return ret;
 }
+EXPORT_SYMBOL(mdiobus_create_device);
 
 /**
  * __mdiobus_register - bring up all the PHYs on a given bus and attach them to bus
diff --git a/include/linux/phy.h b/include/linux/phy.h
index d26779f1fb6b..4524db57fe0b 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1249,12 +1249,19 @@ struct mdio_board_info {
 #if IS_ENABLED(CONFIG_MDIO_DEVICE)
 int mdiobus_register_board_info(const struct mdio_board_info *info,
 				unsigned int n);
+int mdiobus_create_device(struct mii_bus *bus, struct mdio_board_info *bi);
 #else
 static inline int mdiobus_register_board_info(const struct mdio_board_info *i,
 					      unsigned int n)
 {
 	return 0;
 }
+
+static inline int mdiobus_create_device(struct mii_bus *bus,
+					struct mdio_board_info *bi)
+{
+	return 0;
+}
 #endif
 
 
-- 
2.17.0

