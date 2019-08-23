Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0FC9ADCD
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 13:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404448AbfHWLCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 07:02:41 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:56458 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403794AbfHWLCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 07:02:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=Date:Message-Id:In-Reply-To:
        Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:References:
        List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
        List-Archive; bh=mN+5b9C6EttW1899uSNoCDw/gN4YKOp8DqLkxZDEmeY=; b=cU3D6gDFstnb
        NuFIihqPal2LO/DWdOQ476GsOpHQyQmxDTvG1SpUbKLk9jTbFFmFzDnd87MMe59wEUSYyEze9bC8W
        hf7vv+LYzrYF44g5SHsmyUKXOLCp332O91XyWd2CdndzKQVQ4RLprK+GSAyZXX02o0CIkRDxNKuoo
        TPlUw=;
Received: from [92.54.175.117] (helo=fitzroy.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.org.uk>)
        id 1i17Kt-0002wF-De; Fri, 23 Aug 2019 11:02:27 +0000
Received: by fitzroy.sirena.org.uk (Postfix, from userid 1000)
        id 24769D02CD0; Fri, 23 Aug 2019 12:02:27 +0100 (BST)
From:   Mark Brown <broonie@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     broonie@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, netdev@vger.kernel.org
Subject: Applied "spi: spi-fsl-dspi: Remove impossible to reach error check" to the spi tree
In-Reply-To: <20190822211514.19288-4-olteanv@gmail.com>
X-Patchwork-Hint: ignore
Message-Id: <20190823110227.24769D02CD0@fitzroy.sirena.org.uk>
Date:   Fri, 23 Aug 2019 12:02:27 +0100 (BST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch

   spi: spi-fsl-dspi: Remove impossible to reach error check

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

From 1eaeba70738e723be1e5787bdfd9a30f7471d730 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <olteanv@gmail.com>
Date: Fri, 23 Aug 2019 00:15:12 +0300
Subject: [PATCH] spi: spi-fsl-dspi: Remove impossible to reach error check

dspi->devtype_data is under the total control of the driver. Therefore,
a bad value is a driver bug and checking it at runtime (and during an
ISR, at that!) is pointless.

The second "else if" check is only for clarity (instead of a broader
"else") in case other transfer modes are added in the future. But the
printing is dead code and can be removed.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://lore.kernel.org/r/20190822211514.19288-4-olteanv@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 drivers/spi/spi-fsl-dspi.c | 24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 6ef2279a3699..6d2c7984ab0e 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -670,18 +670,10 @@ static irqreturn_t dspi_interrupt(int irq, void *dev_id)
 	msg->actual_length += spi_tcnt * dspi->bytes_per_word;
 
 	trans_mode = dspi->devtype_data->trans_mode;
-	switch (trans_mode) {
-	case DSPI_EOQ_MODE:
+	if (trans_mode == DSPI_EOQ_MODE)
 		dspi_eoq_read(dspi);
-		break;
-	case DSPI_TCFQ_MODE:
+	else if (trans_mode == DSPI_TCFQ_MODE)
 		dspi_tcfq_read(dspi);
-		break;
-	default:
-		dev_err(&dspi->pdev->dev, "unsupported trans_mode %u\n",
-			trans_mode);
-			return IRQ_HANDLED;
-	}
 
 	if (!dspi->len) {
 		dspi->waitflags = 1;
@@ -689,18 +681,10 @@ static irqreturn_t dspi_interrupt(int irq, void *dev_id)
 		return IRQ_HANDLED;
 	}
 
-	switch (trans_mode) {
-	case DSPI_EOQ_MODE:
+	if (trans_mode == DSPI_EOQ_MODE)
 		dspi_eoq_write(dspi);
-		break;
-	case DSPI_TCFQ_MODE:
+	else if (trans_mode == DSPI_TCFQ_MODE)
 		dspi_tcfq_write(dspi);
-		break;
-	default:
-		dev_err(&dspi->pdev->dev,
-			"unsupported trans_mode %u\n",
-			trans_mode);
-	}
 
 	return IRQ_HANDLED;
 }
-- 
2.20.1

