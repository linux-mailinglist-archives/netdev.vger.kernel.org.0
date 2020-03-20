Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E26C18DE59
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 07:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgCUG6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 02:58:42 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:32978 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728070AbgCUG6g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Mar 2020 02:58:36 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 82D3CDAAE4590F25CC9B;
        Sat, 21 Mar 2020 14:58:20 +0800 (CST)
Received: from localhost.localdomain (10.175.34.53) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Sat, 21 Mar 2020 14:57:23 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <luobin9@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
Subject: [PATCH net 2/5] hinic: fix the bug of clearing event queue
Date:   Fri, 20 Mar 2020 23:13:17 +0000
Message-ID: <20200320231320.1001-3-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200320231320.1001-1-luobin9@huawei.com>
References: <20200320231320.1001-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.34.53]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

should disable eq irq before freeing it, must clear event queue
depth in hw before freeing relevant memory to avoid illegal
memory access and update consumer idx to avoid invalid interrupt

Signed-off-by: Luo bin <luobin9@huawei.com>
---
 .../net/ethernet/huawei/hinic/hinic_hw_eqs.c  | 24 +++++++++++++------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
index 79243b626ddb..6a723c4757bc 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
@@ -188,7 +188,7 @@ static u8 eq_cons_idx_checksum_set(u32 val)
  * eq_update_ci - update the HW cons idx of event queue
  * @eq: the event queue to update the cons idx for
  **/
-static void eq_update_ci(struct hinic_eq *eq)
+static void eq_update_ci(struct hinic_eq *eq, u32 arm_state)
 {
 	u32 val, addr = EQ_CONS_IDX_REG_ADDR(eq);
 
@@ -202,7 +202,7 @@ static void eq_update_ci(struct hinic_eq *eq)
 
 	val |= HINIC_EQ_CI_SET(eq->cons_idx, IDX)    |
 	       HINIC_EQ_CI_SET(eq->wrapped, WRAPPED) |
-	       HINIC_EQ_CI_SET(EQ_ARMED, INT_ARMED);
+	       HINIC_EQ_CI_SET(arm_state, INT_ARMED);
 
 	val |= HINIC_EQ_CI_SET(eq_cons_idx_checksum_set(val), XOR_CHKSUM);
 
@@ -347,7 +347,7 @@ static void eq_irq_handler(void *data)
 	else if (eq->type == HINIC_CEQ)
 		ceq_irq_handler(eq);
 
-	eq_update_ci(eq);
+	eq_update_ci(eq, EQ_ARMED);
 }
 
 /**
@@ -702,7 +702,7 @@ static int init_eq(struct hinic_eq *eq, struct hinic_hwif *hwif,
 	}
 
 	set_eq_ctrls(eq);
-	eq_update_ci(eq);
+	eq_update_ci(eq, EQ_ARMED);
 
 	err = alloc_eq_pages(eq);
 	if (err) {
@@ -752,18 +752,28 @@ static int init_eq(struct hinic_eq *eq, struct hinic_hwif *hwif,
  **/
 static void remove_eq(struct hinic_eq *eq)
 {
-	struct msix_entry *entry = &eq->msix_entry;
-
-	free_irq(entry->vector, eq);
+	hinic_set_msix_state(eq->hwif, eq->msix_entry.entry,
+			     HINIC_MSIX_DISABLE);
+	free_irq(eq->msix_entry.vector, eq);
 
 	if (eq->type == HINIC_AEQ) {
 		struct hinic_eq_work *aeq_work = &eq->aeq_work;
 
 		cancel_work_sync(&aeq_work->work);
+		/* clear aeq_len to avoid hw access host memory */
+		hinic_hwif_write_reg(eq->hwif,
+				     HINIC_CSR_AEQ_CTRL_1_ADDR(eq->q_id), 0);
 	} else if (eq->type == HINIC_CEQ) {
 		tasklet_kill(&eq->ceq_tasklet);
+		/* clear ceq_len to avoid hw access host memory */
+		hinic_hwif_write_reg(eq->hwif,
+				     HINIC_CSR_CEQ_CTRL_1_ADDR(eq->q_id), 0);
 	}
 
+	/* update cons_idx to avoid invalid interrupt */
+	eq->cons_idx = hinic_hwif_read_reg(eq->hwif, EQ_PROD_IDX_REG_ADDR(eq));
+	eq_update_ci(eq, EQ_NOT_ARMED);
+
 	free_eq_pages(eq);
 }
 
-- 
2.17.1

