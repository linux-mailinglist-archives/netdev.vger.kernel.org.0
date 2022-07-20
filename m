Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74D3D57AC9E
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 03:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241615AbiGTBX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 21:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241675AbiGTBWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 21:22:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B43B67144;
        Tue, 19 Jul 2022 18:17:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C151E6172D;
        Wed, 20 Jul 2022 01:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4667C341D1;
        Wed, 20 Jul 2022 01:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279819;
        bh=/fb8vtfQRozwqQiS5OqvC6iJ02kgabjZgSoHNXfNz9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aRDM7LqXihBvGpmG+KvDp4HJRPuZB4QNZEBlHFNE0So6qh7Yb0LlNE9Icn0JppjGq
         s7d5YU37LtAAjAzliwb3LLGQVRQRFA/m27OtMajVsPWsomJLb9KVI7c6IUf1KgqRBJ
         if39tLq57H4vOa0MqzzWaJaCUbmdCptRmwMJuoLWGHEkTstkAIldhszcx/N+0uUD+w
         PqEs7eaivPQxTvhii1Sn/IFIk7U85MmWHhFhtjX/JHznmIwzx6sOk6BxR0mBSiNcwc
         AbBHdK+A6v19LpWfLluNM5XfXr+trc1Lw1gNzdirGf2ca83BIl3OgqPlXZuabSxYmw
         bjN8qDD8fSWhg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ryder Lee <ryder.lee@mediatek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 10/25] wifi: mac80211: check skb_shared in ieee80211_8023_xmit()
Date:   Tue, 19 Jul 2022 21:16:01 -0400
Message-Id: <20220720011616.1024753-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011616.1024753-1-sashal@kernel.org>
References: <20220720011616.1024753-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit a4926abb787e2ef3ee2997e6ca8844d859478647 ]

Add a missing skb_shared check into 802.3 path to prevent potential
use-after-free from happening. This also uses skb_share_check()
instead of open-coding in tx path.

Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Link: https://lore.kernel.org/r/e7a73aaf7742b17e43421c56625646dfc5c4d2cb.1653571902.git.ryder.lee@mediatek.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index bbbcc678c655..36e1eb9b2fff 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2811,19 +2811,10 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	/*
 	 * If the skb is shared we need to obtain our own copy.
 	 */
-	if (skb_shared(skb)) {
-		struct sk_buff *tmp_skb = skb;
-
-		/* can't happen -- skb is a clone if info_id != 0 */
-		WARN_ON(info_id);
-
-		skb = skb_clone(skb, GFP_ATOMIC);
-		kfree_skb(tmp_skb);
-
-		if (!skb) {
-			ret = -ENOMEM;
-			goto free;
-		}
+	skb = skb_share_check(skb, GFP_ATOMIC);
+	if (unlikely(!skb)) {
+		ret = -ENOMEM;
+		goto free;
 	}
 
 	hdr.frame_control = fc;
@@ -3526,15 +3517,9 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 
 	/* after this point (skb is modified) we cannot return false */
 
-	if (skb_shared(skb)) {
-		struct sk_buff *tmp_skb = skb;
-
-		skb = skb_clone(skb, GFP_ATOMIC);
-		kfree_skb(tmp_skb);
-
-		if (!skb)
-			return true;
-	}
+	skb = skb_share_check(skb, GFP_ATOMIC);
+	if (unlikely(!skb))
+		return true;
 
 	if ((hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) &&
 	    ieee80211_amsdu_aggregate(sdata, sta, fast_tx, skb))
@@ -4244,7 +4229,7 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 				struct net_device *dev, struct sta_info *sta,
 				struct ieee80211_key *key, struct sk_buff *skb)
 {
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_tx_info *info;
 	struct ieee80211_local *local = sdata->local;
 	struct tid_ampdu_tx *tid_tx;
 	u8 tid;
@@ -4259,6 +4244,11 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 	    test_bit(SDATA_STATE_OFFCHANNEL, &sdata->state))
 		goto out_free;
 
+	skb = skb_share_check(skb, GFP_ATOMIC);
+	if (unlikely(!skb))
+		return;
+
+	info = IEEE80211_SKB_CB(skb);
 	memset(info, 0, sizeof(*info));
 
 	tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
-- 
2.35.1

