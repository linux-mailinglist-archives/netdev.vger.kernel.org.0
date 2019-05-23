Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC2427C60
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 14:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730682AbfEWMCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 08:02:39 -0400
Received: from first.geanix.com ([116.203.34.67]:60938 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728309AbfEWMCj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 08:02:39 -0400
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id E4CB41172;
        Thu, 23 May 2019 12:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1558612904; bh=/1eM9ccCy5KpzovhNj1PcGcm7jxnG7earCjKEUl8ME0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=TMj8gqBcR1gSc8Rb/lhKkRumdez8ygcTi6o7jKXPVSBy+/y2ZS7JD/UDH6bYYFGT/
         xwkLsYOgjTGhfVJu0MUTrkQflYOlwfW+LRlSoeir5RXGRyCw0/cgVJonMPfDALJmJ9
         F4SAxYbGeC7NtRzMjJPgV49iRHGQIZ4Y9T4BxINKLvgMrkeFrv8fdFGCKm2GJFh3ak
         Lfzh9GlfH1qppN/0JGxxiRUHQmjC4RiDl5SdybrQrB2EvvZmhtpR3kvPaoYMVcVv4F
         WAr+MCxxt3fHD4OdxR/IohJtVsAQYPXxiIwfBkhAScO8aMNU0t9lCBFFNNJ2Jomgbi
         6GCuGv2WbJ1yw==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Andrew Lunn <andrew@lunn.ch>,
        YueHaibing <yuehaibing@huawei.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Yang Wei <yang.wei9@zte.com.cn>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] net: ll_temac: Prepare indirect register access for multicast support
Date:   Thu, 23 May 2019 14:02:20 +0200
Message-Id: <20190523120222.3807-3-esben@geanix.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523120222.3807-1-esben@geanix.com>
References: <20190523120222.3807-1-esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 796779db2bec
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With .ndo_set_rx_mode/temac_set_multicast_list() being called in atomic
context (holding addr_list_lock), and temac_set_multicast_list() needing
to access temac indirect registers, the mutex used to synchronize indirect
register is a no-no.

Replace it with a spinlock, and avoid sleeping in
temac_indirect_busywait().

To avoid excessive holding of the lock, which is now a spinlock, the
temac_device_reset() function is changed to only hold the lock for short
periods.  With timeouts, it could be holding the spinlock for more than
2 seconds.

Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/xilinx/ll_temac.h        |   5 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c   | 240 ++++++++++++++++++--------
 drivers/net/ethernet/xilinx/ll_temac_mdio.c   |  20 +--
 include/linux/platform_data/xilinx-ll-temac.h |   3 +-
 4 files changed, 179 insertions(+), 89 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac.h b/drivers/net/ethernet/xilinx/ll_temac.h
