Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5203FB298B
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 06:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbfINECH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 00:02:07 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38853 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbfINECG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 00:02:06 -0400
Received: by mail-pg1-f195.google.com with SMTP id d10so16301267pgo.5
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 21:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ikw0U1xaZy6UMfTEzu8ThrctvxtzI4I6qI9WP3R4ewc=;
        b=H3dPXZ/wR/9VeAsokxtFefv9nb3Rv2NVUbVDsBp8GRxE0tc+/gR+8cfNkypWttBxz6
         6TPxgdT3qSAYa1R3r9iXtGUoEWcdNASJwNp35CAsaJVdOlMeGSJnXHXiDw3KFZrIWSRL
         /lDCOYHuMVZlNVFEj0+1cxjw9VARizb7L58s0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ikw0U1xaZy6UMfTEzu8ThrctvxtzI4I6qI9WP3R4ewc=;
        b=dAnKTw1m7VFvUg+/csP12kyPbAiRV7g2ImY/iGCR/86xPIMtqQAbRPsqSc/6vlF9XL
         8MxrIkc/BimXzFgQvJOrwQkwvf/tdeVpMOR/9+VqjyMR3lfIhH4gLY2SE7BTAaRk4jZi
         bz/tn9fvcSfNKSqbGNnoXi3idH4x+cdJD2/O5TpOX09hS5pyDx0xgR7IFaiGFzVzcad3
         iYnNk9nDCbm59+qakoZjla1swKXhgw8qhE09NX377oiKi19PoT9GTc9othjO3cLkU9kj
         OqYlPgNg48FkvldIFNMBxojXrUrEW9ThweG0roWG6cvGmWlWl83Od4KzUrIVLz8WLtn4
         mZ2Q==
X-Gm-Message-State: APjAAAUgha97DGqShI7nGoecD5i0WLUK0XOgzDyTRwR2FSdN0e7uAUHk
        APMoOHxnTO5PWCkTgvvHNWnp4RvLhqo=
X-Google-Smtp-Source: APXvYqwKRX+5D4gBI78rHYjqCawTWu1cuw+3q5fZcjO6xeNxVBGYvgNbD8XgzmVILIez9f+UHsnbzg==
X-Received: by 2002:a63:c006:: with SMTP id h6mr45629853pgg.290.1568433723928;
        Fri, 13 Sep 2019 21:02:03 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a29sm52363908pfr.152.2019.09.13.21.02.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 21:02:03 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com
Subject: [PATCH net-next 3/4] bnxt_en: Update firmware interface spec. to 1.10.0.100.
Date:   Sat, 14 Sep 2019 00:01:40 -0400
Message-Id: <1568433701-29000-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568433701-29000-1-git-send-email-michael.chan@broadcom.com>
References: <1568433701-29000-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some error recovery updates to the spec., among other minor changes.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h | 146 ++++++++++++++++++--------
 1 file changed, 103 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
