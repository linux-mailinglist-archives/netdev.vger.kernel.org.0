Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F13F534658D
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 17:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233324AbhCWQmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 12:42:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:14550 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233117AbhCWQmd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 12:42:33 -0400
IronPort-SDR: yVVciRJlSFr3BpfE540ygosXLl5AIocNaJghT+KMHnXE/1psc0K1yRChIZ3mOCIdiMCW4Zbr9+
 g0Sket0f0mDw==
X-IronPort-AV: E=McAfee;i="6000,8403,9932"; a="187198388"
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="187198388"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 09:42:32 -0700
IronPort-SDR: 84xPRr46Uy/BvgfKwPID2GwAGiVxWv/NEowCLPizF12T/LzW9ngxTWO0z9oExR30c7T+MvyVJx
 h6NH+QauRZ+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="408403259"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga008.fm.intel.com with ESMTP; 23 Mar 2021 09:42:31 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.59])
        by linux.intel.com (Postfix) with ESMTP id 690D8580718;
        Tue, 23 Mar 2021 09:42:29 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next 1/2] net: phy: add genphy_c45_loopback
Date:   Wed, 24 Mar 2021 00:46:40 +0800
Message-Id: <20210323164641.26059-2-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210323164641.26059-1-vee.khee.wong@linux.intel.com>
References: <20210323164641.26059-1-vee.khee.wong@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add generic code to enable C45 PHY loopback into the common phy-c45.c
file. This will allow C45 PHY drivers aceess this by setting
.set_loopback.

Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
 drivers/net/phy/phy-c45.c | 8 ++++++++
 include/linux/phy.h       | 1 +
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index 077f2929c45e..91e3acb9e397 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -560,6 +560,14 @@ int gen10g_config_aneg(struct phy_device *phydev)
 }
 EXPORT_SYMBOL_GPL(gen10g_config_aneg);
 
+int genphy_c45_loopback(struct phy_device *phydev, bool enable)
+{
+	return phy_modify_mmd(phydev, MDIO_MMD_PCS, MDIO_CTRL1,
+			      MDIO_PCS_CTRL1_LOOPBACK,
+			      enable ? MDIO_PCS_CTRL1_LOOPBACK : 0);
+}
+EXPORT_SYMBOL_GPL(genphy_c45_loopback);
+
 struct phy_driver genphy_c45_driver = {
 	.phy_id         = 0xffffffff,
 	.phy_id_mask    = 0xffffffff,
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 1a12e4436b5b..8e2cf84b2318 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1532,6 +1532,7 @@ int genphy_c45_read_mdix(struct phy_device *phydev);
 int genphy_c45_pma_read_abilities(struct phy_device *phydev);
 int genphy_c45_read_status(struct phy_device *phydev);
 int genphy_c45_config_aneg(struct phy_device *phydev);
+int genphy_c45_loopback(struct phy_device *phydev, bool enable);
 
 /* Generic C45 PHY driver */
 extern struct phy_driver genphy_c45_driver;
-- 
2.25.1

