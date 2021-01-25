Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB953022CE
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 09:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbhAYI22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 03:28:28 -0500
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:33134 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727150AbhAYHQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 02:16:10 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 467277A52;
        Sun, 24 Jan 2021 23:08:22 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 467277A52
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1611558502;
        bh=i2jZ1scI/xxssP0N5hU4Ruj2oNm1MP0D3v7sqHnsSls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fD0nBciyC/lrhe3FDxZIvpVj5WnnlB9cRLvT60ZPxQtuBC7yILqfRnj7y51LbLTBU
         kbxc3xng65VIXp42lpHrXtTk4xmyk4oecjOewqp4qX1BVsBH+KNPDbn05Koz+kmg+w
         ptGSjhbPxDMotFP1tK5grjFzWlZXnUThkvB96E2E=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 01/15] bnxt_en: Update firmware interface to 1.10.2.11.
Date:   Mon, 25 Jan 2021 02:08:07 -0500
Message-Id: <1611558501-11022-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
References: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Updates to backing store APIs, QoS profiles, and push buffer initial
index support.

Since the new HWRM_FUNC_BACKING_STORE_CFG message size has increased,
we need to add some compat. logic to fall back to the smaller legacy
size if firmware cannot accept the larger message size.  The new fields
added to the structure are not used yet.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |   5 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h | 249 ++++++++++++++----
 3 files changed, 203 insertions(+), 53 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index d31a5ad7522a..5daef6801512 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6845,6 +6845,7 @@ static int bnxt_hwrm_func_backing_store_cfg(struct bnxt *bp, u32 enables)
 	struct hwrm_func_backing_store_cfg_input req = {0};
 	struct bnxt_ctx_mem_info *ctx = bp->ctx;
 	struct bnxt_ctx_pg_info *ctx_pg;
+	u32 req_len = sizeof(req);
 	__le32 *num_entries;
 	__le64 *pg_dir;
 	u32 flags = 0;
@@ -6855,6 +6856,8 @@ static int bnxt_hwrm_func_backing_store_cfg(struct bnxt *bp, u32 enables)
 	if (!ctx)
 		return 0;
 
+	if (req_len > bp->hwrm_max_ext_req_len)
+		req_len = BNXT_BACKING_STORE_CFG_LEGACY_LEN;
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_BACKING_STORE_CFG, -1, -1);
 	req.enables = cpu_to_le32(enables);
 
@@ -6938,7 +6941,7 @@ static int bnxt_hwrm_func_backing_store_cfg(struct bnxt *bp, u32 enables)
 		bnxt_hwrm_set_pg_attr(&ctx_pg->ring_mem, pg_attr, pg_dir);
 	}
 	req.flags = cpu_to_le32(flags);
