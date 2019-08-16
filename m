Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B67D58F813
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 02:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfHPApP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 20:45:15 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45415 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbfHPApL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 20:45:11 -0400
Received: by mail-wr1-f65.google.com with SMTP id q12so3763768wrj.12;
        Thu, 15 Aug 2019 17:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YG3u50v8Lo9d/O+VgGzripjobJbM5k58P5pmJCOQlFU=;
        b=DITairBk8fP+IogVPaaeug+xV84Z4OhqzAG9Q4XbvBRWiZ9ORNFemWJkB1+qFjyBQG
         GG9Is9Da627F3ELROv6HfUZrfXDeq0BUls+R2tfeGKvCgxbpaBLtkSxVCuNU3PDCB1S1
         znoKXDtpKzOO9vA0mrh4HbEh2NFpPNpOa1iMc9sRu8FVcY3/y41gRQWT94jSTFrZ4yTB
         oxv0ROhXWfh3s+gNAgjWkoBfwflQk6vwmcPfg12v3xUY4ulwvQ75u28r8N1DYR+7VExl
         JyPXycs7AOYCgntzgwOwJ8l/Gid8t0lnnLNWvADZrVK9goVoD8cX+wDpphZYp9aX2RxZ
         AOcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YG3u50v8Lo9d/O+VgGzripjobJbM5k58P5pmJCOQlFU=;
        b=NrU3/9F1zpgIr0kftcVgPWRFQ5LD6WL+RibEbm+dKjts/jIzoNub2wDxwn95zxIros
         HKo7USmxl3ee9/XRLte8y8NiSdVQbpoBMfgn5HF2d2zdz4oxYsinKQLfBKtRRmx/Aw+5
         WlvD3LE00Erwxx65/nMHM1+A/MKXv7zQXODJhsdk2AJaxnifc1vk2nx7VNi51uNgwKEY
         Qa9isbRPVU536Sn9dP68G3mrdPgy9lC2lSCFtMzu7o3mFmM62FgySaVgl/mmz5oPKysc
         +9SObbn3RtE1h3ui8DkxhIzGDtGgN/I7wygXDkeMWUTXsdaDCf/+MO0Lr3FAibZ1QAEy
         AhZQ==
X-Gm-Message-State: APjAAAXcUzEAi9FYb1baGdz8Npp99ptCI/mWx9uJolCZ7qUZw2URsoUn
        yBzObInMr3AcUZLE61Kic/Y=
X-Google-Smtp-Source: APXvYqxU4Lu85R6U0EhjuhVVyv0w+f4i8RjKs6NI7rt61JH5ED0bqcd/457/VrP7N6cfDETu+Rp0vw==
X-Received: by 2002:a5d:4b0e:: with SMTP id v14mr7913449wrq.24.1565916309446;
        Thu, 15 Aug 2019 17:45:09 -0700 (PDT)
Received: from localhost.localdomain ([188.25.91.80])
        by smtp.gmail.com with ESMTPSA id k124sm6451204wmk.47.2019.08.15.17.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 17:45:09 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     h.feurstein@gmail.com, mlichvar@redhat.com,
        richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        broonie@kernel.org
Cc:     linux-spi@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH net-next 07/11] spi: spi-fsl-dspi: Add a debugging GPIO for monitoring latency
Date:   Fri, 16 Aug 2019 03:44:45 +0300
Message-Id: <20190816004449.10100-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190816004449.10100-1-olteanv@gmail.com>
References: <20190816004449.10100-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is being used to monitor the time it takes to transmit individual
bytes over SPI to the slave device. It is used in conjunction with the
PTP system timestamp feature - only the byte that was requested to be
timestamped triggers a toggle of the GPIO pin.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/spi/spi-fsl-dspi.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 3fc266d8263a..f0838853392d 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -203,6 +203,7 @@ struct fsl_dspi {
 	wait_queue_head_t	waitq;
 	u32			waitflags;
 
+	struct gpio_desc	*debug_gpio;
 	struct fsl_dspi_dma	*dma;
 };
 
@@ -223,6 +224,15 @@ static u32 dspi_pop_tx(struct fsl_dspi *dspi)
 	return txdata;
 }
 
+void dspi_debug_gpio(struct fsl_dspi *dspi, bool enabled)
+{
+	if (IS_ERR(dspi->debug_gpio)) {
+		dev_err(&dspi->pdev->dev, "Bad debug GPIO!\n");
+		return;
+	}
+	gpiod_set_value_cansleep(dspi->debug_gpio, enabled);
+}
+
 static u32 dspi_pop_tx_pushr(struct fsl_dspi *dspi)
 {
 	u16 cmd = dspi->tx_cmd, data = dspi_pop_tx(dspi);
@@ -661,8 +671,11 @@ static int dspi_rxtx(struct fsl_dspi *dspi)
 	u16 spi_tcnt;
 	u32 spi_tcr;
 
-	if (dspi->take_snapshot)
+	if (dspi->take_snapshot) {
 		ptp_read_system_postts(dspi->ptp_sts);
+		if (dspi->ptp_sts)
+			dspi_debug_gpio(dspi, 0);
+	}
 
 	/* Get transfer counter (in number of SPI transfers). It was
 	 * reset to 0 when transfer(s) were started.
@@ -683,8 +696,11 @@ static int dspi_rxtx(struct fsl_dspi *dspi)
 
 	dspi->take_snapshot = (dspi->tx == dspi->ptp_sts_word);
 
-	if (dspi->take_snapshot)
+	if (dspi->take_snapshot) {
+		if (dspi->ptp_sts)
+			dspi_debug_gpio(dspi, 1);
 		ptp_read_system_prets(dspi->ptp_sts);
+	}
 
 	if (dspi->devtype_data->trans_mode == DSPI_EOQ_MODE)
 		dspi_eoq_write(dspi);
@@ -799,8 +815,11 @@ static int dspi_transfer_one_message(struct spi_master *master,
 
 		dspi->take_snapshot = (dspi->tx == dspi->ptp_sts_word);
 
-		if (dspi->take_snapshot)
+		if (dspi->take_snapshot) {
+			if (dspi->ptp_sts)
+				dspi_debug_gpio(dspi, 1);
 			ptp_read_system_prets(dspi->ptp_sts);
+		}
 
 		trans_mode = dspi->devtype_data->trans_mode;
 		switch (trans_mode) {
@@ -1126,6 +1145,11 @@ static int dspi_probe(struct platform_device *pdev)
 		}
 	}
 
+	dspi->debug_gpio = devm_gpiod_get(&pdev->dev, "debug",
+					  GPIOD_OUT_HIGH);
+
+	dspi_debug_gpio(dspi, 0);
+
 	dspi->clk = devm_clk_get(&pdev->dev, "dspi");
 	if (IS_ERR(dspi->clk)) {
 		ret = PTR_ERR(dspi->clk);
-- 
2.17.1

