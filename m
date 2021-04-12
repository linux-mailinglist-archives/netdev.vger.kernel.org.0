Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4D535B7BB
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 02:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236172AbhDLASm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 20:18:42 -0400
Received: from relay.smtp-ext.broadcom.com ([192.19.232.172]:60300 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235866AbhDLASg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 20:18:36 -0400
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 382B63CED8;
        Sun, 11 Apr 2021 17:18:19 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 382B63CED8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1618186699;
        bh=SNHNjgin9SadgJkjG6vruksg3XgYisQCXo+xnrRi8X8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CgAJlgHZxeu6Nyu60HY223aZU0Kfc2sbYJwjbnSUckzVYnP6o6RzOWG4k2yix5PFB
         kMAv3YB+OKz5bNREBI2ah7jfmEbdImI7ryTHtlm+0zT1+ERT4Rb1GhlVNkhDXpZFzP
         2ZmRxfgapeXU9Qn3U90Y3XzWkN8WZIAlzHOkCt74=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 5/5] bnxt_en: Free and allocate VF-Reps during error recovery.
Date:   Sun, 11 Apr 2021 20:18:15 -0400
Message-Id: <1618186695-18823-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1618186695-18823-1-git-send-email-michael.chan@broadcom.com>
References: <1618186695-18823-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>

During firmware recovery, VF-Rep configuration in the firmware is lost.
Fix it by freeing and (re)allocating VF-Reps in FW at relevant points
during the error recovery process.

Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  3 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c | 61 ++++++++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.h | 12 ++++
 3 files changed, 74 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 3f5fbdf61257..e15d454e33f0 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11081,6 +11081,7 @@ static void bnxt_fw_reset_close(struct bnxt *bp)
 		pci_disable_device(bp->pdev);
 	}
 	__bnxt_close_nic(bp, true, false);
+	bnxt_vf_reps_free(bp);
 	bnxt_clear_int_mode(bp);
 	bnxt_hwrm_func_drv_unrgtr(bp);
 	if (pci_is_enabled(bp->pdev))
@@ -11825,6 +11826,8 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 		bnxt_ulp_start(bp, rc);
 		if (!rc)
 			bnxt_reenable_sriov(bp);
+		bnxt_vf_reps_alloc(bp);
+		bnxt_vf_reps_open(bp);
 		bnxt_dl_health_recovery_done(bp);
 		bnxt_dl_health_status_update(bp, true);
 		rtnl_unlock();
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
index a4ac11f5b0e5..dd66302343a2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
@@ -284,8 +284,11 @@ void bnxt_vf_reps_open(struct bnxt *bp)
 	if (bp->eswitch_mode != DEVLINK_ESWITCH_MODE_SWITCHDEV)
 		return;
 
-	for (i = 0; i < pci_num_vf(bp->pdev); i++)
-		bnxt_vf_rep_open(bp->vf_reps[i]->dev);
+	for (i = 0; i < pci_num_vf(bp->pdev); i++) {
+		/* Open the VF-Rep only if it is allocated in the FW */
+		if (bp->vf_reps[i]->tx_cfa_action != CFA_HANDLE_INVALID)
+			bnxt_vf_rep_open(bp->vf_reps[i]->dev);
+	}
 }
 
 static void __bnxt_free_one_vf_rep(struct bnxt *bp, struct bnxt_vf_rep *vf_rep)
@@ -361,6 +364,23 @@ void bnxt_vf_reps_destroy(struct bnxt *bp)
 	__bnxt_vf_reps_destroy(bp);
 }
 
+/* Free the VF-Reps in firmware, during firmware hot-reset processing.
+ * Note that the VF-Rep netdevs are still active (not unregistered) during
+ * this process. As the mode transition from SWITCHDEV to LEGACY happens
+ * under the rtnl_lock() this routine is safe under the rtnl_lock().
+ */
+void bnxt_vf_reps_free(struct bnxt *bp)
+{
+	u16 num_vfs = pci_num_vf(bp->pdev);
+	int i;
+
+	if (bp->eswitch_mode != DEVLINK_ESWITCH_MODE_SWITCHDEV)
+		return;
+
+	for (i = 0; i < num_vfs; i++)
+		__bnxt_free_one_vf_rep(bp, bp->vf_reps[i]);
+}
+
 static int bnxt_alloc_vf_rep(struct bnxt *bp, struct bnxt_vf_rep *vf_rep,
 			     u16 *cfa_code_map)
 {
@@ -381,6 +401,43 @@ static int bnxt_alloc_vf_rep(struct bnxt *bp, struct bnxt_vf_rep *vf_rep,
 	return 0;
 }
 
+/* Allocate the VF-Reps in firmware, during firmware hot-reset processing.
+ * Note that the VF-Rep netdevs are still active (not unregistered) during
+ * this process. As the mode transition from SWITCHDEV to LEGACY happens
+ * under the rtnl_lock() this routine is safe under the rtnl_lock().
+ */
+int bnxt_vf_reps_alloc(struct bnxt *bp)
+{
+	u16 *cfa_code_map = bp->cfa_code_map, num_vfs = pci_num_vf(bp->pdev);
+	struct bnxt_vf_rep *vf_rep;
+	int rc, i;
+
+	if (bp->eswitch_mode != DEVLINK_ESWITCH_MODE_SWITCHDEV)
+		return 0;
+
+	if (!cfa_code_map)
+		return -EINVAL;
+
+	for (i = 0; i < MAX_CFA_CODE; i++)
+		cfa_code_map[i] = VF_IDX_INVALID;
+
+	for (i = 0; i < num_vfs; i++) {
+		vf_rep = bp->vf_reps[i];
+		vf_rep->vf_idx = i;
+
+		rc = bnxt_alloc_vf_rep(bp, vf_rep, cfa_code_map);
+		if (rc)
+			goto err;
+	}
+
+	return 0;
+
+err:
+	netdev_info(bp->dev, "%s error=%d\n", __func__, rc);
+	bnxt_vf_reps_free(bp);
+	return rc;
+}
+
 /* Use the OUI of the PF's perm addr and report the same mac addr
  * for the same VF-rep each time
  */
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.h
index d7287651422f..5637a84884d7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.h
@@ -19,6 +19,8 @@ void bnxt_vf_reps_close(struct bnxt *bp);
 void bnxt_vf_reps_open(struct bnxt *bp);
 void bnxt_vf_rep_rx(struct bnxt *bp, struct sk_buff *skb);
 struct net_device *bnxt_get_vf_rep(struct bnxt *bp, u16 cfa_code);
+int bnxt_vf_reps_alloc(struct bnxt *bp);
+void bnxt_vf_reps_free(struct bnxt *bp);
 
 static inline u16 bnxt_vf_rep_get_fid(struct net_device *dev)
 {
@@ -61,5 +63,15 @@ static inline bool bnxt_dev_is_vf_rep(struct net_device *dev)
 {
 	return false;
 }
+
+static inline int bnxt_vf_reps_alloc(struct bnxt *bp)
+{
+	return 0;
+}
+
+static inline void bnxt_vf_reps_free(struct bnxt *bp)
+{
+}
+
 #endif /* CONFIG_BNXT_SRIOV */
 #endif /* BNXT_VFR_H */
-- 
2.18.1

