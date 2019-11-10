Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B01B5F64CE
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 04:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729414AbfKJCtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 21:49:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:58138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728495AbfKJCtR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:49:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 535B622593;
        Sun, 10 Nov 2019 02:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354157;
        bh=hPCzig74fT8Qr+a6ZmQjOQUngro2H+1RdsElSjjB0i0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WH6oNsP/ITtkxLrMvRyXqfklw4qM7x3WlXoCc9xRZ5jFQTZin9azNJQkimtcCXZfI
         HbpVS5X7wRsQxER5UsDpdK3SRIz1agOKPNM8E0RAtDcLafW8lVGOqqun1Nk/8U5KAy
         UeA0eDub1IK8kUZWhSTblPSf+1dVT8b6ZfIUPcNY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 14/66] net: amd: fix return type of ndo_start_xmit function
Date:   Sat,  9 Nov 2019 21:47:53 -0500
Message-Id: <20191110024846.32598-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024846.32598-1-sashal@kernel.org>
References: <20191110024846.32598-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit fe72352e37ae8478f4c97975a9831f0c50f22e73 ]

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, so make sure the implementation in
this driver has returns 'netdev_tx_t' value, and change the function
return type to netdev_tx_t.

Found by coccinelle.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/am79c961a.c     | 2 +-
 drivers/net/ethernet/amd/atarilance.c    | 6 ++++--
 drivers/net/ethernet/amd/declance.c      | 2 +-
 drivers/net/ethernet/amd/sun3lance.c     | 6 ++++--
 drivers/net/ethernet/amd/sunlance.c      | 2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c | 4 ++--
 6 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/amd/am79c961a.c b/drivers/net/ethernet/amd/am79c961a.c
index fcdf5dda448f9..77d99c532917c 100644
--- a/drivers/net/ethernet/amd/am79c961a.c
+++ b/drivers/net/ethernet/amd/am79c961a.c
@@ -440,7 +440,7 @@ static void am79c961_timeout(struct net_device *dev)
 /*
  * Transmit a packet
  */
-static int
+static netdev_tx_t
 am79c961_sendpacket(struct sk_buff *skb, struct net_device *dev)
 {
 	struct dev_priv *priv = netdev_priv(dev);
diff --git a/drivers/net/ethernet/amd/atarilance.c b/drivers/net/ethernet/amd/atarilance.c
index d2bc8e5dcd23b..35a9f252ceb6c 100644
--- a/drivers/net/ethernet/amd/atarilance.c
+++ b/drivers/net/ethernet/amd/atarilance.c
@@ -339,7 +339,8 @@ static unsigned long lance_probe1( struct net_device *dev, struct lance_addr
                                    *init_rec );
 static int lance_open( struct net_device *dev );
 static void lance_init_ring( struct net_device *dev );
-static int lance_start_xmit( struct sk_buff *skb, struct net_device *dev );
+static netdev_tx_t lance_start_xmit(struct sk_buff *skb,
+				    struct net_device *dev);
 static irqreturn_t lance_interrupt( int irq, void *dev_id );
 static int lance_rx( struct net_device *dev );
 static int lance_close( struct net_device *dev );
@@ -770,7 +771,8 @@ static void lance_tx_timeout (struct net_device *dev)
 
 /* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
 
-static int lance_start_xmit( struct sk_buff *skb, struct net_device *dev )
+static netdev_tx_t
+lance_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct lance_private *lp = netdev_priv(dev);
 	struct lance_ioreg	 *IO = lp->iobase;
diff --git a/drivers/net/ethernet/amd/declance.c b/drivers/net/ethernet/amd/declance.c
index 9e80a76c3dfe1..76393ae4cf0aa 100644
--- a/drivers/net/ethernet/amd/declance.c
+++ b/drivers/net/ethernet/amd/declance.c
@@ -893,7 +893,7 @@ static void lance_tx_timeout(struct net_device *dev)
 	netif_wake_queue(dev);
 }
 
-static int lance_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t lance_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct lance_private *lp = netdev_priv(dev);
 	volatile struct lance_regs *ll = lp->ll;
diff --git a/drivers/net/ethernet/amd/sun3lance.c b/drivers/net/ethernet/amd/sun3lance.c
index 3d8c6b2cdea4c..09271665712da 100644
--- a/drivers/net/ethernet/amd/sun3lance.c
+++ b/drivers/net/ethernet/amd/sun3lance.c
@@ -235,7 +235,8 @@ struct lance_private {
 static int lance_probe( struct net_device *dev);
 static int lance_open( struct net_device *dev );
 static void lance_init_ring( struct net_device *dev );
-static int lance_start_xmit( struct sk_buff *skb, struct net_device *dev );
+static netdev_tx_t lance_start_xmit(struct sk_buff *skb,
+				    struct net_device *dev);
 static irqreturn_t lance_interrupt( int irq, void *dev_id);
 static int lance_rx( struct net_device *dev );
 static int lance_close( struct net_device *dev );
@@ -511,7 +512,8 @@ static void lance_init_ring( struct net_device *dev )
 }
 
 
-static int lance_start_xmit( struct sk_buff *skb, struct net_device *dev )
+static netdev_tx_t
+lance_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct lance_private *lp = netdev_priv(dev);
 	int entry, len;
diff --git a/drivers/net/ethernet/amd/sunlance.c b/drivers/net/ethernet/amd/sunlance.c
index 3153465d4d02f..acbbe4e5a2f8c 100644
--- a/drivers/net/ethernet/amd/sunlance.c
+++ b/drivers/net/ethernet/amd/sunlance.c
@@ -1106,7 +1106,7 @@ static void lance_tx_timeout(struct net_device *dev)
 	netif_wake_queue(dev);
 }
 
-static int lance_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t lance_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct lance_private *lp = netdev_priv(dev);
 	int entry, skblen, len;
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 1e4e8b245cd55..1df7f5da8411f 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -1390,7 +1390,7 @@ static int xgbe_close(struct net_device *netdev)
 	return 0;
 }
 
-static int xgbe_xmit(struct sk_buff *skb, struct net_device *netdev)
+static netdev_tx_t xgbe_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
 	struct xgbe_prv_data *pdata = netdev_priv(netdev);
 	struct xgbe_hw_if *hw_if = &pdata->hw_if;
@@ -1399,7 +1399,7 @@ static int xgbe_xmit(struct sk_buff *skb, struct net_device *netdev)
 	struct xgbe_ring *ring;
 	struct xgbe_packet_data *packet;
 	struct netdev_queue *txq;
-	int ret;
+	netdev_tx_t ret;
 
 	DBGPR("-->xgbe_xmit: skb->len = %d\n", skb->len);
 
-- 
2.20.1

