Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4088AD3B
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 05:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727411AbfHMDmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 23:42:49 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:39400 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727362AbfHMDmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 23:42:46 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x7D3gi9V012013, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x7D3gi9V012013
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 13 Aug 2019 11:42:44 +0800
Received: from fc30.localdomain (172.21.177.138) by RTITCASV01.realtek.com.tw
 (172.21.6.18) with Microsoft SMTP Server id 14.3.468.0; Tue, 13 Aug 2019
 11:42:43 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next v2 5/5] r8152: change rx_copybreak and rx_pending through ethtool
Date:   Tue, 13 Aug 2019 11:42:09 +0800
Message-ID: <1394712342-15778-300-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-295-albertk@realtek.com>
References: <1394712342-15778-289-Taiwan-albertk@realtek.com>
 <1394712342-15778-295-albertk@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.138]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let the rx_copybreak and rx_pending could be modified by
ethtool.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 91 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 86 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 2ae04522cd5a..40d18e866269 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -26,7 +26,7 @@
 #include <linux/acpi.h>
 
 /* Information for net-next */
-#define NETNEXT_VERSION		"09"
+#define NETNEXT_VERSION		"10"
 
 /* Information for net */
 #define NET_VERSION		"10"
@@ -584,7 +584,7 @@ enum rtl_register_content {
 #define TX_ALIGN		4
 #define RX_ALIGN		8
 
-#define RTL8152_MAX_RX_AGG	(10 * RTL8152_MAX_RX)
+#define RTL8152_RX_MAX_PENDING	4096
 #define RTL8152_RXFG_HEADSZ	256
 
 #define INTR_LINK		0x0004
@@ -756,6 +756,9 @@ struct r8152 {
 	u32 tx_qlen;
 	u32 coalesce;
 	u32 rx_buf_sz;
+	u32 rx_copybreak;
+	u32 rx_pending;
+
 	u16 ocp_base;
 	u16 speed;
 	u8 *intr_buff;
@@ -1984,7 +1987,7 @@ static struct rx_agg *rtl_get_free_rx(struct r8152 *tp, gfp_t mflags)
 
 	spin_unlock_irqrestore(&tp->rx_lock, flags);
 
-	if (!agg_free && atomic_read(&tp->rx_count) < RTL8152_MAX_RX_AGG)
+	if (!agg_free && atomic_read(&tp->rx_count) < tp->rx_pending)
 		agg_free = alloc_rx_agg(tp, mflags);
 
 	return agg_free;
@@ -2064,10 +2067,10 @@ static int rx_bottom(struct r8152 *tp, int budget)
 			pkt_len -= ETH_FCS_LEN;
 			rx_data += sizeof(struct rx_desc);
 
-			if (!agg_free || RTL8152_RXFG_HEADSZ > pkt_len)
+			if (!agg_free || tp->rx_copybreak > pkt_len)
 				rx_frag_head_sz = pkt_len;
 			else
-				rx_frag_head_sz = RTL8152_RXFG_HEADSZ;
+				rx_frag_head_sz = tp->rx_copybreak;
 
 			skb = napi_alloc_skb(napi, rx_frag_head_sz);
 			if (!skb) {
@@ -5104,6 +5107,77 @@ static int rtl8152_set_coalesce(struct net_device *netdev,
 	return ret;
 }
 
+static int rtl8152_get_tunable(struct net_device *netdev,
+			       const struct ethtool_tunable *tunable, void *d)
+{
+	struct r8152 *tp = netdev_priv(netdev);
+
+	switch (tunable->id) {
+	case ETHTOOL_RX_COPYBREAK:
+		*(u32 *)d = tp->rx_copybreak;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int rtl8152_set_tunable(struct net_device *netdev,
+			       const struct ethtool_tunable *tunable,
+			       const void *d)
+{
+	struct r8152 *tp = netdev_priv(netdev);
+	u32 val;
+
+	switch (tunable->id) {
+	case ETHTOOL_RX_COPYBREAK:
+		val = *(u32 *)d;
+		if (val < ETH_ZLEN) {
+			netif_err(tp, rx_err, netdev,
+				  "Invalid rx copy break value\n");
+			return -EINVAL;
+		}
+
+		if (tp->rx_copybreak != val) {
+			napi_disable(&tp->napi);
+			tp->rx_copybreak = val;
+			napi_enable(&tp->napi);
+		}
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static void rtl8152_get_ringparam(struct net_device *netdev,
+				  struct ethtool_ringparam *ring)
+{
+	struct r8152 *tp = netdev_priv(netdev);
+
+	ring->rx_max_pending = RTL8152_RX_MAX_PENDING;
+	ring->rx_pending = tp->rx_pending;
+}
+
+static int rtl8152_set_ringparam(struct net_device *netdev,
+				 struct ethtool_ringparam *ring)
+{
+	struct r8152 *tp = netdev_priv(netdev);
+
+	if (ring->rx_pending < (RTL8152_MAX_RX * 2))
+		return -EINVAL;
+
+	if (tp->rx_pending != ring->rx_pending) {
+		napi_disable(&tp->napi);
+		tp->rx_pending = ring->rx_pending;
+		napi_enable(&tp->napi);
+	}
+
+	return 0;
+}
+
 static const struct ethtool_ops ops = {
 	.get_drvinfo = rtl8152_get_drvinfo,
 	.get_link = ethtool_op_get_link,
@@ -5121,6 +5195,10 @@ static const struct ethtool_ops ops = {
 	.set_eee = rtl_ethtool_set_eee,
 	.get_link_ksettings = rtl8152_get_link_ksettings,
 	.set_link_ksettings = rtl8152_set_link_ksettings,
+	.get_tunable = rtl8152_get_tunable,
+	.set_tunable = rtl8152_set_tunable,
+	.get_ringparam = rtl8152_get_ringparam,
+	.set_ringparam = rtl8152_set_ringparam,
 };
 
 static int rtl8152_ioctl(struct net_device *netdev, struct ifreq *rq, int cmd)
@@ -5474,6 +5552,9 @@ static int rtl8152_probe(struct usb_interface *intf,
 	tp->speed = tp->mii.supports_gmii ? SPEED_1000 : SPEED_100;
 	tp->duplex = DUPLEX_FULL;
 
+	tp->rx_copybreak = RTL8152_RXFG_HEADSZ;
+	tp->rx_pending = 10 * RTL8152_MAX_RX;
+
 	intf->needs_remote_wakeup = 1;
 
 	tp->rtl_ops.init(tp);
-- 
2.21.0

