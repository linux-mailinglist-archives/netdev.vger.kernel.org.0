Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2C13AF447
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 20:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbhFUSHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:07:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232184AbhFUSEC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 14:04:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB9D961419;
        Mon, 21 Jun 2021 17:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298149;
        bh=q4Ch5aLwhkpOI3OBAmrvkqhgZqn6fNoRPF7U7SBdh5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I1SO7zyy9Q5RI4NTOLMseStR4NZCzof6B0Tx0zitljMb5rPlcGYVVnl2Q6LXRBtN8
         JL2PuC9dwp3Um3SI36qgNN0nITxHBKgpd6Rxt7JQHdP5xdKOy/Fd/0gzM6HIe4Ubil
         qE3uRydZbcCIJ0j6H25w3z7a2YbhxFSj0AGVp5YqXpZ3P6XbfW3G5/lRD/fxs/9kTv
         1yJS0EBclFcRl/g3GsoK9If3b1iRNoBZo6epdCzgj3PpJ8oy+w2Ng0+Xs+mFENxYEt
         21/0r+dVDvK+or7JYZc9ydcI5snHZABJoBASgeGztZvfFCrBh8xzqFIgaB2ETNw6w1
         Jvkq/R+b05/kQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 03/13] mac80211: drop multicast fragments
Date:   Mon, 21 Jun 2021 13:55:33 -0400
Message-Id: <20210621175544.736421-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175544.736421-1-sashal@kernel.org>
References: <20210621175544.736421-1-sashal@kernel.org>
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
index 721caa5a5430..3a069cb188b7 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1988,17 +1988,15 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
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
@@ -2127,7 +2125,6 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 
  out:
 	ieee80211_led_rx(rx->local);
- out_no_led:
 	if (rx->sta)
 		rx->sta->rx_stats.packets++;
 	return RX_CONTINUE;
-- 
2.30.2

