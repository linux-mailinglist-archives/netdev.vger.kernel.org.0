Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 077FEF60F4
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 20:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfKITCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 14:02:12 -0500
Received: from mout.gmx.net ([212.227.15.15]:59157 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726441AbfKITCM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 14:02:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1573326041;
        bh=4tHGKE+e17UnhyLVKq76j3dokNGsfO7qmeQ/3LMCwKE=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=czluM3FTlc+BYMWlEGvkMYtPQlObKZbfsLLAT66Ns2weja1jDBTTSMRje37yDXJ6g
         6Eij/IQ7IttjKhQqJCnMo8QZ4JyWSrHWRt9iKqKE4NrLoU2k3Bug2um8DXf5+pF9/6
         xylg94t+76ksbTrCjCm4FBxm1tUYK89ZuJz6zhAg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.112]) by mail.gmx.com
 (mrgmx005 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MYNNo-1iOgfq3maI-00VORB; Sat, 09 Nov 2019 20:00:41 +0100
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
Subject: [PATCH V3 net-next 5/7] net: bcmgenet: Refactor register access in bcmgenet_mii_config
Date:   Sat,  9 Nov 2019 20:00:07 +0100
Message-Id: <1573326009-2275-6-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573326009-2275-1-git-send-email-wahrenst@gmx.net>
References: <1573326009-2275-1-git-send-email-wahrenst@gmx.net>
X-Provags-ID: V03:K1:SDewv7JeUg4PC3g8+zwtSYku0IF54nARmVAnnYYd7o0rb0WqPMP
 qQSZ92NGiWz50ZwCoGeJlnQ0fAaXeLrNrl3XOjO3Otx1AJ+ZqHzN+/d8QxYCorv8lOeho2U
 +A4XI8RKiL3v5/FzynFNXokYYSf+l+6l9j6iE7Cl/dMkzxLxSPQcwX9M4RAzeEogSvbd6eo
 PsgVdy7yygDKREXdEjg/w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:z9p06GDHyOY=:+VQs+zygUqtK6j/EItEXvr
 wcTaKcGWhhIr9M7q98yrw4sCoV7+w4beQGUwNt1AALkGYLCUE8Ejzg4rUq5MSbd9LPwLKJEVg
 D9D08HhSq8LpduAoNYGQMN4pRGOu0/RQ8LLY71hHYf/mtdVxpaXRfBEcnCztCfIwSwpZ3txFa
 81NFm9PBX0kbR0s8uWB61IxZW/ATJhT6VFPbcf4oYjSF7XzR5XV81Oj57B1osixiWCDoLYdg5
 bK8pO0QLU958yCjEeT3kdeOILJJq8fDSgSOzgfRHQM3Fk8P7AoZY0NfwG3TkZAWsluj0UPBax
 eEyaIvQtk6xMRQYgRfUat4RwqsArvfwglRQBeCBJ9F75acEnfqgV8xMBdlV6rW2520HdH2NGG
 v3NA9RaQS78BeqwyiOS3mnpGkOwCfULkmzyeyPYWmRQ+Mr/u1X/Bc8CsVRKkklViMhQoy7k23
 q3dtnG5RT1VA8h1PV/zL6dNLfhbshwWDQysa9M088oyDbvtJ5hL2zSGYTX0BaDfUNm20JLCMK
 okZsygOvXA+pzYfxExtvjOPvlD+fJH1Dk/ttXr0ZXYg5esYC5Ia5rknZpF2C9mO6rdnwTYQUZ
 BioNfK8K4H9eB3W9Dfm+i9lr2xNFblvU4LWH2BCcWa1LjYMsaT58R1OVn11Uub4jZ+2mz8/hR
 KbLT72PFv67tV4rC2n7USPpIIHn9vwQn0af4xzJMtxkV3jFesygs95BlU4ervsUsn5gZFjpaN
 WzlMgm17I1P+nSiYmPbNx8SEiw/5uvasWAqBcVa7fjRfpNYNYgqxGf9xL/TfPjUOTS4x5afmt
 9XpLXdnKf7ImJg1H07XmaF15mBhnVjy084ml3P3+Z6N4nTkfdS0PpcVyS44sTkFqnUiFLmwlu
 peSm++mG1q7ejzYeIIUiodFuAPMtx0SJYzWem9FueCQvRBvrH30qe/mH4WMePC5FMR9/kPTrg
 XwdxbYfm6D1PlTNWsbj2VUAR3UZeyMuczA+3MgHvKsuhDETOcQ2wXekh3pBLkjerPufK/IGNx
 Ip29Q9MNTr4SQk5UfSRRnEUIoiikIRzIuM8xaYLk53u5ZUeIRrmEZMRxHwP0tXWLWCXu+qnDU
 1Pjrr2Mv9UYWyI7oNKhN+uSz4HpmM/lm4fQGXuQGXR078pw5XqBDHOuSFDLolLqXFPFRbHZF6
 tD7yooz0ePmhw2boun/9NnBDk6Q5FzjN3d7K8oOzPtWx6U+i0AbpPYALIclmTWuVdrJQd8yuV
 pQx+ewTNKprr6f23ZNZc63wNd3C3jFTy+fBSBrw==
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

