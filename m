Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74E7BD2675
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 11:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388133AbfJJJdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 05:33:41 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:52516 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387527AbfJJJdl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 05:33:41 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id CA7B4F59873951E77D02;
        Thu, 10 Oct 2019 17:33:37 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.439.0; Thu, 10 Oct 2019 17:33:30 +0800
From:   Yonglong Liu <liuyonglong@huawei.com>
To:     <davem@davemloft.net>, <hkallweit1@gmail.com>, <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <shiju.jose@huawei.com>
Subject: [RFC PATCH net] net: phy: Fix "link partner" information disappear issue
Date:   Thu, 10 Oct 2019 17:30:08 +0800
Message-ID: <1570699808-55313-1-git-send-email-liuyonglong@huawei.com>
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

This patch call genphy_read_lpa() before the link state judgement
to fix this problem.

Fixes: 88d6272acaaa ("net: phy: avoid unneeded MDIO reads in genphy_read_status")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
---
 drivers/net/phy/phy_device.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 9d2bbb1..ef3073c 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1839,6 +1839,10 @@ int genphy_read_status(struct phy_device *phydev)
 	if (err)
 		return err;
 
+	err = genphy_read_lpa(phydev);
+	if (err < 0)
+		return err;
+
 	/* why bother the PHY if nothing can have changed */
 	if (phydev->autoneg == AUTONEG_ENABLE && old_link && phydev->link)
 		return 0;
@@ -1848,10 +1852,6 @@ int genphy_read_status(struct phy_device *phydev)
 	phydev->pause = 0;
 	phydev->asym_pause = 0;
 
-	err = genphy_read_lpa(phydev);
-	if (err < 0)
-		return err;
-
 	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete) {
 		phy_resolve_aneg_linkmode(phydev);
 	} else if (phydev->autoneg == AUTONEG_DISABLE) {
-- 
2.8.1