index 2cdef75..03b197e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
@@ -44,11 +44,12 @@ struct hwrm_resp_hdr {
 #define TLV_TYPE_ENGINE_CKV_IV                   0x8003UL
 #define TLV_TYPE_ENGINE_CKV_AUTH_TAG             0x8004UL
 #define TLV_TYPE_ENGINE_CKV_CIPHERTEXT           0x8005UL
-#define TLV_TYPE_ENGINE_CKV_ALGORITHMS           0x8006UL
+#define TLV_TYPE_ENGINE_CKV_HOST_ALGORITHMS      0x8006UL
 #define TLV_TYPE_ENGINE_CKV_HOST_ECC_PUBLIC_KEY  0x8007UL
 #define TLV_TYPE_ENGINE_CKV_ECDSA_SIGNATURE      0x8008UL
-#define TLV_TYPE_ENGINE_CKV_SRT_ECC_PUBLIC_KEY   0x8009UL
-#define TLV_TYPE_LAST                           TLV_TYPE_ENGINE_CKV_SRT_ECC_PUBLIC_KEY
+#define TLV_TYPE_ENGINE_CKV_FW_ECC_PUBLIC_KEY    0x8009UL
+#define TLV_TYPE_ENGINE_CKV_FW_ALGORITHMS        0x800aUL
+#define TLV_TYPE_LAST                           TLV_TYPE_ENGINE_CKV_FW_ALGORITHMS
 
 
 /* tlv (size:64b/8B) */
@@ -201,10 +202,16 @@ struct cmd_nums {
 	#define HWRM_PORT_QSTATS_EXT                      0xb4UL
 	#define HWRM_PORT_PHY_MDIO_WRITE                  0xb5UL
 	#define HWRM_PORT_PHY_MDIO_READ                   0xb6UL
+	#define HWRM_PORT_PHY_MDIO_BUS_ACQUIRE            0xb7UL
+	#define HWRM_PORT_PHY_MDIO_BUS_RELEASE            0xb8UL
 	#define HWRM_FW_RESET                             0xc0UL
 	#define HWRM_FW_QSTATUS                           0xc1UL
 	#define HWRM_FW_HEALTH_CHECK                      0xc2UL
 	#define HWRM_FW_SYNC                              0xc3UL
+	#define HWRM_FW_STATE_BUFFER_QCAPS                0xc4UL
+	#define HWRM_FW_STATE_QUIESCE                     0xc5UL
+	#define HWRM_FW_STATE_BACKUP                      0xc6UL
+	#define HWRM_FW_STATE_RESTORE                     0xc7UL
 	#define HWRM_FW_SET_TIME                          0xc8UL
 	#define HWRM_FW_GET_TIME                          0xc9UL
 	#define HWRM_FW_SET_STRUCTURED_DATA               0xcaUL
@@ -216,7 +223,10 @@ struct cmd_nums {
 	#define HWRM_FWD_ASYNC_EVENT_CMPL                 0xd3UL
 	#define HWRM_OEM_CMD                              0xd4UL
 	#define HWRM_PORT_PRBS_TEST                       0xd5UL
+	#define HWRM_PORT_SFP_SIDEBAND_CFG                0xd6UL
+	#define HWRM_PORT_SFP_SIDEBAND_QCFG               0xd7UL
 	#define HWRM_TEMP_MONITOR_QUERY                   0xe0UL
+	#define HWRM_REG_POWER_QUERY                      0xe1UL
 	#define HWRM_WOL_FILTER_ALLOC                     0xf0UL
 	#define HWRM_WOL_FILTER_FREE                      0xf1UL
 	#define HWRM_WOL_FILTER_QCFG                      0xf2UL
@@ -411,8 +421,8 @@ struct hwrm_err_output {
 #define HWRM_VERSION_MAJOR 1
 #define HWRM_VERSION_MINOR 10
 #define HWRM_VERSION_UPDATE 0
-#define HWRM_VERSION_RSVD 89
-#define HWRM_VERSION_STR "1.10.0.89"
+#define HWRM_VERSION_RSVD 100
+#define HWRM_VERSION_STR "1.10.0.100"
 
 /* hwrm_ver_get_input (size:192b/24B) */
 struct hwrm_ver_get_input {
@@ -805,6 +815,37 @@ struct hwrm_async_event_cmpl_vf_cfg_change {
 	#define ASYNC_EVENT_CMPL_VF_CFG_CHANGE_EVENT_DATA1_TRUSTED_VF_CFG_CHANGE     0x10UL
 };
 
+/* hwrm_async_event_cmpl_default_vnic_change (size:128b/16B) */
+struct hwrm_async_event_cmpl_default_vnic_change {
+	__le16	type;
+	#define ASYNC_EVENT_CMPL_DEFAULT_VNIC_CHANGE_TYPE_MASK            0x3fUL
+	#define ASYNC_EVENT_CMPL_DEFAULT_VNIC_CHANGE_TYPE_SFT             0
+	#define ASYNC_EVENT_CMPL_DEFAULT_VNIC_CHANGE_TYPE_HWRM_ASYNC_EVENT  0x2eUL
+	#define ASYNC_EVENT_CMPL_DEFAULT_VNIC_CHANGE_TYPE_LAST             ASYNC_EVENT_CMPL_DEFAULT_VNIC_CHANGE_TYPE_HWRM_ASYNC_EVENT
+	#define ASYNC_EVENT_CMPL_DEFAULT_VNIC_CHANGE_UNUSED1_MASK         0xffc0UL
+	#define ASYNC_EVENT_CMPL_DEFAULT_VNIC_CHANGE_UNUSED1_SFT          6
+	__le16	event_id;
+	#define ASYNC_EVENT_CMPL_DEFAULT_VNIC_CHANGE_EVENT_ID_ALLOC_FREE_NOTIFICATION 0x35UL
+	#define ASYNC_EVENT_CMPL_DEFAULT_VNIC_CHANGE_EVENT_ID_LAST                   ASYNC_EVENT_CMPL_DEFAULT_VNIC_CHANGE_EVENT_ID_ALLOC_FREE_NOTIFICATION
+	__le32	event_data2;
+	u8	opaque_v;
+	#define ASYNC_EVENT_CMPL_DEFAULT_VNIC_CHANGE_V          0x1UL
+	#define ASYNC_EVENT_CMPL_DEFAULT_VNIC_CHANGE_OPAQUE_MASK 0xfeUL
+	#define ASYNC_EVENT_CMPL_DEFAULT_VNIC_CHANGE_OPAQUE_SFT 1
+	u8	timestamp_lo;
+	__le16	timestamp_hi;
+	__le32	event_data1;
+	#define ASYNC_EVENT_CMPL_DEFAULT_VNIC_CHANGE_EVENT_DATA1_DEF_VNIC_STATE_MASK          0x3UL
+	#define ASYNC_EVENT_CMPL_DEFAULT_VNIC_CHANGE_EVENT_DATA1_DEF_VNIC_STATE_SFT           0
+	#define ASYNC_EVENT_CMPL_DEFAULT_VNIC_CHANGE_EVENT_DATA1_DEF_VNIC_STATE_DEF_VNIC_ALLOC  0x1UL
+	#define ASYNC_EVENT_CMPL_DEFAULT_VNIC_CHANGE_EVENT_DATA1_DEF_VNIC_STATE_DEF_VNIC_FREE   0x2UL
+	#define ASYNC_EVENT_CMPL_DEFAULT_VNIC_CHANGE_EVENT_DATA1_DEF_VNIC_STATE_LAST           ASYNC_EVENT_CMPL_DEFAULT_VNIC_CHANGE_EVENT_DATA1_DEF_VNIC_STATE_DEF_VNIC_FREE
+	#define ASYNC_EVENT_CMPL_DEFAULT_VNIC_CHANGE_EVENT_DATA1_PF_ID_MASK                   0x3fcUL
+	#define ASYNC_EVENT_CMPL_DEFAULT_VNIC_CHANGE_EVENT_DATA1_PF_ID_SFT                    2
+	#define ASYNC_EVENT_CMPL_DEFAULT_VNIC_CHANGE_EVENT_DATA1_VF_ID_MASK                   0x3fffc00UL
+	#define ASYNC_EVENT_CMPL_DEFAULT_VNIC_CHANGE_EVENT_DATA1_VF_ID_SFT                    10
+};
+
 /* hwrm_async_event_cmpl_hw_flow_aged (size:128b/16B) */
 struct hwrm_async_event_cmpl_hw_flow_aged {
 	__le16	type;
@@ -1047,31 +1088,33 @@ struct hwrm_func_qcaps_output {
 	__le16	fid;
 	__le16	port_id;
 	__le32	flags;
-	#define FUNC_QCAPS_RESP_FLAGS_PUSH_MODE_SUPPORTED             0x1UL
-	#define FUNC_QCAPS_RESP_FLAGS_GLOBAL_MSIX_AUTOMASKING         0x2UL
-	#define FUNC_QCAPS_RESP_FLAGS_PTP_SUPPORTED                   0x4UL
-	#define FUNC_QCAPS_RESP_FLAGS_ROCE_V1_SUPPORTED               0x8UL
-	#define FUNC_QCAPS_RESP_FLAGS_ROCE_V2_SUPPORTED               0x10UL
-	#define FUNC_QCAPS_RESP_FLAGS_WOL_MAGICPKT_SUPPORTED          0x20UL
-	#define FUNC_QCAPS_RESP_FLAGS_WOL_BMP_SUPPORTED               0x40UL
-	#define FUNC_QCAPS_RESP_FLAGS_TX_RING_RL_SUPPORTED            0x80UL
-	#define FUNC_QCAPS_RESP_FLAGS_TX_BW_CFG_SUPPORTED             0x100UL
-	#define FUNC_QCAPS_RESP_FLAGS_VF_TX_RING_RL_SUPPORTED         0x200UL
-	#define FUNC_QCAPS_RESP_FLAGS_VF_BW_CFG_SUPPORTED             0x400UL
-	#define FUNC_QCAPS_RESP_FLAGS_STD_TX_RING_MODE_SUPPORTED      0x800UL
-	#define FUNC_QCAPS_RESP_FLAGS_GENEVE_TUN_FLAGS_SUPPORTED      0x1000UL
-	#define FUNC_QCAPS_RESP_FLAGS_NVGRE_TUN_FLAGS_SUPPORTED       0x2000UL
-	#define FUNC_QCAPS_RESP_FLAGS_GRE_TUN_FLAGS_SUPPORTED         0x4000UL
-	#define FUNC_QCAPS_RESP_FLAGS_MPLS_TUN_FLAGS_SUPPORTED        0x8000UL
-	#define FUNC_QCAPS_RESP_FLAGS_PCIE_STATS_SUPPORTED            0x10000UL
-	#define FUNC_QCAPS_RESP_FLAGS_ADOPTED_PF_SUPPORTED            0x20000UL
-	#define FUNC_QCAPS_RESP_FLAGS_ADMIN_PF_SUPPORTED              0x40000UL
-	#define FUNC_QCAPS_RESP_FLAGS_LINK_ADMIN_STATUS_SUPPORTED     0x80000UL
-	#define FUNC_QCAPS_RESP_FLAGS_WCB_PUSH_MODE                   0x100000UL
-	#define FUNC_QCAPS_RESP_FLAGS_DYNAMIC_TX_RING_ALLOC           0x200000UL
-	#define FUNC_QCAPS_RESP_FLAGS_HOT_RESET_CAPABLE               0x400000UL
-	#define FUNC_QCAPS_RESP_FLAGS_ERROR_RECOVERY_CAPABLE          0x800000UL
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_STATS_SUPPORTED             0x1000000UL
+	#define FUNC_QCAPS_RESP_FLAGS_PUSH_MODE_SUPPORTED                   0x1UL
+	#define FUNC_QCAPS_RESP_FLAGS_GLOBAL_MSIX_AUTOMASKING               0x2UL
+	#define FUNC_QCAPS_RESP_FLAGS_PTP_SUPPORTED                         0x4UL
+	#define FUNC_QCAPS_RESP_FLAGS_ROCE_V1_SUPPORTED                     0x8UL
+	#define FUNC_QCAPS_RESP_FLAGS_ROCE_V2_SUPPORTED                     0x10UL
+	#define FUNC_QCAPS_RESP_FLAGS_WOL_MAGICPKT_SUPPORTED                0x20UL
+	#define FUNC_QCAPS_RESP_FLAGS_WOL_BMP_SUPPORTED                     0x40UL
+	#define FUNC_QCAPS_RESP_FLAGS_TX_RING_RL_SUPPORTED                  0x80UL
+	#define FUNC_QCAPS_RESP_FLAGS_TX_BW_CFG_SUPPORTED                   0x100UL
+	#define FUNC_QCAPS_RESP_FLAGS_VF_TX_RING_RL_SUPPORTED               0x200UL
+	#define FUNC_QCAPS_RESP_FLAGS_VF_BW_CFG_SUPPORTED                   0x400UL
+	#define FUNC_QCAPS_RESP_FLAGS_STD_TX_RING_MODE_SUPPORTED            0x800UL
+	#define FUNC_QCAPS_RESP_FLAGS_GENEVE_TUN_FLAGS_SUPPORTED            0x1000UL
+	#define FUNC_QCAPS_RESP_FLAGS_NVGRE_TUN_FLAGS_SUPPORTED             0x2000UL
+	#define FUNC_QCAPS_RESP_FLAGS_GRE_TUN_FLAGS_SUPPORTED               0x4000UL
+	#define FUNC_QCAPS_RESP_FLAGS_MPLS_TUN_FLAGS_SUPPORTED              0x8000UL
+	#define FUNC_QCAPS_RESP_FLAGS_PCIE_STATS_SUPPORTED                  0x10000UL
+	#define FUNC_QCAPS_RESP_FLAGS_ADOPTED_PF_SUPPORTED                  0x20000UL
+	#define FUNC_QCAPS_RESP_FLAGS_ADMIN_PF_SUPPORTED                    0x40000UL
+	#define FUNC_QCAPS_RESP_FLAGS_LINK_ADMIN_STATUS_SUPPORTED           0x80000UL
+	#define FUNC_QCAPS_RESP_FLAGS_WCB_PUSH_MODE                         0x100000UL
+	#define FUNC_QCAPS_RESP_FLAGS_DYNAMIC_TX_RING_ALLOC                 0x200000UL
+	#define FUNC_QCAPS_RESP_FLAGS_HOT_RESET_CAPABLE                     0x400000UL
+	#define FUNC_QCAPS_RESP_FLAGS_ERROR_RECOVERY_CAPABLE                0x800000UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_STATS_SUPPORTED                   0x1000000UL
+	#define FUNC_QCAPS_RESP_FLAGS_ERR_RECOVER_RELOAD                    0x2000000UL
+	#define FUNC_QCAPS_RESP_FLAGS_NOTIFY_VF_DEF_VNIC_CHNG_SUPPORTED     0x4000000UL
 	u8	mac_address[6];
 	__le16	max_rsscos_ctx;
 	__le16	max_cmpl_rings;
@@ -1208,7 +1251,8 @@ struct hwrm_func_qcfg_output {
 	__le16	alloc_stat_ctx;
 	__le16	alloc_msix;
 	__le16	registered_vfs;
-	u8	unused_1[3];
+	__le16	l2_doorbell_bar_size_kb;
+	u8	unused_1;
 	u8	always_1;
 	__le32	reset_addr_poll;
 	u8	unused_2[3];
@@ -1363,7 +1407,11 @@ struct hwrm_func_qstats_input {
 	__le16	target_id;
 	__le64	resp_addr;
 	__le16	fid;
-	u8	unused_0[6];
+	u8	flags;
+	#define FUNC_QSTATS_REQ_FLAGS_UNUSED    0x0UL
+	#define FUNC_QSTATS_REQ_FLAGS_ROCE_ONLY 0x1UL
+	#define FUNC_QSTATS_REQ_FLAGS_LAST     FUNC_QSTATS_REQ_FLAGS_ROCE_ONLY
+	u8	unused_0[5];
 };
 
 /* hwrm_func_qstats_output (size:1408b/176B) */
@@ -4714,7 +4762,7 @@ struct hwrm_vnic_free_output {
 	u8	valid;
 };
 
-/* hwrm_vnic_cfg_input (size:320b/40B) */
+/* hwrm_vnic_cfg_input (size:384b/48B) */
 struct hwrm_vnic_cfg_input {
 	__le16	req_type;
 	__le16	cmpl_ring;
@@ -4737,6 +4785,7 @@ struct hwrm_vnic_cfg_input {
 	#define VNIC_CFG_REQ_ENABLES_MRU                      0x10UL
 	#define VNIC_CFG_REQ_ENABLES_DEFAULT_RX_RING_ID       0x20UL
 	#define VNIC_CFG_REQ_ENABLES_DEFAULT_CMPL_RING_ID     0x40UL
+	#define VNIC_CFG_REQ_ENABLES_QUEUE_ID                 0x80UL
 	__le16	vnic_id;
 	__le16	dflt_ring_grp;
 	__le16	rss_rule;
@@ -4745,6 +4794,8 @@ struct hwrm_vnic_cfg_input {
 	__le16	mru;
 	__le16	default_rx_ring_id;
 	__le16	default_cmpl_ring_id;
+	__le16	queue_id;
+	u8	unused0[6];
 };
 
 /* hwrm_vnic_cfg_output (size:128b/16B) */
@@ -4785,6 +4836,7 @@ struct hwrm_vnic_qcaps_output {
 	#define VNIC_QCAPS_RESP_FLAGS_RSS_DFLT_CR_CAP                     0x20UL
 	#define VNIC_QCAPS_RESP_FLAGS_ROCE_MIRRORING_CAPABLE_VNIC_CAP     0x40UL
 	#define VNIC_QCAPS_RESP_FLAGS_OUTERMOST_RSS_CAP                   0x80UL
+	#define VNIC_QCAPS_RESP_FLAGS_COS_ASSIGNMENT_CAP                  0x100UL
 	__le16	max_aggs_supported;
 	u8	unused_1[5];
 	u8	valid;
@@ -6794,15 +6846,16 @@ struct hwrm_fw_reset_input {
 	__le16	target_id;
 	__le64	resp_addr;
 	u8	embedded_proc_type;
-	#define FW_RESET_REQ_EMBEDDED_PROC_TYPE_BOOT                 0x0UL
-	#define FW_RESET_REQ_EMBEDDED_PROC_TYPE_MGMT                 0x1UL
-	#define FW_RESET_REQ_EMBEDDED_PROC_TYPE_NETCTRL              0x2UL
-	#define FW_RESET_REQ_EMBEDDED_PROC_TYPE_ROCE                 0x3UL
-	#define FW_RESET_REQ_EMBEDDED_PROC_TYPE_HOST                 0x4UL
-	#define FW_RESET_REQ_EMBEDDED_PROC_TYPE_AP                   0x5UL
-	#define FW_RESET_REQ_EMBEDDED_PROC_TYPE_CHIP                 0x6UL
-	#define FW_RESET_REQ_EMBEDDED_PROC_TYPE_HOST_RESOURCE_REINIT 0x7UL
-	#define FW_RESET_REQ_EMBEDDED_PROC_TYPE_LAST                FW_RESET_REQ_EMBEDDED_PROC_TYPE_HOST_RESOURCE_REINIT
+	#define FW_RESET_REQ_EMBEDDED_PROC_TYPE_BOOT                  0x0UL
+	#define FW_RESET_REQ_EMBEDDED_PROC_TYPE_MGMT                  0x1UL
+	#define FW_RESET_REQ_EMBEDDED_PROC_TYPE_NETCTRL               0x2UL
+	#define FW_RESET_REQ_EMBEDDED_PROC_TYPE_ROCE                  0x3UL
+	#define FW_RESET_REQ_EMBEDDED_PROC_TYPE_HOST                  0x4UL
+	#define FW_RESET_REQ_EMBEDDED_PROC_TYPE_AP                    0x5UL
+	#define FW_RESET_REQ_EMBEDDED_PROC_TYPE_CHIP                  0x6UL
+	#define FW_RESET_REQ_EMBEDDED_PROC_TYPE_HOST_RESOURCE_REINIT  0x7UL
+	#define FW_RESET_REQ_EMBEDDED_PROC_TYPE_IMPACTLESS_ACTIVATION 0x8UL
+	#define FW_RESET_REQ_EMBEDDED_PROC_TYPE_LAST                 FW_RESET_REQ_EMBEDDED_PROC_TYPE_IMPACTLESS_ACTIVATION
 	u8	selfrst_status;
 	#define FW_RESET_REQ_SELFRST_STATUS_SELFRSTNONE      0x0UL
 	#define FW_RESET_REQ_SELFRST_STATUS_SELFRSTASAP      0x1UL
@@ -7125,7 +7178,14 @@ struct hwrm_temp_monitor_query_output {
 	__le16	seq_id;
 	__le16	resp_len;
 	u8	temp;
-	u8	unused_0[6];
+	u8	phy_temp;
+	u8	om_temp;
+	u8	flags;
+	#define TEMP_MONITOR_QUERY_RESP_FLAGS_TEMP_NOT_AVAILABLE         0x1UL
+	#define TEMP_MONITOR_QUERY_RESP_FLAGS_PHY_TEMP_NOT_AVAILABLE     0x2UL
+	#define TEMP_MONITOR_QUERY_RESP_FLAGS_OM_NOT_PRESENT             0x4UL
+	#define TEMP_MONITOR_QUERY_RESP_FLAGS_OM_TEMP_NOT_AVAILABLE      0x8UL
+	u8	unused_0[3];
 	u8	valid;
 };
 
-- 
2.5.1

