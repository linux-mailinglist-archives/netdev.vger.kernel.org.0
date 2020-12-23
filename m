Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8899E2E14CA
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730092AbgLWCnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:43:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:50890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729811AbgLWCXA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:23:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65FDE23137;
        Wed, 23 Dec 2020 02:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690164;
        bh=1IopgCTr5CLfw4tXu/+atusloBng3yRw1mvj7xroQs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OIMWCY8egYpgwaJ1Esmqpk9AgbkRyiV7r8pQkNEtY6CsJHe97+6T1l33An8VxeiHc
         8KJKdvziTG1d2M/12u1ARP4wVS+cpgyYM+XMqQs6MpbSd1KBwZcjn1q/hH7+82qMcG
         iP5W36zrnGqbApfu96m+W6ci8hhcumO4p7Iuduaw7eltCxmprAqOtOIN6OZG3nYU8t
         Xgw/Iwaa6qnYBquF6HnkGcv8lXn6sVtEyDxdxdiEtRMGydzn5lzBOu2tAX2Y0vTwoq
         Sy2TzkhQNPvwI3kBSVyED/gu3TsvqbZXplTEKb4YePFL2y1iRoOOSb06b6egEaHI3E
         uYPdrHYgPXl2Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 81/87] mac80211: use bitfield helpers for BA session action frames
Date:   Tue, 22 Dec 2020 21:20:57 -0500
Message-Id: <20201223022103.2792705-81-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit db8ebd06ccb87b7bea8e50f3d4ba5dc0142093b8 ]

Use the appropriate bitfield helpers for encoding and decoding
the capability field in the BA session action frames instead of
open-coding the shifts/masks.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20201206145305.0c46e5097cc0.I06e75706770c40b9ba1cabd1f8a78ab7a05c5b73@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/agg-rx.c |  8 ++++----
 net/mac80211/agg-tx.c | 12 ++++++------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 6a4f154c99f6b..dd2e421bda6e5 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -216,10 +216,10 @@ static void ieee80211_send_addba_resp(struct ieee80211_sub_if_data *sdata, u8 *d
 	mgmt->u.action.u.addba_resp.action_code = WLAN_ACTION_ADDBA_RESP;
 	mgmt->u.action.u.addba_resp.dialog_token = dialog_token;
 
-	capab = (u16)(amsdu << 0);	/* bit 0 A-MSDU support */
-	capab |= (u16)(policy << 1);	/* bit 1 aggregation policy */
-	capab |= (u16)(tid << 2); 	/* bit 5:2 TID number */
-	capab |= (u16)(buf_size << 6);	/* bit 15:6 max size of aggregation */
+	capab = u16_encode_bits(amsdu, IEEE80211_ADDBA_PARAM_AMSDU_MASK);
+	capab |= u16_encode_bits(policy, IEEE80211_ADDBA_PARAM_POLICY_MASK);
+	capab |= u16_encode_bits(tid, IEEE80211_ADDBA_PARAM_TID_MASK);
+	capab |= u16_encode_bits(buf_size, IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK);
 
 	mgmt->u.action.u.addba_resp.capab = cpu_to_le16(capab);
 	mgmt->u.action.u.addba_resp.timeout = cpu_to_le16(timeout);
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 54821fb1a960d..4cb7695a208ac 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -98,10 +98,10 @@ static void ieee80211_send_addba_request(struct ieee80211_sub_if_data *sdata,
 	mgmt->u.action.u.addba_req.action_code = WLAN_ACTION_ADDBA_REQ;
 
 	mgmt->u.action.u.addba_req.dialog_token = dialog_token;
-	capab = (u16)(1 << 0);		/* bit 0 A-MSDU support */
-	capab |= (u16)(1 << 1);		/* bit 1 aggregation policy */
-	capab |= (u16)(tid << 2); 	/* bit 5:2 TID number */
-	capab |= (u16)(agg_size << 6);	/* bit 15:6 max size of aggergation */
+	capab = IEEE80211_ADDBA_PARAM_AMSDU_MASK;
+	capab |= IEEE80211_ADDBA_PARAM_POLICY_MASK;
+	capab |= u16_encode_bits(tid, IEEE80211_ADDBA_PARAM_TID_MASK);
+	capab |= u16_encode_bits(agg_size, IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK);
 
 	mgmt->u.action.u.addba_req.capab = cpu_to_le16(capab);
 
@@ -924,8 +924,8 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
 
 	capab = le16_to_cpu(mgmt->u.action.u.addba_resp.capab);
 	amsdu = capab & IEEE80211_ADDBA_PARAM_AMSDU_MASK;
-	tid = (capab & IEEE80211_ADDBA_PARAM_TID_MASK) >> 2;
-	buf_size = (capab & IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK) >> 6;
+	tid = u16_get_bits(capab, IEEE80211_ADDBA_PARAM_TID_MASK);
+	buf_size = u16_get_bits(capab, IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK);
 	buf_size = min(buf_size, local->hw.max_tx_aggregation_subframes);
 
 	txq = sta->sta.txq[tid];
-- 
2.27.0

