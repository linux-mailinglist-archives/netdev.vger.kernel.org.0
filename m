Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A36DB1A0232
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 02:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbgDGACS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 20:02:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727994AbgDGACP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 20:02:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8BF720B1F;
        Tue,  7 Apr 2020 00:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217734;
        bh=muNrQiaZ8eIKGS+5LNkuEELzJtq6f1xeWtgQdhCXaFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OjEQ42aM+2jORmp67qq/slEN7tKVptWZGLcb5e/0SyIhQGhy/0HdlNHbcLz7kmYPT
         nXpahs3rVaSXRbbQ96zSnrSE53e6S46OJjHvc5Jl3uMb0FhaWjm3dnWSr6W1OzVmPs
         6WK1cHfMIUHT84nrtdtIrTsj+1DGlZrd2KsY9F+4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luo bin <luobin9@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 18/32] hinic: fix the bug of clearing event queue
Date:   Mon,  6 Apr 2020 20:01:36 -0400
Message-Id: <20200407000151.16768-18-sashal@kernel.org>
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

[ Upstream commit 614eaa943e9fc3fcdbd4aa0692ae84973d363333 ]

should disable eq irq before freeing it, must clear event queue
depth in hw before freeing relevant memory to avoid illegal
memory access and update consumer idx to avoid invalid interrupt

Signed-off-by: Luo bin <luobin9@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/huawei/hinic/hinic_hw_eqs.c  | 24 +++++++++++++------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
index 79243b626ddbe..6a723c4757bce 100644
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
2.20.1

