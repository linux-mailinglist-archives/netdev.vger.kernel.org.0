Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4FD5A0B6D
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 10:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237468AbiHYI0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 04:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239795AbiHYI0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 04:26:06 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622132CE23;
        Thu, 25 Aug 2022 01:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661415948; x=1692951948;
  h=from:to:cc:subject:date:message-id;
  bh=Eja8cuJ2l8fSG1VgeeQkVCOALrFwx8H66sQ/4ba8AZY=;
  b=aeUZbd1o6I/3/SkwechHMMhoo16uyhvXm4MGCc6sW2l8vnAr5L69VQOA
   tE9NwqWCEXjShKv2p+WujxvRG1/WMVV2oY1PeEQgMgeRyqwwwLrgVOH6T
   Xzthp0S32Utun+NOrNS/6XdhgmgNJf7YzQ8lJ33VOh1k69l6MdL2HyvGu
   QJDGEMypVgSBZTn7IzyofSqkg569vTOJo4a5+eCvxBMK+e78liHEQaybX
   5I9ZjfqygO4dw/NxCdVby4V3Imynk888K16vbRUU8dgwmsFQIrzyD8xqs
   DvXwwvYxmAT2sNOFXJuoU/8RctjtnannumZTXVNI+B1CBGYHswIqAosrB
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="320257168"
X-IronPort-AV: E=Sophos;i="5.93,262,1654585200"; 
   d="scan'208";a="320257168"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 01:25:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,262,1654585200"; 
   d="scan'208";a="752399532"
Received: from aminuddin-ilbpg12.png.intel.com ([10.88.229.89])
  by fmsmga001.fm.intel.com with ESMTP; 25 Aug 2022 01:25:45 -0700
From:   Aminuddin Jamaluddin <aminuddin.jamaluddin@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, tee.min.tan@intel.com,
        muhammad.husaini.zulkifli@intel.com, aminuddin.jamaluddin@intel.com
Subject: [PATCH net 1/1] net: phy: marvell: add link status check before enabling phy loopback
Date:   Thu, 25 Aug 2022 16:22:37 +0800
Message-Id: <20220825082238.11056-1-aminuddin.jamaluddin@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add link status checking in m88e1510_loopback() for 1Gbps link speed
and delay for 100ms after phy loopback bit is set before send packet.
This is needed to ensure the stability and consistency when running
the phy loopback test.

Fixes: 020a45aff119 ("net: phy: marvell: add Marvell specific PHY loopback")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Signed-off-by: Aminuddin Jamaluddin <aminuddin.jamaluddin@intel.com>
---
 drivers/net/phy/marvell.c | 22 ++++++++++++++++------
 include/linux/phy.h       |  3 +++
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index a714150f5e8c..17403acf780d 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1992,6 +1992,7 @@ static int m88e1510_loopback(struct phy_device *phydev, bool enable)
 
 	if (enable) {
 		u16 bmcr_ctl, mscr2_ctl = 0;
+		int val = 0;
 
 		bmcr_ctl = mii_bmcr_encode_fixed(phydev->speed, phydev->duplex);
 
@@ -2015,14 +2016,23 @@ static int m88e1510_loopback(struct phy_device *phydev, bool enable)
 		if (err < 0)
 			return err;
 
-		/* FIXME: Based on trial and error test, it seem 1G need to have
-		 * delay between soft reset and loopback enablement.
-		 */
-		if (phydev->speed == SPEED_1000)
-			msleep(1000);
+		if (phydev->speed == SPEED_1000) {
+			err = phy_read_poll_timeout(phydev, MII_BMSR, val, val & BMSR_LSTATUS,
+						    PHY_LOOP_BACK_SLEEP,
+						    PHY_LOOP_BACK_TIMEOUT, true);
+			if (err)
+				return err;
+		}
 
-		return phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK,
+		err =  phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK,
 				  BMCR_LOOPBACK);
+		if (!err) {
+			/* It takes some time for PHY device to switch
+			 * into/out-of loopback mode.
+			 */
+			msleep(100);
+		}
+		return err;
 	} else {
 		err = phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK, 0);
 		if (err < 0)
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 87638c55d844..b4da968da8e6 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -276,6 +276,9 @@ static inline const char *phy_modes(phy_interface_t interface)
 #define PHY_INIT_TIMEOUT	100000
 #define PHY_FORCE_TIMEOUT	10
 
+#define PHY_LOOP_BACK_SLEEP	1000000
+#define PHY_LOOP_BACK_TIMEOUT	8000000
+
 #define PHY_MAX_ADDR	32
 
 /* Used when trying to connect to a specific phy (mii bus id:phy device id) */
-- 
2.17.1

