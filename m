Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5124230C510
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 17:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236128AbhBBQLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 11:11:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236104AbhBBQJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 11:09:10 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F01C0613D6
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 08:08:29 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id e15so2799625wme.0
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 08:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=I72tFhBGRzGArbTD6liOesUdXAfRQUF4SchJqYsqSSM=;
        b=O4nU54pILwA7XAPfd5F+ifqTrR/mODJtHpYiPNUe9lHg2joI+6OzA06BERZIGwPr/Z
         9+MQWKjRnXVXe03S5lF3yRUReiiyBC+qhrZ9jJacIAYqnzsQzejvDXzza1EqFsA2txPf
         SMIIUw50ntFy0gzYFCyhaMCo1gSU6oukmZUcGabyQSoz7C+TE8jY0E/UCKRN7E08pzST
         c29VV7SC6mFuX2SnMukM/+L0GMFEu/q4tYqD9HACOI4RmzXuuCuvKAcQxEbfyo/y/VgY
         R1LcIYhl2+U33LzkuGma5gIXAWtKKlDBBiQSVZt8UMUT3F5YJH1rx3moRlGaMo0KOtOT
         4P7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=I72tFhBGRzGArbTD6liOesUdXAfRQUF4SchJqYsqSSM=;
        b=oflGmOgs5sY05l5lMC0x9FE4109k+XCZte57OBW+Y9aLFkMb1uzFmNrownOhFu3lVO
         Qf6yxwgqwb7MEk4ywKaY5a4IZqYT6+8KHFsC51bHv+A2TSW/OTeCZ1jy1wHx88Nzguw3
         hazQum9D4frROeX2Fgvw0Tm1EKehWYBw4wMOqGz+dlWk/w3yhGuEDBJn94uiOAJWH5pO
         L9jNieCvbvLHbWJKUtKDeIwck7H0OjYQ7CogkcTog3VSKCGYUMUomALd72ZZtMXSDxOg
         Ocj+sn9WbP6FGmM+I+CdPIRXxFCQSXpc2fJWt6qcfcAxiUmhYuWP63FV5vHWD3kn5I5g
         BwsA==
X-Gm-Message-State: AOAM533wzSgYjULLy6Gu9oDxu1MSYyXjibDsOAlq2rZRFRiF8UzB/y4s
        ziLL3rkir/ICPJwW8sFnTAF1Rg==
X-Google-Smtp-Source: ABdhPJyWGF3mRVNqMw2qu8cYlSs0uenZ2JvR+eLUpLiAHxuUnSwbx8o6p2KzvQxlf4YBXP+K1V+bmQ==
X-Received: by 2002:a1c:408a:: with SMTP id n132mr4273380wma.86.1612282107920;
        Tue, 02 Feb 2021 08:08:27 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id y6sm3900491wma.19.2021.02.02.08.08.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Feb 2021 08:08:27 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     willemdebruijn.kernel@gmail.com, netdev@vger.kernel.org,
        stranche@codeaurora.org, subashab@codeaurora.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v2 1/2] net: mhi-net: Add de-aggeration support
Date:   Tue,  2 Feb 2021 17:16:07 +0100
Message-Id: <1612282568-14094-1-git-send-email-loic.poulain@linaro.org>
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
previoulsy considered as error and fragments were simply dropped.

This change adds re-aggregation mechanism using skb chaining, via
skb frag_list.

A warning (once) is printed since this behavior usually comes from
a misconfiguration of the device (e.g. modem MTU).

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 v2: use zero-copy skb chaining instead of skb_copy_expand.

 drivers/net/mhi_net.c | 79 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 69 insertions(+), 10 deletions(-)

diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
index 4f512531..be39779 100644
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
@@ -132,6 +134,37 @@ static void mhi_net_setup(struct net_device *ndev)
 	ndev->tx_queue_len = 1000;
 }
 
+static struct sk_buff *mhi_net_skb_agg(struct mhi_net_dev *mhi_netdev,
+				       struct sk_buff *skb)
+{
+	struct sk_buff *head = mhi_netdev->skbagg_head;
+	struct sk_buff *tail = mhi_netdev->skbagg_tail;
+
+	/* This is non-paged skb chaining using frag_list */
+
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
+	/* data_len is normally the size of paged data, in our case there is no
+	 * paged data (nr_frags = 0), so it represents the size of chained skbs,
+	 * This way, net core will consider skb->frag_list.
+	 */
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
@@ -142,19 +175,42 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
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
@@ -169,7 +225,6 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
 			break;
 		}
 
-		skb_put(skb, mhi_res->bytes_xferd);
 		netif_rx(skb);
 	}
 
@@ -267,6 +322,7 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
 	dev_set_drvdata(dev, mhi_netdev);
 	mhi_netdev->ndev = ndev;
 	mhi_netdev->mdev = mhi_dev;
+	mhi_netdev->skbagg_head = NULL;
 	SET_NETDEV_DEV(ndev, &mhi_dev->dev);
 	SET_NETDEV_DEVTYPE(ndev, &wwan_type);
 
@@ -301,6 +357,9 @@ static void mhi_net_remove(struct mhi_device *mhi_dev)
 
 	mhi_unprepare_from_transfer(mhi_netdev->mdev);
 
+	if (mhi_netdev->skbagg_head)
+		kfree_skb(mhi_netdev->skbagg_head);
+
 	free_netdev(mhi_netdev->ndev);
 }
 
-- 
2.7.4

