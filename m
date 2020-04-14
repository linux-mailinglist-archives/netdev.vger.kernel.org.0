Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 565E21A893D
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503844AbgDNSW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:22:57 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:59042 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503800AbgDNSVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:21:33 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 491v205rGDz1rspt;
        Tue, 14 Apr 2020 20:21:12 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 491v205Ywhz1qqkS;
        Tue, 14 Apr 2020 20:21:12 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id ZdSbZS4-jlrl; Tue, 14 Apr 2020 20:21:11 +0200 (CEST)
X-Auth-Info: LGcrPEt1iyZm/oiZ4vqBA9/qV6tDee6dQ4IgiKQkPMk=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue, 14 Apr 2020 20:21:11 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH V4 10/19] net: ks8851: Factor out bus lock handling
Date:   Tue, 14 Apr 2020 20:20:20 +0200
Message-Id: <20200414182029.183594-11-marex@denx.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200414182029.183594-1-marex@denx.de>
References: <20200414182029.183594-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pull out bus access locking code into separate functions, this is done
in preparation for unifying the driver with the parallel bus one. The
parallel bus driver does not need heavy mutex locking of the bus and
works better with spinlocks, hence prepare these locking functions to
be overridden then.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
---
V3: New patch
V4: s@unsigned status@unsigned int status@ in ks8851_irq()
---
 drivers/net/ethernet/micrel/ks8851.c | 97 +++++++++++++++++++---------
 1 file changed, 68 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index b9820068c839..b05cb9e0c5cd 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -151,6 +151,30 @@ static int msg_enable;
 /* turn register number and byte-enable mask into data for start of packet */
 #define MK_OP(_byteen, _reg) (BYTE_EN(_byteen) | (_reg)  << (8+2) | (_reg) >> 6)
 
+/**
+ * ks8851_lock - register access lock
+ * @ks: The chip state
+ * @flags: Spinlock flags
+ *
+ * Claim chip register access lock
+ */
+static void ks8851_lock(struct ks8851_net *ks, unsigned long *flags)
+{
+	mutex_lock(&ks->lock);
+}
+
+/**
+ * ks8851_unlock - register access unlock
+ * @ks: The chip state
+ * @flags: Spinlock flags
+ *
+ * Release chip register access lock
+ */
+static void ks8851_unlock(struct ks8851_net *ks, unsigned long *flags)
+{
+	mutex_unlock(&ks->lock);
+}
+
 /* SPI register read/write calls.
  *
  * All these calls issue SPI transactions to access the chip's registers. They
@@ -304,10 +328,11 @@ static void ks8851_set_powermode(struct ks8851_net *ks, unsigned pwrmode)
 static int ks8851_write_mac_addr(struct net_device *dev)
 {
 	struct ks8851_net *ks = netdev_priv(dev);
+	unsigned long flags;
 	u16 val;
 	int i;
 
-	mutex_lock(&ks->lock);
+	ks8851_lock(ks, &flags);
 
 	/*
 	 * Wake up chip in case it was powered off when stopped; otherwise,
@@ -323,7 +348,7 @@ static int ks8851_write_mac_addr(struct net_device *dev)
 	if (!netif_running(dev))
 		ks8851_set_powermode(ks, PMECR_PM_SOFTDOWN);
 
-	mutex_unlock(&ks->lock);
+	ks8851_unlock(ks, &flags);
 
 	return 0;
 }
@@ -337,10 +362,11 @@ static int ks8851_write_mac_addr(struct net_device *dev)
 static void ks8851_read_mac_addr(struct net_device *dev)
 {
 	struct ks8851_net *ks = netdev_priv(dev);
+	unsigned long flags;
 	u16 reg;
 	int i;
 
-	mutex_lock(&ks->lock);
+	ks8851_lock(ks, &flags);
 
 	for (i = 0; i < ETH_ALEN; i += 2) {
 		reg = ks8851_rdreg16(ks, KS_MAR(i));
@@ -348,7 +374,7 @@ static void ks8851_read_mac_addr(struct net_device *dev)
 		dev->dev_addr[i + 1] = reg & 0xff;
 	}
 
-	mutex_unlock(&ks->lock);
+	ks8851_unlock(ks, &flags);
 }
 
 /**
@@ -534,10 +560,11 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
 static irqreturn_t ks8851_irq(int irq, void *_ks)
 {
 	struct ks8851_net *ks = _ks;
-	unsigned status;
 	unsigned handled = 0;
+	unsigned long flags;
+	unsigned int status;
 
-	mutex_lock(&ks->lock);
+	ks8851_lock(ks, &flags);
 
 	status = ks8851_rdreg16(ks, KS_ISR);
 
@@ -606,7 +633,7 @@ static irqreturn_t ks8851_irq(int irq, void *_ks)
 		ks8851_wrreg16(ks, KS_RXCR1, rxc->rxcr1);
 	}
 
-	mutex_unlock(&ks->lock);
+	ks8851_unlock(ks, &flags);
 
 	if (status & IRQ_LCI)
 		mii_check_link(&ks->mii);
@@ -700,10 +727,11 @@ static void ks8851_done_tx(struct ks8851_net *ks, struct sk_buff *txb)
 static void ks8851_tx_work(struct work_struct *work)
 {
 	struct ks8851_net *ks = container_of(work, struct ks8851_net, tx_work);
+	unsigned long flags;
 	struct sk_buff *txb;
 	bool last = skb_queue_empty(&ks->txq);
 
-	mutex_lock(&ks->lock);
+	ks8851_lock(ks, &flags);
 
 	while (!last) {
 		txb = skb_dequeue(&ks->txq);
@@ -719,7 +747,7 @@ static void ks8851_tx_work(struct work_struct *work)
 		}
 	}
 
-	mutex_unlock(&ks->lock);
+	ks8851_unlock(ks, &flags);
 }
 
 /**
@@ -732,6 +760,7 @@ static void ks8851_tx_work(struct work_struct *work)
 static int ks8851_net_open(struct net_device *dev)
 {
 	struct ks8851_net *ks = netdev_priv(dev);
+	unsigned long flags;
 	int ret;
 
 	ret = request_threaded_irq(dev->irq, NULL, ks8851_irq,
@@ -744,7 +773,7 @@ static int ks8851_net_open(struct net_device *dev)
 
 	/* lock the card, even if we may not actually be doing anything
 	 * else at the moment */
