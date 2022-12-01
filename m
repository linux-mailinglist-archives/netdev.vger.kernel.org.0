Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B34C63E860
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 04:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiLADku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 22:40:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLADks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 22:40:48 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BAEB70608
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 19:40:47 -0800 (PST)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NN1zm4Th1z15MvL;
        Thu,  1 Dec 2022 11:40:04 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Dec 2022 11:40:45 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 1 Dec
 2022 11:40:44 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ioana.ciornei@nxp.com>,
        <calvin.johnson@oss.nxp.com>, <grant.likely@arm.com>,
        <zengheng4@huawei.com>
Subject: [PATCH net v2] net: mdiobus: fix double put fwnode in the error path
Date:   Thu, 1 Dec 2022 11:38:38 +0800
Message-ID: <20221201033838.1938765-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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
to 0, then fwnode_handle_put() will be called in phy_device_release(),
but in the error path, fwnode_handle_put() has already been called,
so set fwnode to NULL after fwnode_handle_put() in the error path to
avoid double put.

Fixes: cdde1560118f ("net: mdiobus: fix unbalanced node reference count")
Reported-by: Zeng Heng <zengheng4@huawei.com>
Tested-by: Zeng Heng <zengheng4@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
v1 -> v2:
  Don't remove fwnode_handle_put() in the error path,
  set fwnode to NULL avoid double put.
---
 drivers/net/mdio/fwnode_mdio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index eb344f6d4a7b..9df618577712 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -99,6 +99,7 @@ int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
 	rc = phy_device_register(phy);
 	if (rc) {
 		fwnode_handle_put(child);
+		device_set_node(&phy->mdio.dev, NULL);
 		return rc;
 	}
 
@@ -154,6 +155,7 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 		rc = phy_device_register(phy);
 		if (rc) {
 			fwnode_handle_put(phy->mdio.dev.fwnode);
+			phy->mdio.dev.fwnode = NULL;
 			goto clean_phy;
 		}
 	} else if (is_of_node(child)) {
-- 
2.25.1

