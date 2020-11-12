Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7BA2B038F
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 12:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbgKLLKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 06:10:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728041AbgKLLKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 06:10:33 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AABC4C0613D1;
        Thu, 12 Nov 2020 03:10:23 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id j7so5575736wrp.3;
        Thu, 12 Nov 2020 03:10:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Tv2bEm0sLbKGDjq3ZdSLJlA91Mcgn0WBp+SI+MmrFWo=;
        b=qP+ccKushbGl1w9gFlfW/TFVWTruI1fOPPvl5CstaEEpOrfSJzvTbTEZFEfXnKKkcR
         Xmu4Y282dYXykJ7v8WmgPZ51FXcvoq5/da22NmtfmTvjbdhs0P7z/HQHt7ZVuJjZRKql
         HMtGjRk6g6LItj/7tZiEFYm0p9XofEAZbqKMwf5Nu7k5PobzYGbPpGdrUA6hXNEYlp9O
         0KJIFwx2ygIYC98SPkHuFZU6UU0VLkKv8Xz3nzcZZF18ljSs9V7kQNHFJ2I9+4uWlfR6
         JykDCe667HtNgblqB9UPdLtXkdR0YaKFrja5gvihKBGFL8X+8AjZr8K7QEIgcj4gopEN
         Nwvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Tv2bEm0sLbKGDjq3ZdSLJlA91Mcgn0WBp+SI+MmrFWo=;
        b=pLcoynh8fxS1ZKvFYgv18x25iS/lF0y8XSMgsL24KQlld8FWP9kHQSHZBP3vGDP2H9
         ichlo60Sar1XafeJjNHyA0U7m2TAjl+J9gy9vD4Txir8iigANvPe1orpgsLRMCfkekCX
         eZ1ysfVtyiZFK92GBKIhxxr2fXKmq5zkH2FkGncGSUlWxwCVPp86ghCHH3/9Os8oYC6R
         iv+9IkVFR66MRpAObkWaKyvcW/iJ+ukfU6a1323wTJx/mNbd54/+OjSqWqlIQxVRItn0
         xUFtmZ8LY4I2vU6RfjalC3e5Xx1Mjtj2jpqZ4CwNUvsbVdeYvQPsVbWeJ0mp/0ob6RVL
         8F5A==
X-Gm-Message-State: AOAM533ikHhu9hExoOeun9+Gb7e0E2px4rUtDJqOVTxS5vVhw8HnArvg
        l7q61dBXQonBmpOTzNRYdqg=
X-Google-Smtp-Source: ABdhPJxGN6E9FoAvVu/8ZH/CM2S5uZc0sFap77Uit1MN2Yku34dNzb315nGIhPSRi4bW8XbI25hQSw==
X-Received: by 2002:a5d:514a:: with SMTP id u10mr13153774wrt.312.1605179422360;
        Thu, 12 Nov 2020 03:10:22 -0800 (PST)
Received: from ubux1.panoulu.local ([2a00:1d50:3:0:1cd1:d2e:7b13:dc30])
        by smtp.gmail.com with ESMTPSA id v67sm6505315wma.17.2020.11.12.03.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 03:10:21 -0800 (PST)
From:   Lev Stipakov <lstipakov@gmail.com>
X-Google-Original-From: Lev Stipakov <lev@openvpn.net>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Lev Stipakov <lev@openvpn.net>
Subject: [PATCH 1/3] net: mac80211: use core API for updating TX stats
Date:   Thu, 12 Nov 2020 13:09:53 +0200
Message-Id: <20201112110953.34055-1-lev@openvpn.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit d3fd65484c781 ("net: core: add dev_sw_netstats_tx_add")
has added function "dev_sw_netstats_tx_add()" to update
net device per-cpu TX stats.

Use this function instead of ieee80211_tx_stats().

Signed-off-by: Lev Stipakov <lev@openvpn.net>
---
 net/mac80211/tx.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 5f05f4651dd7..7807f8178527 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -38,16 +38,6 @@
 
 /* misc utils */
 
-static inline void ieee80211_tx_stats(struct net_device *dev, u32 len)
-{
-	struct pcpu_sw_netstats *tstats = this_cpu_ptr(dev->tstats);
-
-	u64_stats_update_begin(&tstats->syncp);
-	tstats->tx_packets++;
-	tstats->tx_bytes += len;
-	u64_stats_update_end(&tstats->syncp);
-}
-
 static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 				 struct sk_buff *skb, int group_addr,
 				 int next_frag_len)
@@ -3403,7 +3393,7 @@ static void ieee80211_xmit_fast_finish(struct ieee80211_sub_if_data *sdata,
 	if (key)
 		info->control.hw_key = &key->conf;
 
-	ieee80211_tx_stats(skb->dev, skb->len);
+	dev_sw_netstats_tx_add(skb->dev, 1, skb->len);
 
 	if (hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) {
 		tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
@@ -4021,7 +4011,7 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 			goto out;
 		}
 
-		ieee80211_tx_stats(dev, skb->len);
+		dev_sw_netstats_tx_add(dev, 1, skb->len);
 
 		ieee80211_xmit(sdata, sta, skb);
 	}
@@ -4248,7 +4238,7 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 
 	info->hw_queue = sdata->vif.hw_queue[skb_get_queue_mapping(skb)];
 
-	ieee80211_tx_stats(dev, skb->len);
+	dev_sw_netstats_tx_add(dev, 1, skb->len);
 
 	sta->tx_stats.bytes[skb_get_queue_mapping(skb)] += skb->len;
 	sta->tx_stats.packets[skb_get_queue_mapping(skb)]++;
-- 
2.25.1

