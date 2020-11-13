Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2C92B179F
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 09:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgKMI6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 03:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgKMI6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 03:58:30 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0980C0613D1;
        Fri, 13 Nov 2020 00:58:29 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id d17so12668495lfq.10;
        Fri, 13 Nov 2020 00:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dE6n68pZBqNt+HCNDaadMxbINtAfMsObNj3MEOOC+jQ=;
        b=PBqW1E3s4OZ2h7SJm8jjWmn1KNTSX7HlSMBBN3H8HKcR7vCf505vrneKsCpGCmhy0l
         5kyTl3+cTHQs2KwtRWhz2u1Y8DDIX7Mq3W7E3EAXvFt10RpI/vv6D1UMXBM2asA7Hx3P
         ez3CXd9DOrW+I8ACqrYwc2m/uVj4a/MfflP00xjUfJK0pZ7ah8IeeqKpxlYSCXatwT6o
         9ZbfBRnjgk5IHdOWjr5TtUKB50PYtjmj2H75V+oJPwcwpc/8vrOIFR07Pxa2nyF73rsi
         YzVxs1PbGj5gyPFEbvJJntdIYt4PA+MgaZ7L89wjThjfhjwxpyqh6s3ERfbd9IYVTGg3
         gaAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dE6n68pZBqNt+HCNDaadMxbINtAfMsObNj3MEOOC+jQ=;
        b=p6yMDhg03Sc6x+9NZ/yTJN1s//jMmrLFGZ3HIc/piHT33+OdSazpqhWpFMRRrLzBYe
         C0zB/LmjYHA2G40/7nyZnodY3UIIF81FjE0CrgFyDojq5fsQdmrWNa875KjSLSLcACsq
         kfVvLaFfNNeKNlVJ+YhtXDjo6Zt5EFFOkGBKGrExsiBrZXQMAb3bIm2TWFG3A1mUjsqN
         6puGBqDbHZ+ONBfps2qC+jpmq576a8IBaWOtgvovqdIcPVZ2MDwpsu2qtxciYk46u/4N
         NsTcxIi7/C83YLHjzcBS2cQdyWqxaiJlZJzCDgBtF1Lb+B7+T5cyVLWh8zXrVP4hrHFk
         lqbg==
X-Gm-Message-State: AOAM532kIO+fa9KLE/xPe5lXIxeOiPU+FMKCHB5h/29L5XjhupqXSJ2m
        lY8KtTrHBCywUvbU7qD53g4=
X-Google-Smtp-Source: ABdhPJx3Rj6vyw0vveV1qgM0Zt/wsafsw8dFdRc1x1SLCvsJhb8LmeSbl7hMYYKKGOE8n90I8+sizg==
X-Received: by 2002:a05:6512:304b:: with SMTP id b11mr439560lfb.546.1605257908110;
        Fri, 13 Nov 2020 00:58:28 -0800 (PST)
Received: from localhost.localdomain (dmjt96jhvbz3j2f08hy-4.rev.dnainternet.fi. [2001:14bb:51:e1dd:1cd1:d2e:7b13:dc30])
        by smtp.gmail.com with ESMTPSA id q13sm295520lfn.15.2020.11.13.00.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 00:58:27 -0800 (PST)
From:   Lev Stipakov <lstipakov@gmail.com>
X-Google-Original-From: Lev Stipakov <lev@openvpn.net>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.ke, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Lev Stipakov <lev@openvpn.net>
Subject: [PATCH v2 1/3] net: mac80211: use core API for updating TX/RX stats
Date:   Fri, 13 Nov 2020 10:58:04 +0200
Message-Id: <20201113085804.115806-1-lev@openvpn.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <44c8b5ae-3630-9d98-1ab4-5f57bfe0886c@gmail.com>
References: <44c8b5ae-3630-9d98-1ab4-5f57bfe0886c@gmail.com>
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
---
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

