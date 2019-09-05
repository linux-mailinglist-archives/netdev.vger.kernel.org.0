Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB2CA97D2
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 03:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730224AbfIEBIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 21:08:05 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:56129 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727789AbfIEBIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 21:08:00 -0400
Received: by mail-wm1-f66.google.com with SMTP id g207so695579wmg.5;
        Wed, 04 Sep 2019 18:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=t5zxehNW63K06AJ8QGwgCB5nrotoKx8hpJWWf5E4I/U=;
        b=AHeiOPq57vVJXZjcIdfZn+F8c0ezLEImgBZUJJ3/WUqXD//+3rWx+p6Hn0Jz7fwZ0/
         xALLmu6uULBAEEBDDm7q+nVop4/fcczgHt6xHqdHTzCUrKfoXgzUcgt4192kFD5Mas7H
         XPUCeCgQOgFpdXIUl+06H7pqGEQHeMAMxVrLP1kF5DBkJEU2qas0O7MbfgKfLatJBiH+
         2vkUTqTumcFiqGLZeQKuKpNBfU4hBlUSDZ+epyErsdIFsRh7gNQpcbTwZHvQRZWZpZ1n
         NbaPiLPjRd9z/iXoswGcCEVKHkm2fcFED4ntARRBnpofls5Xh5tqnlbfJDOkSVKnEHO9
         sbBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=t5zxehNW63K06AJ8QGwgCB5nrotoKx8hpJWWf5E4I/U=;
        b=b3JjWE7ZHhr0Qsf/WP5dKdwoe9PoHAobf3M06vtfEPK7w/xmz5Zkv6r31Nc8YvSGy1
         pMHxYXx/yUd0evLEJiO1G9IDGckI6cOgTswns8J31tvUzJ/7FCTx5dvcsCSAiJh3YotC
         YavT/oVnTJhMZ9PsAvazH870dwJO4g+q+Dx7ZentxiXo5iHdgfLnS/au3b0c9h4WNLUp
         svmrw6HJPm6utR+EiH3qZ9yD1uPRZjOHG6ZTlJoV2fGrY4WvNtZ3c9FmJkFtDUi9r5PS
         Z4UKSUImMrp2GjoZQfi1rTP1DArNL3kJnOxM5ZaHUO2o7Y9vls6dlmxuzlORFQv5kGHS
         ejeg==
X-Gm-Message-State: APjAAAUyt2RKL2iW3S5Smg/0vbgCCP4eM148IpcIPLgP5OjJgO92Dfe8
        wTv3DuxLA9ztvVirc1L+av+Jvt+4
X-Google-Smtp-Source: APXvYqyw3l8SVHEM38wn36n0JYJyN4C1Krc5UrOWZn4PC8Q0x1Q0yXdyt5hGf4cjHT8i6Ys2OFxgwQ==
X-Received: by 2002:a7b:ce8f:: with SMTP id q15mr688578wmj.106.1567645679091;
        Wed, 04 Sep 2019 18:07:59 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id b15sm670125wmb.28.2019.09.04.18.07.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 18:07:58 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     broonie@kernel.org, h.feurstein@gmail.com, mlichvar@redhat.com,
        richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com
Cc:     linux-spi@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 3/4] spi: spi-fsl-dspi: Implement the PTP system timestamping for TCFQ mode
Date:   Thu,  5 Sep 2019 04:01:13 +0300
Message-Id: <20190905010114.26718-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905010114.26718-1-olteanv@gmail.com>
References: <20190905010114.26718-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In this mode, the DSPI controller uses PIO to transfer word by word. In
comparison, in EOQ mode the 4-word deep FIFO is being used, hence the
current logic will need some adaptation for which I do not have the
hardware (Coldfire) to test. It is not clear what is the timing of DMA
transfers and whether timestamping in the driver brings any overall
performance increase compared to regular timestamping done in the core.

Short phc2sys summary after 58 minutes of running on LS1021A-TSN with
interrupts disabled during the critical section:

  offset: min -26251 max 16416 mean -21.8672 std dev 863.416
  delay: min 4720 max 57280 mean 5182.49 std dev 1607.19
  lost servo lock 3 times

