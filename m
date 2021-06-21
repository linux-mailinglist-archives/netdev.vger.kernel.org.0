Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2C63AF378
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232586AbhFUSBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:01:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233096AbhFUR73 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 13:59:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28C2861369;
        Mon, 21 Jun 2021 17:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298058;
        bh=ir0KLhiqvktH0GnMorBcezemvMBe7ObkYrYYx55eF2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f7AXkOEUn5m/HexYpXsp1+xkaOHiWf5t0j3qnvF0z+yDKwlSKadlQ3g5121Ygp3GG
         KAnW/+SAmZD9vxzCCwQFcLrmk8KQNjgXdVcC6Ji0vUfB8R3eZ2xdQfh3CbZDmTFnZb
         Zx7sOy6kxlRfrfjJia/VX2o273INoEZifXDg0ZhjPLOFg+ckz55KLuMW71osogji25
         OsX5QmkBTk0fAx8wIDV4BVzBmxDhCvwv0xAUkW8jVyZ56/TrixUxLk+gGNuPIWT+yl
         VZXy2GCF//BixwQmdJCti6xgUHcbyN02+CEuJJlr386beO8SvDQEeCSdnALNBatUuS
         3V2fFl0z4qlVw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 10/26] mac80211: drop multicast fragments
Date:   Mon, 21 Jun 2021 13:53:43 -0400
Message-Id: <20210621175400.735800-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175400.735800-1-sashal@kernel.org>
References: <20210621175400.735800-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit a9799541ca34652d9996e45f80e8e03144c12949 ]

These are not permitted by the spec, just drop them.

Link: https://lore.kernel.org/r/20210609161305.23def022b750.Ibd6dd3cdce573dae262fcdc47f8ac52b883a9c50@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 3d7a5c5e586a..670d84e54db7 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2200,17 +2200,15 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 	sc = le16_to_cpu(hdr->seq_ctrl);
 	frag = sc & IEEE80211_SCTL_FRAG;
 
-	if (is_multicast_ether_addr(hdr->addr1)) {
-		I802_DEBUG_INC(rx->local->dot11MulticastReceivedFrameCount);
-		goto out_no_led;
-	}
-
 	if (rx->sta)
 		cache = &rx->sta->frags;
 
 	if (likely(!ieee80211_has_morefrags(fc) && frag == 0))
 		goto out;
 
+	if (is_multicast_ether_addr(hdr->addr1))
+		return RX_DROP_MONITOR;
+
 	I802_DEBUG_INC(rx->local->rx_handlers_fragments);
 
 	if (skb_linearize(rx->skb))
@@ -2336,7 +2334,6 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 
  out:
 	ieee80211_led_rx(rx->local);
- out_no_led:
 	if (rx->sta)
 		rx->sta->rx_stats.packets++;
 	return RX_CONTINUE;
-- 
2.30.2

