Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2EB147B7CC
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 03:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234943AbhLUCBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 21:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233885AbhLUCA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 21:00:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE535C061D60;
        Mon, 20 Dec 2021 18:00:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C27161377;
        Tue, 21 Dec 2021 02:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC7BC36AE8;
        Tue, 21 Dec 2021 02:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640052025;
        bh=dQhzvlzN+ESGzQ/t66wl1mMot656MtLCVD5Dgq07tRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hwTNNSGxBPwhDlu4fkgdlmZSMqU6JGsaCt/i5pLv0+Ll2ErZanUImj4DifNDXwk/W
         VmUGpeNNkASFIDYA6L1PiqKtEtxfd3loEeXHsPpyZHJq4BkQxZzyfXriaiL35dENmP
         cm1hyxhhLZPIxuaOnmd09WYw7EozNxfDJt/C8tbNRpTlHzqFNSRB+fc9lSw6Mjxfh/
         IoGfqDERdcHMBxtnJH2VgrrYYzfn+l/tK/LJOST05u399/pxZYx9vHEzVdd6vvH7ux
         q+Z0pNrAYtW8BfrzAS5uD7bx8uM8bMO+2uIykpaIcsQ+wmE8qo51Rt1QGtfQFnS/9V
         dI3cOfi2THDUA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 11/14] mac80211: do drv_reconfig_complete() before restarting all
Date:   Mon, 20 Dec 2021 20:59:49 -0500
Message-Id: <20211221015952.117052-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221015952.117052-1-sashal@kernel.org>
References: <20211221015952.117052-1-sashal@kernel.org>
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
index fc326a3fc2e64..73a9e21b060d6 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2486,6 +2486,13 @@ int ieee80211_reconfig(struct ieee80211_local *local)
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
@@ -2504,13 +2511,6 @@ int ieee80211_reconfig(struct ieee80211_local *local)
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

