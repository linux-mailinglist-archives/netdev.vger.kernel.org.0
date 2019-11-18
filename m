Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB1C1000D0
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 09:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfKRI5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 03:57:01 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40991 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbfKRI47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 03:56:59 -0500
Received: by mail-pf1-f193.google.com with SMTP id p26so10051765pfq.8
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 00:56:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UvB3uAdKAL+5SIf4igPLqpyeKDPIPTenfvbofv3+v0A=;
        b=YmgSVjP2o0y7EQVM53/utMSFwBQxIQtRYY4EUP2V5HMc4GwsqZmMsdIRXHx4DhfPTN
         7zp3i9WClYUqVMnNhjEm4zi+ypKtV6IEwmbqAeAzZ8pF+8eJT4Ib1SQ1DaGe5O4V1/4b
         /Xy+TbR8s50vqUK7re4rDzXUnA1xOVasV5mzg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UvB3uAdKAL+5SIf4igPLqpyeKDPIPTenfvbofv3+v0A=;
        b=ApTUZzEXgfCqLOZSRsub1FgQXJgfFv8k28pIH48yz/ycbtG/KOjsV8s5RRTQcVdz53
         9ffdxu96q9nbdvbilWLcCeR8jRN83RDrC0V7BxTOE4wLbaUp6Em1obE5iCAZ+y+hZobB
         RFbY4DQcJKWOEf2ohBYneCloEvTuaPiHaqSXMfSn1udcYIqYJocGinKpryneJ3WLMahQ
         gDbXPg/8hzz9+KfbSyl3MYcGTIaRrNQqdBqaAjRaMtYl1lioK39fXkjoWWdyM1iQ/a4m
         YSZCeFY8era++rEzf2w6Yy79ftUhp9TeeQj2XPMT4fh8PXA2r6XRLkGenY1+r/0zNj2N
         vaQw==
X-Gm-Message-State: APjAAAX4AChcIDe1TVGXmm+L4i10DFBHzak4QEYaomIL5GblLp6/ge9z
        HGaoikrfBeZQRrY6TD8PbdZfRNMOy1U=
X-Google-Smtp-Source: APXvYqypzaTBSjmknE+ubBJwXKyHlU7A5E4MmcB2CCbeBJd9WTyUkTC+YrkybIaU+yv65xR9qvYzIg==
X-Received: by 2002:a62:8243:: with SMTP id w64mr8649222pfd.0.1574067418690;
        Mon, 18 Nov 2019 00:56:58 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q41sm19120230pja.20.2019.11.18.00.56.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Nov 2019 00:56:58 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 1/9] bnxt_en: Update firmware interface spec to 1.10.1.12.
Date:   Mon, 18 Nov 2019 03:56:35 -0500
Message-Id: <1574067403-4344-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574067403-4344-1-git-send-email-michael.chan@broadcom.com>
References: <1574067403-4344-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The aRFS ring table interface has changed for the 57500 chips.  Updating
it accordingly so it will work with the latest production firmware.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 20 +++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h | 95 ++++++++++++++++++---------
 3 files changed, 77 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index c071724..81bb6ce 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4601,21 +4601,21 @@ static int bnxt_hwrm_cfa_ntuple_filter_alloc(struct bnxt *bp,
 	struct hwrm_cfa_ntuple_filter_alloc_output *resp;
 	struct flow_keys *keys = &fltr->fkeys;
 	struct bnxt_vnic_info *vnic;
-	u32 dst_ena = 0;
+	u32 flags = 0;
 	int rc = 0;
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_CFA_NTUPLE_FILTER_ALLOC, -1, -1);
 	req.l2_filter_id = bp->vnic_info[0].fw_l2_filter_id[fltr->l2_fltr_idx];
 
