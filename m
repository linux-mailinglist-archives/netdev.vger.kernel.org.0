Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46FF26120D
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 17:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbfGFP71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 11:59:27 -0400
Received: from mo4-p05-ob.smtp.rzone.de ([85.215.255.130]:15726 "EHLO
        mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbfGFP71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 11:59:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1562428765;
        s=strato-dkim-0002; d=jm0.eu;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=4CSxubuFF22g+ZCX8fQKkWTlLw2BxrkpqwCwq+JllT0=;
        b=VlqsRyxY7JJAKk9+KDfCngC1X4szGpIPtQ5hki1Q9144FxMvaYdmt2rcW4Pc3Puy4A
        cMZq9qNrjZLIVi7V1WVp5dBG34HwRItU2uldpt6IQtoExLqUE0wDlf5IBqbEXXGyOfOU
        eEl+2hKuipPctKKVxx2HerrcHUs0FadL54sZZGvzG8XfFkvpE5YY2OoqGQdlal3kFL98
        MXv5GxiKmc5ErKQfEw0Ifh5MI7aiERAyj+lPWQF/jVJmVyjmbsDpO2uZytUzx37RPukr
        1RRRVBPI4YstbS1BCh1ElYhQa0UCa1p1qfj75WajQyfeCv9UwWYwTm1wGEOKErXSQmtL
        nvYA==
X-RZG-AUTH: ":JmMXYEHmdv4HaV2cbPh7iS0wbr/uKIfGM0EPWe8EZQbw/dDJ/fVPBaXaSiaF5/mu26zWKwNU"
X-RZG-CLASS-ID: mo05
Received: from linux-1tvp.lan
        by smtp.strato.de (RZmta 44.24 DYNA|AUTH)
        with ESMTPSA id h0a328v66FJD6MX
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Sat, 6 Jul 2019 17:19:13 +0200 (CEST)
From:   josua@solid-run.com
To:     netdev@vger.kernel.org
Cc:     Josua Mayer <josua@solid-run.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3/4] net: mvmdio: print warning when orion-mdio has too many clocks
Date:   Sat,  6 Jul 2019 17:18:59 +0200
Message-Id: <20190706151900.14355-4-josua@solid-run.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190706151900.14355-1-josua@solid-run.com>
References: <20190706151900.14355-1-josua@solid-run.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Josua Mayer <josua@solid-run.com>

Print a warning when device tree specifies more than the maximum of four
clocks supported by orion-mdio. Because reading from mdio can lock up
the Armada 8k when a required clock is not initialized, it is important
to notify the user when a specified clock is ignored.

Signed-off-by: Josua Mayer <josua@solid-run.com>
---
 drivers/net/ethernet/marvell/mvmdio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvmdio.c b/drivers/net/ethernet/marvell/mvmdio.c
index e17d563e97a6..89a99bf8e87b 100644
--- a/drivers/net/ethernet/marvell/mvmdio.c
+++ b/drivers/net/ethernet/marvell/mvmdio.c
@@ -326,6 +326,10 @@ static int orion_mdio_probe(struct platform_device *pdev)
 		clk_prepare_enable(dev->clk[i]);
 	}
 
+	if (!IS_ERR(of_clk_get(pdev->dev.of_node, i)))
+		dev_warn(dev, "unsupported number of clocks, limiting to the first "
+			 __stringify(ARRAY_SIZE(dev->clk)) "\n");
+
 	dev->err_interrupt = platform_get_irq(pdev, 0);
 	if (dev->err_interrupt > 0 &&
 	    resource_size(r) < MVMDIO_ERR_INT_MASK + 4) {
-- 
2.16.4

