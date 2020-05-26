Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5EF81C34E1
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbgEDIu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726864AbgEDIu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 04:50:58 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48152C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 01:50:58 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id w3so6529928plz.5
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 01:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nC2F+JA7r60ZmqAgmUlXNNExg/q5NDY/cRv3Eri1Kdg=;
        b=PFLcDGO66+mLKTi4T89or66NQJCV/mgAgrJrejh0Pv+a+v3/WiyqESfg25MKO3fRws
         ktsAwuqUkteRqhay/sNUyayBp8dsaA8sEyYv2lab0+/EGbmk2ffec49WZFtyKHP9Sg+S
         3V/LnVvHnISQtR3idAZHWKTB5HyXcHHchpTNo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nC2F+JA7r60ZmqAgmUlXNNExg/q5NDY/cRv3Eri1Kdg=;
        b=Y6+5PAxi2Cbk2vOKOT5U6XIvXPqKj29/XizkzhlLAMoizMPxU8gryZ7DgGdkR47InN
         0VtiAX++kIpsAtd6i0D6IsQbj0WnZP28j2TL+MLNQYKFpiGC0QjX8Prxw2AIcfipkoPu
         ZnUh4BqVPOe5qYEU7s6MFkglw6/F8kezgIYyg8Z8aEh1esuYZW7MYAdgv/DTEkdXmNOo
         +nyN/iyxSYvZBfg8CB9NQazvRgmFeKP57v6yo7FNuwdyNbQqFsyZGPqS+qEGxsWKp1Gd
         dydUOS/l+aWizYsLYZHwq2H86c5EeajA6TOzdofz5sH9OV5Rej7yQ5EdIa+V6u6egglr
         aQQA==
X-Gm-Message-State: AGi0PuYzSlA+BTjKdccfylsjQ03CDGYkxoAPaQpXbK6CriSTBU8dWlkX
        IFdDCdXHO3vvdQKbvTcbvPcWuQ==
X-Google-Smtp-Source: APiQypIR6rWHCKYyAVTUDuWF5m4fng99cJIOJnpsgdWXdUX5lCHQOy70osn+PBRnwpod1BfDGwlyPg==
X-Received: by 2002:a17:90a:fd16:: with SMTP id cv22mr15770238pjb.169.1588582257705;
        Mon, 04 May 2020 01:50:57 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x193sm8754088pfd.54.2020.05.04.01.50.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 May 2020 01:50:57 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 01/15] bnxt_en: Update firmware spec. to 1.10.1.33.
Date:   Mon,  4 May 2020 04:50:27 -0400
Message-Id: <1588582241-31066-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1588582241-31066-1-git-send-email-michael.chan@broadcom.com>
References: <1588582241-31066-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes include additional statistics, ECN support, context memory
interface change for better TQM context memory sizing, firmware
health status definitions, etc.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h | 216 ++++++++++++++++++++++----
 1 file changed, 184 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
index 7cf27df..7e9235c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
@@ -2,7 +2,7 @@
  *
  * Copyright (c) 2014-2016 Broadcom Corporation
  * Copyright (c) 2014-2018 Broadcom Limited
