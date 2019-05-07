Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB32415CBF
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 08:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfEGGGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 02:06:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727274AbfEGFdp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:33:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF23D206A3;
        Tue,  7 May 2019 05:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207224;
        bh=x5frDouWI3KLfoCg7ukxvQ0uGxS5IGb26ZNCG3OqipY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vUeR+fDJf6Sq9EnI10KsWsOC7v9UByTivJwIpS3mTllKhoXtF3u4YTLc0FMdAU5US
         /ZU0jETdUww7LHF0yKoCLUsEuReullNUz6xyWwuvu2XE9ldLWcPH3IGeMwikyxr0iP
         BV0xZzOQ6jBsMVmdL0WUstBF8iuUZzrS+o04+SX8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Denis Bolotin <dbolotin@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 37/99] qed: Fix the DORQ's attentions handling
Date:   Tue,  7 May 2019 01:31:31 -0400
Message-Id: <20190507053235.29900-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Denis Bolotin <dbolotin@marvell.com>

[ Upstream commit 0d72c2ac89185f179da1e8a91c40c82f3fa38f0b ]

Separate the overflow handling from the hardware interrupt status analysis.
The interrupt status is a single register and is common for all PFs. The
first PF reading the register is not necessarily the one who overflowed.
All PFs must check their overflow status on every attention.
In this change we clear the sticky indication in the attention handler to
allow doorbells to be processed again as soon as possible, but running
the doorbell recovery is scheduled for the periodic handler to reduce the
time spent in the attention handler.
Checking the need for DORQ flush was changed to "db_bar_no_edpm" because
qed_edpm_enabled()'s result could change dynamically and might have
prevented a needed flush.

Signed-off-by: Denis Bolotin <dbolotin@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed.h     |  3 ++
 drivers/net/ethernet/qlogic/qed/qed_int.c | 61 +++++++++++++++++------
 2 files changed, 48 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index 07ae600d0f35..f458c9776a89 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -431,6 +431,8 @@ struct qed_qm_info {
 	u8 num_pf_rls;
 };
 
