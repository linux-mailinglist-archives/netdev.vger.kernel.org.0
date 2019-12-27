Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C736512B025
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 02:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfL0BVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 20:21:11 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36026 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbfL0BVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 20:21:11 -0500
Received: by mail-wr1-f66.google.com with SMTP id z3so24916690wru.3
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 17:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=DUpQPK5fjxKECZzGOiN4zd1b/yBFtdI+JhnvQsythio=;
        b=lNUbss1kJEq1XYvuUnfXd8XW1H6TfP1pnUCMByNvnhO9r4EelPT5jGsuZ6RahMi2nR
         7WT29kK6WWKojwW4AdkiOahGaXhqmQPcagfHgEWx3KCwN9aInrR4Ptb+D6cSY3YseH6j
         4RZdOYJs0PKNcaMs30kvmKc/up9iJB3lGZJoRDiVIF8BEy4akFZowunP8TUZofIMr1uA
         lQqoGW8nU4Rs7lG5r4k2HYPhk8ESJvYX+nfwHn2UsLHWr2Mwz+LEJLh48HhuUKYP09B3
         UlXllSZbFWWlIfoAaCCJcQSCqBi3OeBWeqCKnAzCwVOfygx4IhZPwKasnUgmh3o4espw
         C+iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DUpQPK5fjxKECZzGOiN4zd1b/yBFtdI+JhnvQsythio=;
        b=XaCKtetTiPwo281r9Pr52w+dyB1Rl6R1UhhoAY6nA9ou+bdA/OejHGxjWz5Ou77Nem
         jbF5fqJdWR5FpC+Gm912xBd3vI4YCyRn9zNaYgo022K/CwlgBAVdnkr0ehDv5q09Bxjx
         LQY1KF9pzS0pkkdacVeavi0tJ73g/1N8XKiCdRNG1gHl5pQBQdSi3eXsC8CeVjIr/BOd
         5AKe20lprRYqvih8RIJ9QYsXRadND3VXh0vDjQEkCG+x1GQjHSE4pGavx7lUHBjCNMy+
         ixwRMm/p8kOkzJQee9UVk06dIIbSwz7lXBpdyEox3VHWTazC2LKDhsQurP1INl1Ju+68
         L3Vg==
X-Gm-Message-State: APjAAAUa00D6GfAQzSW81CSh4Y36H8QgRh2mgIyFVQAL4dU3Bw2mp+5u
        TwS8rP75HkQH1M76g8bzGIg=
X-Google-Smtp-Source: APXvYqzP7P/19D8/7blEz6qn4bPYy+XfQXPNnTcD+d+UDSCkR+xc6HxgKh2gLXMwTbEQYwqXZbf93g==
X-Received: by 2002:adf:f850:: with SMTP id d16mr48696163wrq.161.1577409668082;
        Thu, 26 Dec 2019 17:21:08 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id n8sm33258680wrx.42.2019.12.26.17.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 17:21:07 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     broonie@kernel.org
Cc:     linux-spi@vget.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH spi] spi: Don't look at TX buffer for PTP system timestamping
Date:   Fri, 27 Dec 2019 03:21:00 +0200
Message-Id: <20191227012100.32316-1-olteanv@gmail.com>
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