- * Copyright (c) 2018-2019 Broadcom Inc.
+ * Copyright (c) 2018-2020 Broadcom Inc.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -207,6 +207,8 @@ struct cmd_nums {
 	#define HWRM_PORT_PHY_MDIO_READ                   0xb6UL
 	#define HWRM_PORT_PHY_MDIO_BUS_ACQUIRE            0xb7UL
 	#define HWRM_PORT_PHY_MDIO_BUS_RELEASE            0xb8UL
+	#define HWRM_PORT_QSTATS_EXT_PFC_WD               0xb9UL
+	#define HWRM_PORT_ECN_QSTATS                      0xbaUL
 	#define HWRM_FW_RESET                             0xc0UL
 	#define HWRM_FW_QSTATUS                           0xc1UL
 	#define HWRM_FW_HEALTH_CHECK                      0xc2UL
@@ -220,6 +222,8 @@ struct cmd_nums {
 	#define HWRM_FW_SET_STRUCTURED_DATA               0xcaUL
 	#define HWRM_FW_GET_STRUCTURED_DATA               0xcbUL
 	#define HWRM_FW_IPC_MAILBOX                       0xccUL
+	#define HWRM_FW_ECN_CFG                           0xcdUL
+	#define HWRM_FW_ECN_QCFG                          0xceUL
 	#define HWRM_EXEC_FWD_RESP                        0xd0UL
 	#define HWRM_REJECT_FWD_RESP                      0xd1UL
 	#define HWRM_FWD_RESP                             0xd2UL
@@ -233,6 +237,7 @@ struct cmd_nums {
 	#define HWRM_TEMP_MONITOR_QUERY                   0xe0UL
 	#define HWRM_REG_POWER_QUERY                      0xe1UL
 	#define HWRM_CORE_FREQUENCY_QUERY                 0xe2UL
+	#define HWRM_REG_POWER_HISTOGRAM                  0xe3UL
 	#define HWRM_WOL_FILTER_ALLOC                     0xf0UL
 	#define HWRM_WOL_FILTER_FREE                      0xf1UL
 	#define HWRM_WOL_FILTER_QCFG                      0xf2UL
@@ -331,6 +336,7 @@ struct cmd_nums {
 	#define HWRM_FUNC_VF_BW_CFG                       0x195UL
 	#define HWRM_FUNC_VF_BW_QCFG                      0x196UL
 	#define HWRM_FUNC_HOST_PF_IDS_QUERY               0x197UL
+	#define HWRM_FUNC_QSTATS_EXT                      0x198UL
 	#define HWRM_SELFTEST_QLIST                       0x200UL
 	#define HWRM_SELFTEST_EXEC                        0x201UL
 	#define HWRM_SELFTEST_IRQ                         0x202UL
@@ -341,6 +347,31 @@ struct cmd_nums {
 	#define HWRM_MFG_OTP_CFG                          0x207UL
 	#define HWRM_MFG_OTP_QCFG                         0x208UL
 	#define HWRM_MFG_HDMA_TEST                        0x209UL
+	#define HWRM_MFG_FRU_EEPROM_WRITE                 0x20aUL
+	#define HWRM_MFG_FRU_EEPROM_READ                  0x20bUL
+	#define HWRM_TF                                   0x2bcUL
+	#define HWRM_TF_VERSION_GET                       0x2bdUL
+	#define HWRM_TF_SESSION_OPEN                      0x2c6UL
+	#define HWRM_TF_SESSION_ATTACH                    0x2c7UL
+	#define HWRM_TF_SESSION_CLOSE                     0x2c8UL
+	#define HWRM_TF_SESSION_QCFG                      0x2c9UL
+	#define HWRM_TF_SESSION_RESC_QCAPS                0x2caUL
+	#define HWRM_TF_SESSION_RESC_ALLOC                0x2cbUL
+	#define HWRM_TF_SESSION_RESC_FREE                 0x2ccUL
+	#define HWRM_TF_SESSION_RESC_FLUSH                0x2cdUL
+	#define HWRM_TF_TBL_TYPE_GET                      0x2d0UL
+	#define HWRM_TF_TBL_TYPE_SET                      0x2d1UL
+	#define HWRM_TF_CTXT_MEM_RGTR                     0x2daUL
+	#define HWRM_TF_CTXT_MEM_UNRGTR                   0x2dbUL
+	#define HWRM_TF_EXT_EM_QCAPS                      0x2dcUL
+	#define HWRM_TF_EXT_EM_OP                         0x2ddUL
+	#define HWRM_TF_EXT_EM_CFG                        0x2deUL
+	#define HWRM_TF_EXT_EM_QCFG                       0x2dfUL
+	#define HWRM_TF_TCAM_SET                          0x2eeUL
+	#define HWRM_TF_TCAM_GET                          0x2efUL
+	#define HWRM_TF_TCAM_MOVE                         0x2f0UL
+	#define HWRM_TF_TCAM_FREE                         0x2f1UL
+	#define HWRM_SV                                   0x400UL
 	#define HWRM_DBG_READ_DIRECT                      0xff10UL
 	#define HWRM_DBG_READ_INDIRECT                    0xff11UL
 	#define HWRM_DBG_WRITE_DIRECT                     0xff12UL
@@ -356,6 +387,10 @@ struct cmd_nums {
 	#define HWRM_DBG_RING_INFO_GET                    0xff1cUL
 	#define HWRM_DBG_CRASHDUMP_HEADER                 0xff1dUL
 	#define HWRM_DBG_CRASHDUMP_ERASE                  0xff1eUL
+	#define HWRM_DBG_DRV_TRACE                        0xff1fUL
+	#define HWRM_DBG_QCAPS                            0xff20UL
+	#define HWRM_DBG_QCFG                             0xff21UL
+	#define HWRM_DBG_CRASHDUMP_MEDIUM_CFG             0xff22UL
 	#define HWRM_NVM_FACTORY_DEFAULTS                 0xffeeUL
 	#define HWRM_NVM_VALIDATE_OPTION                  0xffefUL
 	#define HWRM_NVM_FLUSH                            0xfff0UL
@@ -429,8 +464,8 @@ struct hwrm_err_output {
 #define HWRM_VERSION_MAJOR 1
 #define HWRM_VERSION_MINOR 10
 #define HWRM_VERSION_UPDATE 1
-#define HWRM_VERSION_RSVD 12
-#define HWRM_VERSION_STR "1.10.1.12"
+#define HWRM_VERSION_RSVD 33
+#define HWRM_VERSION_STR "1.10.1.33"
 
 /* hwrm_ver_get_input (size:192b/24B) */
 struct hwrm_ver_get_input {
@@ -482,6 +517,7 @@ struct hwrm_ver_get_output {
 	#define VER_GET_RESP_DEV_CAPS_CFG_CFA_EEM_SUPPORTED                        0x800UL
 	#define VER_GET_RESP_DEV_CAPS_CFG_CFA_ADV_FLOW_MGNT_SUPPORTED              0x1000UL
 	#define VER_GET_RESP_DEV_CAPS_CFG_CFA_TFLIB_SUPPORTED                      0x2000UL
+	#define VER_GET_RESP_DEV_CAPS_CFG_CFA_TRUFLOW_SUPPORTED                    0x4000UL
 	u8	roce_fw_maj_8b;
 	u8	roce_fw_min_8b;
 	u8	roce_fw_bld_8b;
@@ -647,6 +683,7 @@ struct hwrm_async_event_cmpl {
 	#define ASYNC_EVENT_CMPL_EVENT_ID_TFLIB_LINK_STATUS_CHANGE   0x3eUL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_QUIESCE_DONE               0x3fUL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_DEFERRED_RESPONSE          0x40UL
+	#define ASYNC_EVENT_CMPL_EVENT_ID_PFC_WATCHDOG_CFG_CHANGE    0x41UL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_FW_TRACE_MSG               0xfeUL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_HWRM_ERROR                 0xffUL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_LAST                      ASYNC_EVENT_CMPL_EVENT_ID_HWRM_ERROR
@@ -1089,7 +1126,7 @@ struct hwrm_func_qcaps_input {
 	u8	unused_0[6];
 };
 
-/* hwrm_func_qcaps_output (size:640b/80B) */
+/* hwrm_func_qcaps_output (size:704b/88B) */
 struct hwrm_func_qcaps_output {
 	__le16	error_code;
 	__le16	req_type;
@@ -1126,6 +1163,10 @@ struct hwrm_func_qcaps_output {
 	#define FUNC_QCAPS_RESP_FLAGS_ERR_RECOVER_RELOAD                    0x2000000UL
 	#define FUNC_QCAPS_RESP_FLAGS_NOTIFY_VF_DEF_VNIC_CHNG_SUPPORTED     0x4000000UL
 	#define FUNC_QCAPS_RESP_FLAGS_VLAN_ACCELERATION_TX_DISABLED         0x8000000UL
+	#define FUNC_QCAPS_RESP_FLAGS_COREDUMP_CMD_SUPPORTED                0x10000000UL
+	#define FUNC_QCAPS_RESP_FLAGS_CRASHDUMP_CMD_SUPPORTED               0x20000000UL
+	#define FUNC_QCAPS_RESP_FLAGS_PFC_WD_STATS_SUPPORTED                0x40000000UL
+	#define FUNC_QCAPS_RESP_FLAGS_DBG_QCAPS_CMD_SUPPORTED               0x80000000UL
 	u8	mac_address[6];
 	__le16	max_rsscos_ctx;
 	__le16	max_cmpl_rings;
@@ -1146,7 +1187,12 @@ struct hwrm_func_qcaps_output {
 	__le32	max_flow_id;
 	__le32	max_hw_ring_grps;
 	__le16	max_sp_tx_rings;
-	u8	unused_0;
+	u8	unused_0[2];
+	__le32	flags_ext;
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_ECN_MARK_SUPPORTED         0x1UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_ECN_STATS_SUPPORTED        0x2UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_EXT_HW_STATS_SUPPORTED     0x4UL
+	u8	unused_1[3];
 	u8	valid;
 };
 
@@ -1161,7 +1207,7 @@ struct hwrm_func_qcfg_input {
 	u8	unused_0[6];
 };
 
-/* hwrm_func_qcfg_output (size:704b/88B) */
+/* hwrm_func_qcfg_output (size:768b/96B) */
 struct hwrm_func_qcfg_output {
 	__le16	error_code;
 	__le16	req_type;
@@ -1267,7 +1313,11 @@ struct hwrm_func_qcfg_output {
 	u8	always_1;
 	__le32	reset_addr_poll;
 	__le16	legacy_l2_db_size_kb;
-	u8	unused_2[1];
+	__le16	svif_info;
+	#define FUNC_QCFG_RESP_SVIF_INFO_SVIF_MASK      0x7fffUL
+	#define FUNC_QCFG_RESP_SVIF_INFO_SVIF_SFT       0
+	#define FUNC_QCFG_RESP_SVIF_INFO_SVIF_VALID     0x8000UL
+	u8	unused_2[7];
 	u8	valid;
 };
 
@@ -1420,9 +1470,10 @@ struct hwrm_func_qstats_input {
 	__le64	resp_addr;
 	__le16	fid;
 	u8	flags;
-	#define FUNC_QSTATS_REQ_FLAGS_UNUSED    0x0UL
-	#define FUNC_QSTATS_REQ_FLAGS_ROCE_ONLY 0x1UL
-	#define FUNC_QSTATS_REQ_FLAGS_LAST     FUNC_QSTATS_REQ_FLAGS_ROCE_ONLY
+	#define FUNC_QSTATS_REQ_FLAGS_UNUSED       0x0UL
+	#define FUNC_QSTATS_REQ_FLAGS_ROCE_ONLY    0x1UL
+	#define FUNC_QSTATS_REQ_FLAGS_COUNTER_MASK 0x2UL
+	#define FUNC_QSTATS_REQ_FLAGS_LAST        FUNC_QSTATS_REQ_FLAGS_COUNTER_MASK
 	u8	unused_0[5];
 };
 
@@ -1456,6 +1507,53 @@ struct hwrm_func_qstats_output {
 	u8	valid;
 };
 
+/* hwrm_func_qstats_ext_input (size:192b/24B) */
+struct hwrm_func_qstats_ext_input {
+	__le16	req_type;
+	__le16	cmpl_ring;
+	__le16	seq_id;
+	__le16	target_id;
+	__le64	resp_addr;
+	__le16	fid;
+	u8	flags;
+	#define FUNC_QSTATS_EXT_REQ_FLAGS_UNUSED       0x0UL
+	#define FUNC_QSTATS_EXT_REQ_FLAGS_ROCE_ONLY    0x1UL
+	#define FUNC_QSTATS_EXT_REQ_FLAGS_COUNTER_MASK 0x2UL
+	#define FUNC_QSTATS_EXT_REQ_FLAGS_LAST        FUNC_QSTATS_EXT_REQ_FLAGS_COUNTER_MASK
+	u8	unused_0[5];
+};
+
+/* hwrm_func_qstats_ext_output (size:1472b/184B) */
+struct hwrm_func_qstats_ext_output {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
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
+	u8	unused_0[7];
+	u8	valid;
+};
+
 /* hwrm_func_clr_stats_input (size:192b/24B) */
 struct hwrm_func_clr_stats_input {
 	__le16	req_type;
@@ -1808,7 +1906,7 @@ struct hwrm_func_backing_store_qcaps_output {
 	u8	ctx_kind_initializer;
 	__le32	rsvd;
 	__le16	rsvd1;
-	u8	rsvd2;
+	u8	tqm_fp_rings_count;
 	u8	valid;
 };
 
@@ -2231,7 +2329,17 @@ struct hwrm_error_recovery_qcfg_output {
 	#define ERROR_RECOVERY_QCFG_RESP_RESET_REG_ADDR_SFT           2
 	__le32	reset_reg_val[16];
 	u8	delay_after_reset[16];
-	u8	unused_1[7];
+	__le32	err_recovery_cnt_reg;
+	#define ERROR_RECOVERY_QCFG_RESP_ERR_RECOVERY_CNT_REG_ADDR_SPACE_MASK    0x3UL
+	#define ERROR_RECOVERY_QCFG_RESP_ERR_RECOVERY_CNT_REG_ADDR_SPACE_SFT     0
+	#define ERROR_RECOVERY_QCFG_RESP_ERR_RECOVERY_CNT_REG_ADDR_SPACE_PCIE_CFG  0x0UL
+	#define ERROR_RECOVERY_QCFG_RESP_ERR_RECOVERY_CNT_REG_ADDR_SPACE_GRC       0x1UL
+	#define ERROR_RECOVERY_QCFG_RESP_ERR_RECOVERY_CNT_REG_ADDR_SPACE_BAR0      0x2UL
+	#define ERROR_RECOVERY_QCFG_RESP_ERR_RECOVERY_CNT_REG_ADDR_SPACE_BAR1      0x3UL
+	#define ERROR_RECOVERY_QCFG_RESP_ERR_RECOVERY_CNT_REG_ADDR_SPACE_LAST     ERROR_RECOVERY_QCFG_RESP_ERR_RECOVERY_CNT_REG_ADDR_SPACE_BAR1
+	#define ERROR_RECOVERY_QCFG_RESP_ERR_RECOVERY_CNT_REG_ADDR_MASK          0xfffffffcUL
+	#define ERROR_RECOVERY_QCFG_RESP_ERR_RECOVERY_CNT_REG_ADDR_SFT           2
+	u8	unused_1[3];
 	u8	valid;
 };
 
@@ -2934,7 +3042,11 @@ struct hwrm_port_qstats_input {
 	__le16	target_id;
 	__le64	resp_addr;
 	__le16	port_id;
-	u8	unused_0[6];
+	u8	flags;
+	#define PORT_QSTATS_REQ_FLAGS_UNUSED       0x0UL
+	#define PORT_QSTATS_REQ_FLAGS_COUNTER_MASK 0x1UL
+	#define PORT_QSTATS_REQ_FLAGS_LAST        PORT_QSTATS_REQ_FLAGS_COUNTER_MASK
+	u8	unused_0[5];
 	__le64	tx_stat_host_addr;
 	__le64	rx_stat_host_addr;
 };
@@ -3058,7 +3170,11 @@ struct hwrm_port_qstats_ext_input {
 	__le16	port_id;
 	__le16	tx_stat_size;
 	__le16	rx_stat_size;
-	u8	unused_0[2];
+	u8	flags;
+	#define PORT_QSTATS_EXT_REQ_FLAGS_UNUSED       0x0UL
+	#define PORT_QSTATS_EXT_REQ_FLAGS_COUNTER_MASK 0x1UL
+	#define PORT_QSTATS_EXT_REQ_FLAGS_LAST        PORT_QSTATS_EXT_REQ_FLAGS_COUNTER_MASK
+	u8	unused_0;
 	__le64	tx_stat_host_addr;
 	__le64	rx_stat_host_addr;
 };
@@ -3840,14 +3956,22 @@ struct hwrm_queue_pfcenable_qcfg_output {
 	__le16	seq_id;
 	__le16	resp_len;
 	__le32	flags;
-	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI0_PFC_ENABLED     0x1UL
-	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI1_PFC_ENABLED     0x2UL
-	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI2_PFC_ENABLED     0x4UL
-	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI3_PFC_ENABLED     0x8UL
-	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI4_PFC_ENABLED     0x10UL
-	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI5_PFC_ENABLED     0x20UL
-	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI6_PFC_ENABLED     0x40UL
-	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI7_PFC_ENABLED     0x80UL
+	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI0_PFC_ENABLED              0x1UL
+	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI1_PFC_ENABLED              0x2UL
+	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI2_PFC_ENABLED              0x4UL
+	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI3_PFC_ENABLED              0x8UL
+	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI4_PFC_ENABLED              0x10UL
+	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI5_PFC_ENABLED              0x20UL
+	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI6_PFC_ENABLED              0x40UL
+	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI7_PFC_ENABLED              0x80UL
+	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI0_PFC_WATCHDOG_ENABLED     0x100UL
+	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI1_PFC_WATCHDOG_ENABLED     0x200UL
+	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI2_PFC_WATCHDOG_ENABLED     0x400UL
+	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI3_PFC_WATCHDOG_ENABLED     0x800UL
+	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI4_PFC_WATCHDOG_ENABLED     0x1000UL
+	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI5_PFC_WATCHDOG_ENABLED     0x2000UL
+	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI6_PFC_WATCHDOG_ENABLED     0x4000UL
+	#define QUEUE_PFCENABLE_QCFG_RESP_FLAGS_PRI7_PFC_WATCHDOG_ENABLED     0x8000UL
 	u8	unused_0[3];
 	u8	valid;
 };
@@ -3860,14 +3984,22 @@ struct hwrm_queue_pfcenable_cfg_input {
 	__le16	target_id;
 	__le64	resp_addr;
 	__le32	flags;
-	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI0_PFC_ENABLED     0x1UL
-	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI1_PFC_ENABLED     0x2UL
-	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI2_PFC_ENABLED     0x4UL
-	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI3_PFC_ENABLED     0x8UL
-	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI4_PFC_ENABLED     0x10UL
-	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI5_PFC_ENABLED     0x20UL
-	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI6_PFC_ENABLED     0x40UL
-	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI7_PFC_ENABLED     0x80UL
+	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI0_PFC_ENABLED              0x1UL
+	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI1_PFC_ENABLED              0x2UL
+	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI2_PFC_ENABLED              0x4UL
+	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI3_PFC_ENABLED              0x8UL
+	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI4_PFC_ENABLED              0x10UL
+	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI5_PFC_ENABLED              0x20UL
+	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI6_PFC_ENABLED              0x40UL
+	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI7_PFC_ENABLED              0x80UL
+	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI0_PFC_WATCHDOG_ENABLED     0x100UL
+	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI1_PFC_WATCHDOG_ENABLED     0x200UL
+	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI2_PFC_WATCHDOG_ENABLED     0x400UL
+	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI3_PFC_WATCHDOG_ENABLED     0x800UL
+	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI4_PFC_WATCHDOG_ENABLED     0x1000UL
+	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI5_PFC_WATCHDOG_ENABLED     0x2000UL
+	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI6_PFC_WATCHDOG_ENABLED     0x4000UL
+	#define QUEUE_PFCENABLE_CFG_REQ_FLAGS_PRI7_PFC_WATCHDOG_ENABLED     0x8000UL
 	__le16	port_id;
 	u8	unused_0[2];
 };
@@ -5287,7 +5419,11 @@ struct hwrm_ring_cmpl_ring_qaggint_params_input {
 	__le16	target_id;
 	__le64	resp_addr;
 	__le16	ring_id;
-	u8	unused_0[6];
+	__le16	flags;
+	#define RING_CMPL_RING_QAGGINT_PARAMS_REQ_FLAGS_UNUSED_0_MASK 0x3UL
+	#define RING_CMPL_RING_QAGGINT_PARAMS_REQ_FLAGS_UNUSED_0_SFT 0
+	#define RING_CMPL_RING_QAGGINT_PARAMS_REQ_FLAGS_IS_NQ        0x4UL
+	u8	unused_0[4];
 };
 
 /* hwrm_ring_cmpl_ring_qaggint_params_output (size:256b/32B) */
@@ -7618,7 +7754,9 @@ struct hwrm_nvm_modify_input {
 	__le64	resp_addr;
 	__le64	host_src_addr;
 	__le16	dir_idx;
-	u8	unused_0[2];
+	__le16	flags;
+	#define NVM_MODIFY_REQ_FLAGS_BATCH_MODE     0x1UL
+	#define NVM_MODIFY_REQ_FLAGS_BATCH_LAST     0x2UL
 	__le32	offset;
 	__le32	len;
 	u8	unused_1[4];
@@ -8027,4 +8165,18 @@ struct hwrm_selftest_irq_output {
 	u8	valid;
 };
 
+/* fw_status_reg (size:32b/4B) */
+struct fw_status_reg {
+	u32	fw_status;
+	#define FW_STATUS_REG_CODE_MASK              0xffffUL
+	#define FW_STATUS_REG_CODE_SFT               0
+	#define FW_STATUS_REG_CODE_READY               0x8000UL
+	#define FW_STATUS_REG_CODE_LAST               FW_STATUS_REG_CODE_READY
+	#define FW_STATUS_REG_IMAGE_DEGRADED         0x10000UL
+	#define FW_STATUS_REG_RECOVERABLE            0x20000UL
+	#define FW_STATUS_REG_CRASHDUMP_ONGOING      0x40000UL
+	#define FW_STATUS_REG_CRASHDUMP_COMPLETE     0x80000UL
+	#define FW_STATUS_REG_SHUTDOWN               0x100000UL
+};
+
 #endif /* _BNXT_HSI_H_ */
-- 
2.5.1

