Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37C3546177D
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343834AbhK2OKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:10:30 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:28187 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234760AbhK2OI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 09:08:26 -0500
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4J2nB64m0hz8vjl;
        Mon, 29 Nov 2021 22:03:10 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 22:05:07 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 22:05:06 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 05/10] net: hns3: refine function hclge_cfg_mac_speed_dup_hw()
Date:   Mon, 29 Nov 2021 22:00:22 +0800
Message-ID: <20211129140027.23036-6-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211129140027.23036-1-huangguangbin2@huawei.com>
References: <20211129140027.23036-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To reuse the code of converting speed of driver to speed of firmware in
function hclge_cfg_mac_speed_dup_hw(), encapsulate them into a new
function hclge_convert_to_fw_speed().

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 71 +++++++++----------
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  5 ++
 2 files changed, 37 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 5282f2632b3b..7de4c56ef014 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2653,11 +2653,38 @@ static u8 hclge_check_speed_dup(u8 duplex, int speed)
 	return duplex;
 }
 
+struct hclge_mac_speed_map hclge_mac_speed_map_to_fw[] = {
+	{HCLGE_MAC_SPEED_10M, HCLGE_FW_MAC_SPEED_10M},
+	{HCLGE_MAC_SPEED_100M, HCLGE_FW_MAC_SPEED_100M},
+	{HCLGE_MAC_SPEED_1G, HCLGE_FW_MAC_SPEED_1G},
+	{HCLGE_MAC_SPEED_10G, HCLGE_FW_MAC_SPEED_10G},
+	{HCLGE_MAC_SPEED_25G, HCLGE_FW_MAC_SPEED_25G},
+	{HCLGE_MAC_SPEED_40G, HCLGE_FW_MAC_SPEED_40G},
+	{HCLGE_MAC_SPEED_50G, HCLGE_FW_MAC_SPEED_50G},
+	{HCLGE_MAC_SPEED_100G, HCLGE_FW_MAC_SPEED_100G},
+	{HCLGE_MAC_SPEED_200G, HCLGE_FW_MAC_SPEED_200G},
+};
+
+static int hclge_convert_to_fw_speed(u32 speed_drv, u32 *speed_fw)
+{
+	u16 i;
+
+	for (i = 0; i < ARRAY_SIZE(hclge_mac_speed_map_to_fw); i++) {
+		if (hclge_mac_speed_map_to_fw[i].speed_drv == speed_drv) {
+			*speed_fw = hclge_mac_speed_map_to_fw[i].speed_fw;
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+
 static int hclge_cfg_mac_speed_dup_hw(struct hclge_dev *hdev, int speed,
 				      u8 duplex)
 {
 	struct hclge_config_mac_speed_dup_cmd *req;
 	struct hclge_desc desc;
+	u32 speed_fw;
 	int ret;
 
 	req = (struct hclge_config_mac_speed_dup_cmd *)desc.data;
@@ -2667,48 +2694,14 @@ static int hclge_cfg_mac_speed_dup_hw(struct hclge_dev *hdev, int speed,
 	if (duplex)
 		hnae3_set_bit(req->speed_dup, HCLGE_CFG_DUPLEX_B, 1);
 
-	switch (speed) {
-	case HCLGE_MAC_SPEED_10M:
-		hnae3_set_field(req->speed_dup, HCLGE_CFG_SPEED_M,
-				HCLGE_CFG_SPEED_S, HCLGE_FW_MAC_SPEED_10M);
-		break;
-	case HCLGE_MAC_SPEED_100M:
-		hnae3_set_field(req->speed_dup, HCLGE_CFG_SPEED_M,
-				HCLGE_CFG_SPEED_S, HCLGE_FW_MAC_SPEED_100M);
-		break;
-	case HCLGE_MAC_SPEED_1G:
-		hnae3_set_field(req->speed_dup, HCLGE_CFG_SPEED_M,
-				HCLGE_CFG_SPEED_S, HCLGE_FW_MAC_SPEED_1G);
-		break;
-	case HCLGE_MAC_SPEED_10G:
-		hnae3_set_field(req->speed_dup, HCLGE_CFG_SPEED_M,
-				HCLGE_CFG_SPEED_S, HCLGE_FW_MAC_SPEED_10G);
-		break;
-	case HCLGE_MAC_SPEED_25G:
-		hnae3_set_field(req->speed_dup, HCLGE_CFG_SPEED_M,
-				HCLGE_CFG_SPEED_S, HCLGE_FW_MAC_SPEED_25G);
-		break;
-	case HCLGE_MAC_SPEED_40G:
-		hnae3_set_field(req->speed_dup, HCLGE_CFG_SPEED_M,
-				HCLGE_CFG_SPEED_S, HCLGE_FW_MAC_SPEED_40G);
-		break;
-	case HCLGE_MAC_SPEED_50G:
-		hnae3_set_field(req->speed_dup, HCLGE_CFG_SPEED_M,
-				HCLGE_CFG_SPEED_S, HCLGE_FW_MAC_SPEED_50G);
-		break;
-	case HCLGE_MAC_SPEED_100G:
-		hnae3_set_field(req->speed_dup, HCLGE_CFG_SPEED_M,
-				HCLGE_CFG_SPEED_S, HCLGE_FW_MAC_SPEED_100G);
-		break;
-	case HCLGE_MAC_SPEED_200G:
-		hnae3_set_field(req->speed_dup, HCLGE_CFG_SPEED_M,
-				HCLGE_CFG_SPEED_S, HCLGE_FW_MAC_SPEED_200G);
-		break;
-	default:
+	ret = hclge_convert_to_fw_speed(speed, &speed_fw);
+	if (ret) {
 		dev_err(&hdev->pdev->dev, "invalid speed (%d)\n", speed);
-		return -EINVAL;
+		return ret;
 	}
 
+	hnae3_set_field(req->speed_dup, HCLGE_CFG_SPEED_M, HCLGE_CFG_SPEED_S,
+			speed_fw);
 	hnae3_set_bit(req->mac_change_fec_en, HCLGE_CFG_MAC_SPEED_CHANGE_EN_B,
 		      1);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 42ce1eee33c4..a51418fdbb24 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -1095,6 +1095,11 @@ struct hclge_speed_bit_map {
 	u32 speed_bit;
 };
 
+struct hclge_mac_speed_map {
+	u32 speed_drv; /* speed defined in driver */
+	u32 speed_fw; /* speed defined in firmware */
+};
+
 int hclge_set_vport_promisc_mode(struct hclge_vport *vport, bool en_uc_pmc,
 				 bool en_mc_pmc, bool en_bc_pmc);
 int hclge_add_uc_addr_common(struct hclge_vport *vport,
-- 
2.33.0

