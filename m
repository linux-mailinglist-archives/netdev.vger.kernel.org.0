Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F2C2ACD39
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 05:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387734AbgKJEAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 23:00:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:57584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387406AbgKJDzz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 22:55:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0915320870;
        Tue, 10 Nov 2020 03:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980554;
        bh=QDl6ZGTPmYEEeILA0AcjUgmPYYSeYYTVzSyeHeQ9+lY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nnyZEY+bmZijQJet0rLJHcBMj1Nb1S34QcjPeQpbzeq0XeOTzT6ld+2mvIHdd2S6Q
         FLbS8WlxLXWl8cDGTg4K6UXJ0Ijo19TGPKm/V0VCkP3yBHSiu10tB0O+BPlgOgk6Ea
         lvh9eRRbvtFf81wYWvs5zAXWjJ4+GlDdqjDY3ico=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        syzbot+32fd1a1bfe355e93f1e2@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 10/21] mac80211: fix use of skb payload instead of header
Date:   Mon,  9 Nov 2020 22:55:30 -0500
Message-Id: <20201110035541.424648-10-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035541.424648-1-sashal@kernel.org>
References: <20201110035541.424648-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 14f46c1e5108696ec1e5a129e838ecedf108c7bf ]

When ieee80211_skb_resize() is called from ieee80211_build_hdr()
the skb has no 802.11 header yet, in fact it consist only of the
payload as the ethernet frame is removed. As such, we're using
the payload data for ieee80211_is_mgmt(), which is of course
completely wrong. This didn't really hurt us because these are
always data frames, so we could only have added more tailroom
than we needed if we determined it was a management frame and
sdata->crypto_tx_tailroom_needed_cnt was false.

However, syzbot found that of course there need not be any payload,
so we're using at best uninitialized memory for the check.

Fix this to pass explicitly the kind of frame that we have instead
of checking there, by replacing the "bool may_encrypt" argument
with an argument that can carry the three possible states - it's
not going to be encrypted, it's a management frame, or it's a data
frame (and then we check sdata->crypto_tx_tailroom_needed_cnt).

Reported-by: syzbot+32fd1a1bfe355e93f1e2@syzkaller.appspotmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20201009132538.e1fd7f802947.I799b288466ea2815f9d4c84349fae697dca2f189@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3160ffd93a153..98d048630ad2f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1908,19 +1908,24 @@ static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 
 /* device xmit handlers */
 
+enum ieee80211_encrypt {
+	ENCRYPT_NO,
+	ENCRYPT_MGMT,
+	ENCRYPT_DATA,
+};
+
 static int ieee80211_skb_resize(struct ieee80211_sub_if_data *sdata,
 				struct sk_buff *skb,
-				int head_need, bool may_encrypt)
+				int head_need,
+				enum ieee80211_encrypt encrypt)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_hdr *hdr;
 	bool enc_tailroom;
 	int tail_need = 0;
 
-	hdr = (struct ieee80211_hdr *) skb->data;
-	enc_tailroom = may_encrypt &&
-		       (sdata->crypto_tx_tailroom_needed_cnt ||
-			ieee80211_is_mgmt(hdr->frame_control));
+	enc_tailroom = encrypt == ENCRYPT_MGMT ||
+		       (encrypt == ENCRYPT_DATA &&
+			sdata->crypto_tx_tailroom_needed_cnt);
 
 	if (enc_tailroom) {
 		tail_need = IEEE80211_ENCRYPT_TAILROOM;
@@ -1952,23 +1957,29 @@ void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_hdr *hdr;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	int headroom;
-	bool may_encrypt;
+	enum ieee80211_encrypt encrypt;
 
-	may_encrypt = !(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT);
+	if (info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT)
+		encrypt = ENCRYPT_NO;
+	else if (ieee80211_is_mgmt(hdr->frame_control))
+		encrypt = ENCRYPT_MGMT;
+	else
+		encrypt = ENCRYPT_DATA;
 
 	headroom = local->tx_headroom;
-	if (may_encrypt)
+	if (encrypt != ENCRYPT_NO)
 		headroom += sdata->encrypt_headroom;
 	headroom -= skb_headroom(skb);
 	headroom = max_t(int, 0, headroom);
 
-	if (ieee80211_skb_resize(sdata, skb, headroom, may_encrypt)) {
+	if (ieee80211_skb_resize(sdata, skb, headroom, encrypt)) {
 		ieee80211_free_txskb(&local->hw, skb);
 		return;
 	}
 
+	/* reload after potential resize */
 	hdr = (struct ieee80211_hdr *) skb->data;
 	info->control.vif = &sdata->vif;
 
@@ -2751,7 +2762,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 		head_need += sdata->encrypt_headroom;
 		head_need += local->tx_headroom;
 		head_need = max_t(int, 0, head_need);
-		if (ieee80211_skb_resize(sdata, skb, head_need, true)) {
+		if (ieee80211_skb_resize(sdata, skb, head_need, ENCRYPT_DATA)) {
 			ieee80211_free_txskb(&local->hw, skb);
 			skb = NULL;
 			return ERR_PTR(-ENOMEM);
@@ -3414,7 +3425,7 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 	if (unlikely(ieee80211_skb_resize(sdata, skb,
 					  max_t(int, extra_head + hw_headroom -
 						     skb_headroom(skb), 0),
-					  false))) {
+					  ENCRYPT_NO))) {
 		kfree_skb(skb);
 		return true;
 	}
-- 
2.27.0

