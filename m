Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABAEA107DB7
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 09:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbfKWI0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 03:26:35 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:40475 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfKWI0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 03:26:34 -0500
Received: by mail-pj1-f68.google.com with SMTP id ep1so4214160pjb.7
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 00:26:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZK4KKA9nDvDaTY2ckZFa/7j2drSXAcZutcpq4qw/axE=;
        b=ficNAbE8BY8OsKfsrJVVvu7KyJcfcwJ8O7/QvU6CEC4OXz9DhzQYWut7D7Up3EmsoB
         cULQo/Qwz3y5QuAo+WcCrvMJ5rK58nnmUZIOj/DDOfxw887SkUbUu4bt6UB1wAiuk1qS
         qNGBZnJOi4t2/9sjSzG3UqhmQ/163sIKH8FJA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZK4KKA9nDvDaTY2ckZFa/7j2drSXAcZutcpq4qw/axE=;
        b=c04Ga3vx1xIixMJg/1JVECRWYh1ssHoHG5Ba9ElDczqX5sszEAcFuWX2BCkVMRZM4z
         n/Ql+EpsT5t/s6MmwpkLaOtUbhwTDEzGWYtEVjhe2tqOgcOSEUzn63QJ/NXubLFhoLxN
         E7DvbqC1XuIkmS+TM01xVef0Ygf5KlrtmUhE9l/EERtENhydEgUWK9Vn89Cu1A4ndCwc
         9QNeB+LsQHhx+ZH1ksKmMQ1Fln/D2ok9OV3W2mOVcsScyGCbX8qT/QvENHcWrivuqk1i
         cLY4ry1Q3XFpB5tc9fp4Ti2X7jdkR01VuLVWo0avG5nm5d80TkR2VBLcWgA7tKTUu01d
         uiiA==
X-Gm-Message-State: APjAAAUugbvjr22Y/JjIJQHT+x1CRRNiH8h0irAIXvSYGQMrOZvpvKSm
        F1KuDShG0oE2qYIYCtJenDOweA==
X-Google-Smtp-Source: APXvYqyQsjlRBKhHMSfMJCsZ8sBwvmI0hHJGgl+OPVgQDhDTXc1AfnvvV7/+YcxpJ82ie/HNRP5xyw==
X-Received: by 2002:a17:902:8c90:: with SMTP id t16mr259776plo.230.1574497592101;
        Sat, 23 Nov 2019 00:26:32 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p16sm573236pfn.171.2019.11.23.00.26.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Nov 2019 00:26:31 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next 04/15] bnxt_en: Combine 2 functions calling the same HWRM_DRV_RGTR fw command.
Date:   Sat, 23 Nov 2019 03:25:59 -0500
Message-Id: <1574497570-22102-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574497570-22102-1-git-send-email-michael.chan@broadcom.com>
References: <1574497570-22102-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Everytime driver registers with firmware, driver is required to
register for async event notifications as well. These 2 calls
are done using the same firmware command and can be combined.

We are also missing the 2nd step to register for async events
in the suspend/resume path and this will fix it.  Prior to this,
we were getting only default notifications.

ULP can register for additional async events for the RDMA driver,
so we add a parameter to the new function to only do step 2 when
it is called from ULP.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 74 +++++++++++----------------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c |  4 +-
 3 files changed, 35 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 464e8bd..f627741 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4394,53 +4394,22 @@ int hwrm_send_message_silent(struct bnxt *bp, void *msg, u32 msg_len,
 	return rc;
 }
 
-int bnxt_hwrm_func_rgtr_async_events(struct bnxt *bp, unsigned long *bmap,
-				     int bmap_size)
+int bnxt_hwrm_func_drv_rgtr(struct bnxt *bp, unsigned long *bmap, int bmap_size,
+			    bool async_only)
 {
+	struct hwrm_func_drv_rgtr_output *resp = bp->hwrm_cmd_resp_addr;
 	struct hwrm_func_drv_rgtr_input req = {0};
 	DECLARE_BITMAP(async_events_bmap, 256);
 	u32 *events = (u32 *)async_events_bmap;
-	int i;
-
-	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_DRV_RGTR, -1, -1);
-
-	req.enables =
-		cpu_to_le32(FUNC_DRV_RGTR_REQ_ENABLES_ASYNC_EVENT_FWD);
-
-	memset(async_events_bmap, 0, sizeof(async_events_bmap));
-	for (i = 0; i < ARRAY_SIZE(bnxt_async_events_arr); i++) {
-		u16 event_id = bnxt_async_events_arr[i];
-
-		if (event_id == ASYNC_EVENT_CMPL_EVENT_ID_ERROR_RECOVERY &&
-		    !(bp->fw_cap & BNXT_FW_CAP_ERROR_RECOVERY))
-			continue;
-		__set_bit(bnxt_async_events_arr[i], async_events_bmap);
-	}
-	if (bmap && bmap_size) {
-		for (i = 0; i < bmap_size; i++) {
-			if (test_bit(i, bmap))
-				__set_bit(i, async_events_bmap);
-		}
-	}
-
-	for (i = 0; i < 8; i++)
-		req.async_event_fwd[i] |= cpu_to_le32(events[i]);
-
-	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-}
-
-static int bnxt_hwrm_func_drv_rgtr(struct bnxt *bp)
-{
-	struct hwrm_func_drv_rgtr_output *resp = bp->hwrm_cmd_resp_addr;
-	struct hwrm_func_drv_rgtr_input req = {0};
 	u32 flags;
-	int rc;
+	int rc, i;
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_DRV_RGTR, -1, -1);
 
 	req.enables =
 		cpu_to_le32(FUNC_DRV_RGTR_REQ_ENABLES_OS_TYPE |
-			    FUNC_DRV_RGTR_REQ_ENABLES_VER);
+			    FUNC_DRV_RGTR_REQ_ENABLES_VER |
+			    FUNC_DRV_RGTR_REQ_ENABLES_ASYNC_EVENT_FWD);
 
 	req.os_type = cpu_to_le16(FUNC_DRV_RGTR_REQ_OS_TYPE_LINUX);
 	flags = FUNC_DRV_RGTR_REQ_FLAGS_16BIT_VER_MODE |
