Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02C08F668C
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 04:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727551AbfKJCln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 21:41:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:36360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727533AbfKJClm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:41:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2729821019;
        Sun, 10 Nov 2019 02:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353700;
        bh=YOGm9STSFPQ+vtoTJurMaYiBTcEOOG+frLIikCdXxAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kMt294jE0RAvaFx7eZ5Yn1/IYVKP05zFdWxWbFL0cRKNSSaoV2p7rdoFhNFNrdN6N
         mvPoJO6Qwbd2oTJANa3VgiO+Z2Gt3c/NCeUguP1Z0YR/V7KP3FOBNaCUuA9wuwZXHz
         fWq5I9o2ktLl8nhXHInPHJ8weSpC68Y2XFaKpN88=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        Shannon Nelson <shannon.nelson@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 045/191] net: sun: fix return type of ndo_start_xmit function
Date:   Sat,  9 Nov 2019 21:37:47 -0500
Message-Id: <20191110024013.29782-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 0e0cc31f6999df18bb5cfd0bd83c892ed5633975 ]

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, but the implementation in this
driver returns an 'int'.

Found by coccinelle.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Shannon Nelson <shannon.nelson@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sun/ldmvsw.c         |  2 +-
 drivers/net/ethernet/sun/sunbmac.c        |  3 ++-
 drivers/net/ethernet/sun/sunqe.c          |  2 +-
 drivers/net/ethernet/sun/sunvnet.c        |  2 +-
 drivers/net/ethernet/sun/sunvnet_common.c | 14 ++++++++------
 drivers/net/ethernet/sun/sunvnet_common.h |  7 ++++---
 6 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/sun/ldmvsw.c b/drivers/net/ethernet/sun/ldmvsw.c
index d42f47f6c632f..644e42c181ee6 100644
--- a/drivers/net/ethernet/sun/ldmvsw.c
+++ b/drivers/net/ethernet/sun/ldmvsw.c
@@ -113,7 +113,7 @@ static u16 vsw_select_queue(struct net_device *dev, struct sk_buff *skb,
 }
 
 /* Wrappers to common functions */
-static int vsw_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t vsw_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	return sunvnet_start_xmit_common(skb, dev, vsw_tx_port_find);
 }
diff --git a/drivers/net/ethernet/sun/sunbmac.c b/drivers/net/ethernet/sun/sunbmac.c
index f047b27971564..720b7ac77f3b3 100644
--- a/drivers/net/ethernet/sun/sunbmac.c
+++ b/drivers/net/ethernet/sun/sunbmac.c
@@ -950,7 +950,8 @@ static void bigmac_tx_timeout(struct net_device *dev)
 }
 
 /* Put a packet on the wire. */
-static int bigmac_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t
+bigmac_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct bigmac *bp = netdev_priv(dev);
 	int len, entry;
diff --git a/drivers/net/ethernet/sun/sunqe.c b/drivers/net/ethernet/sun/sunqe.c
index 7fe0d5e339221..1468fa0a54e9b 100644
--- a/drivers/net/ethernet/sun/sunqe.c
+++ b/drivers/net/ethernet/sun/sunqe.c
@@ -570,7 +570,7 @@ static void qe_tx_timeout(struct net_device *dev)
 }
 
 /* Get a packet queued to go onto the wire. */
-static int qe_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t qe_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct sunqe *qep = netdev_priv(dev);
 	struct sunqe_buffers *qbufs = qep->buffers;
diff --git a/drivers/net/ethernet/sun/sunvnet.c b/drivers/net/ethernet/sun/sunvnet.c
index 12539b357a784..590172818b922 100644
--- a/drivers/net/ethernet/sun/sunvnet.c
+++ b/drivers/net/ethernet/sun/sunvnet.c
@@ -247,7 +247,7 @@ static u16 vnet_select_queue(struct net_device *dev, struct sk_buff *skb,
 }
 
 /* Wrappers to common functions */
-static int vnet_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t vnet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	return sunvnet_start_xmit_common(skb, dev, vnet_tx_port_find);
 }
diff --git a/drivers/net/ethernet/sun/sunvnet_common.c b/drivers/net/ethernet/sun/sunvnet_common.c
index d8f4c3f281505..baa3088b475c7 100644
--- a/drivers/net/ethernet/sun/sunvnet_common.c
+++ b/drivers/net/ethernet/sun/sunvnet_common.c
@@ -1216,9 +1216,10 @@ static inline struct sk_buff *vnet_skb_shape(struct sk_buff *skb, int ncookies)
 	return skb;
 }
 
-static int vnet_handle_offloads(struct vnet_port *port, struct sk_buff *skb,
-				struct vnet_port *(*vnet_tx_port)
-				(struct sk_buff *, struct net_device *))
+static netdev_tx_t
+vnet_handle_offloads(struct vnet_port *port, struct sk_buff *skb,
+		     struct vnet_port *(*vnet_tx_port)
+		     (struct sk_buff *, struct net_device *))
 {
 	struct net_device *dev = VNET_PORT_TO_NET_DEVICE(port);
 	struct vio_dring_state *dr = &port->vio.drings[VIO_DRIVER_TX_RING];
@@ -1321,9 +1322,10 @@ static int vnet_handle_offloads(struct vnet_port *port, struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
-int sunvnet_start_xmit_common(struct sk_buff *skb, struct net_device *dev,
-			      struct vnet_port *(*vnet_tx_port)
-			      (struct sk_buff *, struct net_device *))
+netdev_tx_t
+sunvnet_start_xmit_common(struct sk_buff *skb, struct net_device *dev,
+			  struct vnet_port *(*vnet_tx_port)
+			  (struct sk_buff *, struct net_device *))
 {
 	struct vnet_port *port = NULL;
 	struct vio_dring_state *dr;
diff --git a/drivers/net/ethernet/sun/sunvnet_common.h b/drivers/net/ethernet/sun/sunvnet_common.h
index 1ea0b016580a4..2b808d2482d60 100644
--- a/drivers/net/ethernet/sun/sunvnet_common.h
+++ b/drivers/net/ethernet/sun/sunvnet_common.h
@@ -136,9 +136,10 @@ int sunvnet_close_common(struct net_device *dev);
 void sunvnet_set_rx_mode_common(struct net_device *dev, struct vnet *vp);
 int sunvnet_set_mac_addr_common(struct net_device *dev, void *p);
 void sunvnet_tx_timeout_common(struct net_device *dev);
-int sunvnet_start_xmit_common(struct sk_buff *skb, struct net_device *dev,
-			   struct vnet_port *(*vnet_tx_port)
-			   (struct sk_buff *, struct net_device *));
+netdev_tx_t
+sunvnet_start_xmit_common(struct sk_buff *skb, struct net_device *dev,
+			  struct vnet_port *(*vnet_tx_port)
+			  (struct sk_buff *, struct net_device *));
 #ifdef CONFIG_NET_POLL_CONTROLLER
 void sunvnet_poll_controller_common(struct net_device *dev, struct vnet *vp);
 #endif
-- 
2.20.1

