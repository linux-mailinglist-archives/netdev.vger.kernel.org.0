Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6B03BD08A
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235495AbhGFLeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:34:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235623AbhGFLaP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:30:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A864761DA8;
        Tue,  6 Jul 2021 11:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570487;
        bh=27ckhIJ+8VfQFzQBVnCXaH3uoS+MBZVLK9NoxWmglxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IV/kibGRcE0DZ05d00Lf0ZzJR1U844m8+FJ+OIOP68CDTu9+52nWt/UO9bTN9n6Mq
         ELEUoui71sTNEmDwW0QT7OLLksRHwZ91PSRQRIYvv4xkQOY2Cd+3Ux/QtoWUXaUDO8
         sF9/Fys8QzkNtYVt32MmWnFrIOOgbRj6T7hklN4cQGkr0hhtR1+OKuQ/rQUJ8RcFqi
         FPlPL3llw9ebEE1yKVEFW7/eIxePQtOZDSZ4pQ9TmzYED2sABBTU4cCGnLsGzRobbx
         xx4iI8HfT3vsEs1dCtVGRU+c9X6Q+xB+W1ogRr6ClBuPW5/1X8Sb09og0MSY0jf02q
         XJvKeoEM+xE1w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Thiraviyam Mariyappan <tmariyap@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 134/160] mac80211: consider per-CPU statistics if present
Date:   Tue,  6 Jul 2021 07:18:00 -0400
Message-Id: <20210706111827.2060499-134-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit d656a4c6ead6c3f252b2f2532bc9735598f7e317 ]

If we have been keeping per-CPU statistics, consider them
regardless of USES_RSS, because we may not actually fill
those, for example in non-fast-RX cases when the connection
is not compatible with fast-RX. If we didn't fill them, the
additional data will be zero and not affect anything, and
if we did fill them then it's more correct to consider them.

This fixes an issue in mesh mode where some statistics are
not updated due to USES_RSS being set, but fast-RX isn't
used.

Reported-by: Thiraviyam Mariyappan <tmariyap@codeaurora.org>
Link: https://lore.kernel.org/r/20210610220814.13b35f5797c5.I511e9b33c5694e0d6cef4b6ae755c873d7c22124@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/sta_info.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index f2fb69da9b6e..641a6657d0c9 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2093,10 +2093,9 @@ static struct ieee80211_sta_rx_stats *
 sta_get_last_rx_stats(struct sta_info *sta)
 {
 	struct ieee80211_sta_rx_stats *stats = &sta->rx_stats;
-	struct ieee80211_local *local = sta->local;
 	int cpu;
 
-	if (!ieee80211_hw_check(&local->hw, USES_RSS))
+	if (!sta->pcpu_rx_stats)
 		return stats;
 
 	for_each_possible_cpu(cpu) {
@@ -2196,9 +2195,7 @@ static void sta_set_tidstats(struct sta_info *sta,
 	int cpu;
 
 	if (!(tidstats->filled & BIT(NL80211_TID_STATS_RX_MSDU))) {
-		if (!ieee80211_hw_check(&local->hw, USES_RSS))
-			tidstats->rx_msdu +=
-				sta_get_tidstats_msdu(&sta->rx_stats, tid);
+		tidstats->rx_msdu += sta_get_tidstats_msdu(&sta->rx_stats, tid);
 
 		if (sta->pcpu_rx_stats) {
 			for_each_possible_cpu(cpu) {
@@ -2277,7 +2274,6 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 		sinfo->rx_beacon = sdata->u.mgd.count_beacon_signal;
 
 	drv_sta_statistics(local, sdata, &sta->sta, sinfo);
-
 	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_INACTIVE_TIME) |
 			 BIT_ULL(NL80211_STA_INFO_STA_FLAGS) |
 			 BIT_ULL(NL80211_STA_INFO_BSS_PARAM) |
@@ -2312,8 +2308,7 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 
 	if (!(sinfo->filled & (BIT_ULL(NL80211_STA_INFO_RX_BYTES64) |
 			       BIT_ULL(NL80211_STA_INFO_RX_BYTES)))) {
-		if (!ieee80211_hw_check(&local->hw, USES_RSS))
-			sinfo->rx_bytes += sta_get_stats_bytes(&sta->rx_stats);
+		sinfo->rx_bytes += sta_get_stats_bytes(&sta->rx_stats);
 
 		if (sta->pcpu_rx_stats) {
 			for_each_possible_cpu(cpu) {
-- 
2.30.2

