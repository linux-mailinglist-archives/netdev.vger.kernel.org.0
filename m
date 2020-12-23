Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E8A2E13EC
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731016AbgLWCgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:36:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:51348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730233AbgLWCY3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:24:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26C1F23333;
        Wed, 23 Dec 2020 02:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690251;
        bh=C73YvmRzvqw6ygvRky5uTvuWKoaNtV93QFaCm+rqboU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/zBTpy90dEnIyS5Y5i2m8EHVURWE1Y59X0ZdM7GPtg/5PzizGq5AyQIKoJQ1rOAn
         H3OpdRS9mhijf3dR9UnJJF5TLU6+RzRsBb2ByQ5oedeZwPEx2NW/1GcmrwczApuioj
         LfSGlQVytOnYSiNpa0/N1j8bpKXD/lhGehc6DQTIbFvWXSeLKgowwuTpfLiadRRqgU
         VLs8Vcyeq1LhcYFtEhKUrNBlH9nqlpfD5eIEVySY9sDvBb6yCa44kVKLoJUk5OC7xi
         oipB9Cib997WGs3afVgvLHSMomjsSj12cR+dUiqfG5GnIqv+QnKuT3iNe9llKXrHWc
         KMRnR4LAE+kbg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 62/66] mac80211: Fix calculation of minimal channel width
Date:   Tue, 22 Dec 2020 21:22:48 -0500
Message-Id: <20201223022253.2793452-62-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022253.2793452-1-sashal@kernel.org>
References: <20201223022253.2793452-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit bbf31e88df2f5da20ce613c340ce508d732046b3 ]

When calculating the minimal channel width for channel context,
the current operation Rx channel width of a station was used and not
the overall channel width capability of the station, i.e., both for
Tx and Rx.

Fix ieee80211_get_sta_bw() to use the maximal channel width the
station is capable. While at it make the function static.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20201206145305.4387040b99a0.I74bcf19238f75a5960c4098b10e355123d933281@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/chan.c        | 10 ++++++----
 net/mac80211/ieee80211_i.h |  1 -
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 89178b46b32fa..6a25be5eb1e7e 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -190,11 +190,13 @@ ieee80211_find_reservation_chanctx(struct ieee80211_local *local,
 	return NULL;
 }
 
-enum nl80211_chan_width ieee80211_get_sta_bw(struct ieee80211_sta *sta)
+static enum nl80211_chan_width ieee80211_get_sta_bw(struct sta_info *sta)
 {
-	switch (sta->bandwidth) {
+	enum ieee80211_sta_rx_bandwidth width = ieee80211_sta_cap_rx_bw(sta);
+
+	switch (width) {
 	case IEEE80211_STA_RX_BW_20:
-		if (sta->ht_cap.ht_supported)
+		if (sta->sta.ht_cap.ht_supported)
 			return NL80211_CHAN_WIDTH_20;
 		else
 			return NL80211_CHAN_WIDTH_20_NOHT;
@@ -231,7 +233,7 @@ ieee80211_get_max_required_bw(struct ieee80211_sub_if_data *sdata)
 		    !(sta->sdata->bss && sta->sdata->bss == sdata->bss))
 			continue;
 
-		max_bw = max(max_bw, ieee80211_get_sta_bw(&sta->sta));
+		max_bw = max(max_bw, ieee80211_get_sta_bw(sta));
 	}
 	rcu_read_unlock();
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0e209a88d88a7..2be55a90ee0bd 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2129,7 +2129,6 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
 				 enum ieee80211_chanctx_mode chanmode,
 				 u8 radar_detect);
 int ieee80211_max_num_channels(struct ieee80211_local *local);
-enum nl80211_chan_width ieee80211_get_sta_bw(struct ieee80211_sta *sta);
 void ieee80211_recalc_chanctx_chantype(struct ieee80211_local *local,
 				       struct ieee80211_chanctx *ctx);
 
-- 
2.27.0

