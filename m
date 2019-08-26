Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2199C822
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 05:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729653AbfHZD4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 23:56:08 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33802 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729611AbfHZD4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 23:56:02 -0400
Received: by mail-pf1-f193.google.com with SMTP id b24so10896487pfp.1
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 20:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Qb5/RLPnRdhh+ULel+YdnvHDZPzcAxGBJo04hzb/LcE=;
        b=fQ38CAe2kBoEJDGb9c5VCNJclF1pSdhhFLY8aiNVat27SPHymRNmxwVhv4oO0v/TVr
         Zdg3tDcqvZRquLMCIXCBNvT1morxN0+a304GxwWkqA3Os50Vus88MZEq6D0Lxci3R3r9
         Uup4n+LJNwtggq4GGkB9q3kV149konBBFl7sA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Qb5/RLPnRdhh+ULel+YdnvHDZPzcAxGBJo04hzb/LcE=;
        b=dSPMF6GIpuvPSS1xol8mEg2WBSzAGVa6eAN7jUtz89viPW6yXU15dJsVagLuUX7i3n
         8MXjAGHCXvKO5huTizswj78LxPLYJqPLfTm7mGo8YbKTW9C5Tk6vUoqjvdEWXQagfw57
         OhMJCnZE4ks+9HKbwn+L3Jplk/sWG+21ybFaYeI2dpIarKdBiqN0Mn+BtGxEgXX9w4wh
         458XyA8MkLJtd4fq/an4wbDwFpnbFihpWs/0rTHpx83LIdQSyIb7QGyWkf9cTYgkzCUx
         iyel1NHWor9oqdDWi5nldVB2OxaXqmrgoYbf/gRQH30TsFslHCNrEOnQNWAd80iJ6ZLI
         ranw==
X-Gm-Message-State: APjAAAUj13Jk9z7yCOl5eWGHNO97oXwDiw8IAKIR0p4uwLpaKa94UF/L
        2LXW9SlCt1WxCDVh4ja6qlhwmA==
X-Google-Smtp-Source: APXvYqxdFHyjYc8LfevMFS1pq7J+v1qLPx8rI6meDoaKINaYMop0LXIRKqjMaPW35oGAa9Ni4XO41w==
X-Received: by 2002:aa7:8b10:: with SMTP id f16mr18239700pfd.44.1566791761355;
        Sun, 25 Aug 2019 20:56:01 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d6sm8532975pgf.55.2019.08.25.20.56.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Aug 2019 20:56:00 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        jiri@mellanox.com, ray.jui@broadcom.com
Subject: [PATCH net-next 10/14] bnxt_en: Handle RESET_NOTIFY async event from firmware.
Date:   Sun, 25 Aug 2019 23:55:01 -0400
Message-Id: <1566791705-20473-11-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
References: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This event from firmware signals a coordinated reset initiated by the
firmware.  It may be triggered by some error conditions encountered
in the firmware or other orderly reset conditions.

Add devlink health reporter for this event.  The driver will perform
an orderly shutdown and will unregister with the firmware.  If the PF
has active and registered VFs, it will wait for all VFs to unregister
first before shutdown.  After that, it will poll for firmware to come
out of reset.  When firmware starts responding, the driver will re-probe
all capabilities before initializing the device.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 164 +++++++++++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  19 +++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c |  52 +++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c     |   3 +
 5 files changed, 238 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index be0eb1c..12ab4ae 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -254,6 +254,7 @@ static const u16 bnxt_async_events_arr[] = {
 	ASYNC_EVENT_CMPL_EVENT_ID_PORT_CONN_NOT_ALLOWED,
 	ASYNC_EVENT_CMPL_EVENT_ID_VF_CFG_CHANGE,
 	ASYNC_EVENT_CMPL_EVENT_ID_LINK_SPEED_CFG_CHANGE,
+	ASYNC_EVENT_CMPL_EVENT_ID_RESET_NOTIFY,
 	ASYNC_EVENT_CMPL_EVENT_ID_ERROR_RECOVERY,
 };
 
@@ -1139,6 +1140,14 @@ static int bnxt_discard_rx(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 	return 0;
 }
 
