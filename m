Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF3A2E138D
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729843AbgLWCbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:31:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:55386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730502AbgLWCZa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:25:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6152225AC;
        Wed, 23 Dec 2020 02:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690309;
        bh=DJnJ6L7zvbWQTi9Wp66yvgBbhZKxZXUlDpt9PsORxHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V/X/fvowbWHMZnhkifOfhgE7sFILsRRxJBuMLXr1MjENWKbHUzb0LAblvcIucgIiT
         oSAy92Zucuye7m/rxMu5tX58ReiQfcmOFQbRxsoge9Q87XsUUwP7g+l1ZUYLdLIIsK
         QbDsAkVEfxwFaiGbkG/o4Rv5x+X33vuHR8Vw6y1KUuuH9juCrZ3Pi2p/O6yzcLuIQr
         n1OhYASDd9P+f31D/ixgm8nD/FCXC6RzlcFP05yWTWIYD3/5g1Aj+bdVSoOG0lvnG3
         MFhXEx7C+AaE3I2qIXEGnqG/MamKXy2668EHXJ/to/dF5Beb7fR9iRh8LPKfY9DYjj
         D/siPYBWK55gA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 43/48] mac80211: disallow band-switch during CSA
Date:   Tue, 22 Dec 2020 21:24:11 -0500
Message-Id: <20201223022417.2794032-43-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022417.2794032-1-sashal@kernel.org>
References: <20201223022417.2794032-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 3660944a37ce73890292571f44f04891834f9044 ]

If the AP advertises a band switch during CSA, we will not have
the right information to continue working with it, since it will
likely (have to) change its capabilities and we don't track any
capability changes at all. Additionally, we store e.g. supported
rates per band, and that information would become invalid.

Since this is a fringe scenario, just disconnect explicitly.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20201129172929.0e2327107c06.I461adb07704e056b054a4a7c29b80c95a9f56637@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 58b80270e58c2..7b9c02d5590c0 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1178,6 +1178,17 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	if (res)
 		return;
 
+	if (sdata->vif.bss_conf.chandef.chan->band !=
+	    csa_ie.chandef.chan->band) {
+		sdata_info(sdata,
+			   "AP %pM switches to different band (%d MHz, width:%d, CF1/2: %d/%d MHz), disconnecting\n",
+			   ifmgd->associated->bssid,
+			   csa_ie.chandef.chan->center_freq,
+			   csa_ie.chandef.width, csa_ie.chandef.center_freq1,
+			   csa_ie.chandef.center_freq2);
+		goto lock_and_drop_connection;
+	}
+
 	if (!cfg80211_chandef_usable(local->hw.wiphy, &csa_ie.chandef,
 				     IEEE80211_CHAN_DISABLED)) {
 		sdata_info(sdata,
@@ -1186,9 +1197,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 			   csa_ie.chandef.chan->center_freq,
 			   csa_ie.chandef.width, csa_ie.chandef.center_freq1,
 			   csa_ie.chandef.center_freq2);
-		ieee80211_queue_work(&local->hw,
-				     &ifmgd->csa_connection_drop_work);
-		return;
+		goto lock_and_drop_connection;
 	}
 
 	if (cfg80211_chandef_identical(&csa_ie.chandef,
@@ -1278,6 +1287,9 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 			  TU_TO_EXP_TIME((csa_ie.count - 1) *
 					 cbss->beacon_interval));
 	return;
+ lock_and_drop_connection:
+	mutex_lock(&local->mtx);
+	mutex_lock(&local->chanctx_mtx);
  drop_connection:
 	/*
 	 * This is just so that the disconnect flow will know that
-- 
2.27.0

