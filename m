Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4AE1E62E2
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 15:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390773AbgE1Nwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 09:52:47 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5382 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390608AbgE1NvF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 09:51:05 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 5F3486E316487660269;
        Thu, 28 May 2020 21:50:59 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Thu, 28 May 2020 21:50:49 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 03/12] net: hns3: refactor hclge_config_tso()
Date:   Thu, 28 May 2020 21:48:10 +0800
Message-ID: <1590673699-63819-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590673699-63819-1-git-send-email-tanhuazhong@huawei.com>
References: <1590673699-63819-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since parameters 'tso_mss_min' and 'tso_mss_max' only indicate
the minimum and maximum MSS, the hnae3_set_field() calls are
meaningless, remove them and change the type of these two
parameters to u16.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 7d5c304..35e5cb8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1429,26 +1429,17 @@ static int hclge_configure(struct hclge_dev *hdev)
 	return ret;
 }
 
-static int hclge_config_tso(struct hclge_dev *hdev, unsigned int tso_mss_min,
-			    unsigned int tso_mss_max)
+static int hclge_config_tso(struct hclge_dev *hdev, u16 tso_mss_min,
+			    u16 tso_mss_max)
 {
 	struct hclge_cfg_tso_status_cmd *req;
 	struct hclge_desc desc;
-	u16 tso_mss;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_TSO_GENERIC_CONFIG, false);
 
 	req = (struct hclge_cfg_tso_status_cmd *)desc.data;
-
-	tso_mss = 0;
-	hnae3_set_field(tso_mss, HCLGE_TSO_MSS_MIN_M,
-			HCLGE_TSO_MSS_MIN_S, tso_mss_min);
-	req->tso_mss_min = cpu_to_le16(tso_mss);
-
-	tso_mss = 0;
-	hnae3_set_field(tso_mss, HCLGE_TSO_MSS_MIN_M,
-			HCLGE_TSO_MSS_MIN_S, tso_mss_max);
-	req->tso_mss_max = cpu_to_le16(tso_mss);
+	req->tso_mss_min = cpu_to_le16(tso_mss_min);
+	req->tso_mss_max = cpu_to_le16(tso_mss_max);
 
 	return hclge_cmd_send(&hdev->hw, &desc, 1);
 }
-- 
2.7.4