-	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	return hwrm_send_message(bp, &req, req_len, HWRM_CMD_TIMEOUT);
 }
 
 static int bnxt_alloc_ctx_mem_blk(struct bnxt *bp,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 51996c85547e..d68065367cf2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1441,6 +1441,8 @@ struct bnxt_ctx_pg_info {
 #define BNXT_MAX_TQM_RINGS		\
 	(BNXT_MAX_TQM_SP_RINGS + BNXT_MAX_TQM_FP_RINGS)
 
+#define BNXT_BACKING_STORE_CFG_LEGACY_LEN	256
+
 struct bnxt_ctx_mem_info {
 	u32	qp_max_entries;
 	u16	qp_min_qp1_entries;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
index 2d3e962bdac3..d5c6e6a3d22d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
@@ -2,7 +2,7 @@
  *
  * Copyright (c) 2014-2016 Broadcom Corporation
  * Copyright (c) 2014-2018 Broadcom Limited
- * Copyright (c) 2018-2020 Broadcom Inc.
+ * Copyright (c) 2018-2021 Broadcom Inc.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -164,6 +164,7 @@ struct cmd_nums {
 	#define HWRM_VNIC_PLCMODES_CFG                    0x48UL
 	#define HWRM_VNIC_PLCMODES_QCFG                   0x49UL
 	#define HWRM_VNIC_QCAPS                           0x4aUL
+	#define HWRM_VNIC_UPDATE                          0x4bUL
 	#define HWRM_RING_ALLOC                           0x50UL
 	#define HWRM_RING_FREE                            0x51UL
 	#define HWRM_RING_CMPL_RING_QAGGINT_PARAMS        0x52UL
@@ -184,6 +185,9 @@ struct cmd_nums {
 	#define HWRM_QUEUE_MPLS_QCAPS                     0x80UL
 	#define HWRM_QUEUE_MPLSTC2PRI_QCFG                0x81UL
 	#define HWRM_QUEUE_MPLSTC2PRI_CFG                 0x82UL
+	#define HWRM_QUEUE_VLANPRI_QCAPS                  0x83UL
+	#define HWRM_QUEUE_VLANPRI2PRI_QCFG               0x84UL
+	#define HWRM_QUEUE_VLANPRI2PRI_CFG                0x85UL
 	#define HWRM_CFA_L2_FILTER_ALLOC                  0x90UL
 	#define HWRM_CFA_L2_FILTER_FREE                   0x91UL
 	#define HWRM_CFA_L2_FILTER_CFG                    0x92UL
@@ -217,6 +221,8 @@ struct cmd_nums {
 	#define HWRM_PORT_TX_FIR_CFG                      0xbbUL
 	#define HWRM_PORT_TX_FIR_QCFG                     0xbcUL
 	#define HWRM_PORT_ECN_QSTATS                      0xbdUL
+	#define HWRM_FW_LIVEPATCH_QUERY                   0xbeUL
+	#define HWRM_FW_LIVEPATCH                         0xbfUL
 	#define HWRM_FW_RESET                             0xc0UL
 	#define HWRM_FW_QSTATUS                           0xc1UL
 	#define HWRM_FW_HEALTH_CHECK                      0xc2UL
@@ -347,6 +353,8 @@ struct cmd_nums {
 	#define HWRM_FUNC_HOST_PF_IDS_QUERY               0x197UL
 	#define HWRM_FUNC_QSTATS_EXT                      0x198UL
 	#define HWRM_STAT_EXT_CTX_QUERY                   0x199UL
+	#define HWRM_FUNC_SPD_CFG                         0x19aUL
+	#define HWRM_FUNC_SPD_QCFG                        0x19bUL
 	#define HWRM_SELFTEST_QLIST                       0x200UL
 	#define HWRM_SELFTEST_EXEC                        0x201UL
 	#define HWRM_SELFTEST_IRQ                         0x202UL
@@ -359,6 +367,11 @@ struct cmd_nums {
 	#define HWRM_MFG_HDMA_TEST                        0x209UL
 	#define HWRM_MFG_FRU_EEPROM_WRITE                 0x20aUL
 	#define HWRM_MFG_FRU_EEPROM_READ                  0x20bUL
+	#define HWRM_MFG_SOC_IMAGE                        0x20cUL
+	#define HWRM_MFG_SOC_QSTATUS                      0x20dUL
+	#define HWRM_MFG_PARAM_SEEPROM_SYNC               0x20eUL
+	#define HWRM_MFG_PARAM_SEEPROM_READ               0x20fUL
+	#define HWRM_MFG_PARAM_SEEPROM_HEALTH             0x210UL
 	#define HWRM_TF                                   0x2bcUL
 	#define HWRM_TF_VERSION_GET                       0x2bdUL
 	#define HWRM_TF_SESSION_OPEN                      0x2c6UL
@@ -384,6 +397,7 @@ struct cmd_nums {
 	#define HWRM_TF_EXT_EM_QCFG                       0x2e9UL
 	#define HWRM_TF_EM_INSERT                         0x2eaUL
 	#define HWRM_TF_EM_DELETE                         0x2ebUL
+	#define HWRM_TF_EM_HASH_INSERT                    0x2ecUL
 	#define HWRM_TF_TCAM_SET                          0x2f8UL
 	#define HWRM_TF_TCAM_GET                          0x2f9UL
 	#define HWRM_TF_TCAM_MOVE                         0x2faUL
@@ -486,9 +500,9 @@ struct hwrm_err_output {
 #define HWRM_TARGET_ID_TOOLS 0xFFFD
 #define HWRM_VERSION_MAJOR 1
 #define HWRM_VERSION_MINOR 10
-#define HWRM_VERSION_UPDATE 1
-#define HWRM_VERSION_RSVD 68
-#define HWRM_VERSION_STR "1.10.1.68"
+#define HWRM_VERSION_UPDATE 2
+#define HWRM_VERSION_RSVD 11
+#define HWRM_VERSION_STR "1.10.2.11"
 
 /* hwrm_ver_get_input (size:192b/24B) */
 struct hwrm_ver_get_input {
@@ -563,8 +577,9 @@ struct hwrm_ver_get_output {
 	__le16	max_resp_len;
 	__le16	def_req_timeout;
 	u8	flags;
-	#define VER_GET_RESP_FLAGS_DEV_NOT_RDY       0x1UL
-	#define VER_GET_RESP_FLAGS_EXT_VER_AVAIL     0x2UL
+	#define VER_GET_RESP_FLAGS_DEV_NOT_RDY                   0x1UL
+	#define VER_GET_RESP_FLAGS_EXT_VER_AVAIL                 0x2UL
+	#define VER_GET_RESP_FLAGS_DEV_NOT_RDY_BACKING_STORE     0x4UL
 	u8	unused_0[2];
 	u8	always_1;
 	__le16	hwrm_intf_major;
@@ -708,6 +723,7 @@ struct hwrm_async_event_cmpl {
 	#define ASYNC_EVENT_CMPL_EVENT_ID_QUIESCE_DONE               0x3fUL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_DEFERRED_RESPONSE          0x40UL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_PFC_WATCHDOG_CFG_CHANGE    0x41UL
+	#define ASYNC_EVENT_CMPL_EVENT_ID_MAX_RGTR_EVENT_ID          0x42UL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_FW_TRACE_MSG               0xfeUL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_HWRM_ERROR                 0xffUL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_LAST                      ASYNC_EVENT_CMPL_EVENT_ID_HWRM_ERROR
@@ -815,6 +831,8 @@ struct hwrm_async_event_cmpl_reset_notify {
 	#define ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_ID_RESET_NOTIFY 0x8UL
 	#define ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_ID_LAST        ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_ID_RESET_NOTIFY
 	__le32	event_data2;
+	#define ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_DATA2_FW_STATUS_CODE_MASK 0xffffUL
+	#define ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_DATA2_FW_STATUS_CODE_SFT 0
 	u8	opaque_v;
 	#define ASYNC_EVENT_CMPL_RESET_NOTIFY_V          0x1UL
 	#define ASYNC_EVENT_CMPL_RESET_NOTIFY_OPAQUE_MASK 0xfeUL
@@ -832,7 +850,8 @@ struct hwrm_async_event_cmpl_reset_notify {
 	#define ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_DATA1_REASON_CODE_MANAGEMENT_RESET_REQUEST  (0x1UL << 8)
 	#define ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_DATA1_REASON_CODE_FW_EXCEPTION_FATAL        (0x2UL << 8)
 	#define ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_DATA1_REASON_CODE_FW_EXCEPTION_NON_FATAL    (0x3UL << 8)
-	#define ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_DATA1_REASON_CODE_LAST                     ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_DATA1_REASON_CODE_FW_EXCEPTION_NON_FATAL
+	#define ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_DATA1_REASON_CODE_FAST_RESET                (0x4UL << 8)
+	#define ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_DATA1_REASON_CODE_LAST                     ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_DATA1_REASON_CODE_FAST_RESET
 	#define ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_DATA1_DELAY_IN_100MS_TICKS_MASK           0xffff0000UL
 	#define ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_DATA1_DELAY_IN_100MS_TICKS_SFT            16
 };
@@ -1271,6 +1290,10 @@ struct hwrm_func_qcaps_output {
 	#define FUNC_QCAPS_RESP_FLAGS_EXT_TX_PROXY_SRC_INTF_OVERRIDE_SUPPORT     0x20UL
 	#define FUNC_QCAPS_RESP_FLAGS_EXT_SCHQ_SUPPORTED                         0x40UL
 	#define FUNC_QCAPS_RESP_FLAGS_EXT_PPP_PUSH_MODE_SUPPORTED                0x80UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_EVB_MODE_CFG_NOT_SUPPORTED             0x100UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_SOC_SPD_SUPPORTED                      0x200UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_FW_LIVEPATCH_SUPPORTED                 0x400UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_FAST_RESET_CAPABLE                     0x800UL
 	u8	max_schqs;
 	u8	mpc_chnls_cap;
 	#define FUNC_QCAPS_RESP_MPC_CHNLS_CAP_TCE         0x1UL
@@ -1315,6 +1338,7 @@ struct hwrm_func_qcfg_output {
 	#define FUNC_QCFG_RESP_FLAGS_HOT_RESET_ALLOWED            0x200UL
 	#define FUNC_QCFG_RESP_FLAGS_PPP_PUSH_MODE_ENABLED        0x400UL
 	#define FUNC_QCFG_RESP_FLAGS_RING_MONITOR_ENABLED         0x800UL
+	#define FUNC_QCFG_RESP_FLAGS_FAST_RESET_ALLOWED           0x1000UL
 	u8	mac_address[6];
 	__le16	pci_id;
 	__le16	alloc_rsscos_ctx;
@@ -1731,6 +1755,7 @@ struct hwrm_func_drv_rgtr_input {
 	#define FUNC_DRV_RGTR_REQ_FLAGS_HOT_RESET_SUPPORT          0x10UL
 	#define FUNC_DRV_RGTR_REQ_FLAGS_ERROR_RECOVERY_SUPPORT     0x20UL
 	#define FUNC_DRV_RGTR_REQ_FLAGS_MASTER_SUPPORT             0x40UL
+	#define FUNC_DRV_RGTR_REQ_FLAGS_FAST_RESET_SUPPORT         0x80UL
 	__le32	enables;
 	#define FUNC_DRV_RGTR_REQ_ENABLES_OS_TYPE             0x1UL
 	#define FUNC_DRV_RGTR_REQ_ENABLES_VER                 0x2UL
@@ -1993,7 +2018,7 @@ struct hwrm_func_backing_store_qcaps_input {
 	__le64	resp_addr;
 };
 
-/* hwrm_func_backing_store_qcaps_output (size:640b/80B) */
+/* hwrm_func_backing_store_qcaps_output (size:704b/88B) */
 struct hwrm_func_backing_store_qcaps_output {
 	__le16	error_code;
 	__le16	req_type;
@@ -2024,13 +2049,25 @@ struct hwrm_func_backing_store_qcaps_output {
 	__le16	mrav_num_entries_units;
 	u8	tqm_entries_multiple;
 	u8	ctx_kind_initializer;
-	__le32	rsvd;
-	__le16	rsvd1;
+	__le16	ctx_init_mask;
+	#define FUNC_BACKING_STORE_QCAPS_RESP_CTX_INIT_MASK_QP       0x1UL
+	#define FUNC_BACKING_STORE_QCAPS_RESP_CTX_INIT_MASK_SRQ      0x2UL
+	#define FUNC_BACKING_STORE_QCAPS_RESP_CTX_INIT_MASK_CQ       0x4UL
+	#define FUNC_BACKING_STORE_QCAPS_RESP_CTX_INIT_MASK_VNIC     0x8UL
+	#define FUNC_BACKING_STORE_QCAPS_RESP_CTX_INIT_MASK_STAT     0x10UL
+	#define FUNC_BACKING_STORE_QCAPS_RESP_CTX_INIT_MASK_MRAV     0x20UL
+	u8	qp_init_offset;
+	u8	srq_init_offset;
+	u8	cq_init_offset;
+	u8	vnic_init_offset;
 	u8	tqm_fp_rings_count;
+	u8	stat_init_offset;
+	u8	mrav_init_offset;
+	u8	rsvd[6];
 	u8	valid;
 };
 
-/* hwrm_func_backing_store_cfg_input (size:2048b/256B) */
+/* hwrm_func_backing_store_cfg_input (size:2432b/304B) */
 struct hwrm_func_backing_store_cfg_input {
 	__le16	req_type;
 	__le16	cmpl_ring;
@@ -2041,22 +2078,25 @@ struct hwrm_func_backing_store_cfg_input {
 	#define FUNC_BACKING_STORE_CFG_REQ_FLAGS_PREBOOT_MODE               0x1UL
 	#define FUNC_BACKING_STORE_CFG_REQ_FLAGS_MRAV_RESERVATION_SPLIT     0x2UL
 	__le32	enables;
-	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_QP            0x1UL
-	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_SRQ           0x2UL
-	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_CQ            0x4UL
-	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_VNIC          0x8UL
-	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_STAT          0x10UL
-	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_TQM_SP        0x20UL
-	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_TQM_RING0     0x40UL
-	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_TQM_RING1     0x80UL
-	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_TQM_RING2     0x100UL
-	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_TQM_RING3     0x200UL
-	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_TQM_RING4     0x400UL
-	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_TQM_RING5     0x800UL
-	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_TQM_RING6     0x1000UL
-	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_TQM_RING7     0x2000UL
-	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_MRAV          0x4000UL
-	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_TIM           0x8000UL
+	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_QP             0x1UL
+	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_SRQ            0x2UL
+	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_CQ             0x4UL
+	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_VNIC           0x8UL
+	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_STAT           0x10UL
+	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_TQM_SP         0x20UL
+	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_TQM_RING0      0x40UL
+	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_TQM_RING1      0x80UL
+	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_TQM_RING2      0x100UL
+	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_TQM_RING3      0x200UL
+	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_TQM_RING4      0x400UL
+	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_TQM_RING5      0x800UL
+	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_TQM_RING6      0x1000UL
+	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_TQM_RING7      0x2000UL
+	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_MRAV           0x4000UL
+	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_TIM            0x8000UL
+	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_TQM_RING8      0x10000UL
+	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_TQM_RING9      0x20000UL
+	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_TQM_RING10     0x40000UL
 	u8	qpc_pg_size_qpc_lvl;
 	#define FUNC_BACKING_STORE_CFG_REQ_QPC_LVL_MASK      0xfUL
 	#define FUNC_BACKING_STORE_CFG_REQ_QPC_LVL_SFT       0
@@ -2358,6 +2398,63 @@ struct hwrm_func_backing_store_cfg_input {
 	__le16	tqm_entry_size;
 	__le16	mrav_entry_size;
 	__le16	tim_entry_size;
+	u8	tqm_ring8_pg_size_tqm_ring_lvl;
+	#define FUNC_BACKING_STORE_CFG_REQ_RING8_TQM_RING_LVL_MASK      0xfUL
+	#define FUNC_BACKING_STORE_CFG_REQ_RING8_TQM_RING_LVL_SFT       0
+	#define FUNC_BACKING_STORE_CFG_REQ_RING8_TQM_RING_LVL_LVL_0       0x0UL
+	#define FUNC_BACKING_STORE_CFG_REQ_RING8_TQM_RING_LVL_LVL_1       0x1UL
+	#define FUNC_BACKING_STORE_CFG_REQ_RING8_TQM_RING_LVL_LVL_2       0x2UL
+	#define FUNC_BACKING_STORE_CFG_REQ_RING8_TQM_RING_LVL_LAST       FUNC_BACKING_STORE_CFG_REQ_RING8_TQM_RING_LVL_LVL_2
+	#define FUNC_BACKING_STORE_CFG_REQ_RING8_TQM_RING_PG_SIZE_MASK  0xf0UL
+	#define FUNC_BACKING_STORE_CFG_REQ_RING8_TQM_RING_PG_SIZE_SFT   4
+	#define FUNC_BACKING_STORE_CFG_REQ_RING8_TQM_RING_PG_SIZE_PG_4K   (0x0UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_RING8_TQM_RING_PG_SIZE_PG_8K   (0x1UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_RING8_TQM_RING_PG_SIZE_PG_64K  (0x2UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_RING8_TQM_RING_PG_SIZE_PG_2M   (0x3UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_RING8_TQM_RING_PG_SIZE_PG_8M   (0x4UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_RING8_TQM_RING_PG_SIZE_PG_1G   (0x5UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_RING8_TQM_RING_PG_SIZE_LAST   FUNC_BACKING_STORE_CFG_REQ_RING8_TQM_RING_PG_SIZE_PG_1G
+	u8	ring8_unused[3];
+	__le32	tqm_ring8_num_entries;
+	__le64	tqm_ring8_page_dir;
+	u8	tqm_ring9_pg_size_tqm_ring_lvl;
+	#define FUNC_BACKING_STORE_CFG_REQ_RING9_TQM_RING_LVL_MASK      0xfUL
+	#define FUNC_BACKING_STORE_CFG_REQ_RING9_TQM_RING_LVL_SFT       0
+	#define FUNC_BACKING_STORE_CFG_REQ_RING9_TQM_RING_LVL_LVL_0       0x0UL
+	#define FUNC_BACKING_STORE_CFG_REQ_RING9_TQM_RING_LVL_LVL_1       0x1UL
+	#define FUNC_BACKING_STORE_CFG_REQ_RING9_TQM_RING_LVL_LVL_2       0x2UL
+	#define FUNC_BACKING_STORE_CFG_REQ_RING9_TQM_RING_LVL_LAST       FUNC_BACKING_STORE_CFG_REQ_RING9_TQM_RING_LVL_LVL_2
+	#define FUNC_BACKING_STORE_CFG_REQ_RING9_TQM_RING_PG_SIZE_MASK  0xf0UL
+	#define FUNC_BACKING_STORE_CFG_REQ_RING9_TQM_RING_PG_SIZE_SFT   4
+	#define FUNC_BACKING_STORE_CFG_REQ_RING9_TQM_RING_PG_SIZE_PG_4K   (0x0UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_RING9_TQM_RING_PG_SIZE_PG_8K   (0x1UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_RING9_TQM_RING_PG_SIZE_PG_64K  (0x2UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_RING9_TQM_RING_PG_SIZE_PG_2M   (0x3UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_RING9_TQM_RING_PG_SIZE_PG_8M   (0x4UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_RING9_TQM_RING_PG_SIZE_PG_1G   (0x5UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_RING9_TQM_RING_PG_SIZE_LAST   FUNC_BACKING_STORE_CFG_REQ_RING9_TQM_RING_PG_SIZE_PG_1G
+	u8	ring9_unused[3];
+	__le32	tqm_ring9_num_entries;
+	__le64	tqm_ring9_page_dir;
+	u8	tqm_ring10_pg_size_tqm_ring_lvl;
+	#define FUNC_BACKING_STORE_CFG_REQ_RING10_TQM_RING_LVL_MASK      0xfUL
+	#define FUNC_BACKING_STORE_CFG_REQ_RING10_TQM_RING_LVL_SFT       0
+	#define FUNC_BACKING_STORE_CFG_REQ_RING10_TQM_RING_LVL_LVL_0       0x0UL
+	#define FUNC_BACKING_STORE_CFG_REQ_RING10_TQM_RING_LVL_LVL_1       0x1UL
+	#define FUNC_BACKING_STORE_CFG_REQ_RING10_TQM_RING_LVL_LVL_2       0x2UL
+	#define FUNC_BACKING_STORE_CFG_REQ_RING10_TQM_RING_LVL_LAST       FUNC_BACKING_STORE_CFG_REQ_RING10_TQM_RING_LVL_LVL_2
+	#define FUNC_BACKING_STORE_CFG_REQ_RING10_TQM_RING_PG_SIZE_MASK  0xf0UL
+	#define FUNC_BACKING_STORE_CFG_REQ_RING10_TQM_RING_PG_SIZE_SFT   4
+	#define FUNC_BACKING_STORE_CFG_REQ_RING10_TQM_RING_PG_SIZE_PG_4K   (0x0UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_RING10_TQM_RING_PG_SIZE_PG_8K   (0x1UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_RING10_TQM_RING_PG_SIZE_PG_64K  (0x2UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_RING10_TQM_RING_PG_SIZE_PG_2M   (0x3UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_RING10_TQM_RING_PG_SIZE_PG_8M   (0x4UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_RING10_TQM_RING_PG_SIZE_PG_1G   (0x5UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_RING10_TQM_RING_PG_SIZE_LAST   FUNC_BACKING_STORE_CFG_REQ_RING10_TQM_RING_PG_SIZE_PG_1G
+	u8	ring10_unused[3];
+	__le32	tqm_ring10_num_entries;
+	__le64	tqm_ring10_page_dir;
 };
 
 /* hwrm_func_backing_store_cfg_output (size:128b/16B) */
@@ -2930,6 +3027,7 @@ struct hwrm_port_phy_qcfg_output {
 	#define PORT_PHY_QCFG_RESP_DUPLEX_STATE_LAST PORT_PHY_QCFG_RESP_DUPLEX_STATE_FULL
 	u8	option_flags;
 	#define PORT_PHY_QCFG_RESP_OPTION_FLAGS_MEDIA_AUTO_DETECT     0x1UL
+	#define PORT_PHY_QCFG_RESP_OPTION_FLAGS_SIGNAL_MODE_KNOWN     0x2UL
 	char	phy_vendor_name[16];
 	char	phy_vendor_partnumber[16];
 	__le16	support_pam4_speeds;
@@ -3528,8 +3626,8 @@ struct hwrm_port_phy_qcaps_output {
 	#define PORT_PHY_QCAPS_RESP_FLAGS_SHARED_PHY_CFG_SUPPORTED         0x8UL
 	#define PORT_PHY_QCAPS_RESP_FLAGS_CUMULATIVE_COUNTERS_ON_RESET     0x10UL
 	#define PORT_PHY_QCAPS_RESP_FLAGS_LOCAL_LPBK_NOT_SUPPORTED         0x20UL
-	#define PORT_PHY_QCAPS_RESP_FLAGS_RSVD1_MASK                       0xc0UL
-	#define PORT_PHY_QCAPS_RESP_FLAGS_RSVD1_SFT                        6
+	#define PORT_PHY_QCAPS_RESP_FLAGS_FW_MANAGED_LINK_DOWN             0x40UL
+	#define PORT_PHY_QCAPS_RESP_FLAGS_RSVD1                            0x80UL
 	u8	port_cnt;
 	#define PORT_PHY_QCAPS_RESP_PORT_CNT_UNKNOWN 0x0UL
 	#define PORT_PHY_QCAPS_RESP_PORT_CNT_1       0x1UL
@@ -4119,7 +4217,10 @@ struct hwrm_queue_qportcfg_output {
 	#define QUEUE_QPORTCFG_RESP_QUEUE_ID7_SERVICE_PROFILE_LOSSLESS_NIC   0x3UL
 	#define QUEUE_QPORTCFG_RESP_QUEUE_ID7_SERVICE_PROFILE_UNKNOWN        0xffUL
 	#define QUEUE_QPORTCFG_RESP_QUEUE_ID7_SERVICE_PROFILE_LAST          QUEUE_QPORTCFG_RESP_QUEUE_ID7_SERVICE_PROFILE_UNKNOWN
-	u8	unused_0;
+	u8	queue_id0_service_profile_type;
+	#define QUEUE_QPORTCFG_RESP_QUEUE_ID0_SERVICE_PROFILE_TYPE_ROCE     0x1UL
+	#define QUEUE_QPORTCFG_RESP_QUEUE_ID0_SERVICE_PROFILE_TYPE_NIC      0x2UL
+	#define QUEUE_QPORTCFG_RESP_QUEUE_ID0_SERVICE_PROFILE_TYPE_CNP      0x4UL
 	char	qid0_name[16];
 	char	qid1_name[16];
 	char	qid2_name[16];
@@ -4128,7 +4229,34 @@ struct hwrm_queue_qportcfg_output {
 	char	qid5_name[16];
 	char	qid6_name[16];
 	char	qid7_name[16];
-	u8	unused_1[7];
+	u8	queue_id1_service_profile_type;
+	#define QUEUE_QPORTCFG_RESP_QUEUE_ID1_SERVICE_PROFILE_TYPE_ROCE     0x1UL
+	#define QUEUE_QPORTCFG_RESP_QUEUE_ID1_SERVICE_PROFILE_TYPE_NIC      0x2UL
+	#define QUEUE_QPORTCFG_RESP_QUEUE_ID1_SERVICE_PROFILE_TYPE_CNP      0x4UL
+	u8	queue_id2_service_profile_type;
+	#define QUEUE_QPORTCFG_RESP_QUEUE_ID2_SERVICE_PROFILE_TYPE_ROCE     0x1UL
+	#define QUEUE_QPORTCFG_RESP_QUEUE_ID2_SERVICE_PROFILE_TYPE_NIC      0x2UL
+	#define QUEUE_QPORTCFG_RESP_QUEUE_ID2_SERVICE_PROFILE_TYPE_CNP      0x4UL
+	u8	queue_id3_service_profile_type;
+	#define QUEUE_QPORTCFG_RESP_QUEUE_ID3_SERVICE_PROFILE_TYPE_ROCE     0x1UL
+	#define QUEUE_QPORTCFG_RESP_QUEUE_ID3_SERVICE_PROFILE_TYPE_NIC      0x2UL
+	#define QUEUE_QPORTCFG_RESP_QUEUE_ID3_SERVICE_PROFILE_TYPE_CNP      0x4UL
+	u8	queue_id4_service_profile_type;
+	#define QUEUE_QPORTCFG_RESP_QUEUE_ID4_SERVICE_PROFILE_TYPE_ROCE     0x1UL
+	#define QUEUE_QPORTCFG_RESP_QUEUE_ID4_SERVICE_PROFILE_TYPE_NIC      0x2UL
+	#define QUEUE_QPORTCFG_RESP_QUEUE_ID4_SERVICE_PROFILE_TYPE_CNP      0x4UL
+	u8	queue_id5_service_profile_type;
+	#define QUEUE_QPORTCFG_RESP_QUEUE_ID5_SERVICE_PROFILE_TYPE_ROCE     0x1UL
+	#define QUEUE_QPORTCFG_RESP_QUEUE_ID5_SERVICE_PROFILE_TYPE_NIC      0x2UL
+	#define QUEUE_QPORTCFG_RESP_QUEUE_ID5_SERVICE_PROFILE_TYPE_CNP      0x4UL
+	u8	queue_id6_service_profile_type;
+	#define QUEUE_QPORTCFG_RESP_QUEUE_ID6_SERVICE_PROFILE_TYPE_ROCE     0x1UL
+	#define QUEUE_QPORTCFG_RESP_QUEUE_ID6_SERVICE_PROFILE_TYPE_NIC      0x2UL
+	#define QUEUE_QPORTCFG_RESP_QUEUE_ID6_SERVICE_PROFILE_TYPE_CNP      0x4UL
+	u8	queue_id7_service_profile_type;
+	#define QUEUE_QPORTCFG_RESP_QUEUE_ID7_SERVICE_PROFILE_TYPE_ROCE     0x1UL
+	#define QUEUE_QPORTCFG_RESP_QUEUE_ID7_SERVICE_PROFILE_TYPE_NIC      0x2UL
+	#define QUEUE_QPORTCFG_RESP_QUEUE_ID7_SERVICE_PROFILE_TYPE_CNP      0x4UL
 	u8	valid;
 };
 
@@ -5142,8 +5270,10 @@ struct hwrm_vnic_alloc_input {
 	__le16	target_id;
 	__le64	resp_addr;
 	__le32	flags;
-	#define VNIC_ALLOC_REQ_FLAGS_DEFAULT     0x1UL
-	u8	unused_0[4];
+	#define VNIC_ALLOC_REQ_FLAGS_DEFAULT                  0x1UL
+	#define VNIC_ALLOC_REQ_FLAGS_VIRTIO_NET_FID_VALID     0x2UL
+	__le16	virtio_net_fid;
+	u8	unused_0[2];
 };
 
 /* hwrm_vnic_alloc_output (size:128b/16B) */
@@ -5260,6 +5390,8 @@ struct hwrm_vnic_qcaps_output {
 	#define VNIC_QCAPS_RESP_FLAGS_OUTERMOST_RSS_CAP                   0x80UL
 	#define VNIC_QCAPS_RESP_FLAGS_COS_ASSIGNMENT_CAP                  0x100UL
 	#define VNIC_QCAPS_RESP_FLAGS_RX_CMPL_V2_CAP                      0x200UL
+	#define VNIC_QCAPS_RESP_FLAGS_VNIC_STATE_CAP                      0x400UL
+	#define VNIC_QCAPS_RESP_FLAGS_VIRTIO_NET_VNIC_ALLOC_CAP           0x800UL
 	__le16	max_aggs_supported;
 	u8	unused_1[5];
 	u8	valid;
@@ -5585,7 +5717,11 @@ struct hwrm_ring_alloc_output {
 	__le16	resp_len;
 	__le16	ring_id;
 	__le16	logical_ring_id;
-	u8	unused_0[3];
+	u8	push_buffer_index;
+	#define RING_ALLOC_RESP_PUSH_BUFFER_INDEX_PING_BUFFER 0x0UL
+	#define RING_ALLOC_RESP_PUSH_BUFFER_INDEX_PONG_BUFFER 0x1UL
+	#define RING_ALLOC_RESP_PUSH_BUFFER_INDEX_LAST       RING_ALLOC_RESP_PUSH_BUFFER_INDEX_PONG_BUFFER
+	u8	unused_0[2];
 	u8	valid;
 };
 
@@ -5644,7 +5780,11 @@ struct hwrm_ring_reset_output {
 	__le16	req_type;
 	__le16	seq_id;
 	__le16	resp_len;
-	u8	unused_0[4];
+	u8	push_buffer_index;
+	#define RING_RESET_RESP_PUSH_BUFFER_INDEX_PING_BUFFER 0x0UL
+	#define RING_RESET_RESP_PUSH_BUFFER_INDEX_PONG_BUFFER 0x1UL
+	#define RING_RESET_RESP_PUSH_BUFFER_INDEX_LAST       RING_RESET_RESP_PUSH_BUFFER_INDEX_PONG_BUFFER
+	u8	unused_0[3];
 	u8	consumer_idx[3];
 	u8	valid;
 };
@@ -6988,21 +7128,23 @@ struct hwrm_cfa_adv_flow_mgnt_qcaps_output {
 	__le16	seq_id;
 	__le16	resp_len;
 	__le32	flags;
-	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_FLOW_HND_16BIT_SUPPORTED                  0x1UL
-	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_FLOW_HND_64BIT_SUPPORTED                  0x2UL
-	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_FLOW_BATCH_DELETE_SUPPORTED               0x4UL
-	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_FLOW_RESET_ALL_SUPPORTED                  0x8UL
-	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_NTUPLE_FLOW_DEST_FUNC_SUPPORTED           0x10UL
-	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_TX_EEM_FLOW_SUPPORTED                     0x20UL
-	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_RX_EEM_FLOW_SUPPORTED                     0x40UL
-	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_FLOW_COUNTER_ALLOC_SUPPORTED              0x80UL
-	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_RFS_RING_TBL_IDX_SUPPORTED                0x100UL
-	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_UNTAGGED_VLAN_SUPPORTED                   0x200UL
-	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_XDP_SUPPORTED                             0x400UL
-	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_L2_HEADER_SOURCE_FIELDS_SUPPORTED         0x800UL
-	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_NTUPLE_FLOW_RX_ARP_SUPPORTED              0x1000UL
-	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_RFS_RING_TBL_IDX_V2_SUPPORTED             0x2000UL
-	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_NTUPLE_FLOW_RX_ETHERTYPE_IP_SUPPORTED     0x4000UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_FLOW_HND_16BIT_SUPPORTED                     0x1UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_FLOW_HND_64BIT_SUPPORTED                     0x2UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_FLOW_BATCH_DELETE_SUPPORTED                  0x4UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_FLOW_RESET_ALL_SUPPORTED                     0x8UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_NTUPLE_FLOW_DEST_FUNC_SUPPORTED              0x10UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_TX_EEM_FLOW_SUPPORTED                        0x20UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_RX_EEM_FLOW_SUPPORTED                        0x40UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_FLOW_COUNTER_ALLOC_SUPPORTED                 0x80UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_RFS_RING_TBL_IDX_SUPPORTED                   0x100UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_UNTAGGED_VLAN_SUPPORTED                      0x200UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_XDP_SUPPORTED                                0x400UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_L2_HEADER_SOURCE_FIELDS_SUPPORTED            0x800UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_NTUPLE_FLOW_RX_ARP_SUPPORTED                 0x1000UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_RFS_RING_TBL_IDX_V2_SUPPORTED                0x2000UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_NTUPLE_FLOW_RX_ETHERTYPE_IP_SUPPORTED        0x4000UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_TRUFLOW_CAPABLE                              0x8000UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_L2_FILTER_TRAFFIC_TYPE_L2_ROCE_SUPPORTED     0x10000UL
 	u8	unused_0[3];
 	u8	valid;
 };
@@ -7472,7 +7614,8 @@ struct hwrm_struct_hdr {
 	#define STRUCT_HDR_STRUCT_ID_AFM_OPAQUE         0x1UL
 	#define STRUCT_HDR_STRUCT_ID_PORT_DESCRIPTION   0xaUL
 	#define STRUCT_HDR_STRUCT_ID_RSS_V2             0x64UL
-	#define STRUCT_HDR_STRUCT_ID_LAST              STRUCT_HDR_STRUCT_ID_RSS_V2
+	#define STRUCT_HDR_STRUCT_ID_MSIX_PER_VF        0xc8UL
+	#define STRUCT_HDR_STRUCT_ID_LAST              STRUCT_HDR_STRUCT_ID_MSIX_PER_VF
 	__le16	len;
 	u8	version;
 	u8	count;
@@ -8000,6 +8143,9 @@ struct hwrm_dbg_coredump_initiate_output {
 struct coredump_data_hdr {
 	__le32	address;
 	__le32	flags_length;
+	#define COREDUMP_DATA_HDR_FLAGS_LENGTH_ACTUAL_LEN_MASK     0xffffffUL
+	#define COREDUMP_DATA_HDR_FLAGS_LENGTH_ACTUAL_LEN_SFT      0
+	#define COREDUMP_DATA_HDR_FLAGS_LENGTH_INDIRECT_ACCESS     0x1000000UL
 	__le32	instance;
 	__le32	next_offset;
 };
@@ -8669,7 +8815,6 @@ struct hcomm_status {
 	#define HCOMM_STATUS_TRUE_OFFSET_MASK        0xfffffffcUL
 	#define HCOMM_STATUS_TRUE_OFFSET_SFT         2
 };
-
 #define HCOMM_STATUS_STRUCT_LOC 0x31001F0UL
 
 #endif /* _BNXT_HSI_H_ */
-- 
2.18.1