+#define QED_OVERFLOW_BIT	1
+
 struct qed_db_recovery_info {
 	struct list_head list;
 
@@ -438,6 +440,7 @@ struct qed_db_recovery_info {
 	spinlock_t lock;
 	bool dorq_attn;
 	u32 db_recovery_counter;
+	unsigned long overflow;
 };
 
 struct storm_stats {
diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.c b/drivers/net/ethernet/qlogic/qed/qed_int.c
index 00688f4c0464..a7e95f239317 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -376,6 +376,9 @@ static int qed_db_rec_flush_queue(struct qed_hwfn *p_hwfn,
 	u32 count = QED_DB_REC_COUNT;
 	u32 usage = 1;
 
+	/* Flush any pending (e)dpms as they may never arrive */
+	qed_wr(p_hwfn, p_ptt, DORQ_REG_DPM_FORCE_ABORT, 0x1);
+
 	/* wait for usage to zero or count to run out. This is necessary since
 	 * EDPM doorbell transactions can take multiple 64b cycles, and as such
 	 * can "split" over the pci. Possibly, the doorbell drop can happen with
@@ -404,23 +407,24 @@ static int qed_db_rec_flush_queue(struct qed_hwfn *p_hwfn,
 
 int qed_db_rec_handler(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 {
-	u32 overflow;
+	u32 attn_ovfl, cur_ovfl;
 	int rc;
 
-	overflow = qed_rd(p_hwfn, p_ptt, DORQ_REG_PF_OVFL_STICKY);
-	DP_NOTICE(p_hwfn, "PF Overflow sticky 0x%x\n", overflow);
-	if (!overflow)
+	attn_ovfl = test_and_clear_bit(QED_OVERFLOW_BIT,
+				       &p_hwfn->db_recovery_info.overflow);
+	cur_ovfl = qed_rd(p_hwfn, p_ptt, DORQ_REG_PF_OVFL_STICKY);
+	if (!cur_ovfl && !attn_ovfl)
 		return 0;
 
-	if (qed_edpm_enabled(p_hwfn)) {
+	DP_NOTICE(p_hwfn, "PF Overflow sticky: attn %u current %u\n",
+		  attn_ovfl, cur_ovfl);
+
+	if (cur_ovfl && !p_hwfn->db_bar_no_edpm) {
 		rc = qed_db_rec_flush_queue(p_hwfn, p_ptt);
 		if (rc)
 			return rc;
 	}
 
-	/* Flush any pending (e)dpm as they may never arrive */
-	qed_wr(p_hwfn, p_ptt, DORQ_REG_DPM_FORCE_ABORT, 0x1);
-
 	/* Release overflow sticky indication (stop silently dropping everything) */
 	qed_wr(p_hwfn, p_ptt, DORQ_REG_PF_OVFL_STICKY, 0x0);
 
@@ -430,13 +434,35 @@ int qed_db_rec_handler(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 	return 0;
 }
 
-static int qed_dorq_attn_cb(struct qed_hwfn *p_hwfn)
+static void qed_dorq_attn_overflow(struct qed_hwfn *p_hwfn)
 {
-	u32 int_sts, first_drop_reason, details, address, all_drops_reason;
 	struct qed_ptt *p_ptt = p_hwfn->p_dpc_ptt;
+	u32 overflow;
 	int rc;
 
-	p_hwfn->db_recovery_info.dorq_attn = true;
+	overflow = qed_rd(p_hwfn, p_ptt, DORQ_REG_PF_OVFL_STICKY);
+	if (!overflow)
+		goto out;
+
+	/* Run PF doorbell recovery in next periodic handler */
+	set_bit(QED_OVERFLOW_BIT, &p_hwfn->db_recovery_info.overflow);
+
+	if (!p_hwfn->db_bar_no_edpm) {
+		rc = qed_db_rec_flush_queue(p_hwfn, p_ptt);
+		if (rc)
+			goto out;
+	}
+
+	qed_wr(p_hwfn, p_ptt, DORQ_REG_PF_OVFL_STICKY, 0x0);
+out:
+	/* Schedule the handler even if overflow was not detected */
+	qed_periodic_db_rec_start(p_hwfn);
+}
+
+static int qed_dorq_attn_int_sts(struct qed_hwfn *p_hwfn)
+{
+	u32 int_sts, first_drop_reason, details, address, all_drops_reason;
+	struct qed_ptt *p_ptt = p_hwfn->p_dpc_ptt;
 
 	/* int_sts may be zero since all PFs were interrupted for doorbell
 	 * overflow but another one already handled it. Can abort here. If
@@ -475,11 +501,6 @@ static int qed_dorq_attn_cb(struct qed_hwfn *p_hwfn)
 			  GET_FIELD(details, QED_DORQ_ATTENTION_SIZE) * 4,
 			  first_drop_reason, all_drops_reason);
 
-		rc = qed_db_rec_handler(p_hwfn, p_ptt);
-		qed_periodic_db_rec_start(p_hwfn);
-		if (rc)
-			return rc;
-
 		/* Clear the doorbell drop details and prepare for next drop */
 		qed_wr(p_hwfn, p_ptt, DORQ_REG_DB_DROP_DETAILS_REL, 0);
 
@@ -505,6 +526,14 @@ static int qed_dorq_attn_cb(struct qed_hwfn *p_hwfn)
 	return -EINVAL;
 }
 
+static int qed_dorq_attn_cb(struct qed_hwfn *p_hwfn)
+{
+	p_hwfn->db_recovery_info.dorq_attn = true;
+	qed_dorq_attn_overflow(p_hwfn);
+
+	return qed_dorq_attn_int_sts(p_hwfn);
+}
+
 static void qed_dorq_attn_handler(struct qed_hwfn *p_hwfn)
 {
 	if (p_hwfn->db_recovery_info.dorq_attn)
-- 
2.20.1

