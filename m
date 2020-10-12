Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A0C28BBAD
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 17:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389850AbgJLPUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 11:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389369AbgJLPUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 11:20:01 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D28C0613D0
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 08:20:00 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id h7so19659433wre.4
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 08:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=cYTQ8OJN/KyGIDeiYuWoizyysaIFTjgElRJtaaW2IVk=;
        b=J0d4CdAtUWaQxA14vNjxap8P+KpyDLsxCgHmWEmD85Pkk27SlnFxf5kweA4SAWb+UZ
         jHdVeXj5cLh/h0DKB/6Z+jA7MlCzE06HB+pCHxWeYq+NaoTYcrc1M+B/D2RR8TMgdZVL
         d26Wg8SAX/MFq/yoyEJAhikt5DdMU0yOU90BPuTMFgrPKX2YMLpGj4isJg2/Bo42LYDL
         mV7R/+nm/oOvbT2DARCizF0rsIZyDEakLkdQa2Vz+0sSBMFLVZB+QZhHEUVfnRXwtIGc
         i4EG1HqY74Dwn/NiFOeI7E4B8PjnrHqVuBj5696EM30VZDr11coC0CO0GUV3QAcNLwTY
         d7PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=cYTQ8OJN/KyGIDeiYuWoizyysaIFTjgElRJtaaW2IVk=;
        b=Na+t5yVk/6bvyTLmvGZ7ruH7trw77G6BJLYUe4nDiWxoGWfWVsHGvCKi3pg1ZbN+/f
         hn56pPmERMfDU5DUZa0R3vzTHIiLEwm0YIHNZJ9nGaKjt7NhXwIlakd0LjALR96fOsYz
         +PE/P2zU0AbpwUqf74WpY2HiEfVPOTGyFoR8x7yhUoAChLDsmm3+6ar5mD4SIfg20YXe
         o4stEy8A6QdUJFLTY6AJB2AXX2AiMuwlnNgXe0mg3F1rlT8nCSvVJfjzsoiJqEmQkpPu
         PZf1DEhKfeSRUe6+kpYL4YmlAmjp4QUit56TWAhar8BmCxgU5MN9joxh6vWOppgIY+GC
         OMHw==
X-Gm-Message-State: AOAM531tVVhLyc430NQ8N5zcjH6xq8tK6FThFVsELl++KRp5ENG6TL14
        Yoc9MiJL8ddbs+5eypV7bNoBJA==
X-Google-Smtp-Source: ABdhPJwlOH9QbfneOl19KhgM523NepRUG1fDdgZfhlRqeHLNDmSQIxjNTf3Xsn+y2HnJIznQMo66ng==
X-Received: by 2002:adf:f2d1:: with SMTP id d17mr30433210wrp.122.1602515998657;
        Mon, 12 Oct 2020 08:19:58 -0700 (PDT)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id c1sm25731300wru.49.2020.10.12.08.19.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Oct 2020 08:19:57 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        hemantk@codeaurora.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH v2] net: Add mhi-net driver
Date:   Mon, 12 Oct 2020 17:26:03 +0200
Message-Id: <1602516363-27006-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a new network driver implementing MHI transport for
network packets. Packets can be in any format, though QMAP (rmnet)
is the usual protocol (flow control + PDN mux).

It support two MHI devices, IP_HW0 which is, the path to the IPA
(IP accelerator) on qcom modem, And IP_SW0 which is the software
driven IP path (to modem CPU).

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 v2: - rebase on net-next
     - remove useless skb_linearize
     - check error type on mhi_queue return
     - rate limited errors
     - Schedule RX refill only on 'low' buf level
     - SET_NETDEV_DEV in probe
     - reorder device remove sequence

 drivers/net/Kconfig   |   7 ++
 drivers/net/Makefile  |   1 +
 drivers/net/mhi_net.c | 282 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 290 insertions(+)
 create mode 100644 drivers/net/mhi_net.c

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 1368d1d..11a6357 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -426,6 +426,13 @@ config VSOCKMON
 	  mostly intended for developers or support to debug vsock issues. If
 	  unsure, say N.
 
+config MHI_NET
+	tristate "MHI network driver"
+	depends on MHI_BUS
+	help
+	  This is the network driver for MHI.  It can be used with
+	  QCOM based WWAN modems (like SDX55).  Say Y or M.
+
 endif # NET_CORE
 
 config SUNGEM_PHY
diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 94b6080..8312037 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_GTP) += gtp.o
 obj-$(CONFIG_NLMON) += nlmon.o
 obj-$(CONFIG_NET_VRF) += vrf.o
 obj-$(CONFIG_VSOCKMON) += vsockmon.o
+obj-$(CONFIG_MHI_NET) += mhi_net.o
 
 #
 # Networking Drivers
diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
new file mode 100644
index 0000000..65a37e5
--- /dev/null
+++ b/drivers/net/mhi_net.c
@@ -0,0 +1,282 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* MHI Network driver - Network over MHI
+ *
+ * Copyright (C) 2020 Linaro Ltd <loic.poulain@linaro.org>
+ */
+
+#include <linux/if_arp.h>
+#include <linux/mhi.h>
+#include <linux/mod_devicetable.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+
+#define MIN_MTU		ETH_MIN_MTU
+#define MAX_MTU		0xffff
+#define DEFAULT_MTU	8192
+
+struct mhi_net_stats {
+	u64 rx_packets;
+	u64 rx_bytes;
+	u64 rx_errors;
+	u64 rx_dropped;
+	u64 tx_packets;
+	u64 tx_bytes;
+	u64 tx_errors;
+	u64 tx_dropped;
+	atomic_t rx_queued;
+};
+
+struct mhi_net_dev {
+	struct mhi_device *mdev;
+	struct net_device *ndev;
+	struct delayed_work rx_refill;
+	struct mhi_net_stats stats;
+	u32 rx_queue_sz;
+};
+
+static int mhi_ndo_open(struct net_device *ndev)
+{
+	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
+
+	/* Feed the rx buffer pool */
+	schedule_delayed_work(&mhi_netdev->rx_refill, 0);
+
+	/* Carrier is established via out-of-band channel (e.g. qmi) */
+	netif_carrier_on(ndev);
+
+	netif_start_queue(ndev);
+
+	return 0;
+}
+
+static int mhi_ndo_stop(struct net_device *ndev)
+{
+	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
+
+	netif_stop_queue(ndev);
+	netif_carrier_off(ndev);
+	cancel_delayed_work_sync(&mhi_netdev->rx_refill);
+
+	return 0;
+}
+
+static int mhi_ndo_xmit(struct sk_buff *skb, struct net_device *ndev)
+{
+	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
+	struct mhi_device *mdev = mhi_netdev->mdev;
+	int err;
+
+	skb_tx_timestamp(skb);
+
+	/* mhi_queue_skb is not thread-safe, but xmit is serialized by the
+	 * network core. Once MHI core will be thread save, migrate to
+	 * NETIF_F_LLTX support.
+	 */
+	err = mhi_queue_skb(mdev, DMA_TO_DEVICE, skb, skb->len, MHI_EOT);
+	if (err == -ENOMEM) {
+		netif_stop_queue(ndev);
+		return NETDEV_TX_BUSY;
+	} else if (unlikely(err)) {
+		net_err_ratelimited("%s: Failed to queue TX buf (%d)\n",
+				    ndev->name, err);
+		mhi_netdev->stats.tx_dropped++;
+		kfree_skb(skb);
+	}
+
+	return NETDEV_TX_OK;
+}
+
+static void mhi_ndo_get_stats64(struct net_device *ndev,
+				struct rtnl_link_stats64 *stats)
+{
+	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
+
+	stats->rx_packets = mhi_netdev->stats.rx_packets;
+	stats->rx_bytes = mhi_netdev->stats.rx_bytes;
+	stats->rx_errors = mhi_netdev->stats.rx_errors;
+	stats->rx_dropped = mhi_netdev->stats.rx_dropped;
+	stats->tx_packets = mhi_netdev->stats.tx_packets;
+	stats->tx_bytes = mhi_netdev->stats.tx_bytes;
+	stats->tx_errors = mhi_netdev->stats.tx_errors;
+	stats->tx_dropped = mhi_netdev->stats.tx_dropped;
+}
+
+static const struct net_device_ops mhi_netdev_ops = {
+	.ndo_open               = mhi_ndo_open,
+	.ndo_stop               = mhi_ndo_stop,
+	.ndo_start_xmit         = mhi_ndo_xmit,
+	.ndo_get_stats64	= mhi_ndo_get_stats64,
+};
+
+static void mhi_net_setup(struct net_device *ndev)
+{
+	ndev->header_ops = NULL;  /* No header */
+	ndev->type = ARPHRD_NONE; /* QMAP... */
+	ndev->hard_header_len = 0;
+	ndev->addr_len = 0;
+	ndev->flags &= ~(IFF_BROADCAST | IFF_MULTICAST);
+	ndev->netdev_ops = &mhi_netdev_ops;
+	ndev->mtu = DEFAULT_MTU;
+	ndev->min_mtu = MIN_MTU;
+	ndev->max_mtu = MAX_MTU;
+	ndev->tx_queue_len = 1000;
+}
+
+static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
+				struct mhi_result *mhi_res)
+{
+	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
+	struct sk_buff *skb = mhi_res->buf_addr;
+	int remaining;
+
+	remaining = atomic_dec_return(&mhi_netdev->stats.rx_queued);
+
+	if (unlikely(mhi_res->transaction_status)) {
+		mhi_netdev->stats.rx_errors++;
+		kfree_skb(skb);
+	} else {
+		mhi_netdev->stats.rx_packets++;
+		mhi_netdev->stats.rx_bytes += mhi_res->bytes_xferd;
+
+		skb->protocol = htons(ETH_P_MAP);
+		skb_put(skb, mhi_res->bytes_xferd);
+		netif_rx(skb);
+	}
+
+	/* Refill if RX buffers queue becomes low */
+	if (remaining <= mhi_netdev->rx_queue_sz / 2)
+		schedule_delayed_work(&mhi_netdev->rx_refill, 0);
+}
+
+static void mhi_net_ul_callback(struct mhi_device *mhi_dev,
+				struct mhi_result *mhi_res)
+{
+	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
+	struct net_device *ndev = mhi_netdev->ndev;
+	struct sk_buff *skb = mhi_res->buf_addr;
+
+	/* Hardware has consumed the buffer, so free the skb (which is not
+	 * freed by the MHI stack) and perform accounting.
+	 */
+	consume_skb(skb);
+
+	if (unlikely(mhi_res->transaction_status)) {
+		mhi_netdev->stats.tx_errors++;
+	} else {
+		mhi_netdev->stats.tx_packets++;
+		mhi_netdev->stats.tx_bytes += mhi_res->bytes_xferd;
+	}
+
+	if (netif_queue_stopped(ndev))
+		netif_wake_queue(ndev);
+}
+
+static void mhi_net_rx_refill_work(struct work_struct *work)
+{
+	struct mhi_net_dev *mhi_netdev = container_of(work, struct mhi_net_dev,
+						      rx_refill.work);
+	struct net_device *ndev = mhi_netdev->ndev;
+	struct mhi_device *mdev = mhi_netdev->mdev;
+	struct sk_buff *skb;
+	int err;
+
+	do {
+		skb = netdev_alloc_skb(ndev, READ_ONCE(ndev->mtu));
+		if (unlikely(!skb))
+			break;
+
+		err = mhi_queue_skb(mdev, DMA_FROM_DEVICE, skb, ndev->mtu,
+				    MHI_EOT);
+		if (err) {
+			if (unlikely(err != -ENOMEM)) {
+				net_err_ratelimited("%s: Failed to queue RX buf (%d)\n",
+						    ndev->name, err);
+			}
+			kfree_skb(skb);
+			break;
+		}
+
+		atomic_inc_return(&mhi_netdev->stats.rx_queued);
+	} while (1);
+
+	/* If we're still starved of rx buffers, reschedule latter */
+	if (unlikely(!atomic_read(&mhi_netdev->stats.rx_queued)))
+		schedule_delayed_work(&mhi_netdev->rx_refill, HZ / 2);
+}
+
+static int mhi_net_probe(struct mhi_device *mhi_dev,
+			 const struct mhi_device_id *id)
+{
+	const char *netname = (char *)id->driver_data;
+	struct mhi_net_dev *mhi_netdev;
+	struct net_device *ndev;
+	struct device *dev = &mhi_dev->dev;
+	int err;
+
+	ndev = alloc_netdev(sizeof(*mhi_netdev), netname, NET_NAME_PREDICTABLE,
+			    mhi_net_setup);
+	if (!ndev)
+		return -ENOMEM;
+
+	mhi_netdev = netdev_priv(ndev);
+	dev_set_drvdata(dev, mhi_netdev);
+	mhi_netdev->ndev = ndev;
+	mhi_netdev->mdev = mhi_dev;
+	SET_NETDEV_DEV(ndev, &mhi_dev->dev);
+
+	/* All MHI net channels have 128 ring elements (at least for now) */
+	mhi_netdev->rx_queue_sz = 128;
+
+	INIT_DELAYED_WORK(&mhi_netdev->rx_refill, mhi_net_rx_refill_work);
+
+	/* Start MHI channels */
+	err = mhi_prepare_for_transfer(mhi_dev);
+	if (err)
+		goto out_err;
+
+	err = register_netdev(ndev);
+	if (err)
+		goto out_err;
+
+	return 0;
+
+out_err:
+	free_netdev(ndev);
+	return err;
+}
+
+static void mhi_net_remove(struct mhi_device *mhi_dev)
+{
+	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
+
+	unregister_netdev(mhi_netdev->ndev);
+
+	mhi_unprepare_from_transfer(mhi_netdev->mdev);
+
+	free_netdev(mhi_netdev->ndev);
+}
+
+static const struct mhi_device_id mhi_net_id_table[] = {
+	{ .chan = "IP_HW0", .driver_data = (kernel_ulong_t)"mhi_hwip%d" },
+	{ .chan = "IP_SW0", .driver_data = (kernel_ulong_t)"mhi_swip%d" },
+	{}
+};
+MODULE_DEVICE_TABLE(mhi, mhi_net_id_table);
+
+static struct mhi_driver mhi_net_driver = {
+	.probe = mhi_net_probe,
+	.remove = mhi_net_remove,
+	.dl_xfer_cb = mhi_net_dl_callback,
+	.ul_xfer_cb = mhi_net_ul_callback,
+	.id_table = mhi_net_id_table,
+	.driver = {
+		.name = "mhi_net",
+	},
+};
+
+module_mhi_driver(mhi_net_driver);
+
+MODULE_AUTHOR("Loic Poulain <loic.poulain@linaro.org>");
+MODULE_DESCRIPTION("Network over MHI");
+MODULE_LICENSE("GPL v2");
-- 
2.7.4

