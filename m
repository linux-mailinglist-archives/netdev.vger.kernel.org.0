Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2DCA47DD0E
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346619AbhLWBPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:15:41 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:27504 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346277AbhLWBOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=svs2sMYtjbzn9WErfCKbNYr+L40h6C9hhF2fxm1TnUc=;
        b=x5CHkg+U/AEUeKShQraCsCFovxrHQLqVVY/1oVhOKnNHL4TqqZwG/RAWfahTKh7Nj2ET
        80zTsD30QLICLXvuzyBP+gAIHfKQoM/88ORaUjOBji9u5S5KxmxDDISb6qrfDlGBYXutJ1
        a1rteALps9iD7gSXjz5pk7IRzDz+o9ejNZBBBgstyPvZmIY6nX3+PROOoPxiMwZTjgLjDL
        AFg7sz5eQhWi06Qekx3CrCJJmclFYsB0c+zJ0ga+WVUX4VWXinod9JHurcLiMh8yLDi/ql
        O7llWzrRjRjziC0CMbS2uiXAV1Utbt8nwS/3ufKEOzFZwB0uvn6iavnqOWyDH0Iw==
Received: by filterdrecv-7bf5c69d5-w55fp with SMTP id filterdrecv-7bf5c69d5-w55fp-1-61C3CD5F-3
        2021-12-23 01:14:07.106510197 +0000 UTC m=+9687232.265531122
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-2-0 (SG)
        with ESMTP
        id exmKzqKWQoOJwtrusg6-sw
        Thu, 23 Dec 2021 01:14:06.969 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 16A1B70156B; Wed, 22 Dec 2021 18:14:06 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 49/50] wilc1000: implement zero-copy transmit support for
 SPI
Date:   Thu, 23 Dec 2021 01:14:07 +0000 (UTC)
Message-Id: <20211223011358.4031459-50-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvIXjviVKntPmow2Ps?=
 =?us-ascii?Q?Uz0li20mrVt8rN+SLyzZEQOCNzWH1oSVsNrpOx1?=
 =?us-ascii?Q?b+zybfU=2FkDGwNSPAcuq2hGsZfhMBjwRhzDZ5KTA?=
 =?us-ascii?Q?KjuNNnHlrwqvVj+2lrFKgV9uq3kXYw6EbmN52uN?=
 =?us-ascii?Q?sjdbqLClTRXtyOftbHzXtaIw9dzW=2FBr6+H7+G0?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This enables zero-copy transmits for the SPI driver.  Maybe something
similar could be implemented for the SDIO driver, but I'm not really
familiar with it.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/spi.c | 162 ++++++++++++++++++
 1 file changed, 162 insertions(+)

