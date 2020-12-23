Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0752E1444
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729887AbgLWCXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:23:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:51318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729870AbgLWCXD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:23:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6BC0225AB;
        Wed, 23 Dec 2020 02:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690165;
        bh=+q+gSVCRGwd6pCl4K2v/dH+8UUl1ZK+npmBeqtDjgck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B+5LD3Maws5ZC/WBttyYWrHi42HsxEZd3rLspncMASS+U+yJ1jC72TeKqH8nsJYxn
         hPRAQvXz248a7HVRjfAptYQfAwmCyixXMxn3m6Z7yjfrqwpQv376w7hscon6fJHPJo
         9qVYVn1VTvtGXLdSMdU+FeT0KBvR2/Hxm2Sn5i/ipbaKwEAV8zo8FuIi1X6PT4zsbq
         VkTX91q4mW8Dzl7KOEUfDraJbWqwhl6CMCzxgA3iScg991xAVsnhY+6m2E9v8NBqrW
         iWTGWZ/fZsfcxzrzHzfdAfQTUql9KI+KRit+3pfVeT7bTh3qaGfxHzcICotV2SmX5l
         inJFzaaNmJluA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 82/87] mac80211: Fix calculation of minimal channel width
Date:   Tue, 22 Dec 2020 21:20:58 -0500
Message-Id: <20201223022103.2792705-82-sashal@kernel.org>
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
index d9558ffb8acf7..b58813568c9ff 100644
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
index 43edb903be693..285a541549aaa 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2165,7 +2165,6 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
 				 enum ieee80211_chanctx_mode chanmode,
 				 u8 radar_detect);
 int ieee80211_max_num_channels(struct ieee80211_local *local);
-enum nl80211_chan_width ieee80211_get_sta_bw(struct ieee80211_sta *sta);
 void ieee80211_recalc_chanctx_chantype(struct ieee80211_local *local,
 				       struct ieee80211_chanctx *ctx);
 
-- 
2.27.0

