Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56C10180E14
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 03:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727967AbgCKClf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 22:41:35 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:60168 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727648AbgCKClf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 22:41:35 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id B39AF8365A;
        Wed, 11 Mar 2020 15:41:32 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1583894492;
        bh=9uLth0Wy0j14fkveY2T4IR24UQOJ9+lVCUAP80s/zxs=;
        h=From:To:Cc:Subject:Date;
        b=QsTr1CwAQjraDtcGOKvcp0HvLJyo4yygweM0g9qw7mgsnc9KEqbxKOwcjFhxTC1jt
         K4GzXZF2Tr8b2qo+V9xJ2hbHoWTH4QRaoyFCmptrW6zN7n4xnPgz4/kR3QYdxa9Yei
         SWej/06vF6AS6TFfdJlZCjrbrWgvf/NXUdQWIiFLTAD332d0xG3pN6zE6Cz8HPV+Pv
         NY5bhmvcqBY5ofiIaJfaET8yWVqikXFfdAirNGaC/zXLFqXr2c7zB6TCeCdrJBXOec
         UNCeZfI+DEXv7lDOENgYD4iyE0QSKcwp2UZPrMsT0U0rExrKSIuTML8foXgZnNF6rO
         DRqFuH800aR8w==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5e684fdd0000>; Wed, 11 Mar 2020 15:41:33 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.20])
        by smtp (Postfix) with ESMTP id 5BB0913EED5;
        Wed, 11 Mar 2020 15:41:31 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 6DEAE28006C; Wed, 11 Mar 2020 15:41:32 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     davem@davemloft.net, andrew@lunn.ch, josua@solid-run.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH] net: mvmdio: avoid error message for optional IRQ
Date:   Wed, 11 Mar 2020 15:41:30 +1300
Message-Id: <20200311024131.1289-1-chris.packham@alliedtelesis.co.nz>
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
---
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

