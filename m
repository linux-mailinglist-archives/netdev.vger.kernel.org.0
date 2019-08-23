Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD069ADCB
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 13:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403881AbfHWLCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 07:02:30 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:56460 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403804AbfHWLC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 07:02:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=Date:Message-Id:In-Reply-To:
        Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:References:
        List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
        List-Archive; bh=mqrlg5qdclgMswZNo7YeuT7GTzz+9HMIwbV1tzQa7/o=; b=tAWhLvebAUeF
        ZMhTF7cMrpBzfMIEw1+Y2pV0shpl62di12XuNmwGgexF6Vw+voB1Fk/oNg/HvkM9ZbNSMT5SHrn/4
        Zk2dIjgpis3k0+iVajNeNzMI775zeP1XzcaY/kb12JWwsREdaSdroEg8Qf7oVgt1nFCd0FwFmchOu
        Szjzs=;
Received: from [92.54.175.117] (helo=fitzroy.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.org.uk>)
        id 1i17Kt-0002wG-Ft; Fri, 23 Aug 2019 11:02:27 +0000
Received: by fitzroy.sirena.org.uk (Postfix, from userid 1000)
        id 36BDAD02CD1; Fri, 23 Aug 2019 12:02:27 +0100 (BST)
From:   Mark Brown <broonie@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     broonie@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, netdev@vger.kernel.org
Subject: Applied "spi: spi-fsl-dspi: Exit the ISR with IRQ_NONE when it's not ours" to the spi tree
In-Reply-To: <20190822211514.19288-3-olteanv@gmail.com>
X-Patchwork-Hint: ignore
Message-Id: <20190823110227.36BDAD02CD1@fitzroy.sirena.org.uk>
Date:   Fri, 23 Aug 2019 12:02:27 +0100 (BST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch

   spi: spi-fsl-dspi: Exit the ISR with IRQ_NONE when it's not ours

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

From 37b4100180641968056cb4e034cebc38338e8652 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <olteanv@gmail.com>
Date: Fri, 23 Aug 2019 00:15:11 +0300
Subject: [PATCH] spi: spi-fsl-dspi: Exit the ISR with IRQ_NONE when it's not
 ours

The DSPI interrupt can be shared between two controllers at least on the
LX2160A. In that case, the driver for one controller might misbehave and
consume the other's interrupt. Fix this by actually checking if any of
the bits in the status register have been asserted.

Fixes: 13aed2392741 ("spi: spi-fsl-dspi: use IRQF_SHARED mode to request IRQ")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://lore.kernel.org/r/20190822211514.19288-3-olteanv@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 drivers/spi/spi-fsl-dspi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index c90db7db4121..6ef2279a3699 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -659,7 +659,7 @@ static irqreturn_t dspi_interrupt(int irq, void *dev_id)
 	regmap_write(dspi->regmap, SPI_SR, spi_sr);
 
 	if (!(spi_sr & (SPI_SR_EOQF | SPI_SR_TCFQF)))
-		return IRQ_HANDLED;
+		return IRQ_NONE;
 
 	/* Get transfer counter (in number of SPI transfers). It was
 	 * reset to 0 when transfer(s) were started.
-- 
2.20.1

