Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3058E84CBC
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 15:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388209AbfHGNT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 09:19:29 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4188 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387970AbfHGNT2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Aug 2019 09:19:28 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 16225B1D52EED8DA34B7;
        Wed,  7 Aug 2019 21:19:24 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Wed, 7 Aug 2019 21:19:14 +0800
From:   Yonglong Liu <liuyonglong@huawei.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <shiju.jose@huawei.com>
Subject: [PATCH net] net: phy: rtl8211f: do a double read to get real time link status
Date:   Wed, 7 Aug 2019 21:16:12 +0800
Message-ID: <1565183772-44268-1-git-send-email-liuyonglong@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[   27.232781] hns3 0000:bd:00.3 eth7: net open
[   27.237303] 8021q: adding VLAN 0 to HW filter on device eth7
[   27.242972] IPv6: ADDRCONF(NETDEV_CHANGE): eth7: link becomes ready
[   27.244449] hns3 0000:bd:00.3: invalid speed (-1)
[   27.253904] hns3 0000:bd:00.3 eth7: failed to adjust link.
[   27.259379] RTL8211F Gigabit Ethernet mii-0000:bd:00.3:07: PHY state change UP -> RUNNING
[   27.924903] hns3 0000:bd:00.3 eth7: link up
[   28.280479] RTL8211F Gigabit Ethernet mii-0000:bd:00.3:07: PHY state change RUNNING -> NOLINK
[   29.208452] hns3 0000:bd:00.3 eth7: link down
[   32.376745] RTL8211F Gigabit Ethernet mii-0000:bd:00.3:07: PHY state change NOLINK -> RUNNING
[   33.208448] hns3 0000:bd:00.3 eth7: link up
[   35.253821] hns3 0000:bd:00.3 eth7: net stop
[   35.258270] hns3 0000:bd:00.3 eth7: link down

When using rtl8211f in polling mode, may get a invalid speed,
because of reading a fake link up and autoneg complete status
immediately after starting autoneg:

        ifconfig-1176  [007] ....    27.232763: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x00 val:0x1040
  kworker/u257:1-670   [015] ....    27.232805: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x04 val:0x01e1
  kworker/u257:1-670   [015] ....    27.232815: mdio_access: mii-0000:bd:00.3 write phy:0x07 reg:0x04 val:0x05e1
  kworker/u257:1-670   [015] ....    27.232869: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x79ad
  kworker/u257:1-670   [015] ....    27.232904: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x09 val:0x0200
  kworker/u257:1-670   [015] ....    27.232940: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x00 val:0x1040
  kworker/u257:1-670   [015] ....    27.232949: mdio_access: mii-0000:bd:00.3 write phy:0x07 reg:0x00 val:0x1240
  kworker/u257:1-670   [015] ....    27.233003: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x79ad
  kworker/u257:1-670   [015] ....    27.233039: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x0a val:0x3002
  kworker/u257:1-670   [015] ....    27.233074: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x09 val:0x0200
  kworker/u257:1-670   [015] ....    27.233110: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x05 val:0x0000
  kworker/u257:1-670   [000] ....    28.280475: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x7989
  kworker/u257:1-670   [000] ....    29.304471: mdio_access: mii-0000:bd:00.3 read  phy:0x07 reg:0x01 val:0x7989

According to the datasheet of rtl8211f, to get the real time
link status, need to read MII_BMSR twice.

This patch add a read_status hook for rtl8211f, and do a fake
phy_read before genphy_read_status(), so that can get real link
status in genphy_read_status().

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
---
 drivers/net/phy/realtek.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index a669945..92e27d5 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -256,6 +256,18 @@ static int rtl8366rb_config_init(struct phy_device *phydev)
 	return ret;
 }
 
+static int rtl8211f_read_status(struct phy_device *phydev)
+{
+	int status;
+
+	/* do a fake read */
+	status = phy_read(phydev, MII_BMSR);
+	if (status < 0)
+		return status;
+
+	return genphy_read_status(phydev);
+}
+
 static struct phy_driver realtek_drvs[] = {
 	{
 		PHY_ID_MATCH_EXACT(0x00008201),
@@ -325,6 +337,7 @@ static struct phy_driver realtek_drvs[] = {
 		.resume		= genphy_resume,
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
+		.read_status	= rtl8211f_read_status,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc800),
 		.name		= "Generic Realtek PHY",
-- 
2.8.1