index 1aeda08..276292b 100644
--- a/drivers/net/ethernet/xilinx/ll_temac.h
+++ b/drivers/net/ethernet/xilinx/ll_temac.h
@@ -361,7 +361,7 @@ struct temac_local {
 	/* For synchronization of indirect register access.  Must be
 	 * shared mutex between interfaces in same TEMAC block.
 	 */
-	struct mutex *indirect_mutex;
+	spinlock_t *indirect_lock;
 	u32 options;			/* Current options word */
 	int last_link;
 	unsigned int temac_features;
@@ -388,8 +388,9 @@ struct temac_local {
 /* xilinx_temac.c */
 int temac_indirect_busywait(struct temac_local *lp);
 u32 temac_indirect_in32(struct temac_local *lp, int reg);
+u32 temac_indirect_in32_locked(struct temac_local *lp, int reg);
 void temac_indirect_out32(struct temac_local *lp, int reg, u32 value);
-
+void temac_indirect_out32_locked(struct temac_local *lp, int reg, u32 value);
 
 /* xilinx_temac_mdio.c */
 int temac_mdio_setup(struct temac_local *lp, struct platform_device *pdev);
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 05195ff..9d43be3 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -52,6 +52,7 @@
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/dma-mapping.h>
+#include <linux/processor.h>
 #include <linux/platform_data/xilinx-ll-temac.h>
 
 #include "ll_temac.h"
@@ -83,51 +84,118 @@ static void _temac_iow_le(struct temac_local *lp, int offset, u32 value)
 	return iowrite32(value, lp->regs + offset);
 }
 
+static bool hard_acs_rdy(struct temac_local *lp)
+{
+	return temac_ior(lp, XTE_RDY0_OFFSET) & XTE_RDY0_HARD_ACS_RDY_MASK;
+}
+
+static bool hard_acs_rdy_or_timeout(struct temac_local *lp, ktime_t timeout)
+{
+	ktime_t cur = ktime_get();
+
+	return hard_acs_rdy(lp) || ktime_after(cur, timeout);
+}
+
+/* Poll for maximum 20 ms.  This is similar to the 2 jiffies @ 100 Hz
+ * that was used before, and should cover MDIO bus speed down to 3200
+ * Hz.
+ */
+#define HARD_ACS_RDY_POLL_NS (20 * NSEC_PER_MSEC)
+
+/**
+ * temac_indirect_busywait - Wait for current indirect register access
+ * to complete.
+ */
 int temac_indirect_busywait(struct temac_local *lp)
 {
-	unsigned long end = jiffies + 2;
+	ktime_t timeout = ktime_add_ns(ktime_get(), HARD_ACS_RDY_POLL_NS);
 
-	while (!(temac_ior(lp, XTE_RDY0_OFFSET) & XTE_RDY0_HARD_ACS_RDY_MASK)) {
-		if (time_before_eq(end, jiffies)) {
-			WARN_ON(1);
-			return -ETIMEDOUT;
-		}
-		usleep_range(500, 1000);
-	}
-	return 0;
+	spin_until_cond(hard_acs_rdy_or_timeout(lp, timeout));
+	if (WARN_ON(!hard_acs_rdy(lp)))
+		return -ETIMEDOUT;
+	else
+		return 0;
 }
 
 /**
- * temac_indirect_in32
- *
- * lp->indirect_mutex must be held when calling this function
+ * temac_indirect_in32 - Indirect register read access.  This function
+ * must be called without lp->indirect_lock being held.
  */
 u32 temac_indirect_in32(struct temac_local *lp, int reg)
 {
-	u32 val;
+	unsigned long flags;
+	int val;
+
+	spin_lock_irqsave(lp->indirect_lock, flags);
+	val = temac_indirect_in32_locked(lp, reg);
+	spin_unlock_irqrestore(lp->indirect_lock, flags);
+	return val;
+}
 
-	if (temac_indirect_busywait(lp))
+/**
+ * temac_indirect_in32_locked - Indirect register read access.  This
+ * function must be called with lp->indirect_lock being held.  Use
+ * this together with spin_lock_irqsave/spin_lock_irqrestore to avoid
+ * repeated lock/unlock and to ensure uninterrupted access to indirect
+ * registers.
+ */
+u32 temac_indirect_in32_locked(struct temac_local *lp, int reg)
+{
+	/* This initial wait should normally not spin, as we always
+	 * try to wait for indirect access to complete before
+	 * releasing the indirect_lock.
+	 */
+	if (WARN_ON(temac_indirect_busywait(lp)))
 		return -ETIMEDOUT;
+	/* Initiate read from indirect register */
 	temac_iow(lp, XTE_CTL0_OFFSET, reg);
-	if (temac_indirect_busywait(lp))
+	/* Wait for indirect register access to complete.  We really
+	 * should not see timeouts, and could even end up causing
+	 * problem for following indirect access, so let's make a bit
+	 * of WARN noise.
+	 */
+	if (WARN_ON(temac_indirect_busywait(lp)))
 		return -ETIMEDOUT;
-	val = temac_ior(lp, XTE_LSW0_OFFSET);
-
-	return val;
+	/* Value is ready now */
+	return temac_ior(lp, XTE_LSW0_OFFSET);
 }
 
 /**
- * temac_indirect_out32
- *
- * lp->indirect_mutex must be held when calling this function
+ * temac_indirect_out32 - Indirect register write access.  This function
+ * must be called without lp->indirect_lock being held.
  */
 void temac_indirect_out32(struct temac_local *lp, int reg, u32 value)
 {
-	if (temac_indirect_busywait(lp))
+	unsigned long flags;
+
+	spin_lock_irqsave(lp->indirect_lock, flags);
+	temac_indirect_out32_locked(lp, reg, value);
+	spin_unlock_irqrestore(lp->indirect_lock, flags);
+}
+
+/**
+ * temac_indirect_out32_locked - Indirect register write access.  This
+ * function must be called with lp->indirect_lock being held.  Use
+ * this together with spin_lock_irqsave/spin_lock_irqrestore to avoid
+ * repeated lock/unlock and to ensure uninterrupted access to indirect
+ * registers.
+ */
+void temac_indirect_out32_locked(struct temac_local *lp, int reg, u32 value)
+{
+	/* As in temac_indirect_in32_locked(), we should normally not
+	 * spin here.  And if it happens, we actually end up silently
+	 * ignoring the write request.  Ouch.
+	 */
+	if (WARN_ON(temac_indirect_busywait(lp)))
 		return;
+	/* Initiate write to indirect register */
 	temac_iow(lp, XTE_LSW0_OFFSET, value);
 	temac_iow(lp, XTE_CTL0_OFFSET, CNTLREG_WRITE_ENABLE_MASK | reg);
-	temac_indirect_busywait(lp);
+	/* As in temac_indirect_in32_locked(), we should not see timeouts
+	 * here.  And if it happens, we continue before the write has
+	 * completed.  Not good.
+	 */
+	WARN_ON(temac_indirect_busywait(lp));
 }
 
 /**
@@ -343,20 +411,21 @@ static int temac_dma_bd_init(struct net_device *ndev)
 static void temac_do_set_mac_address(struct net_device *ndev)
 {
 	struct temac_local *lp = netdev_priv(ndev);
+	unsigned long flags;
 
 	/* set up unicast MAC address filter set its mac address */
-	mutex_lock(lp->indirect_mutex);
-	temac_indirect_out32(lp, XTE_UAW0_OFFSET,
-			     (ndev->dev_addr[0]) |
-			     (ndev->dev_addr[1] << 8) |
-			     (ndev->dev_addr[2] << 16) |
-			     (ndev->dev_addr[3] << 24));
+	spin_lock_irqsave(lp->indirect_lock, flags);
+	temac_indirect_out32_locked(lp, XTE_UAW0_OFFSET,
+				    (ndev->dev_addr[0]) |
+				    (ndev->dev_addr[1] << 8) |
+				    (ndev->dev_addr[2] << 16) |
+				    (ndev->dev_addr[3] << 24));
 	/* There are reserved bits in EUAW1
 	 * so don't affect them Set MAC bits [47:32] in EUAW1 */
-	temac_indirect_out32(lp, XTE_UAW1_OFFSET,
-			     (ndev->dev_addr[4] & 0x000000ff) |
-			     (ndev->dev_addr[5] << 8));
-	mutex_unlock(lp->indirect_mutex);
+	temac_indirect_out32_locked(lp, XTE_UAW1_OFFSET,
+				    (ndev->dev_addr[4] & 0x000000ff) |
+				    (ndev->dev_addr[5] << 8));
+	spin_unlock_irqrestore(lp->indirect_lock, flags);
 }
 
 static int temac_init_mac_address(struct net_device *ndev, const void *address)
