Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 453E219EF85
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 05:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgDFDQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 23:16:54 -0400
Received: from bmailout1.hostsharing.net ([83.223.95.100]:42183 "EHLO
        bmailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgDFDQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 23:16:53 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id 50DFF30000CE7;
        Mon,  6 Apr 2020 05:16:49 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 281ACED565; Mon,  6 Apr 2020 05:16:49 +0200 (CEST)
Date:   Mon, 6 Apr 2020 05:16:49 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V3 00/18] net: ks8851: Unify KS8851 SPI and MLL drivers
Message-ID: <20200406031649.zujfod44bz53ztlo@wunner.de>
References: <20200328003148.498021-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="q3wyrujpa6ql4saw"
Content-Disposition: inline
In-Reply-To: <20200328003148.498021-1-marex@denx.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--q3wyrujpa6ql4saw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 28, 2020 at 01:31:30AM +0100, Marek Vasut wrote:
> The KS8851SNL/SNLI and KS8851-16MLL/MLLI/MLLU are very much the same pieces
> of silicon, except the former has an SPI interface, while the later has a
> parallel bus interface. Thus far, Linux has two separate drivers for each
> and they are diverging considerably.
> 
> This series unifies them into a single driver with small SPI and parallel
> bus specific parts. The approach here is to first separate out the SPI
> specific parts into a separate file, then add parallel bus accessors in
> another separate file and then finally remove the old parallel bus driver.
> The reason for replacing the old parallel bus driver is because the SPI
> bus driver is much higher quality.

Sorry for the delay Marek.

ks8851.ko (SPI variant) no longer compiles with this series.
The attached 0001 patch fixes it.

Both drivers can only be compiled as modules with this series:
If only one of them is built-in, there's a linker error because of
the module_param_named() for msg_enable.
If both are built-in, the symbol collisions you've mentioned occur.

It seems Kbuild can't support building a .o file with a different name
than the corresponding .c file because of the implicit rules used
everywhere.  However, ks8851_common.c can be renamed to be a header
file (a library of sorts) which is included by the two .c files.
I've renamed ks8851_spi.c back to the original ks8851.c and
ks8851_par.c back to ks8851_mll.c. The result is the attached 0002 patch.
Compiles without any errors regardless if one or both drivers are
built-in or modules.

I'll be back at the office this week and will conduct performance
measurements with this version.

Thanks,

Lukas

--q3wyrujpa6ql4saw
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-net-ks8851-Unbreak-the-build-of-CONFIG_KS8851.patch"

From 5d6d0fc40c5e37bf1bea95bf11c598c61c2a9bc2 Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Sun, 5 Apr 2020 13:08:50 +0200
Subject: [PATCH 1/2] net: ks8851: Unbreak the build of CONFIG_KS8851

drivers/net/ethernet/micrel/ks8851_spi.c: In function 'ks8851_start_xmit':
drivers/net/ethernet/micrel/ks8851_spi.c:360:20: error: implicit declaration of function 'calc_txlen' [-Werror=implicit-function-declaration]
  unsigned needed = calc_txlen(skb->len);
                    ^~~~~~~~~~
drivers/net/ethernet/micrel/ks8851_spi.c:377:19: error: 'struct ks8851_net' has no member named 'tx_work'
  schedule_work(&ks->tx_work);
                   ^~

Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 drivers/net/ethernet/micrel/ks8851_common.c | 12 ------------
 drivers/net/ethernet/micrel/ks8851_spi.c    | 15 ++++++++++++++-
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851_common.c b/drivers/net/ethernet/micrel/ks8851_common.c
index b708c01f9f33..9878369efda2 100644
--- a/drivers/net/ethernet/micrel/ks8851_common.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.c
@@ -363,18 +363,6 @@ static irqreturn_t ks8851_irq(int irq, void *_ks)
 	return IRQ_HANDLED;
 }
 
