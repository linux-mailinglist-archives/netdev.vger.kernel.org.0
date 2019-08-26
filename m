Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0219C820
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 05:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729620AbfHZD4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 23:56:03 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43137 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729580AbfHZDz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 23:55:59 -0400
Received: by mail-pf1-f196.google.com with SMTP id v12so10866184pfn.10
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 20:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dCBJSB//EmWJ4z1k93Hk+IAzQRlIBH4W/m2LTDanYIk=;
        b=UkEwvAYpExQtn6adiDhQyW7lEgVP3VLKumvvFrYmmNboeQ8WghaGq/L61r3aQqYX3l
         +65pGUm++Q5CCRiXiGD2KqP9dHd9mpdoI0dH8fOLzInVAcSYGugVrBRFGJPqURyldwlu
         HvhmqpejYELLofDP97B1dYQxWm1Hup+q6Kz2A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dCBJSB//EmWJ4z1k93Hk+IAzQRlIBH4W/m2LTDanYIk=;
        b=Wqm7GQdud4dF2vLJHslZAbiW3aEOfXs2q02LECuvdoXS/HyxecQPf6UjzYny2AyjsL
         aX3xVkjbzgbAW2GI47XYa7V8Mguz6Dr43khnf04j0JhY73y2+wfUhx3c5h6tKbBbyGJZ
         EdjjAS1VsppLqAl89gZCIaiIqBusIwnr08UOXCvCo0j+D6dH0rb3wbDtvDuy7yzRurCu
         gGr/lGLA45NECgWiTPVrRM1/G1aaNMwA3MrqEjP27CnBOWwflQdpF01c435IfmCe0V6M
         RdxsLW/480/kkhTvMlvW9EY9gwvxJu/etgorJ/F1iVq8GsF4x9PkmNOfP2QmBMlvqOwO
         H7xA==
X-Gm-Message-State: APjAAAWe89GIkCZhVf3mPU/E2WvXcvZ+LH8Uhdzz8YoTUbivW7MSyaJA
        8rOtlaAcwLtWU7WmiUXIcRMQVX6bdGg=
X-Google-Smtp-Source: APXvYqzhg7ChVUGBtE/C59cA+yIVDN+QZQAaU9uf2swW71i+kQ1+HyRRBhbgCDwFfjy2SNb4ECohWg==
X-Received: by 2002:a63:e62:: with SMTP id 34mr14330063pgo.331.1566791758546;
        Sun, 25 Aug 2019 20:55:58 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d6sm8532975pgf.55.2019.08.25.20.55.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Aug 2019 20:55:57 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        jiri@mellanox.com, ray.jui@broadcom.com
Subject: [PATCH net-next 07/14] bnxt_en: Enable health monitoring.
Date:   Sun, 25 Aug 2019 23:54:58 -0400
Message-Id: <1566791705-20473-8-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
References: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
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
index 9ab5024..f522f3b 100644
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
@@ -4286,9 +4343,14 @@ int bnxt_hwrm_func_rgtr_async_events(struct bnxt *bp, unsigned long *bmap,
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
index 6053dfd..96f2e12 100644
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