@@ -382,42 +451,56 @@ static int temac_set_mac_address(struct net_device *ndev, void *p)
 static void temac_set_multicast_list(struct net_device *ndev)
 {
 	struct temac_local *lp = netdev_priv(ndev);
-	u32 multi_addr_msw, multi_addr_lsw, val;
+	u32 multi_addr_msw, multi_addr_lsw;
 	int i;
+	unsigned long flags;
+	bool promisc_mode_disabled = false;
 
-	mutex_lock(lp->indirect_mutex);
-	if (ndev->flags & (IFF_ALLMULTI | IFF_PROMISC) ||
-	    netdev_mc_count(ndev) > MULTICAST_CAM_TABLE_NUM) {
+	if (ndev->flags & (IFF_PROMISC | IFF_ALLMULTI) ||
+	    (netdev_mc_count(ndev) > MULTICAST_CAM_TABLE_NUM)) {
 		temac_indirect_out32(lp, XTE_AFM_OFFSET, XTE_AFM_EPPRM_MASK);
 		dev_info(&ndev->dev, "Promiscuous mode enabled.\n");
-	} else if (!netdev_mc_empty(ndev)) {
+		return;
+	}
+
+	spin_lock_irqsave(lp->indirect_lock, flags);
+
+	if (!netdev_mc_empty(ndev)) {
 		struct netdev_hw_addr *ha;
 
 		i = 0;
 		netdev_for_each_mc_addr(ha, ndev) {
-			if (i >= MULTICAST_CAM_TABLE_NUM)
+			if (WARN_ON(i >= MULTICAST_CAM_TABLE_NUM))
 				break;
 			multi_addr_msw = ((ha->addr[3] << 24) |
 					  (ha->addr[2] << 16) |
 					  (ha->addr[1] << 8) |
 					  (ha->addr[0]));
-			temac_indirect_out32(lp, XTE_MAW0_OFFSET,
-					     multi_addr_msw);
+			temac_indirect_out32_locked(lp, XTE_MAW0_OFFSET,
+						    multi_addr_msw);
 			multi_addr_lsw = ((ha->addr[5] << 8) |
 					  (ha->addr[4]) | (i << 16));
-			temac_indirect_out32(lp, XTE_MAW1_OFFSET,
-					     multi_addr_lsw);
+			temac_indirect_out32_locked(lp, XTE_MAW1_OFFSET,
+						    multi_addr_lsw);
 			i++;
 		}
 	} else {
-		val = temac_indirect_in32(lp, XTE_AFM_OFFSET);
-		temac_indirect_out32(lp, XTE_AFM_OFFSET,
-				     val & ~XTE_AFM_EPPRM_MASK);
-		temac_indirect_out32(lp, XTE_MAW0_OFFSET, 0);
-		temac_indirect_out32(lp, XTE_MAW1_OFFSET, 0);
-		dev_info(&ndev->dev, "Promiscuous mode disabled.\n");
+		temac_indirect_out32_locked(lp, XTE_MAW0_OFFSET, 0);
+		temac_indirect_out32_locked(lp, XTE_MAW1_OFFSET, i << 16);
+		}
 	}
-	mutex_unlock(lp->indirect_mutex);
+
+	/* Enable address filter block if currently disabled */
+	if (temac_indirect_in32_locked(lp, XTE_AFM_OFFSET)
+	    & XTE_AFM_EPPRM_MASK) {
+		temac_indirect_out32_locked(lp, XTE_AFM_OFFSET, 0);
+		promisc_mode_disabled = true;
+	}
+
+	spin_unlock_irqrestore(lp->indirect_lock, flags);
+
+	if (promisc_mode_disabled)
+		dev_info(&ndev->dev, "Promiscuous mode disabled.\n");
 }
 
 static struct temac_option {
@@ -508,17 +591,19 @@ static u32 temac_setoptions(struct net_device *ndev, u32 options)
 	struct temac_local *lp = netdev_priv(ndev);
 	struct temac_option *tp = &temac_options[0];
 	int reg;
+	unsigned long flags;
 
-	mutex_lock(lp->indirect_mutex);
+	spin_lock_irqsave(lp->indirect_lock, flags);
 	while (tp->opt) {
-		reg = temac_indirect_in32(lp, tp->reg) & ~tp->m_or;
-		if (options & tp->opt)
+		reg = temac_indirect_in32_locked(lp, tp->reg) & ~tp->m_or;
+		if (options & tp->opt) {
 			reg |= tp->m_or;
-		temac_indirect_out32(lp, tp->reg, reg);
+			temac_indirect_out32_locked(lp, tp->reg, reg);
+		}
 		tp++;
 	}
+	spin_unlock_irqrestore(lp->indirect_lock, flags);
 	lp->options |= options;
-	mutex_unlock(lp->indirect_mutex);
 
 	return 0;
 }
