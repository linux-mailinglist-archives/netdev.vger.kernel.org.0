Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D56C78F80F
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 02:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfHPApM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 20:45:12 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:47078 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfHPApJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 20:45:09 -0400
Received: by mail-wr1-f65.google.com with SMTP id z1so3757027wru.13;
        Thu, 15 Aug 2019 17:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tOy0QPNNFIriObiKAZeSQ2MYJKOdia7E8clZjdIgVzE=;
        b=j/61B7EosyWmNvnTJosfLwpV3zKjaOT0FWbRiT+Q5l3h1pBTNZg9mbTixqp02+J7qR
         PZVxEq0UzY7BH3MsuQq10e62vOJK4Dye4aVyTdqxzXzeh/jhsVuIW5TgqeRjy8DdQWdU
         V5YLdf+4ZFyfCkKLz9glkMPCy0/oPDVHqARHEqkzJObHz/PAAf4Sq1pJQH6kZbFJ10c9
         n7tNty93YsNr3sogdJNaw/E27FxwZaUb7fOjNzA7ureA6zQ7rlBW7astfSCEvVttkVRh
         mJDzfP8Y80zqwp06+fJNWbVuJjzKAYwgtWriwmVZkmjBP1v5oFqoCdn4RI17wFJa0C/f
         uImQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tOy0QPNNFIriObiKAZeSQ2MYJKOdia7E8clZjdIgVzE=;
        b=qdjmehueP+H2buxda0Qj11/oGlBngW/he3LI4RjGSFu//O/5af+dQ5htD4saLWlga7
         NRQopUHkozCv0BW8+r40B7URTRd27KhI3SYMiqMhd/+g5r6W3+aAVvO5vEdpoZuuWPZU
         2I+xS5Us9/NPnUKYX+3TPFZOZF0f07RD9QIbcK/g8akjd6uDSz/iBMZ18KVN63Dd/vYr
         RDt45DQtkgoY+G8NA4jYnGaG+ONugjzf8wh8TPeaemMrLG1jBZF615VH4bu1J+0JeN32
         +d78c/Cv8YhgjfuYmwz/5F1EFEobtIhRifOE3fR+u+sLxtffQ0RCXmistgMMDp8qHjZj
         SfPw==
X-Gm-Message-State: APjAAAWjNOkfyzgELrAqU0DPCkOBe/ChDd0gChVB5H6zMAZ9mo9bSyR2
        CftOVXS5gYwyXKYjlsLpaLs=
X-Google-Smtp-Source: APXvYqwyvej/TrtKRSt52vTNNNoGq1j/c1S6mLSO6g56BZXfCy2YADMRDEshfWADp3me8D35Whewxg==
X-Received: by 2002:a05:6000:12c5:: with SMTP id l5mr7630382wrx.122.1565916307477;
        Thu, 15 Aug 2019 17:45:07 -0700 (PDT)
Received: from localhost.localdomain ([188.25.91.80])
        by smtp.gmail.com with ESMTPSA id k124sm6451204wmk.47.2019.08.15.17.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 17:45:07 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     h.feurstein@gmail.com, mlichvar@redhat.com,
        richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        broonie@kernel.org
Cc:     linux-spi@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH net-next 05/11] spi: spi-fsl-dspi: Use poll mode in case the platform IRQ is missing
Date:   Fri, 16 Aug 2019 03:44:43 +0300
Message-Id: <20190816004449.10100-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190816004449.10100-1-olteanv@gmail.com>
References: <20190816004449.10100-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On platforms like LS1021A which use TCFQ mode, an interrupt needs to be
processed after each byte is TXed/RXed. I tried to make the DSPI
implementation on this SoC operate in other, more efficient modes (EOQ,
DMA) but it looks like it simply isn't possible.

