Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 084AE5EDB81
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 13:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbiI1LOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 07:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233313AbiI1LOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 07:14:18 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8FEEB05
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 04:13:27 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MctzV0VVVz1P6rc;
        Wed, 28 Sep 2022 19:09:10 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 19:13:25 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>
Subject: [net-next] net: phy: Convert to use sysfs_emit() APIs
Date:   Wed, 28 Sep 2022 19:34:20 +0800
Message-ID: <1664364860-29153-1-git-send-email-wangyufen@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follow the advice of the Documentation/filesystems/sysfs.rst and show()
should only use sysfs_emit() or sysfs_emit_at() when formatting the value
to be returned to user space.

Signed-off-by: Wang Yufen <wangyufen@huawei.com>
---
 drivers/net/phy/mdio_bus.c   |  4 ++--
 drivers/net/phy/phy_device.c | 10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 8a2dbe8..f82090b 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -232,7 +232,7 @@ static ssize_t mdio_bus_stat_field_show(struct device *dev,
 		val = mdio_bus_get_stat(&bus->stats[sattr->addr],
 					sattr->field_offset);
 
-	return sprintf(buf, "%llu\n", val);
+	return sysfs_emit(buf, "%llu\n", val);
 }
 
 static ssize_t mdio_bus_device_stat_field_show(struct device *dev,
@@ -251,7 +251,7 @@ static ssize_t mdio_bus_device_stat_field_show(struct device *dev,
 
 	val = mdio_bus_get_stat(&bus->stats[addr], sattr->field_offset);
 
-	return sprintf(buf, "%llu\n", val);
+	return sysfs_emit(buf, "%llu\n", val);
 }
 
 #define MDIO_BUS_STATS_ATTR_DECL(field, file)				\
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 2198f13..7c9d871 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -520,7 +520,7 @@ static int phy_bus_match(struct device *dev, struct device_driver *drv)
 {
 	struct phy_device *phydev = to_phy_device(dev);
 
-	return sprintf(buf, "0x%.8lx\n", (unsigned long)phydev->phy_id);
+	return sysfs_emit(buf, "0x%.8lx\n", (unsigned long)phydev->phy_id);
 }
 static DEVICE_ATTR_RO(phy_id);
 
@@ -535,7 +535,7 @@ static int phy_bus_match(struct device *dev, struct device_driver *drv)
 	else
 		mode = phy_modes(phydev->interface);
 
-	return sprintf(buf, "%s\n", mode);
+	return sysfs_emit(buf, "%s\n", mode);
 }
 static DEVICE_ATTR_RO(phy_interface);
 
@@ -545,7 +545,7 @@ static int phy_bus_match(struct device *dev, struct device_driver *drv)
 {
 	struct phy_device *phydev = to_phy_device(dev);
 
-	return sprintf(buf, "%d\n", phydev->has_fixups);
+	return sysfs_emit(buf, "%d\n", phydev->has_fixups);
 }
 static DEVICE_ATTR_RO(phy_has_fixups);
 
@@ -555,7 +555,7 @@ static ssize_t phy_dev_flags_show(struct device *dev,
 {
 	struct phy_device *phydev = to_phy_device(dev);
 
-	return sprintf(buf, "0x%08x\n", phydev->dev_flags);
+	return sysfs_emit(buf, "0x%08x\n", phydev->dev_flags);
 }
 static DEVICE_ATTR_RO(phy_dev_flags);
 
@@ -1310,7 +1310,7 @@ static void phy_sysfs_create_links(struct phy_device *phydev)
 {
 	struct phy_device *phydev = to_phy_device(dev);
 
-	return sprintf(buf, "%d\n", !phydev->attached_dev);
+	return sysfs_emit(buf, "%d\n", !phydev->attached_dev);
 }
 static DEVICE_ATTR_RO(phy_standalone);
 
-- 
1.8.3.1

