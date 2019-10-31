Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEFD4EAA0B
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 06:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfJaFIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 01:08:25 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36818 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726823AbfJaFIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 01:08:24 -0400
Received: by mail-pl1-f195.google.com with SMTP id g9so2125370plp.3
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 22:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5Lql2iZU3HJneLpJxjvzwtLgN82SXVDbWro54Bpzot0=;
        b=IgNvrJh9Ej6WEDfbnSjGyrT3gDTR3YUWQKhAl8a4YHyCOBwLWJV6oE3qbq78xOZQMi
         vXp8jNA56aA6HsGy19/NKC9jPHn+NRU0pli1MTqO4Go8Uq0h5vpMGHK+RvzJ3SRCgfOS
         P1jsLWsx4gdbV1MDuxnQJngacww53icTV0AFs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5Lql2iZU3HJneLpJxjvzwtLgN82SXVDbWro54Bpzot0=;
        b=rlP2h/dqhOh6BFnQBkfxWh3LYwE4w1+lm5Tyk1cHhY2AEL//QjcUMeElk2ZpGTEWos
         GK6WMPSMV/pJnI5xgOUL/YaspUcKWbiNvgkMZlBjbmrNiJyBCWls1bGVy+4MsRoTt6fU
         l3rIgxvClTNchauo8KG5ha7wGr94GHAv4yaSfWEGG4FbiLOV5Fe2B/BAJcpn5VRxNAyp
         VdvkVFtMx04iPUeoYAQnhoCnhoQ6oT9fpFw+9MzFImdxIMRq8ctdqBEsKmtASEopJWNH
         No4JrdaiWeyKo/9fWV+4kBJVBMPrJbKVT2hFcqH7XxpXYIbJ8UD0ZHq1M+j4dUwkiJ7X
         d+ZA==
X-Gm-Message-State: APjAAAX5iMjC02VJlBb2cJWNLWw8azvQskx7I9ceNnST6WfcRumZGoqb
        3zQDE+4fzgDbon1H/HtqDCzWvw==
X-Google-Smtp-Source: APXvYqxLoqq+fB3CzheLIWJKXqCq1uU6Mzc8uUYLYfuWcMPjTlXp7rWRBc6+B7hE03W8JHr9o0ciFA==
X-Received: by 2002:a17:902:d70b:: with SMTP id w11mr4276802ply.128.1572498503933;
        Wed, 30 Oct 2019 22:08:23 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a8sm1690899pff.5.2019.10.30.22.08.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Oct 2019 22:08:23 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next v2 6/7] bnxt_en: Call bnxt_ulp_stop()/bnxt_ulp_start() during error recovery.
Date:   Thu, 31 Oct 2019 01:07:50 -0400
Message-Id: <1572498471-31550-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1572498471-31550-1-git-send-email-michael.chan@broadcom.com>
References: <1572498471-31550-1-git-send-email-michael.chan@broadcom.com>
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

