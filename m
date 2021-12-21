Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3FBA47B7D2
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 03:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234976AbhLUCBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 21:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233429AbhLUCA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 21:00:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA41BC061784;
        Mon, 20 Dec 2021 18:00:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAE7461357;
        Tue, 21 Dec 2021 02:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C31C36AE9;
        Tue, 21 Dec 2021 02:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640052024;
        bh=tLfx/6CvkybJK6NyfBcLLX6k9iaJeGawGeIuyQnUBVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nnz31FPytrWeuN7cG8gwOqwoN5WSD2sXocaJOFXWj41VylrrsLuqjA5Nx/VK69jO9
         rN7m8n/rPxfHTyLf+c4rT3aPgFsc4/lRYY/uUAAWcBIj5d8RgMvypC4hHaHDd4wWS3
         J9RPganAWpm2Us6fzY1zacwYMetOiUA3CeycxuYL+yldBTTm9iiSCdU6BkFTzcHafz
         7DyIO2+k5ZTlQ/vAf7PTQs1J1AC/EGJxTcIeD0UT/LA2UzJ8xxesWGvtlMBa3SGMrM
         a5YYdbf6JW1Fvd0GVeCjzZ4C+RvLbHpgqtUP2puMJcCU/z9Tan4nazX9w79FvoyK7c
         Ml2jd8c6s7EzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 10/14] mac80211: update channel context before station state
Date:   Mon, 20 Dec 2021 20:59:48 -0500
Message-Id: <20211221015952.117052-10-sashal@kernel.org>
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
index 384a95617ee5e..6a1d3935bd3e1 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -651,6 +651,15 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 
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
@@ -658,12 +667,6 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 
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

