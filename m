Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78C04D6335
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 15:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731861AbfJNNAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 09:00:12 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:53618 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730126AbfJNNAL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 09:00:11 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 40342F1A9E89E082ED4E;
        Mon, 14 Oct 2019 21:00:08 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.439.0; Mon, 14 Oct 2019 21:00:02 +0800
From:   Yonglong Liu <liuyonglong@huawei.com>
To:     <davem@davemloft.net>, <hkallweit1@gmail.com>, <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <shiju.jose@huawei.com>
Subject: [RFC PATCH V2 net] net: phy: Fix "link partner" information disappear issue
Date:   Mon, 14 Oct 2019 20:56:37 +0800
Message-ID: <1571057797-37602-1-git-send-email-liuyonglong@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some drivers just call phy_ethtool_ksettings_set() to set the
links, for those phy drivers that use genphy_read_status(), if
autoneg is on, and the link is up, than execute "ethtool -s
ethx autoneg on" will cause "link partner" information disappear.

The call trace is phy_ethtool_ksettings_set()->phy_start_aneg()
->linkmode_zero(phydev->lp_advertising)->genphy_read_status(),
the link didn't change, so genphy_read_status() just return, and
phydev->lp_advertising is zero now.

This patch moves the clear operation of lp_advertising from
phy_start_aneg() to genphy_read_lpa()/genphy_c45_read_lpa(), and
if autoneg on and autoneg not complete, just clear what the
generic functions care about.

Fixes: 88d6272acaaa ("net: phy: avoid unneeded MDIO reads in genphy_read_status")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>

---
change log:
V2: moves the clear operation of lp_advertising from
phy_start_aneg() to genphy_read_lpa()/genphy_c45_read_lpa(), and
if autoneg on and autoneg not complete, just clear what the
generic functions care about. Suggested by Heiner Kallweit.
---
---
 drivers/net/phy/phy-c45.c    |  2 ++
 drivers/net/phy/phy.c        |  3 ---
 drivers/net/phy/phy_device.c | 12 +++++++++++-
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index 7935593..a1caeee 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -323,6 +323,8 @@ int genphy_c45_read_pma(struct phy_device *phydev)
 {
 	int val;
 
+	linkmode_zero(phydev->lp_advertising);
+
 	val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_CTRL1);
 	if (val < 0)
 		return val;
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 119e6f4..105d389b 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -572,9 +572,6 @@ int phy_start_aneg(struct phy_device *phydev)
 	if (AUTONEG_DISABLE == phydev->autoneg)
 		phy_sanitize_settings(phydev);
 
-	/* Invalidate LP advertising flags */
-	linkmode_zero(phydev->lp_advertising);
-
 	err = phy_config_aneg(phydev);
 	if (err < 0)
 		goto out_unlock;
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 9d2bbb1..4b43466 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1787,7 +1787,14 @@ int genphy_read_lpa(struct phy_device *phydev)
 {
 	int lpa, lpagb;
 
-	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete) {
+	if (phydev->autoneg == AUTONEG_ENABLE) {
+		if (!phydev->autoneg_complete) {
+			mii_stat1000_mod_linkmode_lpa_t(phydev->lp_advertising,
+							0);
+			mii_lpa_mod_linkmode_lpa_t(phydev->lp_advertising, 0);
+			return 0;
+		}
+
 		if (phydev->is_gigabit_capable) {
 			lpagb = phy_read(phydev, MII_STAT1000);
 			if (lpagb < 0)
@@ -1816,6 +1823,9 @@ int genphy_read_lpa(struct phy_device *phydev)
 
 		mii_lpa_mod_linkmode_lpa_t(phydev->lp_advertising, lpa);
 	}
+	else {
+		linkmode_zero(phydev->lp_advertising);
+	}
 
 	return 0;
 }
-- 
2.8.1

