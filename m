Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFB930DAC5
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 14:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbhBCNOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 08:14:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbhBCNOQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 08:14:16 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178DAC0613D6
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 05:13:36 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id m1so5189215wml.2
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 05:13:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=f60+WgcNyeXJlxMaCb+V4GQ7soQ9kBKD34a4oS4TIGU=;
        b=FQXZReHEBQgf71+AyMQ/AvOjm1YC/ZbCiz1b0uWQadCOOd48/TpElkS8iM7/7fn03M
         OWjdyvI9a3JijMxN8JkRrT04sbs3Ein+svx4LvYYLkIja45S4dKWeKIjHTzWaQgXmEOt
         nYensxLf1yz3t6hvhFLuVzGoqi8v4U+t+62FxPyi5tTUbL7M08BzGHglIf/k1c5o9zAl
         Gg0hvNooNM0YxctQN4fsUPhlSXHWJHoij+P1coc3bDvgPaLd0hnxEAdtjiKJ3N4f5d9o
         RDayzp5i8UTt1YTWDioK32AtMpJddaz0WiW9MUbxjoEap5z9CjiB1gpzTybUCtDIeLiC
         wdwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=f60+WgcNyeXJlxMaCb+V4GQ7soQ9kBKD34a4oS4TIGU=;
        b=UDsaS49Lm7DeT1gH+6M9gYMG2sEMYStwwrcD55RNUYTII12Dfs/yUMiVa2LgQCBPjf
         6ScVxBkgrvPNWS0CgILdj093wd48bcVTFtsWsVKaMlSp+2jXPEh5dcjU0mjJbx8Oh+VL
         XJTSie7anq86pc+Yd2yKtA1/aEtaSay5myig4czakfowvRCTIy62P8p8+0UOithm4/hT
         806DSf7uJJvtTBAM0HBlgdj2jcjhrQ8pOpp9mvm/hYxxRtPtOqP9ibZKsymFhbB9QI5N
         Mq47Yb6w+OlQ84U/UZ9G3eQqMpRBHhccfxDtOPww3iWwIuA4na92ygOYgkvDgw/V0Veo
         hV0A==
X-Gm-Message-State: AOAM530kKBei6SStNYQAINJ5OL6LK1Rs3wwogUu7rY+nzeFmUesN0x3k
        SoCmYbL5M+wUh0YDZpAsH6tABQ==
X-Google-Smtp-Source: ABdhPJwUy187zJbNvUIhSH1xFrlq9uA7p1TxjsVQJuo3Xim0ncJP0BBRuNZTClWWtqkot03Ho3g0qA==
X-Received: by 2002:a1c:6a02:: with SMTP id f2mr2862448wmc.36.1612358014727;
        Wed, 03 Feb 2021 05:13:34 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id l14sm3852472wrq.87.2021.02.03.05.13.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Feb 2021 05:13:34 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     willemdebruijn.kernel@gmail.com, netdev@vger.kernel.org,
        stranche@codeaurora.org, subashab@codeaurora.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v3 1/2] net: mhi-net: Add de-aggeration support
Date:   Wed,  3 Feb 2021 14:21:15 +0100
Message-Id: <1612358476-19556-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When device side MTU is larger than host side MTU, the packets
(typically rmnet packets) are split over multiple MHI transfers.
In that case, fragments must be re-aggregated to recover the packet
before forwarding to upper layer.

A fragmented packet result in -EOVERFLOW MHI transaction status for
each of its fragments, except the final one. Such transfer was
previously considered as error and fragments were simply dropped.

This change adds re-aggregation mechanism using skb chaining, via
skb frag_list.

A warning (once) is printed since this behavior usually comes from
a misconfiguration of the device (e.g. modem MTU).

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 v2: use zero-copy skb chaining instead of skb_copy_expand.
 v3: Fix nit in commit msg + remove misleading inline comment for frag_list

 drivers/net/mhi_net.c | 74 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 64 insertions(+), 10 deletions(-)

diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
index 4f512531..8800991 100644
--- a/drivers/net/mhi_net.c
+++ b/drivers/net/mhi_net.c
@@ -32,6 +32,8 @@ struct mhi_net_stats {
 struct mhi_net_dev {
 	struct mhi_device *mdev;
 	struct net_device *ndev;
+	struct sk_buff *skbagg_head;
+	struct sk_buff *skbagg_tail;
 	struct delayed_work rx_refill;
 	struct mhi_net_stats stats;
 	u32 rx_queue_sz;
@@ -132,6 +134,32 @@ static void mhi_net_setup(struct net_device *ndev)
 	ndev->tx_queue_len = 1000;
 }
 
+static struct sk_buff *mhi_net_skb_agg(struct mhi_net_dev *mhi_netdev,
+				       struct sk_buff *skb)
+{
+	struct sk_buff *head = mhi_netdev->skbagg_head;
+	struct sk_buff *tail = mhi_netdev->skbagg_tail;
+
+	/* This is non-paged skb chaining using frag_list */
+	if (!head) {
+		mhi_netdev->skbagg_head = skb;
+		return skb;
+	}
+
+	if (!skb_shinfo(head)->frag_list)
+		skb_shinfo(head)->frag_list = skb;
+	else
+		tail->next = skb;
+
+	head->len += skb->len;
+	head->data_len += skb->len;
+	head->truesize += skb->truesize;
+
+	mhi_netdev->skbagg_tail = skb;
+
+	return mhi_netdev->skbagg_head;
+}
+
 static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
 				struct mhi_result *mhi_res)
 {
@@ -142,19 +170,42 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
 	free_desc_count = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
 
 	if (unlikely(mhi_res->transaction_status)) {
-		dev_kfree_skb_any(skb);
-
-		/* MHI layer stopping/resetting the DL channel */
-		if (mhi_res->transaction_status == -ENOTCONN)
+		switch (mhi_res->transaction_status) {
+		case -EOVERFLOW:
+			/* Packet can not fit in one MHI buffer and has been
+			 * split over multiple MHI transfers, do re-aggregation.
+			 * That usually means the device side MTU is larger than
+			 * the host side MTU/MRU. Since this is not optimal,
+			 * print a warning (once).
+			 */
+			netdev_warn_once(mhi_netdev->ndev,
+					 "Fragmented packets received, fix MTU?\n");
+			skb_put(skb, mhi_res->bytes_xferd);
+			mhi_net_skb_agg(mhi_netdev, skb);
+			break;
+		case -ENOTCONN:
+			/* MHI layer stopping/resetting the DL channel */
+			dev_kfree_skb_any(skb);
 			return;
-
-		u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
-		u64_stats_inc(&mhi_netdev->stats.rx_errors);
-		u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
+		default:
+			/* Unknown error, simply drop */
+			dev_kfree_skb_any(skb);
+			u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
+			u64_stats_inc(&mhi_netdev->stats.rx_errors);
+			u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
+		}
 	} else {
+		skb_put(skb, mhi_res->bytes_xferd);
+
+		if (mhi_netdev->skbagg_head) {
+			/* Aggregate the final fragment */
+			skb = mhi_net_skb_agg(mhi_netdev, skb);
+			mhi_netdev->skbagg_head = NULL;
+		}
+
 		u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
 		u64_stats_inc(&mhi_netdev->stats.rx_packets);
-		u64_stats_add(&mhi_netdev->stats.rx_bytes, mhi_res->bytes_xferd);
+		u64_stats_add(&mhi_netdev->stats.rx_bytes, skb->len);
 		u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
 
 		switch (skb->data[0] & 0xf0) {
@@ -169,7 +220,6 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
 			break;
 		}
 
-		skb_put(skb, mhi_res->bytes_xferd);
 		netif_rx(skb);
 	}
 
@@ -267,6 +317,7 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
 	dev_set_drvdata(dev, mhi_netdev);
 	mhi_netdev->ndev = ndev;
 	mhi_netdev->mdev = mhi_dev;
+	mhi_netdev->skbagg_head = NULL;
 	SET_NETDEV_DEV(ndev, &mhi_dev->dev);
 	SET_NETDEV_DEVTYPE(ndev, &wwan_type);
 
@@ -301,6 +352,9 @@ static void mhi_net_remove(struct mhi_device *mhi_dev)
 
 	mhi_unprepare_from_transfer(mhi_netdev->mdev);
 
+	if (mhi_netdev->skbagg_head)
+		kfree_skb(mhi_netdev->skbagg_head);
+
 	free_netdev(mhi_netdev->ndev);
 }
 
-- 
2.7.4

