Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A1630B1C7
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 21:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbhBAU6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 15:58:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbhBAU6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 15:58:43 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9B2C061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 12:58:03 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id a1so18150346wrq.6
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 12:58:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=bOVZWokpQ33DTK5ssj5sCeUQAOwoz/k0b935F4WFbOQ=;
        b=X3TeoSJKKUrNEmpZMmPHXsCZ5lE6SX4DabvrmMMoYRkPoG+91T3/NGX5LuWPG8pJsC
         mBIMDjuneenMxt8l5IHCgWCx6qyXj6+dznSYo6o5oNsk1NaOZlsfFg0Iks5AeuhYuWsZ
         qxX3iGOIlA2C06W4TyRs+F0kGIKsVOIp7gsY2CsppFCstzEO61aaqfxZkG/Zmf6i5JGS
         8Zy6aGHLLs4sLGnWA6omkCFGC91kZG0a/ipbXa9U0g0HwtQNm7Tmg3MXp81DYDi2timA
         MVElSgUGOiD21/KyCVu1omNRlsuZWHCY3m9ET1HFiAl7gdP+st4rvHy/2LlLA4qgiEqQ
         f4tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bOVZWokpQ33DTK5ssj5sCeUQAOwoz/k0b935F4WFbOQ=;
        b=Ro0+/Z2qE/7DUV6FNWJG7fjWazUOeKsSMeaRjrg7nry+z4sSrCf2mku+vTa/ArvEx1
         0YtgQSk9XnxcEEMnmXg8ILOShyKBr1P8gefvshIjY+fCmc3JBT7taUj49XWPmjRDXMK4
         ra8Dn6w4kR+9zHDd8/2zaC4a/Gj4B34Vt0lJTopwSlDViHD46ljZn+IFj0hgnTXL6m5a
         C1IrCk3ThKnyROxOf19j9JmYiNr8pjprFu1f4L8SsgJEErMQ8HjU5UBQtRG3pqe17JqD
         gzvNTojBLy7or8PT1GxhIyjmX4uJcbDXGtwa7jtJrx+Dlj3phZr2vdqKTiT05iPEUjpR
         UFxQ==
X-Gm-Message-State: AOAM531eBmgbzU2qD2qBBEA6K/oeyTtxMMLMSdcnbp699BBKx+4AHhmo
        FcE+UFHRYUv+kcBBxSDVDlQk5A==
X-Google-Smtp-Source: ABdhPJwI43rEAJV0lcBkt6ejcPfr9U6vjH2iE0cfYZ7MhWi4TFgUl7UywIFW2WlRZdWhTTlHs+CKXA==
X-Received: by 2002:a5d:4d8d:: with SMTP id b13mr19321345wru.178.1612213082108;
        Mon, 01 Feb 2021 12:58:02 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id b7sm27894226wru.33.2021.02.01.12.58.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Feb 2021 12:58:01 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
Cc:     bjorn@mork.no, dcbw@redhat.com, netdev@vger.kernel.org,
        carl.yin@quectel.com, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v2 1/3] net: mhi: Add RX/TX fixup callbacks
Date:   Mon,  1 Feb 2021 22:05:40 +0100
Message-Id: <1612213542-17257-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
To:     unlisted-recipients:; (no To-header on input)
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
 v2: mhi_net_dev as rx/tx_fixup parameter

 drivers/net/mhi_net.c | 70 ++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 58 insertions(+), 12 deletions(-)

diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
index 4f512531..34d4bcf 100644
--- a/drivers/net/mhi_net.c
+++ b/drivers/net/mhi_net.c
@@ -32,11 +32,24 @@ struct mhi_net_stats {
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
+	int (*init)(struct mhi_net_dev *mhi_netdev);
+	struct sk_buff * (*tx_fixup)(struct mhi_net_dev *mhi_netdev, struct sk_buff *skb);
+	int (*rx_fixup)(struct mhi_net_dev *mhi_netdev, struct sk_buff *skb);
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
@@ -66,26 +79,35 @@ static int mhi_ndo_stop(struct net_device *ndev)
 static int mhi_ndo_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
+	const struct mhi_net_proto *proto = mhi_netdev->proto;
 	struct mhi_device *mdev = mhi_netdev->mdev;
 	int err;
 
+	if (proto && proto->tx_fixup) {
+		skb = proto->tx_fixup(mhi_netdev, skb);
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
@@ -136,6 +158,7 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
 				struct mhi_result *mhi_res)
 {
 	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
+	const struct mhi_net_proto *proto = mhi_netdev->proto;
 	struct sk_buff *skb = mhi_res->buf_addr;
 	int free_desc_count;
 
@@ -170,7 +193,11 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
 		}
 
 		skb_put(skb, mhi_res->bytes_xferd);
-		netif_rx(skb);
+
+		if (proto && proto->rx_fixup)
+			proto->rx_fixup(mhi_netdev, skb);
+		else
+			netif_rx(skb);
 	}
 
 	/* Refill if RX buffers queue becomes low */
@@ -252,14 +279,14 @@ static struct device_type wwan_type = {
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
 
@@ -267,6 +294,7 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
 	dev_set_drvdata(dev, mhi_netdev);
 	mhi_netdev->ndev = ndev;
 	mhi_netdev->mdev = mhi_dev;
+	mhi_netdev->proto = info->proto;
 	SET_NETDEV_DEV(ndev, &mhi_dev->dev);
 	SET_NETDEV_DEVTYPE(ndev, &wwan_type);
 
@@ -286,8 +314,16 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
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
@@ -304,9 +340,19 @@ static void mhi_net_remove(struct mhi_device *mhi_dev)
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

