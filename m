Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5015130DDB1
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 16:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233834AbhBCPKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 10:10:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234278AbhBCPIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 10:08:35 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7F5C06178B
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 07:07:55 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id g10so24745465wrx.1
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 07:07:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=qRlv3JFWFU/HIbB5VeHUwt+2xUMX5DE3/4o57Hrpdug=;
        b=SJGY8/5UNCuhghV9VRtOXOoGniTGRFuqEPlw2S6JH4/oKVfoTkQ15rJVlekd77ytYE
         trHg+uy/vYlb4r0tds3UJD9soNK11XN9gfp1+mjoGlkBwoxiobiwEsimqbpC9mVx7c/p
         I+OX7j/QLwYzOGmer6bx6txDaHAItXrMX/XtalvRH9WiBr3w5+UhHxGIQfGDoEBwQnud
         L3XYkAtd77ihLSrzkHKaMpXvyyIp/XiKjdsWg2PMCmoAEUW06ciot4XWnXAkhpiCWSlF
         eglWw7JDgxniZnVECWvc/9ZGdPA/Z6Pi2JoJU09c+x+QS8XfDsBHwfsIGRwzygC7EsO7
         WbVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qRlv3JFWFU/HIbB5VeHUwt+2xUMX5DE3/4o57Hrpdug=;
        b=f6NiZ7TnGrO2OZ52b4wOWGMLhoWcyrnvyCVYtM4u17GlfB0QPES4SbHFdRWQepjrrz
         wjoFP8alYsAjpyypiK0PfLUzXiecsH/9pj2PhqPqvBma7Hm97WIDr+eVkh4cSii1aWO5
         E557rCOsCCLk6YjTHUzZxxAdqwMPNJTBTErdHWbZdnVX9RJaCYTT7h/1VkODT5ZB7Hml
         AjuvD18WPLMsX/k9w9fvfykNGajxClYzPwLK9EPk02ocEOD43YrcJ4BR6TYE8gzf3mRY
         cy4R655PLRi/33/pMAkcorNeJJ6Mjgotwmz63gOlRUT+5lQiBK+R0Ah7ePS1DajZJ0HK
         enqg==
X-Gm-Message-State: AOAM5317Mb4LlSMgGwLOmDZanrS7+lsLEb+YESQ0o4uYdKWaPE2FvoVy
        3NZFerMwRY7rUxkZPancH7lBzngyFa51CA==
X-Google-Smtp-Source: ABdhPJwIHmARQNhxdTFDM2ePQccX4y7fX3K3nwnyS5x92N1jVugDO+RnvL77ljUuIxSjQtzZKQK16A==
X-Received: by 2002:adf:f8c8:: with SMTP id f8mr4091432wrq.132.1612364873973;
        Wed, 03 Feb 2021 07:07:53 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id r1sm3947240wrl.95.2021.02.03.07.07.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Feb 2021 07:07:53 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     willemdebruijn.kernel@gmail.com, netdev@vger.kernel.org,
        stranche@codeaurora.org, subashab@codeaurora.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v4 1/2] net: mhi-net: Add de-aggeration support
Date:   Wed,  3 Feb 2021 16:15:34 +0100
Message-Id: <1612365335-14117-1-git-send-email-loic.poulain@linaro.org>
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
 v4: no change

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

