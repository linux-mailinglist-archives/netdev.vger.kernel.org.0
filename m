Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37695637C6D
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 16:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiKXPDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 10:03:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiKXPDZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 10:03:25 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C927F15C529
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 07:03:22 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NJ1Nr3mRSzqSg9;
        Thu, 24 Nov 2022 22:59:24 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 23:03:21 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 24 Nov
 2022 23:03:20 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ioana.ciornei@nxp.com>,
        <calvin.johnson@oss.nxp.com>, <grant.likely@arm.com>
Subject: [PATCH net] net: mdiobus: fix unbalanced node reference count
Date:   Thu, 24 Nov 2022 23:01:30 +0800
Message-ID: <20221124150130.609420-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I got the following report while doing device(mscc-miim) load test
with CONFIG_OF_UNITTEST and CONFIG_OF_DYNAMIC enabled:

  OF: ERROR: memory leak, expected refcount 1 instead of 2,
  of_node_get()/of_node_put() unbalanced - destroy cset entry:
  attach overlay node /spi/soc@0/mdio@7107009c/ethernet-phy@0

If the 'fwnode' is not an acpi node, the refcount is get in
fwnode_mdiobus_phy_device_register(), but it has never been
put when the device is freed in the normal path. So call
fwnode_handle_put() in phy_device_release() to avoid leak.

If it's an acpi node, it has never been get, but it's put
in the error path, so call fwnode_handle_get() before
phy_device_register() to keep get/put operation balanced.

Fixes: bc1bee3b87ee ("net: mdiobus: Introduce fwnode_mdiobus_register_phy()")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/mdio/fwnode_mdio.c | 2 +-
 drivers/net/phy/phy_device.c   | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 689e728345ce..eb344f6d4a7b 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -146,11 +146,11 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 		phy->irq = bus->irq[addr];
 
 		/* Associate the fwnode with the device structure so it
 		 * can be looked up later.
 		 */
-		phy->mdio.dev.fwnode = child;
+		phy->mdio.dev.fwnode = fwnode_handle_get(child);
 
 		/* All data is now stored in the phy struct, so register it */
 		rc = phy_device_register(phy);
 		if (rc) {
 			fwnode_handle_put(phy->mdio.dev.fwnode);
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index a72adabfd2a7..8cff61dbc4b5 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -215,10 +215,11 @@ static void phy_mdio_device_free(struct mdio_device *mdiodev)
 	phy_device_free(phydev);
 }
 
 static void phy_device_release(struct device *dev)
 {
+	fwnode_handle_put(dev->fwnode);
 	kfree(to_phy_device(dev));
 }
 
 static void phy_mdio_device_remove(struct mdio_device *mdiodev)
 {
-- 
2.25.1

