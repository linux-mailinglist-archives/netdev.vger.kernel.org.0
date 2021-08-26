Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20583F865F
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 13:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242201AbhHZL0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 07:26:44 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8778 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241879AbhHZL0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 07:26:41 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GwL9n5khQzYtry;
        Thu, 26 Aug 2021 19:25:17 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 26 Aug 2021 19:25:52 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 26 Aug 2021 19:25:52 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net 2/7] net: hns3: add waiting time before cmdq memory is released
Date:   Thu, 26 Aug 2021 19:21:56 +0800
Message-ID: <1629976921-43438-3-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1629976921-43438-1-git-send-email-huangguangbin2@huawei.com>
References: <1629976921-43438-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

After the cmdq registers are cleared, the firmware may take time to
clear out possible left over commands in the cmdq. Driver must release
cmdq memory only after firmware has completed processing of left over
commands.

Fixes: 232d0d55fca6 ("net: hns3: uninitialize command queue while unloading PF driver")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c   | 6 +++++-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h   | 1 +
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c | 7 ++++++-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h | 1 +
 4 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index 887297e37cf3..eb748aa35952 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -573,9 +573,13 @@ static void hclge_cmd_uninit_regs(struct hclge_hw *hw)
 
 void hclge_cmd_uninit(struct hclge_dev *hdev)
 {
+	set_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state);
+	/* wait to ensure that the firmware completes the possible left
+	 * over commands.
+	 */
+	msleep(HCLGE_CMDQ_CLEAR_WAIT_TIME);
 	spin_lock_bh(&hdev->hw.cmq.csq.lock);
 	spin_lock(&hdev->hw.cmq.crq.lock);
-	set_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state);
 	hclge_cmd_uninit_regs(&hdev->hw);
 	spin_unlock(&hdev->hw.cmq.crq.lock);
 	spin_unlock_bh(&hdev->hw.cmq.csq.lock);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index d455d689d93a..ac70d49e205d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -9,6 +9,7 @@
 #include "hnae3.h"
 
 #define HCLGE_CMDQ_TX_TIMEOUT		30000
+#define HCLGE_CMDQ_CLEAR_WAIT_TIME	200
 #define HCLGE_DESC_DATA_LEN		6
 
 struct hclge_dev;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index bd19a2d89f6c..d9ddb0a243d4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -507,12 +507,17 @@ static void hclgevf_cmd_uninit_regs(struct hclgevf_hw *hw)
 
 void hclgevf_cmd_uninit(struct hclgevf_dev *hdev)
 {
+	set_bit(HCLGEVF_STATE_CMD_DISABLE, &hdev->state);
+	/* wait to ensure that the firmware completes the possible left
+	 * over commands.
+	 */
+	msleep(HCLGEVF_CMDQ_CLEAR_WAIT_TIME);
 	spin_lock_bh(&hdev->hw.cmq.csq.lock);
 	spin_lock(&hdev->hw.cmq.crq.lock);
-	set_bit(HCLGEVF_STATE_CMD_DISABLE, &hdev->state);
 	hclgevf_cmd_uninit_regs(&hdev->hw);
 	spin_unlock(&hdev->hw.cmq.crq.lock);
 	spin_unlock_bh(&hdev->hw.cmq.csq.lock);
+
 	hclgevf_free_cmd_desc(&hdev->hw.cmq.csq);
 	hclgevf_free_cmd_desc(&hdev->hw.cmq.crq);
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
index 202feb70dba5..5b82177f98b4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
@@ -8,6 +8,7 @@
 #include "hnae3.h"
 
 #define HCLGEVF_CMDQ_TX_TIMEOUT		30000
+#define HCLGEVF_CMDQ_CLEAR_WAIT_TIME	200
 #define HCLGEVF_CMDQ_RX_INVLD_B		0
 #define HCLGEVF_CMDQ_RX_OUTVLD_B	1
 
-- 
2.8.1

