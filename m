Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5020629140C
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 21:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437990AbgJQTI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 15:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437462AbgJQTI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 15:08:28 -0400
Received: from rhcavuit01.kulnet.kuleuven.be (rhcavuit01.kulnet.kuleuven.be [IPv6:2a02:2c40:0:c0::25:129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B3FC061755
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 12:08:27 -0700 (PDT)
X-KULeuven-Envelope-From: mathy.vanhoef@kuleuven.be
X-Spam-Status: not spam, SpamAssassin (not cached, score=-51, required 5,
        autolearn=disabled, ALL_TRUSTED -1.00, LOCAL_SMTPS -50.00)
X-KULeuven-Scanned: Found to be clean
X-KULeuven-ID: 2B3C1120002.AD9C6
X-KULeuven-Information: Katholieke Universiteit Leuven
Received: from icts-p-smtps-1.cc.kuleuven.be (icts-p-smtps-1e.kulnet.kuleuven.be [134.58.240.33])
        by rhcavuit01.kulnet.kuleuven.be (Postfix) with ESMTP id 2B3C1120002
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 21:08:23 +0200 (CEST)
Received: from mathy-work.localhost (unknown [31.215.199.82])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by icts-p-smtps-1.cc.kuleuven.be (Postfix) with ESMTPSA id 6924140B2;
        Sat, 17 Oct 2020 21:08:21 +0200 (CEST)
Date:   Sat, 17 Oct 2020 23:08:18 +0400
X-Kuleuven: This mail passed the K.U.Leuven mailcluster
From:   Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
To:     Thomas Deutschmann <whissi@gentoo.org>
Cc:     <johannes@sipsolutions.net>,
        "davem@davemloft.net" <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <denkenz@gmail.com>
Subject: Re: [Regression 5.9][Bisected 1df2bdba528b] Wifi GTK rekeying
 fails: Sending of EAPol packages broken
Message-ID: <20201017230818.04896494@mathy-work.localhost>
In-Reply-To: <4a7f92dc-13bb-697f-1730-ac288e74b730@gentoo.org>
References: <4a7f92dc-13bb-697f-1730-ac288e74b730@gentoo.org>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've managed to reproduce the issue, or at least a related issue. Can
you try the draft patch below and see if that fixes it?

[PATCH] mac80211: fix regression where EAPOL frames were sent in plaintext

When sending EAPOL frames via NL80211 they are treated as injected
frames in mac80211. Due to commit 1df2bdba528b ("mac80211: never drop
injected frames even if normally not allowed") these injected frames
were not assigned a sta context in the function ieee80211_tx_dequeue,
causing certain wireless network cards to always send EAPOL frames in
plaintext. This may cause compatibility issues with some clients or
APs, which for instance can cause the group key handshake to fail and
in turn would cause the station to get disconnected.

This commit fixes this regression by assigning a sta context in
ieee80211_tx_dequeue to injected frames as well.

Note that sending EAPOL frames in plaintext is not a security issue
since they contain their own encryption and authentication protection.

Fixes: 1df2bdba528b ("mac80211: never drop injected frames even if normally not allowed")
---
 net/mac80211/tx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8ba10a48d..55b41167a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3619,13 +3619,14 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	tx.skb = skb;
 	tx.sdata = vif_to_sdata(info->control.vif);
 
-	if (txq->sta && !(info->flags & IEEE80211_TX_CTL_INJECTED)) {
+	if (txq->sta) {
 		tx.sta = container_of(txq->sta, struct sta_info, sta);
 		/*
 		 * Drop unicast frames to unauthorised stations unless they are
-		 * EAPOL frames from the local station.
+		 * injected frames or EAPOL frames from the local station.
 		 */
-		if (unlikely(ieee80211_is_data(hdr->frame_control) &&
+		if (unlikely(!(info->flags & IEEE80211_TX_CTL_INJECTED) &&
+			     ieee80211_is_data(hdr->frame_control) &&
 			     !ieee80211_vif_is_mesh(&tx.sdata->vif) &&
 			     tx.sdata->vif.type != NL80211_IFTYPE_OCB &&
 			     !is_multicast_ether_addr(hdr->addr1) &&
-- 
2.28.0
