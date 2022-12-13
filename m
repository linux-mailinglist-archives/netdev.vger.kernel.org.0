Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B2E64B47B
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 12:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235307AbiLMLwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 06:52:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234707AbiLMLwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 06:52:03 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB94FAF2;
        Tue, 13 Dec 2022 03:52:01 -0800 (PST)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NWcJl1072z15NJj;
        Tue, 13 Dec 2022 19:51:03 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemi500012.china.huawei.com
 (7.221.188.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 13 Dec
 2022 19:51:59 +0800
From:   Li Zetao <lizetao1@huawei.com>
To:     <weiyongjun1@huawei.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <lizetao1@huawei.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: [PATCH net v2] r6040: Fix kmemleak in probe and remove
Date:   Tue, 13 Dec 2022 20:56:14 +0800
Message-ID: <20221213125614.927754-1-lizetao1@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <7f35ca55-cbed-98ac-4988-1b783db21dc5@huawei.com>
References: <7f35ca55-cbed-98ac-4988-1b783db21dc5@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a memory leaks reported by kmemleak:

  unreferenced object 0xffff888116111000 (size 2048):
    comm "modprobe", pid 817, jiffies 4294759745 (age 76.502s)
    hex dump (first 32 bytes):
      00 c4 0a 04 81 88 ff ff 08 10 11 16 81 88 ff ff  ................
      08 10 11 16 81 88 ff ff 00 00 00 00 00 00 00 00  ................
    backtrace:
      [<ffffffff815bcd82>] kmalloc_trace+0x22/0x60
      [<ffffffff827e20ee>] phy_device_create+0x4e/0x90
      [<ffffffff827e6072>] get_phy_device+0xd2/0x220
      [<ffffffff827e7844>] mdiobus_scan+0xa4/0x2e0
      [<ffffffff827e8be2>] __mdiobus_register+0x482/0x8b0
      [<ffffffffa01f5d24>] r6040_init_one+0x714/0xd2c [r6040]
      ...

The problem occurs in probe process as follows:
  r6040_init_one:
    mdiobus_register
      mdiobus_scan    <- alloc and register phy_device,
                         the reference count of phy_device is 3
    r6040_mii_probe
      phy_connect     <- connect to the first phy_device,
                         so the reference count of the first
                         phy_device is 4, others are 3
    register_netdev   <- fault inject succeeded, goto error handling path

    // error handling path
    err_out_mdio_unregister:
      mdiobus_unregister(lp->mii_bus);
    err_out_mdio:
      mdiobus_free(lp->mii_bus);    <- the reference count of the first
                                       phy_device is 1, it is not released
                                       and other phy_devices are released
  // similarly, the remove process also has the same problem

The root cause is traced to the phy_device is not disconnected when
removes one r6040 device in r6040_remove_one() or on error handling path
after r6040_mii probed successfully. In r6040_mii_probe(), a net ethernet
device is connected to the first PHY device of mii_bus, in order to
notify the connected driver when the link status changes, which is the
default behavior of the PHY infrastructure to handle everything.
Therefore the phy_device should be disconnected when removes one r6040
device or on error handling path.

Fix it by adding phy_disconnect() when removes one r6040 device or on
error handling path after r6040_mii probed successfully.

Fixes: 3831861b4ad8 ("r6040: implement phylib")
Signed-off-by: Li Zetao <lizetao1@huawei.com>
---
v1 -> v2: change the subject prefix "PATCH" to "PATCH net" and change
the goto label name "err_out_r6040_mii_remove" to "err_out_phy_disconnect"

 drivers/net/ethernet/rdc/r6040.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/rdc/r6040.c b/drivers/net/ethernet/rdc/r6040.c
index eecd52ed1ed2..f4d434c379e7 100644
--- a/drivers/net/ethernet/rdc/r6040.c
+++ b/drivers/net/ethernet/rdc/r6040.c
@@ -1159,10 +1159,12 @@ static int r6040_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	err = register_netdev(dev);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to register net device\n");
-		goto err_out_mdio_unregister;
+		goto err_out_phy_disconnect;
 	}
 	return 0;
 
+err_out_phy_disconnect:
+	phy_disconnect(dev->phydev);
 err_out_mdio_unregister:
 	mdiobus_unregister(lp->mii_bus);
 err_out_mdio:
@@ -1186,6 +1188,7 @@ static void r6040_remove_one(struct pci_dev *pdev)
 	struct r6040_private *lp = netdev_priv(dev);
 
 	unregister_netdev(dev);
+	phy_disconnect(dev->phydev);
 	mdiobus_unregister(lp->mii_bus);
 	mdiobus_free(lp->mii_bus);
 	netif_napi_del(&lp->napi);
-- 
2.31.1

