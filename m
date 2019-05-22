Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3D1726FD3
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730917AbfEVTXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:23:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730072AbfEVTXb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:23:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00CB120879;
        Wed, 22 May 2019 19:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553010;
        bh=P+R2WS1P5K+edrz0F0rQKyDg6nYgS4/rJHr/X8Zb5kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=peGvIh1jtRnM31XLtqHZTKxEfBckIK2MUOzWBek8DipbdVnqhEX94ZbWVA3V0OO+V
         aKXO2L6s02265GP3CSudNpLAb0K14zAhnkk5BRVGmF3tA8u4dcg8CiuMeptUMeDn5s
         zG7Te2npek3qMbXBrI5X8KWoTl7IYJBvAuKrK/jw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huazhong Tan <tanhuazhong@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 074/375] net: hns3: use atomic_t replace u32 for arq's count
Date:   Wed, 22 May 2019 15:16:14 -0400
Message-Id: <20190522192115.22666-74-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192115.22666-1-sashal@kernel.org>
References: <20190522192115.22666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>

[ Upstream commit 30780a8b1677e7409b32ae52a9a84f7d41ae6b43 ]

Since irq handler and mailbox task will both update arq's count,
so arq's count should use atomic_t instead of u32, otherwise
its value may go wrong finally.

Fixes: 07a0556a3a73 ("net: hns3: Changes to support ARQ(Asynchronous Receive Queue)")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h          | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c | 7 ++++---
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index 299b277bc7ae9..589b7ee32bff8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -107,7 +107,7 @@ struct hclgevf_mbx_arq_ring {
 	struct hclgevf_dev *hdev;
 	u32 head;
 	u32 tail;
-	u32 count;
+	atomic_t count;
 	u16 msg_q[HCLGE_MBX_MAX_ARQ_MSG_NUM][HCLGE_MBX_MAX_ARQ_MSG_SIZE];
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index 9441b453d38df..9a0a501908aec 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -327,7 +327,7 @@ int hclgevf_cmd_init(struct hclgevf_dev *hdev)
 	hdev->arq.hdev = hdev;
 	hdev->arq.head = 0;
 	hdev->arq.tail = 0;
-	hdev->arq.count = 0;
+	atomic_set(&hdev->arq.count, 0);
 	hdev->hw.cmq.csq.next_to_clean = 0;
 	hdev->hw.cmq.csq.next_to_use = 0;
 	hdev->hw.cmq.crq.next_to_clean = 0;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
index 7dc3c9f79169f..4f2c77283cb43 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
@@ -208,7 +208,8 @@ void hclgevf_mbx_handler(struct hclgevf_dev *hdev)
 			/* we will drop the async msg if we find ARQ as full
 			 * and continue with next message
 			 */
-			if (hdev->arq.count >= HCLGE_MBX_MAX_ARQ_MSG_NUM) {
+			if (atomic_read(&hdev->arq.count) >=
+			    HCLGE_MBX_MAX_ARQ_MSG_NUM) {
 				dev_warn(&hdev->pdev->dev,
 					 "Async Q full, dropping msg(%d)\n",
 					 req->msg[1]);
@@ -220,7 +221,7 @@ void hclgevf_mbx_handler(struct hclgevf_dev *hdev)
 			memcpy(&msg_q[0], req->msg,
 			       HCLGE_MBX_MAX_ARQ_MSG_SIZE * sizeof(u16));
 			hclge_mbx_tail_ptr_move_arq(hdev->arq);
-			hdev->arq.count++;
+			atomic_inc(&hdev->arq.count);
 
 			hclgevf_mbx_task_schedule(hdev);
 
@@ -308,7 +309,7 @@ void hclgevf_mbx_async_handler(struct hclgevf_dev *hdev)
 		}
 
 		hclge_mbx_head_ptr_move_arq(hdev->arq);
-		hdev->arq.count--;
+		atomic_dec(&hdev->arq.count);
 		msg_q = hdev->arq.msg_q[hdev->arq.head];
 	}
 }
-- 
2.20.1

