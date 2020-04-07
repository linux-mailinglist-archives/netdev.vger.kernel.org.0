Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75AF21A0279
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 02:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgDGAEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 20:04:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728312AbgDGAC7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 20:02:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D06D2078C;
        Tue,  7 Apr 2020 00:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217778;
        bh=YH4AGpdCWy5IFEc8AHZ2MuIqQUIpNjevYeeA9hxY4Kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NJQvek5Ndm4p5xSoU88fH0L1vfL+/iBfbowGLSUCxTh39opJzk2SrT1cLquT1OHyO
         BCpSA013xncjP/N28364zOKtw4YBd/rYXOoz8l+LF078xcGm1QDPHMsjQre5iJwNtE
         CLAlAsLHuQdBPdasOTa2Dq/Iz9Aa5VwSbPMdBos8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luo bin <luobin9@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 5/9] hinic: fix wrong para of wait_for_completion_timeout
Date:   Mon,  6 Apr 2020 20:02:48 -0400
Message-Id: <20200407000252.17241-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000252.17241-1-sashal@kernel.org>
References: <20200407000252.17241-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luo bin <luobin9@huawei.com>

[ Upstream commit 0da7c322f116210ebfdda59c7da663a6fc5e9cc8 ]

the second input parameter of wait_for_completion_timeout should
be jiffies instead of millisecond

Signed-off-by: Luo bin <luobin9@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c | 3 ++-
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c | 5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
index 7d95f0866fb0b..e1de97effcd24 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
@@ -398,7 +398,8 @@ static int cmdq_sync_cmd_direct_resp(struct hinic_cmdq *cmdq,
 
 	spin_unlock_bh(&cmdq->cmdq_lock);
 
-	if (!wait_for_completion_timeout(&done, CMDQ_TIMEOUT)) {
+	if (!wait_for_completion_timeout(&done,
+					 msecs_to_jiffies(CMDQ_TIMEOUT))) {
 		spin_lock_bh(&cmdq->cmdq_lock);
 
 		if (cmdq->errcode[curr_prod_idx] == &errcode)
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
index 278dc13f3dae8..9fcf2e5e00039 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
@@ -52,7 +52,7 @@
 
 #define MSG_NOT_RESP                    0xFFFF
 
-#define MGMT_MSG_TIMEOUT                1000
+#define MGMT_MSG_TIMEOUT                5000
 
 #define mgmt_to_pfhwdev(pf_mgmt)        \
 		container_of(pf_mgmt, struct hinic_pfhwdev, pf_to_mgmt)
@@ -276,7 +276,8 @@ static int msg_to_mgmt_sync(struct hinic_pf_to_mgmt *pf_to_mgmt,
 		goto unlock_sync_msg;
 	}
 
-	if (!wait_for_completion_timeout(recv_done, MGMT_MSG_TIMEOUT)) {
+	if (!wait_for_completion_timeout(recv_done,
+					 msecs_to_jiffies(MGMT_MSG_TIMEOUT))) {
 		dev_err(&pdev->dev, "MGMT timeout, MSG id = %d\n", msg_id);
 		err = -ETIMEDOUT;
 		goto unlock_sync_msg;
-- 
2.20.1

