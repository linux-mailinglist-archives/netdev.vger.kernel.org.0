Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3CCC12B02D
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 02:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbfL0BYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 20:24:24 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41741 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726806AbfL0BYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 20:24:24 -0500
Received: by mail-wr1-f65.google.com with SMTP id c9so24890700wrw.8;
        Thu, 26 Dec 2019 17:24:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=bVUkShIVYz0GYkvp4Nh+Gg7c7ljJk23j8BGGZQ1teIk=;
        b=aHZOXDejBhYLGyCj6Ch72AKMAfMMdXoYzUaw+aiVdzIloMwWDTUy1UTzd8RIG8pyO9
         hhjR6eEYcWgXzGa+91jXh1HrDOB6QQ8U7fUaKXhXRyGGBNYBUaIEKae4f/OY+0Bwmilx
         dmqwH4bUHnTYfU21kRhhHxylwNBHtWQaPQnKQCPbiEBTMRYB0OVfQrcQZDgn9XgGJTiC
         wtPZ7ZEJ0Es2E09kNbRWdfa2XXDhMQk3449c+LRmcUpT4UwflDD7GGC4Mz93DEgxk2MM
         zrEximcOeKrlbvaAOlnqVvNT3gCT5S8r+zw6a0fBjFPeCLdoiQ4wa0ZeIzuHC82wGfTk
         DnqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bVUkShIVYz0GYkvp4Nh+Gg7c7ljJk23j8BGGZQ1teIk=;
        b=EvLptjfrZsdhbm1FgSk1sfhfCHEl9/0Ftfy0QRoqC8TzeGpelmAkc4Zz132Pvb7CoF
         ZhmdXO4Ob6DmOvXfsCWwkKMuiwixZt4m1L/yf6F0qTzxkxxhzo3HwSTkFYGIh6VYw5TC
         PvcULkJ48gLJ+8JqTE/rfMYtknS0Biq+unnmTc8+I3k2aN/vmmZP0QVByLG4FPSqNAaV
         lq5IFd5iYasUko/OXzvEYw9/tI2x8eehZoah3j6kR2bqgkMEeuzkeG5jYHGCVpeyj5VT
         uPkYc7W1svRT6rFsCVJK8z/P3ALYAbQW0nuwS0zKOg0aEvxXPzzYJ01cuXQoX/Kg443s
         J7OQ==
X-Gm-Message-State: APjAAAUcWwfBExl4O1lwf5+GzrElZ+pDqkeQmsZNTG/DdXLKrZwnTiND
        RzgiyZqkaiLXpFiMlydLuzk+JMnK
X-Google-Smtp-Source: APXvYqyDVh3BeBUpcKVw/mom+KUNYCCGDqr8smKYZUVF0qIB/v2W8rD+egCiPnzMYH6+pwEyr0/xTg==
X-Received: by 2002:adf:ff8a:: with SMTP id j10mr12780825wrr.312.1577409861657;
        Thu, 26 Dec 2019 17:24:21 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id k7sm9580233wmi.19.2019.12.26.17.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 17:24:21 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     broonie@kernel.org
Cc:     linux-spi@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH spi] spi: Don't look at TX buffer for PTP system timestamping
Date:   Fri, 27 Dec 2019 03:24:17 +0200
Message-Id: <20191227012417.1057-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The API for PTP system timestamping (associating a SPI transaction with
the system time at which it was transferred) is flawed: it assumes that
the xfer->tx_buf pointer will always be present.

This is, of course, not always the case.

So introduce a "progress" variable that denotes how many word have been
transferred.

Fix the Freescale DSPI driver, the only user of the API so far, in the
same patch.

Fixes: b42faeee718c ("spi: Add a PTP system timestamp to the transfer structure")
Fixes: d6b71dfaeeba ("spi: spi-fsl-dspi: Implement the PTP system timestamping for TCFQ mode")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Sorry, resent because I had a typo in the address of the mailing list
the first time.

 drivers/spi/spi-fsl-dspi.c |  9 ++++++---
 drivers/spi/spi.c          | 22 ++++++++--------------
 include/linux/spi/spi.h    |  4 ++--
 3 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 217320376c2d..f9377730e3d8 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -185,6 +185,7 @@ struct fsl_dspi {
 	struct spi_transfer			*cur_transfer;
 	struct spi_message			*cur_msg;
 	struct chip_data			*cur_chip;
+	size_t					progress;
 	size_t					len;
 	const void				*tx;
 	void					*rx;
@@ -641,7 +642,7 @@ static int dspi_rxtx(struct fsl_dspi *dspi)
 	u32 spi_tcr;
 
 	spi_take_timestamp_post(dspi->ctlr, dspi->cur_transfer,
-				dspi->tx - dspi->bytes_per_word, !dspi->irq);
+				dspi->progress, !dspi->irq);
 
 	/* Get transfer counter (in number of SPI transfers). It was
 	 * reset to 0 when transfer(s) were started.
@@ -650,6 +651,7 @@ static int dspi_rxtx(struct fsl_dspi *dspi)
 	spi_tcnt = SPI_TCR_GET_TCNT(spi_tcr);
 	/* Update total number of bytes that were transferred */
 	msg->actual_length += spi_tcnt * dspi->bytes_per_word;
+	dspi->progress += spi_tcnt;
 
 	trans_mode = dspi->devtype_data->trans_mode;
 	if (trans_mode == DSPI_EOQ_MODE)
