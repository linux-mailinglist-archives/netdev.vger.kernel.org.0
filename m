Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD1931584B4
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 22:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbgBJV0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 16:26:50 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:59712 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727422AbgBJV0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 16:26:49 -0500
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id F1B1529B45; Mon, 10 Feb 2020 16:26:47 -0500 (EST)
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <939b34c7ca586da61da9fdf5cce169a0e9ff9c1b.1581369531.git.fthain@telegraphics.com.au>
In-Reply-To: <cover.1581369530.git.fthain@telegraphics.com.au>
References: <cover.1581369530.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH net-next 2/7] net/sonic: Refactor duplicated code
Date:   Tue, 11 Feb 2020 08:18:50 +1100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No functional change.

Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/net/ethernet/natsemi/jazzsonic.c | 31 ++----------------
 drivers/net/ethernet/natsemi/macsonic.c  | 29 ++---------------
 drivers/net/ethernet/natsemi/sonic.c     | 36 +++++++++++++++++++++
 drivers/net/ethernet/natsemi/sonic.h     |  1 +
 drivers/net/ethernet/natsemi/xtsonic.c   | 40 ++----------------------
 5 files changed, 44 insertions(+), 93 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/jazzsonic.c b/drivers/net/ethernet/natsemi/jazzsonic.c
index 51fa82b429a3..bfa0c0d39600 100644
--- a/drivers/net/ethernet/natsemi/jazzsonic.c
+++ b/drivers/net/ethernet/natsemi/jazzsonic.c
@@ -147,39 +147,12 @@ static int sonic_probe1(struct net_device *dev)
 		dev->dev_addr[i*2+1] = val >> 8;
 	}
 
-	err = -ENOMEM;
-
-	/* Initialize the device structure. */
-
 	lp->dma_bitmode = SONIC_BITMODE32;
 
-	/* Allocate the entire chunk of memory for the descriptors.
-           Note that this cannot cross a 64K boundary. */
-	lp->descriptors = dma_alloc_coherent(lp->device,
-					     SIZEOF_SONIC_DESC *
-					     SONIC_BUS_SCALE(lp->dma_bitmode),
-					     &lp->descriptors_laddr,
-					     GFP_KERNEL);
-	if (lp->descriptors == NULL)
+	err = sonic_alloc_descriptors(dev);
+	if (err)
 		goto out;
 
-	/* Now set up the pointers to point to the appropriate places */
-	lp->cda = lp->descriptors;
-	lp->tda = lp->cda + (SIZEOF_SONIC_CDA
-	                     * SONIC_BUS_SCALE(lp->dma_bitmode));
-	lp->rda = lp->tda + (SIZEOF_SONIC_TD * SONIC_NUM_TDS
-	                     * SONIC_BUS_SCALE(lp->dma_bitmode));
-	lp->rra = lp->rda + (SIZEOF_SONIC_RD * SONIC_NUM_RDS
-	                     * SONIC_BUS_SCALE(lp->dma_bitmode));
-
-	lp->cda_laddr = lp->descriptors_laddr;
-	lp->tda_laddr = lp->cda_laddr + (SIZEOF_SONIC_CDA
-	                     * SONIC_BUS_SCALE(lp->dma_bitmode));
-	lp->rda_laddr = lp->tda_laddr + (SIZEOF_SONIC_TD * SONIC_NUM_TDS
-	                     * SONIC_BUS_SCALE(lp->dma_bitmode));
-	lp->rra_laddr = lp->rda_laddr + (SIZEOF_SONIC_RD * SONIC_NUM_RDS
-	                     * SONIC_BUS_SCALE(lp->dma_bitmode));
-
 	dev->netdev_ops = &sonic_netdev_ops;
 	dev->watchdog_timeo = TX_TIMEOUT;
 
