Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 204D644C26F
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 14:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbhKJNua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 08:50:30 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:26300 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbhKJNuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 08:50:20 -0500
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Hq5d92sStzbhn7;
        Wed, 10 Nov 2021 21:42:37 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 10 Nov 2021 21:47:27 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 10 Nov 2021 21:47:26 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 8/8] net: hns3: allow configure ETS bandwidth of all TCs
Date:   Wed, 10 Nov 2021 21:42:56 +0800
Message-ID: <20211110134256.25025-9-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211110134256.25025-1-huangguangbin2@huawei.com>
References: <20211110134256.25025-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, driver only allow configuring ETS bandwidth of TCs according
to the max TC number queried from firmware. However, the hardware actually
supports 8 TCs and users may need to configure ETS bandwidth of all TCs,
so remove the restriction.

Fixes: 330baff5423b ("net: hns3: add ETS TC weight setting in SSU module")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  | 9 +--------
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index 90013c131e94..375ebf105a9a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -129,7 +129,7 @@ static int hclge_ets_sch_mode_validate(struct hclge_dev *hdev,
 	u32 total_ets_bw = 0;
 	u8 i;
 
-	for (i = 0; i < hdev->tc_max; i++) {
+	for (i = 0; i < HNAE3_MAX_TC; i++) {
 		switch (ets->tc_tsa[i]) {
 		case IEEE_8021QAZ_TSA_STRICT:
 			if (hdev->tm_info.tc_info[i].tc_sch_mode !=
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index a50e2edbf4a0..429652a8cde1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -1123,7 +1123,6 @@ static int hclge_tm_pri_tc_base_dwrr_cfg(struct hclge_dev *hdev)
 
 static int hclge_tm_ets_tc_dwrr_cfg(struct hclge_dev *hdev)
 {
-#define DEFAULT_TC_WEIGHT	1
 #define DEFAULT_TC_OFFSET	14
 
 	struct hclge_ets_tc_weight_cmd *ets_weight;
@@ -1136,13 +1135,7 @@ static int hclge_tm_ets_tc_dwrr_cfg(struct hclge_dev *hdev)
 	for (i = 0; i < HNAE3_MAX_TC; i++) {
 		struct hclge_pg_info *pg_info;
 
-		ets_weight->tc_weight[i] = DEFAULT_TC_WEIGHT;
-
-		if (!(hdev->hw_tc_map & BIT(i)))
-			continue;
-
-		pg_info =
-			&hdev->tm_info.pg_info[hdev->tm_info.tc_info[i].pgid];
+		pg_info = &hdev->tm_info.pg_info[hdev->tm_info.tc_info[i].pgid];
 		ets_weight->tc_weight[i] = pg_info->tc_dwrr[i];
 	}
 
-- 
2.33.0

