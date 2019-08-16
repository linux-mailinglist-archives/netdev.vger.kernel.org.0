Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5158F81A
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 02:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbfHPApY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 20:45:24 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:56239 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbfHPApM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 20:45:12 -0400
Received: by mail-wm1-f65.google.com with SMTP id f72so2702725wmf.5;
        Thu, 15 Aug 2019 17:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mu5nWf/bMI5ueoQpUG1+xvUDCnLZCriPbPRqb+hOo6s=;
        b=KxBfRZqWyo9XndTLeoRr1myB9FT1CHTHu+3zLtM6aoybnyfsdtzWK/iERyNtCwvr3d
         0mIpCyLKw4B0Nj5QoI5bnl6BXj8ERpKHax9fjUiMU5bG3OiGLvGq0MIxL9nj/MlunJEv
         zh4QNb3sFMc6W+wb4WQ+SgkyjxcLXnCqwe8kb9DwrQS/ZKtVUfPfhS//RhIx+S8SwKHl
         1qiaHDkPXQXMiFjdmCGhUZ+kPGZCuVQnV2gUhAjs6xpyi4RmYOiw2+jZNYYW0aEMQ9TK
         VWt355E5kbQBAPoqDVAtO9fC9DxTImns/3OpWeBMcdmoOuTEwJM9jO5HhyGatsQ9+Sx/
         vzXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mu5nWf/bMI5ueoQpUG1+xvUDCnLZCriPbPRqb+hOo6s=;
        b=ovJi2yfhqLNkDAAgLAQD60lh6djbEnzJQYul/2lZMXTV07A0CYC3F5NKJLcOqm1eI6
         gJvgbrTnWvM1TxtuGRlrNHcVU5Q+QIilfqwsOYnarYjzd4yEZ2kuQnFQWDbSUQNdVC5j
         r6udehnR7JpjE39fVrFWUdZhns2wypN6wJ1ZjpckUSAe6qQw4AWZixVjoWsNBp6vRW95
         MCBQA7uvmfb8z/e51hciNOl6wvidkPXFXSYyyiTO32pUxgQxdyNNOciHrQcxMhcT/5co
         AIySG5uJrA3K2/OnzahHACKeXTwboV26z4E3pzN6kWT0rzs1drpuX3tqg+Bqfq6+prON
         7HJA==
X-Gm-Message-State: APjAAAUlWGikeM3vJqRw41FXXYTSWe3UWXZJIaJ3w54tGNBrhfPSmMV4
        Cnlxt1NZIhQDH/y//N/Z8BU=
X-Google-Smtp-Source: APXvYqyPa8g8y0lZccaeXFoG4E0cTinrq5WGDuvnuiQQ25DGlY5qTLElgV6EBTeHmU/ino5YsMhCHQ==
X-Received: by 2002:a1c:200a:: with SMTP id g10mr4399126wmg.160.1565916310423;
        Thu, 15 Aug 2019 17:45:10 -0700 (PDT)
Received: from localhost.localdomain ([188.25.91.80])
        by smtp.gmail.com with ESMTPSA id k124sm6451204wmk.47.2019.08.15.17.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 17:45:10 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     h.feurstein@gmail.com, mlichvar@redhat.com,
        richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        broonie@kernel.org
Cc:     linux-spi@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH net-next 08/11] spi: spi-fsl-dspi: Disable interrupts and preemption during poll mode transfer
Date:   Fri, 16 Aug 2019 03:44:46 +0300
Message-Id: <20190816004449.10100-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190816004449.10100-1-olteanv@gmail.com>
References: <20190816004449.10100-1-olteanv@gmail.com>
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
index f0838853392d..5404f1b45ad0 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -184,6 +184,8 @@ struct fsl_dspi {
 	int			irq;
 	struct clk		*clk;
 
+	/* Used to disable IRQs and preemption */
+	spinlock_t		lock;
 	struct ptp_system_timestamp *ptp_sts;
 	const void		*ptp_sts_word;
 	bool			take_snapshot;
@@ -757,6 +759,7 @@ static int dspi_transfer_one_message(struct spi_master *master,
 	struct spi_device *spi = message->spi;
 	enum dspi_trans_mode trans_mode;
 	struct spi_transfer *transfer;
+	unsigned long flags = 0;
 	int status = 0;
 
 	message->actual_length = 0;
@@ -813,6 +816,9 @@ static int dspi_transfer_one_message(struct spi_master *master,
 				     SPI_FRAME_EBITS(transfer->bits_per_word) |
 				     SPI_CTARE_DTCP(1));
 
+		if (!dspi->irq)
+			spin_lock_irqsave(&dspi->lock, flags);
+
 		dspi->take_snapshot = (dspi->tx == dspi->ptp_sts_word);
 
 		if (dspi->take_snapshot) {
@@ -848,6 +854,9 @@ static int dspi_transfer_one_message(struct spi_master *master,
 			do {
 				status = dspi_poll(dspi);
 			} while (status == -EAGAIN);
+
+			spin_unlock_irqrestore(&dspi->lock, flags);
+
 		} else if (trans_mode != DSPI_DMA_MODE) {
 			status = wait_event_interruptible(dspi->waitq,
 							  dspi->waitflags);
@@ -1178,6 +1187,7 @@ static int dspi_probe(struct platform_device *pdev)
 	}
 
 	init_waitqueue_head(&dspi->waitq);
+	spin_lock_init(&dspi->lock);
 
 poll_mode:
 	if (dspi->devtype_data->trans_mode == DSPI_DMA_MODE) {
-- 
2.17.1

