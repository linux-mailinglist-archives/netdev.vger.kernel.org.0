Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61D2DA2DB1
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 05:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728155AbfH3Dzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 23:55:55 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45878 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728099AbfH3Dzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 23:55:48 -0400
Received: by mail-pg1-f193.google.com with SMTP id o13so2784570pgp.12
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 20:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fgPc56SB4QMGwiAiYaeKtU2le5lQpB6FrdIYgmSnigc=;
        b=TqWP6TkVmAIaGPSO9RgOPOlJxMJW4YyzBxO/4UfQABUIX3CabwPKDg/FC6AWemKue/
         NBg3QshPkHOrNcdWsUaxcSkZR1Ueua3flBFHpMe3FA/opKt69JMzpMZGFRmuMSNEwRpm
         WSCot76qDHSpKQF6HrsItj7acGOJ0rd1Iz9+E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fgPc56SB4QMGwiAiYaeKtU2le5lQpB6FrdIYgmSnigc=;
        b=lITpxNK6yp8dwk1HWmXy2CKxRDddMuKThi0tX6rSGiWJjZ5b+xsV4OmH/1Ff42NyS6
         2jY1uInUVATCiSGRopMUALc6WU/qQ2RNhUL+6mG5YU5MBYCPiRvufT1c1zlsLSWM3osJ
         ClZ0IrM12ko1yzuqxZ5nofO+KYDRZTZ6S0vEcqmzCJnjAW8soBmVbW08teGni00FvAMP
         GArFZhflot7TZBusfcOZkW3FfRbeX6UPX5RLWcR98rEQAdSN3lqplZCoaU540AMUZkww
         +uhQXkdk6dLWsZkorE9s5yYYMYCCnWgnx2B7jdki1WlsBwyp9FxMhGSHGcbjMNTJybVI
         bAOg==
X-Gm-Message-State: APjAAAWms6mX5NXCmSYEEMe1+2a3kHkoAV/lCyQeCNqH0kGMhZE/etmY
        s7yq7IuF29q72MpB4GAAfKpl3w==
X-Google-Smtp-Source: APXvYqx4OLmpb/WVi7mU0TmL9gTNsEZ9N27bQms4aIS/BboQIaXLdiB2i4tYVrrLWg0Qu1wxNUVN1g==
X-Received: by 2002:a17:90a:b946:: with SMTP id f6mr13688488pjw.86.1567137347163;
        Thu, 29 Aug 2019 20:55:47 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l3sm3658877pjq.24.2019.08.29.20.55.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 20:55:46 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        ray.jui@broadcom.com
Subject: [PATCH net-next v2 16/22] bnxt_en: Handle firmware reset.
Date:   Thu, 29 Aug 2019 23:54:59 -0400
Message-Id: <1567137305-5853-17-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
References: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the bnxt_fw_reset() main function to handle firmware reset.  This
is triggered by firmware to initiate an orderly reset, for example
when a non-fatal exception condition has been detected.  bnxt_fw_reset()
will first wait for all VFs to shutdown and then start the
bnxt_fw_reset_task() work queue to go through the sequence of reset,
re-probe, and re-initialization.

The next patch will add the devlink reporter to start the sequence and
call bnxt_fw_reset().

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 150 ++++++++++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  11 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c |   3 +
 3 files changed, 164 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index d1d33f6..98b15551 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1140,6 +1140,14 @@ static int bnxt_discard_rx(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
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
@@ -6355,6 +6363,8 @@ static int bnxt_hwrm_func_qcfg(struct bnxt *bp)
 		struct bnxt_vf_info *vf = &bp->vf;
 
 		vf->vlan = le16_to_cpu(resp->vlan) & VLAN_VID_MASK;
+	} else {
+		bp->pf.registered_vfs = le16_to_cpu(resp->registered_vfs);
 	}
 #endif
 	flags = le16_to_cpu(resp->flags);
@@ -9980,6 +9990,53 @@ static void bnxt_reset(struct bnxt *bp, bool silent)
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
+			if (bp->pf.registered_vfs || bp->sriov_cfg) {
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
@@ -10339,6 +10396,98 @@ static int bnxt_fw_init_one(struct bnxt *bp)
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
+		if (bp->pf.registered_vfs || bp->sriov_cfg) {
+			if (time_after(jiffies, bp->fw_reset_timestamp +
+				       (bp->fw_reset_max_dsecs * HZ / 10))) {
+				clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
+				bp->fw_reset_state = 0;
+				netdev_err(bp->dev, "Firmware reset aborted, %d VFs still registered, sriov_cfg %d\n",
+					   bp->pf.registered_vfs,
+					   bp->sriov_cfg);
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
@@ -10401,6 +10550,7 @@ static int bnxt_init_board(struct pci_dev *pdev, struct net_device *dev)
 	pci_enable_pcie_error_reporting(pdev);
 
 	INIT_WORK(&bp->sp_task, bnxt_sp_task);
+	INIT_DELAYED_WORK(&bp->fw_reset_task, bnxt_fw_reset_task);
 
 	spin_lock_init(&bp->ntp_fltr_lock);
 #if BITS_PER_LONG == 32
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 858dc40..c78aa51 100644
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
@@ -1066,6 +1067,7 @@ struct bnxt_pf_info {
 	u8	mac_addr[ETH_ALEN];
 	u32	first_vf_id;
 	u16	active_vfs;
+	u16	registered_vfs;
 	u16	max_vfs;
 	u32	max_encap_records;
 	u32	max_decap_records;
@@ -1721,6 +1723,14 @@ struct bnxt {
 #define BNXT_RING_COAL_NOW_SP_EVENT	17
 #define BNXT_FW_RESET_NOTIFY_SP_EVENT	18
 
+	struct delayed_work	fw_reset_task;
+	int			fw_reset_state;
+#define BNXT_FW_RESET_STATE_POLL_VF	1
+#define BNXT_FW_RESET_STATE_RESET_FW	2
+#define BNXT_FW_RESET_STATE_ENABLE_DEV	3
+#define BNXT_FW_RESET_STATE_POLL_FW	4
+#define BNXT_FW_RESET_STATE_OPENING	5
+
 	u16			fw_reset_min_dsecs;
 #define BNXT_DFLT_FW_RST_MIN_DSECS	20
 	u16			fw_reset_max_dsecs;
@@ -1966,6 +1976,7 @@ int bnxt_open_nic(struct bnxt *, bool, bool);
 int bnxt_half_open_nic(struct bnxt *bp);
 void bnxt_half_close_nic(struct bnxt *bp);
 int bnxt_close_nic(struct bnxt *, bool, bool);
+void bnxt_fw_reset(struct bnxt *bp);
 int bnxt_check_rings(struct bnxt *bp, int tx, int rx, bool sh, int tcs,
 		     int tx_xdp);
 int bnxt_setup_mq_tc(struct net_device *dev, u8 tc);
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

