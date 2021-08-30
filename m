Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55863FB111
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 08:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233839AbhH3GLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 02:11:48 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:18985 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232715AbhH3GLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 02:11:33 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GyfwL6bGXzbkWM;
        Mon, 30 Aug 2021 14:06:42 +0800 (CST)
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
Subject: [PATCH net-next 3/7] net: hns3: reconstruct function hclge_ets_validate()
Date:   Mon, 30 Aug 2021 14:06:38 +0800
Message-ID: <1630303602-44870-4-git-send-email-huangguangbin2@huawei.com>
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

This patch reconstructs function hclge_ets_validate() to reduce the code
cycle complexity and make code more concise.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c | 47 ++++++++++++++++------
 1 file changed, 35 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index 127160416ca6..4a619e5d3f35 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -104,26 +104,30 @@ static int hclge_dcb_common_validate(struct hclge_dev *hdev, u8 num_tc,
 	return 0;
 }
 
-static int hclge_ets_validate(struct hclge_dev *hdev, struct ieee_ets *ets,
-			      u8 *tc, bool *changed)
+static u8 hclge_ets_tc_changed(struct hclge_dev *hdev, struct ieee_ets *ets,
+			       bool *changed)
 {
-	bool has_ets_tc = false;
-	u32 total_ets_bw = 0;
-	u8 max_tc = 0;
-	int ret;
+	u8 max_tc_id = 0;
 	u8 i;
 
 	for (i = 0; i < HNAE3_MAX_USER_PRIO; i++) {
 		if (ets->prio_tc[i] != hdev->tm_info.prio_tc[i])
 			*changed = true;
 
-		if (ets->prio_tc[i] > max_tc)
-			max_tc = ets->prio_tc[i];
+		if (ets->prio_tc[i] > max_tc_id)
+			max_tc_id = ets->prio_tc[i];
 	}
 
-	ret = hclge_dcb_common_validate(hdev, max_tc + 1, ets->prio_tc);
-	if (ret)
-		return ret;
+	/* return max tc number, max tc id need to plus 1 */
+	return max_tc_id + 1;
+}
+
+static int hclge_ets_sch_mode_validate(struct hclge_dev *hdev,
+				       struct ieee_ets *ets, bool *changed)
+{
+	bool has_ets_tc = false;
+	u32 total_ets_bw = 0;
+	u8 i;
 
 	for (i = 0; i < hdev->tc_max; i++) {
 		switch (ets->tc_tsa[i]) {
@@ -148,7 +152,26 @@ static int hclge_ets_validate(struct hclge_dev *hdev, struct ieee_ets *ets,
 	if (has_ets_tc && total_ets_bw != BW_PERCENT)
 		return -EINVAL;
 
-	*tc = max_tc + 1;
+	return 0;
+}
+
+static int hclge_ets_validate(struct hclge_dev *hdev, struct ieee_ets *ets,
+			      u8 *tc, bool *changed)
+{
+	u8 tc_num;
+	int ret;
+
+	tc_num = hclge_ets_tc_changed(hdev, ets, changed);
+
+	ret = hclge_dcb_common_validate(hdev, tc_num, ets->prio_tc);
+	if (ret)
+		return ret;
+
+	ret = hclge_ets_sch_mode_validate(hdev, ets, changed);
+	if (ret)
+		return ret;
+
+	*tc = tc_num;
 	if (*tc != hdev->tm_info.num_tc)
 		*changed = true;
 
-- 
2.8.1

