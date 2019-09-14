Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3AB4B298C
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 06:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbfINECI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 00:02:08 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44013 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfINECH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 00:02:07 -0400
Received: by mail-pf1-f196.google.com with SMTP id a2so256832pfo.10
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 21:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=d1cV/70zFbWV/eErqR3aG33G704p7yF9pn6kkXQUvlo=;
        b=EgA4UJAw8nlHA5SG+/U9q8eadGWFJwf0iVrOBa1HdMaRV2UZj7IG0hjMG0P8LrMcRf
         WVDUmoBsqA+pEgN0aQmGr0Kh/+GyrxR7/3rwcbMSZQOCqbIqwlo30kmXVePfk+1NZBqm
         BadCnpSLpr3LIEq7/ft2sxZ/QTHDpg7qMK6jY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=d1cV/70zFbWV/eErqR3aG33G704p7yF9pn6kkXQUvlo=;
        b=HChJcW7+fZflNvhtKBrZ9U1i+OtVtsVjWJbCSJZbf0iBbUs8KqEhPIjDYLDgISw56z
         G4uBdGzKTPuqkUuCzSJeKE9lBokYFBNbZ+mgBVzaSsXRywoLoleDM2QBq5ELUUjClxcn
         OX6tO1g0LJTZOZHyqJKxUDAAcL/3TfDmGLec9VKoAlYpID/83Hw+e/b/A4dcwdUIhmzp
         v4wxbmh9thnxPZCChBYp2nPvFbi+eUimHgPzYXykdAEJaDV2zClrWCyuRkT07qJAD5zs
         3TTASIPSD1zE+mo4yKwPSk7Xssk2wES7YI8GhydwAXxUvpClNC7/N1ZAW/WhvxetBdOx
         rgFQ==
X-Gm-Message-State: APjAAAVNeXMbsqOH2KvCkTY+FW20yVwprxPkG8Im7rP2HueL4O3EDzsa
        cFhIZhz4j7HcQEDYAOQRNhLZ8g==
X-Google-Smtp-Source: APXvYqw5gLMlWBTfnRSp8DyS/bGp50Jan7w5o/yWdUUAzujaJJlhrv95VUnl+YrDRVjpoGUMdCvrKw==
X-Received: by 2002:a62:1a4d:: with SMTP id a74mr24417027pfa.179.1568433726173;
        Fri, 13 Sep 2019 21:02:06 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a29sm52363908pfr.152.2019.09.13.21.02.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 21:02:05 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com
Subject: [PATCH net-next 4/4] bnxt_en: Add a new BNXT_FW_RESET_STATE_POLL_FW_DOWN state.
Date:   Sat, 14 Sep 2019 00:01:41 -0400
Message-Id: <1568433701-29000-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568433701-29000-1-git-send-email-michael.chan@broadcom.com>
References: <1568433701-29000-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

This new state is required when firmware indicates that the error
recovery process requires polling for firmware state to be completely
down before initiating reset.  For example, firmware may take some
time to collect the crash dump before it is down and ready to be
reset.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 48 +++++++++++++++++++++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  3 ++
 2 files changed, 46 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 58831dd..b4a8cf6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6947,6 +6947,8 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
 		bp->fw_cap |= BNXT_FW_CAP_EXT_STATS_SUPPORTED;
 	if (flags &  FUNC_QCAPS_RESP_FLAGS_ERROR_RECOVERY_CAPABLE)
 		bp->fw_cap |= BNXT_FW_CAP_ERROR_RECOVERY;
+	if (flags & FUNC_QCAPS_RESP_FLAGS_ERR_RECOVER_RELOAD)
+		bp->fw_cap |= BNXT_FW_CAP_ERR_RECOVER_RELOAD;
 
 	bp->tx_push_thresh = 0;
 	if (flags & FUNC_QCAPS_RESP_FLAGS_PUSH_MODE_SUPPORTED)
@@ -10097,6 +10099,8 @@ static void bnxt_force_fw_reset(struct bnxt *bp)
 		wait_dsecs = fw_health->normal_func_wait_dsecs;
 		bp->fw_reset_state = BNXT_FW_RESET_STATE_ENABLE_DEV;
 	}
+
+	bp->fw_reset_min_dsecs = fw_health->post_reset_wait_dsecs;
 	bp->fw_reset_max_dsecs = fw_health->post_reset_max_wait_dsecs;
 	bnxt_queue_fw_reset_work(bp, wait_dsecs * HZ / 10);
 }
