Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89377FA136
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 02:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729316AbfKMBzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 20:55:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:47742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729306AbfKMBzx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 20:55:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89E442246D;
        Wed, 13 Nov 2019 01:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610153;
        bh=PP0VoN0gfOnQZCCZJ3I7rIYd7iS6ObVjGVuvpnxLw1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zFLrbfK1aIfLQHmQkSpWLIn/X4SB/lWmpnRfp18hK9rJfZhi+zhTZbe6pI0R9r8WL
         jAhXltmWavyfSEP/Uc3vIhryccgpjXWMkHqea4i63je/le0B/bMaPTSYiZaeoaKLZP
         Igaz4w3elOLn4xr6i/Pbdr16+BsKhKqfY+cbToZ8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 197/209] mac80211: minstrel: fix using short preamble CCK rates on HT clients
Date:   Tue, 12 Nov 2019 20:50:13 -0500
Message-Id: <20191113015025.9685-197-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 37439f2d6e43ae79e22be9be159f0af157468f82 ]

mi->supported[MINSTREL_CCK_GROUP] needs to be updated
short preamble rates need to be marked as supported regardless of
whether it's currently enabled. Its state can change at any time without
a rate_update call.

Fixes: 782dda00ab8e ("mac80211: minstrel_ht: move short preamble check out of get_rate")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 67ebdeaffbbc8..ae1a180d2eee3 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -1132,7 +1132,6 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	struct ieee80211_mcs_info *mcs = &sta->ht_cap.mcs;
 	u16 sta_cap = sta->ht_cap.cap;
 	struct ieee80211_sta_vht_cap *vht_cap = &sta->vht_cap;
-	struct sta_info *sinfo = container_of(sta, struct sta_info, sta);
 	int use_vht;
 	int n_supported = 0;
 	int ack_dur;
@@ -1258,8 +1257,7 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	if (!n_supported)
 		goto use_legacy;
 
-	if (test_sta_flag(sinfo, WLAN_STA_SHORT_PREAMBLE))
-		mi->cck_supported_short |= mi->cck_supported_short << 4;
+	mi->supported[MINSTREL_CCK_GROUP] |= mi->cck_supported_short << 4;
 
 	/* create an initial rate table with the lowest supported rates */
 	minstrel_ht_update_stats(mp, mi);
-- 
2.20.1

