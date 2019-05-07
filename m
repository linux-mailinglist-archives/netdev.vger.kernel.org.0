Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55B0115CCA
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 08:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbfEGGGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 02:06:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727301AbfEGFdl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:33:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F978214AE;
        Tue,  7 May 2019 05:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207220;
        bh=mtMDzxZPxAh0EDHxRHCQ4/YLrqXVHQcGl7Mse1HMZ24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w7Ap+N8actzmtqL1ccS0soXuUXH+2bOXXsJfAr1pQv85HPQ2BDtt2g6Q/EKx95WdO
         2BlwQL5nXTF0gxB0Yx+5+l/U+LGabuBJ2L0x6hK7nmygH6mW2/79E9M079oJ7YRDK7
         NZvN/cdfF0XVfrxH7rCH6rZ2OuYx0WN86O7M0KhY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Denis Bolotin <dbolotin@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 34/99] qed: Delete redundant doorbell recovery types
Date:   Tue,  7 May 2019 01:31:28 -0400
Message-Id: <20190507053235.29900-34-sashal@kernel.org>
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

[ Upstream commit 9ac6bb1414ac0d45fe9cefbd1f5b06f0e1a3c98a ]

DB_REC_DRY_RUN (running doorbell recovery without sending doorbells) is
never used. DB_REC_ONCE (send a single doorbell from the doorbell recovery)
is not needed anymore because by running the periodic handler we make sure
we check the overflow status later instead.
This patch is needed because in the next patches, the only doorbell
recovery type being used is DB_REC_REAL_DEAL, and the fixes are much
cleaner without this enum.

Signed-off-by: Denis Bolotin <dbolotin@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed.h     |  3 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c | 69 +++++++++--------------
 drivers/net/ethernet/qlogic/qed/qed_int.c |  6 +-
 drivers/net/ethernet/qlogic/qed/qed_int.h |  4 +-
 4 files changed, 31 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index 2d8a77cc156b..d5fece7eb169 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -918,8 +918,7 @@ u16 qed_get_cm_pq_idx_llt_mtc(struct qed_hwfn *p_hwfn, u8 tc);
 
 /* doorbell recovery mechanism */
 void qed_db_recovery_dp(struct qed_hwfn *p_hwfn);