@@ -529,6 +614,7 @@ static void temac_device_reset(struct net_device *ndev)
 	struct temac_local *lp = netdev_priv(ndev);
 	u32 timeout;
 	u32 val;
+	unsigned long flags;
 
 	/* Perform a software reset */
 
@@ -537,7 +623,6 @@ static void temac_device_reset(struct net_device *ndev)
 
 	dev_dbg(&ndev->dev, "%s()\n", __func__);
 
-	mutex_lock(lp->indirect_mutex);
 	/* Reset the receiver and wait for it to finish reset */
 	temac_indirect_out32(lp, XTE_RXC1_OFFSET, XTE_RXC1_RXRST_MASK);
 	timeout = 1000;
@@ -563,8 +648,11 @@ static void temac_device_reset(struct net_device *ndev)
 	}
 
 	/* Disable the receiver */
-	val = temac_indirect_in32(lp, XTE_RXC1_OFFSET);
-	temac_indirect_out32(lp, XTE_RXC1_OFFSET, val & ~XTE_RXC1_RXEN_MASK);
+	spin_lock_irqsave(lp->indirect_lock, flags);
+	val = temac_indirect_in32_locked(lp, XTE_RXC1_OFFSET);
+	temac_indirect_out32_locked(lp, XTE_RXC1_OFFSET,
+				    val & ~XTE_RXC1_RXEN_MASK);
+	spin_unlock_irqrestore(lp->indirect_lock, flags);
 
 	/* Reset Local Link (DMA) */
 	lp->dma_out(lp, DMA_CONTROL_REG, DMA_CONTROL_RST);
