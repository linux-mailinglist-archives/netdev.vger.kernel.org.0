Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33BA2E9783
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 09:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbfJ3IAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 04:00:10 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33404 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbfJ3IAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 04:00:09 -0400
Received: by mail-pf1-f193.google.com with SMTP id c184so1042926pfb.0
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 01:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5Lql2iZU3HJneLpJxjvzwtLgN82SXVDbWro54Bpzot0=;
        b=OyKGhBi0Gaakf3SuNPbm60lKuss3sicvp7Hx4gzg40OUomo2Dr0L6jp2lsnlwuvjAA
         iiKYGS/pDmBrd1aSRcaQdKUxQLI75x6FarpV2meLZ0t8zRrxwGTTV7mPiCwgh/GJhqGj
         it6CqHyz6kY/h2zoJcBle+cBSK++Dvjv2KqxI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5Lql2iZU3HJneLpJxjvzwtLgN82SXVDbWro54Bpzot0=;
        b=OAa3I21zYO1sbIlrNWjdXmZ5s5KcByGtyNSKy4/+tLI76ui0uHwajAm7thh5C9r3Dd
         4UWnQlt4n1jnlZ6mjYEX439H00vdf4q3c9bVFZXUjqE87GJw4Z0BDrgiUpkjWza+uM9o
         ve7sGIo7C1U1dD85KLykQtoSd6Yg6NcT82TyFPxX2lfoLBikDf4GgKXj6SmdvvADpSZ3
         h6FbcaxBz2iVlypch/LU0uzEC0/7nxkopaCipvMwPfvPafBQRBuJcqf/bAoO9MkP/4PE
         VcoFqQXhNCfAgZ497Fv6hNChSFxNBoLVvf09crLAz7JLkFTzBrWlK3pkc3mKUMbuAWED
         v89g==
X-Gm-Message-State: APjAAAXJVp622/l0OYQxK1FNP8KKwTJ3AYvpHcFvEA5MkBGICZ0916Kn
        h6uX1IYWXtn1tuutFLVZk+bqHg==
X-Google-Smtp-Source: APXvYqyIuHOmxWf77A1OBgucsNZNum0po/8uL5XgGObf00qvOKPYo7nYpT+51giHQ0GgVhePbQe6Jw==
X-Received: by 2002:a17:90a:e383:: with SMTP id b3mr12275226pjz.119.1572422408602;
        Wed, 30 Oct 2019 01:00:08 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r21sm1960649pfc.27.2019.10.30.01.00.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Oct 2019 01:00:08 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next 6/7] bnxt_en: Call bnxt_ulp_stop()/bnxt_ulp_start() during error recovery.
Date:   Wed, 30 Oct 2019 03:59:34 -0400
Message-Id: <1572422375-7269-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1572422375-7269-1-git-send-email-michael.chan@broadcom.com>
References: <1572422375-7269-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Notify the RDMA driver by calling the bnxt_ulp_stop()/bnxt_ulp_start()
hooks during error recovery.  The current ULP IRQ start/stop
sequence in error recovery (which is insufficient) is replaced with the
full reset sequence when we call bnxt_ulp_stop()/bnxt_ulp_start().

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index df843f2..e7524c0 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8762,6 +8762,8 @@ static int bnxt_hwrm_if_change(struct bnxt *bp, bool up)
 	}
 	if (resc_reinit || fw_reset) {
 		if (fw_reset) {
+			if (!test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
+				bnxt_ulp_stop(bp);
 			rc = bnxt_fw_init_one(bp);
 			if (rc) {
 				set_bit(BNXT_STATE_ABORT_ERR, &bp->state);
@@ -9224,13 +9226,16 @@ static int bnxt_open(struct net_device *dev)
 	if (rc) {
 		bnxt_hwrm_if_change(bp, false);
 	} else {
-		if (test_and_clear_bit(BNXT_STATE_FW_RESET_DET, &bp->state) &&
-		    BNXT_PF(bp)) {
-			struct bnxt_pf_info *pf = &bp->pf;
-			int n = pf->active_vfs;
+		if (test_and_clear_bit(BNXT_STATE_FW_RESET_DET, &bp->state)) {
+			if (BNXT_PF(bp)) {
+				struct bnxt_pf_info *pf = &bp->pf;
+				int n = pf->active_vfs;
 
-			if (n)
-				bnxt_cfg_hw_sriov(bp, &n, true);
+				if (n)
+					bnxt_cfg_hw_sriov(bp, &n, true);
+			}
+			if (!test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
+				bnxt_ulp_start(bp, 0);
 		}
 		bnxt_hwmon_open(bp);
 	}
@@ -10051,8 +10056,8 @@ static void bnxt_reset(struct bnxt *bp, bool silent)
 
 static void bnxt_fw_reset_close(struct bnxt *bp)
 {
+	bnxt_ulp_stop(bp);
 	__bnxt_close_nic(bp, true, false);
-	bnxt_ulp_irq_stop(bp);
 	bnxt_clear_int_mode(bp);
 	bnxt_hwrm_func_drv_unrgtr(bp);
 	bnxt_free_ctx_mem(bp);
@@ -10725,13 +10730,13 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 			clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
 			dev_close(bp->dev);
 		}
-		bnxt_ulp_irq_restart(bp, rc);
-		rtnl_unlock();
 
 		bp->fw_reset_state = 0;
 		/* Make sure fw_reset_state is 0 before clearing the flag */
 		smp_mb__before_atomic();
 		clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
+		bnxt_ulp_start(bp, rc);
+		rtnl_unlock();
 		break;
 	}
 	return;
-- 
2.5.1