Therefore allow the driver to operate in poll mode, to ease a bit of
this absurd amount of IRQ load generated in TCFQ mode. Doing so reduces
both the net time it takes to transmit a SPI message, as well as the
inter-frame jitter that occurs while doing so.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/spi/spi-fsl-dspi.c | 156 +++++++++++++++++++++----------------
 1 file changed, 90 insertions(+), 66 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 99708b36ee4f..41c45ee2bb2d 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -652,6 +652,77 @@ static void dspi_eoq_read(struct fsl_dspi *dspi)
 		dspi_push_rx(dspi, fifo_read(dspi));
 }
 
+static int dspi_rxtx(struct fsl_dspi *dspi)
+{
+	struct spi_message *msg = dspi->cur_msg;
+	u16 spi_tcnt;
+	u32 spi_tcr;
+
+	/* Get transfer counter (in number of SPI transfers). It was
+	 * reset to 0 when transfer(s) were started.
+	 */
+	regmap_read(dspi->regmap, SPI_TCR, &spi_tcr);
+	spi_tcnt = SPI_TCR_GET_TCNT(spi_tcr);
+	/* Update total number of bytes that were transferred */
+	msg->actual_length += spi_tcnt * dspi->bytes_per_word;
+
+	if (dspi->devtype_data->trans_mode == DSPI_EOQ_MODE)
+		dspi_eoq_read(dspi);
+	else
+		dspi_tcfq_read(dspi);
+
+	if (!dspi->len)
+		/* Success! */
+		return 0;
+
+	if (dspi->devtype_data->trans_mode == DSPI_EOQ_MODE)
+		dspi_eoq_write(dspi);
+	else
+		dspi_tcfq_write(dspi);
+
+	return -EAGAIN;
+}
+
+static int dspi_poll(struct fsl_dspi *dspi)
+{
+	int tries = 1000;
+	u32 spi_sr;
+
+	do {
+		regmap_read(dspi->regmap, SPI_SR, &spi_sr);
+		regmap_write(dspi->regmap, SPI_SR, spi_sr);
+
+		if (spi_sr & (SPI_SR_EOQF | SPI_SR_TCFQF))
+			break;
+	} while (--tries);
+
+	if (!tries)
+		return -ETIMEDOUT;
+
+	return dspi_rxtx(dspi);
+}
+
+static irqreturn_t dspi_interrupt(int irq, void *dev_id)
+{
+	struct fsl_dspi *dspi = (struct fsl_dspi *)dev_id;
+	u32 spi_sr;
+
+	regmap_read(dspi->regmap, SPI_SR, &spi_sr);
+	regmap_write(dspi->regmap, SPI_SR, spi_sr);
+
+	if (!(spi_sr & (SPI_SR_EOQF | SPI_SR_TCFQF)))
+		return IRQ_HANDLED;
+
+	dspi_rxtx(dspi);
+
+	if (!dspi->len) {
+		dspi->waitflags = 1;
+		wake_up_interruptible(&dspi->waitq);
+	}
+
+	return IRQ_HANDLED;
+}
+
 static int dspi_transfer_one_message(struct spi_master *master,
 				     struct spi_message *message)
 {
@@ -736,13 +807,18 @@ static int dspi_transfer_one_message(struct spi_master *master,
 			goto out;
 		}
 
-		if (trans_mode != DSPI_DMA_MODE) {
-			if (wait_event_interruptible(dspi->waitq,
-						     dspi->waitflags))
-				dev_err(&dspi->pdev->dev,
-					"wait transfer complete fail!\n");
+		if (!dspi->irq) {
+			do {
+				status = dspi_poll(dspi);
+			} while (status == -EAGAIN);
+		} else if (trans_mode != DSPI_DMA_MODE) {
+			status = wait_event_interruptible(dspi->waitq,
+							  dspi->waitflags);
 			dspi->waitflags = 0;
 		}
+		if (status)
+			dev_err(&dspi->pdev->dev,
+				"Waiting for transfer to complete failed!\n");
 
 		if (transfer->delay_usecs)
 			udelay(transfer->delay_usecs);
@@ -830,62 +906,6 @@ static void dspi_cleanup(struct spi_device *spi)
 	kfree(chip);
 }
 
-static irqreturn_t dspi_interrupt(int irq, void *dev_id)
-{
-	struct fsl_dspi *dspi = (struct fsl_dspi *)dev_id;
-	struct spi_message *msg = dspi->cur_msg;
-	enum dspi_trans_mode trans_mode;
-	u32 spi_sr, spi_tcr;
-	u16 spi_tcnt;
-
-	regmap_read(dspi->regmap, SPI_SR, &spi_sr);
-	regmap_write(dspi->regmap, SPI_SR, spi_sr);
-
-	if (spi_sr & (SPI_SR_EOQF | SPI_SR_TCFQF)) {
-		/* Get transfer counter (in number of SPI transfers). It was
-		 * reset to 0 when transfer(s) were started.
-		 */
-		regmap_read(dspi->regmap, SPI_TCR, &spi_tcr);
-		spi_tcnt = SPI_TCR_GET_TCNT(spi_tcr);
-		/* Update total number of bytes that were transferred */
-		msg->actual_length += spi_tcnt * dspi->bytes_per_word;
-
-		trans_mode = dspi->devtype_data->trans_mode;
-		switch (trans_mode) {
-		case DSPI_EOQ_MODE:
-			dspi_eoq_read(dspi);
-			break;
-		case DSPI_TCFQ_MODE:
-			dspi_tcfq_read(dspi);
-			break;
-		default:
-			dev_err(&dspi->pdev->dev, "unsupported trans_mode %u\n",
-				trans_mode);
-				return IRQ_HANDLED;
-		}
-
-		if (!dspi->len) {
-			dspi->waitflags = 1;
-			wake_up_interruptible(&dspi->waitq);
-		} else {
-			switch (trans_mode) {
-			case DSPI_EOQ_MODE:
-				dspi_eoq_write(dspi);
-				break;
-			case DSPI_TCFQ_MODE:
-				dspi_tcfq_write(dspi);
-				break;
-			default:
-				dev_err(&dspi->pdev->dev,
-					"unsupported trans_mode %u\n",
-					trans_mode);
-			}
-		}
-	}
-
-	return IRQ_HANDLED;
-}
-
 static const struct of_device_id fsl_dspi_dt_ids[] = {
 	{ .compatible = "fsl,vf610-dspi", .data = &vf610_data, },
 	{ .compatible = "fsl,ls1021a-v1.0-dspi", .data = &ls1021a_v1_data, },
@@ -1099,11 +1119,13 @@ static int dspi_probe(struct platform_device *pdev)
 		goto out_master_put;
 
 	dspi_init(dspi);
+
 	dspi->irq = platform_get_irq(pdev, 0);
-	if (dspi->irq < 0) {
-		dev_err(&pdev->dev, "can't get platform irq\n");
-		ret = dspi->irq;
-		goto out_clk_put;
+	if (dspi->irq <= 0) {
+		dev_info(&pdev->dev,
+			 "can't get platform irq, using poll mode\n");
+		dspi->irq = 0;
+		goto poll_mode;
 	}
 
 	ret = devm_request_irq(&pdev->dev, dspi->irq, dspi_interrupt,
@@ -1113,6 +1135,9 @@ static int dspi_probe(struct platform_device *pdev)
 		goto out_clk_put;
 	}
 
+	init_waitqueue_head(&dspi->waitq);
+
+poll_mode:
 	if (dspi->devtype_data->trans_mode == DSPI_DMA_MODE) {
 		ret = dspi_request_dma(dspi, res->start);
 		if (ret < 0) {
@@ -1124,7 +1149,6 @@ static int dspi_probe(struct platform_device *pdev)
 	master->max_speed_hz =
 		clk_get_rate(dspi->clk) / dspi->devtype_data->max_clock_factor;
 
-	init_waitqueue_head(&dspi->waitq);
 	platform_set_drvdata(pdev, master);
 
 	ret = spi_register_master(master);
-- 
2.17.1

