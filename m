Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4333D3949B6
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 02:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbhE2AzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 20:55:01 -0400
Received: from saphodev.broadcom.com ([192.19.11.229]:39874 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229614AbhE2Ay7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 20:54:59 -0400
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id D34D77DAE;
        Fri, 28 May 2021 17:53:22 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com D34D77DAE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1622249603;
        bh=iEC7cE0I70Xm6irMrS+9BBpgLNqxBIc2iHCtWXys9Rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HiLWF7YBYnBF+HKjU+vWoHJj38fwj8lakVbdFuNvLA77c/Ff4kq0sUTyASjx0OT6H
         ulaNVy84kX3vbgIMI0WBZUs4wBeJqlsDcr8CViyj08VaQH8qA/laTHvfNDae4iLm4h
         sOGxSiF3/Q3IoqiYP/oG4+Kg4EIQcE69EFOWMkaQ=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        richardcochran@gmail.com, pavan.chebbi@broadcom.com,
        edwin.peer@broadcom.com
Subject: [PATCH net-next 1/7] bnxt_en: Update firmware interface to 1.10.2.34.
Date:   Fri, 28 May 2021 20:53:15 -0400
Message-Id: <1622249601-7106-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622249601-7106-1-git-send-email-michael.chan@broadcom.com>
References: <1622249601-7106-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding the PTP related firmware interface is the main change.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h | 434 +++++++++++++++++-
 1 file changed, 417 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
index 6199f125bc13..e0f415ab4d0f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
@@ -189,6 +189,8 @@ struct cmd_nums {
 	#define HWRM_QUEUE_VLANPRI_QCAPS                  0x83UL
 	#define HWRM_QUEUE_VLANPRI2PRI_QCFG               0x84UL
 	#define HWRM_QUEUE_VLANPRI2PRI_CFG                0x85UL
+	#define HWRM_QUEUE_GLOBAL_CFG                     0x86UL
+	#define HWRM_QUEUE_GLOBAL_QCFG                    0x87UL
 	#define HWRM_CFA_L2_FILTER_ALLOC                  0x90UL
 	#define HWRM_CFA_L2_FILTER_FREE                   0x91UL
 	#define HWRM_CFA_L2_FILTER_CFG                    0x92UL
@@ -305,6 +307,8 @@ struct cmd_nums {
 	#define HWRM_CFA_EEM_OP                           0x123UL
 	#define HWRM_CFA_ADV_FLOW_MGNT_QCAPS              0x124UL
 	#define HWRM_CFA_TFLIB                            0x125UL
+	#define HWRM_CFA_LAG_GROUP_MEMBER_RGTR            0x126UL
+	#define HWRM_CFA_LAG_GROUP_MEMBER_UNRGTR          0x127UL
 	#define HWRM_ENGINE_CKV_STATUS                    0x12eUL
 	#define HWRM_ENGINE_CKV_CKEK_ADD                  0x12fUL
 	#define HWRM_ENGINE_CKV_CKEK_DELETE               0x130UL
@@ -356,6 +360,10 @@ struct cmd_nums {
 	#define HWRM_STAT_EXT_CTX_QUERY                   0x199UL
 	#define HWRM_FUNC_SPD_CFG                         0x19aUL
 	#define HWRM_FUNC_SPD_QCFG                        0x19bUL
+	#define HWRM_FUNC_PTP_PIN_QCFG                    0x19cUL
+	#define HWRM_FUNC_PTP_PIN_CFG                     0x19dUL
+	#define HWRM_FUNC_PTP_CFG                         0x19eUL
+	#define HWRM_FUNC_PTP_TS_QUERY                    0x19fUL
 	#define HWRM_SELFTEST_QLIST                       0x200UL
 	#define HWRM_SELFTEST_EXEC                        0x201UL
 	#define HWRM_SELFTEST_IRQ                         0x202UL
@@ -385,6 +393,7 @@ struct cmd_nums {
 	#define HWRM_TF_SESSION_RESC_ALLOC                0x2cdUL
 	#define HWRM_TF_SESSION_RESC_FREE                 0x2ceUL
 	#define HWRM_TF_SESSION_RESC_FLUSH                0x2cfUL
+	#define HWRM_TF_SESSION_RESC_INFO                 0x2d0UL
 	#define HWRM_TF_TBL_TYPE_GET                      0x2daUL
 	#define HWRM_TF_TBL_TYPE_SET                      0x2dbUL
 	#define HWRM_TF_TBL_TYPE_BULK_GET                 0x2dcUL
@@ -399,6 +408,7 @@ struct cmd_nums {
 	#define HWRM_TF_EM_INSERT                         0x2eaUL
 	#define HWRM_TF_EM_DELETE                         0x2ebUL
 	#define HWRM_TF_EM_HASH_INSERT                    0x2ecUL
+	#define HWRM_TF_EM_MOVE                           0x2edUL
 	#define HWRM_TF_TCAM_SET                          0x2f8UL
 	#define HWRM_TF_TCAM_GET                          0x2f9UL
 	#define HWRM_TF_TCAM_MOVE                         0x2faUL
@@ -427,6 +437,15 @@ struct cmd_nums {
 	#define HWRM_DBG_QCAPS                            0xff20UL
 	#define HWRM_DBG_QCFG                             0xff21UL
 	#define HWRM_DBG_CRASHDUMP_MEDIUM_CFG             0xff22UL
+	#define HWRM_DBG_USEQ_ALLOC                       0xff23UL
+	#define HWRM_DBG_USEQ_FREE                        0xff24UL
+	#define HWRM_DBG_USEQ_FLUSH                       0xff25UL
+	#define HWRM_DBG_USEQ_QCAPS                       0xff26UL
+	#define HWRM_DBG_USEQ_CW_CFG                      0xff27UL
+	#define HWRM_DBG_USEQ_SCHED_CFG                   0xff28UL
+	#define HWRM_DBG_USEQ_RUN                         0xff29UL
+	#define HWRM_DBG_USEQ_DELIVERY_REQ                0xff2aUL
+	#define HWRM_DBG_USEQ_RESP_HDR                    0xff2bUL
 	#define HWRM_NVM_REQ_ARBITRATION                  0xffedUL
 	#define HWRM_NVM_FACTORY_DEFAULTS                 0xffeeUL
 	#define HWRM_NVM_VALIDATE_OPTION                  0xffefUL
@@ -502,8 +521,8 @@ struct hwrm_err_output {
 #define HWRM_VERSION_MAJOR 1
 #define HWRM_VERSION_MINOR 10
 #define HWRM_VERSION_UPDATE 2
-#define HWRM_VERSION_RSVD 16
-#define HWRM_VERSION_STR "1.10.2.16"
+#define HWRM_VERSION_RSVD 34
+#define HWRM_VERSION_STR "1.10.2.34"
 
 /* hwrm_ver_get_input (size:192b/24B) */
 struct hwrm_ver_get_input {
@@ -725,7 +744,9 @@ struct hwrm_async_event_cmpl {
 	#define ASYNC_EVENT_CMPL_EVENT_ID_DEFERRED_RESPONSE          0x40UL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_PFC_WATCHDOG_CFG_CHANGE    0x41UL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_ECHO_REQUEST               0x42UL
-	#define ASYNC_EVENT_CMPL_EVENT_ID_MAX_RGTR_EVENT_ID          0x43UL
+	#define ASYNC_EVENT_CMPL_EVENT_ID_PHC_MASTER                 0x43UL
+	#define ASYNC_EVENT_CMPL_EVENT_ID_PPS_TIMESTAMP              0x44UL
+	#define ASYNC_EVENT_CMPL_EVENT_ID_MAX_RGTR_EVENT_ID          0x45UL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_FW_TRACE_MSG               0xfeUL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_HWRM_ERROR                 0xffUL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_LAST                      ASYNC_EVENT_CMPL_EVENT_ID_HWRM_ERROR
@@ -919,6 +940,8 @@ struct hwrm_async_event_cmpl_vf_cfg_change {
 	#define ASYNC_EVENT_CMPL_VF_CFG_CHANGE_EVENT_ID_VF_CFG_CHANGE 0x33UL
 	#define ASYNC_EVENT_CMPL_VF_CFG_CHANGE_EVENT_ID_LAST         ASYNC_EVENT_CMPL_VF_CFG_CHANGE_EVENT_ID_VF_CFG_CHANGE
 	__le32	event_data2;
+	#define ASYNC_EVENT_CMPL_VF_CFG_CHANGE_EVENT_DATA2_VF_ID_MASK 0xffffUL
+	#define ASYNC_EVENT_CMPL_VF_CFG_CHANGE_EVENT_DATA2_VF_ID_SFT 0
 	u8	opaque_v;
 	#define ASYNC_EVENT_CMPL_VF_CFG_CHANGE_V          0x1UL
 	#define ASYNC_EVENT_CMPL_VF_CFG_CHANGE_OPAQUE_MASK 0xfeUL
@@ -1074,6 +1097,60 @@ struct hwrm_async_event_cmpl_echo_request {
 	__le32	event_data1;
 };
 
+/* hwrm_async_event_cmpl_phc_master (size:128b/16B) */
+struct hwrm_async_event_cmpl_phc_master {
+	__le16	type;
+	#define ASYNC_EVENT_CMPL_PHC_MASTER_TYPE_MASK            0x3fUL
+	#define ASYNC_EVENT_CMPL_PHC_MASTER_TYPE_SFT             0
+	#define ASYNC_EVENT_CMPL_PHC_MASTER_TYPE_HWRM_ASYNC_EVENT  0x2eUL
+	#define ASYNC_EVENT_CMPL_PHC_MASTER_TYPE_LAST             ASYNC_EVENT_CMPL_PHC_MASTER_TYPE_HWRM_ASYNC_EVENT
+	__le16	event_id;
+	#define ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_ID_PHC_MASTER 0x43UL
+	#define ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_ID_LAST      ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_ID_PHC_MASTER
+	__le32	event_data2;
+	u8	opaque_v;
+	#define ASYNC_EVENT_CMPL_PHC_MASTER_V          0x1UL
+	#define ASYNC_EVENT_CMPL_PHC_MASTER_OPAQUE_MASK 0xfeUL
+	#define ASYNC_EVENT_CMPL_PHC_MASTER_OPAQUE_SFT 1
+	u8	timestamp_lo;
+	__le16	timestamp_hi;
+	__le32	event_data1;
+	#define ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_DATA1_FLAGS_MASK                0xffUL
+	#define ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_DATA1_FLAGS_SFT                 0
+	#define ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_DATA1_FLAGS_MASTER_FUNC          0x1UL
+	#define ASYNC_EVENT_CMPL_PHC_MASTER_EVENT_DATA1_FLAGS_MASTER_SELECTED      0x2UL
+};
+
+/* hwrm_async_event_cmpl_pps_timestamp (size:128b/16B) */
+struct hwrm_async_event_cmpl_pps_timestamp {
+	__le16	type;
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_TYPE_MASK            0x3fUL
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_TYPE_SFT             0
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_TYPE_HWRM_ASYNC_EVENT  0x2eUL
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_TYPE_LAST             ASYNC_EVENT_CMPL_PPS_TIMESTAMP_TYPE_HWRM_ASYNC_EVENT
+	__le16	event_id;
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_ID_PPS_TIMESTAMP 0x44UL
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_ID_LAST         ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_ID_PPS_TIMESTAMP
+	__le32	event_data2;
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_EVENT_TYPE              0x1UL
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_EVENT_TYPE_INTERNAL       0x0UL
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_EVENT_TYPE_EXTERNAL       0x1UL
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_EVENT_TYPE_LAST          ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_EVENT_TYPE_EXTERNAL
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_PIN_NUMBER_MASK         0xeUL
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_PIN_NUMBER_SFT          1
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_PPS_TIMESTAMP_UPPER_MASK 0xffff0UL
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_PPS_TIMESTAMP_UPPER_SFT 4
+	u8	opaque_v;
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_V          0x1UL
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_OPAQUE_MASK 0xfeUL
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_OPAQUE_SFT 1
+	u8	timestamp_lo;
+	__le16	timestamp_hi;
+	__le32	event_data1;
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA1_PPS_TIMESTAMP_LOWER_MASK 0xffffffffUL
+	#define ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA1_PPS_TIMESTAMP_LOWER_SFT 0
+};
+
 /* hwrm_func_reset_input (size:192b/24B) */
 struct hwrm_func_reset_input {
 	__le16	req_type;
@@ -1320,6 +1397,13 @@ struct hwrm_func_qcaps_output {
 	#define FUNC_QCAPS_RESP_FLAGS_EXT_NVM_OPTION_ACTION_SUPPORTED            0x2000UL
 	#define FUNC_QCAPS_RESP_FLAGS_EXT_BD_METADATA_SUPPORTED                  0x4000UL
 	#define FUNC_QCAPS_RESP_FLAGS_EXT_ECHO_REQUEST_SUPPORTED                 0x8000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_NPAR_1_2_SUPPORTED                     0x10000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_PTP_PTM_SUPPORTED                      0x20000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_PTP_PPS_SUPPORTED                      0x40000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_VF_CFG_ASYNC_FOR_PF_SUPPORTED          0x80000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_PARTITION_BW_SUPPORTED                 0x100000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_DFLT_VLAN_TPID_PCP_SUPPORTED           0x200000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_KTLS_SUPPORTED                         0x400000UL
 	u8	max_schqs;
 	u8	mpc_chnls_cap;
 	#define FUNC_QCAPS_RESP_MPC_CHNLS_CAP_TCE         0x1UL
@@ -1342,7 +1426,7 @@ struct hwrm_func_qcfg_input {
 	u8	unused_0[6];
 };
 
-/* hwrm_func_qcfg_output (size:768b/96B) */
+/* hwrm_func_qcfg_output (size:832b/104B) */
 struct hwrm_func_qcfg_output {
 	__le16	error_code;
 	__le16	req_type;
@@ -1383,6 +1467,7 @@ struct hwrm_func_qcfg_output {
 	#define FUNC_QCFG_RESP_PORT_PARTITION_TYPE_NPAR1_0 0x2UL
 	#define FUNC_QCFG_RESP_PORT_PARTITION_TYPE_NPAR1_5 0x3UL
 	#define FUNC_QCFG_RESP_PORT_PARTITION_TYPE_NPAR2_0 0x4UL
+	#define FUNC_QCFG_RESP_PORT_PARTITION_TYPE_NPAR1_2 0x5UL
 	#define FUNC_QCFG_RESP_PORT_PARTITION_TYPE_UNKNOWN 0xffUL
 	#define FUNC_QCFG_RESP_PORT_PARTITION_TYPE_LAST   FUNC_QCFG_RESP_PORT_PARTITION_TYPE_UNKNOWN
 	u8	port_pf_cnt;
@@ -1463,11 +1548,34 @@ struct hwrm_func_qcfg_output {
 	#define FUNC_QCFG_RESP_MPC_CHNLS_TE_CFA_ENABLED      0x4UL
 	#define FUNC_QCFG_RESP_MPC_CHNLS_RE_CFA_ENABLED      0x8UL
 	#define FUNC_QCFG_RESP_MPC_CHNLS_PRIMATE_ENABLED     0x10UL
-	u8	unused_2[6];
+	u8	unused_2[3];
+	__le32	partition_min_bw;
+	#define FUNC_QCFG_RESP_PARTITION_MIN_BW_BW_VALUE_MASK             0xfffffffUL
+	#define FUNC_QCFG_RESP_PARTITION_MIN_BW_BW_VALUE_SFT              0
+	#define FUNC_QCFG_RESP_PARTITION_MIN_BW_SCALE                     0x10000000UL
+	#define FUNC_QCFG_RESP_PARTITION_MIN_BW_SCALE_BITS                  (0x0UL << 28)
+	#define FUNC_QCFG_RESP_PARTITION_MIN_BW_SCALE_BYTES                 (0x1UL << 28)
+	#define FUNC_QCFG_RESP_PARTITION_MIN_BW_SCALE_LAST                 FUNC_QCFG_RESP_PARTITION_MIN_BW_SCALE_BYTES
+	#define FUNC_QCFG_RESP_PARTITION_MIN_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
+	#define FUNC_QCFG_RESP_PARTITION_MIN_BW_BW_VALUE_UNIT_SFT         29
+	#define FUNC_QCFG_RESP_PARTITION_MIN_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
+	#define FUNC_QCFG_RESP_PARTITION_MIN_BW_BW_VALUE_UNIT_LAST         FUNC_QCFG_RESP_PARTITION_MIN_BW_BW_VALUE_UNIT_PERCENT1_100
+	__le32	partition_max_bw;
+	#define FUNC_QCFG_RESP_PARTITION_MAX_BW_BW_VALUE_MASK             0xfffffffUL
+	#define FUNC_QCFG_RESP_PARTITION_MAX_BW_BW_VALUE_SFT              0
+	#define FUNC_QCFG_RESP_PARTITION_MAX_BW_SCALE                     0x10000000UL
+	#define FUNC_QCFG_RESP_PARTITION_MAX_BW_SCALE_BITS                  (0x0UL << 28)
+	#define FUNC_QCFG_RESP_PARTITION_MAX_BW_SCALE_BYTES                 (0x1UL << 28)
+	#define FUNC_QCFG_RESP_PARTITION_MAX_BW_SCALE_LAST                 FUNC_QCFG_RESP_PARTITION_MAX_BW_SCALE_BYTES
+	#define FUNC_QCFG_RESP_PARTITION_MAX_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
+	#define FUNC_QCFG_RESP_PARTITION_MAX_BW_BW_VALUE_UNIT_SFT         29
+	#define FUNC_QCFG_RESP_PARTITION_MAX_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
+	#define FUNC_QCFG_RESP_PARTITION_MAX_BW_BW_VALUE_UNIT_LAST         FUNC_QCFG_RESP_PARTITION_MAX_BW_BW_VALUE_UNIT_PERCENT1_100
+	u8	unused_3[3];
 	u8	valid;
 };
 
-/* hwrm_func_cfg_input (size:768b/96B) */
+/* hwrm_func_cfg_input (size:832b/104B) */
 struct hwrm_func_cfg_input {
 	__le16	req_type;
 	__le16	cmpl_ring;
@@ -1530,6 +1638,9 @@ struct hwrm_func_cfg_input {
 	#define FUNC_CFG_REQ_ENABLES_HOT_RESET_IF_SUPPORT     0x800000UL
 	#define FUNC_CFG_REQ_ENABLES_SCHQ_ID                  0x1000000UL
 	#define FUNC_CFG_REQ_ENABLES_MPC_CHNLS                0x2000000UL
+	#define FUNC_CFG_REQ_ENABLES_PARTITION_MIN_BW         0x4000000UL
+	#define FUNC_CFG_REQ_ENABLES_PARTITION_MAX_BW         0x8000000UL
+	#define FUNC_CFG_REQ_ENABLES_TPID                     0x10000000UL
 	__le16	mtu;
 	__le16	mru;
 	__le16	num_rsscos_ctxs;
@@ -1615,7 +1726,30 @@ struct hwrm_func_cfg_input {
 	#define FUNC_CFG_REQ_MPC_CHNLS_RE_CFA_DISABLE      0x80UL
 	#define FUNC_CFG_REQ_MPC_CHNLS_PRIMATE_ENABLE      0x100UL
 	#define FUNC_CFG_REQ_MPC_CHNLS_PRIMATE_DISABLE     0x200UL
-	u8	unused_0[4];
+	__le32	partition_min_bw;
+	#define FUNC_CFG_REQ_PARTITION_MIN_BW_BW_VALUE_MASK             0xfffffffUL
+	#define FUNC_CFG_REQ_PARTITION_MIN_BW_BW_VALUE_SFT              0
+	#define FUNC_CFG_REQ_PARTITION_MIN_BW_SCALE                     0x10000000UL
+	#define FUNC_CFG_REQ_PARTITION_MIN_BW_SCALE_BITS                  (0x0UL << 28)
+	#define FUNC_CFG_REQ_PARTITION_MIN_BW_SCALE_BYTES                 (0x1UL << 28)
+	#define FUNC_CFG_REQ_PARTITION_MIN_BW_SCALE_LAST                 FUNC_CFG_REQ_PARTITION_MIN_BW_SCALE_BYTES
+	#define FUNC_CFG_REQ_PARTITION_MIN_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
+	#define FUNC_CFG_REQ_PARTITION_MIN_BW_BW_VALUE_UNIT_SFT         29
+	#define FUNC_CFG_REQ_PARTITION_MIN_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
+	#define FUNC_CFG_REQ_PARTITION_MIN_BW_BW_VALUE_UNIT_LAST         FUNC_CFG_REQ_PARTITION_MIN_BW_BW_VALUE_UNIT_PERCENT1_100
+	__le32	partition_max_bw;
+	#define FUNC_CFG_REQ_PARTITION_MAX_BW_BW_VALUE_MASK             0xfffffffUL
+	#define FUNC_CFG_REQ_PARTITION_MAX_BW_BW_VALUE_SFT              0
+	#define FUNC_CFG_REQ_PARTITION_MAX_BW_SCALE                     0x10000000UL
+	#define FUNC_CFG_REQ_PARTITION_MAX_BW_SCALE_BITS                  (0x0UL << 28)
+	#define FUNC_CFG_REQ_PARTITION_MAX_BW_SCALE_BYTES                 (0x1UL << 28)
+	#define FUNC_CFG_REQ_PARTITION_MAX_BW_SCALE_LAST                 FUNC_CFG_REQ_PARTITION_MAX_BW_SCALE_BYTES
+	#define FUNC_CFG_REQ_PARTITION_MAX_BW_BW_VALUE_UNIT_MASK        0xe0000000UL
+	#define FUNC_CFG_REQ_PARTITION_MAX_BW_BW_VALUE_UNIT_SFT         29
+	#define FUNC_CFG_REQ_PARTITION_MAX_BW_BW_VALUE_UNIT_PERCENT1_100  (0x1UL << 29)
+	#define FUNC_CFG_REQ_PARTITION_MAX_BW_BW_VALUE_UNIT_LAST         FUNC_CFG_REQ_PARTITION_MAX_BW_BW_VALUE_UNIT_PERCENT1_100
+	__be16	tpid;
+	u8	unused_0[2];
 };
 
 /* hwrm_func_cfg_output (size:128b/16B) */
@@ -2047,7 +2181,7 @@ struct hwrm_func_backing_store_qcaps_input {
 	__le64	resp_addr;
 };
 
-/* hwrm_func_backing_store_qcaps_output (size:704b/88B) */
+/* hwrm_func_backing_store_qcaps_output (size:832b/104B) */
 struct hwrm_func_backing_store_qcaps_output {
 	__le16	error_code;
 	__le16	req_type;
@@ -2085,6 +2219,8 @@ struct hwrm_func_backing_store_qcaps_output {
 	#define FUNC_BACKING_STORE_QCAPS_RESP_CTX_INIT_MASK_VNIC     0x8UL
 	#define FUNC_BACKING_STORE_QCAPS_RESP_CTX_INIT_MASK_STAT     0x10UL
 	#define FUNC_BACKING_STORE_QCAPS_RESP_CTX_INIT_MASK_MRAV     0x20UL
+	#define FUNC_BACKING_STORE_QCAPS_RESP_CTX_INIT_MASK_TKC      0x40UL
+	#define FUNC_BACKING_STORE_QCAPS_RESP_CTX_INIT_MASK_RKC      0x80UL
 	u8	qp_init_offset;
 	u8	srq_init_offset;
 	u8	cq_init_offset;
@@ -2093,7 +2229,13 @@ struct hwrm_func_backing_store_qcaps_output {
 	u8	stat_init_offset;
 	u8	mrav_init_offset;
 	u8	tqm_fp_rings_count_ext;
-	u8	rsvd[5];
+	u8	tkc_init_offset;
+	u8	rkc_init_offset;
+	__le16	tkc_entry_size;
+	__le16	rkc_entry_size;
+	__le32	tkc_max_entries;
+	__le32	rkc_max_entries;
+	u8	rsvd[7];
 	u8	valid;
 };
 
@@ -2120,7 +2262,7 @@ struct tqm_fp_ring_cfg {
 	__le64	tqm_ring_page_dir;
 };
 
-/* hwrm_func_backing_store_cfg_input (size:2432b/304B) */
+/* hwrm_func_backing_store_cfg_input (size:2688b/336B) */
 struct hwrm_func_backing_store_cfg_input {
 	__le16	req_type;
 	__le16	cmpl_ring;
@@ -2150,6 +2292,8 @@ struct hwrm_func_backing_store_cfg_input {
 	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_TQM_RING8      0x10000UL
 	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_TQM_RING9      0x20000UL
 	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_TQM_RING10     0x40000UL
+	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_TKC            0x80000UL
+	#define FUNC_BACKING_STORE_CFG_REQ_ENABLES_RKC            0x100000UL
 	u8	qpc_pg_size_qpc_lvl;
 	#define FUNC_BACKING_STORE_CFG_REQ_QPC_LVL_MASK      0xfUL
 	#define FUNC_BACKING_STORE_CFG_REQ_QPC_LVL_SFT       0
@@ -2508,6 +2652,45 @@ struct hwrm_func_backing_store_cfg_input {
 	u8	ring10_unused[3];
 	__le32	tqm_ring10_num_entries;
 	__le64	tqm_ring10_page_dir;
+	__le32	tkc_num_entries;
+	__le32	rkc_num_entries;
+	__le64	tkc_page_dir;
+	__le64	rkc_page_dir;
+	__le16	tkc_entry_size;
+	__le16	rkc_entry_size;
+	u8	tkc_pg_size_tkc_lvl;
+	#define FUNC_BACKING_STORE_CFG_REQ_TKC_LVL_MASK      0xfUL
+	#define FUNC_BACKING_STORE_CFG_REQ_TKC_LVL_SFT       0
+	#define FUNC_BACKING_STORE_CFG_REQ_TKC_LVL_LVL_0       0x0UL
+	#define FUNC_BACKING_STORE_CFG_REQ_TKC_LVL_LVL_1       0x1UL
+	#define FUNC_BACKING_STORE_CFG_REQ_TKC_LVL_LVL_2       0x2UL
+	#define FUNC_BACKING_STORE_CFG_REQ_TKC_LVL_LAST       FUNC_BACKING_STORE_CFG_REQ_TKC_LVL_LVL_2
+	#define FUNC_BACKING_STORE_CFG_REQ_TKC_PG_SIZE_MASK  0xf0UL
+	#define FUNC_BACKING_STORE_CFG_REQ_TKC_PG_SIZE_SFT   4
+	#define FUNC_BACKING_STORE_CFG_REQ_TKC_PG_SIZE_PG_4K   (0x0UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_TKC_PG_SIZE_PG_8K   (0x1UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_TKC_PG_SIZE_PG_64K  (0x2UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_TKC_PG_SIZE_PG_2M   (0x3UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_TKC_PG_SIZE_PG_8M   (0x4UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_TKC_PG_SIZE_PG_1G   (0x5UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_TKC_PG_SIZE_LAST   FUNC_BACKING_STORE_CFG_REQ_TKC_PG_SIZE_PG_1G
+	u8	rkc_pg_size_tkc_lvl;
+	#define FUNC_BACKING_STORE_CFG_REQ_RKC_LVL_MASK      0xfUL
+	#define FUNC_BACKING_STORE_CFG_REQ_RKC_LVL_SFT       0
+	#define FUNC_BACKING_STORE_CFG_REQ_RKC_LVL_LVL_0       0x0UL
+	#define FUNC_BACKING_STORE_CFG_REQ_RKC_LVL_LVL_1       0x1UL
+	#define FUNC_BACKING_STORE_CFG_REQ_RKC_LVL_LVL_2       0x2UL
+	#define FUNC_BACKING_STORE_CFG_REQ_RKC_LVL_LAST       FUNC_BACKING_STORE_CFG_REQ_RKC_LVL_LVL_2
+	#define FUNC_BACKING_STORE_CFG_REQ_RKC_PG_SIZE_MASK  0xf0UL
+	#define FUNC_BACKING_STORE_CFG_REQ_RKC_PG_SIZE_SFT   4
+	#define FUNC_BACKING_STORE_CFG_REQ_RKC_PG_SIZE_PG_4K   (0x0UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_RKC_PG_SIZE_PG_8K   (0x1UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_RKC_PG_SIZE_PG_64K  (0x2UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_RKC_PG_SIZE_PG_2M   (0x3UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_RKC_PG_SIZE_PG_8M   (0x4UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_RKC_PG_SIZE_PG_1G   (0x5UL << 4)
+	#define FUNC_BACKING_STORE_CFG_REQ_RKC_PG_SIZE_LAST   FUNC_BACKING_STORE_CFG_REQ_RKC_PG_SIZE_PG_1G
+	u8	rsvd[2];
 };
 
 /* hwrm_func_backing_store_cfg_output (size:128b/16B) */
@@ -2634,6 +2817,212 @@ struct hwrm_func_echo_response_output {
 	u8	valid;
 };
 
+/* hwrm_func_ptp_pin_qcfg_input (size:192b/24B) */
+struct hwrm_func_ptp_pin_qcfg_input {
+	__le16	req_type;
+	__le16	cmpl_ring;
+	__le16	seq_id;
+	__le16	target_id;
+	__le64	resp_addr;
+	u8	unused_0[8];
+};
+
+/* hwrm_func_ptp_pin_qcfg_output (size:128b/16B) */
+struct hwrm_func_ptp_pin_qcfg_output {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
+	u8	num_pins;
+	u8	state;
+	#define FUNC_PTP_PIN_QCFG_RESP_STATE_PIN0_ENABLED     0x1UL
+	#define FUNC_PTP_PIN_QCFG_RESP_STATE_PIN1_ENABLED     0x2UL
+	#define FUNC_PTP_PIN_QCFG_RESP_STATE_PIN2_ENABLED     0x4UL
+	#define FUNC_PTP_PIN_QCFG_RESP_STATE_PIN3_ENABLED     0x8UL
+	u8	pin0_usage;
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN0_USAGE_NONE     0x0UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN0_USAGE_PPS_IN   0x1UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN0_USAGE_PPS_OUT  0x2UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN0_USAGE_SYNC_IN  0x3UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN0_USAGE_SYNC_OUT 0x4UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN0_USAGE_LAST    FUNC_PTP_PIN_QCFG_RESP_PIN0_USAGE_SYNC_OUT
+	u8	pin1_usage;
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN1_USAGE_NONE     0x0UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN1_USAGE_PPS_IN   0x1UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN1_USAGE_PPS_OUT  0x2UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN1_USAGE_SYNC_IN  0x3UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN1_USAGE_SYNC_OUT 0x4UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN1_USAGE_LAST    FUNC_PTP_PIN_QCFG_RESP_PIN1_USAGE_SYNC_OUT
+	u8	pin2_usage;
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN2_USAGE_NONE     0x0UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN2_USAGE_PPS_IN   0x1UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN2_USAGE_PPS_OUT  0x2UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN2_USAGE_SYNC_IN  0x3UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN2_USAGE_SYNC_OUT 0x4UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN2_USAGE_LAST    FUNC_PTP_PIN_QCFG_RESP_PIN2_USAGE_SYNC_OUT
+	u8	pin3_usage;
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN3_USAGE_NONE     0x0UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN3_USAGE_PPS_IN   0x1UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN3_USAGE_PPS_OUT  0x2UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN3_USAGE_SYNC_IN  0x3UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN3_USAGE_SYNC_OUT 0x4UL
+	#define FUNC_PTP_PIN_QCFG_RESP_PIN3_USAGE_LAST    FUNC_PTP_PIN_QCFG_RESP_PIN3_USAGE_SYNC_OUT
+	u8	unused_0;
+	u8	valid;
+};
+
+/* hwrm_func_ptp_pin_cfg_input (size:256b/32B) */
+struct hwrm_func_ptp_pin_cfg_input {
+	__le16	req_type;
+	__le16	cmpl_ring;
+	__le16	seq_id;
+	__le16	target_id;
+	__le64	resp_addr;
+	__le32	enables;
+	#define FUNC_PTP_PIN_CFG_REQ_ENABLES_PIN0_STATE     0x1UL
+	#define FUNC_PTP_PIN_CFG_REQ_ENABLES_PIN0_USAGE     0x2UL
+	#define FUNC_PTP_PIN_CFG_REQ_ENABLES_PIN1_STATE     0x4UL
+	#define FUNC_PTP_PIN_CFG_REQ_ENABLES_PIN1_USAGE     0x8UL
+	#define FUNC_PTP_PIN_CFG_REQ_ENABLES_PIN2_STATE     0x10UL
+	#define FUNC_PTP_PIN_CFG_REQ_ENABLES_PIN2_USAGE     0x20UL
+	#define FUNC_PTP_PIN_CFG_REQ_ENABLES_PIN3_STATE     0x40UL
+	#define FUNC_PTP_PIN_CFG_REQ_ENABLES_PIN3_USAGE     0x80UL
+	u8	pin0_state;
+	#define FUNC_PTP_PIN_CFG_REQ_PIN0_STATE_DISABLED 0x0UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN0_STATE_ENABLED  0x1UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN0_STATE_LAST    FUNC_PTP_PIN_CFG_REQ_PIN0_STATE_ENABLED
+	u8	pin0_usage;
+	#define FUNC_PTP_PIN_CFG_REQ_PIN0_USAGE_NONE     0x0UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN0_USAGE_PPS_IN   0x1UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN0_USAGE_PPS_OUT  0x2UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN0_USAGE_SYNC_IN  0x3UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN0_USAGE_SYNC_OUT 0x4UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN0_USAGE_LAST    FUNC_PTP_PIN_CFG_REQ_PIN0_USAGE_SYNC_OUT
+	u8	pin1_state;
+	#define FUNC_PTP_PIN_CFG_REQ_PIN1_STATE_DISABLED 0x0UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN1_STATE_ENABLED  0x1UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN1_STATE_LAST    FUNC_PTP_PIN_CFG_REQ_PIN1_STATE_ENABLED
+	u8	pin1_usage;
+	#define FUNC_PTP_PIN_CFG_REQ_PIN1_USAGE_NONE     0x0UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN1_USAGE_PPS_IN   0x1UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN1_USAGE_PPS_OUT  0x2UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN1_USAGE_SYNC_IN  0x3UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN1_USAGE_SYNC_OUT 0x4UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN1_USAGE_LAST    FUNC_PTP_PIN_CFG_REQ_PIN1_USAGE_SYNC_OUT
+	u8	pin2_state;
+	#define FUNC_PTP_PIN_CFG_REQ_PIN2_STATE_DISABLED 0x0UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN2_STATE_ENABLED  0x1UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN2_STATE_LAST    FUNC_PTP_PIN_CFG_REQ_PIN2_STATE_ENABLED
+	u8	pin2_usage;
+	#define FUNC_PTP_PIN_CFG_REQ_PIN2_USAGE_NONE     0x0UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN2_USAGE_PPS_IN   0x1UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN2_USAGE_PPS_OUT  0x2UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN2_USAGE_SYNC_IN  0x3UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN2_USAGE_SYNC_OUT 0x4UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN2_USAGE_LAST    FUNC_PTP_PIN_CFG_REQ_PIN2_USAGE_SYNC_OUT
+	u8	pin3_state;
+	#define FUNC_PTP_PIN_CFG_REQ_PIN3_STATE_DISABLED 0x0UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN3_STATE_ENABLED  0x1UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN3_STATE_LAST    FUNC_PTP_PIN_CFG_REQ_PIN3_STATE_ENABLED
+	u8	pin3_usage;
+	#define FUNC_PTP_PIN_CFG_REQ_PIN3_USAGE_NONE     0x0UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN3_USAGE_PPS_IN   0x1UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN3_USAGE_PPS_OUT  0x2UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN3_USAGE_SYNC_IN  0x3UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN3_USAGE_SYNC_OUT 0x4UL
+	#define FUNC_PTP_PIN_CFG_REQ_PIN3_USAGE_LAST    FUNC_PTP_PIN_CFG_REQ_PIN3_USAGE_SYNC_OUT
+	u8	unused_0[4];
+};
+
+/* hwrm_func_ptp_pin_cfg_output (size:128b/16B) */
+struct hwrm_func_ptp_pin_cfg_output {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
+	u8	unused_0[7];
+	u8	valid;
+};
+
+/* hwrm_func_ptp_cfg_input (size:320b/40B) */
+struct hwrm_func_ptp_cfg_input {
+	__le16	req_type;
+	__le16	cmpl_ring;
+	__le16	seq_id;
+	__le16	target_id;
+	__le64	resp_addr;
+	__le16	enables;
+	#define FUNC_PTP_CFG_REQ_ENABLES_PTP_PPS_EVENT               0x1UL
+	#define FUNC_PTP_CFG_REQ_ENABLES_PTP_FREQ_ADJ_DLL_SOURCE     0x2UL
+	#define FUNC_PTP_CFG_REQ_ENABLES_PTP_FREQ_ADJ_DLL_PHASE      0x4UL
+	#define FUNC_PTP_CFG_REQ_ENABLES_PTP_FREQ_ADJ_EXT_PERIOD     0x8UL
+	#define FUNC_PTP_CFG_REQ_ENABLES_PTP_FREQ_ADJ_EXT_UP         0x10UL
+	#define FUNC_PTP_CFG_REQ_ENABLES_PTP_FREQ_ADJ_EXT_PHASE      0x20UL
+	u8	ptp_pps_event;
+	#define FUNC_PTP_CFG_REQ_PTP_PPS_EVENT_INTERNAL     0x1UL
+	#define FUNC_PTP_CFG_REQ_PTP_PPS_EVENT_EXTERNAL     0x2UL
+	u8	ptp_freq_adj_dll_source;
+	#define FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_SOURCE_NONE    0x0UL
+	#define FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_SOURCE_TSIO_0  0x1UL
+	#define FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_SOURCE_TSIO_1  0x2UL
+	#define FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_SOURCE_TSIO_2  0x3UL
+	#define FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_SOURCE_TSIO_3  0x4UL
+	#define FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_SOURCE_PORT_0  0x5UL
+	#define FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_SOURCE_PORT_1  0x6UL
+	#define FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_SOURCE_PORT_2  0x7UL
+	#define FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_SOURCE_PORT_3  0x8UL
+	#define FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_SOURCE_INVALID 0xffUL
+	#define FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_SOURCE_LAST   FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_SOURCE_INVALID
+	u8	ptp_freq_adj_dll_phase;
+	#define FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_PHASE_NONE 0x0UL
+	#define FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_PHASE_4K   0x1UL
+	#define FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_PHASE_8K   0x2UL
+	#define FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_PHASE_10M  0x3UL
+	#define FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_PHASE_LAST FUNC_PTP_CFG_REQ_PTP_FREQ_ADJ_DLL_PHASE_10M
+	u8	unused_0[3];
+	__le32	ptp_freq_adj_ext_period;
+	__le32	ptp_freq_adj_ext_up;
+	__le32	ptp_freq_adj_ext_phase_lower;
+	__le32	ptp_freq_adj_ext_phase_upper;
+};
+
+/* hwrm_func_ptp_cfg_output (size:128b/16B) */
+struct hwrm_func_ptp_cfg_output {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
+	u8	unused_0[7];
+	u8	valid;
+};
+
+/* hwrm_func_ptp_ts_query_input (size:192b/24B) */
+struct hwrm_func_ptp_ts_query_input {
+	__le16	req_type;
+	__le16	cmpl_ring;
+	__le16	seq_id;
+	__le16	target_id;
+	__le64	resp_addr;
+	__le32	flags;
+	#define FUNC_PTP_TS_QUERY_REQ_FLAGS_PPS_TIME     0x1UL
+	#define FUNC_PTP_TS_QUERY_REQ_FLAGS_PTM_TIME     0x2UL
+	u8	unused_0[4];
+};
+
+/* hwrm_func_ptp_ts_query_output (size:320b/40B) */
+struct hwrm_func_ptp_ts_query_output {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
+	__le64	pps_event_ts;
+	__le64	ptm_res_local_ts;
+	__le64	ptm_pmstr_ts;
+	__le32	ptm_mstr_prop_dly;
+	u8	unused_0[3];
+	u8	valid;
+};
+
 /* hwrm_func_drv_if_change_input (size:192b/24B) */
 struct hwrm_func_drv_if_change_input {
 	__le16	req_type;
@@ -3647,7 +4036,7 @@ struct hwrm_port_lpbk_clr_stats_output {
 	u8	valid;
 };
 
-/* hwrm_port_ts_query_input (size:192b/24B) */
+/* hwrm_port_ts_query_input (size:256b/32B) */
 struct hwrm_port_ts_query_input {
 	__le16	req_type;
 	__le16	cmpl_ring;
@@ -3662,6 +4051,11 @@ struct hwrm_port_ts_query_input {
 	#define PORT_TS_QUERY_REQ_FLAGS_CURRENT_TIME     0x2UL
 	__le16	port_id;
 	u8	unused_0[2];
+	__le16	enables;
+	#define PORT_TS_QUERY_REQ_ENABLES_TS_REQ_TIMEOUT     0x1UL
+	#define PORT_TS_QUERY_REQ_ENABLES_PTP_SEQ_ID         0x2UL
+	__le16	ts_req_timeout;
+	__le32	ptp_seq_id;
 };
 
 /* hwrm_port_ts_query_output (size:192b/24B) */
@@ -4215,7 +4609,8 @@ struct hwrm_queue_qportcfg_output {
 	u8	max_configurable_lossless_queues;
 	u8	queue_cfg_allowed;
 	u8	queue_cfg_info;
-	#define QUEUE_QPORTCFG_RESP_QUEUE_CFG_INFO_ASYM_CFG     0x1UL
+	#define QUEUE_QPORTCFG_RESP_QUEUE_CFG_INFO_ASYM_CFG             0x1UL
+	#define QUEUE_QPORTCFG_RESP_QUEUE_CFG_INFO_USE_PROFILE_TYPE     0x2UL
 	u8	queue_pfcenable_cfg_allowed;
 	u8	queue_pri2cos_cfg_allowed;
 	u8	queue_cos2bw_cfg_allowed;
@@ -7224,6 +7619,7 @@ struct hwrm_cfa_adv_flow_mgnt_qcaps_output {
 	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_NTUPLE_FLOW_RX_ETHERTYPE_IP_SUPPORTED        0x4000UL
 	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_TRUFLOW_CAPABLE                              0x8000UL
 	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_L2_FILTER_TRAFFIC_TYPE_L2_ROCE_SUPPORTED     0x10000UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_LAG_SUPPORTED                                0x20000UL
 	u8	unused_0[3];
 	u8	valid;
 };
@@ -7914,11 +8310,14 @@ struct hwrm_temp_monitor_query_output {
 	u8	phy_temp;
 	u8	om_temp;
 	u8	flags;
-	#define TEMP_MONITOR_QUERY_RESP_FLAGS_TEMP_NOT_AVAILABLE         0x1UL
-	#define TEMP_MONITOR_QUERY_RESP_FLAGS_PHY_TEMP_NOT_AVAILABLE     0x2UL
-	#define TEMP_MONITOR_QUERY_RESP_FLAGS_OM_NOT_PRESENT             0x4UL
-	#define TEMP_MONITOR_QUERY_RESP_FLAGS_OM_TEMP_NOT_AVAILABLE      0x8UL
-	u8	unused_0[3];
+	#define TEMP_MONITOR_QUERY_RESP_FLAGS_TEMP_NOT_AVAILABLE            0x1UL
+	#define TEMP_MONITOR_QUERY_RESP_FLAGS_PHY_TEMP_NOT_AVAILABLE        0x2UL
+	#define TEMP_MONITOR_QUERY_RESP_FLAGS_OM_NOT_PRESENT                0x4UL
+	#define TEMP_MONITOR_QUERY_RESP_FLAGS_OM_TEMP_NOT_AVAILABLE         0x8UL
+	#define TEMP_MONITOR_QUERY_RESP_FLAGS_EXT_TEMP_FIELDS_AVAILABLE     0x10UL
+	u8	temp2;
+	u8	phy_temp2;
+	u8	om_temp2;
 	u8	valid;
 };
 
@@ -8876,6 +9275,7 @@ struct fw_status_reg {
 	#define FW_STATUS_REG_CRASHDUMP_COMPLETE     0x80000UL
 	#define FW_STATUS_REG_SHUTDOWN               0x100000UL
 	#define FW_STATUS_REG_CRASHED_NO_MASTER      0x200000UL
+	#define FW_STATUS_REG_RECOVERING             0x400000UL
 };
 
 /* hcomm_status (size:64b/8B) */
-- 
2.18.1

