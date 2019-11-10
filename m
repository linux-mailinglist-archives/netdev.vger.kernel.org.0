Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8A0F6242
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 03:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbfKJClf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 21:41:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:36054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727482AbfKJCle (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:41:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BE59215EA;
        Sun, 10 Nov 2019 02:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353693;
        bh=27UnLGs7geUNlPITp2DC2amL7h+TJPmXiMZ4kO6aEg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BkSaki+Ls8B8XbgLjAEGmUhsB+zRdLNgIhl5T2o8RcHaFuLoiv06Pds01u2xv+LT6
         CibIfR+JRXTmh1QMNkehhEu4wx8UZrCOtcaL3rWzIR3e0+M//ucQR6vzGHVaOh7Aol
         2ljc6lUXVaqcpGgbCGNrlVFmxtSwFvXdC3r9Hu0E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 044/191] net: amd: fix return type of ndo_start_xmit function
Date:   Sat,  9 Nov 2019 21:37:46 -0500
Message-Id: <20191110024013.29782-44-sashal@kernel.org>
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
index 01d132c02ff90..265039c57023f 100644
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
index c5b81268c2849..d3d44e07afbc0 100644
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
@@ -769,7 +770,8 @@ static void lance_tx_timeout (struct net_device *dev)
 
 /* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
 
-static int lance_start_xmit( struct sk_buff *skb, struct net_device *dev )
+static netdev_tx_t
+lance_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct lance_private *lp = netdev_priv(dev);
 	struct lance_ioreg	 *IO = lp->iobase;
diff --git a/drivers/net/ethernet/amd/declance.c b/drivers/net/ethernet/amd/declance.c
index 00332a1ea84b9..9f23703dd509f 100644
--- a/drivers/net/ethernet/amd/declance.c
+++ b/drivers/net/ethernet/amd/declance.c
@@ -894,7 +894,7 @@ static void lance_tx_timeout(struct net_device *dev)
 	netif_wake_queue(dev);
 }
 
-static int lance_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t lance_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct lance_private *lp = netdev_priv(dev);
 	volatile struct lance_regs *ll = lp->ll;
diff --git a/drivers/net/ethernet/amd/sun3lance.c b/drivers/net/ethernet/amd/sun3lance.c
index 77b1db2677309..da7e3d4f41661 100644
--- a/drivers/net/ethernet/amd/sun3lance.c
+++ b/drivers/net/ethernet/amd/sun3lance.c
@@ -236,7 +236,8 @@ struct lance_private {
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
index 19f89d9b1781f..9d48998268233 100644
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
index 24f1053b8785e..d96a84a62d78d 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2009,7 +2009,7 @@ static int xgbe_close(struct net_device *netdev)
 	return 0;
 }
 
-static int xgbe_xmit(struct sk_buff *skb, struct net_device *netdev)
+static netdev_tx_t xgbe_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
 	struct xgbe_prv_data *pdata = netdev_priv(netdev);
 	struct xgbe_hw_if *hw_if = &pdata->hw_if;
@@ -2018,7 +2018,7 @@ static int xgbe_xmit(struct sk_buff *skb, struct net_device *netdev)
 	struct xgbe_ring *ring;
 	struct xgbe_packet_data *packet;
 	struct netdev_queue *txq;
-	int ret;
+	netdev_tx_t ret;
 
 	DBGPR("-->xgbe_xmit: skb->len = %d\n", skb->len);
 
-- 
2.20.1