-/**
- * calc_txlen - calculate size of message to send packet
- * @len: Length of data
- *
- * Returns the size of the TXFIFO message needed to send
- * this packet.
- */
-static inline unsigned calc_txlen(unsigned len)
-{
-	return ALIGN(len + 4, 4);
-}
-
 /**
  * ks8851_net_open - open network device
  * @dev: The network device being opened.
diff --git a/drivers/net/ethernet/micrel/ks8851_spi.c b/drivers/net/ethernet/micrel/ks8851_spi.c
index e245ad0b82f4..d08a51c55236 100644
--- a/drivers/net/ethernet/micrel/ks8851_spi.c
+++ b/drivers/net/ethernet/micrel/ks8851_spi.c
@@ -236,6 +236,18 @@ void ks8851_rdfifo(struct ks8851_net *ks, u8 *buff, unsigned int len)
 		netdev_err(ks->netdev, "%s: spi_sync() failed\n", __func__);
 }
 
+/**
+ * calc_txlen - calculate size of message to send packet
+ * @len: Length of data
+ *
+ * Returns the size of the TXFIFO message needed to send
+ * this packet.
+ */
+static inline unsigned calc_txlen(unsigned len)
+{
+	return ALIGN(len + 4, 4);
+}
+
 /**
  * ks8851_wrfifo - write packet to TX FIFO via SPI
  * @ks: The device state.
@@ -357,6 +369,7 @@ void ks8851_flush_tx_work(struct ks8851_net *ks)
 netdev_tx_t ks8851_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ks8851_net *ks = netdev_priv(dev);
+	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
 	unsigned needed = calc_txlen(skb->len);
 	netdev_tx_t ret = NETDEV_TX_OK;
 
@@ -374,7 +387,7 @@ netdev_tx_t ks8851_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	spin_unlock(&ks->statelock);
-	schedule_work(&ks->tx_work);
+	schedule_work(&kss->tx_work);
 
 	return ret;
 }
-- 
2.25.0


--q3wyrujpa6ql4saw
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-net-ks8851-Unbreak-the-build-of-CONFIG_KS8851-y-CONF.patch"

From 9b914fcf37d622f330a5997e0bc660c422bcc2f1 Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Mon, 6 Apr 2020 04:54:14 +0200
Subject: [PATCH 2/2] net: ks8851: Unbreak the build of CONFIG_KS8851=y ||
 CONFIG_KS8851_MLL=y

If one of ks8851 or ks8851_mll is built-in:

arm-linux-gnueabihf-ld: drivers/net/ethernet/micrel/ks8851_common.o:(__param+0x4): undefined reference to `__this_module'

If both are built-in:

arm-linux-gnueabihf-ld: drivers/net/ethernet/micrel/ks8851_par.o: in function `ks8851_lock':
drivers/net/ethernet/micrel/ks8851_par.c:68: multiple definition of `ks8851_lock'; drivers/net/ethernet/micrel/ks8851_spi.o:drivers/net/ethernet/micrel/ks8851_spi.c:80: first defined here
arm-linux-gnueabihf-ld: drivers/net/ethernet/micrel/ks8851_par.o: in function `ks8851_unlock':
drivers/net/ethernet/micrel/ks8851_par.c:82: multiple definition of `ks8851_unlock'; drivers/net/ethernet/micrel/ks8851_spi.o:drivers/net/ethernet/micrel/ks8851_spi.c:94: first defined here
arm-linux-gnueabihf-ld: drivers/net/ethernet/micrel/ks8851_par.o: in function `ks8851_wrreg16':
drivers/net/ethernet/micrel/ks8851_par.c:141: multiple definition of `ks8851_wrreg16'; drivers/net/ethernet/micrel/ks8851_spi.o:drivers/net/ethernet/micrel/ks8851_spi.c:116: first defined here
arm-linux-gnueabihf-ld: drivers/net/ethernet/micrel/ks8851_par.o: in function `ks8851_rdreg16':
drivers/net/ethernet/micrel/ks8851_par.c:157: multiple definition of `ks8851_rdreg16'; drivers/net/ethernet/micrel/ks8851_spi.o:drivers/net/ethernet/micrel/ks8851_spi.c:195: first defined here
arm-linux-gnueabihf-ld: drivers/net/ethernet/micrel/ks8851_par.o: in function `ks8851_rdfifo':
drivers/net/ethernet/micrel/ks8851_par.c:175: multiple definition of `ks8851_rdfifo'; drivers/net/ethernet/micrel/ks8851_spi.o:drivers/net/ethernet/micrel/ks8851_spi.c:212: first defined here
arm-linux-gnueabihf-ld: drivers/net/ethernet/micrel/ks8851_par.o: in function `ks8851_wrfifo':
drivers/net/ethernet/micrel/ks8851_par.c:196: multiple definition of `ks8851_wrfifo'; drivers/net/ethernet/micrel/ks8851_spi.o:drivers/net/ethernet/micrel/ks8851_spi.c:263: first defined here
arm-linux-gnueabihf-ld: drivers/net/ethernet/micrel/ks8851_par.o: in function `ks8851_rx_skb':
drivers/net/ethernet/micrel/ks8851_par.c:221: multiple definition of `ks8851_rx_skb'; drivers/net/ethernet/micrel/ks8851_spi.o:drivers/net/ethernet/micrel/ks8851_spi.c:303: first defined here
arm-linux-gnueabihf-ld: drivers/net/ethernet/micrel/ks8851_par.o: in function `ks8851_flush_tx_work':
drivers/net/ethernet/micrel/ks8851_par.c:230: multiple definition of `ks8851_flush_tx_work'; drivers/net/ethernet/micrel/ks8851_spi.o:drivers/net/ethernet/micrel/ks8851_spi.c:350: first defined here
arm-linux-gnueabihf-ld: drivers/net/ethernet/micrel/ks8851_par.o: in function `ks8851_start_xmit':
drivers/net/ethernet/micrel/ks8851_par.c:247: multiple definition of `ks8851_start_xmit'; drivers/net/ethernet/micrel/ks8851_spi.o:drivers/net/ethernet/micrel/ks8851_spi.c:370: first defined here

Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 drivers/net/ethernet/micrel/Makefile          |  2 -
 .../micrel/{ks8851_spi.c => ks8851.c}         | 42 ++++++-------------
 drivers/net/ethernet/micrel/ks8851.h          | 27 ++++--------
 .../{ks8851_common.c => ks8851_common.h}      | 19 ++-------
 .../micrel/{ks8851_par.c => ks8851_mll.c}     | 41 ++++++------------
 5 files changed, 38 insertions(+), 93 deletions(-)
 rename drivers/net/ethernet/micrel/{ks8851_spi.c => ks8851.c} (91%)
 rename drivers/net/ethernet/micrel/{ks8851_common.c => ks8851_common.h} (98%)
 rename drivers/net/ethernet/micrel/{ks8851_par.c => ks8851_mll.c} (89%)

diff --git a/drivers/net/ethernet/micrel/Makefile b/drivers/net/ethernet/micrel/Makefile
index 5cc00d22c708..6d8ac5527aef 100644
--- a/drivers/net/ethernet/micrel/Makefile
+++ b/drivers/net/ethernet/micrel/Makefile
@@ -5,7 +5,5 @@
 
 obj-$(CONFIG_KS8842) += ks8842.o
 obj-$(CONFIG_KS8851) += ks8851.o
-ks8851-objs = ks8851_common.o ks8851_spi.o
 obj-$(CONFIG_KS8851_MLL) += ks8851_mll.o
-ks8851_mll-objs = ks8851_common.o ks8851_par.o
 obj-$(CONFIG_KSZ884X_PCI) += ksz884x.o
diff --git a/drivers/net/ethernet/micrel/ks8851_spi.c b/drivers/net/ethernet/micrel/ks8851.c
similarity index 91%
rename from drivers/net/ethernet/micrel/ks8851_spi.c
rename to drivers/net/ethernet/micrel/ks8851.c
index d08a51c55236..21c7e7d9872b 100644
--- a/drivers/net/ethernet/micrel/ks8851_spi.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -6,28 +6,9 @@
  *	Ben Dooks <ben@simtec.co.uk>
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#define DEBUG
-
-#include <linux/interrupt.h>
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/netdevice.h>
-#include <linux/etherdevice.h>
-#include <linux/ethtool.h>
-#include <linux/cache.h>
-#include <linux/crc32.h>
-#include <linux/mii.h>
-#include <linux/eeprom_93cx6.h>
-#include <linux/regulator/consumer.h>
+#include "ks8851.h"
 
 #include <linux/spi/spi.h>
-#include <linux/gpio.h>
-#include <linux/of_gpio.h>
-#include <linux/of_net.h>
-
-#include "ks8851.h"
 
 /**
  * struct ks8851_net_spi - KS8851 SPI driver private data
@@ -76,7 +57,7 @@ struct ks8851_net_spi {
  *
  * Claim chip register access lock
  */
