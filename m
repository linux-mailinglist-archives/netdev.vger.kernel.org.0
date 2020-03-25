Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E23D192BD1
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 16:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgCYPG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 11:06:29 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:38847 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727845AbgCYPG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 11:06:26 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48nWfR6YCPz1r0GY;
        Wed, 25 Mar 2020 16:06:23 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48nWfR6Jrrz1r0cY;
        Wed, 25 Mar 2020 16:06:23 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id ip48KaMESyyZ; Wed, 25 Mar 2020 16:06:22 +0100 (CET)
X-Auth-Info: pkrT6TfhKpG7M9gUkmVWxtaJlHhzRTHOMUs1Ta/lW2c=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Wed, 25 Mar 2020 16:06:22 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH V2 10/14] net: ks8851: Split out SPI specific entries in struct ks8851_net
Date:   Wed, 25 Mar 2020 16:05:39 +0100
Message-Id: <20200325150543.78569-11-marex@denx.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200325150543.78569-1-marex@denx.de>
References: <20200325150543.78569-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new struct ks8851_net_spi, which embeds the original
struct ks8851_net and contains the entries specific only to
the SPI variant of KS8851.

There should be no functional change.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
---
V2: - Drop 'must be first' comment on the embedded struct ks8851_net
    - Remove moved kerneldoc entries for struct ks8851_net
