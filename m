Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6ED3AF27D
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbhFURy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:54:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231961AbhFURyf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 13:54:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A48F76128A;
        Mon, 21 Jun 2021 17:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624297941;
        bh=ZKOlOQEc0Zv2X+bJq4CpdNmLnkZxsej9vDF0pPBnW4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gPRyRiTTkkL/yKhTPhyj7vkwGpxs+x/mfNDWmofz9xDrxfTHasuPYtjtrHK5dPKNe
         l0Vv7Ysys/fachIQ3vRJoHL7Ep9tsJ3ua8MApJ6H38FsXUzUQW67pd46orUqbrfEc5
         HvLqdQpTQbKr+JSlU7ezx+sN6rKNG7b0oXMBGItyqB4R3J+9Bcw0S7sLG1JKWUt3Jm
         82LveauQHAvg0CHZ1w32TA+3zyWHfZOsiiejxWD3LEmdy+TlOoLZwpDiMqRKA//i5E
         VMTj2PCMm+92Iim8pRF0oe7pndurQ6yDXsa0hopzenc/38ir/CFmxh7RZ1esvUKWlM
         xC1PjfggtZfig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 14/39] mac80211: drop multicast fragments
Date:   Mon, 21 Jun 2021 13:51:30 -0400
Message-Id: <20210621175156.735062-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175156.735062-1-sashal@kernel.org>
References: <20210621175156.735062-1-sashal@kernel.org>
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
index 59de7a86599d..cb5cbf02dbac 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2239,17 +2239,15 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
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
@@ -2375,7 +2373,6 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 
  out:
 	ieee80211_led_rx(rx->local);
- out_no_led:
 	if (rx->sta)
 		rx->sta->rx_stats.packets++;
 	return RX_CONTINUE;
-- 
2.30.2

