Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6F9154748D
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 14:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbiFKMbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 08:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232662AbiFKMbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 08:31:48 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87524641B;
        Sat, 11 Jun 2022 05:31:46 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4LKxyg19mMzDqpc;
        Sat, 11 Jun 2022 20:31:23 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 11 Jun 2022 20:31:44 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 11 Jun 2022 20:31:44 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 4/6] net: hns3: restore tm priority/qset to default settings when tc disabled
Date:   Sat, 11 Jun 2022 20:25:27 +0800
Message-ID: <20220611122529.18571-5-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220611122529.18571-1-huangguangbin2@huawei.com>
References: <20220611122529.18571-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
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

Currently, settings parameters of schedule mode, dwrr, shaper of tm
priority or qset of one tc are only be set when tc is enabled, they are
not restored to the default settings when tc is disabled. It confuses
users when they cat tm_priority or tm_qset files of debugfs. So this
patch fixes it.

Fixes: 848440544b41 ("net: hns3: Add support of TX Scheduler & Shaper to HNS3 driver")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  1 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 95 +++++++++++++------
 2 files changed, 65 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 8a3a446219f7..94f80e1c4020 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -769,6 +769,7 @@ struct hnae3_tc_info {
 	u8 prio_tc[HNAE3_MAX_USER_PRIO]; /* TC indexed by prio */
 	u16 tqp_count[HNAE3_MAX_TC];
 	u16 tqp_offset[HNAE3_MAX_TC];
+	u8 max_tc; /* Total number of TCs */
 	u8 num_tc; /* Total number of enabled TCs */
 	bool mqprio_active;
 };
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 1f87a8a3fe32..ad53a3447322 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -282,8 +282,8 @@ static int hclge_tm_pg_to_pri_map_cfg(struct hclge_dev *hdev,
 	return hclge_cmd_send(&hdev->hw, &desc, 1);
 }
 
