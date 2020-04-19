Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6178E1AFE81
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 00:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgDSWER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 18:04:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49068 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbgDSWER (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 18:04:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BNOo4Q0VtPGq9TCfJVloGu4ducy8+y7WAKlBfKjuers=; b=43BwwkWojCGYz+XB3n5wEUuxWH
        /VckVZahSN3VKDhxDomEtYIXzT4m7kaTz07GK8YLLQbsPTIVDv+0KJzvCZz/RNCoOqeIsjhtabjeb
        PP23keYheF87XAFfpSuYi9BLdoK4K/8bUI85fIrOmHOHqWnE+bx+eNzLOiuAvBviHwwY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jQI2w-003hqk-5G; Mon, 20 Apr 2020 00:04:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, fugang.duan@nxp.com,
        Andrew Lunn <andrew@lunn.ch>, Chris Heally <cphealy@gmail.com>
Subject: [PATCH net-next v3 1/3] net: ethernet: fec: Replace interrupt driven MDIO with polled IO
Date:   Mon, 20 Apr 2020 00:04:00 +0200
Message-Id: <20200419220402.883493-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.0.rc2
In-Reply-To: <20200419220402.883493-1-andrew@lunn.ch>
References: <20200419220402.883493-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Measurements of the MDIO bus have shown that driving the MDIO bus
using interrupts is slow. Back to back MDIO transactions take about
90us, with 25us spent performing the transaction, and the remainder of
the time the bus is idle.

Replacing the completion interrupt with polled IO results in back to
back transactions of 40us. The polling loop waiting for the hardware
to complete the transaction takes around 28us. Which suggests
interrupt handling has an overhead of 50us, and polled IO nearly
halves this overhead, and doubles the MDIO performance.

Suggested-by: Chris Heally <cphealy@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
v3:
Use readl_poll_timeout_atomic() which used the accurate udelay()
s/uS/us/g
---
 drivers/net/ethernet/freescale/fec.h      |  4 +-
 drivers/net/ethernet/freescale/fec_main.c | 67 ++++++++++++-----------
 2 files changed, 35 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index e74dd1f86bba..a6cdd5b61921 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -376,8 +376,7 @@ struct bufdesc_ex {
 #define FEC_ENET_TS_AVAIL       ((uint)0x00010000)
 #define FEC_ENET_TS_TIMER       ((uint)0x00008000)
 
-#define FEC_DEFAULT_IMASK (FEC_ENET_TXF | FEC_ENET_RXF | FEC_ENET_MII)
-#define FEC_NAPI_IMASK	FEC_ENET_MII
+#define FEC_DEFAULT_IMASK (FEC_ENET_TXF | FEC_ENET_RXF)
 #define FEC_RX_DISABLED_IMASK (FEC_DEFAULT_IMASK & (~FEC_ENET_RXF))
 
 /* ENET interrupt coalescing macro define */
@@ -543,7 +542,6 @@ struct fec_enet_private {
 	int	link;
 	int	full_duplex;
 	int	speed;
-	struct	completion mdio_done;
 	int	irq[FEC_IRQ_NUM];
 	bool	bufdesc_ex;
 	int	pause_flag;
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index dc6f8763a5d4..2267bf75784e 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -976,8 +976,8 @@ fec_restart(struct net_device *ndev)
 	writel((__force u32)cpu_to_be32(temp_mac[1]),
 	       fep->hwp + FEC_ADDR_HIGH);
 
-	/* Clear any outstanding interrupt. */
-	writel(0xffffffff, fep->hwp + FEC_IEVENT);
+	/* Clear any outstanding interrupt, except MDIO. */
+	writel((0xffffffff & ~FEC_ENET_MII), fep->hwp + FEC_IEVENT);
 
 	fec_enet_bd_init(ndev);
 
@@ -1123,7 +1123,7 @@ fec_restart(struct net_device *ndev)
 	if (fep->link)
 		writel(FEC_DEFAULT_IMASK, fep->hwp + FEC_IMASK);
 	else
-		writel(FEC_ENET_MII, fep->hwp + FEC_IMASK);
+		writel(0, fep->hwp + FEC_IMASK);
 
 	/* Init the interrupt coalescing */
 	fec_enet_itr_coal_init(ndev);
@@ -1652,6 +1652,10 @@ fec_enet_interrupt(int irq, void *dev_id)
 	irqreturn_t ret = IRQ_NONE;
 
 	int_events = readl(fep->hwp + FEC_IEVENT);
+
+	/* Don't clear MDIO events, we poll for those */
+	int_events &= ~FEC_ENET_MII;
+
 	writel(int_events, fep->hwp + FEC_IEVENT);
 	fec_enet_collect_events(fep, int_events);
 
@@ -1659,16 +1663,12 @@ fec_enet_interrupt(int irq, void *dev_id)
 		ret = IRQ_HANDLED;
 
 		if (napi_schedule_prep(&fep->napi)) {
-			/* Disable the NAPI interrupts */
-			writel(FEC_NAPI_IMASK, fep->hwp + FEC_IMASK);
+			/* Disable interrupts */
+			writel(0, fep->hwp + FEC_IMASK);
 			__napi_schedule(&fep->napi);
 		}
 	}
 
-	if (int_events & FEC_ENET_MII) {
-		ret = IRQ_HANDLED;
-		complete(&fep->mdio_done);
-	}
 	return ret;
 }
 
@@ -1818,11 +1818,24 @@ static void fec_enet_adjust_link(struct net_device *ndev)
 		phy_print_status(phy_dev);
 }
 
