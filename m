Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE5F291D52
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 21:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730226AbgJRTXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 15:23:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730175AbgJRTXN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 15:23:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5412E2137B;
        Sun, 18 Oct 2020 19:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048992;
        bh=nJis7b8zLyW0yaZo9EjWgF0T7QqQq3ssWJU411iebuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lXdWETJaOs0h0/YFTwlcZoP3UvMN7umoQHEPakhPqBJXut6zUQM4TxoEoyBN6P3/h
         54nB6AUmhr2pGj2CdH3gEr2pO5bloCtLMvvm1qwkFC9sKCufNWURHGxOt79CsL8BAf
         H6sGu3A96YTDDtk5e0IP9YFgpMYPhkM5do9PR6BQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Pedersen <thomas@adapt-ip.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 30/80] mac80211: handle lack of sband->bitrates in rates
Date:   Sun, 18 Oct 2020 15:21:41 -0400
Message-Id: <20201018192231.4054535-30-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192231.4054535-1-sashal@kernel.org>
References: <20201018192231.4054535-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Pedersen <thomas@adapt-ip.com>

[ Upstream commit 8b783d104e7f40684333d2ec155fac39219beb2f ]

Even though a driver or mac80211 shouldn't produce a
legacy bitrate if sband->bitrates doesn't exist, don't
crash if that is the case either.

This fixes a kernel panic if station dump is run before
last_rate can be updated with a data frame when
sband->bitrates is missing (eg. in S1G bands).

Signed-off-by: Thomas Pedersen <thomas@adapt-ip.com>
Link: https://lore.kernel.org/r/20201005164522.18069-1-thomas@adapt-ip.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c      | 3 ++-
 net/mac80211/sta_info.c | 4 ++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a9dda5c228f60..fa293feef935d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -698,7 +698,8 @@ void sta_set_rate_info_tx(struct sta_info *sta,
 		u16 brate;
 
 		sband = ieee80211_get_sband(sta->sdata);
-		if (sband) {
+		WARN_ON_ONCE(sband && !sband->bitrates);
+		if (sband && sband->bitrates) {
 			brate = sband->bitrates[rate->idx].bitrate;
 			rinfo->legacy = DIV_ROUND_UP(brate, 1 << shift);
 		}
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index f5d96107af6de..4f14d8a06915a 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2083,6 +2083,10 @@ static void sta_stats_decode_rate(struct ieee80211_local *local, u32 rate,
 		int rate_idx = STA_STATS_GET(LEGACY_IDX, rate);
 
 		sband = local->hw.wiphy->bands[band];
+
+		if (WARN_ON_ONCE(!sband->bitrates))
+			break;
+
 		brate = sband->bitrates[rate_idx].bitrate;
 		if (rinfo->bw == RATE_INFO_BW_5)
 			shift = 2;
-- 
2.25.1

