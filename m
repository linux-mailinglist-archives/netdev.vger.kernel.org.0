Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4F603949B7
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 02:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhE2AzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 20:55:01 -0400
Received: from saphodev.broadcom.com ([192.19.11.229]:39886 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229541AbhE2AzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 20:55:00 -0400
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id C31B27DA6;
        Fri, 28 May 2021 17:53:23 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com C31B27DA6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1622249604;
        bh=SEJy27BVCFFVlyN66mmuUwUt+y1O7rc0J7iqz+eZVyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IxMQNwKEKcZA7H78iiBxqhq3MmzoWdLdGDPVRknu4OhLguAhGERagCoXt+EnzwnHd
         r5WkCvRrgYW/lvBfwEA+GggmS7KRGEkY0bMQw7qCmHL6AbkFYJyAnb+EFpF1CRAVUy
         BhEF6kMJsWG7I7pdkOwDfkkXQybKB+17gkSvY8Kc=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        richardcochran@gmail.com, pavan.chebbi@broadcom.com,
        edwin.peer@broadcom.com
Subject: [PATCH net-next 2/7] bnxt_en: Get PTP hardware capability from firmware.
Date:   Fri, 28 May 2021 20:53:16 -0400
Message-Id: <1622249601-7106-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622249601-7106-1-git-send-email-michael.chan@broadcom.com>
References: <1622249601-7106-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Store PTP hardware info in a structure if hardware and firmware support PTP.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 46 +++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h | 44 ++++++++++++++++++
 3 files changed, 92 insertions(+)
 create mode 100644 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index fcc729d52b17..faf5fdbdf8c7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -49,6 +49,8 @@
 #include <linux/log2.h>
 #include <linux/aer.h>
 #include <linux/bitmap.h>
+#include <linux/ptp_clock_kernel.h>
+#include <linux/timecounter.h>
 #include <linux/cpu_rmap.h>
 #include <linux/cpumask.h>
 #include <net/pkt_cls.h>
@@ -63,6 +65,7 @@
 #include "bnxt_ethtool.h"
 #include "bnxt_dcb.h"
 #include "bnxt_xdp.h"
+#include "bnxt_ptp.h"
 #include "bnxt_vfr.h"
 #include "bnxt_tc.h"
 #include "bnxt_devlink.h"
@@ -7391,6 +7394,45 @@ int bnxt_hwrm_func_resc_qcaps(struct bnxt *bp, bool all)
 	return rc;
 }
 
+/* bp->hwrm_cmd_lock already held. */
+static int __bnxt_hwrm_ptp_qcfg(struct bnxt *bp)
+{
+	struct hwrm_port_mac_ptp_qcfg_output *resp = bp->hwrm_cmd_resp_addr;
+	struct hwrm_port_mac_ptp_qcfg_input req = {0};
+	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
+	int rc;
+
+	if (bp->hwrm_spec_code < 0x10801) {
+		rc = -ENODEV;
+		goto no_ptp;
+	}
+
+	req.port_id = cpu_to_le16(bp->pf.port_id);
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_PORT_MAC_PTP_QCFG, -1, -1);
+	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	if (rc)
+		goto no_ptp;
+
+	if (!(resp->flags & PORT_MAC_PTP_QCFG_RESP_FLAGS_HWRM_ACCESS)) {
+		rc = -ENODEV;
+		goto no_ptp;
+	}
+	if (!ptp) {
+		ptp = kzalloc(sizeof(*ptp), GFP_KERNEL);
+		if (!ptp)
+			return -ENOMEM;
+		ptp->bp = bp;
+		bp->ptp_cfg = ptp;
+	}
+	return 0;
+
+no_ptp:
+	kfree(ptp);
+	bp->ptp_cfg = NULL;
+	return rc;
+
+}
+
 static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
 {
 	int rc = 0;
@@ -7462,6 +7504,8 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
 		bp->flags &= ~BNXT_FLAG_WOL_CAP;
 		if (flags & FUNC_QCAPS_RESP_FLAGS_WOL_MAGICPKT_SUPPORTED)
 			bp->flags |= BNXT_FLAG_WOL_CAP;
+		if (flags & FUNC_QCAPS_RESP_FLAGS_PTP_SUPPORTED)
+			__bnxt_hwrm_ptp_qcfg(bp);
 	} else {
 #ifdef CONFIG_BNXT_SRIOV
 		struct bnxt_vf_info *vf = &bp->vf;
@@ -12566,6 +12610,8 @@ static void bnxt_remove_one(struct pci_dev *pdev)
 	bnxt_dcb_free(bp);
 	kfree(bp->edev);
 	bp->edev = NULL;
+	kfree(bp->ptp_cfg);
+	bp->ptp_cfg = NULL;
 	kfree(bp->fw_health);
 	bp->fw_health = NULL;
 	bnxt_cleanup_pci(bp);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 30e47ea343f9..65deefcb04f8 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -2042,6 +2042,8 @@ struct bnxt {
 
 	struct bpf_prog		*xdp_prog;
 
+	struct bnxt_ptp_cfg	*ptp_cfg;
+
 	/* devlink interface and vf-rep structs */
 	struct devlink		*dl;
 	struct devlink_port	dl_port;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
new file mode 100644
index 000000000000..aecca18ecfbd
--- /dev/null
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
@@ -0,0 +1,44 @@
+/* Broadcom NetXtreme-C/E network driver.
+ *
+ * Copyright (c) 2021 Broadcom Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+
+#ifndef BNXT_PTP_H
+#define BNXT_PTP_H
+
+struct bnxt_ptp_cfg {
+	struct ptp_clock_info	ptp_info;
+	struct ptp_clock	*ptp_clock;
+	struct cyclecounter	cc;
+	struct timecounter	tc;
+	struct sk_buff		*tx_skb;
+	u64			current_time;
+	u64			old_time;
+	struct work_struct	ptp_ts_task;
+	u16			tx_seqid;
+	struct bnxt		*bp;
+	atomic_t		tx_avail;
+#define BNXT_MAX_TX_TS	1
+	u16			rxctl;
+#define BNXT_PTP_MSG_SYNC			(1 << 0)
+#define BNXT_PTP_MSG_DELAY_REQ			(1 << 1)
+#define BNXT_PTP_MSG_PDELAY_REQ			(1 << 2)
+#define BNXT_PTP_MSG_PDELAY_RESP		(1 << 3)
+#define BNXT_PTP_MSG_FOLLOW_UP			(1 << 8)
+#define BNXT_PTP_MSG_DELAY_RESP			(1 << 9)
+#define BNXT_PTP_MSG_PDELAY_RESP_FOLLOW_UP	(1 << 10)
+#define BNXT_PTP_MSG_ANNOUNCE			(1 << 11)
+#define BNXT_PTP_MSG_SIGNALING			(1 << 12)
+#define BNXT_PTP_MSG_MANAGEMENT			(1 << 13)
+#define BNXT_PTP_MSG_EVENTS		(BNXT_PTP_MSG_SYNC |		\
+					 BNXT_PTP_MSG_DELAY_REQ |	\
+					 BNXT_PTP_MSG_PDELAY_REQ |	\
+					 BNXT_PTP_MSG_PDELAY_RESP)
+	u8			tx_tstamp_en:1;
+	int			rx_filter;
+};
+#endif
-- 
2.18.1

