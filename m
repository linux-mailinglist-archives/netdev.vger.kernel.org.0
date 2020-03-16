Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D044F1865E1
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 08:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730051AbgCPHtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 03:49:17 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:39905 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729962AbgCPHtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 03:49:17 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id AA242891AE;
        Mon, 16 Mar 2020 20:49:14 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1584344954;
        bh=lueV+3/ieVHX0j1GQCzwiOIpCw7+gr2T4FpZqjS6B2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=HycmfWNg2/Q+8Ek/8KDldYNUcMAEcs8cBuxd/YQ9WlGn1QxlvkwR3cPnh+lyQxL3L
         c8UVa2+9Ko+TlhayaFRsmZRlGEK4JIv+TZ61+aKGM8z4KfmBHlye6Ehd95Cc29I7RX
         ZIvhXC04W7jbSoThi4eTR2TnvcklVTGiRsnyPmlsmSJCzitng0byif77U+N32h9GW4
         U2VEzeex9xdjQWEF4sLrgwqhpW6uRRK9vTLIUhJ6cPSEpc1x/OWZ6up0oeJT8OR50I
         hHTm3LfNmGdd9SWc8Pf5dnDZdfZhPf8pNlLfVsdoER+s+2AYGnnv5MRmf4IyW3mAq7
         IN9AOWFWmShrA==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5e6f2f750002>; Mon, 16 Mar 2020 20:49:14 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.20])
        by smtp (Postfix) with ESMTP id 2D02813EF9C;
        Mon, 16 Mar 2020 20:49:09 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 813F428006E; Mon, 16 Mar 2020 20:49:09 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     davem@davemloft.net, andrew@lunn.ch, josua@solid-run.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH v3 2/2] net: mvmdio: avoid error message for optional IRQ
Date:   Mon, 16 Mar 2020 20:49:07 +1300
Message-Id: <20200316074907.21879-3-chris.packham@alliedtelesis.co.nz>
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
    Changes in v3:
    - return to minimal fix
   =20
    Changes in v2:
    - Add review from Andrew
    - Clean up error handling case

 drivers/net/ethernet/marvell/mvmdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvmdio.c b/drivers/net/ethernet=
/marvell/mvmdio.c
index 0b9e851f3da4..d14762d93640 100644
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
--=20
2.25.1

