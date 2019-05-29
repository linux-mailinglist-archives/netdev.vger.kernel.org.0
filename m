Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97C562E992
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 01:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbfE2X4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 19:56:52 -0400
Received: from ozlabs.org ([203.11.71.1]:40949 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbfE2X4w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 19:56:52 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45DngN3zTQz9s00;
        Thu, 30 May 2019 09:56:48 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1559174208;
        bh=ARcWeHeoTnvIdiOB8345XbTkTIeEKOvksLJ36MHAxBo=;
        h=Date:From:To:Cc:Subject:From;
        b=bP0Ex/Ogss9VTT4xN536q0IYxYXNcCBdz9zKIwOr1OrDZRAMgOKjhkAzVN5qWN1nm
         3SRuqpu+X3h15OJlD9jD3IE0eQ4NUjtuwvdJh4cGm6W38had8VrldIaT15sRfDmsmI
         87i8kq1X0FScqlIs3LRMANjbirQ7LIIWGhcM0bSRHff3UufjT4ZK+5Z1ITW+oUviNX
         uhnocrlmYEuEz8rTtuK/GAjMUlLnCj9U1RFirF7yHpToJHrIl+t1IavWCnFeBG8g3b
         3KjZCFBxEZ+Lyy2fwa6gN0d4XePVk977qJdyws3Q7SIZLwV4dJVXarqWLYmJn9XiNw
         87Jvf2WpUpDew==
Date:   Thu, 30 May 2019 09:56:32 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Max Uvarov <muvarov@gmail.com>,
        Trent Piepho <tpiepho@impinj.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20190530095632.34685e5b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/7BFx=ybehqHEDaYAc1Bp9ve"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/7BFx=ybehqHEDaYAc1Bp9ve
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/phy/dp83867.c

between commits:

  2b892649254f ("net: phy: dp83867: Set up RGMII TX delay")
  333061b92453 ("net: phy: dp83867: fix speed 10 in sgmii mode")

from the net tree and commits:

  c11669a2757e ("net: phy: dp83867: Rework delay rgmii delay handling")
  27708eb5481b ("net: phy: dp83867: IO impedance is not dependent on RGMII =
delay")

from the net-next tree.

I fixed it up (I took a guess - see below) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc drivers/net/phy/dp83867.c
index c71c7d0f53f0,3bdf94043693..000000000000
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@@ -26,18 -26,11 +26,19 @@@
 =20
  /* Extended Registers */
  #define DP83867_CFG4            0x0031
 +#define DP83867_CFG4_SGMII_ANEG_MASK (BIT(5) | BIT(6))
 +#define DP83867_CFG4_SGMII_ANEG_TIMER_11MS   (3 << 5)
 +#define DP83867_CFG4_SGMII_ANEG_TIMER_800US  (2 << 5)
 +#define DP83867_CFG4_SGMII_ANEG_TIMER_2US    (1 << 5)
 +#define DP83867_CFG4_SGMII_ANEG_TIMER_16MS   (0 << 5)
 +
  #define DP83867_RGMIICTL	0x0032
  #define DP83867_STRAP_STS1	0x006E
+ #define DP83867_STRAP_STS2	0x006f
  #define DP83867_RGMIIDCTL	0x0086
  #define DP83867_IO_MUX_CFG	0x0170
 +#define DP83867_10M_SGMII_CFG   0x016F
 +#define DP83867_10M_SGMII_RATE_ADAPT_MASK BIT(7)
 =20
  #define DP83867_SW_RESET	BIT(15)
  #define DP83867_SW_RESTART	BIT(14)
@@@ -255,10 -321,18 +329,17 @@@ static int dp83867_config_init(struct p
  		ret =3D phy_write(phydev, MII_DP83867_PHYCTRL, val);
  		if (ret)
  			return ret;
 -	}
 =20
 -	/* If rgmii mode with no internal delay is selected, we do NOT use
 -	 * aligned mode as one might expect.  Instead we use the PHY's default
 -	 * based on pin strapping.  And the "mode 0" default is to *use*
 -	 * internal delay with a value of 7 (2.00 ns).
 -	 */
 -	if ((phydev->interface >=3D PHY_INTERFACE_MODE_RGMII_ID) &&
 -	    (phydev->interface <=3D PHY_INTERFACE_MODE_RGMII_RXID)) {
 +		/* Set up RGMII delays */
++		/* If rgmii mode with no internal delay is selected,
++		 * we do NOT use aligned mode as one might expect.  Instead
++		 * we use the PHY's default based on pin strapping.  And the
++		 * "mode 0" default is to *use* * internal delay with a
++		 * value of 7 (2.00 ns).
++		*/
  		val =3D phy_read_mmd(phydev, DP83867_DEVADDR, DP83867_RGMIICTL);
 =20
+ 		val &=3D ~(DP83867_RGMII_TX_CLK_DELAY_EN | DP83867_RGMII_RX_CLK_DELAY_E=
N);
  		if (phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_ID)
  			val |=3D (DP83867_RGMII_TX_CLK_DELAY_EN | DP83867_RGMII_RX_CLK_DELAY_E=
N);
 =20
@@@ -275,41 -349,14 +356,41 @@@
 =20
  		phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RGMIIDCTL,
  			      delay);
-=20
- 		if (dp83867->io_impedance >=3D 0)
- 			phy_modify_mmd(phydev, DP83867_DEVADDR, DP83867_IO_MUX_CFG,
- 				       DP83867_IO_MUX_CFG_IO_IMPEDANCE_CTRL,
- 				       dp83867->io_impedance &
- 				       DP83867_IO_MUX_CFG_IO_IMPEDANCE_CTRL);
  	}
 =20
+ 	/* If specified, set io impedance */
+ 	if (dp83867->io_impedance >=3D 0)
+ 		phy_modify_mmd(phydev, DP83867_DEVADDR, DP83867_IO_MUX_CFG,
+ 			       DP83867_IO_MUX_CFG_IO_IMPEDANCE_MASK,
+ 			       dp83867->io_impedance);
+=20
 +	if (phydev->interface =3D=3D PHY_INTERFACE_MODE_SGMII) {
 +		/* For support SPEED_10 in SGMII mode
 +		 * DP83867_10M_SGMII_RATE_ADAPT bit
 +		 * has to be cleared by software. That
 +		 * does not affect SPEED_100 and
 +		 * SPEED_1000.
 +		 */
 +		ret =3D phy_modify_mmd(phydev, DP83867_DEVADDR,
 +				     DP83867_10M_SGMII_CFG,
 +				     DP83867_10M_SGMII_RATE_ADAPT_MASK,
 +				     0);
 +		if (ret)
 +			return ret;
 +
 +		/* After reset SGMII Autoneg timer is set to 2us (bits 6 and 5
 +		 * are 01). That is not enough to finalize autoneg on some
 +		 * devices. Increase this timer duration to maximum 16ms.
 +		 */
 +		ret =3D phy_modify_mmd(phydev, DP83867_DEVADDR,
 +				     DP83867_CFG4,
 +				     DP83867_CFG4_SGMII_ANEG_MASK,
 +				     DP83867_CFG4_SGMII_ANEG_TIMER_16MS);
 +
 +		if (ret)
 +			return ret;
 +	}
 +
  	/* Enable Interrupt output INT_OE in CFG3 register */
  	if (phy_interrupt_is_valid(phydev)) {
  		val =3D phy_read(phydev, DP83867_CFG3);

--Sig_/7BFx=ybehqHEDaYAc1Bp9ve
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlzvHDAACgkQAVBC80lX
0GxOlgf/fYkTzUbyppqR3YyaCImL3L+2Q99LAD4mslB5qXuDiU+3OItw1EDbBOxt
ZbySoQnL9rneZmGA5opVG6eOq269cA3g+qYK6oOVOz2JRrfSElj3kAzg6sLpuXKG
vG2diCF8vZv033JbFe4kNViihJvWvt4MpJ7Et1QuNruL0T9l7aIVX7EKtGycTYnV
esCOvSiBRVpbxpy8+ye0NjbHAX2X1aMll7o/lCNcRRTZ5KDnexZqHJS2FhNZ369h
72a7vdbpWPAcnPS5UJkZRqHF+9IgcTmDBodpZRnOnJ/Jnh5GTSPvKVzreQTsSAfG
DJ1Muh3S5dUMEa5AYkNgvrBce1KHmQ==
=thpz
-----END PGP SIGNATURE-----

--Sig_/7BFx=ybehqHEDaYAc1Bp9ve--
