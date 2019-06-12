Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9819A42D2E
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 19:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409521AbfFLRMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 13:12:51 -0400
Received: from vsmx011.vodafonemail.xion.oxcs.net ([153.92.174.89]:38247 "EHLO
        vsmx011.vodafonemail.xion.oxcs.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406035AbfFLRMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 13:12:51 -0400
Received: from vsmx003.vodafonemail.xion.oxcs.net (unknown [192.168.75.197])
        by mta-5-out.mta.xion.oxcs.net (Postfix) with ESMTP id 6DA683E020B;
        Wed, 12 Jun 2019 17:03:03 +0000 (UTC)
Received: from arcor.de (unknown [2.247.255.147])
        by mta-7-out.mta.xion.oxcs.net (Postfix) with ESMTPA id E98B9300355;
        Wed, 12 Jun 2019 17:02:54 +0000 (UTC)
Date:   Wed, 12 Jun 2019 19:02:46 +0200
From:   Reinhard Speyerer <rspmn@arcor.de>
To:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     Daniele Palmas <dnlplm@gmail.com>, netdev@vger.kernel.org,
        rspmn@arcor.de
Subject: [PATCH 2/4] qmi_wwan: add network device usage statistics for qmimux
 devices
Message-ID: <627de19e75e5b204175e91e7d7b01ebf2986d599.1560287477.git.rspmn@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1560287477.git.rspmn@arcor.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-VADE-STATUS: LEGIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add proper network device usage statistics for qmimux devices
instead of reporting all-zero values for them.

Fixes: c6adf77953bc ("net: usb: qmi_wwan: add qmap mux protocol support")
Cc: Daniele Palmas <dnlplm@gmail.com>
Signed-off-by: Reinhard Speyerer <rspmn@arcor.de>
---
 drivers/net/usb/qmi_wwan.c | 76 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 71 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index fd3d078a1923..b0a96459621f 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -22,6 +22,7 @@
 #include <linux/usb/cdc.h>
 #include <linux/usb/usbnet.h>
 #include <linux/usb/cdc-wdm.h>
+#include <linux/u64_stats_sync.h>
 
 /* This driver supports wwan (3G/LTE/?) devices using a vendor
  * specific management protocol called Qualcomm MSM Interface (QMI) -
@@ -75,6 +76,7 @@ struct qmimux_hdr {
 struct qmimux_priv {
 	struct net_device *real_dev;
 	u8 mux_id;
+	struct pcpu_sw_netstats __percpu *stats64;
 };
 
 static int qmimux_open(struct net_device *dev)
@@ -101,19 +103,65 @@ static netdev_tx_t qmimux_start_xmit(struct sk_buff *skb, struct net_device *dev
 	struct qmimux_priv *priv = netdev_priv(dev);
 	unsigned int len = skb->len;
 	struct qmimux_hdr *hdr;
+	netdev_tx_t ret;
 
 	hdr = skb_push(skb, sizeof(struct qmimux_hdr));
 	hdr->pad = 0;
 	hdr->mux_id = priv->mux_id;
 	hdr->pkt_len = cpu_to_be16(len);
 	skb->dev = priv->real_dev;
-	return dev_queue_xmit(skb);
+	ret = dev_queue_xmit(skb);
+
+	if (likely(ret == NET_XMIT_SUCCESS || ret == NET_XMIT_CN)) {
+		struct pcpu_sw_netstats *stats64 = this_cpu_ptr(priv->stats64);
+
+		u64_stats_update_begin(&stats64->syncp);
+		stats64->tx_packets++;
+		stats64->tx_bytes += len;
+		u64_stats_update_end(&stats64->syncp);
+	} else {
+		dev->stats.tx_dropped++;
+	}
+
+	return ret;
+}
+
+static void qmimux_get_stats64(struct net_device *net,
+			       struct rtnl_link_stats64 *stats)
+{
+	struct qmimux_priv *priv = netdev_priv(net);
+	unsigned int start;
+	int cpu;
+
+	netdev_stats_to_stats64(stats, &net->stats);
+
+	for_each_possible_cpu(cpu) {
+		struct pcpu_sw_netstats *stats64;
+		u64 rx_packets, rx_bytes;
+		u64 tx_packets, tx_bytes;
+
+		stats64 = per_cpu_ptr(priv->stats64, cpu);
+
+		do {
+			start = u64_stats_fetch_begin_irq(&stats64->syncp);
+			rx_packets = stats64->rx_packets;
+			rx_bytes = stats64->rx_bytes;
+			tx_packets = stats64->tx_packets;
+			tx_bytes = stats64->tx_bytes;
+		} while (u64_stats_fetch_retry_irq(&stats64->syncp, start));
+
+		stats->rx_packets += rx_packets;
+		stats->rx_bytes += rx_bytes;
+		stats->tx_packets += tx_packets;
+		stats->tx_bytes += tx_bytes;
+	}
 }
 
 static const struct net_device_ops qmimux_netdev_ops = {
-	.ndo_open       = qmimux_open,
-	.ndo_stop       = qmimux_stop,
-	.ndo_start_xmit = qmimux_start_xmit,
+	.ndo_open        = qmimux_open,
+	.ndo_stop        = qmimux_stop,
+	.ndo_start_xmit  = qmimux_start_xmit,
+	.ndo_get_stats64 = qmimux_get_stats64,
 };
 
 static void qmimux_setup(struct net_device *dev)
@@ -198,8 +246,19 @@ static int qmimux_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		}
 
 		skb_put_data(skbn, skb->data + offset + qmimux_hdr_sz, pkt_len);
-		if (netif_rx(skbn) != NET_RX_SUCCESS)
+		if (netif_rx(skbn) != NET_RX_SUCCESS) {
+			net->stats.rx_errors++;
 			return 0;
+		} else {
+			struct pcpu_sw_netstats *stats64;
+			struct qmimux_priv *priv = netdev_priv(net);
+
+			stats64 = this_cpu_ptr(priv->stats64);
+			u64_stats_update_begin(&stats64->syncp);
+			stats64->rx_packets++;
+			stats64->rx_bytes += pkt_len;
+			u64_stats_update_end(&stats64->syncp);
+		}
 
 skip:
 		offset += len + qmimux_hdr_sz;
@@ -223,6 +282,12 @@ static int qmimux_register_device(struct net_device *real_dev, u8 mux_id)
 	priv->mux_id = mux_id;
 	priv->real_dev = real_dev;
 
+	priv->stats64 = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
+	if (!priv->stats64) {
+		err = -ENOBUFS;
+		goto out_free_newdev;
+	}
+
 	err = register_netdevice(new_dev);
 	if (err < 0)
 		goto out_free_newdev;
@@ -252,6 +317,7 @@ static void qmimux_unregister_device(struct net_device *dev)
 	struct qmimux_priv *priv = netdev_priv(dev);
 	struct net_device *real_dev = priv->real_dev;
 
+	free_percpu(priv->stats64);
 	netdev_upper_dev_unlink(real_dev, dev);
 	unregister_netdevice(dev);
 
-- 
2.11.0

