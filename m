Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFEAEF6534
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 04:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729404AbfKJDFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 22:05:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:50290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727578AbfKJCqe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:46:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E132215EA;
        Sun, 10 Nov 2019 02:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353992;
        bh=dXwGSVy2f4webg2pIqE4lfGrrBVZiKD7bgSeg6fIUSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tPQp2UKDmdCz6I12ufslvsmoDtBydbxIlujSYubv5rNn2IFnLGs/o6FojZggaXnhr
         1hrdT9SB9knKojS4Y4z+qbfZX2aYVh1ve9WmdRJmztAmX+lUvAurxJ+cImGiIKjNDj
         ag0OA2z5SZn4k4f92YAC84FXechhGOsVM22owkYE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        Shannon Nelson <shannon.nelson@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 023/109] net: sun: fix return type of ndo_start_xmit function
Date:   Sat,  9 Nov 2019 21:44:15 -0500
Message-Id: <20191110024541.31567-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
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
index 5b56c24b6ed2e..e6b96c2989b22 100644
--- a/drivers/net/ethernet/sun/ldmvsw.c
+++ b/drivers/net/ethernet/sun/ldmvsw.c
@@ -111,7 +111,7 @@ static u16 vsw_select_queue(struct net_device *dev, struct sk_buff *skb,
 }
 
 /* Wrappers to common functions */
-static int vsw_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t vsw_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	return sunvnet_start_xmit_common(skb, dev, vsw_tx_port_find);
 }
diff --git a/drivers/net/ethernet/sun/sunbmac.c b/drivers/net/ethernet/sun/sunbmac.c
index 3189722110c26..9a60fb2b4e9dc 100644
--- a/drivers/net/ethernet/sun/sunbmac.c
+++ b/drivers/net/ethernet/sun/sunbmac.c
@@ -951,7 +951,8 @@ static void bigmac_tx_timeout(struct net_device *dev)
 }
 
 /* Put a packet on the wire. */
-static int bigmac_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t
+bigmac_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct bigmac *bp = netdev_priv(dev);
 	int len, entry;
diff --git a/drivers/net/ethernet/sun/sunqe.c b/drivers/net/ethernet/sun/sunqe.c
index a6bcdcdd947e3..82386a375bd26 100644
--- a/drivers/net/ethernet/sun/sunqe.c
+++ b/drivers/net/ethernet/sun/sunqe.c
@@ -569,7 +569,7 @@ static void qe_tx_timeout(struct net_device *dev)
 }
 
 /* Get a packet queued to go onto the wire. */
-static int qe_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t qe_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct sunqe *qep = netdev_priv(dev);
 	struct sunqe_buffers *qbufs = qep->buffers;
diff --git a/drivers/net/ethernet/sun/sunvnet.c b/drivers/net/ethernet/sun/sunvnet.c
index 65347d2f139b7..02ebbe74d93de 100644
--- a/drivers/net/ethernet/sun/sunvnet.c
+++ b/drivers/net/ethernet/sun/sunvnet.c
@@ -245,7 +245,7 @@ static u16 vnet_select_queue(struct net_device *dev, struct sk_buff *skb,
 }
 
 /* Wrappers to common functions */
-static int vnet_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t vnet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	return sunvnet_start_xmit_common(skb, dev, vnet_tx_port_find);
 }
diff --git a/drivers/net/ethernet/sun/sunvnet_common.c b/drivers/net/ethernet/sun/sunvnet_common.c
index ecf456c7b6d14..fd84ff8bba31a 100644
--- a/drivers/net/ethernet/sun/sunvnet_common.c
+++ b/drivers/net/ethernet/sun/sunvnet_common.c
@@ -1215,9 +1215,10 @@ static inline struct sk_buff *vnet_skb_shape(struct sk_buff *skb, int ncookies)
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
@@ -1320,9 +1321,10 @@ static int vnet_handle_offloads(struct vnet_port *port, struct sk_buff *skb,
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
index 6a4dd1fb19bf6..3fcb608fbbb31 100644
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