+static void bnxt_queue_fw_reset_work(struct bnxt *bp, unsigned long delay)
+{
+	if (BNXT_PF(bp))
+		queue_delayed_work(bnxt_pf_wq, &bp->fw_reset_task, delay);
+	else
+		schedule_delayed_work(&bp->fw_reset_task, delay);
+}
+
 static void bnxt_queue_sp_work(struct bnxt *bp)
 {
 	if (BNXT_PF(bp))
@@ -1979,6 +1988,16 @@ static int bnxt_async_event_process(struct bnxt *bp,
 			goto async_event_process_exit;
 		set_bit(BNXT_RESET_TASK_SILENT_SP_EVENT, &bp->sp_event);
 		break;
+	case ASYNC_EVENT_CMPL_EVENT_ID_RESET_NOTIFY:
+		bp->fw_reset_timestamp = jiffies;
+		bp->fw_reset_min_dsecs = cmpl->timestamp_lo;
+		if (!bp->fw_reset_min_dsecs)
+			bp->fw_reset_min_dsecs = 20;
+		bp->fw_reset_max_dsecs = le16_to_cpu(cmpl->timestamp_hi);
+		if (!bp->fw_reset_max_dsecs)
+			bp->fw_reset_max_dsecs = 60;
+		set_bit(BNXT_FW_RESET_NOTIFY_SP_EVENT, &bp->sp_event);
+		break;
 	case ASYNC_EVENT_CMPL_EVENT_ID_ERROR_RECOVERY: {
 		struct bnxt_fw_health *fw_health = bp->fw_health;
 		u32 data1 = le32_to_cpu(cmpl->event_data1);
@@ -4377,7 +4396,8 @@ static int bnxt_hwrm_func_drv_rgtr(struct bnxt *bp)
 			    FUNC_DRV_RGTR_REQ_ENABLES_VER);
 
 	req.os_type = cpu_to_le16(FUNC_DRV_RGTR_REQ_OS_TYPE_LINUX);
-	req.flags = cpu_to_le32(FUNC_DRV_RGTR_REQ_FLAGS_16BIT_VER_MODE);
+	req.flags = cpu_to_le32(FUNC_DRV_RGTR_REQ_FLAGS_16BIT_VER_MODE |
+				FUNC_DRV_RGTR_REQ_FLAGS_HOT_RESET_SUPPORT);
 	req.ver_maj_8b = DRV_VER_MAJ;
 	req.ver_min_8b = DRV_VER_MIN;
 	req.ver_upd_8b = DRV_VER_UPD;
@@ -9957,6 +9977,53 @@ static void bnxt_reset(struct bnxt *bp, bool silent)
 	bnxt_rtnl_unlock_sp(bp);
 }
 
+static void bnxt_fw_reset_close(struct bnxt *bp)
+{
+	__bnxt_close_nic(bp, true, false);
+	bnxt_ulp_irq_stop(bp);
+	bnxt_clear_int_mode(bp);
+	bnxt_hwrm_func_drv_unrgtr(bp);
+	bnxt_free_ctx_mem(bp);
+	kfree(bp->ctx);
+	bp->ctx = NULL;
+}
+
+void bnxt_fw_reset(struct bnxt *bp)
+{
+	int rc;
+
+	bnxt_rtnl_lock_sp(bp);
+	if (test_bit(BNXT_STATE_OPEN, &bp->state) &&
+	    !test_bit(BNXT_STATE_IN_FW_RESET, &bp->state)) {
+		set_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
+		if (BNXT_PF(bp) && bp->pf.active_vfs) {
+			rc = bnxt_hwrm_func_qcfg(bp);
+			if (rc) {
+				netdev_err(bp->dev, "Firmware reset aborted, first func_qcfg cmd failed, rc = %d\n",
+					   rc);
+				clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
+				dev_close(bp->dev);
+				goto fw_reset_exit;
+			}
+			if (bp->pf.registered_vfs) {
+				u16 vf_tmo_dsecs = bp->pf.registered_vfs * 10;
+
+				if (bp->fw_reset_max_dsecs < vf_tmo_dsecs)
+					bp->fw_reset_max_dsecs = vf_tmo_dsecs;
+				bp->fw_reset_state =
+					BNXT_FW_RESET_STATE_POLL_VF;
+				bnxt_queue_fw_reset_work(bp, HZ / 10);
+				goto fw_reset_exit;
+			}
+		}
+		bnxt_fw_reset_close(bp);
+		bp->fw_reset_state = BNXT_FW_RESET_STATE_ENABLE_DEV;
+		bnxt_queue_fw_reset_work(bp, bp->fw_reset_min_dsecs * HZ / 10);
+	}
+fw_reset_exit:
+	bnxt_rtnl_unlock_sp(bp);
+}
+
 static void bnxt_chk_missed_irq(struct bnxt *bp)
 {
 	int i;
@@ -10087,6 +10154,9 @@ static void bnxt_sp_task(struct work_struct *work)
 	if (test_and_clear_bit(BNXT_RESET_TASK_SILENT_SP_EVENT, &bp->sp_event))
 		bnxt_reset(bp, true);
 
+	if (test_and_clear_bit(BNXT_FW_RESET_NOTIFY_SP_EVENT, &bp->sp_event))
+		bnxt_devlink_health_report(bp, BNXT_FW_RESET_NOTIFY_SP_EVENT);
+
 	smp_mb__before_atomic();
 	clear_bit(BNXT_STATE_IN_SP_TASK, &bp->state);
 }
@@ -10316,6 +10386,97 @@ static int bnxt_fw_init_one(struct bnxt *bp)
 	return 0;
 }
 
