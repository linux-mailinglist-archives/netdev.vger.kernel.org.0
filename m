Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E307E5A6168
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 13:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiH3LNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 07:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiH3LNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 07:13:49 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6046DABB2;
        Tue, 30 Aug 2022 04:13:47 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MH4NH0w0BzlWY1;
        Tue, 30 Aug 2022 19:10:23 +0800 (CST)
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
Subject: [PATCH net-next 2/4] net: hns3: add querying fec ability from firmware
Date:   Tue, 30 Aug 2022 19:11:15 +0800
Message-ID: <20220830111117.47865-3-huangguangbin2@huawei.com>
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

For some new devices, driver can queries fec ability from firmware to
decide which FEC mode can be supported.

If devices of old version which not support querying fec ability, driver
sets fixed ability according to current speed.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_cmd.h         |  3 +-
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 32 ++++++++++++++-----
 2 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index f9d89511eb32..075f50071f66 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -347,7 +347,8 @@ struct hclge_sfp_info_cmd {
 	u8 autoneg_ability; /* whether support autoneg */
 	__le32 speed_ability; /* speed ability for current media */
 	__le32 module_type;
-	u8 rsv[8];
+	u8 fec_ability;
+	u8 rsv[7];
 };
 
 #define HCLGE_MAC_CFG_FEC_AUTO_EN_B	0
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 92da11d510b0..039551a3e660 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1003,6 +1003,19 @@ static int hclge_check_port_speed(struct hnae3_handle *handle, u32 speed)
 	return -EINVAL;
 }
 
+static void hclge_update_fec_support(struct hclge_mac *mac)
+{
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_FEC_BASER_BIT, mac->supported);
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_FEC_RS_BIT, mac->supported);
+
+	if (mac->fec_ability & BIT(HNAE3_FEC_BASER))
+		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_BASER_BIT,
+				 mac->supported);
+	if (mac->fec_ability & BIT(HNAE3_FEC_RS))
+		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_RS_BIT,
+				 mac->supported);
+}
+
 static void hclge_convert_setting_sr(u16 speed_ability,
 				     unsigned long *link_mode)
 {
@@ -1101,34 +1114,33 @@ static void hclge_convert_setting_kr(u16 speed_ability,
 
 static void hclge_convert_setting_fec(struct hclge_mac *mac)
 {
-	linkmode_clear_bit(ETHTOOL_LINK_MODE_FEC_BASER_BIT, mac->supported);
-	linkmode_clear_bit(ETHTOOL_LINK_MODE_FEC_RS_BIT, mac->supported);
+	/* If firmware has reported fec_ability, don't need to convert by speed */
+	if (mac->fec_ability)
+		goto out;
 
 	switch (mac->speed) {
 	case HCLGE_MAC_SPEED_10G:
 	case HCLGE_MAC_SPEED_40G:
-		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_BASER_BIT,
-				 mac->supported);
 		mac->fec_ability =
 			BIT(HNAE3_FEC_BASER) | BIT(HNAE3_FEC_AUTO);
 		break;
 	case HCLGE_MAC_SPEED_25G:
 	case HCLGE_MAC_SPEED_50G:
-		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_RS_BIT,
-				 mac->supported);
 		mac->fec_ability =
 			BIT(HNAE3_FEC_BASER) | BIT(HNAE3_FEC_RS) |
 			BIT(HNAE3_FEC_AUTO);
 		break;
 	case HCLGE_MAC_SPEED_100G:
 	case HCLGE_MAC_SPEED_200G:
-		linkmode_set_bit(ETHTOOL_LINK_MODE_FEC_RS_BIT, mac->supported);
 		mac->fec_ability = BIT(HNAE3_FEC_RS) | BIT(HNAE3_FEC_AUTO);
 		break;
 	default:
 		mac->fec_ability = 0;
 		break;
 	}
+
+out:
+	hclge_update_fec_support(mac);
 }
 
 static void hclge_parse_fiber_link_mode(struct hclge_dev *hdev,
@@ -3037,7 +3049,6 @@ static void hclge_update_port_capability(struct hclge_dev *hdev,
 					 struct hclge_mac *mac)
 {
 	if (hnae3_dev_fec_supported(hdev))
-		/* update fec ability by speed */
 		hclge_convert_setting_fec(mac);
 
 	/* firmware can not identify back plane type, the media type
@@ -3123,6 +3134,7 @@ static int hclge_get_sfp_info(struct hclge_dev *hdev, struct hclge_mac *mac)
 			mac->fec_mode = 0;
 		else
 			mac->fec_mode = BIT(resp->active_fec);
+		mac->fec_ability = resp->fec_ability;
 	} else {
 		mac->speed_type = QUERY_SFP_SPEED;
 	}
@@ -11452,6 +11464,10 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	if (ret)
 		goto err_mdiobus_unreg;
 
+	ret = hclge_update_port_info(hdev);
+	if (ret)
+		goto err_mdiobus_unreg;
+
 	INIT_KFIFO(hdev->mac_tnl_log);
 
 	hclge_dcb_ops_set(hdev);
-- 
2.33.0