@@ -662,7 +664,7 @@ static int dspi_rxtx(struct fsl_dspi *dspi)
 		return 0;
 
 	spi_take_timestamp_pre(dspi->ctlr, dspi->cur_transfer,
-			       dspi->tx, !dspi->irq);
+			       dspi->progress, !dspi->irq);
 
 	if (trans_mode == DSPI_EOQ_MODE)
 		dspi_eoq_write(dspi);
@@ -751,6 +753,7 @@ static int dspi_transfer_one_message(struct spi_controller *ctlr,
 		dspi->rx = transfer->rx_buf;
 		dspi->rx_end = dspi->rx + transfer->len;
 		dspi->len = transfer->len;
+		dspi->progress = 0;
 		/* Validated transfer specific frame size (defaults applied) */
 		dspi->bits_per_word = transfer->bits_per_word;
 		dspi->bytes_per_word = DIV_ROUND_UP(dspi->bits_per_word, 8);
@@ -767,7 +770,7 @@ static int dspi_transfer_one_message(struct spi_controller *ctlr,
 				     SPI_CTARE_DTCP(1));
 
 		spi_take_timestamp_pre(dspi->ctlr, dspi->cur_transfer,
-				       dspi->tx, !dspi->irq);
+				       dspi->progress, !dspi->irq);
 
 		trans_mode = dspi->devtype_data->trans_mode;
 		switch (trans_mode) {
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 5e4c4532f7f3..8994545367a2 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1499,8 +1499,7 @@ static void spi_pump_messages(struct kthread_work *work)
  *			    advances its @tx buffer pointer monotonically.
  * @ctlr: Pointer to the spi_controller structure of the driver
  * @xfer: Pointer to the transfer being timestamped
- * @tx: Pointer to the current word within the xfer->tx_buf that the driver is
- *	preparing to transmit right now.
+ * @progress: How many words (not bytes) have been transferred so far
  * @irqs_off: If true, will disable IRQs and preemption for the duration of the
  *	      transfer, for less jitter in time measurement. Only compatible
  *	      with PIO drivers. If true, must follow up with
@@ -1510,21 +1509,19 @@ static void spi_pump_messages(struct kthread_work *work)
  */
 void spi_take_timestamp_pre(struct spi_controller *ctlr,
 			    struct spi_transfer *xfer,
-			    const void *tx, bool irqs_off)
+			    size_t progress, bool irqs_off)
 {
-	u8 bytes_per_word = DIV_ROUND_UP(xfer->bits_per_word, 8);
-
 	if (!xfer->ptp_sts)
 		return;
 
 	if (xfer->timestamped_pre)
 		return;
 
-	if (tx < (xfer->tx_buf + xfer->ptp_sts_word_pre * bytes_per_word))
+	if (progress < xfer->ptp_sts_word_pre)
 		return;
 
 	/* Capture the resolution of the timestamp */
-	xfer->ptp_sts_word_pre = (tx - xfer->tx_buf) / bytes_per_word;
+	xfer->ptp_sts_word_pre = progress;
 
 	xfer->timestamped_pre = true;
 
@@ -1546,23 +1543,20 @@ EXPORT_SYMBOL_GPL(spi_take_timestamp_pre);
  *			     timestamped.
  * @ctlr: Pointer to the spi_controller structure of the driver
  * @xfer: Pointer to the transfer being timestamped
- * @tx: Pointer to the current word within the xfer->tx_buf that the driver has
- *	just transmitted.
+ * @progress: How many words (not bytes) have been transferred so far
  * @irqs_off: If true, will re-enable IRQs and preemption for the local CPU.
  */
 void spi_take_timestamp_post(struct spi_controller *ctlr,
 			     struct spi_transfer *xfer,
-			     const void *tx, bool irqs_off)
+			     size_t progress, bool irqs_off)
 {
-	u8 bytes_per_word = DIV_ROUND_UP(xfer->bits_per_word, 8);
-
 	if (!xfer->ptp_sts)
 		return;
 
 	if (xfer->timestamped_post)
 		return;
 
-	if (tx < (xfer->tx_buf + xfer->ptp_sts_word_post * bytes_per_word))
+	if (progress < xfer->ptp_sts_word_post)
 		return;
 
 	ptp_read_system_postts(xfer->ptp_sts);
@@ -1573,7 +1567,7 @@ void spi_take_timestamp_post(struct spi_controller *ctlr,
 	}
 
 	/* Capture the resolution of the timestamp */
-	xfer->ptp_sts_word_post = (tx - xfer->tx_buf) / bytes_per_word;
+	xfer->ptp_sts_word_post = progress;
 
 	xfer->timestamped_post = true;
 }
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 98fe8663033a..3a67a7e45633 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -689,10 +689,10 @@ extern void spi_finalize_current_transfer(struct spi_controller *ctlr);
 /* Helper calls for driver to timestamp transfer */
 void spi_take_timestamp_pre(struct spi_controller *ctlr,
 			    struct spi_transfer *xfer,
-			    const void *tx, bool irqs_off);
+			    size_t progress, bool irqs_off);
 void spi_take_timestamp_post(struct spi_controller *ctlr,
 			     struct spi_transfer *xfer,
-			     const void *tx, bool irqs_off);
+			     size_t progress, bool irqs_off);
 
 /* the spi driver core manages memory for the spi_controller classdev */
 extern struct spi_controller *__spi_alloc_controller(struct device *host,
-- 
2.17.1