---
 drivers/net/ethernet/micrel/ks8851.c | 79 +++++++++++++++++-----------
 1 file changed, 47 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index e900a975552b..d5fbdddae46c 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -64,7 +64,6 @@ union ks8851_tx_hdr {
 /**
  * struct ks8851_net - KS8851 driver private data
  * @netdev: The network device we're bound to
- * @spidev: The spi device we're bound to.
  * @lock: Lock to ensure that the device is not accessed when busy.
  * @statelock: Lock on this structure for tx list.
  * @mii: The MII state information for the mii calls.
@@ -72,8 +71,6 @@ union ks8851_tx_hdr {
  * @tx_work: Work queue for tx packets
  * @rxctrl_work: Work queue for updating RX mode and multicast lists
  * @txq: Queue of packets for transmission.
- * @spi_msg1: pre-setup SPI transfer with one message, @spi_xfer1.
- * @spi_msg2: pre-setup SPI transfer with two messages, @spi_xfer2.
  * @txh: Space for generating packet TX header in DMA-able data
  * @rxd: Space for receiving SPI data, in DMA-able space.
  * @txd: Space for transmitting SPI data, in DMA-able space.
@@ -102,7 +99,6 @@ union ks8851_tx_hdr {
  */
 struct ks8851_net {
 	struct net_device	*netdev;
-	struct spi_device	*spidev;
 	struct mutex		lock;
 	spinlock_t		statelock;
 
@@ -126,17 +122,30 @@ struct ks8851_net {
 
 	struct sk_buff_head	txq;
 
-	struct spi_message	spi_msg1;
-	struct spi_message	spi_msg2;
-	struct spi_transfer	spi_xfer1;
-	struct spi_transfer	spi_xfer2[2];
-
 	struct eeprom_93cx6	eeprom;
 	struct regulator	*vdd_reg;
 	struct regulator	*vdd_io;
 	int			gpio;
 };
 
+/**
+ * struct ks8851_net_spi - KS8851 SPI driver private data
+ * @ks8851: KS8851 driver common private data
+ * @spidev: The spi device we're bound to.
+ * @spi_msg1: pre-setup SPI transfer with one message, @spi_xfer1.
+ * @spi_msg2: pre-setup SPI transfer with two messages, @spi_xfer2.
+ */
+struct ks8851_net_spi {
+	struct ks8851_net	ks8851;
+	struct spi_device	*spidev;
+	struct spi_message	spi_msg1;
+	struct spi_message	spi_msg2;
+	struct spi_transfer	spi_xfer1;
+	struct spi_transfer	spi_xfer2[2];
+};
+
+#define to_ks8851_spi(ks) container_of((ks), struct ks8851_net_spi, ks8851)
+
 static int msg_enable;
 
 /* SPI frame opcodes */
@@ -168,8 +177,9 @@ static int msg_enable;
  */
 static void ks8851_wrreg16(struct ks8851_net *ks, unsigned reg, unsigned val)
 {
-	struct spi_transfer *xfer = &ks->spi_xfer1;
-	struct spi_message *msg = &ks->spi_msg1;
+	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
+	struct spi_transfer *xfer = &kss->spi_xfer1;
+	struct spi_message *msg = &kss->spi_msg1;
 	__le16 txb[2];
 	int ret;
 
@@ -180,7 +190,7 @@ static void ks8851_wrreg16(struct ks8851_net *ks, unsigned reg, unsigned val)
 	xfer->rx_buf = NULL;
 	xfer->len = 4;
 
-	ret = spi_sync(ks->spidev, msg);
+	ret = spi_sync(kss->spidev, msg);
 	if (ret < 0)
 		netdev_err(ks->netdev, "spi_sync() failed\n");
 }
@@ -198,6 +208,7 @@ static void ks8851_wrreg16(struct ks8851_net *ks, unsigned reg, unsigned val)
 static void ks8851_rdreg(struct ks8851_net *ks, unsigned op,
 			 u8 *rxb, unsigned rxl)
 {
+	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
 	struct spi_transfer *xfer;
 	struct spi_message *msg;
 	__le16 *txb = (__le16 *)ks->txd;
@@ -206,9 +217,9 @@ static void ks8851_rdreg(struct ks8851_net *ks, unsigned op,
 
 	txb[0] = cpu_to_le16(op | KS_SPIOP_RD);
 
-	if (ks->spidev->master->flags & SPI_MASTER_HALF_DUPLEX) {
-		msg = &ks->spi_msg2;
-		xfer = ks->spi_xfer2;
+	if (kss->spidev->master->flags & SPI_MASTER_HALF_DUPLEX) {
+		msg = &kss->spi_msg2;
+		xfer = kss->spi_xfer2;
 
 		xfer->tx_buf = txb;
 		xfer->rx_buf = NULL;
@@ -219,18 +230,18 @@ static void ks8851_rdreg(struct ks8851_net *ks, unsigned op,
 		xfer->rx_buf = trx;
 		xfer->len = rxl;
 	} else {
-		msg = &ks->spi_msg1;
-		xfer = &ks->spi_xfer1;
+		msg = &kss->spi_msg1;
+		xfer = &kss->spi_xfer1;
 
 		xfer->tx_buf = txb;
 		xfer->rx_buf = trx;
 		xfer->len = rxl + 2;
 	}
 
-	ret = spi_sync(ks->spidev, msg);
+	ret = spi_sync(kss->spidev, msg);
 	if (ret < 0)
 		netdev_err(ks->netdev, "read: spi_sync() failed\n");
-	else if (ks->spidev->master->flags & SPI_MASTER_HALF_DUPLEX)
+	else if (kss->spidev->master->flags & SPI_MASTER_HALF_DUPLEX)
 		memcpy(rxb, trx, rxl);
 	else
 		memcpy(rxb, trx + 2, rxl);
@@ -398,8 +409,9 @@ static void ks8851_init_mac(struct ks8851_net *ks, struct device_node *np)
  */
 static void ks8851_rdfifo(struct ks8851_net *ks, u8 *buff, unsigned len)
 {
-	struct spi_transfer *xfer = ks->spi_xfer2;
-	struct spi_message *msg = &ks->spi_msg2;
+	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
+	struct spi_transfer *xfer = kss->spi_xfer2;
+	struct spi_message *msg = &kss->spi_msg2;
 	u8 txb[1];
 	int ret;
 
@@ -418,7 +430,7 @@ static void ks8851_rdfifo(struct ks8851_net *ks, u8 *buff, unsigned len)
 	xfer->tx_buf = NULL;
 	xfer->len = len;
 
-	ret = spi_sync(ks->spidev, msg);
+	ret = spi_sync(kss->spidev, msg);
 	if (ret < 0)
 		netdev_err(ks->netdev, "%s: spi_sync() failed\n", __func__);
 }
@@ -642,8 +654,9 @@ static inline unsigned calc_txlen(unsigned len)
  */
 static void ks8851_wrpkt(struct ks8851_net *ks, struct sk_buff *txp, bool irq)
 {
-	struct spi_transfer *xfer = ks->spi_xfer2;
-	struct spi_message *msg = &ks->spi_msg2;
+	struct ks8851_net_spi *kss = to_ks8851_spi(ks);
+	struct spi_transfer *xfer = kss->spi_xfer2;
+	struct spi_message *msg = &kss->spi_msg2;
 	unsigned fid = 0;
 	int ret;
 
@@ -670,7 +683,7 @@ static void ks8851_wrpkt(struct ks8851_net *ks, struct sk_buff *txp, bool irq)
 	xfer->rx_buf = NULL;
 	xfer->len = ALIGN(txp->len, 4);
 
-	ret = spi_sync(ks->spidev, msg);
+	ret = spi_sync(kss->spidev, msg);
 	if (ret < 0)
 		netdev_err(ks->netdev, "%s: spi_sync() failed\n", __func__);
 }
@@ -1358,22 +1371,24 @@ static SIMPLE_DEV_PM_OPS(ks8851_pm_ops, ks8851_suspend, ks8851_resume);
 static int ks8851_probe(struct spi_device *spi)
 {
 	struct device *dev = &spi->dev;
+	struct ks8851_net_spi *kss;
 	struct net_device *netdev;
 	struct ks8851_net *ks;
 	int ret;
 	unsigned cider;
 	int gpio;
 
-	netdev = devm_alloc_etherdev(dev, sizeof(struct ks8851_net));
+	netdev = devm_alloc_etherdev(dev, sizeof(struct ks8851_net_spi));
 	if (!netdev)
 		return -ENOMEM;
 
 	spi->bits_per_word = 8;
 
 	ks = netdev_priv(netdev);
+	kss = to_ks8851_spi(ks);
 
 	ks->netdev = netdev;
-	ks->spidev = spi;
+	kss->spidev = spi;
 	ks->tx_space = 6144;
 
 	gpio = of_get_named_gpio_flags(dev->of_node, "reset-gpios", 0, NULL);
@@ -1427,12 +1442,12 @@ static int ks8851_probe(struct spi_device *spi)
 
 	/* initialise pre-made spi transfer messages */
 
-	spi_message_init(&ks->spi_msg1);
-	spi_message_add_tail(&ks->spi_xfer1, &ks->spi_msg1);
+	spi_message_init(&kss->spi_msg1);
+	spi_message_add_tail(&kss->spi_xfer1, &kss->spi_msg1);
 
-	spi_message_init(&ks->spi_msg2);
-	spi_message_add_tail(&ks->spi_xfer2[0], &ks->spi_msg2);
-	spi_message_add_tail(&ks->spi_xfer2[1], &ks->spi_msg2);
+	spi_message_init(&kss->spi_msg2);
+	spi_message_add_tail(&kss->spi_xfer2[0], &kss->spi_msg2);
+	spi_message_add_tail(&kss->spi_xfer2[1], &kss->spi_msg2);
 
 	/* setup EEPROM state */
 
-- 
2.25.1