@@ -584,12 +672,12 @@ static void temac_device_reset(struct net_device *ndev)
 				"temac_device_reset descriptor allocation failed\n");
 	}
 
-	temac_indirect_out32(lp, XTE_RXC0_OFFSET, 0);
-	temac_indirect_out32(lp, XTE_RXC1_OFFSET, 0);
-	temac_indirect_out32(lp, XTE_TXC_OFFSET, 0);
-	temac_indirect_out32(lp, XTE_FCC_OFFSET, XTE_FCC_RXFLO_MASK);
-
-	mutex_unlock(lp->indirect_mutex);
+	spin_lock_irqsave(lp->indirect_lock, flags);
+	temac_indirect_out32_locked(lp, XTE_RXC0_OFFSET, 0);
+	temac_indirect_out32_locked(lp, XTE_RXC1_OFFSET, 0);
+	temac_indirect_out32_locked(lp, XTE_TXC_OFFSET, 0);
+	temac_indirect_out32_locked(lp, XTE_FCC_OFFSET, XTE_FCC_RXFLO_MASK);
+	spin_unlock_irqrestore(lp->indirect_lock, flags);
 
 	/* Sync default options with HW
 	 * but leave receiver and transmitter disabled.  */
@@ -613,13 +701,14 @@ static void temac_adjust_link(struct net_device *ndev)
 	struct phy_device *phy = ndev->phydev;
 	u32 mii_speed;
 	int link_state;
+	unsigned long flags;
 
 	/* hash together the state values to decide if something has changed */
 	link_state = phy->speed | (phy->duplex << 1) | phy->link;
 
-	mutex_lock(lp->indirect_mutex);
 	if (lp->last_link != link_state) {
-		mii_speed = temac_indirect_in32(lp, XTE_EMCFG_OFFSET);
+		spin_lock_irqsave(lp->indirect_lock, flags);
+		mii_speed = temac_indirect_in32_locked(lp, XTE_EMCFG_OFFSET);
 		mii_speed &= ~XTE_EMCFG_LINKSPD_MASK;
 
 		switch (phy->speed) {
@@ -629,11 +718,12 @@ static void temac_adjust_link(struct net_device *ndev)
 		}
 
 		/* Write new speed setting out to TEMAC */
-		temac_indirect_out32(lp, XTE_EMCFG_OFFSET, mii_speed);
+		temac_indirect_out32_locked(lp, XTE_EMCFG_OFFSET, mii_speed);
+		spin_unlock_irqrestore(lp->indirect_lock, flags);
+
 		lp->last_link = link_state;
 		phy_print_status(phy);
 	}
-	mutex_unlock(lp->indirect_mutex);
 }
 
 #ifdef CONFIG_64BIT
@@ -1095,17 +1185,17 @@ static int temac_probe(struct platform_device *pdev)
 
 	/* Setup mutex for synchronization of indirect register access */
 	if (pdata) {
-		if (!pdata->indirect_mutex) {
+		if (!pdata->indirect_lock) {
 			dev_err(&pdev->dev,
-				"indirect_mutex missing in platform_data\n");
+				"indirect_lock missing in platform_data\n");
 			return -EINVAL;
 		}
-		lp->indirect_mutex = pdata->indirect_mutex;
+		lp->indirect_lock = pdata->indirect_lock;
 	} else {
-		lp->indirect_mutex = devm_kmalloc(&pdev->dev,
-						  sizeof(*lp->indirect_mutex),
-						  GFP_KERNEL);
-		mutex_init(lp->indirect_mutex);
+		lp->indirect_lock = devm_kmalloc(&pdev->dev,
+						 sizeof(*lp->indirect_lock),
+						 GFP_KERNEL);
+		spin_lock_init(lp->indirect_lock);
 	}
 
 	/* map device registers */