diff --git a/drivers/net/wireless/microchip/wilc1000/spi.c b/drivers/net/wireless/microchip/wilc1000/spi.c
index 8951202ed76e2..8d94f111ffc49 100644
--- a/drivers/net/wireless/microchip/wilc1000/spi.c
+++ b/drivers/net/wireless/microchip/wilc1000/spi.c
@@ -44,6 +44,8 @@ MODULE_PARM_DESC(enable_crc16,
 static const struct wilc_hif_func wilc_hif_spi;
 
 static int wilc_spi_reset(struct wilc *wilc);
+static int wilc_spi_write_sk_buffs(struct wilc *wilc, u32 addr,
+				   size_t num_skbs, struct sk_buff_head *skbs);
 
 /********************************************
  *
@@ -107,9 +109,33 @@ static int wilc_spi_reset(struct wilc *wilc);
 #define DATA_PKT_LOG_SZ				DATA_PKT_LOG_SZ_MAX
 #define DATA_PKT_SZ				(1 << DATA_PKT_LOG_SZ)
 
+#define DATA_START_TAG				0xf0
+#define DATA_ORDER_FIRST			0x01
+#define DATA_ORDER_INNER			0x02
+#define DATA_ORDER_LAST				0x03
+
 #define WILC_SPI_COMMAND_STAT_SUCCESS		0
 #define WILC_GET_RESP_HDR_START(h)		(((h) >> 4) & 0xf)
 
+/* wilc_spi_write_sk_buffs() needs the following max. number of SPI
+ * transfers:
+ *
+ *	- 1 transfer to send the CMD_DMA_EXT_WRITE command
+ *	- 1 transfer per sk_buff (at most WILC_VMM_TBL_SIZE of them)
+ *	- for each data packet:
+ *		+ 1 transfer for the data start tag
+ *		+ 1 transfer for the current sk_buff (if it spans
+ *		  the boundary of a data packet)
+ *		+ 1 transfer for the optional CRC16
+ *	- 1 transfer to read the DMA response bytes
+ */
+#define MAX_DATA_PKTS	DIV_ROUND_UP(WILC_TX_BUFF_SIZE, DATA_PKT_SZ)
+#define MAX_SPI_XFERS				\
+	(1					\
+	 + WILC_VMM_TBL_SIZE			\
+	 + 3 * MAX_DATA_PKTS			\
+	 + 1)
+
 struct wilc_spi {
 	bool isinit;		/* true if SPI protocol has been configured */
 	bool probing_crc;	/* true if we're probing chip's CRC config */
@@ -119,6 +145,11 @@ struct wilc_spi {
 		struct gpio_desc *enable;	/* ENABLE GPIO or NULL */
 		struct gpio_desc *reset;	/* RESET GPIO or NULL */
 	} gpios;
+	/* Scratch space used by wilc_spi_write_sk_buffs() for SPI
+	 * transfers and the data packets' CRCs.
+	 */
+	struct spi_transfer xfer[MAX_SPI_XFERS];
+	u8 crc[2 * MAX_DATA_PKTS];
 };
 
 struct wilc_spi_cmd {
@@ -1037,6 +1068,136 @@ static int wilc_spi_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 	return spi_data_rsp(wilc, CMD_DMA_EXT_WRITE);
 }
 
+static void wilc_spi_add_xfer(struct spi_message *msg,
+			      struct spi_transfer **xferp,
+			      size_t len, const void *tx_buf, void *rx_buf)
+{
+	struct spi_transfer *xfer = *xferp;
+
+	xfer->tx_buf = tx_buf;
+	xfer->rx_buf = rx_buf;
+	xfer->len = len;
+	spi_message_add_tail(xfer, msg);
+	*xferp = xfer + 1;
+}
+
+/**
+ * wilc_spi_write_sk_buffs() - Zero-copy write sk_buffs to the chip.
+ * @wilc: Pointer to the wilc structure.
+ * @addr: The WILC address to transfer the data to.
+ * @num_skbs: The length of the skbs array.
+ * @skbs: The queue containing the sk_buffs to transmit.
+ *
+ * Zero-copy transfer one or more sk_buffs to the WILC chip.  At most
+ * WILC_VMM_TBL_SIZE sk_buffs may be transmitted and the total size of
+ * the data in the sk_buffs must not exceed WILC_VMM_TBL_SIZE.
+ *
+ * Context: The caller must hold ownership of the SPI bus through a
+ * call to acquire_bus().
+ *
+ * Return: Zero on success, negative number on error.
+ */
+static int wilc_spi_write_sk_buffs(struct wilc *wilc, u32 addr, size_t num_skbs,
+				   struct sk_buff_head *skbs)
+{
+	static const u8 data_hdr_first = DATA_START_TAG | DATA_ORDER_FIRST;
+	static const u8 data_hdr_inner = DATA_START_TAG | DATA_ORDER_INNER;
+	static const u8 data_hdr_last = DATA_START_TAG | DATA_ORDER_LAST;
+	size_t num_data_packets = 0, total_bytes = 0, num_sent, n, space;
+	struct spi_device *spi = to_spi_device(wilc->dev);
+	struct wilc_spi *spi_priv = wilc->bus_data;
+	u8 rsp[WILC_SPI_DATA_RSP_BYTES], *crc;
+	int i, ret, cmd_len;
+	struct spi_transfer *xfer;
+	struct wilc_spi_cmd cmd;
+	struct spi_message msg;
+	struct sk_buff *skb;
+	const u8 *data_hdr;
+	u16 crc_calc;
+
+	/* setup the SPI message and transfers: */
+
+	spi_message_init(&msg);
+	msg.spi = spi;
+
+	skb = skb_peek(skbs);
+	for (i = 0; i < num_skbs; ++i) {
+		n = skb->len;
+		total_bytes += n;
+		skb = skb_peek_next(skb, skbs);
+	}
+
+	num_data_packets = DIV_ROUND_UP(total_bytes, DATA_PKT_SZ);
+	skb = skb_peek(skbs);
+	num_sent = 0;
+	xfer = spi_priv->xfer;
+	crc = spi_priv->crc;
+
+	cmd_len = wilc_spi_dma_init_cmd(wilc, &cmd, CMD_DMA_EXT_WRITE,
+					addr, total_bytes);
+	if (cmd_len < 0) {
+		dev_err(&spi->dev, "Failed to init DMA command.");
+		return -EINVAL;
+	}
+	wilc_spi_add_xfer(&msg, &xfer, cmd_len, &cmd, NULL);
+
+	for (i = 0; i < num_data_packets; ++i) {
+		space = DATA_PKT_SZ;
+		crc_calc = 0xffff;
+
+		/* write data packet's start header: */
+		if (i == num_data_packets - 1)
+			data_hdr = &data_hdr_last;
+		else if (i == 0)
+			data_hdr = &data_hdr_first;
+		else
+			data_hdr = &data_hdr_inner;
+		wilc_spi_add_xfer(&msg, &xfer, 1, data_hdr, NULL);
+
+		/* write packet data: */
+		do {
+			n = skb->len - num_sent;
+			if (n > space)
+				n = space;
+			wilc_spi_add_xfer(&msg, &xfer, n,
+					  skb->data + num_sent, NULL);
+			if (spi_priv->crc16_enabled)
+				crc_calc = crc_itu_t(crc_calc,
+						     skb->data + num_sent, n);
+			num_sent += n;
+			space -= n;
+
+			if (num_sent >= skb->len) {
+				skb = skb_peek_next(skb, skbs);
+				--num_skbs;
+				num_sent = 0;
+			}
+		} while (space > 0 && num_skbs > 0);
+
+		/* write optional CRC16 checksum: */
+		if (spi_priv->crc16_enabled) {
+			crc[0] = crc_calc >> 8;
+			crc[1] = crc_calc;
+			wilc_spi_add_xfer(&msg, &xfer, 2, crc, NULL);
+			crc += 2;
+		}
+	}
+	/* last transfer reads the response bytes: */
+	wilc_spi_add_xfer(&msg, &xfer, sizeof(rsp), NULL, rsp);
+
+	WARN_ON((u8 *)xfer - (u8 *)spi_priv->xfer > sizeof(spi_priv->xfer));
+	WARN_ON(crc - spi_priv->crc > sizeof(spi_priv->crc));
+
+	ret = spi_sync(spi, &msg);
+	if (ret < 0) {
+		dev_err(&spi->dev, "spi_sync() failed: ret=%d\n", ret);
+		return -EINVAL;
+	}
+
+	/* Check if the chip received the data correctly: */
+	return spi_data_check_rsp(wilc, rsp);
+}
+
 /********************************************
  *
  *      Bus interfaces
@@ -1275,6 +1436,7 @@ static const struct wilc_hif_func wilc_hif_spi = {
 	.hif_read_size = wilc_spi_read_size,
 	.hif_block_tx_ext = wilc_spi_write,
 	.hif_block_rx_ext = wilc_spi_read,
+	.hif_sk_buffs_tx = wilc_spi_write_sk_buffs,
 	.hif_sync_ext = wilc_spi_sync_ext,
 	.hif_reset = wilc_spi_reset,
 };
-- 
2.25.1