-void ks8851_lock(struct ks8851_net *ks, unsigned long *flags)
+static void ks8851_lock(struct ks8851_net *ks, unsigned long *flags)
 {
 	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
 
@@ -90,7 +71,7 @@ void ks8851_lock(struct ks8851_net *ks, unsigned long *flags)
  *
  * Release chip register access lock
  */
-void ks8851_unlock(struct ks8851_net *ks, unsigned long *flags)
+static void ks8851_unlock(struct ks8851_net *ks, unsigned long *flags)
 {
 	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
 
@@ -112,7 +93,7 @@ void ks8851_unlock(struct ks8851_net *ks, unsigned long *flags)
  *
  * Issue a write to put the value @val into the register specified in @reg.
  */
-void ks8851_wrreg16(struct ks8851_net *ks, unsigned int reg, unsigned int val)
+static void ks8851_wrreg16(struct ks8851_net *ks, unsigned int reg, unsigned int val)
 {
 	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
 	struct spi_transfer *xfer = &kss->spi_xfer1;
@@ -191,7 +172,7 @@ static void ks8851_rdreg(struct ks8851_net *ks, unsigned int op,
  *
  * Read a 16bit register from the chip, returning the result
  */
-unsigned int ks8851_rdreg16(struct ks8851_net *ks, unsigned int reg)
+static unsigned int ks8851_rdreg16(struct ks8851_net *ks, unsigned int reg)
 {
 	__le16 rx = 0;
 
@@ -208,7 +189,7 @@ unsigned int ks8851_rdreg16(struct ks8851_net *ks, unsigned int reg)
  * Issue an RXQ FIFO read command and read the @len amount of data from
  * the FIFO into the buffer specified by @buff.
  */
-void ks8851_rdfifo(struct ks8851_net *ks, u8 *buff, unsigned int len)
+static void ks8851_rdfifo(struct ks8851_net *ks, u8 *buff, unsigned int len)
 {
 	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
 	struct spi_transfer *xfer = kss->spi_xfer2;
@@ -259,7 +240,7 @@ static inline unsigned calc_txlen(unsigned len)
  * needs, such as IRQ on completion. Send the header and the packet data to
  * the device.
  */
-void ks8851_wrfifo(struct ks8851_net *ks, struct sk_buff *txp, bool irq)
+static void ks8851_wrfifo(struct ks8851_net *ks, struct sk_buff *txp, bool irq)
 {
 	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
 	struct spi_transfer *xfer = kss->spi_xfer2;
@@ -299,7 +280,7 @@ void ks8851_wrfifo(struct ks8851_net *ks, struct sk_buff *txp, bool irq)
  * ks8851_rx_skb - receive skbuff
  * @skb: The skbuff
  */
-void ks8851_rx_skb(struct sk_buff *skb)
+static void ks8851_rx_skb(struct sk_buff *skb)
 {
 	netif_rx_ni(skb);
 }
@@ -346,7 +327,7 @@ static void ks8851_tx_work(struct work_struct *work)
  * ks8851_flush_tx_work - flush outstanding TX work
  * @ks: The device state
  */
-void ks8851_flush_tx_work(struct ks8851_net *ks)
+static void ks8851_flush_tx_work(struct ks8851_net *ks)
 {
 	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
 
@@ -366,7 +347,7 @@ void ks8851_flush_tx_work(struct ks8851_net *ks)
  * and secondly so we can round up more than one packet to transmit which
  * means we can try and avoid generating too many transmit done interrupts.
  */
-netdev_tx_t ks8851_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t ks8851_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ks8851_net *ks = netdev_priv(dev);
 	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
@@ -392,6 +373,8 @@ netdev_tx_t ks8851_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	return ret;
 }
 
+#include "ks8851_common.h"
+
 static int ks8851_probe_spi(struct spi_device *spi)
 {
 	struct device *dev = &spi->dev;
@@ -459,3 +442,4 @@ module_spi_driver(ks8851_driver);
 MODULE_DESCRIPTION("KS8851 Network driver");
 MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:ks8851");
diff --git a/drivers/net/ethernet/micrel/ks8851.h b/drivers/net/ethernet/micrel/ks8851.h
index 7932996c6ec4..a8fd2ece2345 100644
--- a/drivers/net/ethernet/micrel/ks8851.h
+++ b/drivers/net/ethernet/micrel/ks8851.h
@@ -304,6 +304,15 @@
 #define TXFR_TXFID_MASK				(0x3f << 0)
 #define TXFR_TXFID_SHIFT			(0)
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#define DEBUG
+
+#include <linux/kernel.h>
+#include <linux/eeprom_93cx6.h>
+#include <linux/mii.h>
+#include <linux/netdevice.h>
+
 /**
  * struct ks8851_rxctrl - KS8851 driver rx control
  * @mchash: Multicast hash-table data.
@@ -403,24 +412,6 @@ struct ks8851_net {
 					  struct sk_buff *txp, bool irq);
 };
 
-int ks8851_probe_common(struct net_device *netdev, struct device *dev);
-int ks8851_remove_common(struct device *dev);
-int ks8851_suspend(struct device *dev);
-int ks8851_resume(struct device *dev);
-
-void ks8851_lock(struct ks8851_net *ks, unsigned long *flags);
-void ks8851_unlock(struct ks8851_net *ks, unsigned long *flags);
-
-unsigned int ks8851_rdreg16(struct ks8851_net *ks, unsigned int reg);
-void ks8851_wrreg16(struct ks8851_net *ks, unsigned int reg, unsigned int val);
-void ks8851_rdfifo(struct ks8851_net *ks, u8 *buff, unsigned int len);
-void ks8851_wrfifo(struct ks8851_net *ks, struct sk_buff *txp, bool irq);
-
-void ks8851_rx_skb(struct sk_buff *skb);
-void ks8851_flush_tx_work(struct ks8851_net *ks);
-
-netdev_tx_t ks8851_start_xmit(struct sk_buff *skb, struct net_device *dev);
-
 static SIMPLE_DEV_PM_OPS(ks8851_pm_ops, ks8851_suspend, ks8851_resume);
 
 /**
diff --git a/drivers/net/ethernet/micrel/ks8851_common.c b/drivers/net/ethernet/micrel/ks8851_common.h
similarity index 98%
rename from drivers/net/ethernet/micrel/ks8851_common.c
rename to drivers/net/ethernet/micrel/ks8851_common.h
index 9878369efda2..5f96230e08cd 100644
--- a/drivers/net/ethernet/micrel/ks8851_common.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.h
@@ -6,28 +6,18 @@
  *	Ben Dooks <ben@simtec.co.uk>
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#define DEBUG
-
 #include <linux/interrupt.h>
 #include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/cache.h>
 #include <linux/crc32.h>
-#include <linux/mii.h>
-#include <linux/eeprom_93cx6.h>
 #include <linux/regulator/consumer.h>
 
 #include <linux/gpio.h>
 #include <linux/of_gpio.h>
 #include <linux/of_net.h>
 
-#include "ks8851.h"
-
 static int msg_enable;
 
 /**
@@ -930,7 +920,7 @@ static int ks8851_read_selftest(struct ks8851_net *ks)
 
 #ifdef CONFIG_PM_SLEEP
 
-int ks8851_suspend(struct device *dev)
+static int ks8851_suspend(struct device *dev)
 {
 	struct ks8851_net *ks = dev_get_drvdata(dev);
 	struct net_device *netdev = ks->netdev;
@@ -943,7 +933,7 @@ int ks8851_suspend(struct device *dev)
 	return 0;
 }
 
-int ks8851_resume(struct device *dev)
+static int ks8851_resume(struct device *dev)
 {
 	struct ks8851_net *ks = dev_get_drvdata(dev);
 	struct net_device *netdev = ks->netdev;
@@ -957,7 +947,7 @@ int ks8851_resume(struct device *dev)
 }
 #endif
 
-int ks8851_probe_common(struct net_device *netdev, struct device *dev)
+static int ks8851_probe_common(struct net_device *netdev, struct device *dev)
 {
 	struct ks8851_net *ks = netdev_priv(netdev);
 	unsigned cider;
@@ -1086,7 +1076,7 @@ int ks8851_probe_common(struct net_device *netdev, struct device *dev)
 	return ret;
 }
 
-int ks8851_remove_common(struct device *dev)
+static int ks8851_remove_common(struct device *dev)
 {
 	struct ks8851_net *priv = dev_get_drvdata(dev);
 
@@ -1104,4 +1094,3 @@ int ks8851_remove_common(struct device *dev)
 
 module_param_named(message, msg_enable, int, 0);
 MODULE_PARM_DESC(message, "Message verbosity level (0=none, 31=all)");
-MODULE_ALIAS("spi:ks8851");
diff --git a/drivers/net/ethernet/micrel/ks8851_par.c b/drivers/net/ethernet/micrel/ks8851_mll.c
similarity index 89%
rename from drivers/net/ethernet/micrel/ks8851_par.c
rename to drivers/net/ethernet/micrel/ks8851_mll.c
index 3f70f07bcb2f..82e76b80436e 100644
--- a/drivers/net/ethernet/micrel/ks8851_par.c
+++ b/drivers/net/ethernet/micrel/ks8851_mll.c
@@ -6,28 +6,9 @@
  *	Ben Dooks <ben@simtec.co.uk>
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#define DEBUG
-
-#include <linux/interrupt.h>
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/netdevice.h>
-#include <linux/etherdevice.h>
-#include <linux/ethtool.h>
-#include <linux/cache.h>
-#include <linux/crc32.h>
-#include <linux/mii.h>
-#include <linux/eeprom_93cx6.h>
-#include <linux/regulator/consumer.h>
+#include "ks8851.h"
 
 #include <linux/platform_device.h>
-#include <linux/gpio.h>
-#include <linux/of_gpio.h>
-#include <linux/of_net.h>
-
-#include "ks8851.h"
 
 #define BE3             0x8000      /* Byte Enable 3 */
 #define BE2             0x4000      /* Byte Enable 2 */
@@ -64,7 +45,7 @@ struct ks8851_net_par {
  *
  * Claim chip register access lock
  */
-void ks8851_lock(struct ks8851_net *ks, unsigned long *flags)
+static void ks8851_lock(struct ks8851_net *ks, unsigned long *flags)
 {
 	struct ks8851_net_par *ksp = to_ks8851_par(ks);
 
@@ -78,7 +59,7 @@ void ks8851_lock(struct ks8851_net *ks, unsigned long *flags)
  *
  * Release chip register access lock
  */
-void ks8851_unlock(struct ks8851_net *ks, unsigned long *flags)
+static void ks8851_unlock(struct ks8851_net *ks, unsigned long *flags)
 {
 	struct ks8851_net_par *ksp = to_ks8851_par(ks);
 
@@ -137,7 +118,7 @@ static int ks_check_endian(struct ks8851_net *ks)
  *
  * Issue a write to put the value @val into the register specified in @reg.
  */
-void ks8851_wrreg16(struct ks8851_net *ks, unsigned int reg, unsigned int val)
+static void ks8851_wrreg16(struct ks8851_net *ks, unsigned int reg, unsigned int val)
 {
 	struct ks8851_net_par *ksp = to_ks8851_par(ks);
 
@@ -153,7 +134,7 @@ void ks8851_wrreg16(struct ks8851_net *ks, unsigned int reg, unsigned int val)
  *
  * Read a 16bit register from the chip, returning the result
  */
-unsigned int ks8851_rdreg16(struct ks8851_net *ks, unsigned int reg)
+static unsigned int ks8851_rdreg16(struct ks8851_net *ks, unsigned int reg)
 {
 	struct ks8851_net_par *ksp = to_ks8851_par(ks);
 
@@ -171,7 +152,7 @@ unsigned int ks8851_rdreg16(struct ks8851_net *ks, unsigned int reg)
  * Issue an RXQ FIFO read command and read the @len amount of data from
  * the FIFO into the buffer specified by @buff.
  */
-void ks8851_rdfifo(struct ks8851_net *ks, u8 *buff, unsigned int len)
+static void ks8851_rdfifo(struct ks8851_net *ks, u8 *buff, unsigned int len)
 {
 	struct ks8851_net_par *ksp = to_ks8851_par(ks);
 
@@ -192,7 +173,7 @@ void ks8851_rdfifo(struct ks8851_net *ks, u8 *buff, unsigned int len)
  * needs, such as IRQ on completion. Send the header and the packet data to
  * the device.
  */
-void ks8851_wrfifo(struct ks8851_net *ks, struct sk_buff *txp, bool irq)
+static void ks8851_wrfifo(struct ks8851_net *ks, struct sk_buff *txp, bool irq)
 {
 	struct ks8851_net_par *ksp = to_ks8851_par(ks);
 	unsigned int len = ALIGN(txp->len, 4);
@@ -217,7 +198,7 @@ void ks8851_wrfifo(struct ks8851_net *ks, struct sk_buff *txp, bool irq)
  * ks8851_rx_skb - receive skbuff
  * @skb: The skbuff
  */
-void ks8851_rx_skb(struct sk_buff *skb)
+static void ks8851_rx_skb(struct sk_buff *skb)
 {
 	netif_rx(skb);
 }
@@ -226,7 +207,7 @@ void ks8851_rx_skb(struct sk_buff *skb)
  * ks8851_flush_tx_work - flush outstanding TX work
  * @ks: The device state
  */
-void ks8851_flush_tx_work(struct ks8851_net *ks)
+static void ks8851_flush_tx_work(struct ks8851_net *ks)
 {
 }
 
@@ -243,7 +224,7 @@ void ks8851_flush_tx_work(struct ks8851_net *ks)
  * and secondly so we can round up more than one packet to transmit which
  * means we can try and avoid generating too many transmit done interrupts.
  */
-netdev_tx_t ks8851_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t ks8851_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ks8851_net *ks = netdev_priv(dev);
 	netdev_tx_t ret = NETDEV_TX_OK;
@@ -271,6 +252,8 @@ netdev_tx_t ks8851_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	return ret;
 }
 
+#include "ks8851_common.h"
+
 static int ks8851_probe_par(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-- 
2.25.0


--q3wyrujpa6ql4saw--
