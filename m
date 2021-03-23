Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E93345A06
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 09:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhCWIo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 04:44:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:51863 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229653AbhCWIoo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 04:44:44 -0400
IronPort-SDR: r+869jBPyZ4L8IHqiNDlj1Vsb8ZcJAWWjhntDic36Ys+EpEw5FJ2HJFFd9BCv6RId5Fp+n94OA
 ek55SaOYhaOQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="210510250"
X-IronPort-AV: E=Sophos;i="5.81,271,1610438400"; 
   d="scan'208";a="210510250"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 01:44:44 -0700
IronPort-SDR: eqyK8467aGdecvbAkOWHWRMYn4/xa918dXj1fQ1KjJFRCWTJGqvOqJb/aB5vjIQXI9XlMollgP
 t+FGBrY6I/Qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,271,1610438400"; 
   d="scan'208";a="442442595"
Received: from linux.intel.com ([10.54.29.200])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Mar 2021 01:44:41 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.59])
        by linux.intel.com (Postfix) with ESMTP id 9813A580718;
        Tue, 23 Mar 2021 01:44:39 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boong Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next 1/1] net: phy: marvell10g: Add PHY loopback support for 88E2110 PHY
Date:   Tue, 23 Mar 2021 16:48:53 +0800
Message-Id: <20210323084853.25432-1-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tan Tee Min <tee.min.tan@intel.com>

Add support for PHY loopback for the Marvell 88E2110 PHY.

This allow user to perform selftest using ethtool.

Signed-off-by: Tan Tee Min <tee.min.tan@intel.com>
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
 drivers/net/phy/marvell10g.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index b1bb9b8e1e4e..c45a8f11bdcf 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -89,6 +89,8 @@ enum {
 	MV_V2_TEMP_CTRL_DISABLE	= 0xc000,
 	MV_V2_TEMP		= 0xf08c,
 	MV_V2_TEMP_UNKNOWN	= 0x9600, /* unknown function */
+
+	MV_LOOPBACK		= BIT(14), /* Loopback (88E2110 only) */
 };
 
 struct mv3310_priv {
@@ -765,6 +767,15 @@ static int mv3310_set_tunable(struct phy_device *phydev,
 	}
 }
 
+static int mv3310_loopback(struct phy_device *phydev, bool enable)
+{
+	if (phydev->drv->phy_id != MARVELL_PHY_ID_88E2110)
+		return -EOPNOTSUPP;
+
+	return phy_modify_mmd(phydev, MDIO_MMD_PCS, MV_PCS_BASE_T,
+			      MV_LOOPBACK, enable ? MV_LOOPBACK : 0);
+}
+
 static struct phy_driver mv3310_drivers[] = {
 	{
 		.phy_id		= MARVELL_PHY_ID_88X3310,
@@ -796,6 +807,7 @@ static struct phy_driver mv3310_drivers[] = {
 		.get_tunable	= mv3310_get_tunable,
 		.set_tunable	= mv3310_set_tunable,
 		.remove		= mv3310_remove,
+		.set_loopback	= mv3310_loopback,
 	},
 };
 
-- 
2.25.1

