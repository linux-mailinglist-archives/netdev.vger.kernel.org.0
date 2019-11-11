Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B594FF808A
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 20:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbfKKTvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 14:51:35 -0500
Received: from mout.gmx.net ([212.227.15.19]:57699 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727089AbfKKTvf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 14:51:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1573501792;
        bh=bICAAjpNAEuBSsYFkawJc3wNJyV0/DEeTRhpBN4urFs=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=UO4QAIV8lH819LcEEu58MxoPYk87X82RVJjLK6NhxkolwitqQRbTzGlXVKQoDSx4A
         p+kgdMDS0zY91xMOioSRYyXLOKtjVv9au/wab0OHP2xudnoUUDPB2VVtcprFFUacc7
         96QxGGqFCCudzSHxSERqJ+e7Fd5V5P4OvrA0Znak=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.112]) by mail.gmx.com
 (mrgmx004 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MOzOw-1iG04a2dS8-00PJjG; Mon, 11 Nov 2019 20:49:52 +0100
From:   Stefan Wahren <wahrenst@gmx.net>
To:     Matthias Brugger <matthias.bgg@kernel.org>,
        Matthias Brugger <mbrugger@suse.com>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Eric Anholt <eric@anholt.net>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Doug Berger <opendmb@gmail.com>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH V5 net-next 5/7] net: bcmgenet: Refactor register access in bcmgenet_mii_config
Date:   Mon, 11 Nov 2019 20:49:24 +0100
Message-Id: <1573501766-21154-6-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573501766-21154-1-git-send-email-wahrenst@gmx.net>
References: <1573501766-21154-1-git-send-email-wahrenst@gmx.net>
X-Provags-ID: V03:K1:67YahmV2UkJIhpHobumqC9+/MmwXxDEYxBSTwbAoxBBAioCr3qM
 x8P7GK2b0x11RhkhkXnUCTYXYQgqYSCL0ZTxyIsKplgJgvJydv6Sdk7dLd0vS8YOgUZApHB
 kx8TxDsq9eQdNCrDjQ9N0zquYurAi8kxkxRzsvmDgKcH2/XFLc/ZA5B9mirNh1G0pRYUhl3
 ydAHEBhDR4HMC6kkGgyJg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:W7YAxsxgv4Y=:3Op2RchXtPvRo9E/XH58Cu
 L5jrJwgCEOXkNHOkQ2oPGcnNMCuaof/dLnnVvwo5u38KFDPyjb5rum2ofGp+pf98zzQINv1e/
 0bdZHifTM1pwMZu0v5nkZs+aOgdOkcrIZ0Ova/AG8A54LceioWC7y+xs5n+irXZJVrATkdi4w
 85TElykn7yUlX8gPYYPwtj6cutfD+wXAObSK53XjHc6Y6GlvZMWwWFWqtozzuqojDQUFnQqhG
 q5FI4rvfeAmeDeXgVaOQllhS6RvFLMv1M55VvlUKBEieOqx9sh8v3iZdmz40kM5hC+80Ongca
 /7zyyHrXnGRS6ym5faTXSckifoubxMM3yTOm6eK/4x/CNHLqVJnhgJaoCJofPeBSMgjH9+hpb
 Rk/k2mp0BXiRSwabn88AczMLWLkQca3Gmgq9kEwiEJ65vZwAOUzAw0nDqTzqtxwvn4Z+HH2Bk
 nQnttcRVnwHTLbISdTn5XZgiEglii4RWGWxLMwGNjf3N7WNvqGsJ7qAUpjpovKm7J8Ek8Mi6/
 NCUCem+7cni7MrhPq60hvdnUstlINdl9n+RhATeCAt304imSdzd4WxiaV7+YudsaeWSJ6P3G3
 niGXsIpjsEdiQAdf72LV5uGxlv74Vawgz9hC6dQBgB8NtNUKCKKk3z3IMeEKBEZ6dHXciDjgJ
 Ofvu2I4B4Iz2W8DdfsN18cCSA3pZShP1hNZzWDz7Vt43RCbeeTlatVLuuPU6CkN/EcsElhueg
 DU8mfSxmf5gTM5xzu2TRA0RaScO1bcoLP2qJytgEj96OQ3rz0R4S7cJx8vzx74qMJEGm5OuIJ
 rourPKi8zMqEnYQcQUB1uOvmLAlUymTWvlQ1001y1eaEjT3t7NVLLmYq/DkXjvEsGrNNoBuF4
 TQEueCesSjJm8Mh2zcGB0JfawtgmpdT+kE9zx3+sWAf10kDQdg9MaASrOTzmhNd7/OLOZ8PsE
 XX5KS9UnUkjCfFCf7ihIldPRHuBA0y1PtXe4P1+HAqTqkuFvXzbIglJiYVaxoLXpGjSACEe93
 JXGBwXELqXz0lxMxr9LAbcV1V4z0hfHdTPasGT77ebrPm4pEqysCYzn6L+yVy+83bQx0I/Kef
 GEY/phLJEKaleERFeg56JVVFTFfDg83AyS+M/z4ZZP+xD/kICJJw8+qhQvGh35E5Ltz8qtOT0
 AhC9UhV3LMFyQa1ETWPiY/X576nG/HK81/9pYI1AXeYetYyvlW/8CUpiD5MI1vUWLzZmzB8it
 V7UtmSyCtr00cQTLrdkATzvdZw+x0AL+6YVaEgg==
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The register access in bcmgenet_mii_config() is a little bit opaque and
not easy to extend. In preparation for the missing RGMII PHY modes
move all the phy name assignments into the switch statement and the
register access to the end of the function. This make the code easier
to read and extend.

Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
=2D--
 drivers/net/ethernet/broadcom/genet/bcmmii.c | 42 +++++++++++++----------=
