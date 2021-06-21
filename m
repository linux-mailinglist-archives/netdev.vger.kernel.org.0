Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2385C3AF462
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 20:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbhFUSJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:09:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234286AbhFUSFD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 14:05:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 013D26135D;
        Mon, 21 Jun 2021 17:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298171;
        bh=bptRCqEJ8bWyjVb1m8aqTTm0rNWtT6SP2b/8nDtdCHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fl22s5WKlG6wKTqbAcp3wgZbhXPFdDN2s/WUsEyeMncRbnucVw9fCHq6rohdoh7hx
         TnsUaslALgdQ1DIdd5No8CLGzqyd7qNKGHRz5dUzgbyMqeDUnA3crvPcFNHgPVa6/o
         Dr8JP5ZUvh7kWaApMmsVd4sAYeEt7tvXetH2wk5ZO90H9sOs/ouGFxoXxOSOExBVoH
         OaUu7WD9Hf3hEB6khIGBJh/GGLzFkltuV0kiSt1A7QS8ocW/JIk14NLX/CJtjTabee
         QvKO6VEDd62Qc1w7QJ87x8xPT22i0E+nczCDHHk/xrRBnmpCwaAI4VXSSGUsiqAKrX
         kSO0C1JKw9XRg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 2/9] mac80211: drop multicast fragments
Date:   Mon, 21 Jun 2021 13:56:00 -0400
Message-Id: <20210621175608.736581-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175608.736581-1-sashal@kernel.org>
References: <20210621175608.736581-1-sashal@kernel.org>
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
index ae0fba044cd0..bde924968cd2 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1853,17 +1853,15 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
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
@@ -1992,7 +1990,6 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 
  out:
 	ieee80211_led_rx(rx->local);
- out_no_led:
 	if (rx->sta)
 		rx->sta->rx_stats.packets++;
 	return RX_CONTINUE;
-- 
2.30.2

