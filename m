Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26AC467F43E
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 04:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbjA1DNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 22:13:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232929AbjA1DNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 22:13:35 -0500
Received: from out29-52.mail.aliyun.com (out29-52.mail.aliyun.com [115.124.29.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BABEDBCA;
        Fri, 27 Jan 2023 19:13:33 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.09190102|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0209846-0.224968-0.754047;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047193;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=14;RT=14;SR=0;TI=SMTPD_---.R2VLvdM_1674875609;
Received: from sun-VirtualBox..(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.R2VLvdM_1674875609)
          by smtp.aliyun-inc.com;
          Sat, 28 Jan 2023 11:13:30 +0800
From:   Frank Sae <Frank.Sae@motor-comm.com>
To:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     xiaogang.fan@motor-comm.com, fei.zhang@motor-comm.com,
        hua.sun@motor-comm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Frank <Frank.Sae@motor-comm.com>
Subject: [PATCH net-next v2 4/5] net: phy: Add dts support for Motorcomm yt8531s gigabit ethernet phy
Date:   Sat, 28 Jan 2023 11:13:13 +0800
Message-Id: <20230128031314.19752-5-Frank.Sae@motor-comm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230128031314.19752-1-Frank.Sae@motor-comm.com>
References: <20230128031314.19752-1-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Add dts support for Motorcomm yt8531s gigabit ethernet phy.
 Change yt8521_probe to support clk config of yt8531s. Becase
 yt8521_probe does the things which yt8531s is needed, so
 removed yt8531s function.
 This patch has been verified on AM335x platform with yt8531s board.

Signed-off-by: Frank Sae <Frank.Sae@motor-comm.com>
---
 drivers/net/phy/motorcomm.c | 51 ++++++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 24 deletions(-)

diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
index b05109f31bd7..9559fc52814f 100644
--- a/drivers/net/phy/motorcomm.c
+++ b/drivers/net/phy/motorcomm.c
@@ -258,8 +258,6 @@
 #define YT8531_SCR_CLK_SRC_CLOCK_FROM_DIGITAL	3
 #define YT8531_SCR_CLK_SRC_REF_25M		4
 #define YT8531_SCR_CLK_SRC_SSC_25M		5
-#define YT8531S_SYNCE_CFG_REG			0xA012
-#define YT8531S_SCR_SYNCE_ENABLE		BIT(6)
 
 /* Extended Register  end */
 
@@ -860,7 +858,32 @@ static int yt8521_probe(struct phy_device *phydev)
 			return -EINVAL;
 		}
 	} else if (phydev->drv->phy_id == PHY_ID_YT8531S) {
-		return 0;
+		switch (freq) {
+		case YTPHY_DTS_OUTPUT_CLK_DIS:
+			mask = YT8531_SCR_SYNCE_ENABLE;
+			val = 0;
+			break;
+		case YTPHY_DTS_OUTPUT_CLK_25M:
+			mask = YT8531_SCR_SYNCE_ENABLE |
+			       YT8531_SCR_CLK_SRC_MASK |
+			       YT8531_SCR_CLK_FRE_SEL_125M;
+			val = YT8531_SCR_SYNCE_ENABLE |
+			      FIELD_PREP(YT8531_SCR_CLK_SRC_MASK,
+					 YT8531_SCR_CLK_SRC_REF_25M);
+			break;
+		case YTPHY_DTS_OUTPUT_CLK_125M:
+			mask = YT8531_SCR_SYNCE_ENABLE |
+			       YT8531_SCR_CLK_SRC_MASK |
+			       YT8531_SCR_CLK_FRE_SEL_125M;
+			val = YT8531_SCR_SYNCE_ENABLE |
+			      YT8531_SCR_CLK_FRE_SEL_125M |
+			      FIELD_PREP(YT8531_SCR_CLK_SRC_MASK,
+					 YT8531_SCR_CLK_SRC_PLL_125M);
+			break;
+		default:
+			phydev_warn(phydev, "Freq err:%u\n", freq);
+			return -EINVAL;
+		}
 	} else {
 		phydev_warn(phydev, "PHY id err\n");
 		return -EINVAL;
@@ -870,26 +893,6 @@ static int yt8521_probe(struct phy_device *phydev)
 					  val);
 }
 
-/**
- * yt8531s_probe() - read chip config then set suitable polling_mode
- * @phydev: a pointer to a &struct phy_device
- *
- * returns 0 or negative errno code
- */
-static int yt8531s_probe(struct phy_device *phydev)
-{
-	int ret;
-
-	/* Disable SyncE clock output by default */
-	ret = ytphy_modify_ext_with_lock(phydev, YT8531S_SYNCE_CFG_REG,
-					 YT8531S_SCR_SYNCE_ENABLE, 0);
-	if (ret < 0)
-		return ret;
-
-	/* same as yt8521_probe */
-	return yt8521_probe(phydev);
-}
-
 /**
  * ytphy_utp_read_lpa() - read LPA then setup lp_advertising for utp
  * @phydev: a pointer to a &struct phy_device
@@ -1972,7 +1975,7 @@ static struct phy_driver motorcomm_phy_drvs[] = {
 		PHY_ID_MATCH_EXACT(PHY_ID_YT8531S),
 		.name		= "YT8531S Gigabit Ethernet",
 		.get_features	= yt8521_get_features,
-		.probe		= yt8531s_probe,
+		.probe		= yt8521_probe,
 		.read_page	= yt8521_read_page,
 		.write_page	= yt8521_write_page,
 		.get_wol	= ytphy_get_wol,
-- 
2.34.1

