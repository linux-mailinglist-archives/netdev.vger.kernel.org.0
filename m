Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2F19C81E
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 05:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729659AbfHZD4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 23:56:09 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36603 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729638AbfHZD4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 23:56:07 -0400
Received: by mail-pf1-f196.google.com with SMTP id w2so10876198pfi.3
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 20:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=F9EuZ9dNR2GoDEBrjHeU887tMhklvFodmihiA0xnCJY=;
        b=S2X+tepXw070ezfMC59TgsfNfVxoKQde1/owYtIOLyse7rgdpvu5yISEvU79lkhX3P
         bGJqZipxMLwGrAWiU/Rn1OddnOMFOCC5XTwlteGSDN8CvowjS4VrlBONMQ1K80c7G+cJ
         y2DACDQ2WSpXWa7SwxXYZRT/NGkLYudHJ1tJE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=F9EuZ9dNR2GoDEBrjHeU887tMhklvFodmihiA0xnCJY=;
        b=iKyVVb4RmmEgaExvKFQFnmevp8KIdqeoZwhj+2wjslXbDsmYBN5Ba4rjzUlJrdE5BO
         Pcg6nBFy7z6q7kVLDWK/Y+sn+x97uq5wL10P8px7zfIVgZH6g09MrDwsHW6CCMgVNYGA
         1XiU6t11cY53/Qf+18g5q/zhsz9EFGzrUYNUqve4u2pn5smb23rQWJAXt8qpKlQQk8Zy
         Ht2didzYoyEDSsmpq+7WYVaS+ue80c6vsrigFhOPH93fUl4UASF03+GvIhUKFz1TRnPi
         MzWwR7CNX/3q6W0I39oZdeDL/VF+c+3SmTbMhE9ILIaLL1lMOj0m89/arRMOZo1xcIj2
         zHnw==
X-Gm-Message-State: APjAAAU5T2ukH5Qi3QpB38e5Qve7h6kOFa6gbS2sRE5rIYYLpBiKhKsC
        qyLsE6ZRopP1+e65WicQ4IzITw==
X-Google-Smtp-Source: APXvYqxyKoyUT+Sz2mlXdbFElk8agNJ3D/QUg2MYeYnprIrqu+4ljkPoyT2yCowgvHV12UBECnWXtQ==
X-Received: by 2002:a17:90a:358a:: with SMTP id r10mr18140148pjb.30.1566791765951;
        Sun, 25 Aug 2019 20:56:05 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d6sm8532975pgf.55.2019.08.25.20.56.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Aug 2019 20:56:05 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        jiri@mellanox.com, ray.jui@broadcom.com
Subject: [PATCH net-next 14/14] bnxt_en: Add FW fatal devlink_health_reporter
Date:   Sun, 25 Aug 2019 23:55:05 -0400
Message-Id: <1566791705-20473-15-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
References: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
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

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 125 +++++++++++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |   8 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c |  56 ++++++++++
 3 files changed, 186 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 1687a1a..d338f5b 100644
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
 			bp->fw_reset_max_dsecs = 60;
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
@@ -4390,6 +4400,7 @@ static int bnxt_hwrm_func_drv_rgtr(struct bnxt *bp)
 {
 	struct hwrm_func_drv_rgtr_output *resp = bp->hwrm_cmd_resp_addr;
 	struct hwrm_func_drv_rgtr_input req = {0};
+	u32 flags;
 	int rc;
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_DRV_RGTR, -1, -1);
@@ -4399,8 +4410,11 @@ static int bnxt_hwrm_func_drv_rgtr(struct bnxt *bp)
 			    FUNC_DRV_RGTR_REQ_ENABLES_VER);
 
 	req.os_type = cpu_to_le16(FUNC_DRV_RGTR_REQ_OS_TYPE_LINUX);
-	req.flags = cpu_to_le32(FUNC_DRV_RGTR_REQ_FLAGS_16BIT_VER_MODE |
-				FUNC_DRV_RGTR_REQ_FLAGS_HOT_RESET_SUPPORT);
+	flags = FUNC_DRV_RGTR_REQ_FLAGS_16BIT_VER_MODE |
+		FUNC_DRV_RGTR_REQ_FLAGS_HOT_RESET_SUPPORT;
+	if (bp->fw_cap & BNXT_FW_CAP_ERROR_RECOVERY)
+		flags |= FUNC_DRV_RGTR_REQ_FLAGS_ERROR_RECOVERY_SUPPORT;
+	req.flags = cpu_to_le32(flags);
 	req.ver_maj_8b = DRV_VER_MAJ;
 	req.ver_min_8b = DRV_VER_MIN;
 	req.ver_upd_8b = DRV_VER_UPD;
