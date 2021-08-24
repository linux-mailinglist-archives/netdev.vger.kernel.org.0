Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943373F54BD
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 02:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234433AbhHXA4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 20:56:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233930AbhHXAze (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 20:55:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3A9C61503;
        Tue, 24 Aug 2021 00:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766484;
        bh=yYIXePsMDMr4LSqP3OftBiaHJtUfw08euqDDpGm+8Og=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I397uiT69JpNl+Q7+b06a8ryRpVeT3cSoVLAzqfxq5Ly+uvB2qShsquGYGoyROUmW
         Vea19KUkMfOT5rTPq1OHi19oCW3F15CQylZKjtPpIyJg8QVYsBJEqeMqIva/Fq9hG2
         ycDieYF8263R3RilfPuB0MH5gP9E44c686pBP/SCqlHKcalANtlR99Azgb7lBmLyps
         VsbYXhcjYiSn535P3rZ8RU0/DUC8y7umxgAZ74IUqG3EkTVrhOV8wPQs8gPeZUcoxy
         Ed6MlJDo/C3sFUcWY1Hz8cQGjbenm777mNpRyHW9217yKrSYp4+IK2Vqj74CtqnLCQ
         nUP/Pb6G0QYew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shai Malin <smalin@marvell.com>, Ariel Elior <aelior@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 09/18] qed: qed ll2 race condition fixes
Date:   Mon, 23 Aug 2021 20:54:23 -0400
Message-Id: <20210824005432.631154-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824005432.631154-1-sashal@kernel.org>
References: <20210824005432.631154-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shai Malin <smalin@marvell.com>

[ Upstream commit 37110237f31105d679fc0aa7b11cdec867750ea7 ]

Avoiding qed ll2 race condition and NULL pointer dereference as part
of the remove and recovery flows.

Changes form V1:
- Change (!p_rx->set_prod_addr).
- qed_ll2.c checkpatch fixes.

Change from V2:
- Revert "qed_ll2.c checkpatch fixes".

Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_ll2.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
index 49783f365079..f2c8273dce67 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
@@ -327,6 +327,9 @@ static int qed_ll2_txq_completion(struct qed_hwfn *p_hwfn, void *p_cookie)
 	unsigned long flags;
 	int rc = -EINVAL;
 
+	if (!p_ll2_conn)
+		return rc;
+
 	spin_lock_irqsave(&p_tx->lock, flags);
 	if (p_tx->b_completing_packet) {
 		rc = -EBUSY;
@@ -500,7 +503,16 @@ static int qed_ll2_rxq_completion(struct qed_hwfn *p_hwfn, void *cookie)
 	unsigned long flags = 0;
 	int rc = 0;
 
+	if (!p_ll2_conn)
+		return rc;
+
 	spin_lock_irqsave(&p_rx->lock, flags);
+
+	if (!QED_LL2_RX_REGISTERED(p_ll2_conn)) {
+		spin_unlock_irqrestore(&p_rx->lock, flags);
+		return 0;
+	}
+
 	cq_new_idx = le16_to_cpu(*p_rx->p_fw_cons);
 	cq_old_idx = qed_chain_get_cons_idx(&p_rx->rcq_chain);
 
@@ -821,6 +833,9 @@ static int qed_ll2_lb_rxq_completion(struct qed_hwfn *p_hwfn, void *p_cookie)
 	struct qed_ll2_info *p_ll2_conn = (struct qed_ll2_info *)p_cookie;
 	int rc;
 
+	if (!p_ll2_conn)
+		return 0;
+
 	if (!QED_LL2_RX_REGISTERED(p_ll2_conn))
 		return 0;
 
@@ -844,6 +859,9 @@ static int qed_ll2_lb_txq_completion(struct qed_hwfn *p_hwfn, void *p_cookie)
 	u16 new_idx = 0, num_bds = 0;
 	int rc;
 
+	if (!p_ll2_conn)
+		return 0;
+
 	if (!QED_LL2_TX_REGISTERED(p_ll2_conn))
 		return 0;
 
@@ -1725,6 +1743,8 @@ int qed_ll2_post_rx_buffer(void *cxt,
 	if (!p_ll2_conn)
 		return -EINVAL;
 	p_rx = &p_ll2_conn->rx_queue;
+	if (!p_rx->set_prod_addr)
+		return -EIO;
 
 	spin_lock_irqsave(&p_rx->lock, flags);
 	if (!list_empty(&p_rx->free_descq))
-- 
2.30.2

