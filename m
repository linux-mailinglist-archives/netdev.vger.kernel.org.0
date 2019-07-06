Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00E18611DF
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 17:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfGFPbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 11:31:10 -0400
Received: from mo4-p05-ob.smtp.rzone.de ([85.215.255.131]:25374 "EHLO
        mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbfGFPbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 11:31:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1562427069;
        s=strato-dkim-0002; d=jm0.eu;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=TDT9sxXhvLoNnEX3mNdqO9PUoFgyTAhRMUVAZRcGM7A=;
        b=MI1QETPSMx0oT9ueQJp+8Y9G67ZnUfdo5GB86BHY4OqTGCWRtFOjX+q2JObMmUi/dE
        cxAvg4PqxcDK+U7f+tHp8LrP+eAhy4DDO2wT7CYrOvcCdglHS6MGpHqP2e5cHNUh03cC
        RP4DquuSdHJpm6wZ043a+OTSR61HKtBYPR/rJZHbYyLn3cVXwRxkLT28dNd4YohYNvhL
        KNq+tKAGFRWNBPK2icvyMS/UPV7rfv8FhCkJbbZCDr8DE/oQBAOumhA9v8uO9jW7W3NX
        12tJIAECbUro51Lbo5oFvKGacmvC2Aw6nob4/cc+Yebwo+KH4GuIkB4p0Ba33Jrdc+OJ
        TjMw==
X-RZG-AUTH: ":JmMXYEHmdv4HaV2cbPh7iS0wbr/uKIfGM0EPWe8EZQbw/dDJ/fVPBaXaSiaF5/mu26zWKwNU"
X-RZG-CLASS-ID: mo05
Received: from linux-1tvp.lan
        by smtp.strato.de (RZmta 44.24 DYNA|AUTH)
        with ESMTPSA id h0a328v66FJF6MY
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Sat, 6 Jul 2019 17:19:15 +0200 (CEST)
From:   josua@solid-run.com
To:     netdev@vger.kernel.org
Cc:     Josua Mayer <josua@solid-run.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4/4] net: mvmdio: defer probe of orion-mdio if a clock is not ready
Date:   Sat,  6 Jul 2019 17:19:00 +0200
Message-Id: <20190706151900.14355-5-josua@solid-run.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190706151900.14355-1-josua@solid-run.com>
References: <20190706151900.14355-1-josua@solid-run.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Josua Mayer <josua@solid-run.com>

Defer probing of the orion-mdio interface when enabling of either of the
clocks defer probing. This avoids locking up the Armada 8k SoC when mdio
is used before all clocks have been enabled.

Signed-off-by: Josua Mayer <josua@solid-run.com>
---
 drivers/net/ethernet/marvell/mvmdio.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvmdio.c b/drivers/net/ethernet/marvell/mvmdio.c
index 89a99bf8e87b..1034013426ad 100644
--- a/drivers/net/ethernet/marvell/mvmdio.c
+++ b/drivers/net/ethernet/marvell/mvmdio.c
@@ -321,6 +321,10 @@ static int orion_mdio_probe(struct platform_device *pdev)
 
 	for (i = 0; i < ARRAY_SIZE(dev->clk); i++) {
 		dev->clk[i] = of_clk_get(pdev->dev.of_node, i);
+		if (dev->clk[i] == PTR_ERR(-EPROBE_DEFER)) {
+			ret = -EPROBE_DEFER;
+			goto out_clk;
+		}
 		if (IS_ERR(dev->clk[i]))
 			break;
 		clk_prepare_enable(dev->clk[i]);
@@ -366,6 +370,7 @@ static int orion_mdio_probe(struct platform_device *pdev)
 	if (dev->err_interrupt > 0)
 		writel(0, dev->regs + MVMDIO_ERR_INT_MASK);
 
+out_clk:
 	for (i = 0; i < ARRAY_SIZE(dev->clk); i++) {
 		if (IS_ERR(dev->clk[i]))
 			break;
-- 
2.16.4

