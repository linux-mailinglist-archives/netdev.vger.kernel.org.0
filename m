Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E656747B731
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 02:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232924AbhLUB60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 20:58:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232745AbhLUB6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 20:58:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68AE1C061574;
        Mon, 20 Dec 2021 17:58:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33C33B8111E;
        Tue, 21 Dec 2021 01:58:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0B2C36AEB;
        Tue, 21 Dec 2021 01:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640051900;
        bh=BjfGgLQJp9X5r/PO8WkL/FIqgaWUhAASR5Hah6RKsyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VRMW3W4UZ+e72d0IJJ1x6YDiqCp1qJP5l/jze4y0F6XoUWFf7XoyYnCHcj/lNcySZ
         l4xfTunT2oJuCnBYydspeyzCA7farmIfz0joXrOZBx4bjCC/ENajLvQmS3UoBzbPrl
         8KEDlptyD2dyh9DGxEioUcRYAye1phV+oTKh0HKqxcj+WqgJd6FVepucwcpCAHF6xT
         MhubVs/uOo3jFtd7MZSmOdmqqt86N4dsh9K0tsJCD7Y4CtfyJktElOPEfmzPXy32e8
         8d9tGNHSgXC8029J/lgqtZ5+TtNZCdZP0q2YKovI6lD4ULdtMlRia6FHzqA78kMKeK
         Mn9/x7rpp4Qjw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 16/29] mac80211: update channel context before station state
Date:   Mon, 20 Dec 2021 20:57:37 -0500
Message-Id: <20211221015751.116328-16-sashal@kernel.org>
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
index 6eeef7a61927b..9e0bb402674c9 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -664,6 +664,15 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 
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
@@ -671,12 +680,6 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 
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

