Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 557ABCF780
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 12:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730584AbfJHKxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 06:53:05 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:47808 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730533AbfJHKw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 06:52:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=Date:Message-Id:In-Reply-To:
        Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:References:
        List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
        List-Archive; bh=ttfY0g79SYV72PXPKl3+eOdB+v+wDuyZDPHH//Yon1U=; b=FncgHAwSuXtS
        1fM9kBN3+yR7doR4Ydh3TgOuuRHnbL0uxqDe9zXPF1uroIINDQ6RvNXnuZaEUAgKBsyogMQE4hbyV
        Tox7VLflQ6NhSWwZ65P5+eBAeSt9rKLV2/3wVn0j/u0pJpw8iXi0QY9eJUmS+cYdF+bYoMThN3eUr
        irF/8=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=ypsilon.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.co.uk>)
        id 1iHn6s-00084D-R8; Tue, 08 Oct 2019 10:52:54 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
        id 58628274299B; Tue,  8 Oct 2019 11:52:54 +0100 (BST)
From:   Mark Brown <broonie@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     andrew@lunn.ch, broonie@kernel.org, f.fainelli@gmail.com,
        h.feurstein@gmail.com, linux-spi@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, mlichvar@redhat.com,
        netdev@vger.kernel.org, richardcochran@gmail.com
Subject: Applied "spi: spi-fsl-dspi: Implement the PTP system timestamping for TCFQ mode" to the spi tree
In-Reply-To: <20190905010114.26718-4-olteanv@gmail.com>
X-Patchwork-Hint: ignore
Message-Id: <20191008105254.58628274299B@ypsilon.sirena.org.uk>
Date:   Tue,  8 Oct 2019 11:52:54 +0100 (BST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch

   spi: spi-fsl-dspi: Implement the PTP system timestamping for TCFQ mode

has been applied to the spi tree at

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git for-5.5

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.  

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark

From d6b71dfaeeba115dd61a7f367cf04c2d0ca77ebb Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <olteanv@gmail.com>
Date: Thu, 5 Sep 2019 04:01:13 +0300
Subject: [PATCH] spi: spi-fsl-dspi: Implement the PTP system timestamping for
 TCFQ mode

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
Link: https://lore.kernel.org/r/20190905010114.26718-4-olteanv@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 drivers/spi/spi-fsl-dspi.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index c61074502145..c0e96cc7fc51 100644
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
@@ -1155,6 +1167,7 @@ static int dspi_probe(struct platform_device *pdev)
 	init_waitqueue_head(&dspi->waitq);
 
 poll_mode:
+
 	if (dspi->devtype_data->trans_mode == DSPI_DMA_MODE) {
 		ret = dspi_request_dma(dspi, res->start);
 		if (ret < 0) {
@@ -1166,6 +1179,8 @@ static int dspi_probe(struct platform_device *pdev)
 	ctlr->max_speed_hz =
 		clk_get_rate(dspi->clk) / dspi->devtype_data->max_clock_factor;
 
+	ctlr->ptp_sts_supported = dspi->devtype_data->ptp_sts_supported;
+
 	platform_set_drvdata(pdev, ctlr);
 
 	ret = spi_register_controller(ctlr);
-- 
2.20.1

