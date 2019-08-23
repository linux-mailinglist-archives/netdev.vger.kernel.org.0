Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 941339ADD0
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 13:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404864AbfHWLCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 07:02:48 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:56462 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403857AbfHWLCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 07:02:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=Date:Message-Id:In-Reply-To:
        Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:References:
        List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
        List-Archive; bh=81XkYAt1dlSIAEhjcYLBf1Q8HHzaz4ERhe2Y36L5NpU=; b=HA+ZvtLmbC5b
        2CMe30cWTu+37mZVf6jhdYOzE/2v5+oiRnQoFhWodGW8rGsjKQM9A/8S92CVLkHc1ha893mE5y4UP
        5oeHZngsl8rpdmKOH1pqStlzux82HGoKqS27JxA9eygefyRGX84QfBQAFaRUaKY8ZY8uapEp3UjxI
        SN0fg=;
Received: from [92.54.175.117] (helo=fitzroy.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.org.uk>)
        id 1i17Kt-0002wH-IE; Fri, 23 Aug 2019 11:02:27 +0000
Received: by fitzroy.sirena.org.uk (Postfix, from userid 1000)
        id 4885AD02CD3; Fri, 23 Aug 2019 12:02:27 +0100 (BST)
From:   Mark Brown <broonie@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     broonie@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, netdev@vger.kernel.org
Subject: Applied "spi: spi-fsl-dspi: Reduce indentation level in dspi_interrupt" to the spi tree
In-Reply-To: <20190822211514.19288-2-olteanv@gmail.com>
X-Patchwork-Hint: ignore
Message-Id: <20190823110227.4885AD02CD3@fitzroy.sirena.org.uk>
Date:   Fri, 23 Aug 2019 12:02:27 +0100 (BST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch

   spi: spi-fsl-dspi: Reduce indentation level in dspi_interrupt

has been applied to the spi tree at

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git for-5.4

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

From 12fb61a973935c63f2580b3b053017cc14b51f42 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <olteanv@gmail.com>
Date: Fri, 23 Aug 2019 00:15:10 +0300
Subject: [PATCH] spi: spi-fsl-dspi: Reduce indentation level in dspi_interrupt

If the entire function depends on the SPI status register having the
interrupt bits asserted, then just check it and exit early if those bits
aren't set (such as in the case of the shared IRQ being triggered for
the other peripheral). Cosmetic patch.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://lore.kernel.org/r/20190822211514.19288-2-olteanv@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 drivers/spi/spi-fsl-dspi.c | 79 +++++++++++++++++++-------------------
 1 file changed, 40 insertions(+), 39 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 790cb02fc181..c90db7db4121 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -658,47 +658,48 @@ static irqreturn_t dspi_interrupt(int irq, void *dev_id)
 	regmap_read(dspi->regmap, SPI_SR, &spi_sr);
 	regmap_write(dspi->regmap, SPI_SR, spi_sr);
 
+	if (!(spi_sr & (SPI_SR_EOQF | SPI_SR_TCFQF)))
+		return IRQ_HANDLED;
+
+	/* Get transfer counter (in number of SPI transfers). It was
+	 * reset to 0 when transfer(s) were started.
+	 */
+	regmap_read(dspi->regmap, SPI_TCR, &spi_tcr);
+	spi_tcnt = SPI_TCR_GET_TCNT(spi_tcr);
+	/* Update total number of bytes that were transferred */
+	msg->actual_length += spi_tcnt * dspi->bytes_per_word;
+
+	trans_mode = dspi->devtype_data->trans_mode;
+	switch (trans_mode) {
+	case DSPI_EOQ_MODE:
+		dspi_eoq_read(dspi);
+		break;
+	case DSPI_TCFQ_MODE:
+		dspi_tcfq_read(dspi);
+		break;
+	default:
+		dev_err(&dspi->pdev->dev, "unsupported trans_mode %u\n",
+			trans_mode);
+			return IRQ_HANDLED;
+	}
 
-	if (spi_sr & (SPI_SR_EOQF | SPI_SR_TCFQF)) {
-		/* Get transfer counter (in number of SPI transfers). It was
-		 * reset to 0 when transfer(s) were started.
-		 */
-		regmap_read(dspi->regmap, SPI_TCR, &spi_tcr);
-		spi_tcnt = SPI_TCR_GET_TCNT(spi_tcr);
-		/* Update total number of bytes that were transferred */
-		msg->actual_length += spi_tcnt * dspi->bytes_per_word;
-
-		trans_mode = dspi->devtype_data->trans_mode;
-		switch (trans_mode) {
-		case DSPI_EOQ_MODE:
-			dspi_eoq_read(dspi);
-			break;
-		case DSPI_TCFQ_MODE:
-			dspi_tcfq_read(dspi);
-			break;
-		default:
-			dev_err(&dspi->pdev->dev, "unsupported trans_mode %u\n",
-				trans_mode);
-				return IRQ_HANDLED;
-		}
+	if (!dspi->len) {
+		dspi->waitflags = 1;
+		wake_up_interruptible(&dspi->waitq);
+		return IRQ_HANDLED;
+	}
 
-		if (!dspi->len) {
-			dspi->waitflags = 1;
-			wake_up_interruptible(&dspi->waitq);
-		} else {
-			switch (trans_mode) {
-			case DSPI_EOQ_MODE:
-				dspi_eoq_write(dspi);
-				break;
-			case DSPI_TCFQ_MODE:
-				dspi_tcfq_write(dspi);
-				break;
-			default:
-				dev_err(&dspi->pdev->dev,
-					"unsupported trans_mode %u\n",
-					trans_mode);
-			}
-		}
+	switch (trans_mode) {
+	case DSPI_EOQ_MODE:
+		dspi_eoq_write(dspi);
+		break;
+	case DSPI_TCFQ_MODE:
+		dspi_tcfq_write(dspi);
+		break;
+	default:
+		dev_err(&dspi->pdev->dev,
+			"unsupported trans_mode %u\n",
+			trans_mode);
 	}
 
 	return IRQ_HANDLED;
-- 
2.20.1

