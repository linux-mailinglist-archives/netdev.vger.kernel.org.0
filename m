Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D21F918D6
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 20:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbfHRS0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 14:26:24 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38609 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbfHRS0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 14:26:20 -0400
Received: by mail-wm1-f65.google.com with SMTP id m125so1094990wmm.3;
        Sun, 18 Aug 2019 11:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JHQc72XV0m3j88ABn+ADDzngpJqZwEjGz07+W89yv4E=;
        b=aXmCO2a7gzWV0S1WdBPu/Zd9iMsDPEuXjIF/jtf2ybjRn8z6kENvSnSYlIyHnTkLdi
         Vyf3r2sd9zROukgetTOgzmQt3NrGKM3hDNuzKjafFVYxGIPf9GNJsT/8QttL+Y1cR+Z0
         0l5aC2pe8u2GmrdqKIP8IFWPtLxtKywHQDtWXCui0NwSG7AofTt7F7KKZEph/NBnxvQj
         VafMa5bU/OUYoNhYWZ6m/ZUBNpV79n4J/1JvxqXhpkgDBRGwsZ2UUbpW3p7lcOuFvlWF
         p+/7482BS1nt0Wwg0SYI37m55NXPYOL/CJY2AZ038YNW9G0jqyqtfpI7kmS33K5WQZfS
         MUhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JHQc72XV0m3j88ABn+ADDzngpJqZwEjGz07+W89yv4E=;
        b=DBWy4ISbyfFsq/23YAjozN6jdCd+fgjNx+RNDg9qfHyWO3Of8EVY1//TJXpYJjzsj5
         whi5AbXlxiv9E5D2YgP9qd+hhuV8184iQkeWeOAAcJUkRyGlZW8ZHu8e/K03O5Q5NKgW
         aKDmX5B2NqTQU6mJBtktVLQvujMj0A9zoliMAnqyRQUQEI+iybYrSKxXQJEvKFtXUk2z
         yODCbaScQVLVH3FaYCYGG2GXJRX+8xp0Egvw5g2xcn0zX8WH8yuUx9LkC+SCbsW7lVon
         UwcoJHGHv/J/9hRi8G/+edXCtb9YGzXgSp+eMTA5IAsvf7Urz5Pc+0NQ2gwUjF1VcREQ
         gt6A==
X-Gm-Message-State: APjAAAVJeTsgTaCYpKWUlHqmdAHDZ+s1/c+LCDtGHbaKkZUcVfsL+RXh
        GC7FeRYH7IRyWcZ7obHa7tSdXo8O
X-Google-Smtp-Source: APXvYqxZOz4ylbSuvROlZ8Q9uV0h8bQeS606lLFlIeyBHH6xmWTrPfdBiQQHZKb6zV3ANLKAmAzM9A==
X-Received: by 2002:a05:600c:296:: with SMTP id 22mr10078653wmk.148.1566152778220;
        Sun, 18 Aug 2019 11:26:18 -0700 (PDT)
Received: from localhost.localdomain ([188.25.91.80])
        by smtp.gmail.com with ESMTPSA id 39sm40831107wrc.45.2019.08.18.11.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Aug 2019 11:26:17 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     broonie@kernel.org, h.feurstein@gmail.com, mlichvar@redhat.com,
        richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com
Cc:     linux-spi@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH spi for-5.4 5/5] spi: spi-fsl-dspi: Disable interrupts and preemption during poll mode transfer
Date:   Sun, 18 Aug 2019 21:26:00 +0300
Message-Id: <20190818182600.3047-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190818182600.3047-1-olteanv@gmail.com>
References: <20190818182600.3047-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While the poll mode helps reduce the overall latency in transmitting a
SPI message in the EOQ and TCFQ modes, the transmission can still have
jitter due to the CPU needing to service interrupts.

The transmission latency does not matter except in situations where the
SPI transfer represents the readout of a POSIX clock. In that case,
even with the byte-level PTP system timestamping in place, a pending IRQ
might find its way to be processed on the local CPU exactly during the
window when the transfer is snapshotted.

Disabling interrupts ensures the above situation never happens. When it
does, it manifests itself as random delay spikes, which throw off the
servo loop of phc2sys and make it lose lock.

Short phc2sys summary after 58 minutes of running without this patch:

  offset: min -26251 max 16416 mean -21.8672 std dev 863.416
  delay: min 4720 max 57280 mean 5182.49 std dev 1607.19
  lost servo lock 3 times

Summary of the same phc2sys service running for 120 minutes with the
patch:

  offset: min -378 max 381 mean -0.0083089 std dev 101.495
  delay: min 4720 max 5920 mean 5129.38 std dev 154.899
  lost servo lock 0 times

Disable interrupts unconditionally if running in poll mode.
Two aspects:
- If the DSPI driver is in IRQ mode, then disabling interrupts becomes a
  contradiction in terms. Poll mode is recommendable for predictable
  latency.
- In theory it should be possible to disable interrupts only for SPI
  transfers that represent an interaction with a POSIX clock. The driver
  can sense this by looking at transfer->ptp_sts. However enabling this
  unconditionally makes issues much more visible (and not just in fringe
  cases), were they to ever appear.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/spi/spi-fsl-dspi.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index ea7169d18e09..c94574a20c8a 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -182,6 +182,8 @@ struct fsl_dspi {
 	int					irq;
 	struct clk				*clk;
 
+	/* Used to disable IRQs and preemption */
+	spinlock_t				lock;
 	struct ptp_system_timestamp		*ptp_sts;
 	const void				*ptp_sts_word_pre;
 	const void				*ptp_sts_word_post;
@@ -739,6 +741,7 @@ static int dspi_transfer_one_message(struct spi_controller *ctlr,
 	struct spi_device *spi = message->spi;
 	enum dspi_trans_mode trans_mode;
 	struct spi_transfer *transfer;
+	unsigned long flags = 0;
 	int status = 0;
 
 	message->actual_length = 0;
@@ -797,6 +800,9 @@ static int dspi_transfer_one_message(struct spi_controller *ctlr,
 				     SPI_FRAME_EBITS(transfer->bits_per_word) |
 				     SPI_CTARE_DTCP(1));
 
+		if (!dspi->irq)
+			spin_lock_irqsave(&dspi->lock, flags);
+
 		dspi->take_snapshot_pre = (dspi->tx == dspi->ptp_sts_word_pre);
 
 		if (dspi->take_snapshot_pre)
@@ -829,6 +835,9 @@ static int dspi_transfer_one_message(struct spi_controller *ctlr,
 			do {
 				status = dspi_poll(dspi);
 			} while (status == -EINPROGRESS);
+
+			spin_unlock_irqrestore(&dspi->lock, flags);
+
 		} else if (trans_mode != DSPI_DMA_MODE) {
 			status = wait_event_interruptible(dspi->waitq,
 							  dspi->waitflags);
@@ -1153,6 +1162,7 @@ static int dspi_probe(struct platform_device *pdev)
 	}
 
 	init_waitqueue_head(&dspi->waitq);
+	spin_lock_init(&dspi->lock);
 
 poll_mode:
 	if (dspi->devtype_data->trans_mode == DSPI_DMA_MODE) {
-- 
2.17.1

