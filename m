Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7722BA5C4
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 10:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbgKTJQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 04:16:44 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8564 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727222AbgKTJQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 04:16:23 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CcrWK1LLzzLqnr;
        Fri, 20 Nov 2020 17:15:57 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Fri, 20 Nov 2020 17:16:12 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 4/5] net: hns3: add support to utilize the firmware calculated shaping parameters
Date:   Fri, 20 Nov 2020 17:16:22 +0800
Message-ID: <1605863783-36995-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1605863783-36995-1-git-send-email-tanhuazhong@huawei.com>
References: <1605863783-36995-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

Since the calculation of the driver is fixed, if the number of
queue or clock changed, the calculated result may be inaccurate.

So for compatible and maintainable, add a new flag to tell the
firmware to calculate the shaping parameters with the specified
rate.

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  | 43 ++++++++++++++++------
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h  | 15 ++++++++
 2 files changed, 46 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index b50b079..54767b0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -395,7 +395,7 @@ static u32 hclge_tm_get_shapping_para(u8 ir_b, u8 ir_u, u8 ir_s,
 
 static int hclge_tm_pg_shapping_cfg(struct hclge_dev *hdev,
 				    enum hclge_shap_bucket bucket, u8 pg_id,
-				    u32 shapping_para)
+				    u32 shapping_para, u32 rate)
 {
 	struct hclge_pg_shapping_cmd *shap_cfg_cmd;
 	enum hclge_opcode_type opcode;
@@ -411,6 +411,10 @@ static int hclge_tm_pg_shapping_cfg(struct hclge_dev *hdev,
 
 	shap_cfg_cmd->pg_shapping_para = cpu_to_le32(shapping_para);
 
+	hnae3_set_bit(shap_cfg_cmd->flag, HCLGE_TM_RATE_VLD, 1);
+
+	shap_cfg_cmd->pg_rate = cpu_to_le32(rate);
+
 	return hclge_cmd_send(&hdev->hw, &desc, 1);
 }
 
@@ -438,12 +442,16 @@ static int hclge_tm_port_shaper_cfg(struct hclge_dev *hdev)
 
 	shap_cfg_cmd->port_shapping_para = cpu_to_le32(shapping_para);
 
+	hnae3_set_bit(shap_cfg_cmd->flag, HCLGE_TM_RATE_VLD, 1);
+
+	shap_cfg_cmd->port_rate = cpu_to_le32(hdev->hw.mac.speed);
+
 	return hclge_cmd_send(&hdev->hw, &desc, 1);
 }
 
 static int hclge_tm_pri_shapping_cfg(struct hclge_dev *hdev,
 				     enum hclge_shap_bucket bucket, u8 pri_id,
-				     u32 shapping_para)
+				     u32 shapping_para, u32 rate)
 {
 	struct hclge_pri_shapping_cmd *shap_cfg_cmd;
 	enum hclge_opcode_type opcode;
@@ -460,6 +468,10 @@ static int hclge_tm_pri_shapping_cfg(struct hclge_dev *hdev,
 
 	shap_cfg_cmd->pri_shapping_para = cpu_to_le32(shapping_para);
 
+	hnae3_set_bit(shap_cfg_cmd->flag, HCLGE_TM_RATE_VLD, 1);
+
+	shap_cfg_cmd->pri_rate = cpu_to_le32(rate);
+
 	return hclge_cmd_send(&hdev->hw, &desc, 1);
 }
 
@@ -561,6 +573,9 @@ int hclge_tm_qs_shaper_cfg(struct hclge_vport *vport, int max_tx_rate)
 		shap_cfg_cmd->qs_id = cpu_to_le16(vport->qs_offset + i);
 		shap_cfg_cmd->qs_shapping_para = cpu_to_le32(shaper_para);
 
+		hnae3_set_bit(shap_cfg_cmd->flag, HCLGE_TM_RATE_VLD, 1);
+		shap_cfg_cmd->qs_rate = cpu_to_le32(max_tx_rate);
+
 		ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 		if (ret) {
 			dev_err(&hdev->pdev->dev,
@@ -762,9 +777,10 @@ static int hclge_tm_pg_shaper_cfg(struct hclge_dev *hdev)
 
 	/* Pg to pri */
 	for (i = 0; i < hdev->tm_info.num_pg; i++) {
+		u32 rate = hdev->tm_info.pg_info[i].bw_limit;
+
 		/* Calc shaper para */
-		ret = hclge_shaper_para_calc(hdev->tm_info.pg_info[i].bw_limit,
-					     HCLGE_SHAPER_LVL_PG,
+		ret = hclge_shaper_para_calc(rate, HCLGE_SHAPER_LVL_PG,
 					     &ir_para, max_tm_rate);
 		if (ret)
 			return ret;
@@ -774,7 +790,7 @@ static int hclge_tm_pg_shaper_cfg(struct hclge_dev *hdev)
 							 HCLGE_SHAPER_BS_S_DEF);
 		ret = hclge_tm_pg_shapping_cfg(hdev,
 					       HCLGE_TM_SHAP_C_BUCKET, i,
-					       shaper_para);
+					       shaper_para, rate);
 		if (ret)
 			return ret;
 
@@ -785,7 +801,7 @@ static int hclge_tm_pg_shaper_cfg(struct hclge_dev *hdev)
 							 HCLGE_SHAPER_BS_S_DEF);
 		ret = hclge_tm_pg_shapping_cfg(hdev,
 					       HCLGE_TM_SHAP_P_BUCKET, i,
-					       shaper_para);
+					       shaper_para, rate);
 		if (ret)
 			return ret;
 	}
