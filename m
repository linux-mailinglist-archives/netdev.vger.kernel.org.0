Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE3CA314B03
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 10:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbhBIJAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 04:00:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbhBII6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 03:58:46 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2B7C06178A
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 00:57:57 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id n6so7815422wrv.8
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 00:57:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=D1xoggkKUYPm/up9HUqtS9Xiw3MkdDwvnq8xK4ouEnc=;
        b=DEMrIs+7nG1vykmUxnuuBvgSEP+iWHxBRCzZtsw0kFiLmpVsMMXbP0jkNnZ4ZMFdvG
         am2V1JM3QfksypjkgRgkwNtTBhtlkQmgFxx5r6UfDRDtaa81dm7AAAbttGol/ISFym3v
         JMeML9dXEcaVEG0BoIgi7c5qrBi1sy0c7OpQJUm/EfWBl6jP9pjpG2LZfdBPf93OsJni
         JFtsm33LEylTQjjFza6c/u8z6wDNtz/61c5iL4oid6nBWgt3aQLJTaREo8Ec/JYWq9E8
         3/VL/2twbW6IXHeSQJdDE0ULN5wx/FR+VS8wk/xbIjJ77EAN/ajpriglscpk+V+wmi2k
         jVdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=D1xoggkKUYPm/up9HUqtS9Xiw3MkdDwvnq8xK4ouEnc=;
        b=LM0heQdDemkwwZ56+HcuHRyBB/2TAuZkbJuYTm7L5iPKyXwbleUUD+WqvVYqobLpsU
         oZE6txwl79l5NDuzvkVXXnOFgh1QCriFxNuDGv3Yo/+Is5tK95DRG9Q78jtd/svxHu03
         S60b5d4ruxUhOVKCngs4G1Nv30OicSDVIoQQpH5mmuai9k4u1hZ6pLxqR1GtzXngwQBB
         BlJDsa/GbVZheFtpernPwUXJfAmaNbCvVo1bX5vrUGqbIAJ4n+EOPSS21BMnuxrT/En/
         5alxo0l0oL6/D4VRoYW79hFcf5cwzlMRfFFhaNAvID044BSmnmLmCTF6hcVrPS9roM2u
         CkvQ==
X-Gm-Message-State: AOAM532u7bW2NWdwkPDClPN84o61NM5mynFtEZ4tdWdL543pHpZFhdNq
        NMHwfe6BTV4T4De/B9l1bG6AWo4/kxUli+Oo
X-Google-Smtp-Source: ABdhPJwNV+VUd5Vf7PuNNn7qarhW1t9EIqe8yK4wSO3huC0VM4vwUr22ANuiASKu5CZTuVA0pbxewA==
X-Received: by 2002:adf:c40a:: with SMTP id v10mr10676723wrf.10.1612861076528;
        Tue, 09 Feb 2021 00:57:56 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id d3sm38348693wrp.79.2021.02.09.00.57.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Feb 2021 00:57:56 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, bjorn@mork.no, dcbw@redhat.com,
        carl.yin@quectel.com, mpearson@lenovo.com, cchen50@lenovo.com,
        jwjiang@lenovo.com, ivan.zhang@quectel.com,
        naveen.kumar@quectel.com, ivan.mikhanchuk@quectel.com,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v5 1/5] net: mhi: Add protocol support
Date:   Tue,  9 Feb 2021 10:05:54 +0100
Message-Id: <1612861558-14487-2-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612861558-14487-1-git-send-email-loic.poulain@linaro.org>
References: <1612861558-14487-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MHI can transport different protocols, some are handled at upper level,
like IP and QMAP(rmnet/netlink), but others will need to be inside MHI
net driver, like mbim. This change adds support for protocol rx and
tx_fixup callbacks registration, that can be used to encode/decode the
targeted protocol.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/mhi_net.c | 69 ++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 57 insertions(+), 12 deletions(-)

diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
index 8800991..b92c2e1 100644
--- a/drivers/net/mhi_net.c
+++ b/drivers/net/mhi_net.c
@@ -34,11 +34,24 @@ struct mhi_net_dev {
 	struct net_device *ndev;
 	struct sk_buff *skbagg_head;
 	struct sk_buff *skbagg_tail;
+	const struct mhi_net_proto *proto;
+	void *proto_data;
 	struct delayed_work rx_refill;
 	struct mhi_net_stats stats;
 	u32 rx_queue_sz;
 };
 
+struct mhi_net_proto {
+	int (*init)(struct mhi_net_dev *mhi_netdev);
+	struct sk_buff * (*tx_fixup)(struct mhi_net_dev *mhi_netdev, struct sk_buff *skb);
+	void (*rx)(struct mhi_net_dev *mhi_netdev, struct sk_buff *skb);
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
@@ -68,26 +81,35 @@ static int mhi_ndo_stop(struct net_device *ndev)
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
@@ -164,6 +186,7 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
 				struct mhi_result *mhi_res)
 {
 	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
+	const struct mhi_net_proto *proto = mhi_netdev->proto;
 	struct sk_buff *skb = mhi_res->buf_addr;
 	int free_desc_count;
 
@@ -220,7 +243,10 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
 			break;
 		}
 
-		netif_rx(skb);
+		if (proto && proto->rx)
+			proto->rx(mhi_netdev, skb);
+		else
+			netif_rx(skb);
 	}
 
 	/* Refill if RX buffers queue becomes low */
@@ -302,14 +328,14 @@ static struct device_type wwan_type = {
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
 
@@ -318,6 +344,7 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
 	mhi_netdev->ndev = ndev;
 	mhi_netdev->mdev = mhi_dev;
 	mhi_netdev->skbagg_head = NULL;
+	mhi_netdev->proto = info->proto;
 	SET_NETDEV_DEV(ndev, &mhi_dev->dev);
 	SET_NETDEV_DEVTYPE(ndev, &wwan_type);
 
@@ -337,8 +364,16 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
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
@@ -358,9 +393,19 @@ static void mhi_net_remove(struct mhi_device *mhi_dev)
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

