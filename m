Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0123FB110
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 08:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233648AbhH3GLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 02:11:47 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9384 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232647AbhH3GLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 02:11:33 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Gyfvz5cnnz8wZN;
        Mon, 30 Aug 2021 14:06:23 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 30 Aug 2021 14:10:36 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Mon, 30 Aug 2021 14:10:36 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 4/7] net: hns3: refine function hclge_dbg_dump_tm_pri()
Date:   Mon, 30 Aug 2021 14:06:39 +0800
Message-ID: <1630303602-44870-5-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1630303602-44870-1-git-send-email-huangguangbin2@huawei.com>
References: <1630303602-44870-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To improve flexibility, simplicity and maintainability to dump info of
every element of tm priority, add a struct hclge_dbg_item array of tm
priority and fill string of every data according to this array.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 70 +++++++++++++---------
 1 file changed, 42 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 288788186ecc..68ed1715ac52 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -926,26 +926,45 @@ static int hclge_dbg_dump_tm_nodes(struct hclge_dev *hdev, char *buf, int len)
 	return 0;
 }
 
+static const struct hclge_dbg_item tm_pri_items[] = {
+	{ "ID", 4 },
+	{ "MODE", 2 },
+	{ "DWRR", 2 },
+	{ "C_IR_B", 2 },
+	{ "C_IR_U", 2 },
+	{ "C_IR_S", 2 },
+	{ "C_BS_B", 2 },
+	{ "C_BS_S", 2 },
+	{ "C_FLAG", 2 },
+	{ "C_RATE(Mbps)", 2 },
+	{ "P_IR_B", 2 },
+	{ "P_IR_U", 2 },
+	{ "P_IR_S", 2 },
+	{ "P_BS_B", 2 },
+	{ "P_BS_S", 2 },
+	{ "P_FLAG", 2 },
+	{ "P_RATE(Mbps)", 0 }
+};
+
 static int hclge_dbg_dump_tm_pri(struct hclge_dev *hdev, char *buf, int len)
 {
-	struct hclge_tm_shaper_para c_shaper_para;
-	struct hclge_tm_shaper_para p_shaper_para;
-	u8 pri_num, sch_mode, weight;
-	char *sch_mode_str;
-	int pos = 0;
-	int ret;
-	u8 i;
+	char data_str[ARRAY_SIZE(tm_pri_items)][HCLGE_DBG_DATA_STR_LEN];
+	struct hclge_tm_shaper_para c_shaper_para, p_shaper_para;
+	char *result[ARRAY_SIZE(tm_pri_items)], *sch_mode_str;
+	char content[HCLGE_DBG_TM_INFO_LEN];
+	u8 pri_num, sch_mode, weight, i, j;
+	int pos, ret;
 
 	ret = hclge_tm_get_pri_num(hdev, &pri_num);
 	if (ret)
 		return ret;
 
-	pos += scnprintf(buf + pos, len - pos,
-			 "ID    MODE  DWRR  C_IR_B  C_IR_U  C_IR_S  C_BS_B  ");
-	pos += scnprintf(buf + pos, len - pos,
-			 "C_BS_S  C_FLAG  C_RATE(Mbps)  P_IR_B  P_IR_U  ");
-	pos += scnprintf(buf + pos, len - pos,
-			 "P_IR_S  P_BS_B  P_BS_S  P_FLAG  P_RATE(Mbps)\n");
+	for (i = 0; i < ARRAY_SIZE(tm_pri_items); i++)
+		result[i] = &data_str[i][0];
+
+	hclge_dbg_fill_content(content, sizeof(content), tm_pri_items,
+			       NULL, ARRAY_SIZE(tm_pri_items));
+	pos = scnprintf(buf, len, "%s", content);
 
 	for (i = 0; i < pri_num; i++) {
 		ret = hclge_tm_get_pri_sch_mode(hdev, i, &sch_mode);
@@ -971,21 +990,16 @@ static int hclge_dbg_dump_tm_pri(struct hclge_dev *hdev, char *buf, int len)
 		sch_mode_str = sch_mode & HCLGE_TM_TX_SCHD_DWRR_MSK ? "dwrr" :
 			       "sp";
 
-		pos += scnprintf(buf + pos, len - pos,
-				 "%04u  %4s  %3u   %3u     %3u     %3u     ",
-				 i, sch_mode_str, weight, c_shaper_para.ir_b,
-				 c_shaper_para.ir_u, c_shaper_para.ir_s);
-		pos += scnprintf(buf + pos, len - pos,
-				 "%3u     %3u       %1u     %6u        ",
-				 c_shaper_para.bs_b, c_shaper_para.bs_s,
-				 c_shaper_para.flag, c_shaper_para.rate);
-		pos += scnprintf(buf + pos, len - pos,
-				 "%3u     %3u     %3u     %3u     %3u       ",
-				 p_shaper_para.ir_b, p_shaper_para.ir_u,
-				 p_shaper_para.ir_s, p_shaper_para.bs_b,
-				 p_shaper_para.bs_s);
-		pos += scnprintf(buf + pos, len - pos, "%1u     %6u\n",
-				 p_shaper_para.flag, p_shaper_para.rate);
+		j = 0;
+		sprintf(result[j++], "%04u", i);
+		sprintf(result[j++], "%4s", sch_mode_str);
+		sprintf(result[j++], "%3u", weight);
+		hclge_dbg_fill_shaper_content(&c_shaper_para, result, &j);
+		hclge_dbg_fill_shaper_content(&p_shaper_para, result, &j);
+		hclge_dbg_fill_content(content, sizeof(content), tm_pri_items,
+				       (const char **)result,
+				       ARRAY_SIZE(tm_pri_items));
+		pos += scnprintf(buf + pos, len - pos, "%s", content);
 	}
 
 	return 0;
-- 
2.8.1

