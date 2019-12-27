Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D37912BA2E
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 19:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbfL0SQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 13:16:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:41242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728178AbfL0SQG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 13:16:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C22021582;
        Fri, 27 Dec 2019 18:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577470566;
        bh=XeHyWWEnQOTi2O9lBiQmY2LxGna8vP21Mi46u6Rip+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ILR24doyNLkJc2uAeXoq+D7H43HdGJtYrBghqBVKnrWQBAg+8kB2oRoSZObExkTWn
         alD0bI5iqcaAfryd8gNAfpL7zoLK6Vk1jCOfXx5IZ4aHRYfX7snAksNClkWG+DUTx2
         uWStsuNsAn8+h9Cotjh2Ae4AXYcZzVzgYNCJl7x4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manish Chopra <manishc@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 13/25] bnx2x: Do not handle requests from VFs after parity
Date:   Fri, 27 Dec 2019 13:15:37 -0500
Message-Id: <20191227181549.8040-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227181549.8040-1-sashal@kernel.org>
References: <20191227181549.8040-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manish Chopra <manishc@marvell.com>

[ Upstream commit 7113f796bbbced2470cd6d7379d50d7a7a78bf34 ]

Parity error from the hardware will cause PF to lose the state
of their VFs due to PF's internal reload and hardware reset following
the parity error. Restrict any configuration request from the VFs after
the parity as it could cause unexpected hardware behavior, only way
for VFs to recover would be to trigger FLR on VFs and reload them.

Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 12 ++++++++++--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h |  1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c  | 12 ++++++++++++
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 82960603da33..026c72e62c18 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -9942,10 +9942,18 @@ static void bnx2x_recovery_failed(struct bnx2x *bp)
  */
 static void bnx2x_parity_recover(struct bnx2x *bp)
 {
-	bool global = false;
 	u32 error_recovered, error_unrecovered;
-	bool is_parity;
+	bool is_parity, global = false;
+#ifdef CONFIG_BNX2X_SRIOV
+	int vf_idx;
+
+	for (vf_idx = 0; vf_idx < bp->requested_nr_virtfn; vf_idx++) {
+		struct bnx2x_virtf *vf = BP_VF(bp, vf_idx);
 
+		if (vf)
+			vf->state = VF_LOST;
+	}
+#endif
 	DP(NETIF_MSG_HW, "Handling parity\n");
 	while (1) {
 		switch (bp->recovery_state) {
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h
index 6f6f13dc2be3..ab8339594cd3 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h
@@ -139,6 +139,7 @@ struct bnx2x_virtf {
 #define VF_ACQUIRED	1	/* VF acquired, but not initialized */
 #define VF_ENABLED	2	/* VF Enabled */
 #define VF_RESET	3	/* VF FLR'd, pending cleanup */
+#define VF_LOST		4	/* Recovery while VFs are loaded */
 
 	bool flr_clnup_stage;	/* true during flr cleanup */
 
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c
index a12a4236b143..e9fc3b09dba8 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c
@@ -2095,6 +2095,18 @@ static void bnx2x_vf_mbx_request(struct bnx2x *bp, struct bnx2x_virtf *vf,
 {
 	int i;
 
+	if (vf->state == VF_LOST) {
+		/* Just ack the FW and return if VFs are lost
+		 * in case of parity error. VFs are supposed to be timedout
+		 * on waiting for PF response.
+		 */
+		DP(BNX2X_MSG_IOV,
+		   "VF 0x%x lost, not handling the request\n", vf->abs_vfid);
+
+		storm_memset_vf_mbx_ack(bp, vf->abs_vfid);
+		return;
+	}
+
 	/* check if tlv type is known */
 	if (bnx2x_tlv_supported(mbx->first_tlv.tl.type)) {
 		/* Lock the per vf op mutex and note the locker's identity.
-- 
2.20.1

