Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B37B279F2E
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 09:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730506AbgI0HPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 03:15:52 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:43710 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730476AbgI0HPu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Sep 2020 03:15:50 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 6C6B2241F836724C8BB6;
        Sun, 27 Sep 2020 15:15:46 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Sun, 27 Sep 2020 15:15:35 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 10/10] net: hns3: add a structure for IR shaper's parameter in hclge_shaper_para_calc()
Date:   Sun, 27 Sep 2020 15:12:48 +0800
Message-ID: <1601190768-50075-11-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1601190768-50075-1-git-send-email-tanhuazhong@huawei.com>
References: <1601190768-50075-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As function hclge_shaper_para_calc() has too many arguments to add
more, so encapsulate its three arguments ir_b, ir_u, ir_s into a
structure.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  | 87 +++++++++++-----------
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h  |  6 ++
 2 files changed, 49 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index eb98a72..15f69fa 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -26,9 +26,7 @@ enum hclge_shaper_level {
 /* hclge_shaper_para_calc: calculate ir parameter for the shaper
  * @ir: Rate to be config, its unit is Mbps
  * @shaper_level: the shaper level. eg: port, pg, priority, queueset
- * @ir_b: IR_B parameter of IR shaper
- * @ir_u: IR_U parameter of IR shaper
- * @ir_s: IR_S parameter of IR shaper
+ * @ir_para: parameters of IR shaper
  * @max_tm_rate: max tm rate is available to config
  *
  * the formula:
@@ -40,7 +38,7 @@ enum hclge_shaper_level {
  * @return: 0: calculate sucessful, negative: fail
  */
 static int hclge_shaper_para_calc(u32 ir, u8 shaper_level,
-				  u8 *ir_b, u8 *ir_u, u8 *ir_s,
+				  struct hclge_shaper_ir_para *ir_para,
 				  u32 max_tm_rate)
 {
 #define DIVISOR_CLK		(1000 * 8)
@@ -74,9 +72,9 @@ static int hclge_shaper_para_calc(u32 ir, u8 shaper_level,
 	ir_calc = (DIVISOR_IR_B_126 + (tick >> 1) - 1) / tick;
 
 	if (ir_calc == ir) {
-		*ir_b = 126;
-		*ir_u = 0;
-		*ir_s = 0;
+		ir_para->ir_b = 126;
+		ir_para->ir_u = 0;
+		ir_para->ir_s = 0;
 
 		return 0;
 	} else if (ir_calc > ir) {
@@ -86,8 +84,8 @@ static int hclge_shaper_para_calc(u32 ir, u8 shaper_level,
 			ir_calc = DIVISOR_IR_B_126 / (tick * (1 << ir_s_calc));
 		}
 
-		*ir_b = (ir * tick * (1 << ir_s_calc) + (DIVISOR_CLK >> 1)) /
-			DIVISOR_CLK;
+		ir_para->ir_b = (ir * tick * (1 << ir_s_calc) +
+				(DIVISOR_CLK >> 1)) / DIVISOR_CLK;
 	} else {
 		/* Increasing the numerator to select ir_u value */
 		u32 numerator;
@@ -99,15 +97,16 @@ static int hclge_shaper_para_calc(u32 ir, u8 shaper_level,
 		}
 
 		if (ir_calc == ir) {
-			*ir_b = 126;
+			ir_para->ir_b = 126;
 		} else {
 			u32 denominator = DIVISOR_CLK * (1 << --ir_u_calc);
-			*ir_b = (ir * tick + (denominator >> 1)) / denominator;
+			ir_para->ir_b = (ir * tick + (denominator >> 1)) /
+					denominator;
 		}
 	}
 
-	*ir_u = ir_u_calc;
-	*ir_s = ir_s_calc;
+	ir_para->ir_u = ir_u_calc;
+	ir_para->ir_s = ir_s_calc;
 
 	return 0;
 }
@@ -400,14 +399,13 @@ static int hclge_tm_pg_shapping_cfg(struct hclge_dev *hdev,
 static int hclge_tm_port_shaper_cfg(struct hclge_dev *hdev)
 {
 	struct hclge_port_shapping_cmd *shap_cfg_cmd;
+	struct hclge_shaper_ir_para ir_para;
 	struct hclge_desc desc;
-	u8 ir_u, ir_b, ir_s;
 	u32 shapping_para;
 	int ret;
 
-	ret = hclge_shaper_para_calc(hdev->hw.mac.speed,
-				     HCLGE_SHAPER_LVL_PORT,
-				     &ir_b, &ir_u, &ir_s,
+	ret = hclge_shaper_para_calc(hdev->hw.mac.speed, HCLGE_SHAPER_LVL_PORT,
+				     &ir_para,
 				     hdev->ae_dev->dev_specs.max_tm_rate);
 	if (ret)
 		return ret;
@@ -415,7 +413,8 @@ static int hclge_tm_port_shaper_cfg(struct hclge_dev *hdev)
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_TM_PORT_SHAPPING, false);
 	shap_cfg_cmd = (struct hclge_port_shapping_cmd *)desc.data;
 
-	shapping_para = hclge_tm_get_shapping_para(ir_b, ir_u, ir_s,
+	shapping_para = hclge_tm_get_shapping_para(ir_para.ir_b, ir_para.ir_u,
+						   ir_para.ir_s,
 						   HCLGE_SHAPER_BS_U_DEF,
 						   HCLGE_SHAPER_BS_S_DEF);
 
@@ -516,9 +515,9 @@ int hclge_tm_qs_shaper_cfg(struct hclge_vport *vport, int max_tx_rate)
 {
 	struct hnae3_knic_private_info *kinfo = &vport->nic.kinfo;
 	struct hclge_qs_shapping_cmd *shap_cfg_cmd;
+	struct hclge_shaper_ir_para ir_para;
 	struct hclge_dev *hdev = vport->back;
 	struct hclge_desc desc;
-	u8 ir_b, ir_u, ir_s;
 	u32 shaper_para;
 	int ret, i;
 
@@ -526,12 +525,13 @@ int hclge_tm_qs_shaper_cfg(struct hclge_vport *vport, int max_tx_rate)
 		max_tx_rate = hdev->ae_dev->dev_specs.max_tm_rate;
 
 	ret = hclge_shaper_para_calc(max_tx_rate, HCLGE_SHAPER_LVL_QSET,
-				     &ir_b, &ir_u, &ir_s,
+				     &ir_para,
 				     hdev->ae_dev->dev_specs.max_tm_rate);
 	if (ret)
 		return ret;
 
-	shaper_para = hclge_tm_get_shapping_para(ir_b, ir_u, ir_s,
+	shaper_para = hclge_tm_get_shapping_para(ir_para.ir_b, ir_para.ir_u,
+						 ir_para.ir_s,
 						 HCLGE_SHAPER_BS_U_DEF,
 						 HCLGE_SHAPER_BS_S_DEF);
 
@@ -733,7 +733,7 @@ static int hclge_tm_pg_to_pri_map(struct hclge_dev *hdev)
 static int hclge_tm_pg_shaper_cfg(struct hclge_dev *hdev)
 {
 	u32 max_tm_rate = hdev->ae_dev->dev_specs.max_tm_rate;
-	u8 ir_u, ir_b, ir_s;
+	struct hclge_shaper_ir_para ir_para;
 	u32 shaper_para;
 	int ret;
 	u32 i;
@@ -745,11 +745,9 @@ static int hclge_tm_pg_shaper_cfg(struct hclge_dev *hdev)
 	/* Pg to pri */
 	for (i = 0; i < hdev->tm_info.num_pg; i++) {
 		/* Calc shaper para */
-		ret = hclge_shaper_para_calc(
-					hdev->tm_info.pg_info[i].bw_limit,
-					HCLGE_SHAPER_LVL_PG,
-					&ir_b, &ir_u, &ir_s,
-					max_tm_rate);
+		ret = hclge_shaper_para_calc(hdev->tm_info.pg_info[i].bw_limit,
+					     HCLGE_SHAPER_LVL_PG,
+					     &ir_para, max_tm_rate);
 		if (ret)
 			return ret;
 
@@ -762,7 +760,9 @@ static int hclge_tm_pg_shaper_cfg(struct hclge_dev *hdev)
 		if (ret)
 			return ret;
 
-		shaper_para = hclge_tm_get_shapping_para(ir_b, ir_u, ir_s,
+		shaper_para = hclge_tm_get_shapping_para(ir_para.ir_b,
+							 ir_para.ir_u,
+							 ir_para.ir_s,
 							 HCLGE_SHAPER_BS_U_DEF,
 							 HCLGE_SHAPER_BS_S_DEF);
 		ret = hclge_tm_pg_shapping_cfg(hdev,
@@ -867,17 +867,15 @@ static int hclge_tm_pri_q_qs_cfg(struct hclge_dev *hdev)
 static int hclge_tm_pri_tc_base_shaper_cfg(struct hclge_dev *hdev)
 {
 	u32 max_tm_rate = hdev->ae_dev->dev_specs.max_tm_rate;
-	u8 ir_u, ir_b, ir_s;
+	struct hclge_shaper_ir_para ir_para;
 	u32 shaper_para;
 	int ret;
 	u32 i;
 
 	for (i = 0; i < hdev->tm_info.num_tc; i++) {
-		ret = hclge_shaper_para_calc(
-					hdev->tm_info.tc_info[i].bw_limit,
-					HCLGE_SHAPER_LVL_PRI,
-					&ir_b, &ir_u, &ir_s,
-					max_tm_rate);
+		ret = hclge_shaper_para_calc(hdev->tm_info.tc_info[i].bw_limit,
+					     HCLGE_SHAPER_LVL_PRI,
+					     &ir_para, max_tm_rate);
 		if (ret)
 			return ret;
 
@@ -889,7 +887,9 @@ static int hclge_tm_pri_tc_base_shaper_cfg(struct hclge_dev *hdev)
 		if (ret)
 			return ret;
 
-		shaper_para = hclge_tm_get_shapping_para(ir_b, ir_u, ir_s,
+		shaper_para = hclge_tm_get_shapping_para(ir_para.ir_b,
+							 ir_para.ir_u,
+							 ir_para.ir_s,
 							 HCLGE_SHAPER_BS_U_DEF,
 							 HCLGE_SHAPER_BS_S_DEF);
 		ret = hclge_tm_pri_shapping_cfg(hdev, HCLGE_TM_SHAP_P_BUCKET, i,
@@ -904,12 +904,12 @@ static int hclge_tm_pri_tc_base_shaper_cfg(struct hclge_dev *hdev)
 static int hclge_tm_pri_vnet_base_shaper_pri_cfg(struct hclge_vport *vport)
 {
 	struct hclge_dev *hdev = vport->back;
-	u8 ir_u, ir_b, ir_s;
+	struct hclge_shaper_ir_para ir_para;
 	u32 shaper_para;
 	int ret;
 
 	ret = hclge_shaper_para_calc(vport->bw_limit, HCLGE_SHAPER_LVL_VF,
-				     &ir_b, &ir_u, &ir_s,
+				     &ir_para,
 				     hdev->ae_dev->dev_specs.max_tm_rate);
 	if (ret)
 		return ret;
@@ -922,7 +922,8 @@ static int hclge_tm_pri_vnet_base_shaper_pri_cfg(struct hclge_vport *vport)
 	if (ret)
 		return ret;
 
-	shaper_para = hclge_tm_get_shapping_para(ir_b, ir_u, ir_s,
+	shaper_para = hclge_tm_get_shapping_para(ir_para.ir_b, ir_para.ir_u,
+						 ir_para.ir_s,
 						 HCLGE_SHAPER_BS_U_DEF,
 						 HCLGE_SHAPER_BS_S_DEF);
 	ret = hclge_tm_pri_shapping_cfg(hdev, HCLGE_TM_SHAP_P_BUCKET,
@@ -938,16 +939,14 @@ static int hclge_tm_pri_vnet_base_shaper_qs_cfg(struct hclge_vport *vport)
 	struct hnae3_knic_private_info *kinfo = &vport->nic.kinfo;
 	struct hclge_dev *hdev = vport->back;
 	u32 max_tm_rate = hdev->ae_dev->dev_specs.max_tm_rate;
-	u8 ir_u, ir_b, ir_s;
+	struct hclge_shaper_ir_para ir_para;
 	u32 i;
 	int ret;
 
 	for (i = 0; i < kinfo->num_tc; i++) {
-		ret = hclge_shaper_para_calc(
-					hdev->tm_info.tc_info[i].bw_limit,
-					HCLGE_SHAPER_LVL_QSET,
-					&ir_b, &ir_u, &ir_s,
-					max_tm_rate);
+		ret = hclge_shaper_para_calc(hdev->tm_info.tc_info[i].bw_limit,
+					     HCLGE_SHAPER_LVL_QSET,
+					     &ir_para, max_tm_rate);
 		if (ret)
 			return ret;
 	}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
index 3c3bb3c..bb2a2d8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
@@ -141,6 +141,12 @@ struct hclge_port_shapping_cmd {
 	__le32 port_shapping_para;
 };
 
+struct hclge_shaper_ir_para {
+	u8 ir_b; /* IR_B parameter of IR shaper */
+	u8 ir_u; /* IR_U parameter of IR shaper */
+	u8 ir_s; /* IR_S parameter of IR shaper */
+};
+
 #define hclge_tm_set_field(dest, string, val) \
 			   hnae3_set_field((dest), \
 			   (HCLGE_TM_SHAP_##string##_MSK), \
-- 
2.7.4