diff --git a/drivers/net/ethernet/xilinx/ll_temac_mdio.c b/drivers/net/ethernet/xilinx/ll_temac_mdio.c
index a466732..6fd2dea 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_mdio.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_mdio.c
@@ -25,14 +25,15 @@ static int temac_mdio_read(struct mii_bus *bus, int phy_id, int reg)
 {
 	struct temac_local *lp = bus->priv;
 	u32 rc;
+	unsigned long flags;
 
 	/* Write the PHY address to the MIIM Access Initiator register.
 	 * When the transfer completes, the PHY register value will appear
 	 * in the LSW0 register */
-	mutex_lock(lp->indirect_mutex);
+	spin_lock_irqsave(lp->indirect_lock, flags);
 	temac_iow(lp, XTE_LSW0_OFFSET, (phy_id << 5) | reg);
-	rc = temac_indirect_in32(lp, XTE_MIIMAI_OFFSET);
-	mutex_unlock(lp->indirect_mutex);
+	rc = temac_indirect_in32_locked(lp, XTE_MIIMAI_OFFSET);
+	spin_unlock_irqrestore(lp->indirect_lock, flags);
 
 	dev_dbg(lp->dev, "temac_mdio_read(phy_id=%i, reg=%x) == %x\n",
 		phy_id, reg, rc);
@@ -43,6 +44,7 @@ static int temac_mdio_read(struct mii_bus *bus, int phy_id, int reg)
 static int temac_mdio_write(struct mii_bus *bus, int phy_id, int reg, u16 val)
 {
 	struct temac_local *lp = bus->priv;
+	unsigned long flags;
 
 	dev_dbg(lp->dev, "temac_mdio_write(phy_id=%i, reg=%x, val=%x)\n",
 		phy_id, reg, val);
@@ -50,10 +52,10 @@ static int temac_mdio_write(struct mii_bus *bus, int phy_id, int reg, u16 val)
 	/* First write the desired value into the write data register
 	 * and then write the address into the access initiator register
 	 */
-	mutex_lock(lp->indirect_mutex);
-	temac_indirect_out32(lp, XTE_MGTDR_OFFSET, val);
-	temac_indirect_out32(lp, XTE_MIIMAI_OFFSET, (phy_id << 5) | reg);
-	mutex_unlock(lp->indirect_mutex);
+	spin_lock_irqsave(lp->indirect_lock, flags);
+	temac_indirect_out32_locked(lp, XTE_MGTDR_OFFSET, val);
+	temac_indirect_out32_locked(lp, XTE_MIIMAI_OFFSET, (phy_id << 5) | reg);
+	spin_unlock_irqrestore(lp->indirect_lock, flags);
 
 	return 0;
 }
@@ -87,9 +89,7 @@ int temac_mdio_setup(struct temac_local *lp, struct platform_device *pdev)
 
 	/* Enable the MDIO bus by asserting the enable bit and writing
 	 * in the clock config */
-	mutex_lock(lp->indirect_mutex);
 	temac_indirect_out32(lp, XTE_MC_OFFSET, 1 << 6 | clk_div);
-	mutex_unlock(lp->indirect_mutex);
 
 	bus = devm_mdiobus_alloc(&pdev->dev);
 	if (!bus)
@@ -116,10 +116,8 @@ int temac_mdio_setup(struct temac_local *lp, struct platform_device *pdev)
 	if (rc)
 		return rc;
 
-	mutex_lock(lp->indirect_mutex);
 	dev_dbg(lp->dev, "MDIO bus registered;  MC:%x\n",
 		temac_indirect_in32(lp, XTE_MC_OFFSET));
-	mutex_unlock(lp->indirect_mutex);
 	return 0;
 }
 
diff --git a/include/linux/platform_data/xilinx-ll-temac.h b/include/linux/platform_data/xilinx-ll-temac.h
index 368530f..f4a6813 100644
--- a/include/linux/platform_data/xilinx-ll-temac.h
+++ b/include/linux/platform_data/xilinx-ll-temac.h
@@ -4,6 +4,7 @@
 
 #include <linux/if_ether.h>
 #include <linux/phy.h>
+#include <linux/spinlock.h>
 
 struct ll_temac_platform_data {
 	bool txcsum;		/* Enable/disable TX checksum */
@@ -21,7 +22,7 @@ struct ll_temac_platform_data {
 	 * TEMAC IP block, the same mutex should be passed here, as
 	 * they share the same DCR bus bridge.
 	 */
-	struct mutex *indirect_mutex;
+	spinlock_t *indirect_lock;
 	/* DMA channel control setup */
 	u8 tx_irq_timeout;	/* TX Interrupt Delay Time-out */
 	u8 tx_irq_count;	/* TX Interrupt Coalescing Threshold Count */
-- 
2.4.11

