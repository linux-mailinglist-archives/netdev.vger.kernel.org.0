Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72E98918D4
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 20:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbfHRS0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 14:26:21 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51589 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfHRS0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 14:26:18 -0400
Received: by mail-wm1-f67.google.com with SMTP id 207so1108534wma.1;
        Sun, 18 Aug 2019 11:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+Uwt4NYyxa+XFmJuiQCeXKFcw3KuaXvOoP8drfuc9V8=;
        b=vRHD9o7BX/MCyHcD6g8j0G+21tlaSE/nJ1+SFxS63lTW+MtjNWPxPzHyeGsUEfvF6N
         i5dT5srdaM+4K268MmhA/yPAN93D6VCWC0vTd+6ADkPnymiqRFHAptgbcTWBb8nAP0d4
         liVKFDWXvAlqh85B0Job0ii9OHIzq/76OC/K9fkJfxpiZAlQe6JQZhmRZ7JlEs1+aWOZ
         TmZp9tfrANsm+WeAJxcd4CDDHbZpI9x2UVnso4J8thYBGIG1FBddVqacre9MDZhUmJXM
         77LOw23uIOr2IKjF+pb2v9VWGff0GC48J0LeCsZK2plNgK48X6U6XEAhQinxXcKvB9Dl
         c7ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+Uwt4NYyxa+XFmJuiQCeXKFcw3KuaXvOoP8drfuc9V8=;
        b=JVqbwyaWxRN+rGWFcuBvmQd8TfuSPpwPB+dALPic1ravUS6Az9u0uyVClJaZrUpHhI
         OyPCRWMSCIS3tbSTRFkrkNNVFsdMse2K22mUDH8FJpSdQl09h1OEs7l8kA3w4U+ug7e6
         jaK2Qu++wIx0cqjUd1otFAhF2wSt7fkK1/kKxUue9Ozlzpw1Id258TyAddmY/0Q/4lOX
         SEyuA3oleg2seo4ZKYpqq7h6Tp/OBRuNkV+gWTci6OByUszWGBox7vEOqLe4mA9DdClS
         zzvecnBzvy/1qXT8fMPC/lujF91z+Ik871e4qkVZnp67LOl6HfEHIdfrrIey4dQ009hv
         1zOQ==
X-Gm-Message-State: APjAAAXDZAtaqd/3e3p6HoxCKyunuLew0kT5VLtF87yL7Gk8BXpD63LN
        A0WiuG2BoeEFxbp2wJtUaOIeNcIS
X-Google-Smtp-Source: APXvYqwoczW8xGrwL5+Su4urUherYAG4dAHKE5pm+p8l1Lu5wWu+FVOiZ6QUOcGkpLP3SSZoEbAf5g==
X-Received: by 2002:a1c:ed04:: with SMTP id l4mr3829216wmh.81.1566152776167;
        Sun, 18 Aug 2019 11:26:16 -0700 (PDT)
Received: from localhost.localdomain ([188.25.91.80])
        by smtp.gmail.com with ESMTPSA id 39sm40831107wrc.45.2019.08.18.11.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Aug 2019 11:26:15 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     broonie@kernel.org, h.feurstein@gmail.com, mlichvar@redhat.com,
        richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com
Cc:     linux-spi@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH spi for-5.4 3/5] spi: spi-fsl-dspi: Use poll mode in case the platform IRQ is missing
Date:   Sun, 18 Aug 2019 21:25:58 +0300
Message-Id: <20190818182600.3047-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190818182600.3047-1-olteanv@gmail.com>
References: <20190818182600.3047-1-olteanv@gmail.com>
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
 drivers/spi/spi-fsl-dspi.c | 81 ++++++++++++++++++++++++++++----------
 1 file changed, 61 insertions(+), 20 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 238bbe172b79..4daf8c3d07b7 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -647,15 +647,11 @@ static void dspi_eoq_read(struct fsl_dspi *dspi)
 		dspi_push_rx(dspi, fifo_read(dspi));
 }
 
-static irqreturn_t dspi_interrupt(int irq, void *dev_id)
+static int dspi_rxtx(struct fsl_dspi *dspi)
 {
-	struct fsl_dspi *dspi = (struct fsl_dspi *)dev_id;
 	struct spi_message *msg = dspi->cur_msg;
-	u32 spi_sr, spi_tcr;
 	u16 spi_tcnt;
-
-	regmap_read(dspi->regmap, SPI_SR, &spi_sr);
-	regmap_write(dspi->regmap, SPI_SR, spi_sr);
+	u32 spi_tcr;
 
 	/* Get transfer counter (in number of SPI transfers). It was
 	 * reset to 0 when transfer(s) were started.
@@ -670,17 +666,52 @@ static irqreturn_t dspi_interrupt(int irq, void *dev_id)
 	else
 		dspi_tcfq_read(dspi);
 
-	if (!dspi->len) {
-		dspi->waitflags = 1;
-		wake_up_interruptible(&dspi->waitq);
-		return IRQ_HANDLED;
-	}
+	if (!dspi->len)
+		/* Success! */
+		return 0;
 
 	if (dspi->devtype_data->trans_mode == DSPI_EOQ_MODE)
 		dspi_eoq_write(dspi);
 	else
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
+	dspi_rxtx(dspi);
+
+	if (!dspi->len) {
+		dspi->waitflags = 1;
+		wake_up_interruptible(&dspi->waitq);
+	}
+
 	return IRQ_HANDLED;
 }
 
@@ -768,13 +799,18 @@ static int dspi_transfer_one_message(struct spi_controller *ctlr,
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
@@ -1074,10 +1110,13 @@ static int dspi_probe(struct platform_device *pdev)
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
@@ -1087,6 +1126,9 @@ static int dspi_probe(struct platform_device *pdev)
 		goto out_clk_put;
 	}
 
+	init_waitqueue_head(&dspi->waitq);
+
+poll_mode:
 	if (dspi->devtype_data->trans_mode == DSPI_DMA_MODE) {
 		ret = dspi_request_dma(dspi, res->start);
 		if (ret < 0) {
@@ -1098,7 +1140,6 @@ static int dspi_probe(struct platform_device *pdev)
 	ctlr->max_speed_hz =
 		clk_get_rate(dspi->clk) / dspi->devtype_data->max_clock_factor;
 
-	init_waitqueue_head(&dspi->waitq);
 	platform_set_drvdata(pdev, ctlr);
 
 	ret = spi_register_controller(ctlr);
-- 
2.17.1

