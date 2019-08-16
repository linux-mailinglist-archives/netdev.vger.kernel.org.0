Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31A458F81C
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 02:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfHPAp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 20:45:28 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38527 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbfHPApK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 20:45:10 -0400
Received: by mail-wm1-f65.google.com with SMTP id m125so2705564wmm.3;
        Thu, 15 Aug 2019 17:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ImqyZJDmKPvgOe4k0V4FFzBk+8qBwZGqcDGc3TcKBm4=;
        b=DpqBbb9LSiCWuDGtMy63+9AFhO05ymfOJQyKegMfoWatYBvl23hnSK0JaA9bPlusNj
         VwL1lPiOTcsTLCaAMijXLX5pQJzISM/GJsy9vuGVBCLfDDLef90MEq5J6sZjr096RGnr
         1JqyB/S4Li3WMMqwX8cjDIdiy/P6Z/qijmirUsBIWN20DoPnLazzg754k3koKuSAKpP7
         T2UnmxqKCQeuz3HMafQOCNz8kGZoFGbdbfUY0dbcxh4WSV5/H7vpoH/QHfukYNedd3iL
         ZkENPOtFeimcOCbASj2I0ZIwOu71HDBbMXi028QrNArro5aC5b1wGG2dKJvCcKFwb1Cg
         9KVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ImqyZJDmKPvgOe4k0V4FFzBk+8qBwZGqcDGc3TcKBm4=;
        b=dMyMtXCsLvFsmWj9H1liLg3QeFTt4pypPM3EWvzAeDxH8anUE4YipXh1IcYyu4W+UE
         3Nyy2oOu/4D/kGSLICNKCrRnaV2aTAPMT57JhqKxWBP9AZNuJk8nXEAanKkNaNqLvf64
         ebPpGMG84IPJvUh6EqwtAJGJUstcoFWpvKk/MZrir/DuC0DMsvpTlUHvZnW6FTzBT62l
         o4A7Jj6bc98d24HK2JkzeyBsIA6M09dXkNxK2XPrW80TDeSgsi1ElQSl+X3c4rrYwUdo
         KzZ8Xy9t96ou4iL06iqA8M8+FnvRvCEWlmELM9Hqyle/zyVIkrzv++Rqb8aFCh+oTjhA
         fycw==
X-Gm-Message-State: APjAAAUMBaMMHhBPWJjmC/ZWKwqEO51V39hcUUZS2hc0zXs6iWZWZ9bA
        tsQylue0L4ySuFby1MSgH1U=
X-Google-Smtp-Source: APXvYqwqYR8mIqlcj16RMrSY+eK8fzNxogZdvPaGEHisWmxRieq+yTXkHqb9tUTif5bu0f4XvrXwVg==
X-Received: by 2002:a7b:cc0f:: with SMTP id f15mr501389wmh.39.1565916308462;
        Thu, 15 Aug 2019 17:45:08 -0700 (PDT)
Received: from localhost.localdomain ([188.25.91.80])
        by smtp.gmail.com with ESMTPSA id k124sm6451204wmk.47.2019.08.15.17.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 17:45:08 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     h.feurstein@gmail.com, mlichvar@redhat.com,
        richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        broonie@kernel.org
Cc:     linux-spi@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH net-next 06/11] spi: spi-fsl-dspi: Implement the PTP system timestamping
Date:   Fri, 16 Aug 2019 03:44:44 +0300
Message-Id: <20190816004449.10100-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190816004449.10100-1-olteanv@gmail.com>
References: <20190816004449.10100-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a snapshotting software feature for TCFQ and EOQ modes of
operation. Due to my lack of proper understanding of the DMA mode,
the latter mode is left as an exercise for future developers.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/spi/spi-fsl-dspi.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 41c45ee2bb2d..3fc266d8263a 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -184,6 +184,9 @@ struct fsl_dspi {
 	int			irq;
 	struct clk		*clk;
 
+	struct ptp_system_timestamp *ptp_sts;
+	const void		*ptp_sts_word;
+	bool			take_snapshot;
 	struct spi_transfer	*cur_transfer;
 	struct spi_message	*cur_msg;
 	struct chip_data	*cur_chip;
@@ -658,6 +661,9 @@ static int dspi_rxtx(struct fsl_dspi *dspi)
 	u16 spi_tcnt;
 	u32 spi_tcr;
 
+	if (dspi->take_snapshot)
+		ptp_read_system_postts(dspi->ptp_sts);
+
 	/* Get transfer counter (in number of SPI transfers). It was
 	 * reset to 0 when transfer(s) were started.
 	 */
@@ -675,6 +681,11 @@ static int dspi_rxtx(struct fsl_dspi *dspi)
 		/* Success! */
 		return 0;
 
+	dspi->take_snapshot = (dspi->tx == dspi->ptp_sts_word);
+
+	if (dspi->take_snapshot)
+		ptp_read_system_prets(dspi->ptp_sts);
+
 	if (dspi->devtype_data->trans_mode == DSPI_EOQ_MODE)
 		dspi_eoq_write(dspi);
 	else
@@ -764,6 +775,8 @@ static int dspi_transfer_one_message(struct spi_master *master,
 		dspi->rx = transfer->rx_buf;
 		dspi->rx_end = dspi->rx + transfer->len;
 		dspi->len = transfer->len;
+		dspi->ptp_sts = transfer->ptp_sts;
+		dspi->ptp_sts_word = dspi->tx + transfer->ptp_sts_word_offset;
 		/* Validated transfer specific frame size (defaults applied) */
 		dspi->bits_per_word = transfer->bits_per_word;
 		if (transfer->bits_per_word <= 8)
@@ -784,6 +797,11 @@ static int dspi_transfer_one_message(struct spi_master *master,
 				     SPI_FRAME_EBITS(transfer->bits_per_word) |
 				     SPI_CTARE_DTCP(1));
 
+		dspi->take_snapshot = (dspi->tx == dspi->ptp_sts_word);
+
+		if (dspi->take_snapshot)
+			ptp_read_system_prets(dspi->ptp_sts);
+
 		trans_mode = dspi->devtype_data->trans_mode;
 		switch (trans_mode) {
 		case DSPI_EOQ_MODE:
-- 
2.17.1

