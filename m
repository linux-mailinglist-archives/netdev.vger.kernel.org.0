Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24AC212B72E
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbfL0Rru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:47:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:43242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728470AbfL0Rox (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 12:44:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0D2520740;
        Fri, 27 Dec 2019 17:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468692;
        bh=k6QT/VGBgYhYTKy+MtjXvJgXYzPO5IhqpOqJKnhk06U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zVteVbBtxmYqnQJPjHqMLPjgI2TYRsa9lpBiKfwUIuiSOayTDWouk+7uruepKs3lH
         70VjEYM87S3jxbMZ5W2UjUqxJlGftEnlLwCDhoIpzlfKnzuPllrxEL9Og+pESkjkEO
         JU+l4NWn3TENVPM7gkzix2XGD+/s8Uhrxx5GAK/Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manish Chopra <manishc@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 49/84] bnx2x: Do not handle requests from VFs after parity
Date:   Fri, 27 Dec 2019 12:43:17 -0500
Message-Id: <20191227174352.6264-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174352.6264-1-sashal@kernel.org>
References: <20191227174352.6264-1-sashal@kernel.org>
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
index af57568c922e..df4f77ad95c4 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -9995,10 +9995,18 @@ static void bnx2x_recovery_failed(struct bnx2x *bp)
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
index eb814c65152f..4dc34de1a09a 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h
@@ -139,6 +139,7 @@ struct bnx2x_virtf {
 #define VF_ACQUIRED	1	/* VF acquired, but not initialized */
 #define VF_ENABLED	2	/* VF Enabled */
 #define VF_RESET	3	/* VF FLR'd, pending cleanup */
+#define VF_LOST		4	/* Recovery while VFs are loaded */
 
 	bool flr_clnup_stage;	/* true during flr cleanup */
 	bool malicious;		/* true if FW indicated so, until FLR */
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c
index 8e0a317b31f7..152758a45150 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c
@@ -2114,6 +2114,18 @@ static void bnx2x_vf_mbx_request(struct bnx2x *bp, struct bnx2x_virtf *vf,
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

