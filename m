Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5CC279F3D
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 09:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730564AbgI0HQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 03:16:21 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14242 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730310AbgI0HPo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Sep 2020 03:15:44 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 61ABA4FD80E013EC7EF5;
        Sun, 27 Sep 2020 15:15:41 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Sun, 27 Sep 2020 15:15:35 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 08/10] net: hns3: replace the macro of max tm rate with the queried specification
Date:   Sun, 27 Sep 2020 15:12:46 +0800
Message-ID: <1601190768-50075-9-git-send-email-tanhuazhong@huawei.com>
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

From: Guangbin Huang <huangguangbin2@huawei.com>

The max tm rate is a fixed value(100Gb/s) now as it is defined by a
macro. In order to support other rates in different kinds of device,
it is better to use specification queried from firmware to replace
this macro.

As function hclge_shaper_para_calc() has too many arguments to add
more, so encapsulate its three arguments ir_b, ir_u, ir_s into a
structure.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  3 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  2 ++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  | 34 ++++++++++++++--------
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h  |  2 ++
 5 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index cc48221..f6d0702 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -271,6 +271,7 @@ struct hnae3_ring_chain_node {
 struct hnae3_dev_specs {
 	u32 mac_entry_num; /* number of mac-vlan table entry */
 	u32 mng_entry_num; /* number of manager table entry */
+	u32 max_tm_rate;
 	u16 rss_ind_tbl_size;
 	u16 rss_key_size;
 	u16 int_ql_max; /* max value of interrupt coalesce based on INT_QL */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index d37066a..096e26a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -1099,7 +1099,8 @@ struct hclge_dev_specs_0_cmd {
 	__le16 rss_key_size;
 	__le16 int_ql_max;
 	u8 max_non_tso_bd_num;
-	u8 rsv1[5];
+	u8 rsv1;
+	__le32 max_tm_rate;
 };
 
 int hclge_cmd_init(struct hclge_dev *hdev);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 7825864..34b2932 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1365,6 +1365,7 @@ static void hclge_set_default_dev_specs(struct hclge_dev *hdev)
 	ae_dev->dev_specs.max_non_tso_bd_num = HCLGE_MAX_NON_TSO_BD_NUM;
 	ae_dev->dev_specs.rss_ind_tbl_size = HCLGE_RSS_IND_TBL_SIZE;
 	ae_dev->dev_specs.rss_key_size = HCLGE_RSS_KEY_SIZE;
+	ae_dev->dev_specs.max_tm_rate = HCLGE_ETHER_MAX_RATE;
 }
 
 static void hclge_parse_dev_specs(struct hclge_dev *hdev,
@@ -1379,6 +1380,7 @@ static void hclge_parse_dev_specs(struct hclge_dev *hdev,
 	ae_dev->dev_specs.rss_ind_tbl_size =
 		le16_to_cpu(req0->rss_ind_tbl_size);
 	ae_dev->dev_specs.rss_key_size = le16_to_cpu(req0->rss_key_size);
+	ae_dev->dev_specs.max_tm_rate = le32_to_cpu(req0->max_tm_rate);
 }
 
 static int hclge_query_dev_specs(struct hclge_dev *hdev)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 19742f9..eb98a72 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -23,14 +23,13 @@ enum hclge_shaper_level {
 #define HCLGE_SHAPER_BS_U_DEF	5
 #define HCLGE_SHAPER_BS_S_DEF	20
 
-#define HCLGE_ETHER_MAX_RATE	100000
-
 /* hclge_shaper_para_calc: calculate ir parameter for the shaper
  * @ir: Rate to be config, its unit is Mbps
  * @shaper_level: the shaper level. eg: port, pg, priority, queueset
  * @ir_b: IR_B parameter of IR shaper
  * @ir_u: IR_U parameter of IR shaper
  * @ir_s: IR_S parameter of IR shaper
+ * @max_tm_rate: max tm rate is available to config
  *
  * the formula:
  *
@@ -41,7 +40,8 @@ enum hclge_shaper_level {
  * @return: 0: calculate sucessful, negative: fail
  */
 static int hclge_shaper_para_calc(u32 ir, u8 shaper_level,
-				  u8 *ir_b, u8 *ir_u, u8 *ir_s)
+				  u8 *ir_b, u8 *ir_u, u8 *ir_s,
+				  u32 max_tm_rate)
 {
 #define DIVISOR_CLK		(1000 * 8)
 #define DIVISOR_IR_B_126	(126 * DIVISOR_CLK)
@@ -59,7 +59,7 @@ static int hclge_shaper_para_calc(u32 ir, u8 shaper_level,
 
 	/* Calc tick */
 	if (shaper_level >= HCLGE_SHAPER_LVL_CNT ||
-	    ir > HCLGE_ETHER_MAX_RATE)
+	    ir > max_tm_rate)
 		return -EINVAL;
 
 	tick = tick_array[shaper_level];
@@ -407,7 +407,8 @@ static int hclge_tm_port_shaper_cfg(struct hclge_dev *hdev)
 
 	ret = hclge_shaper_para_calc(hdev->hw.mac.speed,
 				     HCLGE_SHAPER_LVL_PORT,
-				     &ir_b, &ir_u, &ir_s);
+				     &ir_b, &ir_u, &ir_s,
+				     hdev->ae_dev->dev_specs.max_tm_rate);
 	if (ret)
 		return ret;
 
@@ -522,10 +523,11 @@ int hclge_tm_qs_shaper_cfg(struct hclge_vport *vport, int max_tx_rate)
 	int ret, i;
 
 	if (!max_tx_rate)
-		max_tx_rate = HCLGE_ETHER_MAX_RATE;
+		max_tx_rate = hdev->ae_dev->dev_specs.max_tm_rate;
 
 	ret = hclge_shaper_para_calc(max_tx_rate, HCLGE_SHAPER_LVL_QSET,
-				     &ir_b, &ir_u, &ir_s);
+				     &ir_b, &ir_u, &ir_s,
+				     hdev->ae_dev->dev_specs.max_tm_rate);
 	if (ret)
 		return ret;
 
@@ -668,7 +670,8 @@ static void hclge_tm_pg_info_init(struct hclge_dev *hdev)
 		hdev->tm_info.pg_info[i].pg_id = i;
 		hdev->tm_info.pg_info[i].pg_sch_mode = HCLGE_SCH_MODE_DWRR;
 
-		hdev->tm_info.pg_info[i].bw_limit = HCLGE_ETHER_MAX_RATE;
+		hdev->tm_info.pg_info[i].bw_limit =
+					hdev->ae_dev->dev_specs.max_tm_rate;
 
 		if (i != 0)
 			continue;
@@ -729,6 +732,7 @@ static int hclge_tm_pg_to_pri_map(struct hclge_dev *hdev)
 
 static int hclge_tm_pg_shaper_cfg(struct hclge_dev *hdev)
 {
+	u32 max_tm_rate = hdev->ae_dev->dev_specs.max_tm_rate;
 	u8 ir_u, ir_b, ir_s;
 	u32 shaper_para;
 	int ret;
@@ -744,7 +748,8 @@ static int hclge_tm_pg_shaper_cfg(struct hclge_dev *hdev)
 		ret = hclge_shaper_para_calc(
 					hdev->tm_info.pg_info[i].bw_limit,
 					HCLGE_SHAPER_LVL_PG,
-					&ir_b, &ir_u, &ir_s);
+					&ir_b, &ir_u, &ir_s,
+					max_tm_rate);
 		if (ret)
 			return ret;
 
@@ -861,6 +866,7 @@ static int hclge_tm_pri_q_qs_cfg(struct hclge_dev *hdev)
 
 static int hclge_tm_pri_tc_base_shaper_cfg(struct hclge_dev *hdev)
 {
+	u32 max_tm_rate = hdev->ae_dev->dev_specs.max_tm_rate;
 	u8 ir_u, ir_b, ir_s;
 	u32 shaper_para;
 	int ret;
@@ -870,7 +876,8 @@ static int hclge_tm_pri_tc_base_shaper_cfg(struct hclge_dev *hdev)
 		ret = hclge_shaper_para_calc(
 					hdev->tm_info.tc_info[i].bw_limit,
 					HCLGE_SHAPER_LVL_PRI,
-					&ir_b, &ir_u, &ir_s);
+					&ir_b, &ir_u, &ir_s,
+					max_tm_rate);
 		if (ret)
 			return ret;
 
@@ -902,7 +909,8 @@ static int hclge_tm_pri_vnet_base_shaper_pri_cfg(struct hclge_vport *vport)
 	int ret;
 
 	ret = hclge_shaper_para_calc(vport->bw_limit, HCLGE_SHAPER_LVL_VF,
-				     &ir_b, &ir_u, &ir_s);
+				     &ir_b, &ir_u, &ir_s,
+				     hdev->ae_dev->dev_specs.max_tm_rate);
 	if (ret)
 		return ret;
 
