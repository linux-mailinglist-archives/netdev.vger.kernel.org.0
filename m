Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 674AD9F7EF
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 03:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbfH1BiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 21:38:10 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:40266 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726272AbfH1BiK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 21:38:10 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D21ACD0C64A2A664E798;
        Wed, 28 Aug 2019 09:38:07 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Wed, 28 Aug 2019 09:37:58 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <sergei.shtylyov@cogentembedded.com>
CC:     <netdev@vger.kernel.org>, <forest.zhouchang@huawei.com>,
        <linuxarm@huawei.com>
Subject: [PATCH net-next] net: phy: force phy suspend when calling phy_stop
Date:   Wed, 28 Aug 2019 09:34:47 +0800
Message-ID: <1566956087-37096-1-git-send-email-shenjian15@huawei.com>
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
ndo_open() and ndo_close() respectively.

When network cable is unconnected, and operate like below:
step 1: ifconfig ethX up -> ndo_open -> phy_start ->start
autoneg, and phy is no link.
step 2: ifconfig ethX down -> ndo_close -> phy_stop -> just stop
phy state machine.

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