-	mutex_lock(&ks->lock);
+	ks8851_lock(ks, &flags);
 
 	netif_dbg(ks, ifup, ks->netdev, "opening\n");
 
@@ -804,7 +833,7 @@ static int ks8851_net_open(struct net_device *dev)
 
 	netif_dbg(ks, ifup, ks->netdev, "network device up\n");
 
-	mutex_unlock(&ks->lock);
+	ks8851_unlock(ks, &flags);
 	mii_check_link(&ks->mii);
 	return 0;
 }
@@ -820,22 +849,23 @@ static int ks8851_net_open(struct net_device *dev)
 static int ks8851_net_stop(struct net_device *dev)
 {
 	struct ks8851_net *ks = netdev_priv(dev);
+	unsigned long flags;
 
 	netif_info(ks, ifdown, dev, "shutting down\n");
 
 	netif_stop_queue(dev);
 
-	mutex_lock(&ks->lock);
+	ks8851_lock(ks, &flags);
 	/* turn off the IRQs and ack any outstanding */
 	ks8851_wrreg16(ks, KS_IER, 0x0000);
 	ks8851_wrreg16(ks, KS_ISR, 0xffff);
-	mutex_unlock(&ks->lock);
+	ks8851_unlock(ks, &flags);
 
 	/* stop any outstanding work */
 	flush_work(&ks->tx_work);
 	flush_work(&ks->rxctrl_work);
 
-	mutex_lock(&ks->lock);
+	ks8851_lock(ks, &flags);
 	/* shutdown RX process */
 	ks8851_wrreg16(ks, KS_RXCR1, 0x0000);
 
@@ -844,7 +874,7 @@ static int ks8851_net_stop(struct net_device *dev)
 
 	/* set powermode to soft power down to save power */
 	ks8851_set_powermode(ks, PMECR_PM_SOFTDOWN);
-	mutex_unlock(&ks->lock);
+	ks8851_unlock(ks, &flags);
 
 	/* ensure any queued tx buffers are dumped */
 	while (!skb_queue_empty(&ks->txq)) {
@@ -916,13 +946,14 @@ static netdev_tx_t ks8851_start_xmit(struct sk_buff *skb,
 static void ks8851_rxctrl_work(struct work_struct *work)
 {
 	struct ks8851_net *ks = container_of(work, struct ks8851_net, rxctrl_work);
+	unsigned long flags;
 
-	mutex_lock(&ks->lock);
+	ks8851_lock(ks, &flags);
 
 	/* need to shutdown RXQ before modifying filter parameters */
 	ks8851_wrreg16(ks, KS_RXCR1, 0x00);
 
-	mutex_unlock(&ks->lock);
+	ks8851_unlock(ks, &flags);
 }
 
 static void ks8851_set_rx_mode(struct net_device *dev)
@@ -1104,11 +1135,6 @@ static void ks8851_eeprom_regwrite(struct eeprom_93cx6 *ee)
  */
 static int ks8851_eeprom_claim(struct ks8851_net *ks)
 {
-	if (!(ks->rc_ccr & CCR_EEPROM))
-		return -ENOENT;
-
-	mutex_lock(&ks->lock);
-
 	/* start with clock low, cs high */
 	ks8851_wrreg16(ks, KS_EEPCR, EEPCR_EESA | EEPCR_EECS);
 	return 0;
@@ -1125,7 +1151,6 @@ static void ks8851_eeprom_release(struct ks8851_net *ks)
 	unsigned val = ks8851_rdreg16(ks, KS_EEPCR);
 
 	ks8851_wrreg16(ks, KS_EEPCR, val & ~EEPCR_EESA);
-	mutex_unlock(&ks->lock);
 }
 
 #define KS_EEPROM_MAGIC (0x00008851)
@@ -1135,6 +1160,7 @@ static int ks8851_set_eeprom(struct net_device *dev,
 {
 	struct ks8851_net *ks = netdev_priv(dev);
 	int offset = ee->offset;
+	unsigned long flags;
 	int len = ee->len;
 	u16 tmp;
 
@@ -1145,9 +1171,13 @@ static int ks8851_set_eeprom(struct net_device *dev,
 	if (ee->magic != KS_EEPROM_MAGIC)
 		return -EINVAL;
 
-	if (ks8851_eeprom_claim(ks))
+	if (!(ks->rc_ccr & CCR_EEPROM))
 		return -ENOENT;
 
+	ks8851_lock(ks, &flags);
+
+	ks8851_eeprom_claim(ks);
+
 	eeprom_93cx6_wren(&ks->eeprom, true);
 
 	/* ethtool currently only supports writing bytes, which means
@@ -1167,6 +1197,7 @@ static int ks8851_set_eeprom(struct net_device *dev,
 	eeprom_93cx6_wren(&ks->eeprom, false);
 
 	ks8851_eeprom_release(ks);
+	ks8851_unlock(ks, &flags);
 
 	return 0;
 }
@@ -1176,19 +1207,25 @@ static int ks8851_get_eeprom(struct net_device *dev,
 {
 	struct ks8851_net *ks = netdev_priv(dev);
 	int offset = ee->offset;
+	unsigned long flags;
 	int len = ee->len;
 
 	/* must be 2 byte aligned */
 	if (len & 1 || offset & 1)
 		return -EINVAL;
 
-	if (ks8851_eeprom_claim(ks))
+	if (!(ks->rc_ccr & CCR_EEPROM))
 		return -ENOENT;
 
+	ks8851_lock(ks, &flags);
+
+	ks8851_eeprom_claim(ks);
+
 	ee->magic = KS_EEPROM_MAGIC;
 
 	eeprom_93cx6_multiread(&ks->eeprom, offset/2, (__le16 *)data, len/2);
 	ks8851_eeprom_release(ks);
+	ks8851_unlock(ks, &flags);
 
 	return 0;
 }
@@ -1262,6 +1299,7 @@ static int ks8851_phy_reg(int reg)
 static int ks8851_phy_read(struct net_device *dev, int phy_addr, int reg)
 {
 	struct ks8851_net *ks = netdev_priv(dev);
+	unsigned long flags;
 	int ksreg;
 	int result;
 
@@ -1269,9 +1307,9 @@ static int ks8851_phy_read(struct net_device *dev, int phy_addr, int reg)
 	if (!ksreg)
 		return 0x0;	/* no error return allowed, so use zero */
 
-	mutex_lock(&ks->lock);
+	ks8851_lock(ks, &flags);
 	result = ks8851_rdreg16(ks, ksreg);
-	mutex_unlock(&ks->lock);
+	ks8851_unlock(ks, &flags);
 
 	return result;
 }
@@ -1280,13 +1318,14 @@ static void ks8851_phy_write(struct net_device *dev,
 			     int phy, int reg, int value)
 {
 	struct ks8851_net *ks = netdev_priv(dev);
+	unsigned long flags;
 	int ksreg;
 
 	ksreg = ks8851_phy_reg(reg);
 	if (ksreg) {
-		mutex_lock(&ks->lock);
+		ks8851_lock(ks, &flags);
 		ks8851_wrreg16(ks, ksreg, value);
-		mutex_unlock(&ks->lock);
+		ks8851_unlock(ks, &flags);
 	}
 }
 
-- 
2.25.1

