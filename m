Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 298DE47B73A
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 02:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbhLUB6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 20:58:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:32972 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbhLUB6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 20:58:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2319B8110D;
        Tue, 21 Dec 2021 01:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7991EC36AE9;
        Tue, 21 Dec 2021 01:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640051901;
        bh=UfXfiVWd4sL96uM9J1OKaKgklJUfNgxFazZRw9HEmE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OwQTapm6L2RW/BHVWIJWWbEQLtHcHYbarMM+cN4AE63zOqtGofooPZgL5/Qifp8Sn
         2zR4nKuCeO9qoI/O1L1/E5VBZKRLSK7XwJkgcpT9xy9dpe/L9bqqMCBnR2oNc/MrxZ
         jL0uKe3VeVBcztqKG/6N3G6WIApZgfTqqQBmJ+MmRDjKjUHFH6LgxakZ/TwSqaUs9s
         756e191tGiPI3KAaq4qPbU0s7RkFe/+E1GJy2O1Y3tzCmDZfJlDZHA8FfpoW20ohpI
         yICtR9DyyH09MCFvM3kETdJvtixFzDtpaEhRuUKZ9jC/7uoa7Xo9yNQlN/BOc9V3bi
         J9OCUSNHet43g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 17/29] mac80211: do drv_reconfig_complete() before restarting all
Date:   Mon, 20 Dec 2021 20:57:38 -0500
Message-Id: <20211221015751.116328-17-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221015751.116328-1-sashal@kernel.org>
References: <20211221015751.116328-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 13dee10b30c058ee2c58c5da00339cc0d4201aa6 ]

When we reconfigure, the driver might do some things to complete
the reconfiguration. It's strange and could be broken in some
cases because we restart other works (e.g. remain-on-channel and
TX) before this happens, yet only start queues later.

Change this to do the reconfig complete when reconfiguration is
actually complete, not when we've already started doing other
things again.

For iwlwifi, this should fix a race where the reconfig can race
with TX, for ath10k and ath11k that also use this it won't make
a difference because they just start queues there, and mac80211
also stopped the queues and will restart them later as before.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211129152938.cab99f22fe19.Iefe494687f15fd85f77c1b989d1149c8efdfdc36@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/util.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 39961a4f55d12..a94223710d48d 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2644,6 +2644,13 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		mutex_unlock(&local->sta_mtx);
 	}
 
+	/*
+	 * If this is for hw restart things are still running.
+	 * We may want to change that later, however.
+	 */
+	if (local->open_count && (!suspended || reconfig_due_to_wowlan))
+		drv_reconfig_complete(local, IEEE80211_RECONFIG_TYPE_RESTART);
+
 	if (local->in_reconfig) {
 		local->in_reconfig = false;
 		barrier();
@@ -2662,13 +2669,6 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 					IEEE80211_QUEUE_STOP_REASON_SUSPEND,
 					false);
 
-	/*
-	 * If this is for hw restart things are still running.
-	 * We may want to change that later, however.
-	 */
-	if (local->open_count && (!suspended || reconfig_due_to_wowlan))
-		drv_reconfig_complete(local, IEEE80211_RECONFIG_TYPE_RESTART);
-
 	if (!suspended)
 		return 0;
 
-- 
2.34.1