+static int fec_enet_mdio_wait(struct fec_enet_private *fep)
+{
+	uint ievent;
+	int ret;
+
+	ret = readl_poll_timeout_atomic(fep->hwp + FEC_IEVENT, ievent,
+					ievent & FEC_ENET_MII, 2, 30000);
+
+	if (!ret)
+		writel(FEC_ENET_MII, fep->hwp + FEC_IEVENT);
+
+	return ret;
+}
+
 static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 {
 	struct fec_enet_private *fep = bus->priv;
 	struct device *dev = &fep->pdev->dev;
-	unsigned long time_left;
 	int ret = 0, frame_start, frame_addr, frame_op;
 	bool is_c45 = !!(regnum & MII_ADDR_C45);
 
@@ -1830,8 +1843,6 @@ static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 	if (ret < 0)
 		return ret;
 
-	reinit_completion(&fep->mdio_done);
-
 	if (is_c45) {
 		frame_start = FEC_MMFR_ST_C45;
 
@@ -1843,11 +1854,9 @@ static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 		       fep->hwp + FEC_MII_DATA);
 
 		/* wait for end of transfer */
-		time_left = wait_for_completion_timeout(&fep->mdio_done,
-				usecs_to_jiffies(FEC_MII_TIMEOUT));
-		if (time_left == 0) {
+		ret = fec_enet_mdio_wait(fep);
+		if (ret) {
 			netdev_err(fep->netdev, "MDIO address write timeout\n");
-			ret = -ETIMEDOUT;
 			goto out;
 		}
 
@@ -1866,11 +1875,9 @@ static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 		FEC_MMFR_TA, fep->hwp + FEC_MII_DATA);
 
 	/* wait for end of transfer */
-	time_left = wait_for_completion_timeout(&fep->mdio_done,
-			usecs_to_jiffies(FEC_MII_TIMEOUT));
-	if (time_left == 0) {
+	ret = fec_enet_mdio_wait(fep);
+	if (ret) {
 		netdev_err(fep->netdev, "MDIO read timeout\n");
-		ret = -ETIMEDOUT;
 		goto out;
 	}
 
@@ -1888,7 +1895,6 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 {
 	struct fec_enet_private *fep = bus->priv;
 	struct device *dev = &fep->pdev->dev;
-	unsigned long time_left;
 	int ret, frame_start, frame_addr;
 	bool is_c45 = !!(regnum & MII_ADDR_C45);
 
@@ -1898,8 +1904,6 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 	else
 		ret = 0;
 
-	reinit_completion(&fep->mdio_done);
-
 	if (is_c45) {
 		frame_start = FEC_MMFR_ST_C45;
 
@@ -1911,11 +1915,9 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 		       fep->hwp + FEC_MII_DATA);
 
 		/* wait for end of transfer */
-		time_left = wait_for_completion_timeout(&fep->mdio_done,
-			usecs_to_jiffies(FEC_MII_TIMEOUT));
-		if (time_left == 0) {
+		ret = fec_enet_mdio_wait(fep);
+		if (ret) {
 			netdev_err(fep->netdev, "MDIO address write timeout\n");
-			ret = -ETIMEDOUT;
 			goto out;
 		}
 	} else {
@@ -1931,12 +1933,9 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 		fep->hwp + FEC_MII_DATA);
 
 	/* wait for end of transfer */
-	time_left = wait_for_completion_timeout(&fep->mdio_done,
-			usecs_to_jiffies(FEC_MII_TIMEOUT));
-	if (time_left == 0) {
+	ret = fec_enet_mdio_wait(fep);
+	if (ret)
 		netdev_err(fep->netdev, "MDIO write timeout\n");
-		ret  = -ETIMEDOUT;
-	}
 
 out:
 	pm_runtime_mark_last_busy(dev);
@@ -2132,6 +2131,9 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 
 	writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
 
+	/* Clear any pending transaction complete indication */
+	writel(FEC_ENET_MII, fep->hwp + FEC_IEVENT);
+
 	fep->mii_bus = mdiobus_alloc();
 	if (fep->mii_bus == NULL) {
 		err = -ENOMEM;
@@ -3674,7 +3676,6 @@ fec_probe(struct platform_device *pdev)
 		fep->irq[i] = irq;
 	}
 
-	init_completion(&fep->mdio_done);
 	ret = fec_enet_mii_init(pdev);
 	if (ret)
 		goto failed_mii_init;
-- 
2.26.1

