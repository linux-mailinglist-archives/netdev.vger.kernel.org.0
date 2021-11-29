Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2106046177A
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243825AbhK2OK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:10:27 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:28123 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240258AbhK2OI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 09:08:26 -0500
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4J2n9J2tCwz1DJft;
        Mon, 29 Nov 2021 22:02:28 +0800 (CST)
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
Subject: [PATCH net-next 06/10] net: hns3: add new function hclge_tm_schd_mode_tc_base_cfg()
Date:   Mon, 29 Nov 2021 22:00:23 +0800
Message-ID: <20211129140027.23036-7-huangguangbin2@huawei.com>
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

This patch encapsulates the process code of tc based schedule mode of
function hclge_tm_lvl34_schd_mode_cfg() into a new function
hclge_tm_schd_mode_tc_base_cfg(). It make code more concise and the new
process code can be reused.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 33 +++++++++++++------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 429652a8cde1..1afd305ebd36 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -1274,6 +1274,27 @@ static int hclge_tm_lvl2_schd_mode_cfg(struct hclge_dev *hdev)
 	return 0;
 }
 
+static int hclge_tm_schd_mode_tc_base_cfg(struct hclge_dev *hdev, u8 pri_id)
+{
+	struct hclge_vport *vport = hdev->vport;
+	int ret;
+	u16 i;
+
+	ret = hclge_tm_pri_schd_mode_cfg(hdev, pri_id);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < hdev->num_alloc_vport; i++) {
+		ret = hclge_tm_qs_schd_mode_cfg(hdev,
+						vport[i].qs_offset + pri_id,
+						HCLGE_SCH_MODE_DWRR);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 static int hclge_tm_schd_mode_vnet_base_cfg(struct hclge_vport *vport)
 {
 	struct hnae3_knic_private_info *kinfo = &vport->nic.kinfo;
@@ -1304,21 +1325,13 @@ static int hclge_tm_lvl34_schd_mode_cfg(struct hclge_dev *hdev)
 {
 	struct hclge_vport *vport = hdev->vport;
 	int ret;
-	u8 i, k;
+	u8 i;
 
 	if (hdev->tx_sch_mode == HCLGE_FLAG_TC_BASE_SCH_MODE) {
 		for (i = 0; i < hdev->tm_info.num_tc; i++) {
-			ret = hclge_tm_pri_schd_mode_cfg(hdev, i);
+			ret = hclge_tm_schd_mode_tc_base_cfg(hdev, i);
 			if (ret)
 				return ret;
-
-			for (k = 0; k < hdev->num_alloc_vport; k++) {
-				ret = hclge_tm_qs_schd_mode_cfg(
-					hdev, vport[k].qs_offset + i,
-					HCLGE_SCH_MODE_DWRR);
-				if (ret)
-					return ret;
-			}
 		}
 	} else {
 		for (i = 0; i < hdev->num_alloc_vport; i++) {
-- 
2.33.0

