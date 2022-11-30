Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDC2C63D19D
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 10:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiK3JUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 04:20:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiK3JUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 04:20:07 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80CCE391F8
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 01:20:06 -0800 (PST)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NMYYl6FL2zmWGT;
        Wed, 30 Nov 2022 17:19:23 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 30 Nov 2022 17:20:04 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 30 Nov
 2022 17:20:03 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ioana.ciornei@nxp.com>,
        <calvin.johnson@oss.nxp.com>, <grant.likely@arm.com>,
        <zengheng4@huawei.com>
Subject: [PATCH net] net: mdiobus: remove unneccessary fwnode_handle_put() in the error path
Date:   Wed, 30 Nov 2022 17:17:59 +0800
Message-ID: <20221130091759.682841-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If phy_device_register() or fwnode_mdiobus_phy_device_register()
fail, phy_device_free() is called, the device refcount is decreased
to 0, then fwnode_handle_put() is called in phy_device_release(),
so the fwnode_handle_put() in the error path can be removed to avoid
double put.

Fixes: cdde1560118f ("net: mdiobus: fix unbalanced node reference count")
Reported-by: Zeng Heng <zengheng4@huawei.com>
Tested-by: Zeng Heng <zengheng4@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/mdio/fwnode_mdio.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index eb344f6d4a7b..e584abda585b 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -97,10 +97,8 @@ int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
 	 * register it
 	 */
 	rc = phy_device_register(phy);
-	if (rc) {
-		fwnode_handle_put(child);
+	if (rc)
 		return rc;
-	}
 
 	dev_dbg(&mdio->dev, "registered phy %p fwnode at address %i\n",
 		child, addr);
@@ -152,10 +150,8 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 
 		/* All data is now stored in the phy struct, so register it */
 		rc = phy_device_register(phy);
-		if (rc) {
-			fwnode_handle_put(phy->mdio.dev.fwnode);
+		if (rc)
 			goto clean_phy;
-		}
 	} else if (is_of_node(child)) {
 		rc = fwnode_mdiobus_phy_device_register(bus, phy, child, addr);
 		if (rc)
-- 
2.25.1

