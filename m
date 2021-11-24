Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36CD945B109
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 02:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbhKXBOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 20:14:46 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:31900 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232744AbhKXBOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 20:14:41 -0500
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HzNJ00lb4zcbQd;
        Wed, 24 Nov 2021 09:11:28 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 24 Nov 2021 09:11:29 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 24 Nov 2021 09:11:28 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 1/4] net: hns3: add log for workqueue scheduled late
Date:   Wed, 24 Nov 2021 09:06:51 +0800
Message-ID: <20211124010654.6753-2-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124010654.6753-1-huangguangbin2@huawei.com>
References: <20211124010654.6753-1-huangguangbin2@huawei.com>
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

From: Yufeng Mo <moyufeng@huawei.com>

When the mbx or reset message arrives, the driver is informed
through an interrupt. This task can be processed only after
the workqueue is scheduled. In some cases, this workqueue
scheduling takes a long time. As a result, the mbx or reset
service task cannot be processed in time. So add some warning
message to improve debugging efficiency for this case.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hclge_mbx.h   |  3 +++
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 22 +++++++++++++++++--
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  2 ++
 .../hisilicon/hns3/hns3pf/hclge_mbx.c         |  8 +++++++
 4 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index c2bd2584201f..b668df6193be 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -80,6 +80,9 @@ enum hclge_mbx_tbl_cfg_subcode {
 #define HCLGE_MBX_MAX_RESP_DATA_SIZE	8U
 #define HCLGE_MBX_MAX_RING_CHAIN_PARAM_NUM	4
 
+#define HCLGE_RESET_SCHED_TIMEOUT	(3 * HZ)
+#define HCLGE_MBX_SCHED_TIMEOUT	(HZ / 2)
+
 struct hclge_ring_chain_param {
 	u8 ring_type;
 	u8 tqp_index;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index c2a58101144e..dd98143a65ee 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2933,16 +2933,20 @@ static int hclge_mac_init(struct hclge_dev *hdev)
 static void hclge_mbx_task_schedule(struct hclge_dev *hdev)
 {
 	if (!test_bit(HCLGE_STATE_REMOVING, &hdev->state) &&
-	    !test_and_set_bit(HCLGE_STATE_MBX_SERVICE_SCHED, &hdev->state))
+	    !test_and_set_bit(HCLGE_STATE_MBX_SERVICE_SCHED, &hdev->state)) {
+		hdev->last_mbx_scheduled = jiffies;
 		mod_delayed_work(hclge_wq, &hdev->service_task, 0);
+	}
 }
 
 static void hclge_reset_task_schedule(struct hclge_dev *hdev)
 {
 	if (!test_bit(HCLGE_STATE_REMOVING, &hdev->state) &&
 	    test_bit(HCLGE_STATE_SERVICE_INITED, &hdev->state) &&
-	    !test_and_set_bit(HCLGE_STATE_RST_SERVICE_SCHED, &hdev->state))
+	    !test_and_set_bit(HCLGE_STATE_RST_SERVICE_SCHED, &hdev->state)) {
+		hdev->last_rst_scheduled = jiffies;
 		mod_delayed_work(hclge_wq, &hdev->service_task, 0);
+	}
 }
 
 static void hclge_errhand_task_schedule(struct hclge_dev *hdev)
@@ -3831,6 +3835,13 @@ static void hclge_mailbox_service_task(struct hclge_dev *hdev)
 	    test_and_set_bit(HCLGE_STATE_MBX_HANDLING, &hdev->state))
 		return;
 
+	if (time_is_before_jiffies(hdev->last_mbx_scheduled +
+				   HCLGE_MBX_SCHED_TIMEOUT))
+		dev_warn(&hdev->pdev->dev,
+			 "mbx service task is scheduled after %ums on cpu%u!\n",
+			 jiffies_to_msecs(jiffies - hdev->last_mbx_scheduled),
+			 smp_processor_id());
+
 	hclge_mbx_handler(hdev);
 
 	clear_bit(HCLGE_STATE_MBX_HANDLING, &hdev->state);
@@ -4480,6 +4491,13 @@ static void hclge_reset_service_task(struct hclge_dev *hdev)
 	if (!test_and_clear_bit(HCLGE_STATE_RST_SERVICE_SCHED, &hdev->state))
 		return;
 
+	if (time_is_before_jiffies(hdev->last_rst_scheduled +
+				   HCLGE_RESET_SCHED_TIMEOUT))
+		dev_warn(&hdev->pdev->dev,
+			 "reset service task is scheduled after %ums on cpu%u!\n",
+			 jiffies_to_msecs(jiffies - hdev->last_rst_scheduled),
+			 smp_processor_id());
+
 	down(&hdev->reset_sem);
 	set_bit(HCLGE_STATE_RST_HANDLING, &hdev->state);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index ebba603483a0..42ce1eee33c4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -955,6 +955,8 @@ struct hclge_dev {
 	u16 hclge_fd_rule_num;
 	unsigned long serv_processed_cnt;
 	unsigned long last_serv_processed;
+	unsigned long last_rst_scheduled;
+	unsigned long last_mbx_scheduled;
 	unsigned long fd_bmap[BITS_TO_LONGS(MAX_FD_FILTER_NUM)];
 	enum HCLGE_FD_ACTIVE_RULE_TYPE fd_active_type;
 	u8 fd_en;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 65d78ee4d65a..c495df2e5953 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -848,6 +848,14 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 		if (hnae3_get_bit(req->mbx_need_resp, HCLGE_MBX_NEED_RESP_B) &&
 		    req->msg.code < HCLGE_MBX_GET_VF_FLR_STATUS) {
 			resp_msg.status = ret;
+			if (time_is_before_jiffies(hdev->last_mbx_scheduled +
+						   HCLGE_MBX_SCHED_TIMEOUT))
+				dev_warn(&hdev->pdev->dev,
+					 "resp vport%u mbx(%u,%u) late\n",
+					 req->mbx_src_vfid,
+					 req->msg.code,
+					 req->msg.subcode);
+
 			hclge_gen_resp_to_vf(vport, req, &resp_msg);
 		}
 
-- 
2.33.0

