Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE3FD7894A
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 12:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbfG2KLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 06:11:16 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38888 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbfG2KLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 06:11:15 -0400
Received: by mail-pg1-f196.google.com with SMTP id f5so19187086pgu.5
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 03:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nT+dl/aOweGKKhnDNhaYdl7XPDo2BKtZ5ARw8LsxLJ4=;
        b=ai3vyKBZMIKfa8uVcgVHGAoHxS0xn31IykSmmWcjXpJxk0SOxXQ4N/dC+84jBiPmr6
         nh1w1/nk8MgtzU1242lu6WnoZl5kBBxK5A0IOdk1zpqGQ7T/7jToBcu4R5Na0KVl0AOI
         ez9he7t7GQ0TgoU6z0nTAXiy9gB16RGkGaeXU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nT+dl/aOweGKKhnDNhaYdl7XPDo2BKtZ5ARw8LsxLJ4=;
        b=h02xHo/yNibxd4SbeIvA1pyT0WS2vXHqJ2glJnhiZQOwyjD/df9nhPa3Kzggeuap3S
         53qCCAxsFxzGwYfWG9t+XxPguaZh67KHh1KcO91yNiUO2OXRGghfzlBm5l4d7RyY97l6
         anetrTNfd0VmNfJuqACoxcLL77bCwwPPhGo5+tYb+7khlUE+Il1hbcBAasMYHgIwbRoN
         hzoMqrptgBNnndxjuhE1sjEtvRBg1uofl90dRVovUjAScQ0TsOZFRBkAITyXsyYHVtTK
         pZsv7c5LZBUYM56uxsx0VunZBIC9hfs42NPiY9SJJ3lHXmlbJc3MSDBs0Sgo8NcR1IJb
         PF9g==
X-Gm-Message-State: APjAAAUO6eM7BgGALRVTdBgBZ99/ISiyDccFkYQ/sD10xklE93lgvfgo
        aGhx+Ga1bt/+0a6Add+0A33mPbmcgBQ=
X-Google-Smtp-Source: APXvYqwhXltsa+14vkE4LYvLrlxvWovM3cMnXxuACSKrWXuK9XuDKR5cPAJmrrMk/Xtr455Z1Uf9Tw==
X-Received: by 2002:a63:1765:: with SMTP id 37mr34844003pgx.447.1564395074487;
        Mon, 29 Jul 2019 03:11:14 -0700 (PDT)