@@ -9913,6 +9927,38 @@ static void bnxt_tx_timeout(struct net_device *dev)
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
@@ -9924,6 +9970,9 @@ static void bnxt_timer(struct timer_list *t)
 	if (atomic_read(&bp->intr_sem) != 0)
 		goto bnxt_restart_timer;
 
+	if (bp->fw_cap & BNXT_FW_CAP_ERROR_RECOVERY)
+		bnxt_fw_health_check(bp);
+
 	if (bp->link_info.link_up && (bp->flags & BNXT_FLAG_PORT_STATS) &&
 	    bp->stats_coal_ticks) {
 		set_bit(BNXT_PERIODIC_STATS_SP_EVENT, &bp->sp_event);
@@ -9990,6 +10039,60 @@ static void bnxt_fw_reset_close(struct bnxt *bp)
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
+/* rtnl_lock is acquired before calling this function */
+static void bnxt_force_fw_reset(struct bnxt *bp)
+{
+	struct bnxt_fw_health *fw_health = bp->fw_health;
+	u32 wait_dsecs;
+
+	if (!test_bit(BNXT_STATE_OPEN, &bp->state) ||
+	    test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
+		return;
+
+	set_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
+	bnxt_fw_reset_close(bp);
+	wait_dsecs = fw_health->master_func_wait_dsecs;
+	if (fw_health->master) {
+		if (fw_health->flags & ERROR_RECOVERY_QCFG_RESP_FLAGS_CO_CPU)
+			wait_dsecs = 0;
+		bp->fw_reset_state = BNXT_FW_RESET_STATE_RESET_FW;
+	} else {
+		bp->fw_reset_timestamp = jiffies + wait_dsecs * HZ / 10;
+		wait_dsecs = fw_health->normal_func_wait_dsecs;
+		bp->fw_reset_state = BNXT_FW_RESET_STATE_ENABLE_DEV;
+	}
+	bp->fw_reset_max_dsecs = fw_health->post_reset_max_wait_dsecs;
+	bnxt_queue_fw_reset_work(bp, wait_dsecs * HZ / 10);
+}
+
+void bnxt_fw_exception(struct bnxt *bp)
+{
+	set_bit(BNXT_STATE_FW_FATAL_COND, &bp->state);
+	bnxt_rtnl_lock_sp(bp);
+	bnxt_force_fw_reset(bp);
+	bnxt_rtnl_unlock_sp(bp);
+}
+
 void bnxt_fw_reset(struct bnxt *bp)
 {
 	int rc;
@@ -10160,6 +10263,12 @@ static void bnxt_sp_task(struct work_struct *work)
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
@@ -10492,6 +10601,16 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 		return;
 	}
 	case BNXT_FW_RESET_STATE_ENABLE_DEV:
+		if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state) &&
+		    bp->fw_health) {
+			u32 val;
+
+			val = bnxt_fw_health_readl(bp,
+						   BNXT_FW_RESET_INPROG_REG);
+			if (val)
+				netdev_warn(bp->dev, "FW reset inprog %x after min wait time.\n",
+					    val);
+		}
 		clear_bit(BNXT_STATE_FW_FATAL_COND, &bp->state);
 		if (pci_enable_device(bp->pdev)) {
 			netdev_err(bp->dev, "Cannot re-enable PCI device\n");
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 078900a..1710405 100644
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
@@ -1979,6 +1986,7 @@ int bnxt_open_nic(struct bnxt *, bool, bool);
 int bnxt_half_open_nic(struct bnxt *bp);
 void bnxt_half_close_nic(struct bnxt *bp);
 int bnxt_close_nic(struct bnxt *, bool, bool);
+void bnxt_fw_exception(struct bnxt *bp);
 void bnxt_fw_reset(struct bnxt *bp);
 int bnxt_check_rings(struct bnxt *bp, int tx, int rx, bool sh, int tcs,
 		     int tx_xdp);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index c2f5890..2fad018 100644
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

