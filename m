Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC7113F30
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 13:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbfEELRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 07:17:23 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40731 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfEELRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 07:17:22 -0400
Received: by mail-pf1-f193.google.com with SMTP id u17so5211829pfn.7
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 04:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wiXCojb6vAwZFfgN3ixP4Fl8PGjHWNmwzFfVN1l5ErM=;
        b=G7WkZsrg8U1j96PO8DRP+t7QNou6dUrBW7Z6TRqhlFbdSTZRiuJrMXVcnTr5PCCHxS
         +oLoTKh5MnglfUIQscWKMF0/7IGXsMs/w7Npm2sR5GDQVp19yZyoWky6YGIYAsdPkEh3
         ryb8AdQ+KLhGyYmP9/WGkftmRkDgrCHgURc6E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wiXCojb6vAwZFfgN3ixP4Fl8PGjHWNmwzFfVN1l5ErM=;
        b=XFf4KArXAQ9HYI7aAmk0/VdjvkZFsJcLIMiC2ebXBgDriUlIFRACwJXojJNjPqPRqA
         nD04rkDmEKVDRmG1uIOS4YIyN/O2uuNFdnPlZcCAZblfWu1giHmJnGMqp6dUJ3rCORaX
         nN3pc8JDo+16GPbHpQYedZHGvFudQ9fnkrihBlJ8o7O7yG4EQWSNawmspmRtjS3FIw6a
         TZzbegGKXYc9J0vOtiSsm1sga6KekGPVBt7nzK70qDCdAP6CCn0FxAaXYnicd71INV7D
         FGZdH3QRAQWe8I/id5EXsxKqwqc9On+itMktKaKpcp++SZIu82qrdoPukTK9aXSKtR4y
         gwVQ==
X-Gm-Message-State: APjAAAXFg9LZRKt+DGfDVzS6TmxizTlF7/o85JPrucOueIvJtghbZhFX
        ftCxoWhzsLxy+AHvQtJt76D/Lg==
X-Google-Smtp-Source: APXvYqyrar79iaAg2tDuGf6qiwTyQJ7fmlsQ/GIW6Pu2EZKabrCy/oFmWto38VPqmz18XK2Rj4bqZQ==
X-Received: by 2002:a65:6686:: with SMTP id b6mr24523651pgw.419.1557055041031;
        Sun, 05 May 2019 04:17:21 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.250])
        by smtp.gmail.com with ESMTPSA id 10sm9378902pfh.14.2019.05.05.04.17.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 04:17:20 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 01/11] bnxt_en: Update firmware interface to 1.10.0.69.
