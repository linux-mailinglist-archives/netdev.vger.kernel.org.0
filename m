Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD722E154D
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729104AbgLWCUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:20:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729085AbgLWCUq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:20:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9962D225AB;
        Wed, 23 Dec 2020 02:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690031;
        bh=6OcuqB/AKMJ42QJzTYn3irBcM5mpOV53Vwxshp4TmQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LbrxNX/EDZjnlSgryBFun1ZqcMhyq89+YEAWHKCjMmQqmXD8omfSr2m6m7kbdDNBp
         lQNbIsgLnqODptsZlAs5EUVphkGjA0bkorf5UoFEShYUSA2h4mDa45oFf6vs0zYbmZ
         GmTJHz8blbz0cKWGUDdvTh+QAx+1ZpKfalmnhPhnRkI06Du6f4AYrZZOK9qgJXOtTo
         M0fklT4GUODcHLh/NuAZw3fh6vD6AwDjSy6cVowstMkyGnA6GoTVnk/7E+qXWbPW6D
         xdLHbUPgCD+JeVJUQ5RH2JUlZO/81oHyfBsNFCdsqq7safp/gldeK3LO8xP1o81l6R
         sJJ6yIC2/o5Kg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Haggai Abramovsky <haggai.abramovsky@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 107/130] iwlwifi: validate MPDU length against notification length
Date:   Tue, 22 Dec 2020 21:17:50 -0500
Message-Id: <20201223021813.2791612-107-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit efc0ec5afb6e1488b3bdc4bbf85533d79d7e5f9f ]

The MPDU contained in a notification shouldn't be larger than the
notification size itself is, validate this.

Reported-by: Haggai Abramovsky <haggai.abramovsky@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20201209231352.7c721ad37014.Id5746874ecfa208b60baa62691b2d9dc5dd4d89c@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c   | 10 ++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c   |  8 +++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c |  6 ++++++
 3 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
index 673d60784bfad..b930816ca5ca9 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
@@ -3,7 +3,7 @@
  *
  * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2015 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018, 2020 Intel Corporation
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portionhelp of the ieee80211 subsystem header files.
@@ -786,7 +786,7 @@ static void iwlagn_rx_reply_rx(struct iwl_priv *priv,
 	struct iwl_rx_phy_res *phy_res;
 	__le32 rx_pkt_status;
 	struct iwl_rx_mpdu_res_start *amsdu;
-	u32 len;
+	u32 len, pkt_len = iwl_rx_packet_len(pkt);
 	u32 ampdu_status;
 	u32 rate_n_flags;
 
@@ -798,6 +798,12 @@ static void iwlagn_rx_reply_rx(struct iwl_priv *priv,
 	amsdu = (struct iwl_rx_mpdu_res_start *)pkt->data;
 	header = (struct ieee80211_hdr *)(pkt->data + sizeof(*amsdu));
 	len = le16_to_cpu(amsdu->byte_count);
+
+	if (unlikely(len + sizeof(*amsdu) + sizeof(__le32) > pkt_len)) {
+		IWL_DEBUG_DROP(priv, "FW lied about packet len\n");
+		return;
+	}
+
 	rx_pkt_status = *(__le32 *)(pkt->data + sizeof(*amsdu) + len);
 	ampdu_status = iwlagn_translate_rx_status(priv,
 						  le32_to_cpu(rx_pkt_status));
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 77b8def26edb2..47d38df78439b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -349,7 +349,7 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 	struct iwl_rx_mpdu_res_start *rx_res;
 	struct ieee80211_sta *sta = NULL;
 	struct sk_buff *skb;
-	u32 len;
+	u32 len, pkt_len = iwl_rx_packet_payload_len(pkt);
 	u32 rate_n_flags;
 	u32 rx_pkt_status;
 	u8 crypt_len = 0;
@@ -358,6 +358,12 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 	rx_res = (struct iwl_rx_mpdu_res_start *)pkt->data;
 	hdr = (struct ieee80211_hdr *)(pkt->data + sizeof(*rx_res));
 	len = le16_to_cpu(rx_res->byte_count);
+
+	if (unlikely(len + sizeof(*rx_res) + sizeof(__le32) > pkt_len)) {
+		IWL_DEBUG_DROP(mvm, "FW lied about packet len\n");
+		return;
+	}
+
 	rx_pkt_status = get_unaligned_le32((__le32 *)
 		(pkt->data + sizeof(*rx_res) + len));
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index a6e2a30eb3109..d0bfcee59a3a7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -1553,6 +1553,7 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 	struct iwl_rx_mpdu_desc *desc = (void *)pkt->data;
 	struct ieee80211_hdr *hdr;
 	u32 len = le16_to_cpu(desc->mpdu_len);
+	u32 pkt_len = iwl_rx_packet_payload_len(pkt);
 	u32 rate_n_flags, gp2_on_air_rise;
 	u16 phy_info = le16_to_cpu(desc->phy_info);
 	struct ieee80211_sta *sta = NULL;
@@ -1599,6 +1600,11 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 			le32_get_bits(phy_data.d1,
 				      IWL_RX_PHY_DATA1_INFO_TYPE_MASK);
 
+	if (len + desc_size > pkt_len) {
+		IWL_DEBUG_DROP(mvm, "FW lied about packet len\n");
+		return;
+	}
+
 	hdr = (void *)(pkt->data + desc_size);
 	/* Dont use dev_alloc_skb(), we'll have enough headroom once
 	 * ieee80211_hdr pulled.
-- 
2.27.0