+static void bnxt_fw_reset_task(struct work_struct *work)
+{
+	struct bnxt *bp = container_of(work, struct bnxt, fw_reset_task.work);
+	int rc;
+
+	if (!test_bit(BNXT_STATE_IN_FW_RESET, &bp->state)) {
+		netdev_err(bp->dev, "bnxt_fw_reset_task() called when not in fw reset mode!\n");
+		return;
+	}
+
+	switch (bp->fw_reset_state) {
+	case BNXT_FW_RESET_STATE_POLL_VF:
+		rc = bnxt_hwrm_func_qcfg(bp);
+		if (rc) {
+			netdev_err(bp->dev, "Firmware reset aborted, subsequent func_qcfg cmd failed, rc = %d, %d msecs since reset timestamp\n",
+				   rc, jiffies_to_msecs(jiffies -
+				   bp->fw_reset_timestamp));
+			goto fw_reset_abort;
+		}
+		if (bp->pf.registered_vfs) {
+			if (time_after(jiffies, bp->fw_reset_timestamp +
+				       (bp->fw_reset_max_dsecs * HZ / 10))) {
+				clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
+				bp->fw_reset_state = 0;
+				netdev_err(bp->dev, "Firmware reset aborted, %d VFs still registered\n",
+					   bp->pf.registered_vfs);
+				return;
+			}
+			bnxt_queue_fw_reset_work(bp, HZ / 10);
+			return;
+		}
+		bp->fw_reset_timestamp = jiffies;
+		rtnl_lock();
+		bnxt_fw_reset_close(bp);
+		bp->fw_reset_state = BNXT_FW_RESET_STATE_ENABLE_DEV;
+		rtnl_unlock();
+		bnxt_queue_fw_reset_work(bp, bp->fw_reset_min_dsecs * HZ / 10);
+		return;
+	case BNXT_FW_RESET_STATE_ENABLE_DEV:
+		if (pci_enable_device(bp->pdev)) {
+			netdev_err(bp->dev, "Cannot re-enable PCI device\n");
+			goto fw_reset_abort;
+		}
+		pci_set_master(bp->pdev);
+		bp->fw_reset_state = BNXT_FW_RESET_STATE_POLL_FW;
+		/* fall through */
+	case BNXT_FW_RESET_STATE_POLL_FW:
+		bp->hwrm_cmd_timeout = SHORT_HWRM_CMD_TIMEOUT;
+		rc = __bnxt_hwrm_ver_get(bp, true);
+		if (rc) {
+			if (time_after(jiffies, bp->fw_reset_timestamp +
+				       (bp->fw_reset_max_dsecs * HZ / 10))) {
+				netdev_err(bp->dev, "Firmware reset aborted\n");
+				goto fw_reset_abort;
+			}
+			bnxt_queue_fw_reset_work(bp, HZ / 5);
+			return;
+		}
+		bp->hwrm_cmd_timeout = DFLT_HWRM_CMD_TIMEOUT;
+		bp->fw_reset_state = BNXT_FW_RESET_STATE_OPENING;
+		/* fall through */
+	case BNXT_FW_RESET_STATE_OPENING:
+		while (!rtnl_trylock()) {
+			bnxt_queue_fw_reset_work(bp, HZ / 10);
+			return;
+		}
+		rc = bnxt_open(bp->dev);
+		if (rc) {
+			netdev_err(bp->dev, "bnxt_open_nic() failed\n");
+			clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
+			dev_close(bp->dev);
+		}
+		bnxt_ulp_irq_restart(bp, rc);
+		rtnl_unlock();
+
+		bp->fw_reset_state = 0;
+		/* Make sure fw_reset_state is 0 before clearing the flag */
+		smp_mb__before_atomic();
+		clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
+		break;
+	}
+	return;
+
+fw_reset_abort:
+	clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
+	bp->fw_reset_state = 0;
+	rtnl_lock();
+	dev_close(bp->dev);
+	rtnl_unlock();
+}
+
 static int bnxt_init_board(struct pci_dev *pdev, struct net_device *dev)
 {
 	int rc;
@@ -10378,6 +10539,7 @@ static int bnxt_init_board(struct pci_dev *pdev, struct net_device *dev)
 	pci_enable_pcie_error_reporting(pdev);
 
 	INIT_WORK(&bp->sp_task, bnxt_sp_task);
+	INIT_DELAYED_WORK(&bp->fw_reset_task, bnxt_fw_reset_task);
 
 	spin_lock_init(&bp->ntp_fltr_lock);
 #if BITS_PER_LONG == 32
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 5d291f5..cb9a9a4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -640,6 +640,7 @@ struct nqe_cn {
 #define BNXT_HWRM_MAX_REQ_LEN		(bp->hwrm_max_req_len)
 #define BNXT_HWRM_SHORT_REQ_LEN		sizeof(struct hwrm_short_input)
 #define DFLT_HWRM_CMD_TIMEOUT		500
+#define SHORT_HWRM_CMD_TIMEOUT		20
 #define HWRM_CMD_TIMEOUT		(bp->hwrm_cmd_timeout)
 #define HWRM_RESET_TIMEOUT		((HWRM_CMD_TIMEOUT) * 4)
 #define HWRM_RESP_ERR_CODE_MASK		0xffff
@@ -1370,6 +1371,11 @@ struct bnxt_fw_health {
 	u32 fw_reset_seq_vals[16];
 	u32 fw_reset_seq_delay_msec[16];
 	struct devlink_health_reporter	*fw_reporter;
+	struct devlink_health_reporter *fw_reset_reporter;
+};
+
+struct bnxt_fw_reporter_ctx {
+	unsigned long sp_event;
 };
 
 #define BNXT_FW_HEALTH_REG_TYPE_MASK	3
@@ -1720,6 +1726,18 @@ struct bnxt {
 #define BNXT_FLOW_STATS_SP_EVENT	15
 #define BNXT_UPDATE_PHY_SP_EVENT	16
 #define BNXT_RING_COAL_NOW_SP_EVENT	17
+#define BNXT_FW_RESET_NOTIFY_SP_EVENT	18
+
+	struct delayed_work	fw_reset_task;
+	int			fw_reset_state;
+#define BNXT_FW_RESET_STATE_POLL_VF	1
+#define BNXT_FW_RESET_STATE_RESET_FW	2
+#define BNXT_FW_RESET_STATE_ENABLE_DEV	3
+#define BNXT_FW_RESET_STATE_POLL_FW	4
+#define BNXT_FW_RESET_STATE_OPENING	5
+	u16			fw_reset_min_dsecs;
+	u16			fw_reset_max_dsecs;
+	unsigned long		fw_reset_timestamp;
 
 	struct bnxt_fw_health	*fw_health;
 
@@ -1960,6 +1978,7 @@ int bnxt_open_nic(struct bnxt *, bool, bool);
 int bnxt_half_open_nic(struct bnxt *bp);
 void bnxt_half_close_nic(struct bnxt *bp);
 int bnxt_close_nic(struct bnxt *, bool, bool);
+void bnxt_fw_reset(struct bnxt *bp);
 int bnxt_check_rings(struct bnxt *bp, int tx, int rx, bool sh, int tcs,
 		     int tx_xdp);
 int bnxt_setup_mq_tc(struct net_device *dev, u8 tc);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 7eb1a25..c2f5890 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -65,6 +65,24 @@ static const struct devlink_health_reporter_ops bnxt_dl_fw_reporter_ops = {
 	.diagnose = bnxt_fw_reporter_diagnose,
 };
 
+static int bnxt_fw_reset_recover(struct devlink_health_reporter *reporter,
+				 void *priv_ctx)
+{
+	struct bnxt *bp = devlink_health_reporter_priv(reporter);
+
+	if (!priv_ctx)
+		return -EOPNOTSUPP;
+
+	bnxt_fw_reset(bp);
+	return 0;
+}
+
+static const
+struct devlink_health_reporter_ops bnxt_dl_fw_reset_reporter_ops = {
+	.name = "fw_reset",
+	.recover = bnxt_fw_reset_recover,
+};
+
 static void bnxt_dl_fw_reporters_create(struct bnxt *bp)
 {
 	struct bnxt_fw_health *health = bp->fw_health;
@@ -80,6 +98,16 @@ static void bnxt_dl_fw_reporters_create(struct bnxt *bp)
 			    PTR_ERR(health->fw_reporter));
 		health->fw_reporter = NULL;
 	}
+
+	health->fw_reset_reporter =
+		devlink_health_reporter_create(bp->dl,
+					       &bnxt_dl_fw_reset_reporter_ops,
+					       0, true, bp);
+	if (IS_ERR(health->fw_reset_reporter)) {
+		netdev_warn(bp->dev, "Failed to create FW fatal health reporter, rc = %ld\n",
+			    PTR_ERR(health->fw_reset_reporter));
+		health->fw_reset_reporter = NULL;
+	}
 }
 
 static void bnxt_dl_fw_reporters_destroy(struct bnxt *bp)
@@ -91,6 +119,30 @@ static void bnxt_dl_fw_reporters_destroy(struct bnxt *bp)
 
 	if (health->fw_reporter)
 		devlink_health_reporter_destroy(health->fw_reporter);
+
+	if (health->fw_reset_reporter)
+		devlink_health_reporter_destroy(health->fw_reset_reporter);
+}
+
+void bnxt_devlink_health_report(struct bnxt *bp, unsigned long event)
+{
+	struct bnxt_fw_health *fw_health = bp->fw_health;
+	struct bnxt_fw_reporter_ctx fw_reporter_ctx;
+
+	if (!fw_health)
+		return;
+
+	fw_reporter_ctx.sp_event = event;
+	switch (event) {
+	case BNXT_FW_RESET_NOTIFY_SP_EVENT:
+		if (!fw_health->fw_reset_reporter)
+			return;
+
+		devlink_health_report(fw_health->fw_reset_reporter,
+				      "FW non-fatal reset event received",
+				      &fw_reporter_ctx);
+		return;
+	}
 }
 
 static const struct devlink_ops bnxt_dl_ops = {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
index 5b6b2c7..b97e0ba 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
@@ -55,6 +55,7 @@ struct bnxt_dl_nvm_param {
 	u16 num_bits;
 };
 
+void bnxt_devlink_health_report(struct bnxt *bp, unsigned long event);
 int bnxt_dl_register(struct bnxt *bp);
 void bnxt_dl_unregister(struct bnxt *bp);
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index fc77caf..b2c1609 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -226,6 +226,9 @@ static int bnxt_send_msg(struct bnxt_en_dev *edev, int ulp_id,
 	struct input *req;
 	int rc;
 
+	if (ulp_id != BNXT_ROCE_ULP && bp->fw_reset_state)
+		return -EBUSY;
+
 	mutex_lock(&bp->hwrm_cmd_lock);
 	req = fw_msg->msg;
 	req->resp_addr = cpu_to_le64(bp->hwrm_cmd_resp_dma_addr);
-- 
2.5.1

