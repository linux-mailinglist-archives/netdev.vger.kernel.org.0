Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C100C63655
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 15:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfGINBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 09:01:31 -0400
Received: from mo4-p05-ob.smtp.rzone.de ([85.215.255.136]:31948 "EHLO
        mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfGINBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 09:01:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1562677289;
        s=strato-dkim-0002; d=jm0.eu;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=GR2lBsD5lAok3EXgvRS1ODMHti6feSce0h4ZmY6o/iw=;
        b=dYCDqLrVRo/229WrRqmfvEggTFbCCnGSIB8FZCbpOqPVmRWGclg8yyavSHmxZ0ucys
        cEXil8qenGAjaqaJ4u/2RC8Ydgj1jnV+V/1wwiw2E0WzNarpmbBJJPVg5DZI1czZPKYi
        dvm999PvbS+pfxeUJ4AAoBnK5pVpYlKjQOe8SfiZrzzxJwNJz0S5NUxbGuBgzi+9T1kQ
        5Z9PGsL52RHNzEGFb1bForVtS/OCQg64/A9pbq41REMJpKW+0A95VL5u5dll3Y523uxK
        ch7ILrEcGJZjDVOaMe0sJEaWeTXxXN4XbVZ+8Ye1s4cRsqREEJDrc6Yg1mrX0qNfPugC
        BhRg==
X-RZG-AUTH: ":JmMXYEHmdv4HaV2cbPh7iS0wbr/uKIfGM0EPWe8EZQbw/dDJ/fVPBaXaSiaF5/mu26zWKwNU"
X-RZG-CLASS-ID: mo05
Received: from linux-1tvp.lan
        by smtp.strato.de (RZmta 44.24 DYNA|AUTH)
        with ESMTPSA id h0a328v69D1QEgC
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Tue, 9 Jul 2019 15:01:26 +0200 (CEST)
From:   josua@solid-run.com
To:     netdev@vger.kernel.org
Cc:     Josua Mayer <josua@solid-run.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2 4/4] net: mvmdio: defer probe of orion-mdio if a clock is not ready
Date:   Tue,  9 Jul 2019 15:01:01 +0200
Message-Id: <20190709130101.5160-5-josua@solid-run.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190709130101.5160-1-josua@solid-run.com>
References: <20190706151900.14355-1-josua@solid-run.com>
 <20190709130101.5160-1-josua@solid-run.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Josua Mayer <josua@solid-run.com>

Defer probing of the orion-mdio interface when getting a clock returns
EPROBE_DEFER. This avoids locking up the Armada 8k SoC when mdio is used
before all clocks have been enabled.

Signed-off-by: Josua Mayer <josua@solid-run.com>
---
 drivers/net/ethernet/marvell/mvmdio.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvmdio.c b/drivers/net/ethernet/marvell/mvmdio.c
index eba18065a4da..f660cc2b8258 100644
--- a/drivers/net/ethernet/marvell/mvmdio.c
+++ b/drivers/net/ethernet/marvell/mvmdio.c
@@ -321,6 +321,10 @@ static int orion_mdio_probe(struct platform_device *pdev)
 
 	for (i = 0; i < ARRAY_SIZE(dev->clk); i++) {
 		dev->clk[i] = of_clk_get(pdev->dev.of_node, i);
+		if (PTR_ERR(dev->clk[i]) == -EPROBE_DEFER) {
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

