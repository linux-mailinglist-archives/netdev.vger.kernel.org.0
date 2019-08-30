Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8D33A2DB9
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 05:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbfH3D4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 23:56:12 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42320 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728032AbfH3Dzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 23:55:43 -0400
Received: by mail-pl1-f194.google.com with SMTP id y1so2664985plp.9
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 20:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iuT0rfy4BFAsLrC/+FNGEp/Bx7WO2MTazuq5lVIC6/c=;
        b=fUupHFkgDuwSRGNrbOwMuDv1C+VST+gTxZKUumuqM+/fHdH7G2ImUq0o1/k6LrVx21
         KlTCHABSfsEoB/8/F521kqWk2SWcsy2ce9EiRvc2+wrE1qpxXVaperBE9++cBvUPBB3x
         XyaNZW1ACnHmYlrvXZaRooNZOn2iyVg4e/KmY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iuT0rfy4BFAsLrC/+FNGEp/Bx7WO2MTazuq5lVIC6/c=;
        b=BG2pyH/Xpt3ghbY16dmV41vEVGrBDvG/aWmFcH4bNMonEDWs1eO5a9+0qTqVGxOGAM
         wzB5Ul9BRpPwITD+KW4ibKojHN/cM1cjGITwSTUiN4taKISKhR2q23245tZbEaKp3iFP
         ipD0zhrRXeMLLA0jZLivJzc+pNAzuMQ77ldCMSMJPds+f1PaFRfGDECrRzA2pwwjVccV
         CgxdgzKtcKIdmx50bY9JMN80Gwh/+LuQi2AmuzgBnfPc0ZlkGWRz5Hd0/qJni7QeiMzt
         fpuan1p4qBk+cfVLNsc3a75V6R49gVyBRG1g7M36IqPUrG4x9nectJv3ZDB8qFHljJy5
         GefA==
X-Gm-Message-State: APjAAAU6wU0uNS75GFE3BoKc6DBUgfqRLDl5F8xXeC2JRObY3MsMrE2H
        z63kTpVjmgCporOgUOnzDoDAZA==
X-Google-Smtp-Source: APXvYqxW4Z0TSp5QCdFyF0DGW7NV/ehXvfyvADRfh7SMm4aTRXasxO/Gs/caufW640EhOXbOHy6bOw==
X-Received: by 2002:a17:902:bc4c:: with SMTP id t12mr13231277plz.90.1567137343210;
        Thu, 29 Aug 2019 20:55:43 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l3sm3658877pjq.24.2019.08.29.20.55.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 20:55:42 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        ray.jui@broadcom.com
Subject: [PATCH net-next v2 12/22] bnxt_en: Enable health monitoring.
Date:   Thu, 29 Aug 2019 23:54:55 -0400
Message-Id: <1567137305-5853-13-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
References: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Handle the async event from the firmware that enables firmware health
monitoring.  Store initial health metrics.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 66 ++++++++++++++++++++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  9 +++++
 2 files changed, 73 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 8ec41d6..27fc047 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -254,6 +254,7 @@ static const u16 bnxt_async_events_arr[] = {
 	ASYNC_EVENT_CMPL_EVENT_ID_PORT_CONN_NOT_ALLOWED,
 	ASYNC_EVENT_CMPL_EVENT_ID_VF_CFG_CHANGE,
 	ASYNC_EVENT_CMPL_EVENT_ID_LINK_SPEED_CFG_CHANGE,
+	ASYNC_EVENT_CMPL_EVENT_ID_ERROR_RECOVERY,
 };
 
 static struct workqueue_struct *bnxt_pf_wq;
@@ -1896,6 +1897,33 @@ static int bnxt_force_rx_discard(struct bnxt *bp,
 	return bnxt_rx_pkt(bp, cpr, raw_cons, event);
 }
 
+u32 bnxt_fw_health_readl(struct bnxt *bp, int reg_idx)
+{
+	struct bnxt_fw_health *fw_health = bp->fw_health;
+	u32 reg = fw_health->regs[reg_idx];
+	u32 reg_type, reg_off, val = 0;
+
+	reg_type = BNXT_FW_HEALTH_REG_TYPE(reg);
+	reg_off = BNXT_FW_HEALTH_REG_OFF(reg);
+	switch (reg_type) {
+	case BNXT_FW_HEALTH_REG_TYPE_CFG:
+		pci_read_config_dword(bp->pdev, reg_off, &val);
+		break;
+	case BNXT_FW_HEALTH_REG_TYPE_GRC:
+		reg_off = fw_health->mapped_regs[reg_idx];
+		/* fall through */
+	case BNXT_FW_HEALTH_REG_TYPE_BAR0:
+		val = readl(bp->bar0 + reg_off);
+		break;
+	case BNXT_FW_HEALTH_REG_TYPE_BAR1:
+		val = readl(bp->bar1 + reg_off);
+		break;
+	}
+	if (reg_idx == BNXT_FW_RESET_INPROG_REG)
+		val &= fw_health->fw_reset_inprog_reg_mask;
+	return val;
+}
+
 #define BNXT_GET_EVENT_PORT(data)	\
 	((data) &			\
 	 ASYNC_EVENT_CMPL_PORT_CONN_NOT_ALLOWED_EVENT_DATA1_PORT_ID_MASK)
