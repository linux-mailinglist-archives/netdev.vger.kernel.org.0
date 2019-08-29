Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF837A16F5
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 12:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728551AbfH2KwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 06:52:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:59174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728552AbfH2KvQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 06:51:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C48B2341C;
        Thu, 29 Aug 2019 10:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567075875;
        bh=GzeRH4UgyVOHI0ey86YhHXT1lIRYzwFIUv1/hmjQmCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S+YXI7P0GVfHsBInUPcElNsOyvzqNlCPTSM18b62xSixH0NcyiAWiKcu0kzVsJ1CE
         gUI9JaWjwVsi6GgkQ8b+Eg+jW4QS7kynhtNp4al8SZYO0ZSQxNVUmZtrta2TGOYz9U
         x2qQZwdv1M8/3flSlEjWy/MHNPgINL8YqNc4j1Go=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 3/6] mac80211: fix possible sta leak
Date:   Thu, 29 Aug 2019 06:51:07 -0400
Message-Id: <20190829105110.2748-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829105110.2748-1-sashal@kernel.org>
References: <20190829105110.2748-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 5fd2f91ad483baffdbe798f8a08f1b41442d1e24 ]

If TDLS station addition is rejected, the sta memory is leaked.
Avoid this by moving the check before the allocation.

Cc: stable@vger.kernel.org
Fixes: 7ed5285396c2 ("mac80211: don't initiate TDLS connection if station is not associated to AP")
Link: https://lore.kernel.org/r/20190801073033.7892-1-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7349bf26ae7b3..1999a7eaa6920 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1211,6 +1211,11 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 	if (is_multicast_ether_addr(mac))
 		return -EINVAL;
 
+	if (params->sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER) &&
+	    sdata->vif.type == NL80211_IFTYPE_STATION &&
+	    !sdata->u.mgd.associated)
+		return -EINVAL;
+
 	sta = sta_info_alloc(sdata, mac, GFP_KERNEL);
 	if (!sta)
 		return -ENOMEM;
@@ -1228,10 +1233,6 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 	if (params->sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER))
 		sta->sta.tdls = true;
 
-	if (sta->sta.tdls && sdata->vif.type == NL80211_IFTYPE_STATION &&
-	    !sdata->u.mgd.associated)
-		return -EINVAL;
-
 	err = sta_apply_parameters(local, sta, params);
 	if (err) {
 		sta_info_free(local, sta);
-- 
2.20.1