diff --git a/drivers/net/ethernet/natsemi/macsonic.c b/drivers/net/ethernet/natsemi/macsonic.c
index 0937fc2a928e..0f4d0c25d626 100644
--- a/drivers/net/ethernet/natsemi/macsonic.c
+++ b/drivers/net/ethernet/natsemi/macsonic.c
@@ -186,33 +186,10 @@ static const struct net_device_ops macsonic_netdev_ops = {
 static int macsonic_init(struct net_device *dev)
 {
 	struct sonic_local* lp = netdev_priv(dev);
+	int err = sonic_alloc_descriptors(dev);
 
-	/* Allocate the entire chunk of memory for the descriptors.
-           Note that this cannot cross a 64K boundary. */
-	lp->descriptors = dma_alloc_coherent(lp->device,
-					     SIZEOF_SONIC_DESC *
-					     SONIC_BUS_SCALE(lp->dma_bitmode),
-					     &lp->descriptors_laddr,
-					     GFP_KERNEL);
-	if (lp->descriptors == NULL)
-		return -ENOMEM;
-
-	/* Now set up the pointers to point to the appropriate places */
-	lp->cda = lp->descriptors;
-	lp->tda = lp->cda + (SIZEOF_SONIC_CDA
-	                     * SONIC_BUS_SCALE(lp->dma_bitmode));
-	lp->rda = lp->tda + (SIZEOF_SONIC_TD * SONIC_NUM_TDS
-	                     * SONIC_BUS_SCALE(lp->dma_bitmode));
-	lp->rra = lp->rda + (SIZEOF_SONIC_RD * SONIC_NUM_RDS
-	                     * SONIC_BUS_SCALE(lp->dma_bitmode));
-
-	lp->cda_laddr = lp->descriptors_laddr;
-	lp->tda_laddr = lp->cda_laddr + (SIZEOF_SONIC_CDA
-	                     * SONIC_BUS_SCALE(lp->dma_bitmode));
-	lp->rda_laddr = lp->tda_laddr + (SIZEOF_SONIC_TD * SONIC_NUM_TDS
-	                     * SONIC_BUS_SCALE(lp->dma_bitmode));
-	lp->rra_laddr = lp->rda_laddr + (SIZEOF_SONIC_RD * SONIC_NUM_RDS
-	                     * SONIC_BUS_SCALE(lp->dma_bitmode));
+	if (err)
+		return err;
 
 	dev->netdev_ops = &macsonic_netdev_ops;
 	dev->watchdog_timeo = TX_TIMEOUT;
diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
index e01273654f81..c066510b348e 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -50,6 +50,42 @@ static void sonic_msg_init(struct net_device *dev)
 		netif_dbg(lp, drv, dev, "%s", version);
 }
 
+static int sonic_alloc_descriptors(struct net_device *dev)
+{
+	struct sonic_local *lp = netdev_priv(dev);
+
+	/* Allocate a chunk of memory for the descriptors. Note that this
+	 * must not cross a 64K boundary. It is smaller than one page which
+	 * means that page alignment is a sufficient condition.
+	 */
+	lp->descriptors =
+		dma_alloc_coherent(lp->device,
+				   SIZEOF_SONIC_DESC *
+				   SONIC_BUS_SCALE(lp->dma_bitmode),
+				   &lp->descriptors_laddr, GFP_KERNEL);
+
+	if (!lp->descriptors)
+		return -ENOMEM;
+
+	lp->cda = lp->descriptors;
+	lp->tda = lp->cda + SIZEOF_SONIC_CDA *
+			    SONIC_BUS_SCALE(lp->dma_bitmode);
+	lp->rda = lp->tda + SIZEOF_SONIC_TD * SONIC_NUM_TDS *
+			    SONIC_BUS_SCALE(lp->dma_bitmode);
+	lp->rra = lp->rda + SIZEOF_SONIC_RD * SONIC_NUM_RDS *
+			    SONIC_BUS_SCALE(lp->dma_bitmode);
+
+	lp->cda_laddr = lp->descriptors_laddr;
+	lp->tda_laddr = lp->cda_laddr + SIZEOF_SONIC_CDA *
+					SONIC_BUS_SCALE(lp->dma_bitmode);
+	lp->rda_laddr = lp->tda_laddr + SIZEOF_SONIC_TD * SONIC_NUM_TDS *
+					SONIC_BUS_SCALE(lp->dma_bitmode);
+	lp->rra_laddr = lp->rda_laddr + SIZEOF_SONIC_RD * SONIC_NUM_RDS *
+					SONIC_BUS_SCALE(lp->dma_bitmode);
+
+	return 0;
+}
+
 /*
  * Open/initialize the SONIC controller.
  *
diff --git a/drivers/net/ethernet/natsemi/sonic.h b/drivers/net/ethernet/natsemi/sonic.h
index e0e4cba6f6f6..053f12f5cf4a 100644
--- a/drivers/net/ethernet/natsemi/sonic.h
+++ b/drivers/net/ethernet/natsemi/sonic.h
@@ -342,6 +342,7 @@ static void sonic_multicast_list(struct net_device *dev);
 static int sonic_init(struct net_device *dev);
 static void sonic_tx_timeout(struct net_device *dev, unsigned int txqueue);
 static void sonic_msg_init(struct net_device *dev);
+static int sonic_alloc_descriptors(struct net_device *dev);
 
 /* Internal inlines for reading/writing DMA buffers.  Note that bus
    size and endianness matter here, whereas they don't for registers,
diff --git a/drivers/net/ethernet/natsemi/xtsonic.c b/drivers/net/ethernet/natsemi/xtsonic.c
index e1b886e87a76..dda9ec7d9cee 100644
--- a/drivers/net/ethernet/natsemi/xtsonic.c
+++ b/drivers/net/ethernet/natsemi/xtsonic.c
@@ -167,47 +167,11 @@ static int __init sonic_probe1(struct net_device *dev)
 		dev->dev_addr[i*2+1] = val >> 8;
 	}
 
-	/* Initialize the device structure. */
-
 	lp->dma_bitmode = SONIC_BITMODE32;
 
-	/*
-	 *  Allocate local private descriptor areas in uncached space.
-	 *  The entire structure must be located within the same 64kb segment.
-	 *  A simple way to ensure this is to allocate twice the
-	 *  size of the structure -- given that the structure is
-	 *  much less than 64 kB, at least one of the halves of
-	 *  the allocated area will be contained entirely in 64 kB.
-	 *  We also allocate extra space for a pointer to allow freeing
-	 *  this structure later on (in xtsonic_cleanup_module()).
-	 */
-	lp->descriptors = dma_alloc_coherent(lp->device,
-					     SIZEOF_SONIC_DESC *
-					     SONIC_BUS_SCALE(lp->dma_bitmode),
-					     &lp->descriptors_laddr,
-					     GFP_KERNEL);
-	if (lp->descriptors == NULL) {
-		err = -ENOMEM;
+	err = sonic_alloc_descriptors(dev);
+	if (err)
 		goto out;
-	}
-
-	lp->cda = lp->descriptors;
-	lp->tda = lp->cda + (SIZEOF_SONIC_CDA
-			     * SONIC_BUS_SCALE(lp->dma_bitmode));
-	lp->rda = lp->tda + (SIZEOF_SONIC_TD * SONIC_NUM_TDS
-			     * SONIC_BUS_SCALE(lp->dma_bitmode));
-	lp->rra = lp->rda + (SIZEOF_SONIC_RD * SONIC_NUM_RDS
-			     * SONIC_BUS_SCALE(lp->dma_bitmode));
-
-	/* get the virtual dma address */
-
-	lp->cda_laddr = lp->descriptors_laddr;
-	lp->tda_laddr = lp->cda_laddr + (SIZEOF_SONIC_CDA
-				         * SONIC_BUS_SCALE(lp->dma_bitmode));
-	lp->rda_laddr = lp->tda_laddr + (SIZEOF_SONIC_TD * SONIC_NUM_TDS
-					 * SONIC_BUS_SCALE(lp->dma_bitmode));
-	lp->rra_laddr = lp->rda_laddr + (SIZEOF_SONIC_RD * SONIC_NUM_RDS
-					 * SONIC_BUS_SCALE(lp->dma_bitmode));
 
 	dev->netdev_ops		= &xtsonic_netdev_ops;
 	dev->watchdog_timeo	= TX_TIMEOUT;
-- 
2.24.1

