Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C672C2E15DD
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728564AbgLWCyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:54:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:49598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729205AbgLWCVF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:21:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21C0022573;
        Wed, 23 Dec 2020 02:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690049;
        bh=Gu4frbtfGq85P2ApmCxRMWO2NZ1UrtLluCUI0/A3CgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RGXiUU+IXXh7ibaO0bRH7fQ3xjE9wJMt6UjMKRRjpxx+JXH3vqJCFggqJ0vJl7WeQ
         +V+mxs7K54FKQ4QgAlvux6hpYh2FbOQvtNCd4qbi15rMqd3/vOXF0N6Y3gyMdR7ff/
         EHrzAgVIv44i+eSyTKAZWCvXizX8qW5QgJve4wgIt1NOni6QQXsGGjDqcWkdskMSWf
         W6D2VbhL7D6L2WmnlEF3+mgV+Dtyzm5szyLQ3sjonRdv5PRD6BdP9dDRiRF5wmhYkw
         LxW45/sS+gYabQO1v1YYFveV10aiQtCPsn+savYXl7cfMFmaXN/1QMKMMjbL4PxiNX
         6Ey/n0vtdjYFQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 120/130] mac80211: support Rx timestamp calculation for all preamble types
Date:   Tue, 22 Dec 2020 21:18:03 -0500
Message-Id: <20201223021813.2791612-120-sashal@kernel.org>
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

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit da3882331a55ba8c8eda0cfc077ad3b88c257e22 ]

Add support for calculating the Rx timestamp for HE frames.
Since now all frame types are supported, allow setting the Rx
timestamp regardless of the frame type.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20201206145305.4786559af475.Ia54486bb0a12e5351f9d5c60ef6fcda7c9e7141c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ieee80211_i.h |  9 ++----
 net/mac80211/util.c        | 66 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 67 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 05406e9c05b32..7ad21d041f063 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1561,13 +1561,8 @@ ieee80211_have_rx_timestamp(struct ieee80211_rx_status *status)
 {
 	WARN_ON_ONCE(status->flag & RX_FLAG_MACTIME_START &&
 		     status->flag & RX_FLAG_MACTIME_END);
-	if (status->flag & (RX_FLAG_MACTIME_START | RX_FLAG_MACTIME_END))
-		return true;
-	/* can't handle non-legacy preamble yet */
-	if (status->flag & RX_FLAG_MACTIME_PLCP_START &&
-	    status->encoding == RX_ENC_LEGACY)
-		return true;
-	return false;
+	return !!(status->flag & (RX_FLAG_MACTIME_START | RX_FLAG_MACTIME_END |
+				  RX_FLAG_MACTIME_PLCP_START));
 }
 
 void ieee80211_vif_inc_num_mcast(struct ieee80211_sub_if_data *sdata);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index decd46b383938..9f05336509210 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -3238,6 +3238,7 @@ u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
 	u64 ts = status->mactime;
 	struct rate_info ri;
 	u16 rate;
+	u8 n_ltf;
 
 	if (WARN_ON(!ieee80211_have_rx_timestamp(status)))
 		return 0;
@@ -3248,11 +3249,58 @@ u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
 
 	/* Fill cfg80211 rate info */
 	switch (status->encoding) {
+	case RX_ENC_HE:
+		ri.flags |= RATE_INFO_FLAGS_HE_MCS;
+		ri.mcs = status->rate_idx;
+		ri.nss = status->nss;
+		ri.he_ru_alloc = status->he_ru;
+		if (status->enc_flags & RX_ENC_FLAG_SHORT_GI)
+			ri.flags |= RATE_INFO_FLAGS_SHORT_GI;
+
+		/*
+		 * See P802.11ax_D6.0, section 27.3.4 for
+		 * VHT PPDU format.
+		 */
+		if (status->flag & RX_FLAG_MACTIME_PLCP_START) {
+			mpdu_offset += 2;
+			ts += 36;
+
+			/*
+			 * TODO:
+			 * For HE MU PPDU, add the HE-SIG-B.
+			 * For HE ER PPDU, add 8us for the HE-SIG-A.
+			 * For HE TB PPDU, add 4us for the HE-STF.
+			 * Add the HE-LTF durations - variable.
+			 */
+		}
+
+		break;
 	case RX_ENC_HT:
 		ri.mcs = status->rate_idx;
 		ri.flags |= RATE_INFO_FLAGS_MCS;
 		if (status->enc_flags & RX_ENC_FLAG_SHORT_GI)
 			ri.flags |= RATE_INFO_FLAGS_SHORT_GI;
+
+		/*
+		 * See P802.11REVmd_D3.0, section 19.3.2 for
+		 * HT PPDU format.
+		 */
+		if (status->flag & RX_FLAG_MACTIME_PLCP_START) {
+			mpdu_offset += 2;
+			if (status->enc_flags & RX_ENC_FLAG_HT_GF)
+				ts += 24;
+			else
+				ts += 32;
+
+			/*
+			 * Add Data HT-LTFs per streams
+			 * TODO: add Extension HT-LTFs, 4us per LTF
+			 */
+			n_ltf = ((ri.mcs >> 3) & 3) + 1;
+			n_ltf = n_ltf == 3 ? 4 : n_ltf;
+			ts += n_ltf * 4;
+		}
+
 		break;
 	case RX_ENC_VHT:
 		ri.flags |= RATE_INFO_FLAGS_VHT_MCS;
@@ -3260,6 +3308,23 @@ u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
 		ri.nss = status->nss;
 		if (status->enc_flags & RX_ENC_FLAG_SHORT_GI)
 			ri.flags |= RATE_INFO_FLAGS_SHORT_GI;
+
+		/*
+		 * See P802.11REVmd_D3.0, section 21.3.2 for
+		 * VHT PPDU format.
+		 */
+		if (status->flag & RX_FLAG_MACTIME_PLCP_START) {
+			mpdu_offset += 2;
+			ts += 36;
+
+			/*
+			 * Add VHT-LTFs per streams
+			 */
+			n_ltf = (ri.nss != 1) && (ri.nss % 2) ?
+				ri.nss + 1 : ri.nss;
+			ts += 4 * n_ltf;
+		}
+
 		break;
 	default:
 		WARN_ON(1);
@@ -3283,7 +3348,6 @@ u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
 		ri.legacy = DIV_ROUND_UP(bitrate, (1 << shift));
 
 		if (status->flag & RX_FLAG_MACTIME_PLCP_START) {
-			/* TODO: handle HT/VHT preambles */
 			if (status->band == NL80211_BAND_5GHZ) {
 				ts += 20 << shift;
 				mpdu_offset += 2;
-- 
2.27.0

