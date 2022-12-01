Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC89D63EC61
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 10:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiLAJZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 04:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiLAJZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 04:25:02 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33411C0
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 01:25:00 -0800 (PST)
Received: from kwepemi500024.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NN9Y23KTrzqSfP;
        Thu,  1 Dec 2022 17:20:54 +0800 (CST)
Received: from huawei.com (10.175.103.91) by kwepemi500024.china.huawei.com
 (7.221.188.100) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 1 Dec
 2022 17:24:25 +0800
From:   Zeng Heng <zengheng4@huawei.com>
To:     <f.fainelli@gmail.com>, <pabeni@redhat.com>, <andrew@lunn.ch>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <edumazet@google.com>, <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <liwei391@huawei.com>,
        <zengheng4@huawei.com>
Subject: [PATCH] net: mdio: fix unbalanced fwnode reference count in mdio_device_release()
Date:   Thu, 1 Dec 2022 17:22:02 +0800
Message-ID: <20221201092202.3394119-1-zengheng4@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500024.china.huawei.com (7.221.188.100)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is warning report about of_node refcount leak
while probing mdio device:

OF: ERROR: memory leak, expected refcount 1 instead of 2,
of_node_get()/of_node_put() unbalanced - destroy cset entry:
attach overlay node /spi/soc@0/mdio@710700c0/ethernet@4

In of_mdiobus_register_device(), we increase fwnode refcount
by fwnode_handle_get() before associating the of_node with
mdio device, but it has never been decreased after that.
Since that, in mdio_device_release(), it needs to call
fwnode_handle_put() in addition instead of calling kfree()
directly.

After above, just calling mdio_device_free() in the error handle
path of of_mdiobus_register_device() is enough to keep the
refcount balanced.

Fixes: a9049e0c513c ("mdio: Add support for mdio drivers.")
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
---
 drivers/net/mdio/of_mdio.c    | 1 -
 drivers/net/phy/mdio_device.c | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 796e9c7857d0..296317a6b333 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -69,7 +69,6 @@ static int of_mdiobus_register_device(struct mii_bus *mdio,
 	rc = mdio_device_register(mdiodev);
 	if (rc) {
 		mdio_device_free(mdiodev);
-		of_node_put(child);
 		return rc;
 	}
 
diff --git a/drivers/net/phy/mdio_device.c b/drivers/net/phy/mdio_device.c
index 250742ffdfd9..044828d081d2 100644
--- a/drivers/net/phy/mdio_device.c
+++ b/drivers/net/phy/mdio_device.c
@@ -21,6 +21,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/unistd.h>
+#include <linux/property.h>
 
 void mdio_device_free(struct mdio_device *mdiodev)
 {
@@ -30,6 +31,7 @@ EXPORT_SYMBOL(mdio_device_free);
 
 static void mdio_device_release(struct device *dev)
 {
+	fwnode_handle_put(dev->fwnode);
 	kfree(to_mdio_device(dev));
 }
 
-- 
2.25.1

