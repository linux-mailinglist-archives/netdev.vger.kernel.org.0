Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 360D21A0317
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 02:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgDGAGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 20:06:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727905AbgDGACQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 20:02:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 262E220842;
        Tue,  7 Apr 2020 00:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217735;
        bh=+tDhdjPDbjaCxf9tPz+nxKTRrunX02hgzKXcO8H4XSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a1qCurGDTuWVs5IFwWuRYXclS9S+jDBCNaNPo9u0qfR8NfJWXL2q3S9C/TVtSxE/5
         jv++aDv+qYhdNi1cG4/fgcQBTfiFeUch0sf9hEz8O96Xa+hMHqOJLSbBykri09JT9c
         6gGNjcKKZymPdjl2UtYoq2QbK4zIC2tpXpGPbiUw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luo bin <luobin9@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 19/32] hinic: fix out-of-order excution in arm cpu
Date:   Mon,  6 Apr 2020 20:01:37 -0400
Message-Id: <20200407000151.16768-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000151.16768-1-sashal@kernel.org>
References: <20200407000151.16768-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luo bin <luobin9@huawei.com>

[ Upstream commit 33f15da216a1f4566b4ec880942556ace30615df ]

add read barrier in driver code to keep from reading other fileds
in dma memory which is writable for hw until we have verified the
memory is valid for driver

Signed-off-by: Luo bin <luobin9@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c | 2 ++
 drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c  | 2 ++
 drivers/net/ethernet/huawei/hinic/hinic_rx.c      | 3 +++
 drivers/net/ethernet/huawei/hinic/hinic_tx.c      | 2 ++
 4 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
index eb53c15b13f33..33f93cc25193a 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
@@ -623,6 +623,8 @@ static int cmdq_cmd_ceq_handler(struct hinic_cmdq *cmdq, u16 ci,
 	if (!CMDQ_WQE_COMPLETED(be32_to_cpu(ctrl->ctrl_info)))
 		return -EBUSY;
 
+	dma_rmb();
+
 	errcode = CMDQ_WQE_ERRCODE_GET(be32_to_cpu(status->status_info), VAL);
 
 	cmdq_sync_cmd_handler(cmdq, ci, errcode);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
index 6a723c4757bce..c0b6bcb067cd4 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
@@ -235,6 +235,8 @@ static void aeq_irq_handler(struct hinic_eq *eq)
 		if (HINIC_EQ_ELEM_DESC_GET(aeqe_desc, WRAPPED) == eq->wrapped)
 			break;
 
+		dma_rmb();
+
 		event = HINIC_EQ_ELEM_DESC_GET(aeqe_desc, TYPE);
 		if (event >= HINIC_MAX_AEQ_EVENTS) {
 			dev_err(&pdev->dev, "Unknown AEQ Event %d\n", event);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_rx.c b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
index 2695ad69fca60..815649e37cb15 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_rx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
@@ -350,6 +350,9 @@ static int rxq_recv(struct hinic_rxq *rxq, int budget)
 		if (!rq_wqe)
 			break;
 
+		/* make sure we read rx_done before packet length */
+		dma_rmb();
+
 		cqe = rq->cqe[ci];
 		status =  be32_to_cpu(cqe->status);
 		hinic_rq_get_sge(rxq->rq, rq_wqe, ci, &sge);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
index 0e13d1c7e4746..375d81d03e866 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -622,6 +622,8 @@ static int free_tx_poll(struct napi_struct *napi, int budget)
 	do {
 		hw_ci = HW_CONS_IDX(sq) & wq->mask;
 
+		dma_rmb();
+
 		/* Reading a WQEBB to get real WQE size and consumer index. */
 		sq_wqe = hinic_sq_read_wqebb(sq, &skb, &wqe_size, &sw_ci);
 		if ((!sq_wqe) ||
-- 
2.20.1

