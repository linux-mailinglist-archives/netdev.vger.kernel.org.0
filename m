Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D03A65A6172
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 13:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbiH3LNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 07:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiH3LNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 07:13:49 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E4DDD776;
        Tue, 30 Aug 2022 04:13:47 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MH4PN6k20znTV5;
        Tue, 30 Aug 2022 19:11:20 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 30 Aug 2022 19:13:46 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 30 Aug 2022 19:13:45 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <lanhao@huawei.com>
Subject: [PATCH net-next 3/4] net: hns3: add querying and setting fec llrs mode from firmware
Date:   Tue, 30 Aug 2022 19:11:16 +0800
Message-ID: <20220830111117.47865-4-huangguangbin2@huawei.com>
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

From: Hao Lan <lanhao@huawei.com>

This patch supports llrs fec mode in speed 200G for some new devices, and
suppoprts querying llrs fec ability from firmware.

Signed-off-by: Hao Lan <lanhao@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h       |  1 +
 .../hisilicon/hns3/hns3_common/hclge_comm_cmd.c   |  1 +
 .../hisilicon/hns3/hns3_common/hclge_comm_cmd.h   |  1 +
 .../net/ethernet/hisilicon/hns3/hns3_ethtool.c    |  4 ++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h    |  1 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 15 ++++++++++++++-
 6 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 91a28c22ad28..d7754b180f53 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -223,6 +223,7 @@ enum hnae3_fec_mode {
 	HNAE3_FEC_AUTO = 0,
 	HNAE3_FEC_BASER,
 	HNAE3_FEC_RS,
+	HNAE3_FEC_LLRS,
 	HNAE3_FEC_USER_DEF,
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
index 701d6373020c..f9bd3fc969c5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
@@ -91,6 +91,7 @@ int hclge_comm_firmware_compat_config(struct hnae3_ae_dev *ae_dev,
 			hnae3_set_bit(compat, HCLGE_COMM_PHY_IMP_EN_B, 1);
 		hnae3_set_bit(compat, HCLGE_COMM_MAC_STATS_EXT_EN_B, 1);
 		hnae3_set_bit(compat, HCLGE_COMM_SYNC_RX_RING_HEAD_EN_B, 1);
+		hnae3_set_bit(compat, HCLGE_COMM_LLRS_FEC_EN_B, 1);
 
 		req->compat = cpu_to_le32(compat);
 	}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
index dec0b9b422b4..8aaa5fdfa2f6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
@@ -20,6 +20,7 @@
 #define HCLGE_COMM_PHY_IMP_EN_B			2
 #define HCLGE_COMM_MAC_STATS_EXT_EN_B		3
 #define HCLGE_COMM_SYNC_RX_RING_HEAD_EN_B	4
+#define HCLGE_COMM_LLRS_FEC_EN_B		5
 
 #define hclge_comm_dev_phy_imp_supported(ae_dev) \
 	test_bit(HNAE3_DEV_SUPPORT_PHY_IMP_B, (ae_dev)->caps)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 4c7988e308a2..82a48ec20618 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1621,6 +1621,8 @@ static unsigned int loc_to_eth_fec(u8 loc_fec)
 		eth_fec |= ETHTOOL_FEC_AUTO;
 	if (loc_fec & BIT(HNAE3_FEC_RS))
 		eth_fec |= ETHTOOL_FEC_RS;
+	if (loc_fec & BIT(HNAE3_FEC_LLRS))
+		eth_fec |= ETHTOOL_FEC_LLRS;
 	if (loc_fec & BIT(HNAE3_FEC_BASER))
 		eth_fec |= ETHTOOL_FEC_BASER;
 
@@ -1643,6 +1645,8 @@ static unsigned int eth_to_loc_fec(unsigned int eth_fec)
 		loc_fec |= BIT(HNAE3_FEC_AUTO);
 	if (eth_fec & ETHTOOL_FEC_RS)
 		loc_fec |= BIT(HNAE3_FEC_RS);
+	if (eth_fec & ETHTOOL_FEC_LLRS)
+		loc_fec |= BIT(HNAE3_FEC_LLRS);
 	if (eth_fec & ETHTOOL_FEC_BASER)
 		loc_fec |= BIT(HNAE3_FEC_BASER);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 075f50071f66..489a87e9ecb4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -360,6 +360,7 @@ struct hclge_sfp_info_cmd {
 #define HCLGE_MAC_FEC_OFF		0
 #define HCLGE_MAC_FEC_BASER		1
 #define HCLGE_MAC_FEC_RS		2
+#define HCLGE_MAC_FEC_LLRS		3
 struct hclge_config_fec_cmd {
 	u8 fec_mode;
 	u8 default_config;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 039551a3e660..5cc19ff56121 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1007,6 +1007,7 @@ static void hclge_update_fec_support(struct hclge_mac *mac)
 {
 	linkmode_clear_bit(ETHTOOL_LINK_MODE_FEC_BASER_BIT, mac->supported);
 	linkmode_clear_bit(ETHTOOL_LINK_MODE_FEC_RS_BIT, mac->supported);
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_FEC_LLRS_BIT, mac->supported);
 
 	if (mac->fec_ability & BIT(HNAE3_FEC_BASER))
 		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_BASER_BIT,
@@ -1014,6 +1015,9 @@ static void hclge_update_fec_support(struct hclge_mac *mac)
 	if (mac->fec_ability & BIT(HNAE3_FEC_RS))
 		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_RS_BIT,
 				 mac->supported);
+	if (mac->fec_ability & BIT(HNAE3_FEC_LLRS))
+		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_LLRS_BIT,
+				 mac->supported);
 }
 
 static void hclge_convert_setting_sr(u16 speed_ability,
@@ -1131,9 +1135,12 @@ static void hclge_convert_setting_fec(struct hclge_mac *mac)
 			BIT(HNAE3_FEC_AUTO);
 		break;
 	case HCLGE_MAC_SPEED_100G:
-	case HCLGE_MAC_SPEED_200G:
 		mac->fec_ability = BIT(HNAE3_FEC_RS) | BIT(HNAE3_FEC_AUTO);
 		break;
+	case HCLGE_MAC_SPEED_200G:
+		mac->fec_ability = BIT(HNAE3_FEC_RS) | BIT(HNAE3_FEC_AUTO) |
+				   BIT(HNAE3_FEC_LLRS);
+		break;
 	default:
 		mac->fec_ability = 0;
 		break;
@@ -2756,6 +2763,9 @@ static int hclge_set_fec_hw(struct hclge_dev *hdev, u32 fec_mode)
 	if (fec_mode & BIT(HNAE3_FEC_RS))
 		hnae3_set_field(req->fec_mode, HCLGE_MAC_CFG_FEC_MODE_M,
 				HCLGE_MAC_CFG_FEC_MODE_S, HCLGE_MAC_FEC_RS);
+	if (fec_mode & BIT(HNAE3_FEC_LLRS))
+		hnae3_set_field(req->fec_mode, HCLGE_MAC_CFG_FEC_MODE_M,
+				HCLGE_MAC_CFG_FEC_MODE_S, HCLGE_MAC_FEC_LLRS);
 	if (fec_mode & BIT(HNAE3_FEC_BASER))
 		hnae3_set_field(req->fec_mode, HCLGE_MAC_CFG_FEC_MODE_M,
 				HCLGE_MAC_CFG_FEC_MODE_S, HCLGE_MAC_FEC_BASER);
@@ -3000,6 +3010,9 @@ static void hclge_update_fec_advertising(struct hclge_mac *mac)
 	if (mac->fec_mode & BIT(HNAE3_FEC_RS))
 		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_RS_BIT,
 				 mac->advertising);
+	else if (mac->fec_mode & BIT(HNAE3_FEC_LLRS))
+		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_LLRS_BIT,
+				 mac->advertising);
 	else if (mac->fec_mode & BIT(HNAE3_FEC_BASER))
 		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_BASER_BIT,
 				 mac->advertising);
-- 
2.33.0

