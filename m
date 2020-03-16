Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E70741866B6
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 09:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730279AbgCPIkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 04:40:42 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:60424 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730025AbgCPIkl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 04:40:41 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 51A8BDE17E1D6F84F7D5;
        Mon, 16 Mar 2020 16:40:29 +0800 (CST)
Received: from localhost.localdomain (10.175.34.53) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Mon, 16 Mar 2020 16:40:22 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aviad.krawczyk@huawei.com>, <luoxianjun@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <yin.yinshi@huawei.com>
Subject: [PATCH net 4/6] hinic: fix out-of-order excution in arm cpu
Date:   Mon, 16 Mar 2020 00:56:28 +0000
Message-ID: <20200316005630.9817-5-luobin9@huawei.com>
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

add read barrier in driver code to keep from reading other fileds
in dma memory which is writable for hw until we have verified the
memory is valid for driver

Signed-off-by: Luo bin <luobin9@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c | 2 ++
 drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c  | 2 ++
 drivers/net/ethernet/huawei/hinic/hinic_rx.c      | 3 +++
 drivers/net/ethernet/huawei/hinic/hinic_tx.c      | 2 ++
 4 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
index eb53c15b13f3..33f93cc25193 100644
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
index 13f3abac54ea..fb662ab9b85d 100644
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
index 2695ad69fca6..815649e37cb1 100644
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
index 3c6762086fff..cabcc9019ee4 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -627,6 +627,8 @@ static int free_tx_poll(struct napi_struct *napi, int budget)
 	do {
 		hw_ci = HW_CONS_IDX(sq) & wq->mask;
 
+		dma_rmb();
+
 		/* Reading a WQEBB to get real WQE size and consumer index. */
 		sq_wqe = hinic_sq_read_wqebb(sq, &skb, &wqe_size, &sw_ci);
 		if ((!sq_wqe) ||
-- 
2.17.1

