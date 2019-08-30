Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82C86A2DB3
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 05:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbfH3Dz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 23:55:58 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35318 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728149AbfH3Dzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 23:55:54 -0400
Received: by mail-pf1-f193.google.com with SMTP id 205so1206857pfw.2
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 20:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JI+MDIFGJevmmlRnNz3V980ISJWQvPg6cfCEu/LF6Qk=;
        b=U/AieImTjE2CdlYtyD0msfbwtdG7GkPgqJHv/nmnuHOrnpvfWzkFjZo3zlCu+T+K4g
         vwx/kFFkjr26AXQAEiHf8x1JZV23VxIJCEkiHKgNKe6QzuJb+fLgCqJdqR4lsJXlguKl
         KgPOH/ugqh0ejPxIZExoVn3KfWNSKEwOo565Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JI+MDIFGJevmmlRnNz3V980ISJWQvPg6cfCEu/LF6Qk=;
        b=Sj7HhsAE/YL8b60ChTBZKoxR/w6mlTqZC/oj2h3Ok4gqMrrc0d6CzkR8LScEliYnqg
         CD+XigZQSrQrB2mFStJeYUP2mV36raWFtWgoCYAGlOP/o1sbW6YqBD9c3MLAsTsFjklS
         yWfr0DGe8mdwGyyCZmdM+1ZslBWxoeRV2i75czbBXZx+xTzwDHjMntRBM1u+Bq6CVUeX
         6au7/xT7rB43nrtmRx8XeQFj15VD+RcVplpbjIu9OkC9s9MW3NS31jQlCvYaRYFTfa3X
         suYz0OBr2SBYzVYRC2Mem7XIq1TmYsL214nGY99buGGVHDnPnKuY7Y8AhVdcMVAxcHH7
         ftOQ==
X-Gm-Message-State: APjAAAUpuPzPmeolzWkGocHc+RYCJrdRCZxSN2JHlA+TsuZBPnR8gENg
        eIPO7fdidd8+zSMWXHi9lInUPA==
X-Google-Smtp-Source: APXvYqxlD3Ifbay7FID+3g6wu+RqJbKeK02DLCOO2nc8NIKSzWBuc+etGR/r+aPttNVkqO432N0uUg==
X-Received: by 2002:a65:4786:: with SMTP id e6mr11041095pgs.448.1567137353547;
        Thu, 29 Aug 2019 20:55:53 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l3sm3658877pjq.24.2019.08.29.20.55.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 20:55:53 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        ray.jui@broadcom.com, Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next v2 22/22] bnxt_en: Add FW fatal devlink_health_reporter.
Date:   Thu, 29 Aug 2019 23:55:05 -0400
Message-Id: <1567137305-5853-23-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
References: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Health show command example and output:

$ devlink health show pci/0000:af:00.0 reporter fw_fatal

pci/0000:af:00.0:
  name fw_fatal
    state healthy error 1 recover 1 grace_period 0 auto_recover true

Fatal events from firmware or missing periodic heartbeats will
be reported and recovery will be handled.

We also turn on the support flags when we register with the firmware to
enable this health and recovery feature in the firmware.