-	if (bp->fw_cap & BNXT_FW_CAP_CFA_RFS_RING_TBL_IDX) {
-		dst_ena = CFA_NTUPLE_FILTER_ALLOC_REQ_ENABLES_RFS_RING_TBL_IDX;
-		req.rfs_ring_tbl_idx = cpu_to_le16(fltr->rxq);
-		vnic = &bp->vnic_info[0];
+	if (bp->fw_cap & BNXT_FW_CAP_CFA_RFS_RING_TBL_IDX_V2) {
+		flags = CFA_NTUPLE_FILTER_ALLOC_REQ_FLAGS_DEST_RFS_RING_IDX;
+		req.dst_id = cpu_to_le16(fltr->rxq);
 	} else {
 		vnic = &bp->vnic_info[fltr->rxq + 1];
+		req.dst_id = cpu_to_le16(vnic->fw_vnic_id);
 	}
-	req.dst_id = cpu_to_le16(vnic->fw_vnic_id);
-	req.enables = cpu_to_le32(BNXT_NTP_FLTR_FLAGS | dst_ena);
+	req.flags = cpu_to_le32(flags);
+	req.enables = cpu_to_le32(BNXT_NTP_FLTR_FLAGS);
 
 	req.ethertype = htons(ETH_P_IP);
 	memcpy(req.src_macaddr, fltr->src_mac_addr, ETH_ALEN);
@@ -7042,8 +7042,8 @@ static int bnxt_hwrm_cfa_adv_flow_mgnt_qcaps(struct bnxt *bp)
 
 	flags = le32_to_cpu(resp->flags);
 	if (flags &
-	    CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_RFS_RING_TBL_IDX_SUPPORTED)
-		bp->fw_cap |= BNXT_FW_CAP_CFA_RFS_RING_TBL_IDX;
+	    CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_RFS_RING_TBL_IDX_V2_SUPPORTED)
+		bp->fw_cap |= BNXT_FW_CAP_CFA_RFS_RING_TBL_IDX_V2;
 
 hwrm_cfa_adv_qcaps_exit:
 	mutex_unlock(&bp->hwrm_cmd_lock);
