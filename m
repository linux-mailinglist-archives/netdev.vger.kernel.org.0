Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119C930615D
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 17:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234324AbhA0Qyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 11:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233925AbhA0QyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 11:54:19 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D57C061573
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 08:53:38 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id p15so2625146wrq.8
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 08:53:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Bfd8ZrqYLleMnZ9WSg0Zx5WTuCO4cMXNGVPsnFmssQw=;
        b=HXICIs76q4gkZ7vHbuwRlFDK7GVp8XMiqzJaGBebJ7wQLQKFWEp7MmoVkOL//Wv1KL
         W/qsHQn/vEvI2jwC36O5pU8jLDdebab+21Ge3buKALH2IDO50ZKEpmss8sDONG0EDveY
         KdEPGIhWhuD3QJVuN3NGv2Yuv3P6dyR3LlcJWr4bvlV+O48mxi/QG5UrDr3I100QHLuC
         g7j7CpZu4jLNQbEo84rvDHMEB0Jfkr05f4sSJYR5weA80+CUxPtFeRFPjzH+zg0+GcFJ
         G0AvZOHnNjjbIbt/798Zrs84ECtty6of7tAwp5EtXioe9OncygaP126Nbh9Y1P7NajHg
         Ac/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Bfd8ZrqYLleMnZ9WSg0Zx5WTuCO4cMXNGVPsnFmssQw=;
        b=WD30Y68/s20o7o54oEvOmUUhRxjtyBFnES/sp+QfPYjQxpLtIXRx+SSRSvDdvhYoC5
         sJwkdlP1Q0J3NoVwQeV9H/oTfmAdyun3+7rPrM6wiSpkiOKi0tBIyQYzsvfVqTa7gw+E
         6bPk81FrCBsox61ulg0HZbLtAx2EOIAi76dD0ZYg7hs6fzMbF4kwg3fPsCad504CKajj
         od8hkeGH94JIPqxNcHy+UexUes56cg48LtQNvK6XCCGrfA5xzoT97DtT4ELd5BNhXrLm
         Sywb0mn2N/CjVQNvoY1uX0rZImmckjVXJpBbiD5CVJkfpUTI+dqG2N0Xq5/umrrXqeGg
         Sb3Q==
X-Gm-Message-State: AOAM532qz/baN/TkVLjVzFKDgtizJ0DKm8/ARoj2kzMb8y3pi6HeQTCN
        ILFeKW5zcU031ovaYqqTxC98gw==
X-Google-Smtp-Source: ABdhPJyBUQfRIC5GgYmK9mKXS3zzuwbUEFbD0VDIFVMKElugPiwQAuBSJ2r7DHJmpU1HWxc8N1HQpg==
X-Received: by 2002:a5d:5384:: with SMTP id d4mr11586388wrv.177.1611766416903;
        Wed, 27 Jan 2021 08:53:36 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id m82sm3077042wmf.29.2021.01.27.08.53.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Jan 2021 08:53:36 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, carl.yin@quectel.com,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next 1/3] net: mhi: Add RX/TX fixup callbacks
Date:   Wed, 27 Jan 2021 18:01:15 +0100
Message-Id: <1611766877-16787-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MHI can transport different protocols, some are handled at upper level,
like IP and QMAP(rmnet/netlink), but others will need to be inside MHI
net driver, like mbim. This change adds support for protocol rx/tx
fixup callbacks registration, that can be used to encode/decode the
targeted protocol.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/mhi_net.c | 70 ++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 58 insertions(+), 12 deletions(-)

diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
index a5a214d..aa3a5e0 100644
--- a/drivers/net/mhi_net.c
+++ b/drivers/net/mhi_net.c
@@ -33,11 +33,24 @@ struct mhi_net_stats {
 struct mhi_net_dev {
 	struct mhi_device *mdev;
 	struct net_device *ndev;
+	const struct mhi_net_proto *proto;
+	void *proto_data;
 	struct delayed_work rx_refill;
 	struct mhi_net_stats stats;
 	u32 rx_queue_sz;
 };
 
+struct mhi_net_proto {
+	int (*init)(struct mhi_net_dev *dev);
+	struct sk_buff * (*tx_fixup)(struct net_device *ndev, struct sk_buff *skb);
+	int (*rx_fixup)(struct net_device *ndev, struct sk_buff *skb);
+};
+
+struct mhi_device_info {
+	const char *netname;
+	const struct mhi_net_proto *proto;
+};
+
 static int mhi_ndo_open(struct net_device *ndev)
 {
 	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
@@ -67,26 +80,35 @@ static int mhi_ndo_stop(struct net_device *ndev)
 static int mhi_ndo_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
+	const struct mhi_net_proto *proto = mhi_netdev->proto;
 	struct mhi_device *mdev = mhi_netdev->mdev;
 	int err;
 
+	if (proto && proto->tx_fixup) {
+		skb = proto->tx_fixup(mhi_netdev->ndev, skb);
+		if (unlikely(!skb))
+			goto exit_drop;
+	}
+
 	err = mhi_queue_skb(mdev, DMA_TO_DEVICE, skb, skb->len, MHI_EOT);
 	if (unlikely(err)) {
 		net_err_ratelimited("%s: Failed to queue TX buf (%d)\n",
 				    ndev->name, err);
-
-		u64_stats_update_begin(&mhi_netdev->stats.tx_syncp);
-		u64_stats_inc(&mhi_netdev->stats.tx_dropped);
-		u64_stats_update_end(&mhi_netdev->stats.tx_syncp);
-
-		/* drop the packet */
 		dev_kfree_skb_any(skb);
+		goto exit_drop;
 	}
 
 	if (mhi_queue_is_full(mdev, DMA_TO_DEVICE))
 		netif_stop_queue(ndev);
 
 	return NETDEV_TX_OK;
+
+exit_drop:
+	u64_stats_update_begin(&mhi_netdev->stats.tx_syncp);
+	u64_stats_inc(&mhi_netdev->stats.tx_dropped);
+	u64_stats_update_end(&mhi_netdev->stats.tx_syncp);
+
+	return NETDEV_TX_OK;
 }
 
 static void mhi_ndo_get_stats64(struct net_device *ndev,
@@ -137,6 +159,7 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
 				struct mhi_result *mhi_res)
 {
 	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
+	const struct mhi_net_proto *proto = mhi_netdev->proto;
 	struct sk_buff *skb = mhi_res->buf_addr;
 	int remaining;
 
@@ -171,7 +194,11 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
 		}
 
 		skb_put(skb, mhi_res->bytes_xferd);
-		netif_rx(skb);
+
+		if (proto && proto->rx_fixup)
+			proto->rx_fixup(mhi_netdev->ndev, skb);
+		else
+			netif_rx(skb);
 	}
 
 	/* Refill if RX buffers queue becomes low */
@@ -255,14 +282,14 @@ static struct device_type wwan_type = {
 static int mhi_net_probe(struct mhi_device *mhi_dev,
 			 const struct mhi_device_id *id)
 {
-	const char *netname = (char *)id->driver_data;
+	const struct mhi_device_info *info = (struct mhi_device_info *)id->driver_data;
 	struct device *dev = &mhi_dev->dev;
 	struct mhi_net_dev *mhi_netdev;
 	struct net_device *ndev;
 	int err;
 
-	ndev = alloc_netdev(sizeof(*mhi_netdev), netname, NET_NAME_PREDICTABLE,
-			    mhi_net_setup);
+	ndev = alloc_netdev(sizeof(*mhi_netdev), info->netname,
+			    NET_NAME_PREDICTABLE, mhi_net_setup);
 	if (!ndev)
 		return -ENOMEM;
 
@@ -270,6 +297,7 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
 	dev_set_drvdata(dev, mhi_netdev);
 	mhi_netdev->ndev = ndev;
 	mhi_netdev->mdev = mhi_dev;
+	mhi_netdev->proto = info->proto;
 	SET_NETDEV_DEV(ndev, &mhi_dev->dev);
 	SET_NETDEV_DEVTYPE(ndev, &wwan_type);
 
@@ -289,8 +317,16 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
 	if (err)
 		goto out_err;
 
+	if (mhi_netdev->proto) {
+		err = mhi_netdev->proto->init(mhi_netdev);
+		if (err)
+			goto out_err_proto;
+	}
+
 	return 0;
 
+out_err_proto:
+	unregister_netdev(ndev);
 out_err:
 	free_netdev(ndev);
 	return err;
@@ -307,9 +343,19 @@ static void mhi_net_remove(struct mhi_device *mhi_dev)
 	free_netdev(mhi_netdev->ndev);
 }
 
+static const struct mhi_device_info mhi_hwip0 = {
+	.netname = "mhi_hwip%d",
+};
+
+static const struct mhi_device_info mhi_swip0 = {
+	.netname = "mhi_swip%d",
+};
+
 static const struct mhi_device_id mhi_net_id_table[] = {
-	{ .chan = "IP_HW0", .driver_data = (kernel_ulong_t)"mhi_hwip%d" },
-	{ .chan = "IP_SW0", .driver_data = (kernel_ulong_t)"mhi_swip%d" },
+	/* Hardware accelerated data PATH (to modem IPA), protocol agnostic */
+	{ .chan = "IP_HW0", .driver_data = (kernel_ulong_t)&mhi_hwip0 },
+	/* Software data PATH (to modem CPU) */
+	{ .chan = "IP_SW0", .driver_data = (kernel_ulong_t)&mhi_swip0 },
 	{}
 };
 MODULE_DEVICE_TABLE(mhi, mhi_net_id_table);
-- 
2.7.4