Date:   Sun,  5 May 2019 07:16:58 -0400
Message-Id: <1557055028-14816-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1557055028-14816-1-git-send-email-michael.chan@broadcom.com>
References: <1557055028-14816-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PTP API updates for 57500 chips, new RX port stats counters and other
miscellaneous updates.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |   4 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h     | 263 +++++++++++++++++-----
 2 files changed, 214 insertions(+), 53 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index adabbe9..a3e6a7d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -345,6 +345,10 @@ static const struct {
 	BNXT_RX_STATS_EXT_ENTRY(resume_roce_pause_events),
 	BNXT_RX_STATS_EXT_COS_ENTRIES,
 	BNXT_RX_STATS_EXT_PFC_ENTRIES,
+	BNXT_RX_STATS_EXT_ENTRY(rx_bits),
+	BNXT_RX_STATS_EXT_ENTRY(rx_buffer_passed_threshold),
+	BNXT_RX_STATS_EXT_ENTRY(rx_pcs_symbol_err),
+	BNXT_RX_STATS_EXT_ENTRY(rx_corrected_bits),
 };
 
 static const struct {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
index b6c6103..12bbb2a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
@@ -89,7 +89,10 @@ struct hwrm_short_input {
 	__le16	signature;
 	#define SHORT_REQ_SIGNATURE_SHORT_CMD 0x4321UL
 	#define SHORT_REQ_SIGNATURE_LAST     SHORT_REQ_SIGNATURE_SHORT_CMD
-	__le16	unused_0;
+	__le16	target_id;
+	#define SHORT_REQ_TARGET_ID_DEFAULT 0x0UL
+	#define SHORT_REQ_TARGET_ID_TOOLS   0xfffdUL
+	#define SHORT_REQ_TARGET_ID_LAST   SHORT_REQ_TARGET_ID_TOOLS
 	__le16	size;
 	__le64	req_addr;
 };
@@ -211,6 +214,7 @@ struct cmd_nums {
 	#define HWRM_FWD_RESP                             0xd2UL
 	#define HWRM_FWD_ASYNC_EVENT_CMPL                 0xd3UL
 	#define HWRM_OEM_CMD                              0xd4UL
+	#define HWRM_PORT_PRBS_TEST                       0xd5UL
 	#define HWRM_TEMP_MONITOR_QUERY                   0xe0UL
 	#define HWRM_WOL_FILTER_ALLOC                     0xf0UL
 	#define HWRM_WOL_FILTER_FREE                      0xf1UL
@@ -262,6 +266,7 @@ struct cmd_nums {
 	#define HWRM_CFA_EEM_QCFG                         0x122UL
 	#define HWRM_CFA_EEM_OP                           0x123UL
 	#define HWRM_CFA_ADV_FLOW_MGNT_QCAPS              0x124UL
+	#define HWRM_CFA_TFLIB                            0x125UL
 	#define HWRM_ENGINE_CKV_HELLO                     0x12dUL
 	#define HWRM_ENGINE_CKV_STATUS                    0x12eUL
 	#define HWRM_ENGINE_CKV_CKEK_ADD                  0x12fUL
@@ -272,6 +277,7 @@ struct cmd_nums {
 	#define HWRM_ENGINE_CKV_RNG_GET                   0x134UL
 	#define HWRM_ENGINE_CKV_KEY_GEN                   0x135UL
 	#define HWRM_ENGINE_CKV_KEY_LABEL_CFG             0x136UL
+	#define HWRM_ENGINE_CKV_KEY_LABEL_QCFG            0x137UL
 	#define HWRM_ENGINE_QG_CONFIG_QUERY               0x13cUL
 	#define HWRM_ENGINE_QG_QUERY                      0x13dUL
 	#define HWRM_ENGINE_QG_METER_PROFILE_CONFIG_QUERY 0x13eUL
@@ -312,6 +318,11 @@ struct cmd_nums {
 	#define HWRM_SELFTEST_IRQ                         0x202UL
 	#define HWRM_SELFTEST_RETRIEVE_SERDES_DATA        0x203UL
 	#define HWRM_PCIE_QSTATS                          0x204UL
+	#define HWRM_MFG_FRU_WRITE_CONTROL                0x205UL
+	#define HWRM_MFG_TIMERS_QUERY                     0x206UL
+	#define HWRM_MFG_OTP_CFG                          0x207UL
+	#define HWRM_MFG_OTP_QCFG                         0x208UL
+	#define HWRM_MFG_HDMA_TEST                        0x209UL
 	#define HWRM_DBG_READ_DIRECT                      0xff10UL
 	#define HWRM_DBG_READ_INDIRECT                    0xff11UL
 	#define HWRM_DBG_WRITE_DIRECT                     0xff12UL
@@ -325,6 +336,8 @@ struct cmd_nums {
 	#define HWRM_DBG_FW_CLI                           0xff1aUL
 	#define HWRM_DBG_I2C_CMD                          0xff1bUL
 	#define HWRM_DBG_RING_INFO_GET                    0xff1cUL
+	#define HWRM_DBG_CRASHDUMP_HEADER                 0xff1dUL
+	#define HWRM_DBG_CRASHDUMP_ERASE                  0xff1eUL
 	#define HWRM_NVM_FACTORY_DEFAULTS                 0xffeeUL
 	#define HWRM_NVM_VALIDATE_OPTION                  0xffefUL
 	#define HWRM_NVM_FLUSH                            0xfff0UL
@@ -350,23 +363,26 @@ struct cmd_nums {
 /* ret_codes (size:64b/8B) */
 struct ret_codes {
 	__le16	error_code;
-	#define HWRM_ERR_CODE_SUCCESS                   0x0UL
-	#define HWRM_ERR_CODE_FAIL                      0x1UL
-	#define HWRM_ERR_CODE_INVALID_PARAMS            0x2UL
-	#define HWRM_ERR_CODE_RESOURCE_ACCESS_DENIED    0x3UL
-	#define HWRM_ERR_CODE_RESOURCE_ALLOC_ERROR      0x4UL
-	#define HWRM_ERR_CODE_INVALID_FLAGS             0x5UL
-	#define HWRM_ERR_CODE_INVALID_ENABLES           0x6UL
-	#define HWRM_ERR_CODE_UNSUPPORTED_TLV           0x7UL
-	#define HWRM_ERR_CODE_NO_BUFFER                 0x8UL
-	#define HWRM_ERR_CODE_UNSUPPORTED_OPTION_ERR    0x9UL
-	#define HWRM_ERR_CODE_HOT_RESET_PROGRESS        0xaUL
-	#define HWRM_ERR_CODE_HOT_RESET_FAIL            0xbUL
-	#define HWRM_ERR_CODE_HWRM_ERROR                0xfUL
-	#define HWRM_ERR_CODE_TLV_ENCAPSULATED_RESPONSE 0x8000UL
-	#define HWRM_ERR_CODE_UNKNOWN_ERR               0xfffeUL
-	#define HWRM_ERR_CODE_CMD_NOT_SUPPORTED         0xffffUL
-	#define HWRM_ERR_CODE_LAST                     HWRM_ERR_CODE_CMD_NOT_SUPPORTED
+	#define HWRM_ERR_CODE_SUCCESS                      0x0UL
+	#define HWRM_ERR_CODE_FAIL                         0x1UL
+	#define HWRM_ERR_CODE_INVALID_PARAMS               0x2UL
+	#define HWRM_ERR_CODE_RESOURCE_ACCESS_DENIED       0x3UL
+	#define HWRM_ERR_CODE_RESOURCE_ALLOC_ERROR         0x4UL
+	#define HWRM_ERR_CODE_INVALID_FLAGS                0x5UL
+	#define HWRM_ERR_CODE_INVALID_ENABLES              0x6UL
+	#define HWRM_ERR_CODE_UNSUPPORTED_TLV              0x7UL
+	#define HWRM_ERR_CODE_NO_BUFFER                    0x8UL
+	#define HWRM_ERR_CODE_UNSUPPORTED_OPTION_ERR       0x9UL
+	#define HWRM_ERR_CODE_HOT_RESET_PROGRESS           0xaUL
+	#define HWRM_ERR_CODE_HOT_RESET_FAIL               0xbUL
+	#define HWRM_ERR_CODE_NO_FLOW_COUNTER_DURING_ALLOC 0xcUL
+	#define HWRM_ERR_CODE_KEY_HASH_COLLISION           0xdUL
+	#define HWRM_ERR_CODE_KEY_ALREADY_EXISTS           0xeUL
+	#define HWRM_ERR_CODE_HWRM_ERROR                   0xfUL
+	#define HWRM_ERR_CODE_TLV_ENCAPSULATED_RESPONSE    0x8000UL
+	#define HWRM_ERR_CODE_UNKNOWN_ERR                  0xfffeUL
+	#define HWRM_ERR_CODE_CMD_NOT_SUPPORTED            0xffffUL
+	#define HWRM_ERR_CODE_LAST                        HWRM_ERR_CODE_CMD_NOT_SUPPORTED
 	__le16	unused_0[3];
 };
 
@@ -387,11 +403,15 @@ struct hwrm_err_output {
 #define HW_HASH_INDEX_SIZE 0x80
 #define HW_HASH_KEY_SIZE 40
 #define HWRM_RESP_VALID_KEY 1
+#define HWRM_TARGET_ID_BONO 0xFFF8
+#define HWRM_TARGET_ID_KONG 0xFFF9
+#define HWRM_TARGET_ID_APE 0xFFFA
+#define HWRM_TARGET_ID_TOOLS 0xFFFD
 #define HWRM_VERSION_MAJOR 1
 #define HWRM_VERSION_MINOR 10
 #define HWRM_VERSION_UPDATE 0
-#define HWRM_VERSION_RSVD 47
-#define HWRM_VERSION_STR "1.10.0.47"
+#define HWRM_VERSION_RSVD 69
+#define HWRM_VERSION_STR "1.10.0.69"
 
 /* hwrm_ver_get_input (size:192b/24B) */
 struct hwrm_ver_get_input {
@@ -442,6 +462,7 @@ struct hwrm_ver_get_output {
 	#define VER_GET_RESP_DEV_CAPS_CFG_ADV_FLOW_COUNTERS_SUPPORTED              0x400UL
 	#define VER_GET_RESP_DEV_CAPS_CFG_CFA_EEM_SUPPORTED                        0x800UL
 	#define VER_GET_RESP_DEV_CAPS_CFG_CFA_ADV_FLOW_MGNT_SUPPORTED              0x1000UL
+	#define VER_GET_RESP_DEV_CAPS_CFG_CFA_TFLIB_SUPPORTED                      0x2000UL
 	u8	roce_fw_maj_8b;
 	u8	roce_fw_min_8b;
 	u8	roce_fw_bld_8b;
@@ -449,7 +470,7 @@ struct hwrm_ver_get_output {
 	char	hwrm_fw_name[16];
 	char	mgmt_fw_name[16];
 	char	netctrl_fw_name[16];
-	u8	reserved2[16];
+	char	active_pkg_name[16];
 	char	roce_fw_name[16];
 	__le16	chip_num;
 	u8	chip_rev;
@@ -1047,6 +1068,7 @@ struct hwrm_func_qcaps_output {
 	#define FUNC_QCAPS_RESP_FLAGS_DYNAMIC_TX_RING_ALLOC           0x200000UL
 	#define FUNC_QCAPS_RESP_FLAGS_HOT_RESET_CAPABLE               0x400000UL
 	#define FUNC_QCAPS_RESP_FLAGS_ERROR_RECOVERY_CAPABLE          0x800000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_STATS_SUPPORTED             0x1000000UL
 	u8	mac_address[6];
 	__le16	max_rsscos_ctx;
 	__le16	max_cmpl_rings;
@@ -1715,7 +1737,7 @@ struct hwrm_func_backing_store_qcaps_output {
 	__le16	mrav_entry_size;
 	__le16	tim_entry_size;
 	__le32	tim_max_entries;
-	u8	unused_0[2];
+	__le16	mrav_num_entries_units;
 	u8	tqm_entries_multiple;
 	u8	valid;
 };
@@ -1728,7 +1750,8 @@ struct hwrm_func_backing_store_cfg_input {
 	__le16	target_id;
 	__le64	resp_addr;
 	__le32	flags;
-	#define FUNC_BACKING_STORE_CFG_REQ_FLAGS_PREBOOT_MODE     0x1UL
+	#define FUNC_BACKING_STORE_CFG_REQ_FLAGS_PREBOOT_MODE               0x1UL
+	#define FUNC_BACKING_STORE_CFG_REQ_FLAGS_MRAV_RESERVATION_SPLIT     0x2UL
 	__le32	enables;
 	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_QP            0x1UL
 	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_SRQ           0x2UL
@@ -2580,7 +2603,7 @@ struct hwrm_port_phy_qcfg_output {
 	u8	valid;
 };
 
-/* hwrm_port_mac_cfg_input (size:320b/40B) */
+/* hwrm_port_mac_cfg_input (size:384b/48B) */
 struct hwrm_port_mac_cfg_input {
 	__le16	req_type;
 	__le16	cmpl_ring;
@@ -2601,6 +2624,7 @@ struct hwrm_port_mac_cfg_input {
 	#define PORT_MAC_CFG_REQ_FLAGS_VLAN_PRI2COS_DISABLE          0x400UL
 	#define PORT_MAC_CFG_REQ_FLAGS_TUNNEL_PRI2COS_DISABLE        0x800UL
 	#define PORT_MAC_CFG_REQ_FLAGS_IP_DSCP2COS_DISABLE           0x1000UL
+	#define PORT_MAC_CFG_REQ_FLAGS_PTP_ONE_STEP_TX_TS            0x2000UL
 	__le32	enables;
 	#define PORT_MAC_CFG_REQ_ENABLES_IPG                            0x1UL
 	#define PORT_MAC_CFG_REQ_ENABLES_LPBK                           0x2UL
@@ -2610,6 +2634,7 @@ struct hwrm_port_mac_cfg_input {
 	#define PORT_MAC_CFG_REQ_ENABLES_RX_TS_CAPTURE_PTP_MSG_TYPE     0x40UL
 	#define PORT_MAC_CFG_REQ_ENABLES_TX_TS_CAPTURE_PTP_MSG_TYPE     0x80UL
 	#define PORT_MAC_CFG_REQ_ENABLES_COS_FIELD_CFG                  0x100UL
+	#define PORT_MAC_CFG_REQ_ENABLES_PTP_FREQ_ADJ_PPB               0x200UL
 	__le16	port_id;
 	u8	ipg;
 	u8	lpbk;
@@ -2642,6 +2667,8 @@ struct hwrm_port_mac_cfg_input {
 	#define PORT_MAC_CFG_REQ_COS_FIELD_CFG_DEFAULT_COS_MASK          0xe0UL
 	#define PORT_MAC_CFG_REQ_COS_FIELD_CFG_DEFAULT_COS_SFT           5
 	u8	unused_0[3];
+	__s32	ptp_freq_adj_ppb;
+	u8	unused_1[4];
 };
 
 /* hwrm_port_mac_cfg_output (size:128b/16B) */
@@ -2680,8 +2707,9 @@ struct hwrm_port_mac_ptp_qcfg_output {
 	__le16	seq_id;
 	__le16	resp_len;
 	u8	flags;
-	#define PORT_MAC_PTP_QCFG_RESP_FLAGS_DIRECT_ACCESS     0x1UL
-	#define PORT_MAC_PTP_QCFG_RESP_FLAGS_HWRM_ACCESS       0x2UL
+	#define PORT_MAC_PTP_QCFG_RESP_FLAGS_DIRECT_ACCESS      0x1UL
+	#define PORT_MAC_PTP_QCFG_RESP_FLAGS_HWRM_ACCESS        0x2UL
+	#define PORT_MAC_PTP_QCFG_RESP_FLAGS_ONE_STEP_TX_TS     0x4UL
 	u8	unused_0[3];
 	__le32	rx_ts_reg_off_lower;
 	__le32	rx_ts_reg_off_upper;
@@ -2888,7 +2916,7 @@ struct tx_port_stats_ext {
 	__le64	pfc_pri7_tx_transitions;
 };
 
-/* rx_port_stats_ext (size:2368b/296B) */
+/* rx_port_stats_ext (size:2624b/328B) */
 struct rx_port_stats_ext {
 	__le64	link_down_events;
 	__le64	continuous_pause_events;
@@ -2927,6 +2955,10 @@ struct rx_port_stats_ext {
 	__le64	pfc_pri6_rx_transitions;
 	__le64	pfc_pri7_rx_duration_us;
 	__le64	pfc_pri7_rx_transitions;
+	__le64	rx_bits;
+	__le64	rx_buffer_passed_threshold;
+	__le64	rx_pcs_symbol_err;
+	__le64	rx_corrected_bits;
 };
 
 /* hwrm_port_qstats_ext_input (size:320b/40B) */
@@ -3029,6 +3061,35 @@ struct hwrm_port_lpbk_clr_stats_output {
 	u8	valid;
 };
 
+/* hwrm_port_ts_query_input (size:192b/24B) */
+struct hwrm_port_ts_query_input {
+	__le16	req_type;
+	__le16	cmpl_ring;
+	__le16	seq_id;
+	__le16	target_id;
+	__le64	resp_addr;
+	__le32	flags;
+	#define PORT_TS_QUERY_REQ_FLAGS_PATH             0x1UL
+	#define PORT_TS_QUERY_REQ_FLAGS_PATH_TX            0x0UL
+	#define PORT_TS_QUERY_REQ_FLAGS_PATH_RX            0x1UL
+	#define PORT_TS_QUERY_REQ_FLAGS_PATH_LAST         PORT_TS_QUERY_REQ_FLAGS_PATH_RX
+	#define PORT_TS_QUERY_REQ_FLAGS_CURRENT_TIME     0x2UL
+	__le16	port_id;
+	u8	unused_0[2];
+};
+
+/* hwrm_port_ts_query_output (size:192b/24B) */
+struct hwrm_port_ts_query_output {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
+	__le64	ptp_msg_ts;
+	__le16	ptp_msg_seqid;
+	u8	unused_0[5];
+	u8	valid;
+};
+
 /* hwrm_port_phy_qcaps_input (size:192b/24B) */
 struct hwrm_port_phy_qcaps_input {
 	__le16	req_type;
@@ -4703,7 +4764,8 @@ struct hwrm_vnic_qcaps_output {
 	#define VNIC_QCAPS_RESP_FLAGS_RSS_DFLT_CR_CAP                     0x20UL
 	#define VNIC_QCAPS_RESP_FLAGS_ROCE_MIRRORING_CAPABLE_VNIC_CAP     0x40UL
 	#define VNIC_QCAPS_RESP_FLAGS_OUTERMOST_RSS_CAP                   0x80UL
-	u8	unused_1[7];
+	__le16	max_aggs_supported;
+	u8	unused_1[5];
 	u8	valid;
 };
 
@@ -4723,6 +4785,7 @@ struct hwrm_vnic_tpa_cfg_input {
 	#define VNIC_TPA_CFG_REQ_FLAGS_AGG_WITH_SAME_GRE_SEQ     0x20UL
 	#define VNIC_TPA_CFG_REQ_FLAGS_GRO_IPID_CHECK            0x40UL
 	#define VNIC_TPA_CFG_REQ_FLAGS_GRO_TTL_CHECK             0x80UL
+	#define VNIC_TPA_CFG_REQ_FLAGS_AGG_PACK_AS_GRO           0x100UL
 	__le32	enables;
 	#define VNIC_TPA_CFG_REQ_ENABLES_MAX_AGG_SEGS      0x1UL
 	#define VNIC_TPA_CFG_REQ_ENABLES_MAX_AGGS          0x2UL
@@ -5254,6 +5317,8 @@ struct hwrm_cfa_l2_filter_alloc_input {
 	#define CFA_L2_FILTER_ALLOC_REQ_FLAGS_TRAFFIC_L2          (0x1UL << 4)
 	#define CFA_L2_FILTER_ALLOC_REQ_FLAGS_TRAFFIC_ROCE        (0x2UL << 4)
 	#define CFA_L2_FILTER_ALLOC_REQ_FLAGS_TRAFFIC_LAST       CFA_L2_FILTER_ALLOC_REQ_FLAGS_TRAFFIC_ROCE
+	#define CFA_L2_FILTER_ALLOC_REQ_FLAGS_XDP_DISABLE       0x40UL
+	#define CFA_L2_FILTER_ALLOC_REQ_FLAGS_SOURCE_VALID      0x80UL
 	__le32	enables;
 	#define CFA_L2_FILTER_ALLOC_REQ_ENABLES_L2_ADDR             0x1UL
 	#define CFA_L2_FILTER_ALLOC_REQ_ENABLES_L2_ADDR_MASK        0x2UL
@@ -5272,8 +5337,11 @@ struct hwrm_cfa_l2_filter_alloc_input {
 	#define CFA_L2_FILTER_ALLOC_REQ_ENABLES_TUNNEL_TYPE         0x4000UL
 	#define CFA_L2_FILTER_ALLOC_REQ_ENABLES_DST_ID              0x8000UL
 	#define CFA_L2_FILTER_ALLOC_REQ_ENABLES_MIRROR_VNIC_ID      0x10000UL
+	#define CFA_L2_FILTER_ALLOC_REQ_ENABLES_NUM_VLANS           0x20000UL
+	#define CFA_L2_FILTER_ALLOC_REQ_ENABLES_T_NUM_VLANS         0x40000UL
 	u8	l2_addr[6];
-	u8	unused_0[2];
+	u8	num_vlans;
+	u8	t_num_vlans;
 	u8	l2_addr_mask[6];
 	__le16	l2_ovlan;
 	__le16	l2_ovlan_mask;
@@ -5338,6 +5406,16 @@ struct hwrm_cfa_l2_filter_alloc_output {
 	__le16	resp_len;
 	__le64	l2_filter_id;
 	__le32	flow_id;
+	#define CFA_L2_FILTER_ALLOC_RESP_FLOW_ID_VALUE_MASK 0x3fffffffUL
+	#define CFA_L2_FILTER_ALLOC_RESP_FLOW_ID_VALUE_SFT 0
+	#define CFA_L2_FILTER_ALLOC_RESP_FLOW_ID_TYPE      0x40000000UL
+	#define CFA_L2_FILTER_ALLOC_RESP_FLOW_ID_TYPE_INT    (0x0UL << 30)
+	#define CFA_L2_FILTER_ALLOC_RESP_FLOW_ID_TYPE_EXT    (0x1UL << 30)
+	#define CFA_L2_FILTER_ALLOC_RESP_FLOW_ID_TYPE_LAST  CFA_L2_FILTER_ALLOC_RESP_FLOW_ID_TYPE_EXT
+	#define CFA_L2_FILTER_ALLOC_RESP_FLOW_ID_DIR       0x80000000UL
+	#define CFA_L2_FILTER_ALLOC_RESP_FLOW_ID_DIR_RX      (0x0UL << 31)
+	#define CFA_L2_FILTER_ALLOC_RESP_FLOW_ID_DIR_TX      (0x1UL << 31)
+	#define CFA_L2_FILTER_ALLOC_RESP_FLOW_ID_DIR_LAST   CFA_L2_FILTER_ALLOC_RESP_FLOW_ID_DIR_TX
 	u8	unused_0[3];
 	u8	valid;
 };
@@ -5504,6 +5582,16 @@ struct hwrm_cfa_tunnel_filter_alloc_output {
 	__le16	resp_len;
 	__le64	tunnel_filter_id;
 	__le32	flow_id;
+	#define CFA_TUNNEL_FILTER_ALLOC_RESP_FLOW_ID_VALUE_MASK 0x3fffffffUL
+	#define CFA_TUNNEL_FILTER_ALLOC_RESP_FLOW_ID_VALUE_SFT 0
+	#define CFA_TUNNEL_FILTER_ALLOC_RESP_FLOW_ID_TYPE      0x40000000UL
+	#define CFA_TUNNEL_FILTER_ALLOC_RESP_FLOW_ID_TYPE_INT    (0x0UL << 30)
+	#define CFA_TUNNEL_FILTER_ALLOC_RESP_FLOW_ID_TYPE_EXT    (0x1UL << 30)
+	#define CFA_TUNNEL_FILTER_ALLOC_RESP_FLOW_ID_TYPE_LAST  CFA_TUNNEL_FILTER_ALLOC_RESP_FLOW_ID_TYPE_EXT
+	#define CFA_TUNNEL_FILTER_ALLOC_RESP_FLOW_ID_DIR       0x80000000UL
+	#define CFA_TUNNEL_FILTER_ALLOC_RESP_FLOW_ID_DIR_RX      (0x0UL << 31)
+	#define CFA_TUNNEL_FILTER_ALLOC_RESP_FLOW_ID_DIR_TX      (0x1UL << 31)
+	#define CFA_TUNNEL_FILTER_ALLOC_RESP_FLOW_ID_DIR_LAST   CFA_TUNNEL_FILTER_ALLOC_RESP_FLOW_ID_DIR_TX
 	u8	unused_0[3];
 	u8	valid;
 };
@@ -5646,7 +5734,7 @@ struct hwrm_cfa_encap_record_free_output {
 	u8	valid;
 };
 
-/* hwrm_cfa_ntuple_filter_alloc_input (size:1024b/128B) */
+/* hwrm_cfa_ntuple_filter_alloc_input (size:1088b/136B) */
 struct hwrm_cfa_ntuple_filter_alloc_input {
 	__le16	req_type;
 	__le16	cmpl_ring;
@@ -5678,6 +5766,7 @@ struct hwrm_cfa_ntuple_filter_alloc_input {
 	#define CFA_NTUPLE_FILTER_ALLOC_REQ_ENABLES_DST_ID               0x10000UL
 	#define CFA_NTUPLE_FILTER_ALLOC_REQ_ENABLES_MIRROR_VNIC_ID       0x20000UL
 	#define CFA_NTUPLE_FILTER_ALLOC_REQ_ENABLES_DST_MACADDR          0x40000UL
+	#define CFA_NTUPLE_FILTER_ALLOC_REQ_ENABLES_RFS_RING_TBL_IDX     0x80000UL
 	__le64	l2_filter_id;
 	u8	src_macaddr[6];
 	__be16	ethertype;
@@ -5725,6 +5814,8 @@ struct hwrm_cfa_ntuple_filter_alloc_input {
 	__be16	dst_port;
 	__be16	dst_port_mask;
 	__le64	ntuple_filter_id_hint;
+	__le16	rfs_ring_tbl_idx;
+	u8	unused_0[6];
 };
 
 /* hwrm_cfa_ntuple_filter_alloc_output (size:192b/24B) */
@@ -5735,6 +5826,16 @@ struct hwrm_cfa_ntuple_filter_alloc_output {
 	__le16	resp_len;
 	__le64	ntuple_filter_id;
 	__le32	flow_id;
+	#define CFA_NTUPLE_FILTER_ALLOC_RESP_FLOW_ID_VALUE_MASK 0x3fffffffUL
+	#define CFA_NTUPLE_FILTER_ALLOC_RESP_FLOW_ID_VALUE_SFT 0
+	#define CFA_NTUPLE_FILTER_ALLOC_RESP_FLOW_ID_TYPE      0x40000000UL
+	#define CFA_NTUPLE_FILTER_ALLOC_RESP_FLOW_ID_TYPE_INT    (0x0UL << 30)
+	#define CFA_NTUPLE_FILTER_ALLOC_RESP_FLOW_ID_TYPE_EXT    (0x1UL << 30)
+	#define CFA_NTUPLE_FILTER_ALLOC_RESP_FLOW_ID_TYPE_LAST  CFA_NTUPLE_FILTER_ALLOC_RESP_FLOW_ID_TYPE_EXT
+	#define CFA_NTUPLE_FILTER_ALLOC_RESP_FLOW_ID_DIR       0x80000000UL
+	#define CFA_NTUPLE_FILTER_ALLOC_RESP_FLOW_ID_DIR_RX      (0x0UL << 31)
+	#define CFA_NTUPLE_FILTER_ALLOC_RESP_FLOW_ID_DIR_TX      (0x1UL << 31)
+	#define CFA_NTUPLE_FILTER_ALLOC_RESP_FLOW_ID_DIR_LAST   CFA_NTUPLE_FILTER_ALLOC_RESP_FLOW_ID_DIR_TX
 	u8	unused_0[3];
 	u8	valid;
 };
@@ -5934,19 +6035,20 @@ struct hwrm_cfa_flow_alloc_input {
 	__le16	src_fid;
 	__le32	tunnel_handle;
 	__le16	action_flags;
-	#define CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_FWD                    0x1UL
-	#define CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_RECYCLE                0x2UL
-	#define CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_DROP                   0x4UL
-	#define CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_METER                  0x8UL
-	#define CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_TUNNEL                 0x10UL
-	#define CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_NAT_SRC                0x20UL
-	#define CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_NAT_DEST               0x40UL
-	#define CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_NAT_IPV4_ADDRESS       0x80UL
-	#define CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_L2_HEADER_REWRITE      0x100UL
-	#define CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_TTL_DECREMENT          0x200UL
-	#define CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_TUNNEL_IP              0x400UL
-	#define CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_FLOW_AGING_ENABLED     0x800UL
-	#define CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_PRI_HINT               0x1000UL
+	#define CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_FWD                       0x1UL
+	#define CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_RECYCLE                   0x2UL
+	#define CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_DROP                      0x4UL
+	#define CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_METER                     0x8UL
+	#define CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_TUNNEL                    0x10UL
+	#define CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_NAT_SRC                   0x20UL
+	#define CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_NAT_DEST                  0x40UL
+	#define CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_NAT_IPV4_ADDRESS          0x80UL
+	#define CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_L2_HEADER_REWRITE         0x100UL
+	#define CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_TTL_DECREMENT             0x200UL
+	#define CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_TUNNEL_IP                 0x400UL
+	#define CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_FLOW_AGING_ENABLED        0x800UL
+	#define CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_PRI_HINT                  0x1000UL
+	#define CFA_FLOW_ALLOC_REQ_ACTION_FLAGS_NO_FLOW_COUNTER_ALLOC     0x2000UL
 	__le16	dst_fid;
 	__be16	l2_rewrite_vlan_tpid;
 	__be16	l2_rewrite_vlan_tci;
@@ -5997,6 +6099,16 @@ struct hwrm_cfa_flow_alloc_output {
 	__le16	flow_handle;
 	u8	unused_0[2];
 	__le32	flow_id;
+	#define CFA_FLOW_ALLOC_RESP_FLOW_ID_VALUE_MASK 0x3fffffffUL
+	#define CFA_FLOW_ALLOC_RESP_FLOW_ID_VALUE_SFT 0
+	#define CFA_FLOW_ALLOC_RESP_FLOW_ID_TYPE      0x40000000UL
+	#define CFA_FLOW_ALLOC_RESP_FLOW_ID_TYPE_INT    (0x0UL << 30)
+	#define CFA_FLOW_ALLOC_RESP_FLOW_ID_TYPE_EXT    (0x1UL << 30)
+	#define CFA_FLOW_ALLOC_RESP_FLOW_ID_TYPE_LAST  CFA_FLOW_ALLOC_RESP_FLOW_ID_TYPE_EXT
+	#define CFA_FLOW_ALLOC_RESP_FLOW_ID_DIR       0x80000000UL
+	#define CFA_FLOW_ALLOC_RESP_FLOW_ID_DIR_RX      (0x0UL << 31)
+	#define CFA_FLOW_ALLOC_RESP_FLOW_ID_DIR_TX      (0x1UL << 31)
+	#define CFA_FLOW_ALLOC_RESP_FLOW_ID_DIR_LAST   CFA_FLOW_ALLOC_RESP_FLOW_ID_DIR_TX
 	__le64	ext_flow_handle;
 	__le32	flow_counter_id;
 	u8	unused_1[3];
@@ -6011,7 +6123,8 @@ struct hwrm_cfa_flow_free_input {
 	__le16	target_id;
 	__le64	resp_addr;
 	__le16	flow_handle;
-	u8	unused_0[6];
+	__le16	unused_0;
+	__le32	flow_counter_id;
 	__le64	ext_flow_handle;
 };
 
@@ -6199,8 +6312,10 @@ struct hwrm_cfa_eem_qcaps_output {
 	__le16	seq_id;
 	__le16	resp_len;
 	__le32	flags;
-	#define CFA_EEM_QCAPS_RESP_FLAGS_PATH_TX     0x1UL
-	#define CFA_EEM_QCAPS_RESP_FLAGS_PATH_RX     0x2UL
+	#define CFA_EEM_QCAPS_RESP_FLAGS_PATH_TX                                         0x1UL
+	#define CFA_EEM_QCAPS_RESP_FLAGS_PATH_RX                                         0x2UL
+	#define CFA_EEM_QCAPS_RESP_FLAGS_CENTRALIZED_MEMORY_MODEL_SUPPORTED              0x4UL
+	#define CFA_EEM_QCAPS_RESP_FLAGS_DETACHED_CENTRALIZED_MEMORY_MODEL_SUPPORTED     0x8UL
 	__le32	unused_0;
 	__le32	supported;
 	#define CFA_EEM_QCAPS_RESP_SUPPORTED_KEY0_TABLE                       0x1UL
@@ -6226,7 +6341,9 @@ struct hwrm_cfa_eem_cfg_input {
 	#define CFA_EEM_CFG_REQ_FLAGS_PATH_TX               0x1UL
 	#define CFA_EEM_CFG_REQ_FLAGS_PATH_RX               0x2UL
 	#define CFA_EEM_CFG_REQ_FLAGS_PREFERRED_OFFLOAD     0x4UL
-	__le32	unused_0;
+	#define CFA_EEM_CFG_REQ_FLAGS_SECONDARY_PF          0x8UL
+	__le16	group_id;
+	__le16	unused_0;
 	__le32	num_entries;
 	__le32	unused_1;
 	__le16	key0_ctx_id;
@@ -6258,7 +6375,7 @@ struct hwrm_cfa_eem_qcfg_input {
 	__le32	unused_0;
 };
 
-/* hwrm_cfa_eem_qcfg_output (size:128b/16B) */
+/* hwrm_cfa_eem_qcfg_output (size:192b/24B) */
 struct hwrm_cfa_eem_qcfg_output {
 	__le16	error_code;
 	__le16	req_type;
@@ -6269,6 +6386,8 @@ struct hwrm_cfa_eem_qcfg_output {
 	#define CFA_EEM_QCFG_RESP_FLAGS_PATH_RX               0x2UL
 	#define CFA_EEM_QCFG_RESP_FLAGS_PREFERRED_OFFLOAD     0x4UL
 	__le32	num_entries;
+	u8	unused_0[7];
+	u8	valid;
 };
 
 /* hwrm_cfa_eem_op_input (size:192b/24B) */
@@ -6300,6 +6419,39 @@ struct hwrm_cfa_eem_op_output {
 	u8	valid;
 };
 
+/* hwrm_cfa_adv_flow_mgnt_qcaps_input (size:256b/32B) */
+struct hwrm_cfa_adv_flow_mgnt_qcaps_input {
+	__le16	req_type;
+	__le16	cmpl_ring;
+	__le16	seq_id;
+	__le16	target_id;
+	__le64	resp_addr;
+	__le32	unused_0[4];
+};
+
+/* hwrm_cfa_adv_flow_mgnt_qcaps_output (size:128b/16B) */
+struct hwrm_cfa_adv_flow_mgnt_qcaps_output {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
+	__le32	flags;
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_FLOW_HND_16BIT_SUPPORTED              0x1UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_FLOW_HND_64BIT_SUPPORTED              0x2UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_FLOW_BATCH_DELETE_SUPPORTED           0x4UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_FLOW_RESET_ALL_SUPPORTED              0x8UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_NTUPLE_FLOW_DEST_FUNC_SUPPORTED       0x10UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_TX_EEM_FLOW_SUPPORTED                 0x20UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_RX_EEM_FLOW_SUPPORTED                 0x40UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_FLOW_COUNTER_ALLOC_SUPPORTED          0x80UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_RFS_RING_TBL_IDX_SUPPORTED            0x100UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_UNTAGGED_VLAN_SUPPORTED               0x200UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_XDP_SUPPORTED                         0x400UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_L2_HEADER_SOURCE_FIELDS_SUPPORTED     0x800UL
+	u8	unused_0[3];
+	u8	valid;
+};
+
 /* hwrm_tunnel_dst_port_query_input (size:192b/24B) */
 struct hwrm_tunnel_dst_port_query_input {
 	__le16	req_type;
@@ -6636,7 +6788,8 @@ struct hwrm_fw_qstatus_output {
 	#define FW_QSTATUS_RESP_SELFRST_STATUS_SELFRSTNONE    0x0UL
 	#define FW_QSTATUS_RESP_SELFRST_STATUS_SELFRSTASAP    0x1UL
 	#define FW_QSTATUS_RESP_SELFRST_STATUS_SELFRSTPCIERST 0x2UL
-	#define FW_QSTATUS_RESP_SELFRST_STATUS_LAST          FW_QSTATUS_RESP_SELFRST_STATUS_SELFRSTPCIERST
+	#define FW_QSTATUS_RESP_SELFRST_STATUS_SELFRSTPOWER   0x3UL
+	#define FW_QSTATUS_RESP_SELFRST_STATUS_LAST          FW_QSTATUS_RESP_SELFRST_STATUS_SELFRSTPOWER
 	u8	unused_0[6];
 	u8	valid;
 };
@@ -6659,8 +6812,8 @@ struct hwrm_fw_set_time_input {
 	u8	unused_0;
 	__le16	millisecond;
 	__le16	zone;
-	#define FW_SET_TIME_REQ_ZONE_UTC     0x0UL
-	#define FW_SET_TIME_REQ_ZONE_UNKNOWN 0xffffUL
+	#define FW_SET_TIME_REQ_ZONE_UTC     0
+	#define FW_SET_TIME_REQ_ZONE_UNKNOWN 65535
 	#define FW_SET_TIME_REQ_ZONE_LAST   FW_SET_TIME_REQ_ZONE_UNKNOWN
 	u8	unused_1[4];
 };
@@ -7064,7 +7217,9 @@ struct hwrm_dbg_coredump_list_input {
 	__le64	host_dest_addr;
 	__le32	host_buf_len;
 	__le16	seq_no;
-	u8	unused_0[2];
+	u8	flags;
+	#define DBG_COREDUMP_LIST_REQ_FLAGS_CRASHDUMP     0x1UL
+	u8	unused_0[1];
 };
 
 /* hwrm_dbg_coredump_list_output (size:128b/16B) */
@@ -7392,7 +7547,9 @@ struct hwrm_nvm_get_dev_info_output {
 	__le32	nvram_size;
 	__le32	reserved_size;
 	__le32	available_size;
-	u8	unused_0[3];
+	u8	nvm_cfg_ver_maj;
+	u8	nvm_cfg_ver_min;
+	u8	nvm_cfg_ver_upd;
 	u8	valid;
 };
 
-- 
2.5.1

