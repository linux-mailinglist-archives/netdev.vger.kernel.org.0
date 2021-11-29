Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5422F461784
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244271AbhK2OKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:10:40 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:16319 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240472AbhK2OIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 09:08:30 -0500
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J2nCr397Fz91SQ;
        Mon, 29 Nov 2021 22:04:40 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 22:05:07 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 22:05:07 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 07/10] net: hns3: refine function hclge_tm_pri_q_qs_cfg()
Date:   Mon, 29 Nov 2021 22:00:24 +0800
Message-ID: <20211129140027.23036-8-huangguangbin2@huawei.com>
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

This patch encapsulates the process code for queue to qset config of two
mode(tc based and vnet based) into two function, for making code more
concise.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 75 ++++++++++++-------
 1 file changed, 50 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 1afd305ebd36..3edbfc8d17e8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -916,38 +916,63 @@ static int hclge_vport_q_to_qs_map(struct hclge_dev *hdev,
 	return 0;
 }
 
-static int hclge_tm_pri_q_qs_cfg(struct hclge_dev *hdev)
+static int hclge_tm_pri_q_qs_cfg_tc_base(struct hclge_dev *hdev)
 {
 	struct hclge_vport *vport = hdev->vport;
+	u16 i, k;
 	int ret;
-	u32 i, k;
 
-	if (hdev->tx_sch_mode == HCLGE_FLAG_TC_BASE_SCH_MODE) {
-		/* Cfg qs -> pri mapping, one by one mapping */
-		for (k = 0; k < hdev->num_alloc_vport; k++) {
-			struct hnae3_knic_private_info *kinfo =
-				&vport[k].nic.kinfo;
-
-			for (i = 0; i < kinfo->tc_info.num_tc; i++) {
-				ret = hclge_tm_qs_to_pri_map_cfg(
-					hdev, vport[k].qs_offset + i, i);
-				if (ret)
-					return ret;
-			}
+	/* Cfg qs -> pri mapping, one by one mapping */
+	for (k = 0; k < hdev->num_alloc_vport; k++) {
+		struct hnae3_knic_private_info *kinfo = &vport[k].nic.kinfo;
+
+		for (i = 0; i < kinfo->tc_info.num_tc; i++) {
+			ret = hclge_tm_qs_to_pri_map_cfg(hdev,
+							 vport[k].qs_offset + i,
+							 i);
+			if (ret)
+				return ret;
 		}
-	} else if (hdev->tx_sch_mode == HCLGE_FLAG_VNET_BASE_SCH_MODE) {
-		/* Cfg qs -> pri mapping,  qs = tc, pri = vf, 8 qs -> 1 pri */
-		for (k = 0; k < hdev->num_alloc_vport; k++)
-			for (i = 0; i < HNAE3_MAX_TC; i++) {
-				ret = hclge_tm_qs_to_pri_map_cfg(
-					hdev, vport[k].qs_offset + i, k);
-				if (ret)
-					return ret;
-			}
-	} else {
-		return -EINVAL;
 	}
 
+	return 0;
+}
+
+static int hclge_tm_pri_q_qs_cfg_vnet_base(struct hclge_dev *hdev)
+{
+	struct hclge_vport *vport = hdev->vport;
+	u16 i, k;
+	int ret;
+
+	/* Cfg qs -> pri mapping,  qs = tc, pri = vf, 8 qs -> 1 pri */
+	for (k = 0; k < hdev->num_alloc_vport; k++)
+		for (i = 0; i < HNAE3_MAX_TC; i++) {
+			ret = hclge_tm_qs_to_pri_map_cfg(hdev,
+							 vport[k].qs_offset + i,
+							 k);
+			if (ret)
+				return ret;
+		}
+
+	return 0;
+}
+
+static int hclge_tm_pri_q_qs_cfg(struct hclge_dev *hdev)
+{
+	struct hclge_vport *vport = hdev->vport;
+	int ret;
+	u32 i;
+
+	if (hdev->tx_sch_mode == HCLGE_FLAG_TC_BASE_SCH_MODE)
+		ret = hclge_tm_pri_q_qs_cfg_tc_base(hdev);
+	else if (hdev->tx_sch_mode == HCLGE_FLAG_VNET_BASE_SCH_MODE)
+		ret = hclge_tm_pri_q_qs_cfg_vnet_base(hdev);
+	else
+		return -EINVAL;
+
+	if (ret)
+		return ret;
+
 	/* Cfg q -> qs mapping */
 	for (i = 0; i < hdev->num_alloc_vport; i++) {
 		ret = hclge_vport_q_to_qs_map(hdev, vport);
-- 
2.33.0

