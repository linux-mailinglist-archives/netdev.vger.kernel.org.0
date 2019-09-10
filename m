Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2751CAE645
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 11:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387764AbfIJJBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 05:01:51 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:55602 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726655AbfIJJBJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 05:01:09 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 98AAE63E293416FC9073;
        Tue, 10 Sep 2019 17:01:07 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Tue, 10 Sep 2019 17:01:01 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 7/7] net: hns3: add some DFX info for reset issue
Date:   Tue, 10 Sep 2019 16:58:28 +0800
Message-ID: <1568105908-60983-8-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1568105908-60983-1-git-send-email-tanhuazhong@huawei.com>
References: <1568105908-60983-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds more information for reset DFX. Also, adds some
cleanups to reset info, move reset_fail_cnt into struct
hclge_rst_stats, and modifies some print formats.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 32 ++++++++++++++++------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 11 ++++----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  2 +-
 3 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 6dcce48..d0128d7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -931,22 +931,36 @@ static void hclge_dbg_fd_tcam(struct hclge_dev *hdev)
 
 static void hclge_dbg_dump_rst_info(struct hclge_dev *hdev)
 {
-	dev_info(&hdev->pdev->dev, "PF reset count: %d\n",
+	dev_info(&hdev->pdev->dev, "PF reset count: %u\n",
 		 hdev->rst_stats.pf_rst_cnt);
-	dev_info(&hdev->pdev->dev, "FLR reset count: %d\n",
+	dev_info(&hdev->pdev->dev, "FLR reset count: %u\n",
 		 hdev->rst_stats.flr_rst_cnt);
-	dev_info(&hdev->pdev->dev, "CORE reset count: %d\n",
-		 hdev->rst_stats.core_rst_cnt);
-	dev_info(&hdev->pdev->dev, "GLOBAL reset count: %d\n",
+	dev_info(&hdev->pdev->dev, "GLOBAL reset count: %u\n",
 		 hdev->rst_stats.global_rst_cnt);
-	dev_info(&hdev->pdev->dev, "IMP reset count: %d\n",
+	dev_info(&hdev->pdev->dev, "IMP reset count: %u\n",
 		 hdev->rst_stats.imp_rst_cnt);
-	dev_info(&hdev->pdev->dev, "reset done count: %d\n",
+	dev_info(&hdev->pdev->dev, "reset done count: %u\n",
 		 hdev->rst_stats.reset_done_cnt);
-	dev_info(&hdev->pdev->dev, "HW reset done count: %d\n",
+	dev_info(&hdev->pdev->dev, "HW reset done count: %u\n",
 		 hdev->rst_stats.hw_reset_done_cnt);
-	dev_info(&hdev->pdev->dev, "reset count: %d\n",
+	dev_info(&hdev->pdev->dev, "reset count: %u\n",
 		 hdev->rst_stats.reset_cnt);
+	dev_info(&hdev->pdev->dev, "reset count: %u\n",
+		 hdev->rst_stats.reset_cnt);
+	dev_info(&hdev->pdev->dev, "reset fail count: %u\n",
+		 hdev->rst_stats.reset_fail_cnt);
+	dev_info(&hdev->pdev->dev, "vector0 interrupt enable status: 0x%x\n",
+		 hclge_read_dev(&hdev->hw, HCLGE_MISC_VECTOR_REG_BASE));
+	dev_info(&hdev->pdev->dev, "reset interrupt source: 0x%x\n",
+		 hclge_read_dev(&hdev->hw, HCLGE_MISC_RESET_STS_REG));
+	dev_info(&hdev->pdev->dev, "reset interrupt status: 0x%x\n",
+		 hclge_read_dev(&hdev->hw, HCLGE_MISC_VECTOR_INT_STS));
+	dev_info(&hdev->pdev->dev, "hardware reset status: 0x%x\n",
+		 hclge_read_dev(&hdev->hw, HCLGE_GLOBAL_RESET_REG));
+	dev_info(&hdev->pdev->dev, "handshake status: 0x%x\n",
+		 hclge_read_dev(&hdev->hw, HCLGE_NIC_CSQ_DEPTH_REG));
+	dev_info(&hdev->pdev->dev, "function reset status: 0x%x\n",
+		 hclge_read_dev(&hdev->hw, HCLGE_FUN_RST_ING));
 }
 
 static void hclge_dbg_get_m7_stats_info(struct hclge_dev *hdev)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index bc5bad3..fd7f943 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3547,12 +3547,12 @@ static bool hclge_reset_err_handle(struct hclge_dev *hdev)
 			 "reset failed because new reset interrupt\n");
 		hclge_clear_reset_cause(hdev);
 		return false;
-	} else if (hdev->reset_fail_cnt < MAX_RESET_FAIL_CNT) {
-		hdev->reset_fail_cnt++;
+	} else if (hdev->rst_stats.reset_fail_cnt < MAX_RESET_FAIL_CNT) {
+		hdev->rst_stats.reset_fail_cnt++;
 		set_bit(hdev->reset_type, &hdev->reset_pending);
 		dev_info(&hdev->pdev->dev,
 			 "re-schedule reset task(%d)\n",
-			 hdev->reset_fail_cnt);
+			 hdev->rst_stats.reset_fail_cnt);
 		return true;
 	}
 
@@ -3679,7 +3679,8 @@ static void hclge_reset(struct hclge_dev *hdev)
 	/* ignore RoCE notify error if it fails HCLGE_RESET_MAX_FAIL_CNT - 1
 	 * times
 	 */
-	if (ret && hdev->reset_fail_cnt < HCLGE_RESET_MAX_FAIL_CNT - 1)
+	if (ret &&
+	    hdev->rst_stats.reset_fail_cnt < HCLGE_RESET_MAX_FAIL_CNT - 1)
 		goto err_reset;
 
 	rtnl_lock();
@@ -3695,7 +3696,7 @@ static void hclge_reset(struct hclge_dev *hdev)
 		goto err_reset;
 
 	hdev->last_reset_time = jiffies;
-	hdev->reset_fail_cnt = 0;
+	hdev->rst_stats.reset_fail_cnt = 0;
 	hdev->rst_stats.reset_done_cnt++;
 	ae_dev->reset_type = HNAE3_NONE_RESET;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 870550f..3e9574a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -659,6 +659,7 @@ struct hclge_rst_stats {
 	u32 global_rst_cnt;	/* the number of GLOBAL */
 	u32 imp_rst_cnt;	/* the number of IMP reset */
 	u32 reset_cnt;		/* the number of reset */
+	u32 reset_fail_cnt;	/* the number of reset fail */
 };
 
 /* time and register status when mac tunnel interruption occur */
@@ -725,7 +726,6 @@ struct hclge_dev {
 	unsigned long reset_request;	/* reset has been requested */
 	unsigned long reset_pending;	/* client rst is pending to be served */
 	struct hclge_rst_stats rst_stats;
-	u32 reset_fail_cnt;
 	u32 fw_version;
 	u16 num_vmdq_vport;		/* Num vmdq vport this PF has set up */
 	u16 num_tqps;			/* Num task queue pairs of this PF */
-- 
2.7.4

