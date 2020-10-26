Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0AB329A1A1
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 01:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438092AbgJ0AnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 20:43:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:50406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409165AbgJZXul (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 19:50:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 053932075B;
        Mon, 26 Oct 2020 23:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756240;
        bh=3Tid0z77FOPAKyxCArbwfdFzfiDVOeZwGFliCQNSh2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BKOQG7FP4Ot69BcztMBtvhg7cVIaG2KpLQTEaKD92WH7Nc7teAEBb5OkH4ssphZBV
         2oE+AEuqiboyzsGZ7OoDcgIOhjky8SkT/fUhQHh7OPfTiaPcvbO9NCi5FX/0J+5gdW
         lJ+gNBTSOx/HomicA13dxE2Pubc1Fx+OF1CnmKqY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 077/147] mac80211: add missing queue/hash initialization to 802.3 xmit
Date:   Mon, 26 Oct 2020 19:47:55 -0400
Message-Id: <20201026234905.1022767-77-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 5f8d69eaab1915df97f4f2aca89ea16abdd092d5 ]

Fixes AQL for encap-offloaded tx

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20200908123702.88454-2-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index dca01d7e6e3e0..282b0bc201eeb 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4209,6 +4209,12 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 	if (is_zero_ether_addr(ra))
 		goto out_free;
 
+	if (local->ops->wake_tx_queue) {
+		u16 queue = __ieee80211_select_queue(sdata, sta, skb);
+		skb_set_queue_mapping(skb, queue);
+		skb_get_hash(skb);
+	}
+
 	multicast = is_multicast_ether_addr(ra);
 
 	if (sta)
-- 
2.25.1