Received: from localhost.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e124sm99045812pfh.181.2019.07.29.03.11.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 03:11:13 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 01/16] bnxt_en: Update firmware interface spec. to 1.10.0.89.
Date:   Mon, 29 Jul 2019 06:10:18 -0400
Message-Id: <1564395033-19511-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
References: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Among the changes are new CoS discard counters and new ctx_hw_stats_ext
struct for the latest 5750X B0 chips.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  15 +++
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h     | 109 ++++++++++++++++++----
 2 files changed, 108 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index c7ee63d..1eb590e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -207,6 +207,20 @@ static int bnxt_set_coalesce(struct net_device *dev,
 	BNXT_TX_STATS_EXT_COS_ENTRY(6),				\
 	BNXT_TX_STATS_EXT_COS_ENTRY(7)				\
 
+#define BNXT_RX_STATS_EXT_DISCARD_COS_ENTRY(n)			\
+	BNXT_RX_STATS_EXT_ENTRY(rx_discard_bytes_cos##n),	\
+	BNXT_RX_STATS_EXT_ENTRY(rx_discard_packets_cos##n)
+
+#define BNXT_RX_STATS_EXT_DISCARD_COS_ENTRIES				\
+	BNXT_RX_STATS_EXT_DISCARD_COS_ENTRY(0),				\
+	BNXT_RX_STATS_EXT_DISCARD_COS_ENTRY(1),				\
+	BNXT_RX_STATS_EXT_DISCARD_COS_ENTRY(2),				\
+	BNXT_RX_STATS_EXT_DISCARD_COS_ENTRY(3),				\
+	BNXT_RX_STATS_EXT_DISCARD_COS_ENTRY(4),				\
+	BNXT_RX_STATS_EXT_DISCARD_COS_ENTRY(5),				\
+	BNXT_RX_STATS_EXT_DISCARD_COS_ENTRY(6),				\
+	BNXT_RX_STATS_EXT_DISCARD_COS_ENTRY(7)
+
 #define BNXT_RX_STATS_PRI_ENTRY(counter, n)		\
 	{ BNXT_RX_STATS_EXT_OFFSET(counter##_cos0),	\
 	  __stringify(counter##_pri##n) }
@@ -352,6 +366,7 @@ static const struct {
 	BNXT_RX_STATS_EXT_ENTRY(rx_buffer_passed_threshold),
 	BNXT_RX_STATS_EXT_ENTRY(rx_pcs_symbol_err),
 	BNXT_RX_STATS_EXT_ENTRY(rx_corrected_bits),
+	BNXT_RX_STATS_EXT_DISCARD_COS_ENTRIES,
 };
 
 static const struct {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
index 12bbb2a..2cdef75 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
@@ -1,7 +1,8 @@
 /* Broadcom NetXtreme-C/E network driver.
  *
  * Copyright (c) 2014-2016 Broadcom Corporation
- * Copyright (c) 2016-2019 Broadcom Limited
+ * Copyright (c) 2014-2018 Broadcom Limited
+ * Copyright (c) 2018-2019 Broadcom Inc.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -39,15 +40,15 @@ struct hwrm_resp_hdr {
 #define TLV_TYPE_ROCE_SP_COMMAND                 0x3UL
 #define TLV_TYPE_QUERY_ROCE_CC_GEN1              0x4UL
 #define TLV_TYPE_MODIFY_ROCE_CC_GEN1             0x5UL
-#define TLV_TYPE_ENGINE_CKV_DEVICE_SERIAL_NUMBER 0x8001UL
-#define TLV_TYPE_ENGINE_CKV_NONCE                0x8002UL
+#define TLV_TYPE_ENGINE_CKV_ALIAS_ECC_PUBLIC_KEY 0x8001UL
 #define TLV_TYPE_ENGINE_CKV_IV                   0x8003UL
 #define TLV_TYPE_ENGINE_CKV_AUTH_TAG             0x8004UL
 #define TLV_TYPE_ENGINE_CKV_CIPHERTEXT           0x8005UL
 #define TLV_TYPE_ENGINE_CKV_ALGORITHMS           0x8006UL
-#define TLV_TYPE_ENGINE_CKV_ECC_PUBLIC_KEY       0x8007UL
+#define TLV_TYPE_ENGINE_CKV_HOST_ECC_PUBLIC_KEY  0x8007UL
 #define TLV_TYPE_ENGINE_CKV_ECDSA_SIGNATURE      0x8008UL
-#define TLV_TYPE_LAST                           TLV_TYPE_ENGINE_CKV_ECDSA_SIGNATURE
+#define TLV_TYPE_ENGINE_CKV_SRT_ECC_PUBLIC_KEY   0x8009UL
+#define TLV_TYPE_LAST                           TLV_TYPE_ENGINE_CKV_SRT_ECC_PUBLIC_KEY
 
 
 /* tlv (size:64b/8B) */
@@ -267,7 +268,6 @@ struct cmd_nums {
 	#define HWRM_CFA_EEM_OP                           0x123UL
 	#define HWRM_CFA_ADV_FLOW_MGNT_QCAPS              0x124UL
 	#define HWRM_CFA_TFLIB                            0x125UL
-	#define HWRM_ENGINE_CKV_HELLO                     0x12dUL
 	#define HWRM_ENGINE_CKV_STATUS                    0x12eUL
 	#define HWRM_ENGINE_CKV_CKEK_ADD                  0x12fUL
 	#define HWRM_ENGINE_CKV_CKEK_DELETE               0x130UL
@@ -313,6 +313,7 @@ struct cmd_nums {
 	#define HWRM_FUNC_BACKING_STORE_QCFG              0x194UL
 	#define HWRM_FUNC_VF_BW_CFG                       0x195UL
 	#define HWRM_FUNC_VF_BW_QCFG                      0x196UL
+	#define HWRM_FUNC_HOST_PF_IDS_QUERY               0x197UL
 	#define HWRM_SELFTEST_QLIST                       0x200UL
 	#define HWRM_SELFTEST_EXEC                        0x201UL
 	#define HWRM_SELFTEST_IRQ                         0x202UL
@@ -410,8 +411,8 @@ struct hwrm_err_output {
 #define HWRM_VERSION_MAJOR 1
 #define HWRM_VERSION_MINOR 10
 #define HWRM_VERSION_UPDATE 0
-#define HWRM_VERSION_RSVD 69
-#define HWRM_VERSION_STR "1.10.0.69"
+#define HWRM_VERSION_RSVD 89
+#define HWRM_VERSION_STR "1.10.0.89"
 
 /* hwrm_ver_get_input (size:192b/24B) */
 struct hwrm_ver_get_input {
@@ -624,6 +625,8 @@ struct hwrm_async_event_cmpl {
 	#define ASYNC_EVENT_CMPL_EVENT_ID_TCP_FLAG_ACTION_CHANGE     0x3aUL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_EEM_FLOW_ACTIVE            0x3bUL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_EEM_CFG_CHANGE             0x3cUL
+	#define ASYNC_EVENT_CMPL_EVENT_ID_TFLIB_DEFAULT_VNIC_CHANGE  0x3dUL
+	#define ASYNC_EVENT_CMPL_EVENT_ID_TFLIB_LINK_STATUS_CHANGE   0x3eUL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_FW_TRACE_MSG               0xfeUL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_HWRM_ERROR                 0xffUL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_LAST                      ASYNC_EVENT_CMPL_EVENT_ID_HWRM_ERROR
@@ -1122,6 +1125,7 @@ struct hwrm_func_qcfg_output {
 	#define FUNC_QCFG_RESP_FLAGS_MULTI_HOST                   0x20UL
 	#define FUNC_QCFG_RESP_FLAGS_TRUSTED_VF                   0x40UL
 	#define FUNC_QCFG_RESP_FLAGS_SECURE_MODE_ENABLED          0x80UL
+	#define FUNC_QCFG_RESP_FLAGS_PREBOOT_LEGACY_L2_RINGS      0x100UL
 	u8	mac_address[6];
 	__le16	pci_id;
 	__le16	alloc_rsscos_ctx;
@@ -1241,6 +1245,7 @@ struct hwrm_func_cfg_input {
 	#define FUNC_CFG_REQ_FLAGS_DYNAMIC_TX_RING_ALLOC          0x400000UL
 	#define FUNC_CFG_REQ_FLAGS_NQ_ASSETS_TEST                 0x800000UL
 	#define FUNC_CFG_REQ_FLAGS_TRUSTED_VF_DISABLE             0x1000000UL
+	#define FUNC_CFG_REQ_FLAGS_PREBOOT_LEGACY_L2_RINGS        0x2000000UL
 	__le32	enables;
 	#define FUNC_CFG_REQ_ENABLES_MTU                     0x1UL
 	#define FUNC_CFG_REQ_ENABLES_MRU                     0x2UL
@@ -2916,7 +2921,7 @@ struct tx_port_stats_ext {
 	__le64	pfc_pri7_tx_transitions;
 };
 
-/* rx_port_stats_ext (size:2624b/328B) */
+/* rx_port_stats_ext (size:3648b/456B) */
 struct rx_port_stats_ext {
 	__le64	link_down_events;
 	__le64	continuous_pause_events;
@@ -2959,6 +2964,22 @@ struct rx_port_stats_ext {
 	__le64	rx_buffer_passed_threshold;
 	__le64	rx_pcs_symbol_err;
 	__le64	rx_corrected_bits;
+	__le64	rx_discard_bytes_cos0;
+	__le64	rx_discard_bytes_cos1;
+	__le64	rx_discard_bytes_cos2;
+	__le64	rx_discard_bytes_cos3;
+	__le64	rx_discard_bytes_cos4;
+	__le64	rx_discard_bytes_cos5;
+	__le64	rx_discard_bytes_cos6;
+	__le64	rx_discard_bytes_cos7;
+	__le64	rx_discard_packets_cos0;
+	__le64	rx_discard_packets_cos1;
+	__le64	rx_discard_packets_cos2;
+	__le64	rx_discard_packets_cos3;
+	__le64	rx_discard_packets_cos4;
+	__le64	rx_discard_packets_cos5;
+	__le64	rx_discard_packets_cos6;
+	__le64	rx_discard_packets_cos7;
 };
 
 /* hwrm_port_qstats_ext_input (size:320b/40B) */
@@ -6115,6 +6136,21 @@ struct hwrm_cfa_flow_alloc_output {
 	u8	valid;
 };
 
+/* hwrm_cfa_flow_alloc_cmd_err (size:64b/8B) */
+struct hwrm_cfa_flow_alloc_cmd_err {
+	u8	code;
+	#define CFA_FLOW_ALLOC_CMD_ERR_CODE_UNKNOWN         0x0UL
+	#define CFA_FLOW_ALLOC_CMD_ERR_CODE_L2_CONTEXT_TCAM 0x1UL
+	#define CFA_FLOW_ALLOC_CMD_ERR_CODE_ACTION_RECORD   0x2UL
+	#define CFA_FLOW_ALLOC_CMD_ERR_CODE_FLOW_COUNTER    0x3UL
+	#define CFA_FLOW_ALLOC_CMD_ERR_CODE_WILD_CARD_TCAM  0x4UL
+	#define CFA_FLOW_ALLOC_CMD_ERR_CODE_HASH_COLLISION  0x5UL
+	#define CFA_FLOW_ALLOC_CMD_ERR_CODE_KEY_EXISTS      0x6UL
+	#define CFA_FLOW_ALLOC_CMD_ERR_CODE_FLOW_CTXT_DB    0x7UL
+	#define CFA_FLOW_ALLOC_CMD_ERR_CODE_LAST           CFA_FLOW_ALLOC_CMD_ERR_CODE_FLOW_CTXT_DB
+	u8	unused_0[7];
+};
+
 /* hwrm_cfa_flow_free_input (size:256b/32B) */
 struct hwrm_cfa_flow_free_input {
 	__le16	req_type;
@@ -6305,7 +6341,7 @@ struct hwrm_cfa_eem_qcaps_input {
 	__le32	unused_0;
 };
 
-/* hwrm_cfa_eem_qcaps_output (size:256b/32B) */
+/* hwrm_cfa_eem_qcaps_output (size:320b/40B) */
 struct hwrm_cfa_eem_qcaps_output {
 	__le16	error_code;
 	__le16	req_type;
@@ -6322,15 +6358,17 @@ struct hwrm_cfa_eem_qcaps_output {
 	#define CFA_EEM_QCAPS_RESP_SUPPORTED_KEY1_TABLE                       0x2UL
 	#define CFA_EEM_QCAPS_RESP_SUPPORTED_EXTERNAL_RECORD_TABLE            0x4UL
 	#define CFA_EEM_QCAPS_RESP_SUPPORTED_EXTERNAL_FLOW_COUNTERS_TABLE     0x8UL
+	#define CFA_EEM_QCAPS_RESP_SUPPORTED_FID_TABLE                        0x10UL
 	__le32	max_entries_supported;
 	__le16	key_entry_size;
 	__le16	record_entry_size;
 	__le16	efc_entry_size;
-	u8	unused_1;
+	__le16	fid_entry_size;
+	u8	unused_1[7];
 	u8	valid;
 };
 
-/* hwrm_cfa_eem_cfg_input (size:320b/40B) */
+/* hwrm_cfa_eem_cfg_input (size:384b/48B) */
 struct hwrm_cfa_eem_cfg_input {
 	__le16	req_type;
 	__le16	cmpl_ring;
@@ -6350,6 +6388,9 @@ struct hwrm_cfa_eem_cfg_input {
 	__le16	key1_ctx_id;
 	__le16	record_ctx_id;
 	__le16	efc_ctx_id;
+	__le16	fid_ctx_id;
+	__le16	unused_2;
+	__le32	unused_3;
 };
 
 /* hwrm_cfa_eem_cfg_output (size:128b/16B) */
@@ -6375,7 +6416,7 @@ struct hwrm_cfa_eem_qcfg_input {
 	__le32	unused_0;
 };
 
-/* hwrm_cfa_eem_qcfg_output (size:192b/24B) */
+/* hwrm_cfa_eem_qcfg_output (size:256b/32B) */
 struct hwrm_cfa_eem_qcfg_output {
 	__le16	error_code;
 	__le16	req_type;
@@ -6386,7 +6427,12 @@ struct hwrm_cfa_eem_qcfg_output {
 	#define CFA_EEM_QCFG_RESP_FLAGS_PATH_RX               0x2UL
 	#define CFA_EEM_QCFG_RESP_FLAGS_PREFERRED_OFFLOAD     0x4UL
 	__le32	num_entries;
-	u8	unused_0[7];
+	__le16	key0_ctx_id;
+	__le16	key1_ctx_id;
+	__le16	record_ctx_id;
+	__le16	efc_ctx_id;
+	__le16	fid_ctx_id;
+	u8	unused_2[5];
 	u8	valid;
 };
 
@@ -6567,6 +6613,31 @@ struct ctx_hw_stats {
 	__le64	tpa_aborts;
 };
 
+/* ctx_hw_stats_ext (size:1344b/168B) */
+struct ctx_hw_stats_ext {
+	__le64	rx_ucast_pkts;
+	__le64	rx_mcast_pkts;
+	__le64	rx_bcast_pkts;
+	__le64	rx_discard_pkts;
+	__le64	rx_drop_pkts;
+	__le64	rx_ucast_bytes;
+	__le64	rx_mcast_bytes;
+	__le64	rx_bcast_bytes;
+	__le64	tx_ucast_pkts;
+	__le64	tx_mcast_pkts;
+	__le64	tx_bcast_pkts;
+	__le64	tx_discard_pkts;
+	__le64	tx_drop_pkts;
+	__le64	tx_ucast_bytes;
+	__le64	tx_mcast_bytes;
+	__le64	tx_bcast_bytes;
+	__le64	rx_tpa_eligible_pkt;
+	__le64	rx_tpa_eligible_bytes;
+	__le64	rx_tpa_pkt;
+	__le64	rx_tpa_bytes;
+	__le64	rx_tpa_errors;
+};
+
 /* hwrm_stat_ctx_alloc_input (size:256b/32B) */
 struct hwrm_stat_ctx_alloc_input {
 	__le16	req_type;
@@ -6578,7 +6649,8 @@ struct hwrm_stat_ctx_alloc_input {
 	__le32	update_period_ms;
 	u8	stat_ctx_flags;
 	#define STAT_CTX_ALLOC_REQ_STAT_CTX_FLAGS_ROCE     0x1UL
-	u8	unused_0[3];
+	u8	unused_0;
+	__le16	stats_dma_length;
 };
 
 /* hwrm_stat_ctx_alloc_output (size:128b/16B) */
@@ -7204,7 +7276,9 @@ struct coredump_segment_record {
 	u8	version_hi;
 	u8	version_low;
 	u8	seg_flags;
-	u8	unused_0[7];
+	u8	compress_flags;
+	#define SFLAG_COMPRESSED_ZLIB     0x1UL
+	u8	unused_0[6];
 };
 
 /* hwrm_dbg_coredump_list_input (size:256b/32B) */
@@ -7729,6 +7803,9 @@ struct hwrm_nvm_set_variable_input {
 	#define NVM_SET_VARIABLE_REQ_FLAGS_ENCRYPT_MODE_AES256          (0x2UL << 1)
 	#define NVM_SET_VARIABLE_REQ_FLAGS_ENCRYPT_MODE_HMAC_SHA1_AUTH  (0x3UL << 1)
 	#define NVM_SET_VARIABLE_REQ_FLAGS_ENCRYPT_MODE_LAST           NVM_SET_VARIABLE_REQ_FLAGS_ENCRYPT_MODE_HMAC_SHA1_AUTH
+	#define NVM_SET_VARIABLE_REQ_FLAGS_FLAGS_UNUSED_0_MASK        0x70UL
+	#define NVM_SET_VARIABLE_REQ_FLAGS_FLAGS_UNUSED_0_SFT         4
+	#define NVM_SET_VARIABLE_REQ_FLAGS_FACTORY_DEFAULT            0x80UL
 	u8	unused_0;
 };
 
-- 
2.5.1

