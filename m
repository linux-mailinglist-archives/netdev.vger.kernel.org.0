Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E14DA40CB
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 01:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbfH3XLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 19:11:03 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35982 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728143AbfH3XLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 19:11:03 -0400
Received: by mail-pl1-f193.google.com with SMTP id f19so4013316plr.3
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 16:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=EanwREuvJl8eN+WDxp0bUAkBBiPFu3Zem4kfy9myoqc=;
        b=YiesMVAE7cPjuB8NJpIbKi+hQnpgK+F2nv+jHFbOv+X1k4SW/ouS96ZaN+cJ3Pew3S
         FMbvMKAXqaLCzy8dmDBpozrzaP8fFI7k/7upiK5bATpEE1TUT+7AVgp5Jrp+bDTRHpo4
         MIlgUYDeNILZyE+V2nF4t6J6ZAKVuoupPQGDU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=EanwREuvJl8eN+WDxp0bUAkBBiPFu3Zem4kfy9myoqc=;
        b=FlBGcYzMp2hzD5NEfOZWG6N5RpfyK09O0Ra/geKOK5D8j2wVSeRLz6QnxpQp9ycLwi
         lnzkPyYuNhGG4rlkdtJ+JKa31WuMg7xb3k29+jCBKpnCG4sNIWH5pYR33om1JVV4hrbX
         ILpAAXO/ciMmXMhOOybGi392fu2KYKSsophloDsOoI4zTtYuQC7lRzwBAE3sejuHNxq3
         icOEy7M6YlF/L+m+0a3sS+ou+gRXJswWgmr6xLFekk21zqXzIHghIc+YNnsQ1Fb5SYq8
         SQPKBXrYzqO31dGYc+pIobSGtexTQtqJtO7DiWLUGYIRDxG/T3xyImrGv0MUJ8mKTLt8
         2jLw==
X-Gm-Message-State: APjAAAXkqr33E4NdrhI2DKfX3gP6BKKSJBKNDGmBIn7J2xjXKe0wjOHy
        kdCbemFvOsYc6Rs1XOXe99b46ugY1o0=
X-Google-Smtp-Source: APXvYqzKPC5E6FkqZSyA/tqwGVqyIDX8qk/u01n05SKJk4npzIBCZ7QjOopxZz4BwrWmgmBU5gxMxw==
X-Received: by 2002:a17:902:b70b:: with SMTP id d11mr10799775pls.238.1567206662420;
        Fri, 30 Aug 2019 16:11:02 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v67sm11300486pfb.45.2019.08.30.16.11.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 16:11:01 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, ray.jui@broadcom.com
Subject: [PATCH net-next] bnxt_en: Fix compile error regression with CONFIG_BNXT_SRIOV not set.
Date:   Fri, 30 Aug 2019 19:10:38 -0400
Message-Id: <1567206638-22674-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new function bnxt_get_registered_vfs() to handle the work
of getting the number of registered VFs under #ifdef CONFIG_BNXT_SRIOV.
The main code will call this function and will always work correctly
whether CONFIG_BNXT_SRIOV is set or not.

Fixes: 230d1f0de754 ("bnxt_en: Handle firmware reset.")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 82 ++++++++++++++++++++-----------
 1 file changed, 52 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f8a834f..402d9f5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10107,34 +10107,56 @@ void bnxt_fw_exception(struct bnxt *bp)
 	bnxt_rtnl_unlock_sp(bp);
 }
 