@@ -929,6 +937,7 @@ static int hclge_tm_pri_vnet_base_shaper_qs_cfg(struct hclge_vport *vport)
 {
 	struct hnae3_knic_private_info *kinfo = &vport->nic.kinfo;
 	struct hclge_dev *hdev = vport->back;
+	u32 max_tm_rate = hdev->ae_dev->dev_specs.max_tm_rate;
 	u8 ir_u, ir_b, ir_s;
 	u32 i;
 	int ret;
@@ -937,7 +946,8 @@ static int hclge_tm_pri_vnet_base_shaper_qs_cfg(struct hclge_vport *vport)
 		ret = hclge_shaper_para_calc(
 					hdev->tm_info.tc_info[i].bw_limit,
 					HCLGE_SHAPER_LVL_QSET,
-					&ir_b, &ir_u, &ir_s);
+					&ir_b, &ir_u, &ir_s,
+					max_tm_rate);
 		if (ret)
 			return ret;
 	}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
index 45bcb67..3c3bb3c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
@@ -19,6 +19,8 @@
 #define HCLGE_TM_TX_SCHD_DWRR_MSK	BIT(0)
 #define HCLGE_TM_TX_SCHD_SP_MSK		(0xFE)
 
+#define HCLGE_ETHER_MAX_RATE	100000
+
 struct hclge_pg_to_pri_link_cmd {
 	u8 pg_id;
 	u8 rsvd1[3];
-- 
2.7.4