@@ -891,8 +907,9 @@ static int hclge_tm_pri_tc_base_shaper_cfg(struct hclge_dev *hdev)
 	u32 i;
 
 	for (i = 0; i < hdev->tm_info.num_tc; i++) {
-		ret = hclge_shaper_para_calc(hdev->tm_info.tc_info[i].bw_limit,
-					     HCLGE_SHAPER_LVL_PRI,
+		u32 rate = hdev->tm_info.tc_info[i].bw_limit;
+
+		ret = hclge_shaper_para_calc(rate, HCLGE_SHAPER_LVL_PRI,
 					     &ir_para, max_tm_rate);
 		if (ret)
 			return ret;
@@ -901,7 +918,7 @@ static int hclge_tm_pri_tc_base_shaper_cfg(struct hclge_dev *hdev)
 							 HCLGE_SHAPER_BS_U_DEF,
 							 HCLGE_SHAPER_BS_S_DEF);
 		ret = hclge_tm_pri_shapping_cfg(hdev, HCLGE_TM_SHAP_C_BUCKET, i,
-						shaper_para);
+						shaper_para, rate);
 		if (ret)
 			return ret;
 
@@ -911,7 +928,7 @@ static int hclge_tm_pri_tc_base_shaper_cfg(struct hclge_dev *hdev)
 							 HCLGE_SHAPER_BS_U_DEF,
 							 HCLGE_SHAPER_BS_S_DEF);
 		ret = hclge_tm_pri_shapping_cfg(hdev, HCLGE_TM_SHAP_P_BUCKET, i,
-						shaper_para);
+						shaper_para, rate);
 		if (ret)
 			return ret;
 	}
@@ -936,7 +953,8 @@ static int hclge_tm_pri_vnet_base_shaper_pri_cfg(struct hclge_vport *vport)
 						 HCLGE_SHAPER_BS_U_DEF,
 						 HCLGE_SHAPER_BS_S_DEF);
 	ret = hclge_tm_pri_shapping_cfg(hdev, HCLGE_TM_SHAP_C_BUCKET,
-					vport->vport_id, shaper_para);
+					vport->vport_id, shaper_para,
+					vport->bw_limit);
 	if (ret)
 		return ret;
 
@@ -945,7 +963,8 @@ static int hclge_tm_pri_vnet_base_shaper_pri_cfg(struct hclge_vport *vport)
 						 HCLGE_SHAPER_BS_U_DEF,
 						 HCLGE_SHAPER_BS_S_DEF);
 	ret = hclge_tm_pri_shapping_cfg(hdev, HCLGE_TM_SHAP_P_BUCKET,
-					vport->vport_id, shaper_para);
+					vport->vport_id, shaper_para,
+					vport->bw_limit);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
index 42c2270..5498d73 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
@@ -92,22 +92,34 @@ enum hclge_shap_bucket {
 	HCLGE_TM_SHAP_P_BUCKET,
 };
 
+/* set bit HCLGE_TM_RATE_VLD to 1 means use 'rate' to config shaping */
+#define HCLGE_TM_RATE_VLD	0
+
 struct hclge_pri_shapping_cmd {
 	u8 pri_id;
 	u8 rsvd[3];
 	__le32 pri_shapping_para;
+	u8 flag;
+	u8 rsvd1[3];
+	__le32 pri_rate;
 };
 
 struct hclge_pg_shapping_cmd {
 	u8 pg_id;
 	u8 rsvd[3];
 	__le32 pg_shapping_para;
+	u8 flag;
+	u8 rsvd1[3];
+	__le32 pg_rate;
 };
 
 struct hclge_qs_shapping_cmd {
 	__le16 qs_id;
 	u8 rsvd[2];
 	__le32 qs_shapping_para;
+	u8 flag;
+	u8 rsvd1[3];
+	__le32 qs_rate;
 };
 
 #define HCLGE_BP_GRP_NUM		32
@@ -150,6 +162,9 @@ struct hclge_pfc_stats_cmd {
 
 struct hclge_port_shapping_cmd {
 	__le32 port_shapping_para;
+	u8 flag;
+	u8 rsvd[3];
+	__le32 port_rate;
 };
 
 struct hclge_shaper_ir_para {
-- 
2.7.4

