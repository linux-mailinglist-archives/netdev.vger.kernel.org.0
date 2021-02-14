Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D1331B329
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 00:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhBNXF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 18:05:58 -0500
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:45534 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229945AbhBNXFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 18:05:54 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 27B2C7A22;
        Sun, 14 Feb 2021 15:05:02 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 27B2C7A22
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1613343902;
        bh=ehArEIyms1dYe3mbXOPBQ9nXOtR3+VlJJhhL2t1nxBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E9e5dbA+Z9akCvZRkD6Hft29uaEyuADwE7ePyKJ9BC4QcnPKTw/4gfP22VJpD/tZL
         v7gnl9r78IAJ5oS4N0SZVfYSY5BhplB5NtWsK6p5WMrTv2AH7gYYpmfmXGwCRY4RJf
         wrJpZy4eKuqp6mYYeF/73owipg26NzRI3ckifNR0=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 1/7] bnxt_en: Update firmware interface spec to 1.10.2.16.
Date:   Sun, 14 Feb 2021 18:04:55 -0500
Message-Id: <1613343901-6629-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1613343901-6629-1-git-send-email-michael.chan@broadcom.com>
References: <1613343901-6629-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main changes are the echo request/response from firmware for error
detection and the NO_FCS feature to transmit frames without FCS.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h | 105 ++++++++++++++++--
 2 files changed, 96 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 4ef6888acdc6..36007b0d1177 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -18,7 +18,7 @@
  */
 #define DRV_VER_MAJ	1
 #define DRV_VER_MIN	10
