Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20F0AF4ADD
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391518AbfKHMLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 07:11:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:52034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733032AbfKHLjF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:39:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B28A20869;
        Fri,  8 Nov 2019 11:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213143;
        bh=HCqGy/wd7vaxpgsJLDIJABoxOA2NNLLVQDuPO1xglAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NHfNmBMERPfPvJPsgXvYEo6eqff2hQ/jFfhDzj9vEUjcDSiWIxKBw0j7S5b0HFWiq
         awcbS04IknrbkI7R9WREal2LjkWVWrO+xvW0Xa0BkqCnkcBYJVvYUCm5OAhLTvyZEV
         vaCybZC1WFvSXuwBull0VI0phDP1WHVd3kT/Vdsg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 056/205] iwlwifi: drop packets with bad status in CD
Date:   Fri,  8 Nov 2019 06:35:23 -0500
Message-Id: <20191108113752.12502-56-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

[ Upstream commit 7891965d74bc48fb42b5068033192f97c9aa2090 ]

We need to drop packets with errors (such as replay,
MIC, ICV, conversion, duplicate and so on).

Drop invalid packets, put the status bits in the metadata and
move the enum definition to the correct place (FW API header).

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/fw/api/rx.h    | 63 +++++++++++++++++++
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |  1 +
 .../wireless/intel/iwlwifi/pcie/internal.h    | 60 ------------------
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c  |  8 ++-
 4 files changed, 70 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h b/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
