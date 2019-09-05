Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25202A97CD
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 03:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730112AbfIEBID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 21:08:03 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:56132 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729919AbfIEBIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 21:08:01 -0400
Received: by mail-wm1-f68.google.com with SMTP id g207so695604wmg.5;
        Wed, 04 Sep 2019 18:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BtXETVKXFJe6FPHxTO9TLLqiQam7bkQepJpAF4AjFU4=;
        b=ZU+Sw84HT/8IphJQh6loSkm9KNVNDZ9QZvq4/msqw3ML3gPpjOCXlCtR9bz6vioEx1
         LVBaeiUIngr3gxwGuyNv3DwewNExRQyDnhon7oUp4yGAIJVTU9rvtnFQ/wHC7wcE/bJd
         2HGUPbJEyRAO4koqdKXyETffUMx6xiAhUwn4Pm7E7tDuF3M6ja4VWgAbQNgIJ8vdVbt4
         rLqiCicnxa2KaXprJTDTUZMA0I0BrzdKTckjiEsxoklXmMbC0VgA/6OFUER6SzGnTYfp
         dWuG/qhyinG+ITu52jyvgHmm2x+hxA/91tKLijww7DjeAspjMhy8CBsnze46qoMZcPIf
         BJEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BtXETVKXFJe6FPHxTO9TLLqiQam7bkQepJpAF4AjFU4=;
        b=DvPyIu3mvjDF5kqd/UiVrIzG+YHrbKZwEFfa6Qa+6FxqNkpeqZB5T9D7W89TUI2gYH
         /Na3NvhJon/8qfNyQInFjkVZD2JJjaZMPOjrTN4NEMmkYGUl4ANqul1fVp6V33iX2+Ye
         yxbUNu3uLPR0aZWYNv6TnmdThilDKXiwGddi13zUc57QJ66MYtV6vE4ios7SNpu58pPd
         dzjUymM288tslB+E6lK58bT+ircjqvsW9BrRKafKlhabtbt3eX9WE8/igppfg14S9SjA
         LdQsBqkF7fPsg62tRPbId2BzUk4N6XEJsoq3mD0ICC2beObnOaGIfS67KsFA002m6SDW
         dOSw==
X-Gm-Message-State: APjAAAVAMWngx8usg26NSRhF4CPGi+o1U6uxXQd9Twbehc6A4lrHSKA2
        CPETLEt6T+tcOcKM9KW8NNI=
X-Google-Smtp-Source: APXvYqwkNdnA21T9Gkqk+LdFzxj2v/Zcw/nfaiilL0gGv9t9KTapp8SYOFjemZrLHrW/97tN8K8xyg==
X-Received: by 2002:a1c:1d85:: with SMTP id d127mr773378wmd.14.1567645680086;
        Wed, 04 Sep 2019 18:08:00 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id b15sm670125wmb.28.2019.09.04.18.07.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 18:07:59 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     broonie@kernel.org, h.feurstein@gmail.com, mlichvar@redhat.com,
        richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com
Cc:     linux-spi@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 4/4] spi: spi-fsl-dspi: Always use the TCFQ devices in poll mode
Date:   Thu,  5 Sep 2019 04:01:14 +0300
Message-Id: <20190905010114.26718-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905010114.26718-1-olteanv@gmail.com>
References: <20190905010114.26718-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With this patch, the "interrupts" property from the device tree bindings
is ignored, even if present, if the driver runs in TCFQ mode.

Switching to using the DSPI in poll mode has several distinct
benefits:

- With interrupts, the DSPI driver in TCFQ mode raises an IRQ after each
  transmitted word. There is more time wasted for the "waitq" event than
  for actual I/O. And the DSPI IRQ count can easily get the largest in
  /proc/interrupts on Freescale boards with attached SPI devices.

- The SPI I/O time is both lower, and more consistently so. Attached to
  some Freescale devices are either PTP switches, or SPI RTCs. For
  reading time off of a SPI slave device, it is important that all SPI
  transfers take a deterministic time to complete.

- In poll mode there is much less time spent by the CPU in hardirq
  context, which helps with the response latency of the system, and at
  the same time there is more control over when interrupts must be
  disabled (to get a precise timestamp measurement): win-win.

On the LS1021A-TSN board, where the SPI device is a SJA1105 PTP switch
(with a bits_per_word=8 driver), I created a "benchmark" where I read
its PTP time once per second, for 120 seconds. Each "read PTP time" is a
12-byte SPI transfer. I then recorded the time before putting the first
byte in the TX FIFO, and the time after reading the last byte from the
RX FIFO. That is the transfer delay in nanoseconds.

Interrupt mode:

  delay: min 125120 max 168320 mean 150286 std dev 17675.3

Poll mode:

  delay: min 69440 max 119040 mean 70312.9 std dev 8065.34

Both the mean latency and the standard deviation are more than 50% lower
in poll mode than in interrupt mode. This is with an 'ondemand' governor
on an otherwise idle system - therefore running mostly at 600 MHz out of
a max of 1200 MHz.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v2:
- None.

 drivers/spi/spi-fsl-dspi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 7caea2da4397..c30325faa050 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -716,7 +716,7 @@ static irqreturn_t dspi_interrupt(int irq, void *dev_id)
 	regmap_read(dspi->regmap, SPI_SR, &spi_sr);
 	regmap_write(dspi->regmap, SPI_SR, spi_sr);
 
-	if (!(spi_sr & (SPI_SR_EOQF | SPI_SR_TCFQF)))
+	if (!(spi_sr & SPI_SR_EOQF))
 		return IRQ_NONE;
 
 	if (dspi_rxtx(dspi) == 0) {
@@ -1126,6 +1126,9 @@ static int dspi_probe(struct platform_device *pdev)
 
 	dspi_init(dspi);
 
+	if (dspi->devtype_data->trans_mode == DSPI_TCFQ_MODE)
+		goto poll_mode;
+
 	dspi->irq = platform_get_irq(pdev, 0);
 	if (dspi->irq <= 0) {
 		dev_info(&pdev->dev,
-- 
2.17.1

