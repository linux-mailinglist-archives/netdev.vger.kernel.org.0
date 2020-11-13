Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16BA2B276F
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 22:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgKMVrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 16:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgKMVrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 16:47:00 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C9EC0613D1;
        Fri, 13 Nov 2020 13:46:58 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id p22so11346162wmg.3;
        Fri, 13 Nov 2020 13:46:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WM7wpHxEkrZAO6xn8107x15fhcLgi3YQQEBhYF8p1Bg=;
        b=lESsPA20eOWHTipg7uL0lDD7NGD4DX7IBnPPoX3VHc9d8gfF/dzfE/17XwEcvE0gOn
         uZeBpJiDWIF7aMLq7iJ7JOQvSMfd6eCC7dm+yRdMLyrN8Yu4vpjgFDIWLis/mVHn+Ik8
         1unL2RuJp5wBLDvhAMAd3owojsUYH5F2wiGyIdz8DIWc5E0QJ2ugBVymE/E122CWmK0p
         YYHy9A43pDtTJ2MdF3lz7gmdRgIOhFWd6UYpbfCCl/SkFEsHUp5RvIQVyTlTSIVWFm5h
         qquONMWLc8MSS0iME9/TgkkqNOXaGFDJjGsLv+DH25kc5GueSkpjBDNK+1AHuMKmOE0f
         lgDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WM7wpHxEkrZAO6xn8107x15fhcLgi3YQQEBhYF8p1Bg=;
        b=Wi8Z2BuaOEDohw4WHuMZ4bj65kvsubBQP23FdQDuyRh97xHSPKgTVSiJS4Hn1x8cOh
         p+4UwlkUqd8o/5V8hkCOewRAf4NcP8uS88Q/VMAn7BN2CMjfGXrDzRk+kZIPOnZey3/b
         x3m8L+YDJriR9M7G4KWrPLD2fgxFUzjpYR4d55bzq57dhj6PMFTalkBXWrRwfbsYp1x9
         hYcW7WeajTPnDGbDyEv5Uvhxkw/M1yWymD2Ljaui6M5PZW8eQDdYBm7DSUxEnkf0PoME
         +cptm9D31fXoj8RiOjrqeEMb6CQZt5UqSpugjQoDLxuRs8M2H79yZJthl+SMg3Z7Bkjq
         2BnQ==
X-Gm-Message-State: AOAM532n/T7d/JKiFh2/hav8RU1kL6zDMcX9PFITtVtop2RRlC5+LjQZ
        RlAFJmkBuhlpw8BTyWGbhfk=
X-Google-Smtp-Source: ABdhPJxv4rtQE1cdHvY4i5T3x5t0eq0/Q225Y50A1KZwQjShIut1Iu0TXZbZxXsfskOOa7jOTYS23A==
X-Received: by 2002:a1c:f405:: with SMTP id z5mr4367517wma.126.1605304017589;
        Fri, 13 Nov 2020 13:46:57 -0800 (PST)
Received: from ubux1.bb.dnainternet.fi (81-175-130-136.bb.dnainternet.fi. [81.175.130.136])
        by smtp.gmail.com with ESMTPSA id k1sm8382313wrp.23.2020.11.13.13.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 13:46:57 -0800 (PST)
From:   Lev Stipakov <lstipakov@gmail.com>
X-Google-Original-From: Lev Stipakov <lev@openvpn.net>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Lev Stipakov <lev@openvpn.net>
Subject: [PATCH v3] net: mac80211: use core API for updating TX/RX stats
Date:   Fri, 13 Nov 2020 23:46:24 +0200
Message-Id: <20201113214623.144663-1-lev@openvpn.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201113133111.15516437@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201113133111.15516437@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commits

  d3fd65484c781 ("net: core: add dev_sw_netstats_tx_add")
  451b05f413d3f ("net: netdevice.h: sw_netstats_rx_add helper)

have added API to update net device per-cpu TX/RX stats.

Use core API instead of ieee80211_tx/rx_stats().

Signed-off-by: Lev Stipakov <lev@openvpn.net>
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 v3: no code changes, just send separate patch instead of series as
requested
 v2: also replace ieee80211_rx_stats() with dev_sw_netstats_rx_add()

 net/mac80211/rx.c | 18 ++++--------------
 net/mac80211/tx.c | 16 +++-------------
 2 files changed, 7 insertions(+), 27 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 09d1c9fb8872..0c1a19a93c79 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -32,16 +32,6 @@
 #include "wme.h"
 #include "rate.h"
 
-static inline void ieee80211_rx_stats(struct net_device *dev, u32 len)
-{
-	struct pcpu_sw_netstats *tstats = this_cpu_ptr(dev->tstats);
-
-	u64_stats_update_begin(&tstats->syncp);
-	tstats->rx_packets++;
-	tstats->rx_bytes += len;
-	u64_stats_update_end(&tstats->syncp);
-}
-
 /*
  * monitor mode reception
  *
@@ -842,7 +832,7 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 
 			if (skb) {
 				skb->dev = sdata->dev;
-				ieee80211_rx_stats(skb->dev, skb->len);
+				dev_sw_netstats_rx_add(skb->dev, skb->len);
 				netif_receive_skb(skb);
 			}
 		}
@@ -2560,7 +2550,7 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 	skb = rx->skb;
 	xmit_skb = NULL;
 
-	ieee80211_rx_stats(dev, skb->len);
+	dev_sw_netstats_rx_add(dev, skb->len);
 
 	if (rx->sta) {
 		/* The seqno index has the same property as needed
@@ -3699,7 +3689,7 @@ static void ieee80211_rx_cooked_monitor(struct ieee80211_rx_data *rx,
 		}
 
 		prev_dev = sdata->dev;
-		ieee80211_rx_stats(sdata->dev, skb->len);
+		dev_sw_netstats_rx_add(sdata->dev, skb->len);
 	}
 
 	if (prev_dev) {
@@ -4416,7 +4406,7 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
 
 	skb->dev = fast_rx->dev;
 
-	ieee80211_rx_stats(fast_rx->dev, skb->len);
+	dev_sw_netstats_rx_add(fast_rx->dev, skb->len);
 
 	/* The seqno index has the same property as needed
 	 * for the rx_msdu field, i.e. it is IEEE80211_NUM_TIDS
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

