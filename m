Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3FC81B7529
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 14:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgDXMXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 08:23:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727825AbgDXMXH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 08:23:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD69B2087E;
        Fri, 24 Apr 2020 12:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587730986;
        bh=t6QrlUuqm7H12f/LEkP2lMqOz6UI8P+PkX2WkGbdVLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ce2KMzcwtR1jHYB2iMVnQZ2AWFQNnrLnW3oEUCfVZMskCTvM1nMjyERAm9QOolKfo
         ARKRMog7pVaaZnPjDO93g9dU7LuWh5m2YcsBt8Wkv5B10s50IqjCmrkd6Z07ywy3b9
         5+qKE9Ahx/F72Tz0mGJO2bLeuJ/HmS9H8eIT3d98=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tamizh chelvam <tamizhr@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 25/38] mac80211: fix channel switch trigger from unknown mesh peer
Date:   Fri, 24 Apr 2020 08:22:23 -0400
Message-Id: <20200424122237.9831-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424122237.9831-1-sashal@kernel.org>
References: <20200424122237.9831-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tamizh chelvam <tamizhr@codeaurora.org>

[ Upstream commit 93e2d04a1888668183f3fb48666e90b9b31d29e6 ]

Previously mesh channel switch happens if beacon contains
CSA IE without checking the mesh peer info. Due to that
channel switch happens even if the beacon is not from
its own mesh peer. Fixing that by checking if the CSA
originated from the same mesh network before proceeding
for channel switch.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
Link: https://lore.kernel.org/r/1585403604-29274-1-git-send-email-tamizhr@codeaurora.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index d09b3c789314d..36978a0e50001 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1257,15 +1257,15 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 		    sdata->u.mesh.mshcfg.rssi_threshold < rx_status->signal)
 			mesh_neighbour_update(sdata, mgmt->sa, &elems,
 					      rx_status);
+
+		if (ifmsh->csa_role != IEEE80211_MESH_CSA_ROLE_INIT &&
+		    !sdata->vif.csa_active)
+			ieee80211_mesh_process_chnswitch(sdata, &elems, true);
 	}
 
 	if (ifmsh->sync_ops)
 		ifmsh->sync_ops->rx_bcn_presp(sdata,
 			stype, mgmt, &elems, rx_status);
-
-	if (ifmsh->csa_role != IEEE80211_MESH_CSA_ROLE_INIT &&
-	    !sdata->vif.csa_active)
-		ieee80211_mesh_process_chnswitch(sdata, &elems, true);
 }
 
 int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata)
@@ -1373,6 +1373,9 @@ static void mesh_rx_csa_frame(struct ieee80211_sub_if_data *sdata,
 	ieee802_11_parse_elems(pos, len - baselen, true, &elems,
 			       mgmt->bssid, NULL);
 
+	if (!mesh_matches_local(sdata, &elems))
+		return;
+
 	ifmsh->chsw_ttl = elems.mesh_chansw_params_ie->mesh_ttl;
 	if (!--ifmsh->chsw_ttl)
 		fwd_csa = false;
-- 
2.20.1