-static int hclge_tm_qs_to_pri_map_cfg(struct hclge_dev *hdev,
-				      u16 qs_id, u8 pri)
+static int hclge_tm_qs_to_pri_map_cfg(struct hclge_dev *hdev, u16 qs_id, u8 pri,
+				      bool link_vld)
 {
 	struct hclge_qs_to_pri_link_cmd *map;
 	struct hclge_desc desc;
@@ -294,7 +294,7 @@ static int hclge_tm_qs_to_pri_map_cfg(struct hclge_dev *hdev,
 
 	map->qs_id = cpu_to_le16(qs_id);
 	map->priority = pri;
-	map->link_vld = HCLGE_TM_QS_PRI_LINK_VLD_MSK;
+	map->link_vld = link_vld ? HCLGE_TM_QS_PRI_LINK_VLD_MSK : 0;
 
 	return hclge_cmd_send(&hdev->hw, &desc, 1);
 }
@@ -642,11 +642,13 @@ static void hclge_tm_update_kinfo_rss_size(struct hclge_vport *vport)
 	 * one tc for VF for simplicity. VF's vport_id is non zero.
 	 */
 	if (vport->vport_id) {
+		kinfo->tc_info.max_tc = 1;
 		kinfo->tc_info.num_tc = 1;
 		vport->qs_offset = HNAE3_MAX_TC +
 				   vport->vport_id - HCLGE_VF_VPORT_START_NUM;
 		vport_max_rss_size = hdev->vf_rss_size_max;
 	} else {
+		kinfo->tc_info.max_tc = hdev->tc_max;
 		kinfo->tc_info.num_tc =
 			min_t(u16, vport->alloc_tqps, hdev->tm_info.num_tc);
 		vport->qs_offset = 0;
@@ -714,14 +716,22 @@ static void hclge_tm_vport_info_update(struct hclge_dev *hdev)
 
 static void hclge_tm_tc_info_init(struct hclge_dev *hdev)
 {
-	u8 i;
+	u8 i, tc_sch_mode;
+	u32 bw_limit;
+
+	for (i = 0; i < hdev->tc_max; i++) {
+		if (i < hdev->tm_info.num_tc) {
+			tc_sch_mode = HCLGE_SCH_MODE_DWRR;
+			bw_limit = hdev->tm_info.pg_info[0].bw_limit;
+		} else {
+			tc_sch_mode = HCLGE_SCH_MODE_SP;
+			bw_limit = 0;
+		}
 
-	for (i = 0; i < hdev->tm_info.num_tc; i++) {
 		hdev->tm_info.tc_info[i].tc_id = i;
-		hdev->tm_info.tc_info[i].tc_sch_mode = HCLGE_SCH_MODE_DWRR;
+		hdev->tm_info.tc_info[i].tc_sch_mode = tc_sch_mode;
 		hdev->tm_info.tc_info[i].pgid = 0;
-		hdev->tm_info.tc_info[i].bw_limit =
-			hdev->tm_info.pg_info[0].bw_limit;
+		hdev->tm_info.tc_info[i].bw_limit = bw_limit;
 	}
 
 	for (i = 0; i < HNAE3_MAX_USER_PRIO; i++)
@@ -926,10 +936,13 @@ static int hclge_tm_pri_q_qs_cfg_tc_base(struct hclge_dev *hdev)
 	for (k = 0; k < hdev->num_alloc_vport; k++) {
 		struct hnae3_knic_private_info *kinfo = &vport[k].nic.kinfo;
 
-		for (i = 0; i < kinfo->tc_info.num_tc; i++) {
+		for (i = 0; i < kinfo->tc_info.max_tc; i++) {
+			u8 pri = i < kinfo->tc_info.num_tc ? i : 0;
+			bool link_vld = i < kinfo->tc_info.num_tc;
+
 			ret = hclge_tm_qs_to_pri_map_cfg(hdev,
 							 vport[k].qs_offset + i,
-							 i);
+							 pri, link_vld);
 			if (ret)
 				return ret;
 		}
@@ -949,7 +962,7 @@ static int hclge_tm_pri_q_qs_cfg_vnet_base(struct hclge_dev *hdev)
 		for (i = 0; i < HNAE3_MAX_TC; i++) {
 			ret = hclge_tm_qs_to_pri_map_cfg(hdev,
 							 vport[k].qs_offset + i,
-							 k);
+							 k, true);
 			if (ret)
 				return ret;
 		}
@@ -989,33 +1002,39 @@ static int hclge_tm_pri_tc_base_shaper_cfg(struct hclge_dev *hdev)
 {
 	u32 max_tm_rate = hdev->ae_dev->dev_specs.max_tm_rate;
 	struct hclge_shaper_ir_para ir_para;
-	u32 shaper_para;
+	u32 shaper_para_c, shaper_para_p;
 	int ret;
 	u32 i;
 
-	for (i = 0; i < hdev->tm_info.num_tc; i++) {
+	for (i = 0; i < hdev->tc_max; i++) {
 		u32 rate = hdev->tm_info.tc_info[i].bw_limit;
 
-		ret = hclge_shaper_para_calc(rate, HCLGE_SHAPER_LVL_PRI,
-					     &ir_para, max_tm_rate);
-		if (ret)
-			return ret;
+		if (rate) {
+			ret = hclge_shaper_para_calc(rate, HCLGE_SHAPER_LVL_PRI,
+						     &ir_para, max_tm_rate);
+			if (ret)
+				return ret;
+
+			shaper_para_c = hclge_tm_get_shapping_para(0, 0, 0,
+								   HCLGE_SHAPER_BS_U_DEF,
+								   HCLGE_SHAPER_BS_S_DEF);
+			shaper_para_p = hclge_tm_get_shapping_para(ir_para.ir_b,
+								   ir_para.ir_u,
+								   ir_para.ir_s,
+								   HCLGE_SHAPER_BS_U_DEF,
+								   HCLGE_SHAPER_BS_S_DEF);
+		} else {
+			shaper_para_c = 0;
+			shaper_para_p = 0;
+		}
 
-		shaper_para = hclge_tm_get_shapping_para(0, 0, 0,
-							 HCLGE_SHAPER_BS_U_DEF,
-							 HCLGE_SHAPER_BS_S_DEF);
 		ret = hclge_tm_pri_shapping_cfg(hdev, HCLGE_TM_SHAP_C_BUCKET, i,
-						shaper_para, rate);
+						shaper_para_c, rate);
 		if (ret)
 			return ret;
 
-		shaper_para = hclge_tm_get_shapping_para(ir_para.ir_b,
-							 ir_para.ir_u,
-							 ir_para.ir_s,
-							 HCLGE_SHAPER_BS_U_DEF,
-							 HCLGE_SHAPER_BS_S_DEF);
 		ret = hclge_tm_pri_shapping_cfg(hdev, HCLGE_TM_SHAP_P_BUCKET, i,
-						shaper_para, rate);
+						shaper_para_p, rate);
 		if (ret)
 			return ret;
 	}
@@ -1125,7 +1144,7 @@ static int hclge_tm_pri_tc_base_dwrr_cfg(struct hclge_dev *hdev)
 	int ret;
 	u32 i, k;
 
-	for (i = 0; i < hdev->tm_info.num_tc; i++) {
+	for (i = 0; i < hdev->tc_max; i++) {
 		pg_info =
 			&hdev->tm_info.pg_info[hdev->tm_info.tc_info[i].pgid];
 		dwrr = pg_info->tc_dwrr[i];
@@ -1135,9 +1154,15 @@ static int hclge_tm_pri_tc_base_dwrr_cfg(struct hclge_dev *hdev)
 			return ret;
 
 		for (k = 0; k < hdev->num_alloc_vport; k++) {
+			struct hnae3_knic_private_info *kinfo = &vport[k].nic.kinfo;
+
+			if (i >= kinfo->tc_info.max_tc)
+				continue;
+
+			dwrr = i < kinfo->tc_info.num_tc ? vport[k].dwrr : 0;
 			ret = hclge_tm_qs_weight_cfg(
 				hdev, vport[k].qs_offset + i,
-				vport[k].dwrr);
+				dwrr);
 			if (ret)
 				return ret;
 		}
@@ -1303,6 +1328,7 @@ static int hclge_tm_schd_mode_tc_base_cfg(struct hclge_dev *hdev, u8 pri_id)
 {
 	struct hclge_vport *vport = hdev->vport;
 	int ret;
+	u8 mode;
 	u16 i;
 
 	ret = hclge_tm_pri_schd_mode_cfg(hdev, pri_id);
@@ -1310,9 +1336,16 @@ static int hclge_tm_schd_mode_tc_base_cfg(struct hclge_dev *hdev, u8 pri_id)
 		return ret;
 
 	for (i = 0; i < hdev->num_alloc_vport; i++) {
+		struct hnae3_knic_private_info *kinfo = &vport[i].nic.kinfo;
+
+		if (pri_id >= kinfo->tc_info.max_tc)
+			continue;
+
+		mode = pri_id < kinfo->tc_info.num_tc ? HCLGE_SCH_MODE_DWRR :
+		       HCLGE_SCH_MODE_SP;
 		ret = hclge_tm_qs_schd_mode_cfg(hdev,
 						vport[i].qs_offset + pri_id,
-						HCLGE_SCH_MODE_DWRR);
+						mode);
 		if (ret)
 			return ret;
 	}
@@ -1353,7 +1386,7 @@ static int hclge_tm_lvl34_schd_mode_cfg(struct hclge_dev *hdev)
 	u8 i;
 
 	if (hdev->tx_sch_mode == HCLGE_FLAG_TC_BASE_SCH_MODE) {
-		for (i = 0; i < hdev->tm_info.num_tc; i++) {
+		for (i = 0; i < hdev->tc_max; i++) {
 			ret = hclge_tm_schd_mode_tc_base_cfg(hdev, i);
 			if (ret)
 				return ret;
-- 
2.33.0

