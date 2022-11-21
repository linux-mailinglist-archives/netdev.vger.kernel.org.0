Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD597631AF2
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 09:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiKUIGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 03:06:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiKUIGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 03:06:41 -0500
Received: from out28-75.mail.aliyun.com (out28-75.mail.aliyun.com [115.124.28.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3121409D;
        Mon, 21 Nov 2022 00:06:39 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07487702|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.00576339-0.106031-0.888205;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047188;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=14;RT=14;SR=0;TI=SMTPD_---.QCzvKBK_1669017959;
Received: from sunhua.motor-comm.com(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.QCzvKBK_1669017959)
          by smtp.aliyun-inc.com;
          Mon, 21 Nov 2022 16:06:37 +0800
From:   Frank <Frank.Sae@motor-comm.com>
To:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     yinghong.zhang@motor-comm.com, fei.zhang@motor-comm.com,
        hua.sun@motor-comm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Frank <Frank.Sae@motor-comm.com>
Subject: [PATCH net-next] net: phy: add Motorcomm YT8531S phy id.
Date:   Mon, 21 Nov 2022 16:06:38 +0800
Message-Id: <20221121080638.547-1-Frank.Sae@motor-comm.com>
X-Mailer: git-send-email 2.31.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We added patch for motorcomm.c to support YT8531S. This patch has
been tested on AM335x platform which has one YT8531S interface
card and passed all test cases.
The tested cases indluding: YT8531S UTP function with support of
10M/100M/1000M; YT8531S Fiber function with support of 100M/1000M;
and YT8531S Combo function that supports auto detection of media type.
 
Since most functions of YT8531S are similar to YT8521 and we reuse some
codes for YT8521 in the patch file.

Signed-off-by: Frank <Frank.Sae@motor-comm.com>
---
 drivers/net/phy/Kconfig     |  2 +-
 drivers/net/phy/motorcomm.c | 50 ++++++++++++++++++++++++++++++++++---
 2 files changed, 47 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 040c8bf6d05b..af00cf44cd97 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -260,7 +260,7 @@ config MOTORCOMM_PHY
 	tristate "Motorcomm PHYs"
 	help
 	  Enables support for Motorcomm network PHYs.
-	  Currently supports the YT8511, YT8521 Gigabit Ethernet PHYs.
+	  Currently supports the YT8511, YT8521, YT8531S Gigabit Ethernet PHYs.
 
 config NATIONAL_PHY
 	tristate "National Semiconductor PHYs"
diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
index bd1ab5d0631f..4c46c3edc0d9 100644
--- a/drivers/net/phy/motorcomm.c
+++ b/drivers/net/phy/motorcomm.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * Motorcomm 8511/8521 PHY driver.
+ * Motorcomm 8511/8521/8531S PHY driver.
  *
  * Author: Peter Geis <pgwipeout@gmail.com>
  * Author: Frank <Frank.Sae@motor-comm.com>
@@ -13,8 +13,9 @@
 
 #define PHY_ID_YT8511		0x0000010a
 #define PHY_ID_YT8521				0x0000011A
+#define PHY_ID_YT8531S				0x4F51E91A
 
-/* YT8521 Register Overview
+/* YT8521/YT8531S Register Overview
  *	UTP Register space	|	FIBER Register space
  *  ------------------------------------------------------------
  * |	UTP MII			|	FIBER MII		|
@@ -147,7 +148,7 @@
 #define YT8521_LINK_TIMER_CFG2_REG		0xA5
 #define YT8521_LTCR_EN_AUTOSEN			BIT(15)
 
-/* 0xA000, 0xA001, 0xA003 ,and 0xA006 ~ 0xA00A  are common ext registers
+/* 0xA000, 0xA001, 0xA003 , 0xA006 ~ 0xA00A and 0xA012 are common ext registers
  * of yt8521 phy. There is no need to switch reg space when operating these
  * registers.
  */
@@ -221,6 +222,9 @@
  */
 #define YTPHY_WCR_TYPE_PULSE			BIT(0)
 
+#define YT8531S_SYNCE_CFG_REG			0xA012
+#define YT8531S_SCR_SYNCE_ENABLE		BIT(6)
+
 /* Extended Register  end */
 
 struct yt8521_priv {
@@ -647,6 +651,26 @@ static int yt8521_probe(struct phy_device *phydev)
 	return 0;
 }
 
+/**
+ * yt8531s_probe() - read chip config then set suitable polling_mode
+ * @phydev: a pointer to a &struct phy_device
+ *
+ * returns 0 or negative errno code
+ */
+static int yt8531s_probe(struct phy_device *phydev)
+{
+	int ret;
+
+	/* Disable SyncE clock output by default */
+	ret = ytphy_modify_ext_with_lock(phydev, YT8531S_SYNCE_CFG_REG,
+					 YT8531S_SCR_SYNCE_ENABLE, 0);
+	if (ret < 0)
+		return ret;
+
+	/* same as yt8521_probe */
+	return yt8521_probe(phydev);
+}
+
 /**
  * ytphy_utp_read_lpa() - read LPA then setup lp_advertising for utp
  * @phydev: a pointer to a &struct phy_device
@@ -1750,11 +1774,28 @@ static struct phy_driver motorcomm_phy_drvs[] = {
 		.suspend	= yt8521_suspend,
 		.resume		= yt8521_resume,
 	},
+	{
+		PHY_ID_MATCH_EXACT(PHY_ID_YT8531S),
+		.name		= "YT8531S Gigabit Ethernet",
+		.get_features	= yt8521_get_features,
+		.probe		= yt8531s_probe,
+		.read_page	= yt8521_read_page,
+		.write_page	= yt8521_write_page,
+		.get_wol	= ytphy_get_wol,
+		.set_wol	= ytphy_set_wol,
+		.config_aneg	= yt8521_config_aneg,
+		.aneg_done	= yt8521_aneg_done,
+		.config_init	= yt8521_config_init,
+		.read_status	= yt8521_read_status,
+		.soft_reset	= yt8521_soft_reset,
+		.suspend	= yt8521_suspend,
+		.resume		= yt8521_resume,
+	},
 };
 
 module_phy_driver(motorcomm_phy_drvs);
 
-MODULE_DESCRIPTION("Motorcomm 8511/8521 PHY driver");
+MODULE_DESCRIPTION("Motorcomm 8511/8521/8531S PHY driver");
 MODULE_AUTHOR("Peter Geis");
 MODULE_AUTHOR("Frank");
 MODULE_LICENSE("GPL");
@@ -1762,6 +1803,7 @@ MODULE_LICENSE("GPL");
 static const struct mdio_device_id __maybe_unused motorcomm_tbl[] = {
 	{ PHY_ID_MATCH_EXACT(PHY_ID_YT8511) },
 	{ PHY_ID_MATCH_EXACT(PHY_ID_YT8521) },
+	{ PHY_ID_MATCH_EXACT(PHY_ID_YT8531S) },
 	{ /* sentinal */ }
 };
 
-- 
2.31.0.windows.1