Cc: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 80 ++++++++++++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  7 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 56 ++++++++++++++++
 3 files changed, 141 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 5c7379e..f8a834f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1988,7 +1988,9 @@ static int bnxt_async_event_process(struct bnxt *bp,
 			goto async_event_process_exit;
 		set_bit(BNXT_RESET_TASK_SILENT_SP_EVENT, &bp->sp_event);
 		break;
-	case ASYNC_EVENT_CMPL_EVENT_ID_RESET_NOTIFY:
+	case ASYNC_EVENT_CMPL_EVENT_ID_RESET_NOTIFY: {
+		u32 data1 = le32_to_cpu(cmpl->event_data1);
+
 		bp->fw_reset_timestamp = jiffies;
 		bp->fw_reset_min_dsecs = cmpl->timestamp_lo;
 		if (!bp->fw_reset_min_dsecs)
@@ -1996,8 +1998,16 @@ static int bnxt_async_event_process(struct bnxt *bp,
 		bp->fw_reset_max_dsecs = le16_to_cpu(cmpl->timestamp_hi);
 		if (!bp->fw_reset_max_dsecs)
 			bp->fw_reset_max_dsecs = BNXT_DFLT_FW_RST_MAX_DSECS;
+		if (EVENT_DATA1_RESET_NOTIFY_FATAL(data1)) {
+			netdev_warn(bp->dev, "Firmware fatal reset event received\n");
+			set_bit(BNXT_STATE_FW_FATAL_COND, &bp->state);
+		} else {
+			netdev_warn(bp->dev, "Firmware non-fatal reset event received, max wait time %d msec\n",
+				    bp->fw_reset_max_dsecs * 100);
+		}
 		set_bit(BNXT_FW_RESET_NOTIFY_SP_EVENT, &bp->sp_event);
 		break;
+	}
 	case ASYNC_EVENT_CMPL_EVENT_ID_ERROR_RECOVERY: {
 		struct bnxt_fw_health *fw_health = bp->fw_health;
 		u32 data1 = le32_to_cpu(cmpl->event_data1);
@@ -4414,6 +4424,7 @@ static int bnxt_hwrm_func_drv_rgtr(struct bnxt *bp)
 {
 	struct hwrm_func_drv_rgtr_output *resp = bp->hwrm_cmd_resp_addr;
 	struct hwrm_func_drv_rgtr_input req = {0};
+	u32 flags;
 	int rc;
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_DRV_RGTR, -1, -1);
@@ -4423,7 +4434,11 @@ static int bnxt_hwrm_func_drv_rgtr(struct bnxt *bp)
 			    FUNC_DRV_RGTR_REQ_ENABLES_VER);
 
 	req.os_type = cpu_to_le16(FUNC_DRV_RGTR_REQ_OS_TYPE_LINUX);
-	req.flags = cpu_to_le32(FUNC_DRV_RGTR_REQ_FLAGS_16BIT_VER_MODE);
+	flags = FUNC_DRV_RGTR_REQ_FLAGS_16BIT_VER_MODE |
+		FUNC_DRV_RGTR_REQ_FLAGS_HOT_RESET_SUPPORT;
+	if (bp->fw_cap & BNXT_FW_CAP_ERROR_RECOVERY)
+		flags |= FUNC_DRV_RGTR_REQ_FLAGS_ERROR_RECOVERY_SUPPORT;
+	req.flags = cpu_to_le32(flags);
 	req.ver_maj_8b = DRV_VER_MAJ;
 	req.ver_min_8b = DRV_VER_MIN;
 	req.ver_upd_8b = DRV_VER_UPD;
@@ -9926,6 +9941,38 @@ static void bnxt_tx_timeout(struct net_device *dev)
 	bnxt_queue_sp_work(bp);
 }
 
+static void bnxt_fw_health_check(struct bnxt *bp)
+{
+	struct bnxt_fw_health *fw_health = bp->fw_health;
+	u32 val;
+
+	if (!fw_health || !fw_health->enabled ||
+	    test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
+		return;
+
+	if (fw_health->tmr_counter) {
+		fw_health->tmr_counter--;
+		return;
+	}
+
+	val = bnxt_fw_health_readl(bp, BNXT_FW_HEARTBEAT_REG);
+	if (val == fw_health->last_fw_heartbeat)
+		goto fw_reset;
+
+	fw_health->last_fw_heartbeat = val;
+
+	val = bnxt_fw_health_readl(bp, BNXT_FW_RESET_CNT_REG);
+	if (val != fw_health->last_fw_reset_cnt)
+		goto fw_reset;
+
+	fw_health->tmr_counter = fw_health->tmr_multiplier;
+	return;
+
+fw_reset:
+	set_bit(BNXT_FW_EXCEPTION_SP_EVENT, &bp->sp_event);
+	bnxt_queue_sp_work(bp);
+}
+
 static void bnxt_timer(struct timer_list *t)
 {
 	struct bnxt *bp = from_timer(bp, t, timer);
@@ -9937,6 +9984,9 @@ static void bnxt_timer(struct timer_list *t)
 	if (atomic_read(&bp->intr_sem) != 0)
 		goto bnxt_restart_timer;
 
+	if (bp->fw_cap & BNXT_FW_CAP_ERROR_RECOVERY)
+		bnxt_fw_health_check(bp);
+
 	if (bp->link_info.link_up && (bp->flags & BNXT_FLAG_PORT_STATS) &&
 	    bp->stats_coal_ticks) {
 		set_bit(BNXT_PERIODIC_STATS_SP_EVENT, &bp->sp_event);
@@ -10003,6 +10053,26 @@ static void bnxt_fw_reset_close(struct bnxt *bp)
 	bp->ctx = NULL;
 }
 
+static bool is_bnxt_fw_ok(struct bnxt *bp)
+{
+	struct bnxt_fw_health *fw_health = bp->fw_health;
+	bool no_heartbeat = false, has_reset = false;
+	u32 val;
+
+	val = bnxt_fw_health_readl(bp, BNXT_FW_HEARTBEAT_REG);
+	if (val == fw_health->last_fw_heartbeat)
+		no_heartbeat = true;
+
+	val = bnxt_fw_health_readl(bp, BNXT_FW_RESET_CNT_REG);
+	if (val != fw_health->last_fw_reset_cnt)
+		has_reset = true;
+
+	if (!no_heartbeat && has_reset)
+		return true;
+
+	return false;
+}
+
 /* rtnl_lock is acquired before calling this function */
 static void bnxt_force_fw_reset(struct bnxt *bp)
 {
@@ -10207,6 +10277,12 @@ static void bnxt_sp_task(struct work_struct *work)
 	if (test_and_clear_bit(BNXT_FW_RESET_NOTIFY_SP_EVENT, &bp->sp_event))
 		bnxt_devlink_health_report(bp, BNXT_FW_RESET_NOTIFY_SP_EVENT);
 
+	if (test_and_clear_bit(BNXT_FW_EXCEPTION_SP_EVENT, &bp->sp_event)) {
+		if (!is_bnxt_fw_ok(bp))
+			bnxt_devlink_health_report(bp,
+						   BNXT_FW_EXCEPTION_SP_EVENT);
+	}
+
 	smp_mb__before_atomic();
 	clear_bit(BNXT_STATE_IN_SP_TASK, &bp->state);
 }
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 3459b2a..333b0a8 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -472,6 +472,11 @@ struct rx_tpa_end_cmp_ext {
 	((le32_to_cpu((rx_tpa_end_ext)->rx_tpa_end_cmp_dup_acks) &	\
 	 RX_TPA_END_CMP_AGG_BUFS_P5) >> RX_TPA_END_CMP_AGG_BUFS_SHIFT_P5)
 
+#define EVENT_DATA1_RESET_NOTIFY_FATAL(data1)				\
+	(((data1) &							\
+	  ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_DATA1_REASON_CODE_MASK) ==\
+	 ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_DATA1_REASON_CODE_FW_EXCEPTION_FATAL)
+
 #define EVENT_DATA1_RECOVERY_MASTER_FUNC(data1)				\
 	!!((data1) &							\
 	   ASYNC_EVENT_CMPL_ERROR_RECOVERY_EVENT_DATA1_FLAGS_MASTER_FUNC)
@@ -1372,6 +1377,7 @@ struct bnxt_fw_health {
 	u32 fw_reset_seq_delay_msec[16];
 	struct devlink_health_reporter	*fw_reporter;
 	struct devlink_health_reporter *fw_reset_reporter;
+	struct devlink_health_reporter *fw_fatal_reporter;
 };
 
 struct bnxt_fw_reporter_ctx {
@@ -1728,6 +1734,7 @@ struct bnxt {
 #define BNXT_UPDATE_PHY_SP_EVENT	16
 #define BNXT_RING_COAL_NOW_SP_EVENT	17
 #define BNXT_FW_RESET_NOTIFY_SP_EVENT	18
+#define BNXT_FW_EXCEPTION_SP_EVENT	19
 
 	struct delayed_work	fw_reset_task;
 	int			fw_reset_state;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 8512467..e664392 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -83,6 +83,31 @@ struct devlink_health_reporter_ops bnxt_dl_fw_reset_reporter_ops = {
 	.recover = bnxt_fw_reset_recover,
 };
 
+static int bnxt_fw_fatal_recover(struct devlink_health_reporter *reporter,
+				 void *priv_ctx)
+{
+	struct bnxt *bp = devlink_health_reporter_priv(reporter);
+	struct bnxt_fw_reporter_ctx *fw_reporter_ctx = priv_ctx;
+	unsigned long event;
+
+	if (!priv_ctx)
+		return -EOPNOTSUPP;
+
+	event = fw_reporter_ctx->sp_event;
+	if (event == BNXT_FW_RESET_NOTIFY_SP_EVENT)
+		bnxt_fw_reset(bp);
+	else if (event == BNXT_FW_EXCEPTION_SP_EVENT)
+		bnxt_fw_exception(bp);
+
+	return 0;
+}
+
+static const
+struct devlink_health_reporter_ops bnxt_dl_fw_fatal_reporter_ops = {
+	.name = "fw_fatal",
+	.recover = bnxt_fw_fatal_recover,
+};
+
 static void bnxt_dl_fw_reporters_create(struct bnxt *bp)
 {
 	struct bnxt_fw_health *health = bp->fw_health;
@@ -108,6 +133,16 @@ static void bnxt_dl_fw_reporters_create(struct bnxt *bp)
 			    PTR_ERR(health->fw_reset_reporter));
 		health->fw_reset_reporter = NULL;
 	}
+
+	health->fw_fatal_reporter =
+		devlink_health_reporter_create(bp->dl,
+					       &bnxt_dl_fw_fatal_reporter_ops,
+					       0, true, bp);
+	if (IS_ERR(health->fw_fatal_reporter)) {
+		netdev_warn(bp->dev, "Failed to create FW fatal health reporter, rc = %ld\n",
+			    PTR_ERR(health->fw_fatal_reporter));
+		health->fw_fatal_reporter = NULL;
+	}
 }
 
 static void bnxt_dl_fw_reporters_destroy(struct bnxt *bp)
@@ -122,6 +157,9 @@ static void bnxt_dl_fw_reporters_destroy(struct bnxt *bp)
 
 	if (health->fw_reset_reporter)
 		devlink_health_reporter_destroy(health->fw_reset_reporter);
+
+	if (health->fw_fatal_reporter)
+		devlink_health_reporter_destroy(health->fw_fatal_reporter);
 }
 
 void bnxt_devlink_health_report(struct bnxt *bp, unsigned long event)
@@ -135,6 +173,15 @@ void bnxt_devlink_health_report(struct bnxt *bp, unsigned long event)
 	fw_reporter_ctx.sp_event = event;
 	switch (event) {
 	case BNXT_FW_RESET_NOTIFY_SP_EVENT:
+		if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state)) {
+			if (!fw_health->fw_fatal_reporter)
+				return;
+
+			devlink_health_report(fw_health->fw_fatal_reporter,
+					      "FW fatal async event received",
+					      &fw_reporter_ctx);
+			return;
+		}
 		if (!fw_health->fw_reset_reporter)
 			return;
 
@@ -142,6 +189,15 @@ void bnxt_devlink_health_report(struct bnxt *bp, unsigned long event)
 				      "FW non-fatal reset event received",
 				      &fw_reporter_ctx);
 		return;
+
+	case BNXT_FW_EXCEPTION_SP_EVENT:
+		if (!fw_health->fw_fatal_reporter)
+			return;
+
+		devlink_health_report(fw_health->fw_fatal_reporter,
+				      "FW fatal error reported",
+				      &fw_reporter_ctx);
+		return;
 	}
 }
 
-- 
2.5.1

