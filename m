Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A64C2E15D7
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbgLWCyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:54:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:45428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729212AbgLWCVH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:21:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71F3C22525;
        Wed, 23 Dec 2020 02:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690050;
        bh=OOvL48awBBRzLmQEbK7Ney9ldGZAun+UOni2ZChnpxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hV6XjnIpEL4Ynhy6s9qhNMDU5/u1e4DT8B+M0IIhuS7iQqn77fvpHJ8Hna50JKyZc
         cUX05FxKJDfySGxv1jNzn5+e5lDuvPFHO7woqnktGp7RfDFaSuzgVea6AjA9yOUmDp
         seJOIhzhJ1ZoUOLwKQTdtXilgpwf30n91XJ9mcc1EVZRFzC59sdE4Pba7idWP8Hv+u
         XGPvQFE78P1+iCriiikJB2fO/be9d6Tq7SZsHVODEHYOxvZvMt7RCOqYQbhtuUGy60
         bC5jBOI7q1gzGpxl6J6Dj8rrxDsqwOGd82G3xx5n90qu9HUYrCbX7gBQu9+uhGCJNu
         aux+FyaAtC/5A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 121/130] mac80211: use bitfield helpers for BA session action frames
Date:   Tue, 22 Dec 2020 21:18:04 -0500
Message-Id: <20201223021813.2791612-121-sashal@kernel.org>
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
index 4d1c335e06e57..93285f9a2bbd5 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -250,10 +250,10 @@ static void ieee80211_send_addba_resp(struct sta_info *sta, u8 *da, u16 tid,
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
index b11883d268759..ea6bc02c900bf 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -95,10 +95,10 @@ static void ieee80211_send_addba_request(struct ieee80211_sub_if_data *sdata,
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
 
@@ -921,8 +921,8 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
 
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

