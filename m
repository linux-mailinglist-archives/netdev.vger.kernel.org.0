Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E819912BBC1
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 00:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbfL0XGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 18:06:04 -0500
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:42742 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbfL0XGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 18:06:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=Date:Message-Id:In-Reply-To:
        Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:References:
        List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
        List-Archive; bh=a/Omcxi51q/doRd8pPO1rXZXChkD1R3YfPIl5nLLstE=; b=lsh3zrKuvN3z
        12Du2KnpZhUIdu9Cczg7CJlRm9+SpTMR6kT2uSdterKX6BfmZZ7fVedjb9Jxe3QhFnUrwjs4V0Pxl
        zlbuGzY7UpDIv7dQH33lRxaW7BfQwl0ICE9oAdIWDQ+7/PRB1EyK4gyzvFJYzXorD3jnI6mEUV3tn
        m3OtI=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=fitzroy.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.org.uk>)
        id 1ikyZ8-0006c7-Il; Fri, 27 Dec 2019 22:58:42 +0000
Received: by fitzroy.sirena.org.uk (Postfix, from userid 1000)
        id 118BED01A22; Fri, 27 Dec 2019 22:58:42 +0000 (GMT)
From:   Mark Brown <broonie@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     broonie@kernel.org, linux-spi@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, netdev@vger.kernel.org
Subject: Applied "spi: Catch improper use of PTP system timestamping API" to the spi tree
In-Reply-To: <20191227012444.1204-1-olteanv@gmail.com>
Message-Id: <applied-20191227012444.1204-1-olteanv@gmail.com>
X-Patchwork-Hint: ignore
Date:   Fri, 27 Dec 2019 22:58:42 +0000 (GMT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch

   spi: Catch improper use of PTP system timestamping API

has been applied to the spi tree at

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git for-5.6

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

From f971a2074447726ec9a3feee3648a2e157f08248 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <olteanv@gmail.com>
Date: Fri, 27 Dec 2019 03:24:44 +0200
Subject: [PATCH] spi: Catch improper use of PTP system timestamping API

We can catch whether the SPI controller has declared it can take care of
software timestamping transfers, but didn't. So do it.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://lore.kernel.org/r/20191227012444.1204-1-olteanv@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 drivers/spi/spi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 5e4c4532f7f3..5485ef89197c 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1680,6 +1680,13 @@ void spi_finalize_current_message(struct spi_controller *ctlr)
 		}
 	}
 
+	if (unlikely(ctlr->ptp_sts_supported)) {
+		list_for_each_entry(xfer, &mesg->transfers, transfer_list) {
+			WARN_ON_ONCE(xfer->ptp_sts && !xfer->timestamped_pre);
+			WARN_ON_ONCE(xfer->ptp_sts && !xfer->timestamped_post);
+		}
+	}
+
 	spi_unmap_msg(ctlr, mesg);
 
 	if (ctlr->cur_msg_prepared && ctlr->unprepare_message) {
-- 
2.20.1

