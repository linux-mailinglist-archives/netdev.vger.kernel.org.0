Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A9C5A6171
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 13:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbiH3LN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 07:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiH3LNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 07:13:49 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A06BEDDA95;
        Tue, 30 Aug 2022 04:13:48 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MH4N10V1lz1N7J3;
        Tue, 30 Aug 2022 19:10:09 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 30 Aug 2022 19:13:46 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 30 Aug 2022 19:13:46 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <lanhao@huawei.com>
Subject: [PATCH net-next 4/4] net: hns3: net: hns3: add querying and setting fec off mode from firmware
Date:   Tue, 30 Aug 2022 19:11:17 +0800
Message-ID: <20220830111117.47865-5-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220830111117.47865-1-huangguangbin2@huawei.com>
References: <20220830111117.47865-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For some new devices, the FEC mode can not be set to OFF in speed 200G.
In order to flexibly adapt to all types of devices, driver queries
fec ability from firmware to decide whether OFF mode can be supported.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h      |  1 +
 .../net/ethernet/hisilicon/hns3/hns3_ethtool.c   | 11 +++++------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c  | 16 ++++++++++------
 3 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index d7754b180f53..795df7111119 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -224,6 +224,7 @@ enum hnae3_fec_mode {
 	HNAE3_FEC_BASER,
 	HNAE3_FEC_RS,
 	HNAE3_FEC_LLRS,
+	HNAE3_FEC_NONE,
 	HNAE3_FEC_USER_DEF,
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 82a48ec20618..3ca9c2b67da4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1625,10 +1625,8 @@ static unsigned int loc_to_eth_fec(u8 loc_fec)
 		eth_fec |= ETHTOOL_FEC_LLRS;
 	if (loc_fec & BIT(HNAE3_FEC_BASER))
 		eth_fec |= ETHTOOL_FEC_BASER;
-
-	/* if nothing is set, then FEC is off */
-	if (!eth_fec)
-		eth_fec = ETHTOOL_FEC_OFF;
+	if (loc_fec & BIT(HNAE3_FEC_NONE))
+		eth_fec |= ETHTOOL_FEC_OFF;
 
 	return eth_fec;
 }
@@ -1639,8 +1637,7 @@ static unsigned int eth_to_loc_fec(unsigned int eth_fec)
 	u32 loc_fec = 0;
 
 	if (eth_fec & ETHTOOL_FEC_OFF)
-		return loc_fec;
-
+		loc_fec |= BIT(HNAE3_FEC_NONE);
 	if (eth_fec & ETHTOOL_FEC_AUTO)
 		loc_fec |= BIT(HNAE3_FEC_AUTO);
 	if (eth_fec & ETHTOOL_FEC_RS)
@@ -1672,6 +1669,8 @@ static int hns3_get_fecparam(struct net_device *netdev,
 
 	fec->fec = loc_to_eth_fec(fec_ability);
 	fec->active_fec = loc_to_eth_fec(fec_mode);
+	if (!fec->active_fec)
+		fec->active_fec = ETHTOOL_FEC_OFF;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 5cc19ff56121..fcdc978379ff 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1008,6 +1008,7 @@ static void hclge_update_fec_support(struct hclge_mac *mac)
 	linkmode_clear_bit(ETHTOOL_LINK_MODE_FEC_BASER_BIT, mac->supported);
 	linkmode_clear_bit(ETHTOOL_LINK_MODE_FEC_RS_BIT, mac->supported);
 	linkmode_clear_bit(ETHTOOL_LINK_MODE_FEC_LLRS_BIT, mac->supported);
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_FEC_NONE_BIT, mac->supported);
 
 	if (mac->fec_ability & BIT(HNAE3_FEC_BASER))
 		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_BASER_BIT,
@@ -1018,6 +1019,9 @@ static void hclge_update_fec_support(struct hclge_mac *mac)
 	if (mac->fec_ability & BIT(HNAE3_FEC_LLRS))
 		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_LLRS_BIT,
 				 mac->supported);
+	if (mac->fec_ability & BIT(HNAE3_FEC_NONE))
+		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_NONE_BIT,
+				 mac->supported);
 }
 
 static void hclge_convert_setting_sr(u16 speed_ability,
@@ -1125,17 +1129,17 @@ static void hclge_convert_setting_fec(struct hclge_mac *mac)
 	switch (mac->speed) {
 	case HCLGE_MAC_SPEED_10G:
 	case HCLGE_MAC_SPEED_40G:
-		mac->fec_ability =
-			BIT(HNAE3_FEC_BASER) | BIT(HNAE3_FEC_AUTO);
+		mac->fec_ability = BIT(HNAE3_FEC_BASER) | BIT(HNAE3_FEC_AUTO) |
+				   BIT(HNAE3_FEC_NONE);
 		break;
 	case HCLGE_MAC_SPEED_25G:
 	case HCLGE_MAC_SPEED_50G:
-		mac->fec_ability =
-			BIT(HNAE3_FEC_BASER) | BIT(HNAE3_FEC_RS) |
-			BIT(HNAE3_FEC_AUTO);
+		mac->fec_ability = BIT(HNAE3_FEC_BASER) | BIT(HNAE3_FEC_RS) |
+				   BIT(HNAE3_FEC_AUTO) | BIT(HNAE3_FEC_NONE);
 		break;
 	case HCLGE_MAC_SPEED_100G:
-		mac->fec_ability = BIT(HNAE3_FEC_RS) | BIT(HNAE3_FEC_AUTO);
+		mac->fec_ability = BIT(HNAE3_FEC_RS) | BIT(HNAE3_FEC_AUTO) |
+				   BIT(HNAE3_FEC_NONE);
 		break;
 	case HCLGE_MAC_SPEED_200G:
 		mac->fec_ability = BIT(HNAE3_FEC_RS) | BIT(HNAE3_FEC_AUTO) |
-- 
2.33.0