-#define DRV_VER_UPD	1
+#define DRV_VER_UPD	2
 
 #include <linux/ethtool.h>
 #include <linux/interrupt.h>
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
index d5c6e6a3d22d..6199f125bc13 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
@@ -103,6 +103,7 @@ struct hwrm_short_input {
 struct cmd_nums {
 	__le16	req_type;
 	#define HWRM_VER_GET                              0x0UL
+	#define HWRM_FUNC_ECHO_RESPONSE                   0xbUL
 	#define HWRM_ERROR_RECOVERY_QCFG                  0xcUL
 	#define HWRM_FUNC_DRV_IF_CHANGE                   0xdUL
 	#define HWRM_FUNC_BUF_UNRGTR                      0xeUL
@@ -501,8 +502,8 @@ struct hwrm_err_output {
 #define HWRM_VERSION_MAJOR 1
 #define HWRM_VERSION_MINOR 10
 #define HWRM_VERSION_UPDATE 2
-#define HWRM_VERSION_RSVD 11
-#define HWRM_VERSION_STR "1.10.2.11"
+#define HWRM_VERSION_RSVD 16
+#define HWRM_VERSION_STR "1.10.2.16"
 
 /* hwrm_ver_get_input (size:192b/24B) */
 struct hwrm_ver_get_input {
@@ -723,7 +724,8 @@ struct hwrm_async_event_cmpl {
 	#define ASYNC_EVENT_CMPL_EVENT_ID_QUIESCE_DONE               0x3fUL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_DEFERRED_RESPONSE          0x40UL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_PFC_WATCHDOG_CFG_CHANGE    0x41UL
-	#define ASYNC_EVENT_CMPL_EVENT_ID_MAX_RGTR_EVENT_ID          0x42UL
+	#define ASYNC_EVENT_CMPL_EVENT_ID_ECHO_REQUEST               0x42UL
+	#define ASYNC_EVENT_CMPL_EVENT_ID_MAX_RGTR_EVENT_ID          0x43UL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_FW_TRACE_MSG               0xfeUL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_HWRM_ERROR                 0xffUL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_LAST                      ASYNC_EVENT_CMPL_EVENT_ID_HWRM_ERROR
@@ -1052,6 +1054,26 @@ struct hwrm_async_event_cmpl_deferred_response {
 	__le32	event_data1;
 };
 
+/* hwrm_async_event_cmpl_echo_request (size:128b/16B) */
+struct hwrm_async_event_cmpl_echo_request {
+	__le16	type;
+	#define ASYNC_EVENT_CMPL_ECHO_REQUEST_TYPE_MASK            0x3fUL
+	#define ASYNC_EVENT_CMPL_ECHO_REQUEST_TYPE_SFT             0
+	#define ASYNC_EVENT_CMPL_ECHO_REQUEST_TYPE_HWRM_ASYNC_EVENT  0x2eUL
+	#define ASYNC_EVENT_CMPL_ECHO_REQUEST_TYPE_LAST             ASYNC_EVENT_CMPL_ECHO_REQUEST_TYPE_HWRM_ASYNC_EVENT
+	__le16	event_id;
+	#define ASYNC_EVENT_CMPL_ECHO_REQUEST_EVENT_ID_ECHO_REQUEST 0x42UL
+	#define ASYNC_EVENT_CMPL_ECHO_REQUEST_EVENT_ID_LAST        ASYNC_EVENT_CMPL_ECHO_REQUEST_EVENT_ID_ECHO_REQUEST
+	__le32	event_data2;
+	u8	opaque_v;
+	#define ASYNC_EVENT_CMPL_ECHO_REQUEST_V          0x1UL
+	#define ASYNC_EVENT_CMPL_ECHO_REQUEST_OPAQUE_MASK 0xfeUL
+	#define ASYNC_EVENT_CMPL_ECHO_REQUEST_OPAQUE_SFT 1
+	u8	timestamp_lo;
+	__le16	timestamp_hi;
+	__le32	event_data1;
+};
+
 /* hwrm_func_reset_input (size:192b/24B) */
 struct hwrm_func_reset_input {
 	__le16	req_type;
@@ -1294,6 +1316,10 @@ struct hwrm_func_qcaps_output {
 	#define FUNC_QCAPS_RESP_FLAGS_EXT_SOC_SPD_SUPPORTED                      0x200UL
 	#define FUNC_QCAPS_RESP_FLAGS_EXT_FW_LIVEPATCH_SUPPORTED                 0x400UL
 	#define FUNC_QCAPS_RESP_FLAGS_EXT_FAST_RESET_CAPABLE                     0x800UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_TX_METADATA_CFG_CAPABLE                0x1000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_NVM_OPTION_ACTION_SUPPORTED            0x2000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_BD_METADATA_SUPPORTED                  0x4000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_ECHO_REQUEST_SUPPORTED                 0x8000UL
 	u8	max_schqs;
 	u8	mpc_chnls_cap;
 	#define FUNC_QCAPS_RESP_MPC_CHNLS_CAP_TCE         0x1UL
@@ -1339,6 +1365,7 @@ struct hwrm_func_qcfg_output {
 	#define FUNC_QCFG_RESP_FLAGS_PPP_PUSH_MODE_ENABLED        0x400UL
 	#define FUNC_QCFG_RESP_FLAGS_RING_MONITOR_ENABLED         0x800UL
 	#define FUNC_QCFG_RESP_FLAGS_FAST_RESET_ALLOWED           0x1000UL
+	#define FUNC_QCFG_RESP_FLAGS_MULTI_ROOT                   0x2000UL
 	u8	mac_address[6];
 	__le16	pci_id;
 	__le16	alloc_rsscos_ctx;
@@ -1474,6 +1501,8 @@ struct hwrm_func_cfg_input {
 	#define FUNC_CFG_REQ_FLAGS_HOT_RESET_IF_EN_DIS            0x4000000UL
 	#define FUNC_CFG_REQ_FLAGS_PPP_PUSH_MODE_ENABLE           0x8000000UL
 	#define FUNC_CFG_REQ_FLAGS_PPP_PUSH_MODE_DISABLE          0x10000000UL
+	#define FUNC_CFG_REQ_FLAGS_BD_METADATA_ENABLE             0x20000000UL
+	#define FUNC_CFG_REQ_FLAGS_BD_METADATA_DISABLE            0x40000000UL
 	__le32	enables;
 	#define FUNC_CFG_REQ_ENABLES_MTU                      0x1UL
 	#define FUNC_CFG_REQ_ENABLES_MRU                      0x2UL
@@ -2063,8 +2092,32 @@ struct hwrm_func_backing_store_qcaps_output {
 	u8	tqm_fp_rings_count;
 	u8	stat_init_offset;
 	u8	mrav_init_offset;
-	u8	rsvd[6];
-	u8	valid;
+	u8	tqm_fp_rings_count_ext;
+	u8	rsvd[5];
+	u8	valid;
+};
+
+/* tqm_fp_ring_cfg (size:128b/16B) */
+struct tqm_fp_ring_cfg {
+	u8	tqm_ring_pg_size_tqm_ring_lvl;
+	#define TQM_FP_RING_CFG_TQM_RING_CFG_TQM_RING_LVL_MASK      0xfUL
+	#define TQM_FP_RING_CFG_TQM_RING_CFG_TQM_RING_LVL_SFT       0
+	#define TQM_FP_RING_CFG_TQM_RING_CFG_TQM_RING_LVL_LVL_0       0x0UL
+	#define TQM_FP_RING_CFG_TQM_RING_CFG_TQM_RING_LVL_LVL_1       0x1UL
+	#define TQM_FP_RING_CFG_TQM_RING_CFG_TQM_RING_LVL_LVL_2       0x2UL
+	#define TQM_FP_RING_CFG_TQM_RING_CFG_TQM_RING_LVL_LAST       TQM_FP_RING_CFG_TQM_RING_CFG_TQM_RING_LVL_LVL_2
+	#define TQM_FP_RING_CFG_TQM_RING_CFG_TQM_RING_PG_SIZE_MASK  0xf0UL
+	#define TQM_FP_RING_CFG_TQM_RING_CFG_TQM_RING_PG_SIZE_SFT   4
+	#define TQM_FP_RING_CFG_TQM_RING_CFG_TQM_RING_PG_SIZE_PG_4K   (0x0UL << 4)
+	#define TQM_FP_RING_CFG_TQM_RING_CFG_TQM_RING_PG_SIZE_PG_8K   (0x1UL << 4)
+	#define TQM_FP_RING_CFG_TQM_RING_CFG_TQM_RING_PG_SIZE_PG_64K  (0x2UL << 4)
+	#define TQM_FP_RING_CFG_TQM_RING_CFG_TQM_RING_PG_SIZE_PG_2M   (0x3UL << 4)
+	#define TQM_FP_RING_CFG_TQM_RING_CFG_TQM_RING_PG_SIZE_PG_8M   (0x4UL << 4)
+	#define TQM_FP_RING_CFG_TQM_RING_CFG_TQM_RING_PG_SIZE_PG_1G   (0x5UL << 4)
+	#define TQM_FP_RING_CFG_TQM_RING_CFG_TQM_RING_PG_SIZE_LAST   TQM_FP_RING_CFG_TQM_RING_CFG_TQM_RING_PG_SIZE_PG_1G
+	u8	unused[3];
+	__le32	tqm_ring_num_entries;
+	__le64	tqm_ring_page_dir;
 };
 
 /* hwrm_func_backing_store_cfg_input (size:2432b/304B) */
@@ -2560,6 +2613,27 @@ struct hwrm_error_recovery_qcfg_output {
 	u8	valid;
 };
 
+/* hwrm_func_echo_response_input (size:192b/24B) */
+struct hwrm_func_echo_response_input {
+	__le16	req_type;
+	__le16	cmpl_ring;
+	__le16	seq_id;
+	__le16	target_id;
+	__le64	resp_addr;
+	__le32	event_data1;
+	__le32	event_data2;
+};
+
+/* hwrm_func_echo_response_output (size:128b/16B) */
+struct hwrm_func_echo_response_output {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
+	u8	unused_0[7];
+	u8	valid;
+};
+
 /* hwrm_func_drv_if_change_input (size:192b/24B) */
 struct hwrm_func_drv_if_change_input {
 	__le16	req_type;
@@ -3627,7 +3701,7 @@ struct hwrm_port_phy_qcaps_output {
 	#define PORT_PHY_QCAPS_RESP_FLAGS_CUMULATIVE_COUNTERS_ON_RESET     0x10UL
 	#define PORT_PHY_QCAPS_RESP_FLAGS_LOCAL_LPBK_NOT_SUPPORTED         0x20UL
 	#define PORT_PHY_QCAPS_RESP_FLAGS_FW_MANAGED_LINK_DOWN             0x40UL
-	#define PORT_PHY_QCAPS_RESP_FLAGS_RSVD1                            0x80UL
+	#define PORT_PHY_QCAPS_RESP_FLAGS_NO_FCS                           0x80UL
 	u8	port_cnt;
 	#define PORT_PHY_QCAPS_RESP_PORT_CNT_UNKNOWN 0x0UL
 	#define PORT_PHY_QCAPS_RESP_PORT_CNT_1       0x1UL
@@ -5392,6 +5466,7 @@ struct hwrm_vnic_qcaps_output {
 	#define VNIC_QCAPS_RESP_FLAGS_RX_CMPL_V2_CAP                      0x200UL
 	#define VNIC_QCAPS_RESP_FLAGS_VNIC_STATE_CAP                      0x400UL
 	#define VNIC_QCAPS_RESP_FLAGS_VIRTIO_NET_VNIC_ALLOC_CAP           0x800UL
+	#define VNIC_QCAPS_RESP_FLAGS_METADATA_FORMAT_CAP                 0x1000UL
 	__le16	max_aggs_supported;
 	u8	unused_1[5];
 	u8	valid;
@@ -5725,7 +5800,7 @@ struct hwrm_ring_alloc_output {
 	u8	valid;
 };
 
-/* hwrm_ring_free_input (size:192b/24B) */
+/* hwrm_ring_free_input (size:256b/32B) */
 struct hwrm_ring_free_input {
 	__le16	req_type;
 	__le16	cmpl_ring;
@@ -5740,9 +5815,13 @@ struct hwrm_ring_free_input {
 	#define RING_FREE_REQ_RING_TYPE_RX_AGG    0x4UL
 	#define RING_FREE_REQ_RING_TYPE_NQ        0x5UL
 	#define RING_FREE_REQ_RING_TYPE_LAST     RING_FREE_REQ_RING_TYPE_NQ
-	u8	unused_0;
+	u8	flags;
+	#define RING_FREE_REQ_FLAGS_VIRTIO_RING_VALID 0x1UL
+	#define RING_FREE_REQ_FLAGS_LAST             RING_FREE_REQ_FLAGS_VIRTIO_RING_VALID
 	__le16	ring_id;
-	u8	unused_1[4];
+	__le32	prod_idx;
+	__le32	opaque;
+	__le32	unused_1;
 };
 
 /* hwrm_ring_free_output (size:128b/16B) */
@@ -7562,7 +7641,13 @@ struct hwrm_fw_qstatus_output {
 	#define FW_QSTATUS_RESP_SELFRST_STATUS_SELFRSTPCIERST 0x2UL
 	#define FW_QSTATUS_RESP_SELFRST_STATUS_SELFRSTPOWER   0x3UL
 	#define FW_QSTATUS_RESP_SELFRST_STATUS_LAST          FW_QSTATUS_RESP_SELFRST_STATUS_SELFRSTPOWER
-	u8	unused_0[6];
+	u8	nvm_option_action_status;
+	#define FW_QSTATUS_RESP_NVM_OPTION_ACTION_STATUS_NVMOPT_ACTION_NONE     0x0UL
+	#define FW_QSTATUS_RESP_NVM_OPTION_ACTION_STATUS_NVMOPT_ACTION_HOTRESET 0x1UL
+	#define FW_QSTATUS_RESP_NVM_OPTION_ACTION_STATUS_NVMOPT_ACTION_WARMBOOT 0x2UL
+	#define FW_QSTATUS_RESP_NVM_OPTION_ACTION_STATUS_NVMOPT_ACTION_COLDBOOT 0x3UL
+	#define FW_QSTATUS_RESP_NVM_OPTION_ACTION_STATUS_LAST                  FW_QSTATUS_RESP_NVM_OPTION_ACTION_STATUS_NVMOPT_ACTION_COLDBOOT
+	u8	unused_0[5];
 	u8	valid;
 };
 
-- 
2.18.1

