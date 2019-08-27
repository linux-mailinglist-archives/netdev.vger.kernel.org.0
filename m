Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC559DBC5
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 04:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728764AbfH0CuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 22:50:22 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:37512 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727493AbfH0CuW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 22:50:22 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A51972D2616F5C16AE19;
        Tue, 27 Aug 2019 10:50:19 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.439.0; Tue, 27 Aug 2019 10:50:10 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <forest.zhouchang@huawei.com>,
        <linuxarm@huawei.com>
Subject: [RFC PATCH net-next] net: phy: force phy suspend when calling phy_stop
Date:   Tue, 27 Aug 2019 10:47:00 +0800
Message-ID: <1566874020-14334-1-git-send-email-shenjian15@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some ethernet drivers may call phy_start() and phy_stop() from
ndo_open and ndo_close() respectively.

When network cable is unconnected, and operate like below:
step 1: ifconfig ethX up -> ndo_open -> phy_start ->start
autoneg, and phy is no link.
step 2: ifconfig ethX down -> ndo_close -> phy_stop -> just stop
phy state machine.
step 3: plugin the network cable, and autoneg complete, then
LED for link status will be on.
step 4: ethtool ethX --> see the result of "Link detected" is no.

This patch forces phy suspend even phydev->link is off.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/phy/phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index f3adea9..0acd5b4 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -911,8 +911,8 @@ void phy_state_machine(struct work_struct *work)
 		if (phydev->link) {
 			phydev->link = 0;
 			phy_link_down(phydev, true);
-			do_suspend = true;
 		}
+		do_suspend = true;
 		break;
 	}
 
-- 
2.8.1