-----
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/et=
hernet/broadcom/genet/bcmmii.c
index 6f291ee..021ce9e 100644
=2D-- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -213,11 +213,10 @@ int bcmgenet_mii_config(struct net_device *dev, bool=
 init)
 		udelay(2);
 	}

-	priv->ext_phy =3D !priv->internal_phy &&
-			(priv->phy_interface !=3D PHY_INTERFACE_MODE_MOCA);
-
 	switch (priv->phy_interface) {
 	case PHY_INTERFACE_MODE_INTERNAL:
+		phy_name =3D "internal PHY";
+		/* fall through */
 	case PHY_INTERFACE_MODE_MOCA:
 		/* Irrespective of the actually configured PHY speed (100 or
 		 * 1000) GENETv4 only has an internal GPHY so we will just end
@@ -229,11 +228,7 @@ int bcmgenet_mii_config(struct net_device *dev, bool =
init)
 		else
 			port_ctrl =3D PORT_MODE_INT_EPHY;

-		bcmgenet_sys_writel(priv, port_ctrl, SYS_PORT_CTRL);
-
-		if (priv->internal_phy) {
-			phy_name =3D "internal PHY";
-		} else if (priv->phy_interface =3D=3D PHY_INTERFACE_MODE_MOCA) {
+		if (!phy_name) {
 			phy_name =3D "MoCA";
 			bcmgenet_moca_phy_setup(priv);
 		}
@@ -242,11 +237,7 @@ int bcmgenet_mii_config(struct net_device *dev, bool =
init)
 	case PHY_INTERFACE_MODE_MII:
 		phy_name =3D "external MII";
 		phy_set_max_speed(phydev, SPEED_100);
-		bcmgenet_sys_writel(priv,
-				    PORT_MODE_EXT_EPHY, SYS_PORT_CTRL);
-		/* Restore the MII PHY after isolation */
-		if (bmcr >=3D 0)
-			phy_write(phydev, MII_BMCR, bmcr);
+		port_ctrl =3D PORT_MODE_EXT_EPHY;
 		break;

 	case PHY_INTERFACE_MODE_REVMII:
@@ -261,31 +252,38 @@ int bcmgenet_mii_config(struct net_device *dev, bool=
 init)
 			port_ctrl =3D PORT_MODE_EXT_RVMII_50;
 		else
 			port_ctrl =3D PORT_MODE_EXT_RVMII_25;
-		bcmgenet_sys_writel(priv, port_ctrl, SYS_PORT_CTRL);
 		break;

 	case PHY_INTERFACE_MODE_RGMII:
 		/* RGMII_NO_ID: TXC transitions at the same time as TXD
 		 *		(requires PCB or receiver-side delay)
-		 * RGMII:	Add 2ns delay on TXC (90 degree shift)
 		 *
 		 * ID is implicitly disabled for 100Mbps (RG)MII operation.
 		 */
+		phy_name =3D "external RGMII (no delay)";
 		id_mode_dis =3D BIT(16);
-		/* fall through */
+		port_ctrl =3D PORT_MODE_EXT_GPHY;
+		break;
+
 	case PHY_INTERFACE_MODE_RGMII_TXID:
-		if (id_mode_dis)
-			phy_name =3D "external RGMII (no delay)";
-		else
-			phy_name =3D "external RGMII (TX delay)";
-		bcmgenet_sys_writel(priv,
-				    PORT_MODE_EXT_GPHY, SYS_PORT_CTRL);
+		/* RGMII_TXID:	Add 2ns delay on TXC (90 degree shift) */
+		phy_name =3D "external RGMII (TX delay)";
+		port_ctrl =3D PORT_MODE_EXT_GPHY;
 		break;
 	default:
 		dev_err(kdev, "unknown phy mode: %d\n", priv->phy_interface);
 		return -EINVAL;
 	}

+	bcmgenet_sys_writel(priv, port_ctrl, SYS_PORT_CTRL);
+
+	/* Restore the MII PHY after isolation */
+	if (bmcr >=3D 0)
+		phy_write(phydev, MII_BMCR, bmcr);
+
+	priv->ext_phy =3D !priv->internal_phy &&
+			(priv->phy_interface !=3D PHY_INTERFACE_MODE_MOCA);
+
 	/* This is an external PHY (xMII), so we need to enable the RGMII
 	 * block for the interface to work
 	 */
=2D-
2.7.4