-void bnxt_fw_reset(struct bnxt *bp)
+/* Returns the number of registered VFs, or 1 if VF configuration is pending, or
+ * < 0 on error.
+ */
+static int bnxt_get_registered_vfs(struct bnxt *bp)
 {
+#ifdef CONFIG_BNXT_SRIOV
 	int rc;
 
+	if (!BNXT_PF(bp))
+		return 0;
+
+	rc = bnxt_hwrm_func_qcfg(bp);
+	if (rc) {
+		netdev_err(bp->dev, "func_qcfg cmd failed, rc = %d\n", rc);
+		return rc;
+	}
+	if (bp->pf.registered_vfs)
+		return bp->pf.registered_vfs;
+	if (bp->sriov_cfg)
+		return 1;
+#endif
+	return 0;
+}
+
+void bnxt_fw_reset(struct bnxt *bp)
+{
 	bnxt_rtnl_lock_sp(bp);
 	if (test_bit(BNXT_STATE_OPEN, &bp->state) &&
 	    !test_bit(BNXT_STATE_IN_FW_RESET, &bp->state)) {
+		int n = 0;
+
 		set_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
-		if (BNXT_PF(bp) && bp->pf.active_vfs &&
-		    !test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state)) {
-			rc = bnxt_hwrm_func_qcfg(bp);
-			if (rc) {
-				netdev_err(bp->dev, "Firmware reset aborted, first func_qcfg cmd failed, rc = %d\n",
-					   rc);
-				clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
-				dev_close(bp->dev);
-				goto fw_reset_exit;
-			}
-			if (bp->pf.registered_vfs || bp->sriov_cfg) {
-				u16 vf_tmo_dsecs = bp->pf.registered_vfs * 10;
-
-				if (bp->fw_reset_max_dsecs < vf_tmo_dsecs)
-					bp->fw_reset_max_dsecs = vf_tmo_dsecs;
-				bp->fw_reset_state =
-					BNXT_FW_RESET_STATE_POLL_VF;
-				bnxt_queue_fw_reset_work(bp, HZ / 10);
-				goto fw_reset_exit;
-			}
+		if (bp->pf.active_vfs &&
+		    !test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
+			n = bnxt_get_registered_vfs(bp);
+		if (n < 0) {
+			netdev_err(bp->dev, "Firmware reset aborted, rc = %d\n",
+				   n);
+			clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
+			dev_close(bp->dev);
+			goto fw_reset_exit;
+		} else if (n > 0) {
+			u16 vf_tmo_dsecs = n * 10;
+
+			if (bp->fw_reset_max_dsecs < vf_tmo_dsecs)
+				bp->fw_reset_max_dsecs = vf_tmo_dsecs;
+			bp->fw_reset_state =
+				BNXT_FW_RESET_STATE_POLL_VF;
+			bnxt_queue_fw_reset_work(bp, HZ / 10);
+			goto fw_reset_exit;
 		}
 		bnxt_fw_reset_close(bp);
 		bp->fw_reset_state = BNXT_FW_RESET_STATE_ENABLE_DEV;
@@ -10579,22 +10601,21 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 	}
 
 	switch (bp->fw_reset_state) {
-	case BNXT_FW_RESET_STATE_POLL_VF:
-		rc = bnxt_hwrm_func_qcfg(bp);
-		if (rc) {
+	case BNXT_FW_RESET_STATE_POLL_VF: {
+		int n = bnxt_get_registered_vfs(bp);
+
+		if (n < 0) {
 			netdev_err(bp->dev, "Firmware reset aborted, subsequent func_qcfg cmd failed, rc = %d, %d msecs since reset timestamp\n",
-				   rc, jiffies_to_msecs(jiffies -
+				   n, jiffies_to_msecs(jiffies -
 				   bp->fw_reset_timestamp));
 			goto fw_reset_abort;
-		}
-		if (bp->pf.registered_vfs || bp->sriov_cfg) {
+		} else if (n > 0) {
 			if (time_after(jiffies, bp->fw_reset_timestamp +
 				       (bp->fw_reset_max_dsecs * HZ / 10))) {
 				clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
 				bp->fw_reset_state = 0;
-				netdev_err(bp->dev, "Firmware reset aborted, %d VFs still registered, sriov_cfg %d\n",
-					   bp->pf.registered_vfs,
-					   bp->sriov_cfg);
+				netdev_err(bp->dev, "Firmware reset aborted, bnxt_get_registered_vfs() returns %d\n",
+					   n);
 				return;
 			}
 			bnxt_queue_fw_reset_work(bp, HZ / 10);
@@ -10607,6 +10628,7 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 		rtnl_unlock();
 		bnxt_queue_fw_reset_work(bp, bp->fw_reset_min_dsecs * HZ / 10);
 		return;
+	}
 	case BNXT_FW_RESET_STATE_RESET_FW: {
 		u32 wait_dsecs = bp->fw_health->post_reset_wait_dsecs;
 
-- 
2.5.1

