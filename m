Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C023049F6
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731861AbhAZFTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:19:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729889AbhAYPjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 10:39:00 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C31C0613D6
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 07:38:17 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id y187so11498688wmd.3
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 07:38:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=l+n0h5ltton87s7f3eOsCp7yU1LsdlhB2Rwvyon8e+g=;
        b=to8fDsjvPU1rCGcBBLge5sn51P4AuABtUzQFfOTIGU+F2IGX2ljVG+e1IDgg5m4tVe
         agpfRqpNAw+gIwe9rOBAWEjdwkX6Ps9RmKX78dzR5tw+534dJtEu+Ab49cmuj/GIxyAC
         LpR/04zNziO1JbhIMP8zmA1Xe0/rdy517pecuaMtY1PZUy6klzuzkudZVkWAf048FnkH
         6HfDw3S4Sp9qCnBfqA374blxKpYdjuuu+B9hYANglvd73oGjT+nPj5u6MX25NEkHkc60
         0Jx4RgY+ZKkvgXhA1JEcj8SItgje9SkAMXVlCCcdfVs2ZxK1azut41BhfrjRkNEqsQUT
         5OkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=l+n0h5ltton87s7f3eOsCp7yU1LsdlhB2Rwvyon8e+g=;
        b=XVdrZ2VyIO/Ioj7uAhrk7glTt//DrtCmbIM4c0Z6DmWPcyGUNSx35uEEv6Kx4ellIX
         Eh97l7yR+a8YopGCCxbxFpgh/jOBmOjsdu2LDup92xI/2B2eHURTbh9axWDelGO80sWE
         ITnqQERebALdhWDX+Th18J070XdBWQ7rXcdf4EwmX5WnbNReliDdflHUeOe+8Mt9WEuB
         Cc9041ssnUG34AGBLn7DNeQqKfch8dT9HleVo78OwPoubETS4jiWwD2tESe+GWz6RIt4
         sdzMQySzd1JDT8P8VU/Dn3XmMEpn4yuKSnANmOUT+QS8szrueGn5gmvljvckGp/9Q+Ml
         yCIw==
X-Gm-Message-State: AOAM533gYYIdg7JM7jqTSh5+XLBUXGxOstC+wW0Y3ghZVhKlnJxUpKDL
        7NVzC6J9Qjr7A5CXz5f7OAZAZA==
X-Google-Smtp-Source: ABdhPJzLjjsRLYsGugIKp2f6BAyr51WFoMciL74YlYGIIdKZ6FHIAH/JOgkXrm45Ua9BixtMGr49aQ==
X-Received: by 2002:a1c:81cc:: with SMTP id c195mr690540wmd.70.1611589096399;
        Mon, 25 Jan 2021 07:38:16 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id v65sm23000974wme.23.2021.01.25.07.38.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Jan 2021 07:38:16 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next] net: mhi-net: Add de-aggeration support
Date:   Mon, 25 Jan 2021 16:45:57 +0100
Message-Id: <1611589557-31012-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When device side MTU is larger than host side MRU, the packets
(typically rmnet packets) are split over multiple MHI transfers.
In that case, fragments must be re-aggregated to recover the packet
before forwarding to upper layer.

A fragmented packet result in -EOVERFLOW MHI transaction status for
each of its fragments, except the final one. Such transfer was
previoulsy considered as error and fragments were simply dropped.

This patch implements the aggregation mechanism allowing to recover
the initial packet. It also prints a warning (once) since this behavior
usually comes from a misconfiguration of the device (modem).

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/mhi_net.c | 74 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 64 insertions(+), 10 deletions(-)

diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
index a5a214d..780086f 100644
--- a/drivers/net/mhi_net.c
+++ b/drivers/net/mhi_net.c
@@ -34,6 +34,7 @@ struct mhi_net_dev {
 	struct mhi_device *mdev;
 	struct net_device *ndev;
 	struct delayed_work rx_refill;
+	struct sk_buff *skbagg;
 	struct mhi_net_stats stats;
 	u32 rx_queue_sz;
 };
@@ -133,6 +134,31 @@ static void mhi_net_setup(struct net_device *ndev)
 	ndev->tx_queue_len = 1000;
 }
 
+static struct sk_buff *mhi_net_skb_append(struct mhi_device *mhi_dev,
+					  struct sk_buff *skb1,
+					  struct sk_buff *skb2)
+{
+	struct sk_buff *new_skb;
+
+	/* This is the first fragment */
+	if (!skb1)
+		return skb2;
+
+	/* Expand packet */
+	new_skb = skb_copy_expand(skb1, 0, skb2->len, GFP_ATOMIC);
+	dev_kfree_skb_any(skb1);
+	if (!new_skb)
+		return skb2;
+
+	/* Append to expanded packet */
+	memcpy(skb_put(new_skb, skb2->len), skb2->data, skb2->len);
+
+	/* free appended skb */
+	dev_kfree_skb_any(skb2);
+
+	return new_skb;
+}
+
 static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
 				struct mhi_result *mhi_res)
 {
@@ -143,19 +169,44 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
 	remaining = atomic_dec_return(&mhi_netdev->stats.rx_queued);
 
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
+			mhi_netdev->skbagg = mhi_net_skb_append(mhi_dev,
+								mhi_netdev->skbagg,
+								skb);
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
+		if (mhi_netdev->skbagg) {
+			/* Aggregate the final fragment */
+			skb = mhi_net_skb_append(mhi_dev, mhi_netdev->skbagg, skb);
+			mhi_netdev->skbagg = NULL;
+		}
+
 		u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
 		u64_stats_inc(&mhi_netdev->stats.rx_packets);
-		u64_stats_add(&mhi_netdev->stats.rx_bytes, mhi_res->bytes_xferd);
+		u64_stats_add(&mhi_netdev->stats.rx_bytes, skb->len);
 		u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
 
 		switch (skb->data[0] & 0xf0) {
@@ -170,7 +221,6 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
 			break;
 		}
 
-		skb_put(skb, mhi_res->bytes_xferd);
 		netif_rx(skb);
 	}
 
@@ -270,6 +320,7 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
 	dev_set_drvdata(dev, mhi_netdev);
 	mhi_netdev->ndev = ndev;
 	mhi_netdev->mdev = mhi_dev;
+	mhi_netdev->skbagg = NULL;
 	SET_NETDEV_DEV(ndev, &mhi_dev->dev);
 	SET_NETDEV_DEVTYPE(ndev, &wwan_type);
 
@@ -304,6 +355,9 @@ static void mhi_net_remove(struct mhi_device *mhi_dev)
 
 	mhi_unprepare_from_transfer(mhi_netdev->mdev);
 
+	if (mhi_netdev->skbagg)
+		kfree_skb(mhi_netdev->skbagg);
+
 	free_netdev(mhi_netdev->ndev);
 }
 
-- 
2.7.4

