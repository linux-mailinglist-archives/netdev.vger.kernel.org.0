Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 632D11866B7
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 09:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730295AbgCPIkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 04:40:49 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:60488 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730167AbgCPIkt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 04:40:49 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 55F6A13C2F8B8260B06B;
        Mon, 16 Mar 2020 16:40:29 +0800 (CST)
Received: from localhost.localdomain (10.175.34.53) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Mon, 16 Mar 2020 16:40:23 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aviad.krawczyk@huawei.com>, <luoxianjun@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <yin.yinshi@huawei.com>
Subject: [PATCH net 5/6] hinic: fix wrong para of wait_for_completion_timeout
Date:   Mon, 16 Mar 2020 00:56:29 +0000
Message-ID: <20200316005630.9817-6-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200316005630.9817-1-luobin9@huawei.com>
References: <20200316005630.9817-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.34.53]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the second input parameter of wait_for_completion_timeout should
be jiffies instead of millisecond

Signed-off-by: Luo bin <luobin9@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c | 3 ++-
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c | 5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
index 33f93cc25193..5f2d57d1b2d3 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
@@ -389,7 +389,8 @@ static int cmdq_sync_cmd_direct_resp(struct hinic_cmdq *cmdq,
 
 	spin_unlock_bh(&cmdq->cmdq_lock);
 
-	if (!wait_for_completion_timeout(&done, CMDQ_TIMEOUT)) {
+	if (!wait_for_completion_timeout(&done,
+					 msecs_to_jiffies(CMDQ_TIMEOUT))) {
 		spin_lock_bh(&cmdq->cmdq_lock);
 
 		if (cmdq->errcode[curr_prod_idx] == &errcode)
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
index c1a6be6bf6a8..8995e32dd1c0 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
@@ -43,7 +43,7 @@
 
 #define MSG_NOT_RESP                    0xFFFF
 
-#define MGMT_MSG_TIMEOUT                1000
+#define MGMT_MSG_TIMEOUT                5000
 
 #define mgmt_to_pfhwdev(pf_mgmt)        \
 		container_of(pf_mgmt, struct hinic_pfhwdev, pf_to_mgmt)
@@ -267,7 +267,8 @@ static int msg_to_mgmt_sync(struct hinic_pf_to_mgmt *pf_to_mgmt,
 		goto unlock_sync_msg;
 	}
 
-	if (!wait_for_completion_timeout(recv_done, MGMT_MSG_TIMEOUT)) {
+	if (!wait_for_completion_timeout(recv_done,
+					 msecs_to_jiffies(MGMT_MSG_TIMEOUT))) {
 		dev_err(&pdev->dev, "MGMT timeout, MSG id = %d\n", msg_id);
 		err = -ETIMEDOUT;
 		goto unlock_sync_msg;
-- 
2.17.1

