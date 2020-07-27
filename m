Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBA2C22E471
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 05:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbgG0DaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 23:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbgG0DaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 23:30:21 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0C1C0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 20:30:20 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id l63so8584964pge.12
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 20:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=t7nzXeEyn2WM4Gs6IM+STZu/UAAFVV5ncDjVneGM7Q4=;
        b=dDVTIvm/fik6s+39KIlfUfKgbXevl2wugul5KGf23CsGml3049jln/vLMHGC4XWL+U
         R6d72B8+F9b+KC0Qf6ddXGQ/VoSXCzAiwLLRrxaPoyczdfZ4S2OjHQfDBrHvw3To9VcH
         4yr+wO2GZWfhbymtR4zbTtrwBlohab0Ja6zxI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=t7nzXeEyn2WM4Gs6IM+STZu/UAAFVV5ncDjVneGM7Q4=;
        b=l7XcIVveyUTQYDUjV/pVfLBlAXpJ32VoBo6kFvkhVyI6bPM1DD6tRtkS3bmnSkvHoB
         zjgCoAITIKEY/083HjYGalueC3/gI1wI1tLCfxK/ncZiQ9d9ljGas17xbo3vfrNr6Rt/
         r27nnFTRSBVqteL6OcB6LEVAU9q+UlHLQc0KuhOSrdlReefWxeQKEaQLRU5lyqzKd0d1
         1mEcTnL5xhKi7NzfIF9OmnAz43wmeUIN+RzWGErwhgovJ+ePxfuihbIrEnNzYJZTpHc8
         HglPTFtHkb5Y5tjCIveGjwx5BeBdnVCogWS4r6lRTZHLJ6o1moTJ61GvDmRqgP+U1J7o
         VinA==
X-Gm-Message-State: AOAM530Ji7ChkPfZf9ki7mMcVH7SGwvDccXMzGZVcHvySoNlRIlN0y4e
        TZ5t5iDaLd7XJvJCGoxVAMRkeQ==
X-Google-Smtp-Source: ABdhPJyANSDrnD7uGHnkPWqWocBxkFM/26F5hyU07grH2Dla1eGEw619PlEFHIjdbs5S9YU3XoGKDw==
X-Received: by 2002:a63:7d16:: with SMTP id y22mr17065300pgc.136.1595820620147;
        Sun, 26 Jul 2020 20:30:20 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n25sm13504506pff.51.2020.07.26.20.30.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jul 2020 20:30:19 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 02/10] bnxt_en: Update firmware interface to 1.10.1.54.
Date:   Sun, 26 Jul 2020 23:29:38 -0400
Message-Id: <1595820586-2203-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1595820586-2203-1-git-send-email-michael.chan@broadcom.com>
References: <1595820586-2203-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Main changes are 200G support and fixing the definitions of discard and
error counters to match the hardware definitions.

Because the HWRM_PORT_PHY_QCFG message size has now exceeded the max.
encapsulated response message size of 96 bytes from the PF to the VF,
we now need to cap this message to 96 bytes for forwarding.  The forwarded
response only needs to contain the basic link status and speed information
and can be capped without adding the new information.

Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  44 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h     | 468 ++++++++++++++++------
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c   |   2 +-
 5 files changed, 390 insertions(+), 130 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b294de1..cd794b0 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9597,7 +9597,7 @@ static void bnxt_get_ring_stats(struct bnxt *bp,
 
 		stats->multicast += le64_to_cpu(hw_stats->rx_mcast_pkts);
 
-		stats->tx_dropped += le64_to_cpu(hw_stats->tx_drop_pkts);
+		stats->tx_dropped += le64_to_cpu(hw_stats->tx_error_pkts);
 	}
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 10286cb..306636d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1135,6 +1135,50 @@ struct bnxt_ntuple_filter {
 #define BNXT_FLTR_UPDATE	1
 };
 
