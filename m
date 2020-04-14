Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5421A703B
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 02:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390561AbgDNAqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 20:46:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35238 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390520AbgDNAqE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 20:46:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Y1B8tJz28zQbby7GJ0l44BV4O9MbaOKDunNvhp87W78=; b=q9LH0+OMaq0qUobNahl3Fl8lZa
        H8sdT5k+ZLOm6ceAbyi8HyckEGG2jzV3AQJiFBY9OsWseFzhGEl2Mrcl+tBeLttsOytpzCzPmWySu
        Uz76vOVnAWr42upy22IfO6GFYb4IGMl0dJRkar+Vx8tKAnRwsWcfFEf6uftNcx9CjpDg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jO9iB-002Y3F-NY; Tue, 14 Apr 2020 02:45:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, fugang.duan@nxp.com,
        Chris Healy <Chris.Healy@zii.aero>,
        Andrew Lunn <andrew@lunn.ch>, Chris Heally <cphealy@gmail.com>
Subject: [PATCH] net: ethernet: fec: Replace interrupt driven MDIO with polled IO
Date:   Tue, 14 Apr 2020 02:45:51 +0200
Message-Id: <20200414004551.607503-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.0.rc2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Measurements of the MDIO bus have shown that driving the MDIO bus
using interrupts is slow. Back to back MDIO transactions take about
90uS, with 25uS spent performing the transaction, and the remainder of
the time the bus is idle.

Replacing the completion interrupt with polled IO results in back to
back transactions of 40uS. The polling loop waiting for the hardware
to complete the transaction takes around 27uS. Which suggests
interrupt handling has an overhead of 50uS, and polled IO nearly
halves this overhead, and doubles the MDIO performance.

Suggested-by: Chris Heally <cphealy@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/freescale/fec.h      |  4 +-
 drivers/net/ethernet/freescale/fec_main.c | 69 ++++++++++++-----------
 2 files changed, 37 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index bd898f5b4da5..4c8e7f57957a 100644
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
@@ -537,7 +536,6 @@ struct fec_enet_private {
 	int	link;
 	int	full_duplex;
 	int	speed;
-	struct	completion mdio_done;
 	int	irq[FEC_IRQ_NUM];
 	bool	bufdesc_ex;
 	int	pause_flag;
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index c1c267b61647..48ac0a3a4eb0 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -938,8 +938,8 @@ fec_restart(struct net_device *ndev)
 	writel((__force u32)cpu_to_be32(temp_mac[1]),
 	       fep->hwp + FEC_ADDR_HIGH);
 
-	/* Clear any outstanding interrupt. */
-	writel(0xffffffff, fep->hwp + FEC_IEVENT);
+	/* Clear any outstanding interrupt, except MDIO. */
+	writel((0xffffffff & ~FEC_ENET_MII), fep->hwp + FEC_IEVENT);
 
 	fec_enet_bd_init(ndev);
 
@@ -1085,7 +1085,7 @@ fec_restart(struct net_device *ndev)
 	if (fep->link)
 		writel(FEC_DEFAULT_IMASK, fep->hwp + FEC_IMASK);
 	else
-		writel(FEC_ENET_MII, fep->hwp + FEC_IMASK);
+		writel(0, fep->hwp + FEC_IMASK);
 
 	/* Init the interrupt coalescing */
 	fec_enet_itr_coal_init(ndev);
@@ -1599,6 +1599,10 @@ fec_enet_interrupt(int irq, void *dev_id)
 	irqreturn_t ret = IRQ_NONE;
 
 	int_events = readl(fep->hwp + FEC_IEVENT);
+
+	/* Don't clear MDIO events, we poll for those */
+	int_events &= ~FEC_ENET_MII;
+
 	writel(int_events, fep->hwp + FEC_IEVENT);
 	fec_enet_collect_events(fep, int_events);
 
@@ -1606,16 +1610,12 @@ fec_enet_interrupt(int irq, void *dev_id)
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
 
@@ -1765,11 +1765,26 @@ static void fec_enet_adjust_link(struct net_device *ndev)
 		phy_print_status(phy_dev);
 }
 
+static int fec_enet_mdio_wait(struct fec_enet_private *fep)
+{
+	int retries = 10000;
+	uint ievent;
+
+	while (retries--) {
+		ievent = readl(fep->hwp + FEC_IEVENT);
+		if (ievent & FEC_ENET_MII) {
+			writel(FEC_ENET_MII, fep->hwp + FEC_IEVENT);
+			return 0;
+		}
+	}
+
+	return -ETIMEDOUT;
+}
+
 static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 {
 	struct fec_enet_private *fep = bus->priv;
 	struct device *dev = &fep->pdev->dev;
-	unsigned long time_left;
 	int ret = 0, frame_start, frame_addr, frame_op;
 	bool is_c45 = !!(regnum & MII_ADDR_C45);
 
@@ -1777,8 +1792,6 @@ static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 	if (ret < 0)
 		return ret;
 
-	reinit_completion(&fep->mdio_done);
-
 	if (is_c45) {
 		frame_start = FEC_MMFR_ST_C45;
 
@@ -1790,11 +1803,9 @@ static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
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
 
@@ -1813,11 +1824,9 @@ static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
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
 
@@ -1835,7 +1844,6 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 {
 	struct fec_enet_private *fep = bus->priv;
 	struct device *dev = &fep->pdev->dev;
-	unsigned long time_left;
 	int ret, frame_start, frame_addr;
 	bool is_c45 = !!(regnum & MII_ADDR_C45);
 
@@ -1845,8 +1853,6 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 	else
 		ret = 0;
 
-	reinit_completion(&fep->mdio_done);
-
 	if (is_c45) {
 		frame_start = FEC_MMFR_ST_C45;
 
@@ -1858,11 +1864,9 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
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
@@ -1878,12 +1882,9 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
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
@@ -2079,6 +2080,9 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 
 	writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
 
+	/* Clear any pending transaction complete indication */
+	writel(FEC_ENET_MII, fep->hwp + FEC_IEVENT);
+
 	fep->mii_bus = mdiobus_alloc();
 	if (fep->mii_bus == NULL) {
 		err = -ENOMEM;
@@ -3583,7 +3587,6 @@ fec_probe(struct platform_device *pdev)
 		fep->irq[i] = irq;
 	}
 
-	init_completion(&fep->mdio_done);
 	ret = fec_enet_mii_init(pdev);
 	if (ret)
 		goto failed_mii_init;
-- 
2.26.0