@@ -1951,6 +1979,35 @@ static int bnxt_async_event_process(struct bnxt *bp,
 			goto async_event_process_exit;
 		set_bit(BNXT_RESET_TASK_SILENT_SP_EVENT, &bp->sp_event);
 		break;
+	case ASYNC_EVENT_CMPL_EVENT_ID_ERROR_RECOVERY: {
+		struct bnxt_fw_health *fw_health = bp->fw_health;
+		u32 data1 = le32_to_cpu(cmpl->event_data1);
+
+		if (!fw_health)
+			goto async_event_process_exit;
+
+		fw_health->enabled = EVENT_DATA1_RECOVERY_ENABLED(data1);
+		fw_health->master = EVENT_DATA1_RECOVERY_MASTER_FUNC(data1);
+		if (!fw_health->enabled)
+			break;
+
+		if (netif_msg_drv(bp))
+			netdev_info(bp->dev, "Error recovery info: error recovery[%d], master[%d], reset count[0x%x], health status: 0x%x\n",
+				    fw_health->enabled, fw_health->master,
+				    bnxt_fw_health_readl(bp,
+							 BNXT_FW_RESET_CNT_REG),
+				    bnxt_fw_health_readl(bp,
+							 BNXT_FW_HEALTH_REG));
+		fw_health->tmr_multiplier =
+			DIV_ROUND_UP(fw_health->polling_dsecs * HZ,
+				     bp->current_interval * 10);
+		fw_health->tmr_counter = fw_health->tmr_multiplier;
+		fw_health->last_fw_heartbeat =
+			bnxt_fw_health_readl(bp, BNXT_FW_HEARTBEAT_REG);
+		fw_health->last_fw_reset_cnt =
+			bnxt_fw_health_readl(bp, BNXT_FW_RESET_CNT_REG);
+		goto async_event_process_exit;
+	}
 	default:
 		goto async_event_process_exit;
 	}
@@ -4310,9 +4367,14 @@ int bnxt_hwrm_func_rgtr_async_events(struct bnxt *bp, unsigned long *bmap,
 		cpu_to_le32(FUNC_DRV_RGTR_REQ_ENABLES_ASYNC_EVENT_FWD);
 
 	memset(async_events_bmap, 0, sizeof(async_events_bmap));
-	for (i = 0; i < ARRAY_SIZE(bnxt_async_events_arr); i++)
-		__set_bit(bnxt_async_events_arr[i], async_events_bmap);
+	for (i = 0; i < ARRAY_SIZE(bnxt_async_events_arr); i++) {
+		u16 event_id = bnxt_async_events_arr[i];
 
+		if (event_id == ASYNC_EVENT_CMPL_EVENT_ID_ERROR_RECOVERY &&
+		    !(bp->fw_cap & BNXT_FW_CAP_ERROR_RECOVERY))
+			continue;
+		__set_bit(bnxt_async_events_arr[i], async_events_bmap);
+	}
 	if (bmap && bmap_size) {
 		for (i = 0; i < bmap_size; i++) {
 			if (test_bit(i, bmap))
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 78fd585..eb55519 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -472,6 +472,14 @@ struct rx_tpa_end_cmp_ext {
 	((le32_to_cpu((rx_tpa_end_ext)->rx_tpa_end_cmp_dup_acks) &	\
 	 RX_TPA_END_CMP_AGG_BUFS_P5) >> RX_TPA_END_CMP_AGG_BUFS_SHIFT_P5)
 
+#define EVENT_DATA1_RECOVERY_MASTER_FUNC(data1)				\
+	!!((data1) &							\
+	   ASYNC_EVENT_CMPL_ERROR_RECOVERY_EVENT_DATA1_FLAGS_MASTER_FUNC)
+
+#define EVENT_DATA1_RECOVERY_ENABLED(data1)				\
+	!!((data1) &							\
+	   ASYNC_EVENT_CMPL_ERROR_RECOVERY_EVENT_DATA1_FLAGS_RECOVERY_ENABLED)
+
 struct nqe_cn {
 	__le16	type;
 	#define NQ_CN_TYPE_MASK           0x3fUL
@@ -1914,6 +1922,7 @@ extern const u16 bnxt_lhint_arr[];
 int bnxt_alloc_rx_data(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 		       u16 prod, gfp_t gfp);
 void bnxt_reuse_rx_data(struct bnxt_rx_ring_info *rxr, u16 cons, void *data);
+u32 bnxt_fw_health_readl(struct bnxt *bp, int reg_idx);
 void bnxt_set_tpa_flags(struct bnxt *bp);
 void bnxt_set_ring_params(struct bnxt *);
 int bnxt_set_rx_skb_mode(struct bnxt *bp, bool page_mode);
-- 
2.5.1