+struct hwrm_port_phy_qcfg_output_compat {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
+	u8	link;
+	u8	link_signal_mode;
+	__le16	link_speed;
+	u8	duplex_cfg;
+	u8	pause;
+	__le16	support_speeds;
+	__le16	force_link_speed;
+	u8	auto_mode;
+	u8	auto_pause;
+	__le16	auto_link_speed;
+	__le16	auto_link_speed_mask;
+	u8	wirespeed;
+	u8	lpbk;
+	u8	force_pause;
+	u8	module_status;
+	__le32	preemphasis;
+	u8	phy_maj;
+	u8	phy_min;
+	u8	phy_bld;
+	u8	phy_type;
+	u8	media_type;
+	u8	xcvr_pkg_type;
+	u8	eee_config_phy_addr;
+	u8	parallel_detect;
+	__le16	link_partner_adv_speeds;
+	u8	link_partner_adv_auto_mode;
+	u8	link_partner_adv_pause;
+	__le16	adv_eee_link_speed_mask;
+	__le16	link_partner_adv_eee_link_speed_mask;
+	__le32	xcvr_identifier_type_tx_lpi_timer;
+	__le16	fec_cfg;
+	u8	duplex_state;
+	u8	option_flags;
+	char	phy_vendor_name[16];
+	char	phy_vendor_partnumber[16];
+	u8	unused_0[7];
+	u8	valid;
+};
+
 struct bnxt_link_info {
 	u8			phy_type;
 	u8			media_type;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index dded170..c8bafab 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -142,7 +142,7 @@ static int bnxt_set_coalesce(struct net_device *dev,
 	"rx_mcast_packets",
 	"rx_bcast_packets",
 	"rx_discards",
-	"rx_drops",
+	"rx_errors",
 	"rx_ucast_bytes",
 	"rx_mcast_bytes",
 	"rx_bcast_bytes",
@@ -152,8 +152,8 @@ static int bnxt_set_coalesce(struct net_device *dev,
 	"tx_ucast_packets",
 	"tx_mcast_packets",
 	"tx_bcast_packets",
+	"tx_errors",
 	"tx_discards",
-	"tx_drops",
 	"tx_ucast_bytes",
 	"tx_mcast_bytes",
 	"tx_bcast_bytes",
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
index 7e9235c..c4af6bf 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
@@ -169,9 +169,14 @@ struct cmd_nums {
 	#define HWRM_RING_CMPL_RING_QAGGINT_PARAMS        0x52UL
 	#define HWRM_RING_CMPL_RING_CFG_AGGINT_PARAMS     0x53UL
 	#define HWRM_RING_AGGINT_QCAPS                    0x54UL
+	#define HWRM_RING_SCHQ_ALLOC                      0x55UL
+	#define HWRM_RING_SCHQ_CFG                        0x56UL
+	#define HWRM_RING_SCHQ_FREE                       0x57UL
 	#define HWRM_RING_RESET                           0x5eUL
 	#define HWRM_RING_GRP_ALLOC                       0x60UL
 	#define HWRM_RING_GRP_FREE                        0x61UL
+	#define HWRM_RING_CFG                             0x62UL
+	#define HWRM_RING_QCFG                            0x63UL
 	#define HWRM_RESERVED5                            0x64UL
 	#define HWRM_RESERVED6                            0x65UL
 	#define HWRM_VNIC_RSS_COS_LB_CTX_ALLOC            0x70UL
@@ -224,6 +229,7 @@ struct cmd_nums {
 	#define HWRM_FW_IPC_MAILBOX                       0xccUL
 	#define HWRM_FW_ECN_CFG                           0xcdUL
 	#define HWRM_FW_ECN_QCFG                          0xceUL
+	#define HWRM_FW_SECURE_CFG                        0xcfUL
 	#define HWRM_EXEC_FWD_RESP                        0xd0UL
 	#define HWRM_REJECT_FWD_RESP                      0xd1UL
 	#define HWRM_FWD_RESP                             0xd2UL
@@ -337,6 +343,7 @@ struct cmd_nums {
 	#define HWRM_FUNC_VF_BW_QCFG                      0x196UL
 	#define HWRM_FUNC_HOST_PF_IDS_QUERY               0x197UL
 	#define HWRM_FUNC_QSTATS_EXT                      0x198UL
+	#define HWRM_STAT_EXT_CTX_QUERY                   0x199UL
 	#define HWRM_SELFTEST_QLIST                       0x200UL
 	#define HWRM_SELFTEST_EXEC                        0x201UL
 	#define HWRM_SELFTEST_IRQ                         0x202UL
@@ -353,24 +360,30 @@ struct cmd_nums {
 	#define HWRM_TF_VERSION_GET                       0x2bdUL
 	#define HWRM_TF_SESSION_OPEN                      0x2c6UL
 	#define HWRM_TF_SESSION_ATTACH                    0x2c7UL
-	#define HWRM_TF_SESSION_CLOSE                     0x2c8UL
-	#define HWRM_TF_SESSION_QCFG                      0x2c9UL
-	#define HWRM_TF_SESSION_RESC_QCAPS                0x2caUL
-	#define HWRM_TF_SESSION_RESC_ALLOC                0x2cbUL
-	#define HWRM_TF_SESSION_RESC_FREE                 0x2ccUL
-	#define HWRM_TF_SESSION_RESC_FLUSH                0x2cdUL
-	#define HWRM_TF_TBL_TYPE_GET                      0x2d0UL
-	#define HWRM_TF_TBL_TYPE_SET                      0x2d1UL
-	#define HWRM_TF_CTXT_MEM_RGTR                     0x2daUL
-	#define HWRM_TF_CTXT_MEM_UNRGTR                   0x2dbUL
-	#define HWRM_TF_EXT_EM_QCAPS                      0x2dcUL
-	#define HWRM_TF_EXT_EM_OP                         0x2ddUL
-	#define HWRM_TF_EXT_EM_CFG                        0x2deUL
-	#define HWRM_TF_EXT_EM_QCFG                       0x2dfUL
-	#define HWRM_TF_TCAM_SET                          0x2eeUL
-	#define HWRM_TF_TCAM_GET                          0x2efUL
-	#define HWRM_TF_TCAM_MOVE                         0x2f0UL
-	#define HWRM_TF_TCAM_FREE                         0x2f1UL
+	#define HWRM_TF_SESSION_REGISTER                  0x2c8UL
+	#define HWRM_TF_SESSION_UNREGISTER                0x2c9UL
+	#define HWRM_TF_SESSION_CLOSE                     0x2caUL
+	#define HWRM_TF_SESSION_QCFG                      0x2cbUL
+	#define HWRM_TF_SESSION_RESC_QCAPS                0x2ccUL
+	#define HWRM_TF_SESSION_RESC_ALLOC                0x2cdUL
+	#define HWRM_TF_SESSION_RESC_FREE                 0x2ceUL
+	#define HWRM_TF_SESSION_RESC_FLUSH                0x2cfUL
+	#define HWRM_TF_TBL_TYPE_GET                      0x2daUL
+	#define HWRM_TF_TBL_TYPE_SET                      0x2dbUL
+	#define HWRM_TF_CTXT_MEM_RGTR                     0x2e4UL
+	#define HWRM_TF_CTXT_MEM_UNRGTR                   0x2e5UL
+	#define HWRM_TF_EXT_EM_QCAPS                      0x2e6UL
+	#define HWRM_TF_EXT_EM_OP                         0x2e7UL
+	#define HWRM_TF_EXT_EM_CFG                        0x2e8UL
+	#define HWRM_TF_EXT_EM_QCFG                       0x2e9UL
+	#define HWRM_TF_EM_INSERT                         0x2eaUL
+	#define HWRM_TF_EM_DELETE                         0x2ebUL
+	#define HWRM_TF_TCAM_SET                          0x2f8UL
+	#define HWRM_TF_TCAM_GET                          0x2f9UL
+	#define HWRM_TF_TCAM_MOVE                         0x2faUL
+	#define HWRM_TF_TCAM_FREE                         0x2fbUL
+	#define HWRM_TF_GLOBAL_CFG_SET                    0x2fcUL
+	#define HWRM_TF_GLOBAL_CFG_GET                    0x2fdUL
 	#define HWRM_SV                                   0x400UL
 	#define HWRM_DBG_READ_DIRECT                      0xff10UL
 	#define HWRM_DBG_READ_INDIRECT                    0xff11UL
@@ -391,6 +404,7 @@ struct cmd_nums {
 	#define HWRM_DBG_QCAPS                            0xff20UL
 	#define HWRM_DBG_QCFG                             0xff21UL
 	#define HWRM_DBG_CRASHDUMP_MEDIUM_CFG             0xff22UL
+	#define HWRM_NVM_REQ_ARBITRATION                  0xffedUL
 	#define HWRM_NVM_FACTORY_DEFAULTS                 0xffeeUL
 	#define HWRM_NVM_VALIDATE_OPTION                  0xffefUL
 	#define HWRM_NVM_FLUSH                            0xfff0UL
@@ -464,8 +478,8 @@ struct hwrm_err_output {
 #define HWRM_VERSION_MAJOR 1
 #define HWRM_VERSION_MINOR 10
 #define HWRM_VERSION_UPDATE 1
-#define HWRM_VERSION_RSVD 33
-#define HWRM_VERSION_STR "1.10.1.33"
+#define HWRM_VERSION_RSVD 54
+#define HWRM_VERSION_STR "1.10.1.54"
 
 /* hwrm_ver_get_input (size:192b/24B) */
 struct hwrm_ver_get_input {
@@ -1094,6 +1108,8 @@ struct hwrm_func_vf_cfg_input {
 	#define FUNC_VF_CFG_REQ_FLAGS_STAT_CTX_ASSETS_TEST       0x20UL
 	#define FUNC_VF_CFG_REQ_FLAGS_VNIC_ASSETS_TEST           0x40UL
 	#define FUNC_VF_CFG_REQ_FLAGS_L2_CTX_ASSETS_TEST         0x80UL
+	#define FUNC_VF_CFG_REQ_FLAGS_PPP_PUSH_MODE_ENABLE       0x100UL
+	#define FUNC_VF_CFG_REQ_FLAGS_PPP_PUSH_MODE_DISABLE      0x200UL
 	__le16	num_rsscos_ctxs;
 	__le16	num_cmpl_rings;
 	__le16	num_tx_rings;
@@ -1189,10 +1205,16 @@ struct hwrm_func_qcaps_output {
 	__le16	max_sp_tx_rings;
 	u8	unused_0[2];
 	__le32	flags_ext;
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_ECN_MARK_SUPPORTED         0x1UL
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_ECN_STATS_SUPPORTED        0x2UL
-	#define FUNC_QCAPS_RESP_FLAGS_EXT_EXT_HW_STATS_SUPPORTED     0x4UL
-	u8	unused_1[3];
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_ECN_MARK_SUPPORTED                     0x1UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_ECN_STATS_SUPPORTED                    0x2UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_EXT_HW_STATS_SUPPORTED                 0x4UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_HOT_RESET_IF_SUPPORT                   0x8UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_PROXY_MODE_SUPPORT                     0x10UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_TX_PROXY_SRC_INTF_OVERRIDE_SUPPORT     0x20UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_SCHQ_SUPPORTED                         0x40UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_PPP_PUSH_MODE_SUPPORTED                0x80UL
+	u8	max_schqs;
+	u8	unused_1[2];
 	u8	valid;
 };
 
@@ -1226,6 +1248,8 @@ struct hwrm_func_qcfg_output {
 	#define FUNC_QCFG_RESP_FLAGS_TRUSTED_VF                   0x40UL
 	#define FUNC_QCFG_RESP_FLAGS_SECURE_MODE_ENABLED          0x80UL
 	#define FUNC_QCFG_RESP_FLAGS_PREBOOT_LEGACY_L2_RINGS      0x100UL
+	#define FUNC_QCFG_RESP_FLAGS_HOT_RESET_ALLOWED            0x200UL
+	#define FUNC_QCFG_RESP_FLAGS_PPP_PUSH_MODE_ENABLED        0x400UL
 	u8	mac_address[6];
 	__le16	pci_id;
 	__le16	alloc_rsscos_ctx;
@@ -1321,7 +1345,7 @@ struct hwrm_func_qcfg_output {
 	u8	valid;
 };
 
-/* hwrm_func_cfg_input (size:704b/88B) */
+/* hwrm_func_cfg_input (size:768b/96B) */
 struct hwrm_func_cfg_input {
 	__le16	req_type;
 	__le16	cmpl_ring;
@@ -1352,30 +1376,35 @@ struct hwrm_func_cfg_input {
 	#define FUNC_CFG_REQ_FLAGS_NQ_ASSETS_TEST                 0x800000UL
 	#define FUNC_CFG_REQ_FLAGS_TRUSTED_VF_DISABLE             0x1000000UL
 	#define FUNC_CFG_REQ_FLAGS_PREBOOT_LEGACY_L2_RINGS        0x2000000UL
+	#define FUNC_CFG_REQ_FLAGS_HOT_RESET_IF_EN_DIS            0x4000000UL
+	#define FUNC_CFG_REQ_FLAGS_PPP_PUSH_MODE_ENABLE           0x8000000UL
+	#define FUNC_CFG_REQ_FLAGS_PPP_PUSH_MODE_DISABLE          0x10000000UL
 	__le32	enables;
-	#define FUNC_CFG_REQ_ENABLES_MTU                     0x1UL
-	#define FUNC_CFG_REQ_ENABLES_MRU                     0x2UL
-	#define FUNC_CFG_REQ_ENABLES_NUM_RSSCOS_CTXS         0x4UL
-	#define FUNC_CFG_REQ_ENABLES_NUM_CMPL_RINGS          0x8UL
-	#define FUNC_CFG_REQ_ENABLES_NUM_TX_RINGS            0x10UL
-	#define FUNC_CFG_REQ_ENABLES_NUM_RX_RINGS            0x20UL
-	#define FUNC_CFG_REQ_ENABLES_NUM_L2_CTXS             0x40UL
-	#define FUNC_CFG_REQ_ENABLES_NUM_VNICS               0x80UL
-	#define FUNC_CFG_REQ_ENABLES_NUM_STAT_CTXS           0x100UL
-	#define FUNC_CFG_REQ_ENABLES_DFLT_MAC_ADDR           0x200UL
-	#define FUNC_CFG_REQ_ENABLES_DFLT_VLAN               0x400UL
-	#define FUNC_CFG_REQ_ENABLES_DFLT_IP_ADDR            0x800UL
-	#define FUNC_CFG_REQ_ENABLES_MIN_BW                  0x1000UL
-	#define FUNC_CFG_REQ_ENABLES_MAX_BW                  0x2000UL
-	#define FUNC_CFG_REQ_ENABLES_ASYNC_EVENT_CR          0x4000UL
-	#define FUNC_CFG_REQ_ENABLES_VLAN_ANTISPOOF_MODE     0x8000UL
-	#define FUNC_CFG_REQ_ENABLES_ALLOWED_VLAN_PRIS       0x10000UL
-	#define FUNC_CFG_REQ_ENABLES_EVB_MODE                0x20000UL
-	#define FUNC_CFG_REQ_ENABLES_NUM_MCAST_FILTERS       0x40000UL
-	#define FUNC_CFG_REQ_ENABLES_NUM_HW_RING_GRPS        0x80000UL
-	#define FUNC_CFG_REQ_ENABLES_CACHE_LINESIZE          0x100000UL
-	#define FUNC_CFG_REQ_ENABLES_NUM_MSIX                0x200000UL
-	#define FUNC_CFG_REQ_ENABLES_ADMIN_LINK_STATE        0x400000UL
+	#define FUNC_CFG_REQ_ENABLES_MTU                      0x1UL
+	#define FUNC_CFG_REQ_ENABLES_MRU                      0x2UL
+	#define FUNC_CFG_REQ_ENABLES_NUM_RSSCOS_CTXS          0x4UL
+	#define FUNC_CFG_REQ_ENABLES_NUM_CMPL_RINGS           0x8UL
+	#define FUNC_CFG_REQ_ENABLES_NUM_TX_RINGS             0x10UL
+	#define FUNC_CFG_REQ_ENABLES_NUM_RX_RINGS             0x20UL
+	#define FUNC_CFG_REQ_ENABLES_NUM_L2_CTXS              0x40UL
+	#define FUNC_CFG_REQ_ENABLES_NUM_VNICS                0x80UL
+	#define FUNC_CFG_REQ_ENABLES_NUM_STAT_CTXS            0x100UL
+	#define FUNC_CFG_REQ_ENABLES_DFLT_MAC_ADDR            0x200UL
+	#define FUNC_CFG_REQ_ENABLES_DFLT_VLAN                0x400UL
+	#define FUNC_CFG_REQ_ENABLES_DFLT_IP_ADDR             0x800UL
+	#define FUNC_CFG_REQ_ENABLES_MIN_BW                   0x1000UL
+	#define FUNC_CFG_REQ_ENABLES_MAX_BW                   0x2000UL
+	#define FUNC_CFG_REQ_ENABLES_ASYNC_EVENT_CR           0x4000UL
+	#define FUNC_CFG_REQ_ENABLES_VLAN_ANTISPOOF_MODE      0x8000UL
+	#define FUNC_CFG_REQ_ENABLES_ALLOWED_VLAN_PRIS        0x10000UL
+	#define FUNC_CFG_REQ_ENABLES_EVB_MODE                 0x20000UL
+	#define FUNC_CFG_REQ_ENABLES_NUM_MCAST_FILTERS        0x40000UL
+	#define FUNC_CFG_REQ_ENABLES_NUM_HW_RING_GRPS         0x80000UL
+	#define FUNC_CFG_REQ_ENABLES_CACHE_LINESIZE           0x100000UL
+	#define FUNC_CFG_REQ_ENABLES_NUM_MSIX                 0x200000UL
+	#define FUNC_CFG_REQ_ENABLES_ADMIN_LINK_STATE         0x400000UL
+	#define FUNC_CFG_REQ_ENABLES_HOT_RESET_IF_SUPPORT     0x800000UL
+	#define FUNC_CFG_REQ_ENABLES_SCHQ_ID                  0x1000000UL
 	__le16	mtu;
 	__le16	mru;
 	__le16	num_rsscos_ctxs;
@@ -1449,6 +1478,8 @@ struct hwrm_func_cfg_input {
 	#define FUNC_CFG_REQ_OPTIONS_RSVD_MASK                   0xf0UL
 	#define FUNC_CFG_REQ_OPTIONS_RSVD_SFT                    4
 	__le16	num_mcast_filters;
+	__le16	schq_id;
+	u8	unused_0[6];
 };
 
 /* hwrm_func_cfg_output (size:128b/16B) */
@@ -1507,7 +1538,7 @@ struct hwrm_func_qstats_output {
 	u8	valid;
 };
 
-/* hwrm_func_qstats_ext_input (size:192b/24B) */
+/* hwrm_func_qstats_ext_input (size:256b/32B) */
 struct hwrm_func_qstats_ext_input {
 	__le16	req_type;
 	__le16	cmpl_ring;
@@ -1520,7 +1551,12 @@ struct hwrm_func_qstats_ext_input {
 	#define FUNC_QSTATS_EXT_REQ_FLAGS_ROCE_ONLY    0x1UL
 	#define FUNC_QSTATS_EXT_REQ_FLAGS_COUNTER_MASK 0x2UL
 	#define FUNC_QSTATS_EXT_REQ_FLAGS_LAST        FUNC_QSTATS_EXT_REQ_FLAGS_COUNTER_MASK
-	u8	unused_0[5];
+	u8	unused_0[1];
+	__le32	enables;
+	#define FUNC_QSTATS_EXT_REQ_ENABLES_SCHQ_ID     0x1UL
+	__le16	schq_id;
+	__le16	traffic_class;
+	u8	unused_1[4];
 };
 
 /* hwrm_func_qstats_ext_output (size:1472b/184B) */
@@ -1533,15 +1569,15 @@ struct hwrm_func_qstats_ext_output {
 	__le64	rx_mcast_pkts;
 	__le64	rx_bcast_pkts;
 	__le64	rx_discard_pkts;
-	__le64	rx_drop_pkts;
+	__le64	rx_error_pkts;
 	__le64	rx_ucast_bytes;
 	__le64	rx_mcast_bytes;
 	__le64	rx_bcast_bytes;
 	__le64	tx_ucast_pkts;
 	__le64	tx_mcast_pkts;
 	__le64	tx_bcast_pkts;
+	__le64	tx_error_pkts;
 	__le64	tx_discard_pkts;
-	__le64	tx_drop_pkts;
 	__le64	tx_ucast_bytes;
 	__le64	tx_mcast_bytes;
 	__le64	tx_bcast_bytes;
@@ -2376,33 +2412,39 @@ struct hwrm_port_phy_cfg_input {
 	__le16	target_id;
 	__le64	resp_addr;
 	__le32	flags;
-	#define PORT_PHY_CFG_REQ_FLAGS_RESET_PHY                0x1UL
-	#define PORT_PHY_CFG_REQ_FLAGS_DEPRECATED               0x2UL
-	#define PORT_PHY_CFG_REQ_FLAGS_FORCE                    0x4UL
-	#define PORT_PHY_CFG_REQ_FLAGS_RESTART_AUTONEG          0x8UL
-	#define PORT_PHY_CFG_REQ_FLAGS_EEE_ENABLE               0x10UL
-	#define PORT_PHY_CFG_REQ_FLAGS_EEE_DISABLE              0x20UL
-	#define PORT_PHY_CFG_REQ_FLAGS_EEE_TX_LPI_ENABLE        0x40UL
-	#define PORT_PHY_CFG_REQ_FLAGS_EEE_TX_LPI_DISABLE       0x80UL
-	#define PORT_PHY_CFG_REQ_FLAGS_FEC_AUTONEG_ENABLE       0x100UL
-	#define PORT_PHY_CFG_REQ_FLAGS_FEC_AUTONEG_DISABLE      0x200UL
-	#define PORT_PHY_CFG_REQ_FLAGS_FEC_CLAUSE74_ENABLE      0x400UL
-	#define PORT_PHY_CFG_REQ_FLAGS_FEC_CLAUSE74_DISABLE     0x800UL
-	#define PORT_PHY_CFG_REQ_FLAGS_FEC_CLAUSE91_ENABLE      0x1000UL
-	#define PORT_PHY_CFG_REQ_FLAGS_FEC_CLAUSE91_DISABLE     0x2000UL
-	#define PORT_PHY_CFG_REQ_FLAGS_FORCE_LINK_DWN           0x4000UL
+	#define PORT_PHY_CFG_REQ_FLAGS_RESET_PHY                 0x1UL
+	#define PORT_PHY_CFG_REQ_FLAGS_DEPRECATED                0x2UL
+	#define PORT_PHY_CFG_REQ_FLAGS_FORCE                     0x4UL
+	#define PORT_PHY_CFG_REQ_FLAGS_RESTART_AUTONEG           0x8UL
+	#define PORT_PHY_CFG_REQ_FLAGS_EEE_ENABLE                0x10UL
+	#define PORT_PHY_CFG_REQ_FLAGS_EEE_DISABLE               0x20UL
+	#define PORT_PHY_CFG_REQ_FLAGS_EEE_TX_LPI_ENABLE         0x40UL
+	#define PORT_PHY_CFG_REQ_FLAGS_EEE_TX_LPI_DISABLE        0x80UL
+	#define PORT_PHY_CFG_REQ_FLAGS_FEC_AUTONEG_ENABLE        0x100UL
+	#define PORT_PHY_CFG_REQ_FLAGS_FEC_AUTONEG_DISABLE       0x200UL
+	#define PORT_PHY_CFG_REQ_FLAGS_FEC_CLAUSE74_ENABLE       0x400UL
+	#define PORT_PHY_CFG_REQ_FLAGS_FEC_CLAUSE74_DISABLE      0x800UL
+	#define PORT_PHY_CFG_REQ_FLAGS_FEC_CLAUSE91_ENABLE       0x1000UL
+	#define PORT_PHY_CFG_REQ_FLAGS_FEC_CLAUSE91_DISABLE      0x2000UL
+	#define PORT_PHY_CFG_REQ_FLAGS_FORCE_LINK_DWN            0x4000UL
+	#define PORT_PHY_CFG_REQ_FLAGS_FEC_RS544_1XN_ENABLE      0x8000UL
+	#define PORT_PHY_CFG_REQ_FLAGS_FEC_RS544_1XN_DISABLE     0x10000UL
+	#define PORT_PHY_CFG_REQ_FLAGS_FEC_RS544_2XN_ENABLE      0x20000UL
+	#define PORT_PHY_CFG_REQ_FLAGS_FEC_RS544_2XN_DISABLE     0x40000UL
 	__le32	enables;
-	#define PORT_PHY_CFG_REQ_ENABLES_AUTO_MODE                0x1UL
-	#define PORT_PHY_CFG_REQ_ENABLES_AUTO_DUPLEX              0x2UL
-	#define PORT_PHY_CFG_REQ_ENABLES_AUTO_PAUSE               0x4UL
-	#define PORT_PHY_CFG_REQ_ENABLES_AUTO_LINK_SPEED          0x8UL
-	#define PORT_PHY_CFG_REQ_ENABLES_AUTO_LINK_SPEED_MASK     0x10UL
-	#define PORT_PHY_CFG_REQ_ENABLES_WIRESPEED                0x20UL
-	#define PORT_PHY_CFG_REQ_ENABLES_LPBK                     0x40UL
-	#define PORT_PHY_CFG_REQ_ENABLES_PREEMPHASIS              0x80UL
-	#define PORT_PHY_CFG_REQ_ENABLES_FORCE_PAUSE              0x100UL
-	#define PORT_PHY_CFG_REQ_ENABLES_EEE_LINK_SPEED_MASK      0x200UL
-	#define PORT_PHY_CFG_REQ_ENABLES_TX_LPI_TIMER             0x400UL
+	#define PORT_PHY_CFG_REQ_ENABLES_AUTO_MODE                     0x1UL
+	#define PORT_PHY_CFG_REQ_ENABLES_AUTO_DUPLEX                   0x2UL
+	#define PORT_PHY_CFG_REQ_ENABLES_AUTO_PAUSE                    0x4UL
+	#define PORT_PHY_CFG_REQ_ENABLES_AUTO_LINK_SPEED               0x8UL
+	#define PORT_PHY_CFG_REQ_ENABLES_AUTO_LINK_SPEED_MASK          0x10UL
+	#define PORT_PHY_CFG_REQ_ENABLES_WIRESPEED                     0x20UL
+	#define PORT_PHY_CFG_REQ_ENABLES_LPBK                          0x40UL
+	#define PORT_PHY_CFG_REQ_ENABLES_PREEMPHASIS                   0x80UL
+	#define PORT_PHY_CFG_REQ_ENABLES_FORCE_PAUSE                   0x100UL
+	#define PORT_PHY_CFG_REQ_ENABLES_EEE_LINK_SPEED_MASK           0x200UL
+	#define PORT_PHY_CFG_REQ_ENABLES_TX_LPI_TIMER                  0x400UL
+	#define PORT_PHY_CFG_REQ_ENABLES_FORCE_PAM4_LINK_SPEED         0x800UL
+	#define PORT_PHY_CFG_REQ_ENABLES_AUTO_PAM4_LINK_SPEED_MASK     0x1000UL
 	__le16	port_id;
 	__le16	force_link_speed;
 	#define PORT_PHY_CFG_REQ_FORCE_LINK_SPEED_100MB 0x1UL
@@ -2415,7 +2457,6 @@ struct hwrm_port_phy_cfg_input {
 	#define PORT_PHY_CFG_REQ_FORCE_LINK_SPEED_40GB  0x190UL
 	#define PORT_PHY_CFG_REQ_FORCE_LINK_SPEED_50GB  0x1f4UL
 	#define PORT_PHY_CFG_REQ_FORCE_LINK_SPEED_100GB 0x3e8UL
-	#define PORT_PHY_CFG_REQ_FORCE_LINK_SPEED_200GB 0x7d0UL
 	#define PORT_PHY_CFG_REQ_FORCE_LINK_SPEED_10MB  0xffffUL
 	#define PORT_PHY_CFG_REQ_FORCE_LINK_SPEED_LAST PORT_PHY_CFG_REQ_FORCE_LINK_SPEED_10MB
 	u8	auto_mode;
@@ -2446,7 +2487,6 @@ struct hwrm_port_phy_cfg_input {
 	#define PORT_PHY_CFG_REQ_AUTO_LINK_SPEED_40GB  0x190UL
 	#define PORT_PHY_CFG_REQ_AUTO_LINK_SPEED_50GB  0x1f4UL
 	#define PORT_PHY_CFG_REQ_AUTO_LINK_SPEED_100GB 0x3e8UL
-	#define PORT_PHY_CFG_REQ_AUTO_LINK_SPEED_200GB 0x7d0UL
 	#define PORT_PHY_CFG_REQ_AUTO_LINK_SPEED_10MB  0xffffUL
 	#define PORT_PHY_CFG_REQ_AUTO_LINK_SPEED_LAST PORT_PHY_CFG_REQ_AUTO_LINK_SPEED_10MB
 	__le16	auto_link_speed_mask;
@@ -2464,7 +2504,6 @@ struct hwrm_port_phy_cfg_input {
 	#define PORT_PHY_CFG_REQ_AUTO_LINK_SPEED_MASK_100GB       0x800UL
 	#define PORT_PHY_CFG_REQ_AUTO_LINK_SPEED_MASK_10MBHD      0x1000UL
 	#define PORT_PHY_CFG_REQ_AUTO_LINK_SPEED_MASK_10MB        0x2000UL
-	#define PORT_PHY_CFG_REQ_AUTO_LINK_SPEED_MASK_200GB       0x4000UL
 	u8	wirespeed;
 	#define PORT_PHY_CFG_REQ_WIRESPEED_OFF 0x0UL
 	#define PORT_PHY_CFG_REQ_WIRESPEED_ON  0x1UL
@@ -2488,11 +2527,19 @@ struct hwrm_port_phy_cfg_input {
 	#define PORT_PHY_CFG_REQ_EEE_LINK_SPEED_MASK_RSVD3     0x10UL
 	#define PORT_PHY_CFG_REQ_EEE_LINK_SPEED_MASK_RSVD4     0x20UL
 	#define PORT_PHY_CFG_REQ_EEE_LINK_SPEED_MASK_10GB      0x40UL
-	u8	unused_2[2];
+	__le16	force_pam4_link_speed;
+	#define PORT_PHY_CFG_REQ_FORCE_PAM4_LINK_SPEED_50GB  0x1f4UL
+	#define PORT_PHY_CFG_REQ_FORCE_PAM4_LINK_SPEED_100GB 0x3e8UL
+	#define PORT_PHY_CFG_REQ_FORCE_PAM4_LINK_SPEED_200GB 0x7d0UL
+	#define PORT_PHY_CFG_REQ_FORCE_PAM4_LINK_SPEED_LAST PORT_PHY_CFG_REQ_FORCE_PAM4_LINK_SPEED_200GB
 	__le32	tx_lpi_timer;
 	#define PORT_PHY_CFG_REQ_TX_LPI_TIMER_MASK 0xffffffUL
 	#define PORT_PHY_CFG_REQ_TX_LPI_TIMER_SFT 0
-	__le32	unused_3;
+	__le16	auto_link_pam4_speed_mask;
+	#define PORT_PHY_CFG_REQ_AUTO_LINK_PAM4_SPEED_MASK_50G      0x1UL
+	#define PORT_PHY_CFG_REQ_AUTO_LINK_PAM4_SPEED_MASK_100G     0x2UL
+	#define PORT_PHY_CFG_REQ_AUTO_LINK_PAM4_SPEED_MASK_200G     0x4UL
+	u8	unused_2[2];
 };
 
 /* hwrm_port_phy_cfg_output (size:128b/16B) */
@@ -2526,7 +2573,7 @@ struct hwrm_port_phy_qcfg_input {
 	u8	unused_0[6];
 };
 
-/* hwrm_port_phy_qcfg_output (size:768b/96B) */
+/* hwrm_port_phy_qcfg_output (size:832b/104B) */
 struct hwrm_port_phy_qcfg_output {
 	__le16	error_code;
 	__le16	req_type;
@@ -2537,7 +2584,10 @@ struct hwrm_port_phy_qcfg_output {
 	#define PORT_PHY_QCFG_RESP_LINK_SIGNAL  0x1UL
 	#define PORT_PHY_QCFG_RESP_LINK_LINK    0x2UL
 	#define PORT_PHY_QCFG_RESP_LINK_LAST   PORT_PHY_QCFG_RESP_LINK_LINK
-	u8	unused_0;
+	u8	link_signal_mode;
+	#define PORT_PHY_QCFG_RESP_LINK_SIGNAL_MODE_NRZ  0x0UL
+	#define PORT_PHY_QCFG_RESP_LINK_SIGNAL_MODE_PAM4 0x1UL
+	#define PORT_PHY_QCFG_RESP_LINK_SIGNAL_MODE_LAST PORT_PHY_QCFG_RESP_LINK_SIGNAL_MODE_PAM4
 	__le16	link_speed;
 	#define PORT_PHY_QCFG_RESP_LINK_SPEED_100MB 0x1UL
 	#define PORT_PHY_QCFG_RESP_LINK_SPEED_1GB   0xaUL
@@ -2574,7 +2624,6 @@ struct hwrm_port_phy_qcfg_output {
 	#define PORT_PHY_QCFG_RESP_SUPPORT_SPEEDS_100GB       0x800UL
 	#define PORT_PHY_QCFG_RESP_SUPPORT_SPEEDS_10MBHD      0x1000UL
 	#define PORT_PHY_QCFG_RESP_SUPPORT_SPEEDS_10MB        0x2000UL
-	#define PORT_PHY_QCFG_RESP_SUPPORT_SPEEDS_200GB       0x4000UL
 	__le16	force_link_speed;
 	#define PORT_PHY_QCFG_RESP_FORCE_LINK_SPEED_100MB 0x1UL
 	#define PORT_PHY_QCFG_RESP_FORCE_LINK_SPEED_1GB   0xaUL
@@ -2586,7 +2635,6 @@ struct hwrm_port_phy_qcfg_output {
 	#define PORT_PHY_QCFG_RESP_FORCE_LINK_SPEED_40GB  0x190UL
 	#define PORT_PHY_QCFG_RESP_FORCE_LINK_SPEED_50GB  0x1f4UL
 	#define PORT_PHY_QCFG_RESP_FORCE_LINK_SPEED_100GB 0x3e8UL
-	#define PORT_PHY_QCFG_RESP_FORCE_LINK_SPEED_200GB 0x7d0UL
 	#define PORT_PHY_QCFG_RESP_FORCE_LINK_SPEED_10MB  0xffffUL
 	#define PORT_PHY_QCFG_RESP_FORCE_LINK_SPEED_LAST PORT_PHY_QCFG_RESP_FORCE_LINK_SPEED_10MB
 	u8	auto_mode;
@@ -2611,7 +2659,6 @@ struct hwrm_port_phy_qcfg_output {
 	#define PORT_PHY_QCFG_RESP_AUTO_LINK_SPEED_40GB  0x190UL
 	#define PORT_PHY_QCFG_RESP_AUTO_LINK_SPEED_50GB  0x1f4UL
 	#define PORT_PHY_QCFG_RESP_AUTO_LINK_SPEED_100GB 0x3e8UL
-	#define PORT_PHY_QCFG_RESP_AUTO_LINK_SPEED_200GB 0x7d0UL
 	#define PORT_PHY_QCFG_RESP_AUTO_LINK_SPEED_10MB  0xffffUL
 	#define PORT_PHY_QCFG_RESP_AUTO_LINK_SPEED_LAST PORT_PHY_QCFG_RESP_AUTO_LINK_SPEED_10MB
 	__le16	auto_link_speed_mask;
@@ -2629,7 +2676,6 @@ struct hwrm_port_phy_qcfg_output {
 	#define PORT_PHY_QCFG_RESP_AUTO_LINK_SPEED_MASK_100GB       0x800UL
 	#define PORT_PHY_QCFG_RESP_AUTO_LINK_SPEED_MASK_10MBHD      0x1000UL
 	#define PORT_PHY_QCFG_RESP_AUTO_LINK_SPEED_MASK_10MB        0x2000UL
-	#define PORT_PHY_QCFG_RESP_AUTO_LINK_SPEED_MASK_200GB       0x4000UL
 	u8	wirespeed;
 	#define PORT_PHY_QCFG_RESP_WIRESPEED_OFF 0x0UL
 	#define PORT_PHY_QCFG_RESP_WIRESPEED_ON  0x1UL
@@ -2763,13 +2809,21 @@ struct hwrm_port_phy_qcfg_output {
 	#define PORT_PHY_QCFG_RESP_XCVR_IDENTIFIER_TYPE_QSFP28    (0x11UL << 24)
 	#define PORT_PHY_QCFG_RESP_XCVR_IDENTIFIER_TYPE_LAST     PORT_PHY_QCFG_RESP_XCVR_IDENTIFIER_TYPE_QSFP28
 	__le16	fec_cfg;
-	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_NONE_SUPPORTED         0x1UL
-	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_AUTONEG_SUPPORTED      0x2UL
-	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_AUTONEG_ENABLED        0x4UL
-	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_CLAUSE74_SUPPORTED     0x8UL
-	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_CLAUSE74_ENABLED       0x10UL
-	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_CLAUSE91_SUPPORTED     0x20UL
-	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_CLAUSE91_ENABLED       0x40UL
+	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_NONE_SUPPORTED          0x1UL
+	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_AUTONEG_SUPPORTED       0x2UL
+	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_AUTONEG_ENABLED         0x4UL
+	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_CLAUSE74_SUPPORTED      0x8UL
+	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_CLAUSE74_ENABLED        0x10UL
+	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_CLAUSE91_SUPPORTED      0x20UL
+	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_CLAUSE91_ENABLED        0x40UL
+	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_RS544_1XN_SUPPORTED     0x80UL
+	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_RS544_1XN_ENABLED       0x100UL
+	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_RS544_2XN_SUPPORTED     0x200UL
+	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_RS544_2XN_ENABLED       0x400UL
+	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_CLAUSE74_ACTIVE         0x800UL
+	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_CLAUSE91_ACTIVE         0x1000UL
+	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_RS544_1XN_ACTIVE        0x2000UL
+	#define PORT_PHY_QCFG_RESP_FEC_CFG_FEC_RS544_2XN_ACTIVE        0x4000UL
 	u8	duplex_state;
 	#define PORT_PHY_QCFG_RESP_DUPLEX_STATE_HALF 0x0UL
 	#define PORT_PHY_QCFG_RESP_DUPLEX_STATE_FULL 0x1UL
@@ -2778,7 +2832,24 @@ struct hwrm_port_phy_qcfg_output {
 	#define PORT_PHY_QCFG_RESP_OPTION_FLAGS_MEDIA_AUTO_DETECT     0x1UL
 	char	phy_vendor_name[16];
 	char	phy_vendor_partnumber[16];
-	u8	unused_2[7];
+	__le16	support_pam4_speeds;
+	#define PORT_PHY_QCFG_RESP_SUPPORT_PAM4_SPEEDS_50G      0x1UL
+	#define PORT_PHY_QCFG_RESP_SUPPORT_PAM4_SPEEDS_100G     0x2UL
+	#define PORT_PHY_QCFG_RESP_SUPPORT_PAM4_SPEEDS_200G     0x4UL
+	__le16	force_pam4_link_speed;
+	#define PORT_PHY_QCFG_RESP_FORCE_PAM4_LINK_SPEED_50GB  0x1f4UL
+	#define PORT_PHY_QCFG_RESP_FORCE_PAM4_LINK_SPEED_100GB 0x3e8UL
+	#define PORT_PHY_QCFG_RESP_FORCE_PAM4_LINK_SPEED_200GB 0x7d0UL
+	#define PORT_PHY_QCFG_RESP_FORCE_PAM4_LINK_SPEED_LAST PORT_PHY_QCFG_RESP_FORCE_PAM4_LINK_SPEED_200GB
+	__le16	auto_pam4_link_speed_mask;
+	#define PORT_PHY_QCFG_RESP_AUTO_PAM4_LINK_SPEED_MASK_50G      0x1UL
+	#define PORT_PHY_QCFG_RESP_AUTO_PAM4_LINK_SPEED_MASK_100G     0x2UL
+	#define PORT_PHY_QCFG_RESP_AUTO_PAM4_LINK_SPEED_MASK_200G     0x4UL
+	__le16	link_partner_pam4_adv_speeds;
+	#define PORT_PHY_QCFG_RESP_LINK_PARTNER_PAM4_ADV_SPEEDS_50GB      0x1UL
+	#define PORT_PHY_QCFG_RESP_LINK_PARTNER_PAM4_ADV_SPEEDS_100GB     0x2UL
+	#define PORT_PHY_QCFG_RESP_LINK_PARTNER_PAM4_ADV_SPEEDS_200GB     0x4UL
+	u8	unused_0[7];
 	u8	valid;
 };
 
@@ -3304,19 +3375,20 @@ struct hwrm_port_phy_qcaps_input {
 	u8	unused_0[6];
 };
 
-/* hwrm_port_phy_qcaps_output (size:192b/24B) */
+/* hwrm_port_phy_qcaps_output (size:256b/32B) */
 struct hwrm_port_phy_qcaps_output {
 	__le16	error_code;
 	__le16	req_type;
 	__le16	seq_id;
 	__le16	resp_len;
 	u8	flags;
-	#define PORT_PHY_QCAPS_RESP_FLAGS_EEE_SUPPORTED                0x1UL
-	#define PORT_PHY_QCAPS_RESP_FLAGS_EXTERNAL_LPBK_SUPPORTED      0x2UL
-	#define PORT_PHY_QCAPS_RESP_FLAGS_AUTONEG_LPBK_SUPPORTED       0x4UL
-	#define PORT_PHY_QCAPS_RESP_FLAGS_SHARED_PHY_CFG_SUPPORTED     0x8UL
-	#define PORT_PHY_QCAPS_RESP_FLAGS_RSVD1_MASK                   0xf0UL
-	#define PORT_PHY_QCAPS_RESP_FLAGS_RSVD1_SFT                    4
+	#define PORT_PHY_QCAPS_RESP_FLAGS_EEE_SUPPORTED                    0x1UL
+	#define PORT_PHY_QCAPS_RESP_FLAGS_EXTERNAL_LPBK_SUPPORTED          0x2UL
+	#define PORT_PHY_QCAPS_RESP_FLAGS_AUTONEG_LPBK_SUPPORTED           0x4UL
+	#define PORT_PHY_QCAPS_RESP_FLAGS_SHARED_PHY_CFG_SUPPORTED         0x8UL
+	#define PORT_PHY_QCAPS_RESP_FLAGS_CUMULATIVE_COUNTERS_ON_RESET     0x10UL
+	#define PORT_PHY_QCAPS_RESP_FLAGS_RSVD1_MASK                       0xe0UL
+	#define PORT_PHY_QCAPS_RESP_FLAGS_RSVD1_SFT                        5
 	u8	port_cnt;
 	#define PORT_PHY_QCAPS_RESP_PORT_CNT_UNKNOWN 0x0UL
 	#define PORT_PHY_QCAPS_RESP_PORT_CNT_1       0x1UL
@@ -3339,7 +3411,6 @@ struct hwrm_port_phy_qcaps_output {
 	#define PORT_PHY_QCAPS_RESP_SUPPORTED_SPEEDS_FORCE_MODE_100GB       0x800UL
 	#define PORT_PHY_QCAPS_RESP_SUPPORTED_SPEEDS_FORCE_MODE_10MBHD      0x1000UL
 	#define PORT_PHY_QCAPS_RESP_SUPPORTED_SPEEDS_FORCE_MODE_10MB        0x2000UL
-	#define PORT_PHY_QCAPS_RESP_SUPPORTED_SPEEDS_FORCE_MODE_200GB       0x4000UL
 	__le16	supported_speeds_auto_mode;
 	#define PORT_PHY_QCAPS_RESP_SUPPORTED_SPEEDS_AUTO_MODE_100MBHD     0x1UL
 	#define PORT_PHY_QCAPS_RESP_SUPPORTED_SPEEDS_AUTO_MODE_100MB       0x2UL
@@ -3355,7 +3426,6 @@ struct hwrm_port_phy_qcaps_output {
 	#define PORT_PHY_QCAPS_RESP_SUPPORTED_SPEEDS_AUTO_MODE_100GB       0x800UL
 	#define PORT_PHY_QCAPS_RESP_SUPPORTED_SPEEDS_AUTO_MODE_10MBHD      0x1000UL
 	#define PORT_PHY_QCAPS_RESP_SUPPORTED_SPEEDS_AUTO_MODE_10MB        0x2000UL
-	#define PORT_PHY_QCAPS_RESP_SUPPORTED_SPEEDS_AUTO_MODE_200GB       0x4000UL
 	__le16	supported_speeds_eee_mode;
 	#define PORT_PHY_QCAPS_RESP_SUPPORTED_SPEEDS_EEE_MODE_RSVD1     0x1UL
 	#define PORT_PHY_QCAPS_RESP_SUPPORTED_SPEEDS_EEE_MODE_100MB     0x2UL
@@ -3372,8 +3442,18 @@ struct hwrm_port_phy_qcaps_output {
 	__le32	valid_tx_lpi_timer_high;
 	#define PORT_PHY_QCAPS_RESP_TX_LPI_TIMER_HIGH_MASK 0xffffffUL
 	#define PORT_PHY_QCAPS_RESP_TX_LPI_TIMER_HIGH_SFT 0
-	#define PORT_PHY_QCAPS_RESP_VALID_MASK            0xff000000UL
-	#define PORT_PHY_QCAPS_RESP_VALID_SFT             24
+	#define PORT_PHY_QCAPS_RESP_RSVD_MASK             0xff000000UL
+	#define PORT_PHY_QCAPS_RESP_RSVD_SFT              24
+	__le16	supported_pam4_speeds_auto_mode;
+	#define PORT_PHY_QCAPS_RESP_SUPPORTED_PAM4_SPEEDS_AUTO_MODE_50G      0x1UL
+	#define PORT_PHY_QCAPS_RESP_SUPPORTED_PAM4_SPEEDS_AUTO_MODE_100G     0x2UL
+	#define PORT_PHY_QCAPS_RESP_SUPPORTED_PAM4_SPEEDS_AUTO_MODE_200G     0x4UL
+	__le16	supported_pam4_speeds_force_mode;
+	#define PORT_PHY_QCAPS_RESP_SUPPORTED_PAM4_SPEEDS_FORCE_MODE_50G      0x1UL
+	#define PORT_PHY_QCAPS_RESP_SUPPORTED_PAM4_SPEEDS_FORCE_MODE_100G     0x2UL
+	#define PORT_PHY_QCAPS_RESP_SUPPORTED_PAM4_SPEEDS_FORCE_MODE_200G     0x4UL
+	u8	unused_0[3];
+	u8	valid;
 };
 
 /* hwrm_port_phy_i2c_read_input (size:320b/40B) */
@@ -3812,7 +3892,7 @@ struct hwrm_queue_qportcfg_input {
 	u8	unused_0;
 };
 
-/* hwrm_queue_qportcfg_output (size:256b/32B) */
+/* hwrm_queue_qportcfg_output (size:1344b/168B) */
 struct hwrm_queue_qportcfg_output {
 	__le16	error_code;
 	__le16	req_type;
@@ -3898,6 +3978,49 @@ struct hwrm_queue_qportcfg_output {
 	#define QUEUE_QPORTCFG_RESP_QUEUE_ID7_SERVICE_PROFILE_LOSSLESS_NIC   0x3UL
 	#define QUEUE_QPORTCFG_RESP_QUEUE_ID7_SERVICE_PROFILE_UNKNOWN        0xffUL
 	#define QUEUE_QPORTCFG_RESP_QUEUE_ID7_SERVICE_PROFILE_LAST          QUEUE_QPORTCFG_RESP_QUEUE_ID7_SERVICE_PROFILE_UNKNOWN
+	u8	unused_0;
+	char	qid0_name[16];
+	char	qid1_name[16];
+	char	qid2_name[16];
+	char	qid3_name[16];
+	char	qid4_name[16];
+	char	qid5_name[16];
+	char	qid6_name[16];
+	char	qid7_name[16];
+	u8	unused_1[7];
+	u8	valid;
+};
+
+/* hwrm_queue_qcfg_input (size:192b/24B) */
+struct hwrm_queue_qcfg_input {
+	__le16	req_type;
+	__le16	cmpl_ring;
+	__le16	seq_id;
+	__le16	target_id;
+	__le64	resp_addr;
+	__le32	flags;
+	#define QUEUE_QCFG_REQ_FLAGS_PATH     0x1UL
+	#define QUEUE_QCFG_REQ_FLAGS_PATH_TX    0x0UL
+	#define QUEUE_QCFG_REQ_FLAGS_PATH_RX    0x1UL
+	#define QUEUE_QCFG_REQ_FLAGS_PATH_LAST QUEUE_QCFG_REQ_FLAGS_PATH_RX
+	__le32	queue_id;
+};
+
+/* hwrm_queue_qcfg_output (size:128b/16B) */
+struct hwrm_queue_qcfg_output {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
+	__le32	queue_len;
+	u8	service_profile;
+	#define QUEUE_QCFG_RESP_SERVICE_PROFILE_LOSSY    0x0UL
+	#define QUEUE_QCFG_RESP_SERVICE_PROFILE_LOSSLESS 0x1UL
+	#define QUEUE_QCFG_RESP_SERVICE_PROFILE_UNKNOWN  0xffUL
+	#define QUEUE_QCFG_RESP_SERVICE_PROFILE_LAST    QUEUE_QCFG_RESP_SERVICE_PROFILE_UNKNOWN
+	u8	queue_cfg_info;
+	#define QUEUE_QCFG_RESP_QUEUE_CFG_INFO_ASYM_CFG     0x1UL
+	u8	unused_0;
 	u8	valid;
 };
 
@@ -4938,6 +5061,7 @@ struct hwrm_vnic_cfg_input {
 	#define VNIC_CFG_REQ_ENABLES_DEFAULT_RX_RING_ID       0x20UL
 	#define VNIC_CFG_REQ_ENABLES_DEFAULT_CMPL_RING_ID     0x40UL
 	#define VNIC_CFG_REQ_ENABLES_QUEUE_ID                 0x80UL
+	#define VNIC_CFG_REQ_ENABLES_RX_CSUM_V2_MODE          0x100UL
 	__le16	vnic_id;
 	__le16	dflt_ring_grp;
 	__le16	rss_rule;
@@ -4947,7 +5071,12 @@ struct hwrm_vnic_cfg_input {
 	__le16	default_rx_ring_id;
 	__le16	default_cmpl_ring_id;
 	__le16	queue_id;
-	u8	unused0[6];
+	u8	rx_csum_v2_mode;
+	#define VNIC_CFG_REQ_RX_CSUM_V2_MODE_DEFAULT 0x0UL
+	#define VNIC_CFG_REQ_RX_CSUM_V2_MODE_ALL_OK  0x1UL
+	#define VNIC_CFG_REQ_RX_CSUM_V2_MODE_MAX     0x2UL
+	#define VNIC_CFG_REQ_RX_CSUM_V2_MODE_LAST   VNIC_CFG_REQ_RX_CSUM_V2_MODE_MAX
+	u8	unused0[5];
 };
 
 /* hwrm_vnic_cfg_output (size:128b/16B) */
@@ -4989,6 +5118,7 @@ struct hwrm_vnic_qcaps_output {
 	#define VNIC_QCAPS_RESP_FLAGS_ROCE_MIRRORING_CAPABLE_VNIC_CAP     0x40UL
 	#define VNIC_QCAPS_RESP_FLAGS_OUTERMOST_RSS_CAP                   0x80UL
 	#define VNIC_QCAPS_RESP_FLAGS_COS_ASSIGNMENT_CAP                  0x100UL
+	#define VNIC_QCAPS_RESP_FLAGS_RX_CMPL_V2_CAP                      0x200UL
 	__le16	max_aggs_supported;
 	u8	unused_1[5];
 	u8	valid;
@@ -5155,15 +5285,18 @@ struct hwrm_vnic_plcmodes_cfg_input {
 	#define VNIC_PLCMODES_CFG_REQ_FLAGS_HDS_IPV6              0x8UL
 	#define VNIC_PLCMODES_CFG_REQ_FLAGS_HDS_FCOE              0x10UL
 	#define VNIC_PLCMODES_CFG_REQ_FLAGS_HDS_ROCE              0x20UL
+	#define VNIC_PLCMODES_CFG_REQ_FLAGS_VIRTIO_PLACEMENT      0x40UL
 	__le32	enables;
 	#define VNIC_PLCMODES_CFG_REQ_ENABLES_JUMBO_THRESH_VALID      0x1UL
 	#define VNIC_PLCMODES_CFG_REQ_ENABLES_HDS_OFFSET_VALID        0x2UL
 	#define VNIC_PLCMODES_CFG_REQ_ENABLES_HDS_THRESHOLD_VALID     0x4UL
+	#define VNIC_PLCMODES_CFG_REQ_ENABLES_MAX_BDS_VALID           0x8UL
 	__le32	vnic_id;
 	__le16	jumbo_thresh;
 	__le16	hds_offset;
 	__le16	hds_threshold;
-	u8	unused_0[6];
+	__le16	max_bds;
+	u8	unused_0[4];
 };
 
 /* hwrm_vnic_plcmodes_cfg_output (size:128b/16B) */
@@ -5231,6 +5364,7 @@ struct hwrm_ring_alloc_input {
 	#define RING_ALLOC_REQ_ENABLES_RX_RING_ID_VALID      0x40UL
 	#define RING_ALLOC_REQ_ENABLES_NQ_RING_ID_VALID      0x80UL
 	#define RING_ALLOC_REQ_ENABLES_RX_BUF_SIZE_VALID     0x100UL
+	#define RING_ALLOC_REQ_ENABLES_SCHQ_ID               0x200UL
 	u8	ring_type;
 	#define RING_ALLOC_REQ_RING_TYPE_L2_CMPL   0x0UL
 	#define RING_ALLOC_REQ_RING_TYPE_TX        0x1UL
@@ -5246,7 +5380,7 @@ struct hwrm_ring_alloc_input {
 	__le32	fbo;
 	u8	page_size;
 	u8	page_tbl_depth;
-	u8	unused_1[2];
+	__le16	schq_id;
 	__le32	length;
 	__le16	logical_id;
 	__le16	cmpl_ring_id;
@@ -5344,11 +5478,12 @@ struct hwrm_ring_reset_input {
 	__le16	target_id;
 	__le64	resp_addr;
 	u8	ring_type;
-	#define RING_RESET_REQ_RING_TYPE_L2_CMPL   0x0UL
-	#define RING_RESET_REQ_RING_TYPE_TX        0x1UL
-	#define RING_RESET_REQ_RING_TYPE_RX        0x2UL
-	#define RING_RESET_REQ_RING_TYPE_ROCE_CMPL 0x3UL
-	#define RING_RESET_REQ_RING_TYPE_LAST     RING_RESET_REQ_RING_TYPE_ROCE_CMPL
+	#define RING_RESET_REQ_RING_TYPE_L2_CMPL     0x0UL
+	#define RING_RESET_REQ_RING_TYPE_TX          0x1UL
+	#define RING_RESET_REQ_RING_TYPE_RX          0x2UL
+	#define RING_RESET_REQ_RING_TYPE_ROCE_CMPL   0x3UL
+	#define RING_RESET_REQ_RING_TYPE_RX_RING_GRP 0x6UL
+	#define RING_RESET_REQ_RING_TYPE_LAST       RING_RESET_REQ_RING_TYPE_RX_RING_GRP
 	u8	unused_0;
 	__le16	ring_id;
 	u8	unused_1[4];
@@ -5529,6 +5664,7 @@ struct hwrm_ring_grp_free_output {
 	u8	unused_0[7];
 	u8	valid;
 };
+
 #define DEFAULT_FLOW_ID 0xFFFFFFFFUL
 #define ROCEV1_FLOW_ID 0xFFFFFFFEUL
 #define ROCEV2_FLOW_ID 0xFFFFFFFDUL
@@ -6816,15 +6952,15 @@ struct ctx_hw_stats {
 	__le64	rx_mcast_pkts;
 	__le64	rx_bcast_pkts;
 	__le64	rx_discard_pkts;
-	__le64	rx_drop_pkts;
+	__le64	rx_error_pkts;
 	__le64	rx_ucast_bytes;
 	__le64	rx_mcast_bytes;
 	__le64	rx_bcast_bytes;
 	__le64	tx_ucast_pkts;
 	__le64	tx_mcast_pkts;
 	__le64	tx_bcast_pkts;
+	__le64	tx_error_pkts;
 	__le64	tx_discard_pkts;
-	__le64	tx_drop_pkts;
 	__le64	tx_ucast_bytes;
 	__le64	tx_mcast_bytes;
 	__le64	tx_bcast_bytes;
@@ -6840,15 +6976,15 @@ struct ctx_hw_stats_ext {
 	__le64	rx_mcast_pkts;
 	__le64	rx_bcast_pkts;
 	__le64	rx_discard_pkts;
-	__le64	rx_drop_pkts;
+	__le64	rx_error_pkts;
 	__le64	rx_ucast_bytes;
 	__le64	rx_mcast_bytes;
 	__le64	rx_bcast_bytes;
 	__le64	tx_ucast_pkts;
 	__le64	tx_mcast_pkts;
 	__le64	tx_bcast_pkts;
+	__le64	tx_error_pkts;
 	__le64	tx_discard_pkts;
-	__le64	tx_drop_pkts;
 	__le64	tx_ucast_bytes;
 	__le64	tx_mcast_bytes;
 	__le64	tx_bcast_bytes;
@@ -6915,7 +7051,9 @@ struct hwrm_stat_ctx_query_input {
 	__le16	target_id;
 	__le64	resp_addr;
 	__le32	stat_ctx_id;
-	u8	unused_0[4];
+	u8	flags;
+	#define STAT_CTX_QUERY_REQ_FLAGS_COUNTER_MASK     0x1UL
+	u8	unused_0[3];
 };
 
 /* hwrm_stat_ctx_query_output (size:1408b/176B) */
@@ -6948,6 +7086,50 @@ struct hwrm_stat_ctx_query_output {
 	u8	valid;
 };
 
+/* hwrm_stat_ext_ctx_query_input (size:192b/24B) */
+struct hwrm_stat_ext_ctx_query_input {
+	__le16	req_type;
+	__le16	cmpl_ring;
+	__le16	seq_id;
+	__le16	target_id;
+	__le64	resp_addr;
+	__le32	stat_ctx_id;
+	u8	flags;
+	#define STAT_EXT_CTX_QUERY_REQ_FLAGS_COUNTER_MASK     0x1UL
+	u8	unused_0[3];
+};
+
+/* hwrm_stat_ext_ctx_query_output (size:1472b/184B) */
+struct hwrm_stat_ext_ctx_query_output {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
+	__le64	rx_ucast_pkts;
+	__le64	rx_mcast_pkts;
+	__le64	rx_bcast_pkts;
+	__le64	rx_discard_pkts;
+	__le64	rx_error_pkts;
+	__le64	rx_ucast_bytes;
+	__le64	rx_mcast_bytes;
+	__le64	rx_bcast_bytes;
+	__le64	tx_ucast_pkts;
+	__le64	tx_mcast_pkts;
+	__le64	tx_bcast_pkts;
+	__le64	tx_error_pkts;
+	__le64	tx_discard_pkts;
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
 /* hwrm_stat_ctx_clr_stats_input (size:192b/24B) */
 struct hwrm_stat_ctx_clr_stats_input {
 	__le16	req_type;
@@ -7497,6 +7679,29 @@ struct hwrm_wol_reason_qcfg_output {
 	u8	valid;
 };
 
+/* hwrm_dbg_read_direct_input (size:256b/32B) */
+struct hwrm_dbg_read_direct_input {
+	__le16	req_type;
+	__le16	cmpl_ring;
+	__le16	seq_id;
+	__le16	target_id;
+	__le64	resp_addr;
+	__le64	host_dest_addr;
+	__le32	read_addr;
+	__le32	read_len32;
+};
+
+/* hwrm_dbg_read_direct_output (size:128b/16B) */
+struct hwrm_dbg_read_direct_output {
+	__le16	error_code;
+	__le16	req_type;
+	__le16	seq_id;
+	__le16	resp_len;
+	__le32	crc32;
+	u8	unused_0[3];
+	u8	valid;
+};
+
 /* coredump_segment_record (size:128b/16B) */
 struct coredump_segment_record {
 	__le16	component_id;
@@ -7507,7 +7712,8 @@ struct coredump_segment_record {
 	u8	seg_flags;
 	u8	compress_flags;
 	#define SFLAG_COMPRESSED_ZLIB     0x1UL
-	u8	unused_0[6];
+	u8	unused_0[2];
+	__le32	segment_len;
 };
 
 /* hwrm_dbg_coredump_list_input (size:256b/32B) */
@@ -7620,7 +7826,8 @@ struct hwrm_dbg_ring_info_get_input {
 	#define DBG_RING_INFO_GET_REQ_RING_TYPE_L2_CMPL 0x0UL
 	#define DBG_RING_INFO_GET_REQ_RING_TYPE_TX      0x1UL
 	#define DBG_RING_INFO_GET_REQ_RING_TYPE_RX      0x2UL
-	#define DBG_RING_INFO_GET_REQ_RING_TYPE_LAST   DBG_RING_INFO_GET_REQ_RING_TYPE_RX
+	#define DBG_RING_INFO_GET_REQ_RING_TYPE_NQ      0x3UL
+	#define DBG_RING_INFO_GET_REQ_RING_TYPE_LAST   DBG_RING_INFO_GET_REQ_RING_TYPE_NQ
 	u8	unused_0[3];
 	__le32	fw_ring_id;
 };
@@ -7633,7 +7840,8 @@ struct hwrm_dbg_ring_info_get_output {
 	__le16	resp_len;
 	__le32	producer_index;
 	__le32	consumer_index;
-	u8	unused_0[7];
+	__le32	cag_vector_ctrl;
+	u8	unused_0[3];
 	u8	valid;
 };
 
@@ -7922,6 +8130,7 @@ struct hwrm_nvm_install_update_input {
 	#define NVM_INSTALL_UPDATE_REQ_FLAGS_ERASE_UNUSED_SPACE     0x1UL
 	#define NVM_INSTALL_UPDATE_REQ_FLAGS_REMOVE_UNUSED_PKG      0x2UL
 	#define NVM_INSTALL_UPDATE_REQ_FLAGS_ALLOWED_TO_DEFRAG      0x4UL
+	#define NVM_INSTALL_UPDATE_REQ_FLAGS_VERIFY_ONLY            0x8UL
 	u8	unused_0[2];
 };
 
@@ -8101,7 +8310,14 @@ struct hwrm_selftest_qlist_output {
 	char	test5_name[32];
 	char	test6_name[32];
 	char	test7_name[32];
-	u8	unused_2[7];
+	u8	eyescope_target_BER_support;
+	#define SELFTEST_QLIST_RESP_EYESCOPE_TARGET_BER_SUPPORT_BER_1E8_SUPPORTED  0x0UL
+	#define SELFTEST_QLIST_RESP_EYESCOPE_TARGET_BER_SUPPORT_BER_1E9_SUPPORTED  0x1UL
+	#define SELFTEST_QLIST_RESP_EYESCOPE_TARGET_BER_SUPPORT_BER_1E10_SUPPORTED 0x2UL
+	#define SELFTEST_QLIST_RESP_EYESCOPE_TARGET_BER_SUPPORT_BER_1E11_SUPPORTED 0x3UL
+	#define SELFTEST_QLIST_RESP_EYESCOPE_TARGET_BER_SUPPORT_BER_1E12_SUPPORTED 0x4UL
+	#define SELFTEST_QLIST_RESP_EYESCOPE_TARGET_BER_SUPPORT_LAST              SELFTEST_QLIST_RESP_EYESCOPE_TARGET_BER_SUPPORT_BER_1E12_SUPPORTED
+	u8	unused_2[6];
 	u8	valid;
 };
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
index 392e32c..cc2ee4d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
@@ -1029,7 +1029,7 @@ static int bnxt_vf_set_link(struct bnxt *bp, struct bnxt_vf_info *vf)
 		rc = bnxt_hwrm_exec_fwd_resp(
 			bp, vf, sizeof(struct hwrm_port_phy_qcfg_input));
 	} else {
-		struct hwrm_port_phy_qcfg_output phy_qcfg_resp;
+		struct hwrm_port_phy_qcfg_output_compat phy_qcfg_resp = {0};
 		struct hwrm_port_phy_qcfg_input *phy_qcfg_req;
 
 		phy_qcfg_req =
-- 
1.8.3.1