@@ -9693,7 +9693,7 @@ static bool bnxt_can_reserve_rings(struct bnxt *bp)
 static bool bnxt_rfs_supported(struct bnxt *bp)
 {
 	if (bp->flags & BNXT_FLAG_CHIP_P5) {
-		if (bp->fw_cap & BNXT_FW_CAP_CFA_RFS_RING_TBL_IDX)
+		if (bp->fw_cap & BNXT_FW_CAP_CFA_RFS_RING_TBL_IDX_V2)
 			return true;
 		return false;
 	}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index a3545c8..c260cbb 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -12,11 +12,11 @@
 #define BNXT_H
 
 #define DRV_MODULE_NAME		"bnxt_en"
-#define DRV_MODULE_VERSION	"1.10.0"
+#define DRV_MODULE_VERSION	"1.10.1"
 
 #define DRV_VER_MAJ	1
 #define DRV_VER_MIN	10
-#define DRV_VER_UPD	0
+#define DRV_VER_UPD	1
 
 #include <linux/interrupt.h>
 #include <linux/rhashtable.h>
@@ -1666,7 +1666,7 @@ struct bnxt {
 	#define BNXT_FW_CAP_ERROR_RECOVERY		0x00002000
 	#define BNXT_FW_CAP_PKG_VER			0x00004000
 	#define BNXT_FW_CAP_CFA_ADV_FLOW		0x00008000
-	#define BNXT_FW_CAP_CFA_RFS_RING_TBL_IDX	0x00010000
+	#define BNXT_FW_CAP_CFA_RFS_RING_TBL_IDX_V2	0x00010000
 	#define BNXT_FW_CAP_PCIE_STATS_SUPPORTED	0x00020000
 	#define BNXT_FW_CAP_EXT_STATS_SUPPORTED		0x00040000
 	#define BNXT_FW_CAP_ERR_RECOVER_RELOAD		0x00100000
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
index 03b197e..7cf27df 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
@@ -176,6 +176,9 @@ struct cmd_nums {
 	#define HWRM_RESERVED6                            0x65UL
 	#define HWRM_VNIC_RSS_COS_LB_CTX_ALLOC            0x70UL
 	#define HWRM_VNIC_RSS_COS_LB_CTX_FREE             0x71UL
+	#define HWRM_QUEUE_MPLS_QCAPS                     0x80UL
+	#define HWRM_QUEUE_MPLSTC2PRI_QCFG                0x81UL
+	#define HWRM_QUEUE_MPLSTC2PRI_CFG                 0x82UL
 	#define HWRM_CFA_L2_FILTER_ALLOC                  0x90UL
 	#define HWRM_CFA_L2_FILTER_FREE                   0x91UL
 	#define HWRM_CFA_L2_FILTER_CFG                    0x92UL
@@ -208,7 +211,7 @@ struct cmd_nums {
 	#define HWRM_FW_QSTATUS                           0xc1UL
 	#define HWRM_FW_HEALTH_CHECK                      0xc2UL
 	#define HWRM_FW_SYNC                              0xc3UL
-	#define HWRM_FW_STATE_BUFFER_QCAPS                0xc4UL
+	#define HWRM_FW_STATE_QCAPS                       0xc4UL
 	#define HWRM_FW_STATE_QUIESCE                     0xc5UL
 	#define HWRM_FW_STATE_BACKUP                      0xc6UL
 	#define HWRM_FW_STATE_RESTORE                     0xc7UL
@@ -225,8 +228,11 @@ struct cmd_nums {
 	#define HWRM_PORT_PRBS_TEST                       0xd5UL
 	#define HWRM_PORT_SFP_SIDEBAND_CFG                0xd6UL
 	#define HWRM_PORT_SFP_SIDEBAND_QCFG               0xd7UL
+	#define HWRM_FW_STATE_UNQUIESCE                   0xd8UL
+	#define HWRM_PORT_DSC_DUMP                        0xd9UL
 	#define HWRM_TEMP_MONITOR_QUERY                   0xe0UL
 	#define HWRM_REG_POWER_QUERY                      0xe1UL
+	#define HWRM_CORE_FREQUENCY_QUERY                 0xe2UL
 	#define HWRM_WOL_FILTER_ALLOC                     0xf0UL
 	#define HWRM_WOL_FILTER_FREE                      0xf1UL
 	#define HWRM_WOL_FILTER_QCFG                      0xf2UL
@@ -308,6 +314,7 @@ struct cmd_nums {
 	#define HWRM_ENGINE_STATS_CONFIG                  0x155UL
 	#define HWRM_ENGINE_STATS_CLEAR                   0x156UL
 	#define HWRM_ENGINE_STATS_QUERY                   0x157UL
+	#define HWRM_ENGINE_STATS_QUERY_CONTINUOUS_ERROR  0x158UL
 	#define HWRM_ENGINE_RQ_ALLOC                      0x15eUL
 	#define HWRM_ENGINE_RQ_FREE                       0x15fUL
 	#define HWRM_ENGINE_CQ_ALLOC                      0x160UL
@@ -390,6 +397,7 @@ struct ret_codes {
 	#define HWRM_ERR_CODE_KEY_HASH_COLLISION           0xdUL
 	#define HWRM_ERR_CODE_KEY_ALREADY_EXISTS           0xeUL
 	#define HWRM_ERR_CODE_HWRM_ERROR                   0xfUL
+	#define HWRM_ERR_CODE_BUSY                         0x10UL
 	#define HWRM_ERR_CODE_TLV_ENCAPSULATED_RESPONSE    0x8000UL
 	#define HWRM_ERR_CODE_UNKNOWN_ERR                  0xfffeUL
 	#define HWRM_ERR_CODE_CMD_NOT_SUPPORTED            0xffffUL
@@ -420,9 +428,9 @@ struct hwrm_err_output {
 #define HWRM_TARGET_ID_TOOLS 0xFFFD
 #define HWRM_VERSION_MAJOR 1
 #define HWRM_VERSION_MINOR 10
-#define HWRM_VERSION_UPDATE 0
-#define HWRM_VERSION_RSVD 100
-#define HWRM_VERSION_STR "1.10.0.100"
+#define HWRM_VERSION_UPDATE 1
+#define HWRM_VERSION_RSVD 12
+#define HWRM_VERSION_STR "1.10.1.12"
 
 /* hwrm_ver_get_input (size:192b/24B) */
 struct hwrm_ver_get_input {
@@ -637,6 +645,8 @@ struct hwrm_async_event_cmpl {
 	#define ASYNC_EVENT_CMPL_EVENT_ID_EEM_CFG_CHANGE             0x3cUL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_TFLIB_DEFAULT_VNIC_CHANGE  0x3dUL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_TFLIB_LINK_STATUS_CHANGE   0x3eUL
+	#define ASYNC_EVENT_CMPL_EVENT_ID_QUIESCE_DONE               0x3fUL
+	#define ASYNC_EVENT_CMPL_EVENT_ID_DEFERRED_RESPONSE          0x40UL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_FW_TRACE_MSG               0xfeUL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_HWRM_ERROR                 0xffUL
 	#define ASYNC_EVENT_CMPL_EVENT_ID_LAST                      ASYNC_EVENT_CMPL_EVENT_ID_HWRM_ERROR
@@ -1115,6 +1125,7 @@ struct hwrm_func_qcaps_output {
 	#define FUNC_QCAPS_RESP_FLAGS_EXT_STATS_SUPPORTED                   0x1000000UL
 	#define FUNC_QCAPS_RESP_FLAGS_ERR_RECOVER_RELOAD                    0x2000000UL
 	#define FUNC_QCAPS_RESP_FLAGS_NOTIFY_VF_DEF_VNIC_CHNG_SUPPORTED     0x4000000UL
+	#define FUNC_QCAPS_RESP_FLAGS_VLAN_ACCELERATION_TX_DISABLED         0x8000000UL
 	u8	mac_address[6];
 	__le16	max_rsscos_ctx;
 	__le16	max_cmpl_rings;
@@ -1255,7 +1266,8 @@ struct hwrm_func_qcfg_output {
 	u8	unused_1;
 	u8	always_1;
 	__le32	reset_addr_poll;
-	u8	unused_2[3];
+	__le16	legacy_l2_db_size_kb;
+	u8	unused_2[1];
 	u8	valid;
 };
 
@@ -1500,6 +1512,7 @@ struct hwrm_func_drv_rgtr_input {
 	#define FUNC_DRV_RGTR_REQ_FLAGS_FLOW_HANDLE_64BIT_MODE     0x8UL
 	#define FUNC_DRV_RGTR_REQ_FLAGS_HOT_RESET_SUPPORT          0x10UL
 	#define FUNC_DRV_RGTR_REQ_FLAGS_ERROR_RECOVERY_SUPPORT     0x20UL
+	#define FUNC_DRV_RGTR_REQ_FLAGS_MASTER_SUPPORT             0x40UL
 	__le32	enables;
 	#define FUNC_DRV_RGTR_REQ_ENABLES_OS_TYPE             0x1UL
 	#define FUNC_DRV_RGTR_REQ_ENABLES_VER                 0x2UL
@@ -1762,7 +1775,7 @@ struct hwrm_func_backing_store_qcaps_input {
 	__le64	resp_addr;
 };
 
-/* hwrm_func_backing_store_qcaps_output (size:576b/72B) */
+/* hwrm_func_backing_store_qcaps_output (size:640b/80B) */
 struct hwrm_func_backing_store_qcaps_output {
 	__le16	error_code;
 	__le16	req_type;
@@ -1792,6 +1805,10 @@ struct hwrm_func_backing_store_qcaps_output {
 	__le32	tim_max_entries;
 	__le16	mrav_num_entries_units;
 	u8	tqm_entries_multiple;
+	u8	ctx_kind_initializer;
+	__le32	rsvd;
+	__le16	rsvd1;
+	u8	rsvd2;
 	u8	valid;
 };
 
@@ -2524,6 +2541,7 @@ struct hwrm_port_phy_qcfg_output {
 	#define PORT_PHY_QCFG_RESP_MODULE_STATUS_WARNINGMSG    0x2UL
 	#define PORT_PHY_QCFG_RESP_MODULE_STATUS_PWRDOWN       0x3UL
 	#define PORT_PHY_QCFG_RESP_MODULE_STATUS_NOTINSERTED   0x4UL
+	#define PORT_PHY_QCFG_RESP_MODULE_STATUS_CURRENTFAULT  0x5UL
 	#define PORT_PHY_QCFG_RESP_MODULE_STATUS_NOTAPPLICABLE 0xffUL
 	#define PORT_PHY_QCFG_RESP_MODULE_STATUS_LAST         PORT_PHY_QCFG_RESP_MODULE_STATUS_NOTAPPLICABLE
 	__le32	preemphasis;
@@ -2761,8 +2779,8 @@ struct hwrm_port_mac_ptp_qcfg_output {
 	__le16	resp_len;
 	u8	flags;
 	#define PORT_MAC_PTP_QCFG_RESP_FLAGS_DIRECT_ACCESS      0x1UL
-	#define PORT_MAC_PTP_QCFG_RESP_FLAGS_HWRM_ACCESS        0x2UL
 	#define PORT_MAC_PTP_QCFG_RESP_FLAGS_ONE_STEP_TX_TS     0x4UL
+	#define PORT_MAC_PTP_QCFG_RESP_FLAGS_HWRM_ACCESS        0x8UL
 	u8	unused_0[3];
 	__le32	rx_ts_reg_off_lower;
 	__le32	rx_ts_reg_off_upper;
@@ -3177,10 +3195,12 @@ struct hwrm_port_phy_qcaps_output {
 	__le16	seq_id;
 	__le16	resp_len;
 	u8	flags;
-	#define PORT_PHY_QCAPS_RESP_FLAGS_EEE_SUPPORTED               0x1UL
-	#define PORT_PHY_QCAPS_RESP_FLAGS_EXTERNAL_LPBK_SUPPORTED     0x2UL
-	#define PORT_PHY_QCAPS_RESP_FLAGS_RSVD1_MASK                  0xfcUL
-	#define PORT_PHY_QCAPS_RESP_FLAGS_RSVD1_SFT                   2
+	#define PORT_PHY_QCAPS_RESP_FLAGS_EEE_SUPPORTED                0x1UL
+	#define PORT_PHY_QCAPS_RESP_FLAGS_EXTERNAL_LPBK_SUPPORTED      0x2UL
+	#define PORT_PHY_QCAPS_RESP_FLAGS_AUTONEG_LPBK_SUPPORTED       0x4UL
+	#define PORT_PHY_QCAPS_RESP_FLAGS_SHARED_PHY_CFG_SUPPORTED     0x8UL
+	#define PORT_PHY_QCAPS_RESP_FLAGS_RSVD1_MASK                   0xf0UL
+	#define PORT_PHY_QCAPS_RESP_FLAGS_RSVD1_SFT                    4
 	u8	port_cnt;
 	#define PORT_PHY_QCAPS_RESP_PORT_CNT_UNKNOWN 0x0UL
 	#define PORT_PHY_QCAPS_RESP_PORT_CNT_1       0x1UL
@@ -4980,6 +5000,15 @@ struct hwrm_vnic_rss_cfg_output {
 	u8	valid;
 };
 
+/* hwrm_vnic_rss_cfg_cmd_err (size:64b/8B) */
+struct hwrm_vnic_rss_cfg_cmd_err {
+	u8	code;
+	#define VNIC_RSS_CFG_CMD_ERR_CODE_UNKNOWN             0x0UL
+	#define VNIC_RSS_CFG_CMD_ERR_CODE_INTERFACE_NOT_READY 0x1UL
+	#define VNIC_RSS_CFG_CMD_ERR_CODE_LAST               VNIC_RSS_CFG_CMD_ERR_CODE_INTERFACE_NOT_READY
+	u8	unused_0[7];
+};
+
 /* hwrm_vnic_plcmodes_cfg_input (size:320b/40B) */
 struct hwrm_vnic_plcmodes_cfg_input {
 	__le16	req_type;
@@ -5807,7 +5836,7 @@ struct hwrm_cfa_encap_record_free_output {
 	u8	valid;
 };
 
-/* hwrm_cfa_ntuple_filter_alloc_input (size:1088b/136B) */
+/* hwrm_cfa_ntuple_filter_alloc_input (size:1024b/128B) */
 struct hwrm_cfa_ntuple_filter_alloc_input {
 	__le16	req_type;
 	__le16	cmpl_ring;
@@ -5815,10 +5844,12 @@ struct hwrm_cfa_ntuple_filter_alloc_input {
 	__le16	target_id;
 	__le64	resp_addr;
 	__le32	flags;
-	#define CFA_NTUPLE_FILTER_ALLOC_REQ_FLAGS_LOOPBACK     0x1UL
-	#define CFA_NTUPLE_FILTER_ALLOC_REQ_FLAGS_DROP         0x2UL
-	#define CFA_NTUPLE_FILTER_ALLOC_REQ_FLAGS_METER        0x4UL
-	#define CFA_NTUPLE_FILTER_ALLOC_REQ_FLAGS_DEST_FID     0x8UL
+	#define CFA_NTUPLE_FILTER_ALLOC_REQ_FLAGS_LOOPBACK              0x1UL
+	#define CFA_NTUPLE_FILTER_ALLOC_REQ_FLAGS_DROP                  0x2UL
+	#define CFA_NTUPLE_FILTER_ALLOC_REQ_FLAGS_METER                 0x4UL
+	#define CFA_NTUPLE_FILTER_ALLOC_REQ_FLAGS_DEST_FID              0x8UL
+	#define CFA_NTUPLE_FILTER_ALLOC_REQ_FLAGS_ARP_REPLY             0x10UL
+	#define CFA_NTUPLE_FILTER_ALLOC_REQ_FLAGS_DEST_RFS_RING_IDX     0x20UL
 	__le32	enables;
 	#define CFA_NTUPLE_FILTER_ALLOC_REQ_ENABLES_L2_FILTER_ID         0x1UL
 	#define CFA_NTUPLE_FILTER_ALLOC_REQ_ENABLES_ETHERTYPE            0x2UL
@@ -5887,8 +5918,6 @@ struct hwrm_cfa_ntuple_filter_alloc_input {
 	__be16	dst_port;
 	__be16	dst_port_mask;
 	__le64	ntuple_filter_id_hint;
-	__le16	rfs_ring_tbl_idx;
-	u8	unused_0[6];
 };
 
 /* hwrm_cfa_ntuple_filter_alloc_output (size:192b/24B) */
@@ -5954,7 +5983,8 @@ struct hwrm_cfa_ntuple_filter_cfg_input {
 	#define CFA_NTUPLE_FILTER_CFG_REQ_ENABLES_NEW_MIRROR_VNIC_ID        0x2UL
 	#define CFA_NTUPLE_FILTER_CFG_REQ_ENABLES_NEW_METER_INSTANCE_ID     0x4UL
 	__le32	flags;
-	#define CFA_NTUPLE_FILTER_CFG_REQ_FLAGS_DEST_FID     0x1UL
+	#define CFA_NTUPLE_FILTER_CFG_REQ_FLAGS_DEST_FID              0x1UL
+	#define CFA_NTUPLE_FILTER_CFG_REQ_FLAGS_DEST_RFS_RING_IDX     0x2UL
 	__le64	ntuple_filter_id;
 	__le32	new_dst_id;
 	__le32	new_mirror_vnic_id;
@@ -6534,18 +6564,21 @@ struct hwrm_cfa_adv_flow_mgnt_qcaps_output {
 	__le16	seq_id;
 	__le16	resp_len;
 	__le32	flags;
-	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_FLOW_HND_16BIT_SUPPORTED              0x1UL
-	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_FLOW_HND_64BIT_SUPPORTED              0x2UL
-	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_FLOW_BATCH_DELETE_SUPPORTED           0x4UL
-	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_FLOW_RESET_ALL_SUPPORTED              0x8UL
-	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_NTUPLE_FLOW_DEST_FUNC_SUPPORTED       0x10UL
-	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_TX_EEM_FLOW_SUPPORTED                 0x20UL
-	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_RX_EEM_FLOW_SUPPORTED                 0x40UL
-	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_FLOW_COUNTER_ALLOC_SUPPORTED          0x80UL
-	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_RFS_RING_TBL_IDX_SUPPORTED            0x100UL
-	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_UNTAGGED_VLAN_SUPPORTED               0x200UL
-	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_XDP_SUPPORTED                         0x400UL
-	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_L2_HEADER_SOURCE_FIELDS_SUPPORTED     0x800UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_FLOW_HND_16BIT_SUPPORTED                  0x1UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_FLOW_HND_64BIT_SUPPORTED                  0x2UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_FLOW_BATCH_DELETE_SUPPORTED               0x4UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_FLOW_RESET_ALL_SUPPORTED                  0x8UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_NTUPLE_FLOW_DEST_FUNC_SUPPORTED           0x10UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_TX_EEM_FLOW_SUPPORTED                     0x20UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_RX_EEM_FLOW_SUPPORTED                     0x40UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_FLOW_COUNTER_ALLOC_SUPPORTED              0x80UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_RFS_RING_TBL_IDX_SUPPORTED                0x100UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_UNTAGGED_VLAN_SUPPORTED                   0x200UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_XDP_SUPPORTED                             0x400UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_L2_HEADER_SOURCE_FIELDS_SUPPORTED         0x800UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_NTUPLE_FLOW_RX_ARP_SUPPORTED              0x1000UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_RFS_RING_TBL_IDX_V2_SUPPORTED             0x2000UL
+	#define CFA_ADV_FLOW_MGNT_QCAPS_RESP_FLAGS_NTUPLE_FLOW_RX_ETHERTYPE_IP_SUPPORTED     0x4000UL
 	u8	unused_0[3];
 	u8	valid;
 };
-- 
2.5.1

