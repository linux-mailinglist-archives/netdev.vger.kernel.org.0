Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D503A636034
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 14:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236245AbiKWNm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 08:42:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238852AbiKWNmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 08:42:01 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240AE7CBAC
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 05:30:15 -0800 (PST)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NHMRp3hRDz15Mly;
        Wed, 23 Nov 2022 21:29:42 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 21:30:13 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 23 Nov
 2022 21:30:12 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <afleming@freescale.com>, <jgarzik@pobox.com>
Subject: [PATCH net] net: phy: fix null-ptr-deref while probe() failed
Date:   Wed, 23 Nov 2022 21:28:08 +0800
Message-ID: <20221123132808.2090427-1-yangyingliang@huawei.com>
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

I got a null-ptr-deref report as following when doing fault injection test:

BUG: kernel NULL pointer dereference, address: 0000000000000058
Oops: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 1 PID: 253 Comm: 507-spi-dm9051 Tainted: G    B            N 6.1.0-rc3+
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:klist_put+0x2d/0xd0
Call Trace:
 <TASK>
 klist_remove+0xf1/0x1c0
 device_release_driver_internal+0x23e/0x2d0
 bus_remove_device+0x1bd/0x240
 device_del+0x357/0x770
 phy_device_remove+0x11/0x30
 mdiobus_unregister+0xa5/0x140
 release_nodes+0x6a/0xa0
 devres_release_all+0xf8/0x150
 device_unbind_cleanup+0x19/0xd0

//probe path:
phy_device_register()
  device_add()

phy_connect
  phy_attach_direct() //set device driver
    probe() //it's failed, driver is not bound
    device_bind_driver() // probe failed, it's not called

//remove path:
phy_device_remove()
  device_del()
    device_release_driver_internal()
      __device_release_driver() //dev->drv is not NULL
        klist_remove() <- knode_driver is not added yet, cause null-ptr-deref

In phy_attach_direct(), after setting the 'dev->driver', probe() fails,
device_bind_driver() is not called, so the knode_driver->n_klist is not
set, then it causes null-ptr-deref in __device_release_driver() while
deleting device. Fix this by setting dev->driver to NULL in the error
path in phy_attach_direct().

Fixes: e13934563db0 ("[PATCH] PHY Layer fixup")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/phy/phy_device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 57849ac0384e..a72adabfd2a7 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1520,6 +1520,7 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 
 error_module_put:
 	module_put(d->driver->owner);
+	d->driver = NULL;
 error_put_device:
 	put_device(d);
 	if (ndev_owner != bus->owner)
-- 
2.25.1

