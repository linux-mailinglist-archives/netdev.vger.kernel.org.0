Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09C82918D3
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 20:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfHRS0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 14:26:20 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43281 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbfHRS0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 14:26:19 -0400
Received: by mail-wr1-f68.google.com with SMTP id y8so6373508wrn.10;
        Sun, 18 Aug 2019 11:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6UTR4YjSPp4cvlWTll4PTd3gemQVYHSKz0X0IEZIQm8=;
        b=h9avmaL6KndLpgW/6KxDzzozRnd9amA3Ec/IbHA2OssYnwv8CH2qa5HlfCR1f30jtS
         S3jVcm7ZwEuEhlHrMbSWq7Fix2M4N9CkK9RdC2eydIhsMICSDdT1HjcRnxBMDkIBvXmE
         +1zdkjqePC+/gFc/5HcZyhxWKix9qhpAOxXv4KZ/X+LDDeI3xgi6de274tzP65RgspCy
         /W6f6xeQ4brVviPuoUB2envJusMZCd2xxH6MZrWy8UULk9S7KCNpY7SqP++ZvMT6aGbT
         WGZlu1ssgiex32JxGtkjmOQ4/HO8E31zpSv7EBfqwBawIJxRW7iSuG/iyhRbH8lQul+O
         RNFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6UTR4YjSPp4cvlWTll4PTd3gemQVYHSKz0X0IEZIQm8=;
        b=cOxEQRn7mdn/Pw/SeVYhJQ0QDLSnUPRU14/oR5iqDs5apt5FBI7Lia9MJNm56Y0nQt
         Watq9RbzOJ0ps5pP5kXolsnZHurkpJ+n3w8zRRJia6r1ONJCqAHb93M4GDbna+Gbh2wx
         sKCXwaP6euPubHkbitbBCXSA3Z3etl0NZJWvv7+8Apwg507ErGC7zzqKAjxMhQkDu+ay
         +pEbSVjr5KbFXoLG6RZRFUlzHCiyDN4Kc/40HkUxIM0P4RkB46vO5HlfFpGqYgqL0BMF
         UgJSiiMIcDllnPZpRrQgy0sVbbSnMmaWuntQRD7KorMfSAB70k3LmL+Dc1fThZVh5hep
         8IZw==
X-Gm-Message-State: APjAAAWarhqnC74VzCKROqn50zcYPw2RJQsqvXr43J6dhpxNpQ2aLxLb
        vRkcZ3s5E3NfpcZFiopY9bS5HxR2
X-Google-Smtp-Source: APXvYqyoxauAMVptPTAnoxE7NUdMSvsttlgxk+53hnN4QpNiV3Nfb9i+W0lC93Xvz3eXwu3yLB3FyA==
X-Received: by 2002:adf:fd82:: with SMTP id d2mr21833998wrr.194.1566152777161;
        Sun, 18 Aug 2019 11:26:17 -0700 (PDT)
Received: from localhost.localdomain ([188.25.91.80])
        by smtp.gmail.com with ESMTPSA id 39sm40831107wrc.45.2019.08.18.11.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Aug 2019 11:26:16 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     broonie@kernel.org, h.feurstein@gmail.com, mlichvar@redhat.com,
        richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com
Cc:     linux-spi@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH spi for-5.4 4/5] spi: spi-fsl-dspi: Implement the PTP system timestamping for TCFQ mode
Date:   Sun, 18 Aug 2019 21:25:59 +0300
Message-Id: <20190818182600.3047-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190818182600.3047-1-olteanv@gmail.com>
References: <20190818182600.3047-1-olteanv@gmail.com>
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

Tested on LS1021A.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/spi/spi-fsl-dspi.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 4daf8c3d07b7..ea7169d18e09 100644
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
@@ -179,6 +182,11 @@ struct fsl_dspi {
 	int					irq;
 	struct clk				*clk;
 
+	struct ptp_system_timestamp		*ptp_sts;
+	const void				*ptp_sts_word_pre;
+	const void				*ptp_sts_word_post;
+	bool					take_snapshot_pre;
+	bool					take_snapshot_post;
 	struct spi_transfer			*cur_transfer;
 	struct spi_message			*cur_msg;
 	struct chip_data			*cur_chip;
@@ -653,6 +661,9 @@ static int dspi_rxtx(struct fsl_dspi *dspi)
 	u16 spi_tcnt;
 	u32 spi_tcr;
 
+	if (dspi->take_snapshot_post)
+		ptp_read_system_postts(dspi->ptp_sts);
+
 	/* Get transfer counter (in number of SPI transfers). It was
 	 * reset to 0 when transfer(s) were started.
 	 */
@@ -670,6 +681,12 @@ static int dspi_rxtx(struct fsl_dspi *dspi)
 		/* Success! */
 		return 0;
 
+	dspi->take_snapshot_pre = (dspi->tx == dspi->ptp_sts_word_pre);
+	dspi->take_snapshot_post = (dspi->tx == dspi->ptp_sts_word_post);
+
+	if (dspi->take_snapshot_pre)
+		ptp_read_system_prets(dspi->ptp_sts);
+
 	if (dspi->devtype_data->trans_mode == DSPI_EOQ_MODE)
 		dspi_eoq_write(dspi);
 	else
@@ -764,6 +781,10 @@ static int dspi_transfer_one_message(struct spi_controller *ctlr,
 			dspi->bytes_per_word = 2;
 		else
 			dspi->bytes_per_word = 4;
+		dspi->ptp_sts = transfer->ptp_sts;
+		dspi->ptp_sts_word_pre = spi_xfer_ptp_sts_word(transfer, true);
+		dspi->ptp_sts_word_post = spi_xfer_ptp_sts_word(transfer,
+								false);
 
 		regmap_update_bits(dspi->regmap, SPI_MCR,
 				   SPI_MCR_CLR_TXF | SPI_MCR_CLR_RXF,
@@ -776,6 +797,11 @@ static int dspi_transfer_one_message(struct spi_controller *ctlr,
 				     SPI_FRAME_EBITS(transfer->bits_per_word) |
 				     SPI_CTARE_DTCP(1));
 
+		dspi->take_snapshot_pre = (dspi->tx == dspi->ptp_sts_word_pre);
+
+		if (dspi->take_snapshot_pre)
+			ptp_read_system_prets(dspi->ptp_sts);
+
 		trans_mode = dspi->devtype_data->trans_mode;
 		switch (trans_mode) {
 		case DSPI_EOQ_MODE:
@@ -1140,6 +1166,8 @@ static int dspi_probe(struct platform_device *pdev)
 	ctlr->max_speed_hz =
 		clk_get_rate(dspi->clk) / dspi->devtype_data->max_clock_factor;
 
+	ctlr->ptp_sts_supported = dspi->devtype_data->ptp_sts_supported;
+
 	platform_set_drvdata(pdev, ctlr);
 
 	ret = spi_register_controller(ctlr);
-- 
2.17.1