-void qed_db_recovery_execute(struct qed_hwfn *p_hwfn,
-			     enum qed_db_rec_exec db_exec);
+void qed_db_recovery_execute(struct qed_hwfn *p_hwfn);
 bool qed_edpm_enabled(struct qed_hwfn *p_hwfn);
 
 /* Other Linux specific common definitions */
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index 2ecaaaa4469a..ff0bbf8d073d 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -300,26 +300,19 @@ void qed_db_recovery_dp(struct qed_hwfn *p_hwfn)
 
 /* Ring the doorbell of a single doorbell recovery entry */
 static void qed_db_recovery_ring(struct qed_hwfn *p_hwfn,
-				 struct qed_db_recovery_entry *db_entry,
-				 enum qed_db_rec_exec db_exec)
-{
-	if (db_exec != DB_REC_ONCE) {
-		/* Print according to width */
-		if (db_entry->db_width == DB_REC_WIDTH_32B) {
-			DP_VERBOSE(p_hwfn, QED_MSG_SPQ,
-				   "%s doorbell address %p data %x\n",
-				   db_exec == DB_REC_DRY_RUN ?
-				   "would have rung" : "ringing",
-				   db_entry->db_addr,
-				   *(u32 *)db_entry->db_data);
-		} else {
-			DP_VERBOSE(p_hwfn, QED_MSG_SPQ,
-				   "%s doorbell address %p data %llx\n",
-				   db_exec == DB_REC_DRY_RUN ?
-				   "would have rung" : "ringing",
-				   db_entry->db_addr,
-				   *(u64 *)(db_entry->db_data));
-		}
+				 struct qed_db_recovery_entry *db_entry)
+{
+	/* Print according to width */
+	if (db_entry->db_width == DB_REC_WIDTH_32B) {
+		DP_VERBOSE(p_hwfn, QED_MSG_SPQ,
+			   "ringing doorbell address %p data %x\n",
+			   db_entry->db_addr,
+			   *(u32 *)db_entry->db_data);
+	} else {
+		DP_VERBOSE(p_hwfn, QED_MSG_SPQ,
+			   "ringing doorbell address %p data %llx\n",
+			   db_entry->db_addr,
+			   *(u64 *)(db_entry->db_data));
 	}
 
 	/* Sanity */
@@ -334,14 +327,12 @@ static void qed_db_recovery_ring(struct qed_hwfn *p_hwfn,
 	wmb();
 
 	/* Ring the doorbell */
-	if (db_exec == DB_REC_REAL_DEAL || db_exec == DB_REC_ONCE) {
-		if (db_entry->db_width == DB_REC_WIDTH_32B)
-			DIRECT_REG_WR(db_entry->db_addr,
-				      *(u32 *)(db_entry->db_data));
-		else
-			DIRECT_REG_WR64(db_entry->db_addr,
-					*(u64 *)(db_entry->db_data));
-	}
+	if (db_entry->db_width == DB_REC_WIDTH_32B)
+		DIRECT_REG_WR(db_entry->db_addr,
+			      *(u32 *)(db_entry->db_data));
+	else
+		DIRECT_REG_WR64(db_entry->db_addr,
+				*(u64 *)(db_entry->db_data));
 
 	/* Flush the write combined buffer. Next doorbell may come from a
 	 * different entity to the same address...
@@ -350,29 +341,21 @@ static void qed_db_recovery_ring(struct qed_hwfn *p_hwfn,
 }
 
 /* Traverse the doorbell recovery entry list and ring all the doorbells */
-void qed_db_recovery_execute(struct qed_hwfn *p_hwfn,
-			     enum qed_db_rec_exec db_exec)
+void qed_db_recovery_execute(struct qed_hwfn *p_hwfn)
 {
 	struct qed_db_recovery_entry *db_entry = NULL;
 
-	if (db_exec != DB_REC_ONCE) {
-		DP_NOTICE(p_hwfn,
-			  "Executing doorbell recovery. Counter was %d\n",
-			  p_hwfn->db_recovery_info.db_recovery_counter);
+	DP_NOTICE(p_hwfn, "Executing doorbell recovery. Counter was %d\n",
+		  p_hwfn->db_recovery_info.db_recovery_counter);
 
-		/* Track amount of times recovery was executed */
-		p_hwfn->db_recovery_info.db_recovery_counter++;
-	}
+	/* Track amount of times recovery was executed */
+	p_hwfn->db_recovery_info.db_recovery_counter++;
 
 	/* Protect the list */
 	spin_lock_bh(&p_hwfn->db_recovery_info.lock);
 	list_for_each_entry(db_entry,
-			    &p_hwfn->db_recovery_info.list, list_entry) {
-		qed_db_recovery_ring(p_hwfn, db_entry, db_exec);
-		if (db_exec == DB_REC_ONCE)
-			break;
-	}
-
+			    &p_hwfn->db_recovery_info.list, list_entry)
+		qed_db_recovery_ring(p_hwfn, db_entry);
 	spin_unlock_bh(&p_hwfn->db_recovery_info.lock);
 }
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.c b/drivers/net/ethernet/qlogic/qed/qed_int.c
index 92340919d852..b994f81eb51c 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -409,10 +409,8 @@ int qed_db_rec_handler(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 
 	overflow = qed_rd(p_hwfn, p_ptt, DORQ_REG_PF_OVFL_STICKY);
 	DP_NOTICE(p_hwfn, "PF Overflow sticky 0x%x\n", overflow);
-	if (!overflow) {
-		qed_db_recovery_execute(p_hwfn, DB_REC_ONCE);
+	if (!overflow)
 		return 0;
-	}
 
 	if (qed_edpm_enabled(p_hwfn)) {
 		rc = qed_db_rec_flush_queue(p_hwfn, p_ptt);
@@ -427,7 +425,7 @@ int qed_db_rec_handler(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 	qed_wr(p_hwfn, p_ptt, DORQ_REG_PF_OVFL_STICKY, 0x0);
 
 	/* Repeat all last doorbells (doorbell drop recovery) */
-	qed_db_recovery_execute(p_hwfn, DB_REC_REAL_DEAL);
+	qed_db_recovery_execute(p_hwfn);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.h b/drivers/net/ethernet/qlogic/qed/qed_int.h
index d81a62ebd524..df26bf333893 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.h
@@ -192,8 +192,8 @@ void qed_int_disable_post_isr_release(struct qed_dev *cdev);
 
 /**
  * @brief - Doorbell Recovery handler.
- *          Run DB_REAL_DEAL doorbell recovery in case of PF overflow
- *          (and flush DORQ if needed), otherwise run DB_REC_ONCE.
+ *          Run doorbell recovery in case of PF overflow (and flush DORQ if
+ *          needed).
  *
  * @param p_hwfn
  * @param p_ptt
-- 
2.20.1

