Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76E6A4417A0
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 10:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbhKAJiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 05:38:00 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:30890 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbhKAJfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 05:35:50 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HjSQ51QTCzcZyn;
        Mon,  1 Nov 2021 17:28:29 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 1 Nov 2021 17:33:11 +0800
Received: from compute.localdomain (10.175.112.70) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 1 Nov 2021 17:33:11 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: phy: fix duplex out of sync problem while changing settings
Date:   Mon, 1 Nov 2021 17:44:34 +0800
Message-ID: <1635759875-5927-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before commit 2bd229df5e2e ("net: phy: remove state PHY_FORCING") if
phy_ethtool_ksettings_set() is called with autoneg off, phy_start_aneg()
will set phydev->state to PHY_FORCING, so adjust_link will always be
called.

But after that commit, if phy_ethtool_ksettings_set() changes the local
link from 10Mbps/Half to 10Mbps/Full when the link partner is
10Mbps/Full, phy_check_link_status() will not trigger the link change,
because phydev->link and phydev->state has not changed. This will causes
the duplex of the PHY and MAC to be out of sync.

Fix it by re-adding the PHY_FORCING state to force adjust_link to be
called in fixed mode.

Fixes: 2bd229df5e2e ("net: phy: remove state PHY_FORCING")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/phy/phy.c | 10 ++++++++--
 include/linux/phy.h   |  6 ++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index a3bfb15..b114f15 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -49,6 +49,7 @@ static const char *phy_state_to_str(enum phy_state st)
 	PHY_STATE_STR(UP)
 	PHY_STATE_STR(RUNNING)
 	PHY_STATE_STR(NOLINK)
+	PHY_STATE_STR(FORCING)
 	PHY_STATE_STR(CABLETEST)
 	PHY_STATE_STR(HALTED)
 	}
@@ -724,8 +725,12 @@ static int _phy_start_aneg(struct phy_device *phydev)
 	if (err < 0)
 		return err;
 
-	if (phy_is_started(phydev))
-		err = phy_check_link_status(phydev);
+	if (phy_is_started(phydev)) {
+		if (phydev->autoneg == AUTONEG_ENABLE)
+			err = phy_check_link_status(phydev);
+		else
+			phydev->state = PHY_FORCING;
+	}
 
 	return err;
 }
@@ -1120,6 +1125,7 @@ void phy_state_machine(struct work_struct *work)
 		needs_aneg = true;
 
 		break;
+	case PHY_FORCING:
 	case PHY_NOLINK:
 	case PHY_RUNNING:
 		err = phy_check_link_status(phydev);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 736e1d1..e639729 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -446,6 +446,11 @@ struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr);
  * - irq or timer will set @PHY_NOLINK if link goes down
  * - phy_stop moves to @PHY_HALTED
  *
+ * @PHY_FORCING: PHY is being configured with forced settings.
+ * - if link is up, move to @PHY_RUNNING
+ * - if link is down, move to @PHY_NOLINK
+ * - phy_stop moves to @PHY_HALTED
+ *
  * @PHY_CABLETEST: PHY is performing a cable test. Packet reception/sending
  * is not expected to work, carrier will be indicated as down. PHY will be
  * poll once per second, or on interrupt for it current state.
@@ -463,6 +468,7 @@ enum phy_state {
 	PHY_UP,
 	PHY_RUNNING,
 	PHY_NOLINK,
+	PHY_FORCING,
 	PHY_CABLETEST,
 };
 
-- 
2.9.5

