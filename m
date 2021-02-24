Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E075324197
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 17:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234536AbhBXQCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 11:02:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236000AbhBXPpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 10:45:12 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01E9C061793
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 07:44:28 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id 7so2345270wrz.0
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 07:44:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rGsiWH1BdrantaUO7fftm0n1XKcEAK+j/IdSsSV+6XI=;
        b=ucm+uA3rdofBu5dmHS8gWUBpi+lRoamf0XSiaSOQ+ttmwkzv2fSifHdqj4ce1cgPVO
         Jza2fYg8Y3yyD0X6F0Klu80F93Fo8NH7XTMj6up2BrjrzSMLLYB2TAfbtbS80EKqt8Cm
         C6/G5y8OuQZOnfY4H5dgUQAaignvjt8SKToTG0vlsYbqDQqR4WPgvRaOf4tcaZb8cT48
         JOKkHl5bDzgA4oeaLTIdzVPw1mmO9n9xhezZbCN/M1gaXHVJXAkWKserS5FpQZFyEH8T
         Pu6qJazM66b94CkleTuHCXsoB2gByWtenP3zVCdKDQpeke3v+zxqudp6MwYTR1sTJbiz
         PJsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rGsiWH1BdrantaUO7fftm0n1XKcEAK+j/IdSsSV+6XI=;
        b=CACmVcXLKOQjNF1Nbfs1Rm5Kc1vUPMBqk7W9LTZ0cGnrssJ0q0X6r59KNTlSQ57VAs
         GbLGL9FA2D4y3IXupIYutRwdCZ1fyP66ereOCTamckX4LSB7fsV5UOVPNG87AqO+eSoM
         YJxjAqrJMYcbYnBXfmu8efyRHvfNK+vqgzW0xL47foK0GmMLzxmO4U1FsBDaOsUxqZIW
         OzAW7vckm+yEu+yth7kIWUbmeSg48EXKV3L2YxiK/EUzLv7GIMVX1Gaz56URHsQWqmHz
         0Qa1pENYf3np+1YbpLGIzfnu7m6wOxScf8pc1uMKxEP/CgGSW2z7iR0Fen9rC+YHpcMi
         uSQQ==
X-Gm-Message-State: AOAM53084AG3KQyXxzivzBzkQ7nMtTvoLedPe1ct3W2RYhWcSXC1dxT5
        Vo4qQgR9FER0cl120QCH4hA=
X-Google-Smtp-Source: ABdhPJyeJfhVzN562hGd/HC/j+roU7wxr08qRnpeMVafBxgfGmGBSroWmIZaLfon+VKOS+aDoJuAow==
X-Received: by 2002:adf:f14d:: with SMTP id y13mr23781922wro.75.1614181467604;
        Wed, 24 Feb 2021 07:44:27 -0800 (PST)
Received: from tool.localnet ([213.177.198.100])
        by smtp.gmail.com with ESMTPSA id 4sm6004929wrr.27.2021.02.24.07.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 07:44:27 -0800 (PST)
From:   Daniel =?ISO-8859-1?Q?Gonz=E1lez?= Cabanelas <dgcbueu@gmail.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, noltari@gmail.com
Subject: [PATCH v2] bcm63xx_enet: fix internal phy IRQ assignment
Date:   Wed, 24 Feb 2021 16:44:18 +0100
Message-ID: <2323124.5UR7tLNZLG@tool>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current bcm63xx_enet driver doesn't asign the internal phy IRQ. As a
result of this it works in polling mode.

=46ix it using the phy_device structure to assign the platform IRQ.

Tested under a BCM6348 board. Kernel dmesg before the patch:
   Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY driver [Broadcom
              BCM63XX (1)] (mii_bus:phy_addr=3Dbcm63xx_enet-0:01, irq=3DPOL=
L)

After the patch:
   Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY driver [Broadcom
              BCM63XX (1)] (mii_bus:phy_addr=3Dbcm63xx_enet-0:01, irq=3D17)

Pluging and uplugging the ethernet cable now generates interrupts and the
PHY goes up and down as expected.

Signed-off-by: Daniel Gonz=C3=A1lez Cabanelas <dgcbueu@gmail.com>
=2D--
changes in V2:=20
  - snippet moved after the mdiobus registration
  - added missing brackets

 drivers/net/ethernet/broadcom/bcm63xx_enet.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/eth=
ernet/broadcom/bcm63xx_enet.c
index fd876721316..dd218722560 100644
=2D-- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -1818,10 +1818,19 @@ static int bcm_enet_probe(struct platform_device *p=
dev)
 		 * if a slave is not present on hw */
 		bus->phy_mask =3D ~(1 << priv->phy_id);
=20
=2D		if (priv->has_phy_interrupt)
+		ret =3D mdiobus_register(bus);
+
+		if (priv->has_phy_interrupt) {
+			phydev =3D mdiobus_get_phy(bus, priv->phy_id);
+			if (!phydev) {
+				dev_err(&dev->dev, "no PHY found\n");
+				goto out_unregister_mdio;
+			}
+
 			bus->irq[priv->phy_id] =3D priv->phy_interrupt;
+			phydev->irq =3D priv->phy_interrupt;
+		}
=20
=2D		ret =3D mdiobus_register(bus);
 		if (ret) {
 			dev_err(&pdev->dev, "unable to register mdio bus\n");
 			goto out_free_mdio;
=2D-=20
2.30.1