Summary of the same phc2sys service running for 120 minutes with
interrupts disabled:

  offset: min -378 max 381 mean -0.0083089 std dev 101.495
  delay: min 4720 max 5920 mean 5129.38 std dev 154.899
  lost servo lock 0 times

The minimum delay (pre to post time) in nanoseconds is the same, but the
maximum delay is quite a bit higher, due to interrupts getting sometimes
executed and interfering with the measurement. Hence set disable_irqs
whenever possible (aka when the driver runs in poll mode - otherwise it
would be a contradiction in terms).

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v2:
- Adapted to the newly introduced SPI core API from 02/04.

 drivers/spi/spi-fsl-dspi.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index bec758e978fb..7caea2da4397 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -129,6 +129,7 @@ enum dspi_trans_mode {
 struct fsl_dspi_devtype_data {
 	enum dspi_trans_mode	trans_mode;
 	u8			max_clock_factor;
+	bool			ptp_sts_supported;
 	bool			xspi_mode;
 };
 
@@ -140,12 +141,14 @@ static const struct fsl_dspi_devtype_data vf610_data = {
 static const struct fsl_dspi_devtype_data ls1021a_v1_data = {
 	.trans_mode		= DSPI_TCFQ_MODE,
 	.max_clock_factor	= 8,
+	.ptp_sts_supported	= true,
 	.xspi_mode		= true,
 };
 
 static const struct fsl_dspi_devtype_data ls2085a_data = {
 	.trans_mode		= DSPI_TCFQ_MODE,
 	.max_clock_factor	= 8,
+	.ptp_sts_supported	= true,
 };
 
 static const struct fsl_dspi_devtype_data coldfire_data = {
@@ -654,6 +657,9 @@ static int dspi_rxtx(struct fsl_dspi *dspi)
 	u16 spi_tcnt;
 	u32 spi_tcr;
 
+	spi_take_timestamp_post(dspi->ctlr, dspi->cur_transfer,
+				dspi->tx - dspi->bytes_per_word, !dspi->irq);
+
 	/* Get transfer counter (in number of SPI transfers). It was
 	 * reset to 0 when transfer(s) were started.
 	 */
@@ -672,6 +678,9 @@ static int dspi_rxtx(struct fsl_dspi *dspi)
 		/* Success! */
 		return 0;
 
+	spi_take_timestamp_pre(dspi->ctlr, dspi->cur_transfer,
+			       dspi->tx, !dspi->irq);
+
 	if (trans_mode == DSPI_EOQ_MODE)
 		dspi_eoq_write(dspi);
 	else if (trans_mode == DSPI_TCFQ_MODE)
@@ -779,6 +788,9 @@ static int dspi_transfer_one_message(struct spi_controller *ctlr,
 				     SPI_FRAME_EBITS(transfer->bits_per_word) |
 				     SPI_CTARE_DTCP(1));
 
+		spi_take_timestamp_pre(dspi->ctlr, dspi->cur_transfer,
+				       dspi->tx, !dspi->irq);
+
 		trans_mode = dspi->devtype_data->trans_mode;
 		switch (trans_mode) {
 		case DSPI_EOQ_MODE:
@@ -1132,6 +1144,7 @@ static int dspi_probe(struct platform_device *pdev)
 	init_waitqueue_head(&dspi->waitq);
 
 poll_mode:
+
 	if (dspi->devtype_data->trans_mode == DSPI_DMA_MODE) {
 		ret = dspi_request_dma(dspi, res->start);
 		if (ret < 0) {
@@ -1143,6 +1156,8 @@ static int dspi_probe(struct platform_device *pdev)
 	ctlr->max_speed_hz =
 		clk_get_rate(dspi->clk) / dspi->devtype_data->max_clock_factor;
 
+	ctlr->ptp_sts_supported = dspi->devtype_data->ptp_sts_supported;
+
 	platform_set_drvdata(pdev, ctlr);
 
 	ret = spi_register_controller(ctlr);
-- 
2.17.1

