Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2B029A1E6
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 23:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391064AbfHVVP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 17:15:56 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34978 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390231AbfHVVPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 17:15:55 -0400
Received: by mail-wm1-f65.google.com with SMTP id l2so7123891wmg.0;
        Thu, 22 Aug 2019 14:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZothcN6Bqy4o1FtBOntfj8dAuHCpsgXZRU/8m3bFF7w=;
        b=p3oIMjED49DVZk8QmpOAKxF1KXl/QAxS8z8WomGhSMLXXuj+wYRlCI4jyM02PpXm5X
         g1ngNLoYnFqR1eXXuLVOkHOs1sQY0dzVjNOTIr6EvPjL3X55A5sgeMWypD0/mSsdBwa1
         9zRL37w1NfdFazzYDTrxNNhULI7N2nCqkzuCw/SWGEMfx+JZf2Fyd5qOuJ8cQKDFGOGr
         AMIDOvrfWjZda7CHB9CZxWT+YDSirjxOHvggJnK+jzjVX6IV7YLvxsSOKGYAyQq3/huq
         7HLZEbZcyyNpRO/QIepmf3kdGulwvvn2Wxt0RjxSl6t/vel4n5nMzcGx6yKQP5AnPSha
         hleg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZothcN6Bqy4o1FtBOntfj8dAuHCpsgXZRU/8m3bFF7w=;
        b=YCe3Oh80yG2UKSYTEuI3880vI8D+YWCY3lKbnaFmwJ+mECnnB3zvoEb39q/ERJuBjZ
         RANuJ1V1oHpvez9Z3BaZaVId0/A2hfYTtti3xg/EHIvC8rN2vfnuk+4Gc84LmlpOiygC
         WciJAa68vba313393tFRhtbTZmVPDU4/tiFUgFjCJC17qnAI8kBJgFjQOBIdsmcvcTZ5
         8utB5IbeonwL7UNZC68F/P0MoN3xNxvZihdaWUjoB+vLPu9VpcIOi4iRfSzNYSYzPpRJ
         YeYMX3zeHfL37YF0XH8hBJekAsHHEWy6G7/mPbLroACBDkj1ewHdQsrA2WR76zAYf8wS
         W/bQ==
X-Gm-Message-State: APjAAAW0Gadi61BIEigGoQ0OEZ9uwzXKY5pD9u3QKNpT1XVUIS+QyiPh
        46Z7UMKeo6B+IJEBu56W13ikWrd9
X-Google-Smtp-Source: APXvYqzA7q5JOkuWoXOcMYp3M4MXZ7HA7rb2oRhjveeD9MxCdOqzqn4/N+j2QBx0MaHutMzF4YdGSw==
X-Received: by 2002:a1c:a6cd:: with SMTP id p196mr1020890wme.111.1566508552749;
        Thu, 22 Aug 2019 14:15:52 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id g197sm578488wme.30.2019.08.22.14.15.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 14:15:52 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     broonie@kernel.org
Cc:     linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 4/5] spi: spi-fsl-dspi: Use poll mode in case the platform IRQ is missing
Date:   Fri, 23 Aug 2019 00:15:13 +0300
Message-Id: <20190822211514.19288-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190822211514.19288-1-olteanv@gmail.com>
References: <20190822211514.19288-1-olteanv@gmail.com>
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
 drivers/spi/spi-fsl-dspi.c | 87 ++++++++++++++++++++++++++++----------
 1 file changed, 64 insertions(+), 23 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 6d2c7984ab0e..77db43f1290f 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -647,19 +647,12 @@ static void dspi_eoq_read(struct fsl_dspi *dspi)
 		dspi_push_rx(dspi, fifo_read(dspi));
 }
 
-static irqreturn_t dspi_interrupt(int irq, void *dev_id)
+static int dspi_rxtx(struct fsl_dspi *dspi)
 {
-	struct fsl_dspi *dspi = (struct fsl_dspi *)dev_id;
 	struct spi_message *msg = dspi->cur_msg;
 	enum dspi_trans_mode trans_mode;
-	u32 spi_sr, spi_tcr;
 	u16 spi_tcnt;
-
-	regmap_read(dspi->regmap, SPI_SR, &spi_sr);
-	regmap_write(dspi->regmap, SPI_SR, spi_sr);
-
-	if (!(spi_sr & (SPI_SR_EOQF | SPI_SR_TCFQF)))
-		return IRQ_NONE;
+	u32 spi_tcr;
 
 	/* Get transfer counter (in number of SPI transfers). It was
 	 * reset to 0 when transfer(s) were started.
@@ -675,17 +668,55 @@ static irqreturn_t dspi_interrupt(int irq, void *dev_id)
 	else if (trans_mode == DSPI_TCFQ_MODE)
 		dspi_tcfq_read(dspi);
 
-	if (!dspi->len) {
-		dspi->waitflags = 1;
-		wake_up_interruptible(&dspi->waitq);
-		return IRQ_HANDLED;
-	}
+	if (!dspi->len)
+		/* Success! */
+		return 0;
 
 	if (trans_mode == DSPI_EOQ_MODE)
 		dspi_eoq_write(dspi);
 	else if (trans_mode == DSPI_TCFQ_MODE)
 		dspi_tcfq_write(dspi);
 
+	return -EINPROGRESS;
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
+		return IRQ_NONE;
+
+	dspi_rxtx(dspi);
+
+	if (!dspi->len) {
+		dspi->waitflags = 1;
+		wake_up_interruptible(&dspi->waitq);
+	}
+
 	return IRQ_HANDLED;
 }
 
@@ -773,13 +804,18 @@ static int dspi_transfer_one_message(struct spi_controller *ctlr,
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
+			} while (status == -EINPROGRESS);
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
@@ -1079,10 +1115,13 @@ static int dspi_probe(struct platform_device *pdev)
 		goto out_ctlr_put;
 
 	dspi_init(dspi);
+
 	dspi->irq = platform_get_irq(pdev, 0);
-	if (dspi->irq < 0) {
-		ret = dspi->irq;
-		goto out_clk_put;
+	if (dspi->irq <= 0) {
+		dev_info(&pdev->dev,
+			 "can't get platform irq, using poll mode\n");
+		dspi->irq = 0;
+		goto poll_mode;
 	}
 
 	ret = devm_request_irq(&pdev->dev, dspi->irq, dspi_interrupt,
@@ -1092,6 +1131,9 @@ static int dspi_probe(struct platform_device *pdev)
 		goto out_clk_put;
 	}
 
+	init_waitqueue_head(&dspi->waitq);
+
+poll_mode:
 	if (dspi->devtype_data->trans_mode == DSPI_DMA_MODE) {
 		ret = dspi_request_dma(dspi, res->start);
 		if (ret < 0) {
@@ -1103,7 +1145,6 @@ static int dspi_probe(struct platform_device *pdev)
 	ctlr->max_speed_hz =
 		clk_get_rate(dspi->clk) / dspi->devtype_data->max_clock_factor;
 
-	init_waitqueue_head(&dspi->waitq);
 	platform_set_drvdata(pdev, ctlr);
 
 	ret = spi_register_controller(ctlr);
-- 
2.17.1