@@ -10138,7 +10142,7 @@ void bnxt_fw_reset(struct bnxt *bp)
 	bnxt_rtnl_lock_sp(bp);
 	if (test_bit(BNXT_STATE_OPEN, &bp->state) &&
 	    !test_bit(BNXT_STATE_IN_FW_RESET, &bp->state)) {
-		int n = 0;
+		int n = 0, tmo;
 
 		set_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
 		if (bp->pf.active_vfs &&
@@ -10161,8 +10165,14 @@ void bnxt_fw_reset(struct bnxt *bp)
 			goto fw_reset_exit;
 		}
 		bnxt_fw_reset_close(bp);
-		bp->fw_reset_state = BNXT_FW_RESET_STATE_ENABLE_DEV;
-		bnxt_queue_fw_reset_work(bp, bp->fw_reset_min_dsecs * HZ / 10);
+		if (bp->fw_cap & BNXT_FW_CAP_ERR_RECOVER_RELOAD) {
+			bp->fw_reset_state = BNXT_FW_RESET_STATE_POLL_FW_DOWN;
+			tmo = HZ / 10;
+		} else {
+			bp->fw_reset_state = BNXT_FW_RESET_STATE_ENABLE_DEV;
+			tmo = bp->fw_reset_min_dsecs * HZ / 10;
+		}
+		bnxt_queue_fw_reset_work(bp, tmo);
 	}
 fw_reset_exit:
 	bnxt_rtnl_unlock_sp(bp);
@@ -10605,6 +10615,7 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 	switch (bp->fw_reset_state) {
 	case BNXT_FW_RESET_STATE_POLL_VF: {
 		int n = bnxt_get_registered_vfs(bp);
+		int tmo;
 
 		if (n < 0) {
 			netdev_err(bp->dev, "Firmware reset aborted, subsequent func_qcfg cmd failed, rc = %d, %d msecs since reset timestamp\n",
@@ -10626,11 +10637,38 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 		bp->fw_reset_timestamp = jiffies;
 		rtnl_lock();
 		bnxt_fw_reset_close(bp);
-		bp->fw_reset_state = BNXT_FW_RESET_STATE_ENABLE_DEV;
+		if (bp->fw_cap & BNXT_FW_CAP_ERR_RECOVER_RELOAD) {
+			bp->fw_reset_state = BNXT_FW_RESET_STATE_POLL_FW_DOWN;
+			tmo = HZ / 10;
+		} else {
+			bp->fw_reset_state = BNXT_FW_RESET_STATE_ENABLE_DEV;
+			tmo = bp->fw_reset_min_dsecs * HZ / 10;
+		}
 		rtnl_unlock();
-		bnxt_queue_fw_reset_work(bp, bp->fw_reset_min_dsecs * HZ / 10);
+		bnxt_queue_fw_reset_work(bp, tmo);
 		return;
 	}
+	case BNXT_FW_RESET_STATE_POLL_FW_DOWN: {
+		u32 val;
+
+		val = bnxt_fw_health_readl(bp, BNXT_FW_HEALTH_REG);
+		if (!(val & BNXT_FW_STATUS_SHUTDOWN) &&
+		    !time_after(jiffies, bp->fw_reset_timestamp +
+		    (bp->fw_reset_max_dsecs * HZ / 10))) {
+			bnxt_queue_fw_reset_work(bp, HZ / 5);
+			return;
+		}
+
+		if (!bp->fw_health->master) {
+			u32 wait_dsecs = bp->fw_health->normal_func_wait_dsecs;
+
+			bp->fw_reset_state = BNXT_FW_RESET_STATE_ENABLE_DEV;
+			bnxt_queue_fw_reset_work(bp, wait_dsecs * HZ / 10);
+			return;
+		}
+		bp->fw_reset_state = BNXT_FW_RESET_STATE_RESET_FW;
+	}
+	/* fall through */
 	case BNXT_FW_RESET_STATE_RESET_FW: {
 		u32 wait_dsecs = bp->fw_health->post_reset_wait_dsecs;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 42a8a75..d333589 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1398,6 +1398,7 @@ struct bnxt_fw_reporter_ctx {
 #define BNXT_FW_HEALTH_WIN_MAP_OFF	8
 
 #define BNXT_FW_STATUS_HEALTHY		0x8000
+#define BNXT_FW_STATUS_SHUTDOWN		0x100000
 
 struct bnxt {
 	void __iomem		*bar0;
@@ -1655,6 +1656,7 @@ struct bnxt {
 	#define BNXT_FW_CAP_CFA_RFS_RING_TBL_IDX	0x00010000
 	#define BNXT_FW_CAP_PCIE_STATS_SUPPORTED	0x00020000
 	#define BNXT_FW_CAP_EXT_STATS_SUPPORTED		0x00040000
+	#define BNXT_FW_CAP_ERR_RECOVER_RELOAD		0x00100000
 
 #define BNXT_NEW_RM(bp)		((bp)->fw_cap & BNXT_FW_CAP_NEW_RM)
 	u32			hwrm_spec_code;
@@ -1744,6 +1746,7 @@ struct bnxt {
 #define BNXT_FW_RESET_STATE_ENABLE_DEV	3
 #define BNXT_FW_RESET_STATE_POLL_FW	4
 #define BNXT_FW_RESET_STATE_OPENING	5
+#define BNXT_FW_RESET_STATE_POLL_FW_DOWN	6
 
 	u16			fw_reset_min_dsecs;
 #define BNXT_DFLT_FW_RST_MIN_DSECS	20
-- 
2.5.1

