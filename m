Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0353F18231A
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 21:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731241AbgCKUFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 16:05:53 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:33172 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730960AbgCKUFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 16:05:53 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 1F815891AE;
        Thu, 12 Mar 2020 09:05:51 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1583957151;
        bh=uTFPuggRCHvi5DImcHCu3FYQUMyH3o+lq3v6bIA18Qs=;
        h=From:To:Cc:Subject:Date;
        b=nkyMc3zrMU6gsHPNQSuVh889rxdhpJJjI116tVwIXULzmb/WtJp9iUu3HPY8vAnph
         rtJwlqRjQPxUmFEitlAQN+iWO6Bivy28sR37vRKMBXOsySOZ7CDQHwiFcdEYB3lsTs
         9v7658Iny6KCrDv5Gmh/s3AYj8AB/RAtmAiA1WcXFGptlFxD8tWYZAh1P33eRZQTpc
         Y95YZRK23NcRDezg0CqOZsI6O/wp/k/kx4L+VxGOzHoy3i4Skt/9L3vwLaIJagsYWe
         o0xB17nr79Bl5aEyjV4cy7nGrCCWMp7YmpFLFYvemfry1ysndW10AvOLEk6xZbZ4jx
         FXY1DgDACPZHg==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5e69449d0000>; Thu, 12 Mar 2020 09:05:49 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.20])
        by smtp (Postfix) with ESMTP id B788913EEB7;
        Thu, 12 Mar 2020 09:05:50 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id CB94B28006C; Thu, 12 Mar 2020 09:05:50 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     davem@davemloft.net, andrew@lunn.ch, josua@solid-run.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH v2] net: mvmdio: avoid error message for optional IRQ
Date:   Thu, 12 Mar 2020 09:05:46 +1300
Message-Id: <20200311200546.9936-1-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Per the dt-binding the interrupt is optional so use
platform_get_irq_optional() instead of platform_get_irq(). Since
commit 7723f4c5ecdb ("driver core: platform: Add an error message to
platform_get_irq*()") platform_get_irq() produces an error message

  orion-mdio f1072004.mdio: IRQ index 0 not found

which is perfectly normal if one hasn't specified the optional property
in the device tree.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---

Notes:
    Changes in v2:
    - Add review from Andrew
    - Clean up error handling case

 drivers/net/ethernet/marvell/mvmdio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvmdio.c b/drivers/net/ethernet=
/marvell/mvmdio.c
index 0b9e851f3da4..d2e2dc538428 100644
--- a/drivers/net/ethernet/marvell/mvmdio.c
+++ b/drivers/net/ethernet/marvell/mvmdio.c
@@ -347,7 +347,7 @@ static int orion_mdio_probe(struct platform_device *p=
dev)
 	}
=20
=20
-	dev->err_interrupt =3D platform_get_irq(pdev, 0);
+	dev->err_interrupt =3D platform_get_irq_optional(pdev, 0);
 	if (dev->err_interrupt > 0 &&
 	    resource_size(r) < MVMDIO_ERR_INT_MASK + 4) {
 		dev_err(&pdev->dev,
@@ -364,8 +364,8 @@ static int orion_mdio_probe(struct platform_device *p=
dev)
 		writel(MVMDIO_ERR_INT_SMI_DONE,
 			dev->regs + MVMDIO_ERR_INT_MASK);
=20
-	} else if (dev->err_interrupt =3D=3D -EPROBE_DEFER) {
-		ret =3D -EPROBE_DEFER;
+	} else if (dev->err_interrupt < 0) {
+		ret =3D dev->err_interrupt;
 		goto out_mdio;
 	}
=20
--=20
2.25.1