index 2f599353c8856..2ba1401e5c0d5 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
@@ -574,6 +574,69 @@ struct iwl_rx_mpdu_desc {
 
 #define IWL_RX_DESC_SIZE_V1 offsetofend(struct iwl_rx_mpdu_desc, v1)
 
+#define IWL_CD_STTS_OPTIMIZED_POS	0
+#define IWL_CD_STTS_OPTIMIZED_MSK	0x01
+#define IWL_CD_STTS_TRANSFER_STATUS_POS	1
+#define IWL_CD_STTS_TRANSFER_STATUS_MSK	0x0E
+#define IWL_CD_STTS_WIFI_STATUS_POS	4
+#define IWL_CD_STTS_WIFI_STATUS_MSK	0xF0
+
+/**
+ * enum iwl_completion_desc_transfer_status -  transfer status (bits 1-3)
+ * @IWL_CD_STTS_UNUSED: unused
+ * @IWL_CD_STTS_UNUSED_2: unused
+ * @IWL_CD_STTS_END_TRANSFER: successful transfer complete.
+ *	In sniffer mode, when split is used, set in last CD completion. (RX)
+ * @IWL_CD_STTS_OVERFLOW: In sniffer mode, when using split - used for
+ *	all CD completion. (RX)
+ * @IWL_CD_STTS_ABORTED: CR abort / close flow. (RX)
+ * @IWL_CD_STTS_ERROR: general error (RX)
+ */
+enum iwl_completion_desc_transfer_status {
+	IWL_CD_STTS_UNUSED,
+	IWL_CD_STTS_UNUSED_2,
+	IWL_CD_STTS_END_TRANSFER,
+	IWL_CD_STTS_OVERFLOW,
+	IWL_CD_STTS_ABORTED,
+	IWL_CD_STTS_ERROR,
+};
+
+/**
+ * enum iwl_completion_desc_wifi_status - wifi status (bits 4-7)
+ * @IWL_CD_STTS_VALID: the packet is valid (RX)
+ * @IWL_CD_STTS_FCS_ERR: frame check sequence error (RX)
+ * @IWL_CD_STTS_SEC_KEY_ERR: error handling the security key of rx (RX)
+ * @IWL_CD_STTS_DECRYPTION_ERR: error decrypting the frame (RX)
+ * @IWL_CD_STTS_DUP: duplicate packet (RX)
+ * @IWL_CD_STTS_ICV_MIC_ERR: MIC error (RX)
+ * @IWL_CD_STTS_INTERNAL_SNAP_ERR: problems removing the snap (RX)
+ * @IWL_CD_STTS_SEC_PORT_FAIL: security port fail (RX)
+ * @IWL_CD_STTS_BA_OLD_SN: block ack received old SN (RX)
+ * @IWL_CD_STTS_QOS_NULL: QoS null packet (RX)
+ * @IWL_CD_STTS_MAC_HDR_ERR: MAC header conversion error (RX)
+ * @IWL_CD_STTS_MAX_RETRANS: reached max number of retransmissions (TX)
+ * @IWL_CD_STTS_EX_LIFETIME: exceeded lifetime (TX)
+ * @IWL_CD_STTS_NOT_USED: completed but not used (RX)
+ * @IWL_CD_STTS_REPLAY_ERR: pn check failed, replay error (RX)
+ */
+enum iwl_completion_desc_wifi_status {
+	IWL_CD_STTS_VALID,
+	IWL_CD_STTS_FCS_ERR,
+	IWL_CD_STTS_SEC_KEY_ERR,
+	IWL_CD_STTS_DECRYPTION_ERR,
+	IWL_CD_STTS_DUP,
+	IWL_CD_STTS_ICV_MIC_ERR,
+	IWL_CD_STTS_INTERNAL_SNAP_ERR,
+	IWL_CD_STTS_SEC_PORT_FAIL,
+	IWL_CD_STTS_BA_OLD_SN,
+	IWL_CD_STTS_QOS_NULL,
+	IWL_CD_STTS_MAC_HDR_ERR,
+	IWL_CD_STTS_MAX_RETRANS,
+	IWL_CD_STTS_EX_LIFETIME,
+	IWL_CD_STTS_NOT_USED,
+	IWL_CD_STTS_REPLAY_ERR,
+};
+
 struct iwl_frame_release {
 	u8 baid;
 	u8 reserved;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 279dd7b7a3fb9..0b8cf7f3af933 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -269,6 +269,7 @@ struct iwl_rx_cmd_buffer {
 	bool _page_stolen;
 	u32 _rx_page_order;
 	unsigned int truesize;
+	u8 status;
 };
 
 static inline void *rxb_addr(struct iwl_rx_cmd_buffer *r)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 00f9566bcc213..e9d67ba3e56dd 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -102,66 +102,6 @@ struct isr_statistics {
 	u32 unhandled;
 };
 
-#define IWL_CD_STTS_OPTIMIZED_POS	0
-#define IWL_CD_STTS_OPTIMIZED_MSK	0x01
-#define IWL_CD_STTS_TRANSFER_STATUS_POS	1
-#define IWL_CD_STTS_TRANSFER_STATUS_MSK	0x0E
-#define IWL_CD_STTS_WIFI_STATUS_POS	4
-#define IWL_CD_STTS_WIFI_STATUS_MSK	0xF0
-
-/**
- * enum iwl_completion_desc_transfer_status -  transfer status (bits 1-3)
- * @IWL_CD_STTS_END_TRANSFER: successful transfer complete.
- *	In sniffer mode, when split is used, set in last CD completion. (RX)
- * @IWL_CD_STTS_OVERFLOW: In sniffer mode, when using split - used for
- *	all CD completion. (RX)
- * @IWL_CD_STTS_ABORTED: CR abort / close flow. (RX)
- */
-enum iwl_completion_desc_transfer_status {
-	IWL_CD_STTS_UNUSED,
-	IWL_CD_STTS_UNUSED_2,
-	IWL_CD_STTS_END_TRANSFER,
-	IWL_CD_STTS_OVERFLOW,
-	IWL_CD_STTS_ABORTED,
-	IWL_CD_STTS_ERROR,
-};
-
-/**
- * enum iwl_completion_desc_wifi_status - wifi status (bits 4-7)
- * @IWL_CD_STTS_VALID: the packet is valid (RX)
- * @IWL_CD_STTS_FCS_ERR: frame check sequence error (RX)
- * @IWL_CD_STTS_SEC_KEY_ERR: error handling the security key of rx (RX)
- * @IWL_CD_STTS_DECRYPTION_ERR: error decrypting the frame (RX)
- * @IWL_CD_STTS_DUP: duplicate packet (RX)
- * @IWL_CD_STTS_ICV_MIC_ERR: MIC error (RX)
- * @IWL_CD_STTS_INTERNAL_SNAP_ERR: problems removing the snap (RX)
- * @IWL_CD_STTS_SEC_PORT_FAIL: security port fail (RX)
- * @IWL_CD_STTS_BA_OLD_SN: block ack received old SN (RX)
- * @IWL_CD_STTS_QOS_NULL: QoS null packet (RX)
- * @IWL_CD_STTS_MAC_HDR_ERR: MAC header conversion error (RX)
- * @IWL_CD_STTS_MAX_RETRANS: reached max number of retransmissions (TX)
- * @IWL_CD_STTS_EX_LIFETIME: exceeded lifetime (TX)
- * @IWL_CD_STTS_NOT_USED: completed but not used (RX)
- * @IWL_CD_STTS_REPLAY_ERR: pn check failed, replay error (RX)
- */
-enum iwl_completion_desc_wifi_status {
-	IWL_CD_STTS_VALID,
-	IWL_CD_STTS_FCS_ERR,
-	IWL_CD_STTS_SEC_KEY_ERR,
-	IWL_CD_STTS_DECRYPTION_ERR,
-	IWL_CD_STTS_DUP,
-	IWL_CD_STTS_ICV_MIC_ERR,
-	IWL_CD_STTS_INTERNAL_SNAP_ERR,
-	IWL_CD_STTS_SEC_PORT_FAIL,
-	IWL_CD_STTS_BA_OLD_SN,
-	IWL_CD_STTS_QOS_NULL,
-	IWL_CD_STTS_MAC_HDR_ERR,
-	IWL_CD_STTS_MAX_RETRANS,
-	IWL_CD_STTS_EX_LIFETIME,
-	IWL_CD_STTS_NOT_USED,
-	IWL_CD_STTS_REPLAY_ERR,
-};
-
 #define IWL_RX_TD_TYPE_MSK	0xff000000
 #define IWL_RX_TD_SIZE_MSK	0x00ffffff
 #define IWL_RX_TD_SIZE_2K	BIT(11)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 1d144985ea589..80a1a50f5da51 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1198,7 +1198,8 @@ static void iwl_pcie_rx_reuse_rbd(struct iwl_trans *trans,
 static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 				struct iwl_rxq *rxq,
 				struct iwl_rx_mem_buffer *rxb,
-				bool emergency)
+				bool emergency,
+				int i)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_txq *txq = trans_pcie->txq[trans_pcie->cmd_queue];
@@ -1224,6 +1225,9 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 			.truesize = max_len,
 		};
 
+		if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560)
+			rxcb.status = rxq->cd[i].status;
+
 		pkt = rxb_addr(&rxcb);
 
 		if (pkt->len_n_flags == cpu_to_le32(FH_RSCSR_FRAME_INVALID)) {
@@ -1430,7 +1434,7 @@ restart:
 			goto out;
 
 		IWL_DEBUG_RX(trans, "Q %d: HW = %d, SW = %d\n", rxq->id, r, i);
-		iwl_pcie_rx_handle_rb(trans, rxq, rxb, emergency);
+		iwl_pcie_rx_handle_rb(trans, rxq, rxb, emergency, i);
 
 		i = (i + 1) & (rxq->queue_size - 1);
 
-- 
2.20.1

