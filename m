Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB7881865E5
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 08:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729992AbgCPHtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 03:49:16 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:39902 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729973AbgCPHtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 03:49:16 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 8E883891AD;
        Mon, 16 Mar 2020 20:49:14 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1584344954;
        bh=344D7td7yNvnB50ZDS+yKPulTKNSqIhTM+BaA7i6798=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=cOeLwTWzpRaajwv1Rl+IKPUA5rLVOaJyIaPq1pSRtyrcC6vQzQZIa1IcrXDk8Cs53
         TpchUikp5GpF+rm4QMeqG8Mje0fUfESC3PZFloDJaOHzDJNBjx8/1jkul0IrhJ5Ard
         1Iqah+7xA0QSho/wdgxVzC153GVon3lOWl8wdgk+ZFeUFHzOzTT4BtBResvTY3ADi7
         Jian13FqAmOnXpsulR9UHZ4Cy1rYkCZtaRyD58tPHMwk2sxcsKdFzo99G0EgTdoa8Z
         e2uPZcd4REd7rJKJ3U/X7skhQETMYNaVsuevRsC8DqhxEevjdN+hk+M4wVxy2iYanS
         xK7CSYoEQ2AQg==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5e6f2f750001>; Mon, 16 Mar 2020 20:49:14 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.20])
        by smtp (Postfix) with ESMTP id 0C69513EF9B;
        Mon, 16 Mar 2020 20:49:09 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 60CA828006E; Mon, 16 Mar 2020 20:49:09 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     davem@davemloft.net, andrew@lunn.ch, josua@solid-run.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH v3 1/2] Revert "net: mvmdio: avoid error message for optional IRQ"
Date:   Mon, 16 Mar 2020 20:49:06 +1300
Message-Id: <20200316074907.21879-2-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200316074907.21879-1-chris.packham@alliedtelesis.co.nz>
References: <20200316074907.21879-1-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit e1f550dc44a4d535da4e25ada1b0eaf8f3417929.
platform_get_irq_optional() will still return -ENXIO when no interrupt
is provided so the additional error handling caused the driver prone to
fail when no interrupt was specified. Revert the change so we can apply
the correct minimal fix.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---
 drivers/net/ethernet/marvell/mvmdio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvmdio.c b/drivers/net/ethernet=
/marvell/mvmdio.c
index d2e2dc538428..0b9e851f3da4 100644
--- a/drivers/net/ethernet/marvell/mvmdio.c
+++ b/drivers/net/ethernet/marvell/mvmdio.c
@@ -347,7 +347,7 @@ static int orion_mdio_probe(struct platform_device *p=
dev)
 	}
=20
=20
-	dev->err_interrupt =3D platform_get_irq_optional(pdev, 0);
+	dev->err_interrupt =3D platform_get_irq(pdev, 0);
 	if (dev->err_interrupt > 0 &&
 	    resource_size(r) < MVMDIO_ERR_INT_MASK + 4) {
 		dev_err(&pdev->dev,
@@ -364,8 +364,8 @@ static int orion_mdio_probe(struct platform_device *p=
dev)
 		writel(MVMDIO_ERR_INT_SMI_DONE,
 			dev->regs + MVMDIO_ERR_INT_MASK);
=20
-	} else if (dev->err_interrupt < 0) {
-		ret =3D dev->err_interrupt;
+	} else if (dev->err_interrupt =3D=3D -EPROBE_DEFER) {
+		ret =3D -EPROBE_DEFER;
 		goto out_mdio;
 	}
=20
--=20
2.25.1