@@ -4481,6 +4450,28 @@ static int bnxt_hwrm_func_drv_rgtr(struct bnxt *bp)
 		req.flags |= cpu_to_le32(
 			FUNC_DRV_RGTR_REQ_FLAGS_FLOW_HANDLE_64BIT_MODE);
 
+	memset(async_events_bmap, 0, sizeof(async_events_bmap));
+	for (i = 0; i < ARRAY_SIZE(bnxt_async_events_arr); i++) {
+		u16 event_id = bnxt_async_events_arr[i];
+
+		if (event_id == ASYNC_EVENT_CMPL_EVENT_ID_ERROR_RECOVERY &&
+		    !(bp->fw_cap & BNXT_FW_CAP_ERROR_RECOVERY))
+			continue;
+		__set_bit(bnxt_async_events_arr[i], async_events_bmap);
+	}
+	if (bmap && bmap_size) {
+		for (i = 0; i < bmap_size; i++) {
+			if (test_bit(i, bmap))
+				__set_bit(i, async_events_bmap);
+		}
+	}
+	for (i = 0; i < 8; i++)
+		req.async_event_fwd[i] |= cpu_to_le32(events[i]);
+
+	if (async_only)
+		req.enables =
+			cpu_to_le32(FUNC_DRV_RGTR_REQ_ENABLES_ASYNC_EVENT_FWD);
+
 	mutex_lock(&bp->hwrm_cmd_lock);
 	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 	if (!rc) {
@@ -10490,11 +10481,7 @@ static int bnxt_fw_init_one_p2(struct bnxt *bp)
 		netdev_warn(bp->dev, "hwrm query error recovery failure rc: %d\n",
 			    rc);
 
-	rc = bnxt_hwrm_func_drv_rgtr(bp);
-	if (rc)
-		return -ENODEV;
-
-	rc = bnxt_hwrm_func_rgtr_async_events(bp, NULL, 0);
+	rc = bnxt_hwrm_func_drv_rgtr(bp, NULL, 0, false);
 	if (rc)
 		return -ENODEV;
 
@@ -11947,7 +11934,8 @@ static int bnxt_resume(struct device *device)
 		goto resume_exit;
 	}
 	pci_set_master(bp->pdev);
-	if (bnxt_hwrm_ver_get(bp) || bnxt_hwrm_func_drv_rgtr(bp)) {
+	if (bnxt_hwrm_ver_get(bp) ||
+	    bnxt_hwrm_func_drv_rgtr(bp, NULL, 0, false)) {
 		rc = -ENODEV;
 		goto resume_exit;
 	}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index a38664eef..35c483b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1996,8 +1996,8 @@ int _hwrm_send_message(struct bnxt *, void *, u32, int);
 int _hwrm_send_message_silent(struct bnxt *bp, void *msg, u32 len, int timeout);
 int hwrm_send_message(struct bnxt *, void *, u32, int);
 int hwrm_send_message_silent(struct bnxt *, void *, u32, int);
-int bnxt_hwrm_func_rgtr_async_events(struct bnxt *bp, unsigned long *bmap,
-				     int bmap_size);
+int bnxt_hwrm_func_drv_rgtr(struct bnxt *bp, unsigned long *bmap,
+			    int bmap_size, bool async_only);
 int bnxt_hwrm_vnic_cfg(struct bnxt *bp, u16 vnic_id);
 int __bnxt_hwrm_get_tx_rings(struct bnxt *bp, u16 fid, int *tx_rings);
 int bnxt_nq_rings_in_use(struct bnxt *bp);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index 077fd10..c601ff7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -81,7 +81,7 @@ static int bnxt_unregister_dev(struct bnxt_en_dev *edev, int ulp_id)
 		edev->en_ops->bnxt_free_msix(edev, ulp_id);
 
 	if (ulp->max_async_event_id)
-		bnxt_hwrm_func_rgtr_async_events(bp, NULL, 0);
+		bnxt_hwrm_func_drv_rgtr(bp, NULL, 0, true);
 
 	RCU_INIT_POINTER(ulp->ulp_ops, NULL);
 	synchronize_rcu();
@@ -441,7 +441,7 @@ static int bnxt_register_async_events(struct bnxt_en_dev *edev, int ulp_id,
 	/* Make sure bnxt_ulp_async_events() sees this order */
 	smp_wmb();
 	ulp->max_async_event_id = max_id;
-	bnxt_hwrm_func_rgtr_async_events(bp, events_bmap, max_id + 1);
+	bnxt_hwrm_func_drv_rgtr(bp, events_bmap, max_id + 1, true);
 	return 0;
 }
 
-- 
2.5.1

