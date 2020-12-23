Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEB02E137F
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730925AbgLWCah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:30:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:55146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730532AbgLWCZe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:25:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8391522285;
        Wed, 23 Dec 2020 02:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690313;
        bh=E6UgPzpZIrhWjU5j0cOZrnbRIBr4p0c5BkmzbsysHWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nJhJGyAMM0Yv/0IdpaNYgdtVu0EjrpVavrODwnne1yA5MNJLCVkm0TcwfqakfBQtf
         ZCDPQrxLM25E4IaZq8+SMqLFIoJGg2+ebHOdVvxibVTJeeQzchFyFOxTlDUn4XXGYm
         hL+zqmxUZY/jDmzpxrBp8pz6HBxYlVQNNG4RdbyrNS6JnjJFA/ZhbPfKUBianIUaD7
         hV7nCMYHkYqngo0vOsizomp5DFCDANkjU2Cv28ELN5JG8KJFSaiTGiKXGFeWDOXUOy
         vyWFLASG1lz1ZT9YNDRUjjMEx2WrLACVCWMrBtoVYb7MT1VhstZ5TI4uxBn5dQC8w1
         lZGIHktLnqRWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 46/48] mac80211: Update rate control on channel change
Date:   Tue, 22 Dec 2020 21:24:14 -0500
Message-Id: <20201223022417.2794032-46-sashal@kernel.org>
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

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 44b72ca8163b8cf94384a11fdec716f5478411bf ]

A channel change or a channel bandwidth change can impact the
rate control logic. However, the rate control logic was not updated
before/after such a change, which might result in unexpected
behavior.

Fix this by updating the stations rate control logic when the
corresponding channel context changes.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20201206145305.600d967fe3c9.I48305f25cfcc9c032c77c51396e9e9b882748a86@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/chan.c | 61 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 48b60b53ff3ff..0d06330aa9321 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -8,6 +8,7 @@
 #include <net/cfg80211.h>
 #include "ieee80211_i.h"
 #include "driver-ops.h"
+#include "rate.h"
 
 static int ieee80211_chanctx_num_assigned(struct ieee80211_local *local,
 					  struct ieee80211_chanctx *ctx)
@@ -339,10 +340,42 @@ void ieee80211_recalc_chanctx_min_def(struct ieee80211_local *local,
 	drv_change_chanctx(local, ctx, IEEE80211_CHANCTX_CHANGE_MIN_WIDTH);
 }
 
+static void ieee80211_chan_bw_change(struct ieee80211_local *local,
+				     struct ieee80211_chanctx *ctx)
+{
+	struct sta_info *sta;
+	struct ieee80211_supported_band *sband =
+		local->hw.wiphy->bands[ctx->conf.def.chan->band];
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sta, &local->sta_list,
+				list) {
+		enum ieee80211_sta_rx_bandwidth new_sta_bw;
+
+		if (!ieee80211_sdata_running(sta->sdata))
+			continue;
+
+		if (rcu_access_pointer(sta->sdata->vif.chanctx_conf) !=
+		    &ctx->conf)
+			continue;
+
+		new_sta_bw = ieee80211_sta_cur_vht_bw(sta);
+		if (new_sta_bw == sta->sta.bandwidth)
+			continue;
+
+		sta->sta.bandwidth = new_sta_bw;
+		rate_control_rate_update(local, sband, sta,
+					 IEEE80211_RC_BW_CHANGED);
+	}
+	rcu_read_unlock();
+}
+
 static void ieee80211_change_chanctx(struct ieee80211_local *local,
 				     struct ieee80211_chanctx *ctx,
 				     const struct cfg80211_chan_def *chandef)
 {
+	enum nl80211_chan_width width;
+
 	if (cfg80211_chandef_identical(&ctx->conf.def, chandef)) {
 		ieee80211_recalc_chanctx_min_def(local, ctx);
 		return;
@@ -350,7 +383,25 @@ static void ieee80211_change_chanctx(struct ieee80211_local *local,
 
 	WARN_ON(!cfg80211_chandef_compatible(&ctx->conf.def, chandef));
 
+	width = ctx->conf.def.width;
 	ctx->conf.def = *chandef;
+
+	/* expected to handle only 20/40/80/160 channel widths */
+	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_20_NOHT:
+	case NL80211_CHAN_WIDTH_20:
+	case NL80211_CHAN_WIDTH_40:
+	case NL80211_CHAN_WIDTH_80:
+	case NL80211_CHAN_WIDTH_80P80:
+	case NL80211_CHAN_WIDTH_160:
+		break;
+	default:
+		WARN_ON(1);
+	}
+
+	if (chandef->width < width)
+		ieee80211_chan_bw_change(local, ctx);
+
 	drv_change_chanctx(local, ctx, IEEE80211_CHANCTX_CHANGE_WIDTH);
 	ieee80211_recalc_chanctx_min_def(local, ctx);
 
@@ -358,6 +409,9 @@ static void ieee80211_change_chanctx(struct ieee80211_local *local,
 		local->_oper_chandef = *chandef;
 		ieee80211_hw_config(local, 0);
 	}
+
+	if (chandef->width > width)
+		ieee80211_chan_bw_change(local, ctx);
 }
 
 static struct ieee80211_chanctx *
@@ -1040,8 +1094,14 @@ ieee80211_vif_use_reserved_reassign(struct ieee80211_sub_if_data *sdata)
 	if (WARN_ON(!chandef))
 		return -EINVAL;
 
+	if (old_ctx->conf.def.width > new_ctx->conf.def.width)
+		ieee80211_chan_bw_change(local, new_ctx);
+
 	ieee80211_change_chanctx(local, new_ctx, chandef);
 
+	if (old_ctx->conf.def.width < new_ctx->conf.def.width)
+		ieee80211_chan_bw_change(local, new_ctx);
+
 	vif_chsw[0].vif = &sdata->vif;
 	vif_chsw[0].old_ctx = &old_ctx->conf;
 	vif_chsw[0].new_ctx = &new_ctx->conf;
@@ -1434,6 +1494,7 @@ static int ieee80211_vif_use_reserved_switch(struct ieee80211_local *local)
 		ieee80211_recalc_smps_chanctx(local, ctx);
 		ieee80211_recalc_radar_chanctx(local, ctx);
 		ieee80211_recalc_chanctx_min_def(local, ctx);
+		ieee80211_chan_bw_change(local, ctx);
 
 		list_for_each_entry_safe(sdata, sdata_tmp, &ctx->reserved_vifs,
 					 reserved_chanctx_list) {
-- 
2.27.0

