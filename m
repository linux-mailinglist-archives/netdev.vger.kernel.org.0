Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87B5AA04C9
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 16:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfH1OZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 10:25:44 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:41768 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726828AbfH1OZo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 10:25:44 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 58660D488D2F89626D47;
        Wed, 28 Aug 2019 22:25:41 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Wed, 28 Aug 2019 22:25:31 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Zhongzhu Liu <liuzhongzhu@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 08/12] net: hns3: optimize waiting time for TQP reset
Date:   Wed, 28 Aug 2019 22:23:12 +0800
Message-ID: <1567002196-63242-9-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567002196-63242-1-git-send-email-tanhuazhong@huawei.com>
References: <1567002196-63242-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhongzhu Liu <liuzhongzhu@huawei.com>

This patch optimizes the waiting time for TQP reset.

Signed-off-by: Zhongzhu Liu <liuzhongzhu@huawei.com>
Reviewed-by: Yunsheng Lin <linyunsheng@huawei.com>
Reviewed-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 10 ++++++----
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h |  2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 8a5b81d..f43c298 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8262,11 +8262,12 @@ int hclge_reset_tqp(struct hnae3_handle *handle, u16 queue_id)
 	}
 
 	while (reset_try_times++ < HCLGE_TQP_RESET_TRY_TIMES) {
-		/* Wait for tqp hw reset */
-		msleep(20);
 		reset_status = hclge_get_reset_status(hdev, queue_gid);
 		if (reset_status)
 			break;
+
+		/* Wait for tqp hw reset */
+		usleep_range(1000, 1200);
 	}
 
 	if (reset_try_times >= HCLGE_TQP_RESET_TRY_TIMES) {
@@ -8300,11 +8301,12 @@ void hclge_reset_vf_queue(struct hclge_vport *vport, u16 queue_id)
 	}
 
 	while (reset_try_times++ < HCLGE_TQP_RESET_TRY_TIMES) {
-		/* Wait for tqp hw reset */
-		msleep(20);
 		reset_status = hclge_get_reset_status(hdev, queue_gid);
 		if (reset_status)
 			break;
+
+		/* Wait for tqp hw reset */
+		usleep_range(1000, 1200);
 	}
 
 	if (reset_try_times >= HCLGE_TQP_RESET_TRY_TIMES) {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 7ff03b9..00c07f8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -119,7 +119,7 @@
 #define HCLGE_DEFAULT_UMV_SPACE_PER_PF \
 	(HCLGE_UMV_TBL_SIZE / HCLGE_MAX_PF_NUM)
 
-#define HCLGE_TQP_RESET_TRY_TIMES	10
+#define HCLGE_TQP_RESET_TRY_TIMES	200
 
 #define HCLGE_PHY_PAGE_MDIX		0
 #define HCLGE_PHY_PAGE_COPPER		0
-- 
2.7.4

