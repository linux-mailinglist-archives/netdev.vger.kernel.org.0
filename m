Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B8D3241EA
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 17:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234359AbhBXQPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 11:15:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235630AbhBXQMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 11:12:36 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C77C06174A
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 08:11:51 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id x16so2250042wmk.3
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 08:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=scd7o+CtzdiCz3fZdMjfv9qClZABBNpPAwzVZ6vjA30=;
        b=ZonJuRpjtE7/llSDOR6UrD2lnUs+bpKXxFCZDwyM7w2vI6fY98DLqDG/U74mastkNq
         Rmrh9NQJ/5BYw4rR8aR+fvI5w0bBdoGkH/Waky8xYoeZbaIoXDsO0o2DZLKwNrQ63nzM
         iuTrwDbA3zFRkEjVXQ2wx7n3sRdyLGh7+MlVvWLG8q5hLAFfjxr6TTbNuS5m/KS8rerM
         3kUvH7pvjeIv5ofVW8DUOss3fI+jk5Cv0vnjcVFq9flaaQMf4o5x+kH7GWXOqMuB2Q7X
         RQx1JiZ2FvxV3DmfQFx4aXGjO4NaWM8teiMeVfeet6McMcoW9IM9yx+Y7hy98ipcfey8
         M+vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=scd7o+CtzdiCz3fZdMjfv9qClZABBNpPAwzVZ6vjA30=;
        b=m/wxWQJ59gVDCnkvh+9KnoNdDp8nOxspfRJ+zrGAHpK5kBD0IFbf/uxTsU+BN0nKZU
         s6rA3Efn/5a7vWlshPVi7Y1dgCMIJnDoSPrmG8h2c8OhGnCC1onBCDGcYJ+Irw5pFVpS
         sM5kztSOR5Dfpf8HIofu49e0sgjdvJY8EW7wkU8i1K1uDeyDK5iGhBJBONIC7vdLKv7G
         fXCBMk3fU5lyJJmNUQqcW8dNTZ/WHtgBCHrcJV201f9BE0aq77MEZp71+bFtioQrBWFx
         BGYzLDzbSiEd107rVBwsmVVmV86QD1ApIE1OZm77WQ7mU+oo6+bMCwvQ0I8CZsBWZoO9
         iazA==
X-Gm-Message-State: AOAM531d2XAybcbbobIZiLA2G++UlXjgSgBmA9+PAibem+OH+MO6yvUJ
        s//7B0G8c1Va8fDB20Zt5v/Pd356YWg1Xw==
X-Google-Smtp-Source: ABdhPJw16hNgu6zIwm2NKZ9vV+sEgtZ+T9erYlGYznnK2hS5iO4ChgNPsIARybklyjz2nEKiYi8mTQ==
X-Received: by 2002:a05:600c:2298:: with SMTP id 24mr4534609wmf.136.1614183110432;
        Wed, 24 Feb 2021 08:11:50 -0800 (PST)
Received: from tool.localnet ([213.177.198.100])
        by smtp.gmail.com with ESMTPSA id f8sm3729737wml.20.2021.02.24.08.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 08:11:49 -0800 (PST)
From:   Daniel =?ISO-8859-1?Q?Gonz=E1lez?= Cabanelas <dgcbueu@gmail.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, noltari@gmail.com
Subject: [PATCH v3] bcm63xx_enet: fix internal phy IRQ assignment
Date:   Wed, 24 Feb 2021 17:11:33 +0100
Message-ID: <2190629.1yaby32tsi@tool>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
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
changes in V3:=20
  - snippet moved after the mdiobus err check
  - snippet moved after the mdiobus registration
  - added missing brackets

 drivers/net/ethernet/broadcom/bcm63xx_enet.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/eth=
ernet/broadcom/bcm63xx_enet.c
index fd876721316..22c782ed76a 100644
=2D-- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -1818,14 +1818,22 @@ static int bcm_enet_probe(struct platform_device *p=
dev)
 		 * if a slave is not present on hw */
 		bus->phy_mask =3D ~(1 << priv->phy_id);
=20
=2D		if (priv->has_phy_interrupt)
=2D			bus->irq[priv->phy_id] =3D priv->phy_interrupt;
=2D
 		ret =3D mdiobus_register(bus);
 		if (ret) {
 			dev_err(&pdev->dev, "unable to register mdio bus\n");
 			goto out_free_mdio;
 		}
+
+		if (priv->has_phy_interrupt) {
+			phydev =3D mdiobus_get_phy(bus, priv->phy_id);
+			if (!phydev) {
+				dev_err(&dev->dev, "no PHY found\n");
+				goto out_unregister_mdio;
+			}
+
+			bus->irq[priv->phy_id] =3D priv->phy_interrupt;
+			phydev->irq =3D priv->phy_interrupt;
+		}
 	} else {
=20
 		/* run platform code to initialize PHY device */
=2D-=20
2.30.1




