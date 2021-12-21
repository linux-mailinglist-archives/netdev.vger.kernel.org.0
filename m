Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5364547B78C
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 03:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234419AbhLUCA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 21:00:28 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33912 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233848AbhLUB7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 20:59:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35E84B81112;
        Tue, 21 Dec 2021 01:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE450C36AE9;
        Tue, 21 Dec 2021 01:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640051972;
        bh=QMYg3T/QRIFGtWXwvilAzeDh03fXhnKQ/aPEChnnvM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GO7BPGS2mMokulqrh4luH1VIZui54EYfpUmM4lk0m+5VpBfylD/A19H/bqT3cPvL7
         L/Q0Uph4o+eDcUAVvLZvAy+irniW+nUVIHtRhLE36T6ZKyBhIkNJeP37gbivC0OiW7
         bE5jQPq7KUqu72mqBOsvlsNM5MwUwoFih4d+HQe126G2rOgmYcDVgtSKfZCUOYhZuX
         Z8msCOTDvkPWG8GXZO0pcyzTIIdgayMLrqV8Nmh3JIGeuuj00272tcfkTCTWEQAqcF
         wbIzxgF1twZ1aCd/OWK+DbljZujjh/4nr5J/t75K19SaD2xtT07eQFXCRVbIVBPxsG
         3Rfmj0wB2AIaA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 11/19] mac80211: update channel context before station state
Date:   Mon, 20 Dec 2021 20:59:06 -0500
Message-Id: <20211221015914.116767-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221015914.116767-1-sashal@kernel.org>
References: <20211221015914.116767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

[ Upstream commit 4dde3c3627b52ca515a34f6f4de3898224aa1dd3 ]

Currently channel context is updated only after station got an update about
new assoc state, this results in station using the old channel context.

Fix this by moving the update channel context before updating station,
enabling the driver to immediately use the updated channel context in
the new assoc state.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211129152938.1c80c17ffd8a.I94ae31378b363c1182cfdca46c4b7e7165cff984@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/sta_info.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 461c03737da8d..3ccd1a311ff9c 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -668,6 +668,15 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 
 	list_add_tail_rcu(&sta->list, &local->sta_list);
 
+	/* update channel context before notifying the driver about state
+	 * change, this enables driver using the updated channel context right away.
+	 */
+	if (sta->sta_state >= IEEE80211_STA_ASSOC) {
+		ieee80211_recalc_min_chandef(sta->sdata);
+		if (!sta->sta.support_p2p_ps)
+			ieee80211_recalc_p2p_go_ps_allowed(sta->sdata);
+	}
+
 	/* notify driver */
 	err = sta_info_insert_drv_state(local, sdata, sta);
 	if (err)
@@ -675,12 +684,6 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 
 	set_sta_flag(sta, WLAN_STA_INSERTED);
 
-	if (sta->sta_state >= IEEE80211_STA_ASSOC) {
-		ieee80211_recalc_min_chandef(sta->sdata);
-		if (!sta->sta.support_p2p_ps)
-			ieee80211_recalc_p2p_go_ps_allowed(sta->sdata);
-	}
-
 	/* accept BA sessions now */
 	clear_sta_flag(sta, WLAN_STA_BLOCK_BA);
 
-- 
2.34.1

