Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61292367B72
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 09:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235186AbhDVHt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 03:49:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:8025 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230285AbhDVHty (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 03:49:54 -0400
IronPort-SDR: Pa91toOnpxRajShzMOiOSMvAs87/gN7aSRUJabAbiByFiuPq3lYdZQbqL66h3mUk8/KoDDS3q7
 OB4C4ewb4odA==
X-IronPort-AV: E=McAfee;i="6200,9189,9961"; a="195956137"
X-IronPort-AV: E=Sophos;i="5.82,241,1613462400"; 
   d="scan'208";a="195956137"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2021 00:49:19 -0700
IronPort-SDR: CtZAtxYrpalam1QJw4BNM4q/i6wfpcPi/+QQm6biF6EyaTTNjdkCQrc2K3CsPsbwUzsIjTRVRz
 uYF6Ej2hqzfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,242,1613462400"; 
   d="scan'208";a="427830736"
Received: from mismail5-ilbpg0.png.intel.com ([10.88.229.82])
  by orsmga008.jf.intel.com with ESMTP; 22 Apr 2021 00:49:07 -0700
From:   mohammad.athari.ismail@intel.com
To:     Jose Abreu <joabreu@synopsys.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>, vee.khee.wong@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mohammad.athari.ismail@intel.com
Subject: [PATCH net-next] net: pcs: Enable pre-emption packet for 10/100Mbps
Date:   Thu, 22 Apr 2021 15:48:51 +0800
Message-Id: <20210422074851.17375-1-mohammad.athari.ismail@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>

Set VR_MII_DIG_CTRL1 bit-6(PRE_EMP) to enable pre-emption packet for
10/100Mbps by default. This setting doesn`t impact pre-emption
capability for other speeds.

Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
---
 drivers/net/pcs/pcs-xpcs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 944ba105cac1..2dbc1d46821e 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -66,6 +66,7 @@
 
 /* VR_MII_DIG_CTRL1 */
 #define DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW		BIT(9)
+#define DW_VR_MII_DIG_CTRL1_PRE_EMP		BIT(6)
 
 /* VR_MII_AN_CTRL */
 #define DW_VR_MII_AN_CTRL_TX_CONFIG_SHIFT	3
@@ -666,6 +667,10 @@ static int xpcs_config_aneg_c37_sgmii(struct mdio_xpcs_args *xpcs)
 	 *	 PHY about the link state change after C28 AN is completed
 	 *	 between PHY and Link Partner. There is also no need to
 	 *	 trigger AN restart for MAC-side SGMII.
+	 *
+	 * For pre-emption, the setting is :-
+	 * 1) VR_MII_DIG_CTRL1 Bit(6) [PRE_EMP] = 1b (Enable pre-emption packet
+	 *    for 10/100Mbps)
 	 */
 	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_AN_CTRL);
 	if (ret < 0)
@@ -686,7 +691,7 @@ static int xpcs_config_aneg_c37_sgmii(struct mdio_xpcs_args *xpcs)
 	if (ret < 0)
 		return ret;
 
-	ret |= DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW;
+	ret |= (DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW | DW_VR_MII_DIG_CTRL1_PRE_EMP);
 
 	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
 }
-- 
2.17.1

