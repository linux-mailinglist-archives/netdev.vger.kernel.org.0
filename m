Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74FF4ECED9
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 14:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbfKBNmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 09:42:22 -0400
Received: from mout.gmx.net ([212.227.17.22]:33299 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726430AbfKBNmV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Nov 2019 09:42:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1572702115;
        bh=4tHGKE+e17UnhyLVKq76j3dokNGsfO7qmeQ/3LMCwKE=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=dwAZ8qK2mOEhL8yddYvia54XCp7WcFlWZgnR0N81rrx8bFhvyP/xySjIwrjcC+Lh9
         UJ+Dr7+CieRXtyvxMdWefQX3mXv0nE9wq91rVLa3SFaxAjuq+WgbAA2BOJbw7waCxz
         qMDX48M62lJwn7xVgoOISiU6K+HmC1RRbqVyOSM4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.112]) by mail.gmx.com
 (mrgmx105 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1N6KUT-1htc7u0YED-016h8f; Sat, 02 Nov 2019 14:41:55 +0100
From:   Stefan Wahren <wahrenst@gmx.net>
To:     Matthias Brugger <matthias.bgg@kernel.org>,
        Matthias Brugger <mbrugger@suse.com>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Eric Anholt <eric@anholt.net>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Doug Berger <opendmb@gmail.com>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org,
        Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH RFC V2 4/6] net: bcmgenet: Refactor register access in bcmgenet_mii_config
Date:   Sat,  2 Nov 2019 14:41:31 +0100
Message-Id: <1572702093-18261-5-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1572702093-18261-1-git-send-email-wahrenst@gmx.net>
References: <1572702093-18261-1-git-send-email-wahrenst@gmx.net>
X-Provags-ID: V03:K1:MQ6Jl9aVlitUoMTuabDM7aRAHAZGevUik1OOtVe4QXl8h2C3Skv
 RtAT7SGqOqjvGXxwx+pfP9M3ilaw0Pe1Vga4EWl6/ZgbzVlmNCLBOUI//BYGmiciSOCMG9Z
 IZcdJaAzOY0idsx6XENMTKEych+jdfPLzgTpuqHaK2CVqScikUmH8oGrasuS6+EIlz3rABU
 GEZf8eMfW7rpFIJqX3iRQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:431g0FG5bQA=:QsyJ0NpbJQb8p8jhLLbdAT
 /ECgEMAbmevEoPi4HlUWGStPH62/2B6YvMnHr2o8JdPYqHSM4t12HO9DIP1DGOa+AkU0ZTCD4
 Sa2kfJ5mnOjcClZRpHJaYUcKkjdYwB6zWP8cST9CE9guoWA0vp3hPNTSvAUSVT/cWUw5pyE9G
 0xbnvSdUNSYrrySFqZ+1Zdo0ECi15wVGUX5tQAnb71WLYdtUJIo5vkuyCc6VfA7cYF+FekKqT
 H8NJKHY79vjP+yoCEGoQDmitITHt6wuU07/H9U6VHnnFLyS3VPwgstqvPnhev3IOMbTUjUivm
 m/Gp5yOZSF2VKR4Ws9JzOSHfgCQdK9rBuiRBiEQRANRwUfEyUwYpVGuerVcF86kjutcc2ouE/
 jynj5O+xDnlPUy7VNSUji/Qdfbsmqddwl4zgPSBpB2vlQcX6tCQ42q9NccaiSkZOKTKlbgAlc
 yenfdU5w4xvTalNqRmM5olSfl6+Muxe8W/Iu8NyrhOS3J6eotATL1w2l7SfxlBM801rpmkM8t
 PTKdb9W94jX/VUoNbxVLQ1dXhDV+aUdnqj6fnT/IDrGB18QviXEuFVbMHkqvE6CnNx/HlnXQl
 3BLipo3bG0vP1xrDKgA7iIgDnU/Evt3VDOw5BRBC0L2a9xxt0ip4nATaNKr4kDhRzoa3I6ll9
 QHG08X3xr9ZfMYC/BA0IGKYnMzPOxiDXbPhZuurtk3B4XfXPvZ85UkpDRaxKUIxWWTqWiH81c
 MjG/zB5IroQBIJ4jC5tooeV9P7Z86JTs1cxxIPm0xbE86XK/Wqv+MTx2kKeUXeghJg3tibZU7
 8UDs8ZJW+agIZJRVi6opH0meyIAJevnm/YP44P32SdwSieyMGNVkAhGdv2JSlzSoqP8cFU3Xv
 hAMMZfhJ6JMrevrmn26XQzb4l85/Eo2EAY/7VgSrlDvGXmXO4ok8mdZQrIbXXpC4ECeRtvMIt
 7Dz/FN0oln7Tla7ABdgPI0oeU5cAP9aHPSJ3pVbas7E212Wt4p660i/tf8Xf0VdJQnEnyoFB4
 XRN634olQ05nJBHl44dIK0sITAlU5SvproXdMw+BOQo6Vxu6aK+JRWANdeWuMBWWine8R/SqO
 tyKkpXt944yyOD0TpT3Hmw9p9UmVSKsaPOJl0o0uDrxN8YS5DQ7StRwfSGaGVDjMrf4x4EMbP
 dE2Te/ltfm32kO7HneVxPOXT2YjnkST7u9oO4epg5AN88ppe0YohmIZoIajaQ/Muv9vL6sXz/
 9CNEF36cnQPwr0KtZXsUmC3DAOSz+T5cEyqmTxw==
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The register access in bcmgenet_mii_config() is a little bit opaque and
not easy to extend. In preparation for the missing RGMII PHY modes
move the real register access to the end of the function. This make
the code easier to read and extend.

Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
=2D--
 drivers/net/ethernet/broadcom/genet/bcmmii.c | 41 ++++++++++++-----------=
