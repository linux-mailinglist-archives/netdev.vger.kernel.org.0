Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E47351591C
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 07:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbfEGFdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:33:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727316AbfEGFdo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:33:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EF5D20C01;
        Tue,  7 May 2019 05:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207223;
        bh=ptVtqOMVYoCmNDp4VQ6JUp/GpkRIfYIiQsi7nEBA6lM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yf19qSUfp5SdwV/i6ZOQIRErURGB+DvdoIbzkpTrk5O53jnNPGpH1qvRvV/VHAeYz
         EroZF7oLZj+kbzWMFiaAXzNYKRl+awTRY5eA7kYfXPG4+UnlHYI0NBnWzfNMEBQDKX
         pVP6uov3baSnzCWYfz2ASakqvzJJUOq9U3xuM80g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Denis Bolotin <dbolotin@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 36/99] qed: Fix missing DORQ attentions
Date:   Tue,  7 May 2019 01:31:30 -0400
Message-Id: <20190507053235.29900-36-sashal@kernel.org>
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

[ Upstream commit d4476b8a6151b2dd86c09b5acec64f66430db55d ]

When the DORQ (doorbell block) is overflowed, all PFs get attentions at the
same time. If one PF finished handling the attention before another PF even
started, the second PF might miss the DORQ's attention bit and not handle
the attention at all.
If the DORQ attention is missed and the issue is not resolved, another
attention will not be sent, therefore each attention is treated as a
potential DORQ attention.
As a result, the attention callback is called more frequently so the debug
print was moved to reduce its quantity.
The number of periodic doorbell recovery handler schedules was reduced
because it was the previous way to mitigating the missed attention issue.

Signed-off-by: Denis Bolotin <dbolotin@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed.h      |  1 +
 drivers/net/ethernet/qlogic/qed/qed_int.c  | 20 ++++++++++++++++++--
 drivers/net/ethernet/qlogic/qed/qed_main.c |  2 +-
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index d5fece7eb169..07ae600d0f35 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -436,6 +436,7 @@ struct qed_db_recovery_info {
 
 	/* Lock to protect the doorbell recovery mechanism list */
 	spinlock_t lock;
+	bool dorq_attn;
 	u32 db_recovery_counter;
 };
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.c b/drivers/net/ethernet/qlogic/qed/qed_int.c
index b994f81eb51c..00688f4c0464 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -436,17 +436,19 @@ static int qed_dorq_attn_cb(struct qed_hwfn *p_hwfn)
 	struct qed_ptt *p_ptt = p_hwfn->p_dpc_ptt;
 	int rc;
 
-	int_sts = qed_rd(p_hwfn, p_ptt, DORQ_REG_INT_STS);
-	DP_NOTICE(p_hwfn->cdev, "DORQ attention. int_sts was %x\n", int_sts);
+	p_hwfn->db_recovery_info.dorq_attn = true;
 
 	/* int_sts may be zero since all PFs were interrupted for doorbell
 	 * overflow but another one already handled it. Can abort here. If
 	 * This PF also requires overflow recovery we will be interrupted again.
 	 * The masked almost full indication may also be set. Ignoring.
 	 */
+	int_sts = qed_rd(p_hwfn, p_ptt, DORQ_REG_INT_STS);
 	if (!(int_sts & ~DORQ_REG_INT_STS_DORQ_FIFO_AFULL))
 		return 0;
 
+	DP_NOTICE(p_hwfn->cdev, "DORQ attention. int_sts was %x\n", int_sts);
+
 	/* check if db_drop or overflow happened */
 	if (int_sts & (DORQ_REG_INT_STS_DB_DROP |
 		       DORQ_REG_INT_STS_DORQ_FIFO_OVFL_ERR)) {
@@ -503,6 +505,17 @@ static int qed_dorq_attn_cb(struct qed_hwfn *p_hwfn)
 	return -EINVAL;
 }
 
+static void qed_dorq_attn_handler(struct qed_hwfn *p_hwfn)
+{
+	if (p_hwfn->db_recovery_info.dorq_attn)
+		goto out;
+
+	/* Call DORQ callback if the attention was missed */
+	qed_dorq_attn_cb(p_hwfn);
+out:
+	p_hwfn->db_recovery_info.dorq_attn = false;
+}
+
 /* Instead of major changes to the data-structure, we have a some 'special'
  * identifiers for sources that changed meaning between adapters.
  */
@@ -1076,6 +1089,9 @@ static int qed_int_deassertion(struct qed_hwfn  *p_hwfn,
 		}
 	}
 
+	/* Handle missed DORQ attention */
+	qed_dorq_attn_handler(p_hwfn);
+
 	/* Clear IGU indication for the deasserted bits */
 	DIRECT_REG_WR((u8 __iomem *)p_hwfn->regview +
 				    GTT_BAR0_MAP_REG_IGU_CMD +
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 6adf5bda9811..26bfcbeebc4c 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -966,7 +966,7 @@ static void qed_update_pf_params(struct qed_dev *cdev,
 	}
 }
 
-#define QED_PERIODIC_DB_REC_COUNT		100
+#define QED_PERIODIC_DB_REC_COUNT		10
 #define QED_PERIODIC_DB_REC_INTERVAL_MS		100
 #define QED_PERIODIC_DB_REC_INTERVAL \
 	msecs_to_jiffies(QED_PERIODIC_DB_REC_INTERVAL_MS)
-- 
2.20.1