-----
 1 file changed, 18 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/et=
hernet/broadcom/genet/bcmmii.c
index 17bb8d6..8f7b2c0 100644
=2D-- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -223,9 +223,6 @@ int bcmgenet_mii_config(struct net_device *dev, bool i=
nit)
 	u32 port_ctrl;
 	u32 reg;

-	priv->ext_phy =3D !priv->internal_phy &&
-			(priv->phy_interface !=3D PHY_INTERFACE_MODE_MOCA);
-
 	switch (priv->phy_interface) {
 	case PHY_INTERFACE_MODE_INTERNAL:
 	case PHY_INTERFACE_MODE_MOCA:
@@ -238,22 +235,12 @@ int bcmgenet_mii_config(struct net_device *dev, bool=
 init)
 			port_ctrl =3D PORT_MODE_INT_GPHY;
 		else
 			port_ctrl =3D PORT_MODE_INT_EPHY;
-
-		bcmgenet_sys_writel(priv, port_ctrl, SYS_PORT_CTRL);
-
-		if (priv->internal_phy) {
-			phy_name =3D "internal PHY";
-		} else if (priv->phy_interface =3D=3D PHY_INTERFACE_MODE_MOCA) {
-			phy_name =3D "MoCA";
-			bcmgenet_moca_phy_setup(priv);
-		}
 		break;

 	case PHY_INTERFACE_MODE_MII:
 		phy_name =3D "external MII";
 		phy_set_max_speed(phydev, SPEED_100);
-		bcmgenet_sys_writel(priv,
-				    PORT_MODE_EXT_EPHY, SYS_PORT_CTRL);
+		port_ctrl =3D PORT_MODE_EXT_EPHY;
 		break;

 	case PHY_INTERFACE_MODE_REVMII:
@@ -268,31 +255,34 @@ int bcmgenet_mii_config(struct net_device *dev, bool=
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
+	priv->ext_phy =3D !priv->internal_phy &&
+			(priv->phy_interface !=3D PHY_INTERFACE_MODE_MOCA);
+
 	/* This is an external PHY (xMII), so we need to enable the RGMII
 	 * block for the interface to work
 	 */
@@ -304,6 +294,11 @@ int bcmgenet_mii_config(struct net_device *dev, bool =
init)
 		else
 			reg |=3D RGMII_MODE_EN;
 		bcmgenet_ext_writel(priv, reg, EXT_RGMII_OOB_CTRL);
+	} else if (priv->internal_phy) {
+		phy_name =3D "internal PHY";
+	} else if (priv->phy_interface =3D=3D PHY_INTERFACE_MODE_MOCA) {
+		phy_name =3D "MoCA";
+		bcmgenet_moca_phy_setup(priv);
 	}

 	if (init) {
=2D-
2.7.4

