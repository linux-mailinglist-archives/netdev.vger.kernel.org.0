Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E068441D107
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 03:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347644AbhI3BnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 21:43:09 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:60643 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347415AbhI3BnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 21:43:09 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HKbYx4gP4z4xR9;
        Thu, 30 Sep 2021 11:41:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1632966086;
        bh=7qg2Fwc95KhARCTFHd1qt2bTSiCfEua6E/UBMlkGK5k=;
        h=Date:From:To:Cc:Subject:From;
        b=C8FPByhrqplfQZJZvQl6/+K6AXLtFwgTlOCXWVmkmfEPVCwnlaMWMyJdxHcMk5dop
         rdvji2ELuMmaOYZSYj86Ce0vjqpEvig5ocl1SL+dvoBdW06iX434F2Hp4S+ZfVgrDC
         akdxfXXyYaXHKRj39864+l7wkyc6toyrCTk5QNf7dMU4P/5qPmIkcMJUAvaDU5ScBY
         RLbD/9TO5jRyphpdI1CD0kfVLNMcHmkZF4DSJPdgn8rLswLjA38JptLORvFJ5HihrC
         RG5lFyGF8VJHJicqbAh20efx3Bq41Tj2KtBhFwFFLcJlKBsicJ3dnyWni+kONUobzo
         bZ2Gjb8umcq+Q==
Date:   Thu, 30 Sep 2021 11:41:24 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20210930114124.68a76832@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/iARep1OtUpfU1T8_0NGqEDB";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/iARep1OtUpfU1T8_0NGqEDB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/phy/bcm7xxx.c

between commit:

  d88fd1b546ff ("net: phy: bcm7xxx: Fixed indirect MMD operations")

from the net tree and commit:

  f68d08c437f9 ("net: phy: bcm7xxx: Add EPHY entry for 72165")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc drivers/net/phy/bcm7xxx.c
index 27b6a3f507ae,3a29a1493ff1..000000000000
--- a/drivers/net/phy/bcm7xxx.c
+++ b/drivers/net/phy/bcm7xxx.c
@@@ -415,93 -398,190 +415,277 @@@ static int bcm7xxx_28nm_ephy_config_ini
  	return bcm7xxx_28nm_ephy_apd_enable(phydev);
  }
 =20
 +#define MII_BCM7XXX_REG_INVALID	0xff
 +
 +static u8 bcm7xxx_28nm_ephy_regnum_to_shd(u16 regnum)
 +{
 +	switch (regnum) {
 +	case MDIO_CTRL1:
 +		return MII_BCM7XXX_SHD_3_PCS_CTRL;
 +	case MDIO_STAT1:
 +		return MII_BCM7XXX_SHD_3_PCS_STATUS;
 +	case MDIO_PCS_EEE_ABLE:
 +		return MII_BCM7XXX_SHD_3_EEE_CAP;
 +	case MDIO_AN_EEE_ADV:
 +		return MII_BCM7XXX_SHD_3_AN_EEE_ADV;
 +	case MDIO_AN_EEE_LPABLE:
 +		return MII_BCM7XXX_SHD_3_EEE_LP;
 +	case MDIO_PCS_EEE_WK_ERR:
 +		return MII_BCM7XXX_SHD_3_EEE_WK_ERR;
 +	default:
 +		return MII_BCM7XXX_REG_INVALID;
 +	}
 +}
 +
 +static bool bcm7xxx_28nm_ephy_dev_valid(int devnum)
 +{
 +	return devnum =3D=3D MDIO_MMD_AN || devnum =3D=3D MDIO_MMD_PCS;
 +}
 +
 +static int bcm7xxx_28nm_ephy_read_mmd(struct phy_device *phydev,
 +				      int devnum, u16 regnum)
 +{
 +	u8 shd =3D bcm7xxx_28nm_ephy_regnum_to_shd(regnum);
 +	int ret;
 +
 +	if (!bcm7xxx_28nm_ephy_dev_valid(devnum) ||
 +	    shd =3D=3D MII_BCM7XXX_REG_INVALID)
 +		return -EOPNOTSUPP;
 +
 +	/* set shadow mode 2 */
 +	ret =3D __phy_set_clr_bits(phydev, MII_BCM7XXX_TEST,
 +				 MII_BCM7XXX_SHD_MODE_2, 0);
 +	if (ret < 0)
 +		return ret;
 +
 +	/* Access the desired shadow register address */
 +	ret =3D __phy_write(phydev, MII_BCM7XXX_SHD_2_ADDR_CTRL, shd);
 +	if (ret < 0)
 +		goto reset_shadow_mode;
 +
 +	ret =3D __phy_read(phydev, MII_BCM7XXX_SHD_2_CTRL_STAT);
 +
 +reset_shadow_mode:
 +	/* reset shadow mode 2 */
 +	__phy_set_clr_bits(phydev, MII_BCM7XXX_TEST, 0,
 +			   MII_BCM7XXX_SHD_MODE_2);
 +	return ret;
 +}
 +
 +static int bcm7xxx_28nm_ephy_write_mmd(struct phy_device *phydev,
 +				       int devnum, u16 regnum, u16 val)
 +{
 +	u8 shd =3D bcm7xxx_28nm_ephy_regnum_to_shd(regnum);
 +	int ret;
 +
 +	if (!bcm7xxx_28nm_ephy_dev_valid(devnum) ||
 +	    shd =3D=3D MII_BCM7XXX_REG_INVALID)
 +		return -EOPNOTSUPP;
 +
 +	/* set shadow mode 2 */
 +	ret =3D __phy_set_clr_bits(phydev, MII_BCM7XXX_TEST,
 +				 MII_BCM7XXX_SHD_MODE_2, 0);
 +	if (ret < 0)
 +		return ret;
 +
 +	/* Access the desired shadow register address */
 +	ret =3D __phy_write(phydev, MII_BCM7XXX_SHD_2_ADDR_CTRL, shd);
 +	if (ret < 0)
 +		goto reset_shadow_mode;
 +
 +	/* Write the desired value in the shadow register */
 +	__phy_write(phydev, MII_BCM7XXX_SHD_2_CTRL_STAT, val);
 +
 +reset_shadow_mode:
 +	/* reset shadow mode 2 */
 +	return __phy_set_clr_bits(phydev, MII_BCM7XXX_TEST, 0,
 +				  MII_BCM7XXX_SHD_MODE_2);
 +}
 +
+ static int bcm7xxx_16nm_ephy_afe_config(struct phy_device *phydev)
+ {
+ 	int tmp, rcalcode, rcalnewcodelp, rcalnewcode11, rcalnewcode11d2;
+=20
+ 	/* Reset PHY */
+ 	tmp =3D genphy_soft_reset(phydev);
+ 	if (tmp)
+ 		return tmp;
+=20
+ 	/* Reset AFE and PLL */
+ 	bcm_phy_write_exp_sel(phydev, 0x0003, 0x0006);
+ 	/* Clear reset */
+ 	bcm_phy_write_exp_sel(phydev, 0x0003, 0x0000);
+=20
+ 	/* Write PLL/AFE control register to select 54MHz crystal */
+ 	bcm_phy_write_misc(phydev, 0x0030, 0x0001, 0x0000);
+ 	bcm_phy_write_misc(phydev, 0x0031, 0x0000, 0x044a);
+=20
+ 	/* Change Ka,Kp,Ki to pdiv=3D1 */
+ 	bcm_phy_write_misc(phydev, 0x0033, 0x0002, 0x71a1);
+ 	/* Configuration override */
+ 	bcm_phy_write_misc(phydev, 0x0033, 0x0001, 0x8000);
+=20
+ 	/* Change PLL_NDIV and PLL_NUDGE */
+ 	bcm_phy_write_misc(phydev, 0x0031, 0x0001, 0x2f68);
+ 	bcm_phy_write_misc(phydev, 0x0031, 0x0002, 0x0000);
+=20
+ 	/* Reference frequency is 54Mhz, config_mode[15:14] =3D 3 (low
+ 	 * phase)
+ 	 */
+ 	bcm_phy_write_misc(phydev, 0x0030, 0x0003, 0xc036);
+=20
+ 	/* Initialize bypass mode */
+ 	bcm_phy_write_misc(phydev, 0x0032, 0x0003, 0x0000);
+ 	/* Bypass code, default: VCOCLK enabled */
+ 	bcm_phy_write_misc(phydev, 0x0033, 0x0000, 0x0002);
+ 	/* LDOs at default setting */
+ 	bcm_phy_write_misc(phydev, 0x0030, 0x0002, 0x01c0);
+ 	/* Release PLL reset */
+ 	bcm_phy_write_misc(phydev, 0x0030, 0x0001, 0x0001);
+=20
+ 	/* Bandgap curvature correction to correct default */
+ 	bcm_phy_write_misc(phydev, 0x0038, 0x0000, 0x0010);
+=20
+ 	/* Run RCAL */
+ 	bcm_phy_write_misc(phydev, 0x0039, 0x0003, 0x0038);
+ 	bcm_phy_write_misc(phydev, 0x0039, 0x0003, 0x003b);
+ 	udelay(2);
+ 	bcm_phy_write_misc(phydev, 0x0039, 0x0003, 0x003f);
+ 	mdelay(5);
+=20
+ 	/* AFE_CAL_CONFIG_0, Vref=3D1000, Target=3D10, averaging enabled */
+ 	bcm_phy_write_misc(phydev, 0x0039, 0x0001, 0x1c82);
+ 	/* AFE_CAL_CONFIG_0, no reset and analog powerup */
+ 	bcm_phy_write_misc(phydev, 0x0039, 0x0001, 0x9e82);
+ 	udelay(2);
+ 	/* AFE_CAL_CONFIG_0, start calibration */
+ 	bcm_phy_write_misc(phydev, 0x0039, 0x0001, 0x9f82);
+ 	udelay(100);
+ 	/* AFE_CAL_CONFIG_0, clear start calibration, set HiBW */
+ 	bcm_phy_write_misc(phydev, 0x0039, 0x0001, 0x9e86);
+ 	udelay(2);
+ 	/* AFE_CAL_CONFIG_0, start calibration with hi BW mode set */
+ 	bcm_phy_write_misc(phydev, 0x0039, 0x0001, 0x9f86);
+ 	udelay(100);
+=20
+ 	/* Adjust 10BT amplitude additional +7% and 100BT +2% */
+ 	bcm_phy_write_misc(phydev, 0x0038, 0x0001, 0xe7ea);
+ 	/* Adjust 1G mode amplitude and 1G testmode1 */
+ 	bcm_phy_write_misc(phydev, 0x0038, 0x0002, 0xede0);
+=20
+ 	/* Read CORE_EXPA9 */
+ 	tmp =3D bcm_phy_read_exp(phydev, 0x00a9);
+ 	/* CORE_EXPA9[6:1] is rcalcode[5:0] */
+ 	rcalcode =3D (tmp & 0x7e) / 2;
+ 	/* Correct RCAL code + 1 is -1% rprogr, LP: +16 */
+ 	rcalnewcodelp =3D rcalcode + 16;
+ 	/* Correct RCAL code + 1 is -15 rprogr, 11: +10 */
+ 	rcalnewcode11 =3D rcalcode + 10;
+ 	/* Saturate if necessary */
+ 	if (rcalnewcodelp > 0x3f)
+ 		rcalnewcodelp =3D 0x3f;
+ 	if (rcalnewcode11 > 0x3f)
+ 		rcalnewcode11 =3D 0x3f;
+ 	/* REXT=3D1 BYP=3D1 RCAL_st1<5:0>=3Dnew rcal code */
+ 	tmp =3D 0x00f8 + rcalnewcodelp * 256;
+ 	/* Program into AFE_CAL_CONFIG_2 */
+ 	bcm_phy_write_misc(phydev, 0x0039, 0x0003, tmp);
+ 	/* AFE_BIAS_CONFIG_0 10BT bias code (Bias: E4) */
+ 	bcm_phy_write_misc(phydev, 0x0038, 0x0001, 0xe7e4);
+ 	/* invert adc clock output and 'adc refp ldo current To correct
+ 	 * default
+ 	 */
+ 	bcm_phy_write_misc(phydev, 0x003b, 0x0000, 0x8002);
+ 	/* 100BT stair case, high BW, 1G stair case, alternate encode */
+ 	bcm_phy_write_misc(phydev, 0x003c, 0x0003, 0xf882);
+ 	/* 1000BT DAC transition method per Erol, bits[32], DAC Shuffle
+ 	 * sequence 1 + 10BT imp adjust bits
+ 	 */
+ 	bcm_phy_write_misc(phydev, 0x003d, 0x0000, 0x3201);
+ 	/* Non-overlap fix */
+ 	bcm_phy_write_misc(phydev, 0x003a, 0x0002, 0x0c00);
+=20
+ 	/* pwdb override (rxconfig<5>) to turn on RX LDO indpendent of
+ 	 * pwdb controls from DSP_TAP10
+ 	 */
+ 	bcm_phy_write_misc(phydev, 0x003a, 0x0001, 0x0020);
+=20
+ 	/* Remove references to channel 2 and 3 */
+ 	bcm_phy_write_misc(phydev, 0x003b, 0x0002, 0x0000);
+ 	bcm_phy_write_misc(phydev, 0x003b, 0x0003, 0x0000);
+=20
+ 	/* Set cal_bypassb bit rxconfig<43> */
+ 	bcm_phy_write_misc(phydev, 0x003a, 0x0003, 0x0800);
+ 	udelay(2);
+=20
+ 	/* Revert pwdb_override (rxconfig<5>) to 0 so that the RX pwr
+ 	 * is controlled by DSP.
+ 	 */
+ 	bcm_phy_write_misc(phydev, 0x003a, 0x0001, 0x0000);
+=20
+ 	/* Drop LSB */
+ 	rcalnewcode11d2 =3D (rcalnewcode11 & 0xfffe) / 2;
+ 	tmp =3D bcm_phy_read_misc(phydev, 0x003d, 0x0001);
+ 	/* Clear bits [11:5] */
+ 	tmp &=3D ~0xfe0;
+ 	/* set txcfg_ch0<5>=3D1 (enable + set local rcal) */
+ 	tmp |=3D 0x0020 | (rcalnewcode11d2 * 64);
+ 	bcm_phy_write_misc(phydev, 0x003d, 0x0001, tmp);
+ 	bcm_phy_write_misc(phydev, 0x003d, 0x0002, tmp);
+=20
+ 	tmp =3D bcm_phy_read_misc(phydev, 0x003d, 0x0000);
+ 	/* set txcfg<45:44>=3D11 (enable Rextra + invert fullscaledetect)
+ 	 */
+ 	tmp &=3D ~0x3000;
+ 	tmp |=3D 0x3000;
+ 	bcm_phy_write_misc(phydev, 0x003d, 0x0000, tmp);
+=20
+ 	return 0;
+ }
+=20
+ static int bcm7xxx_16nm_ephy_config_init(struct phy_device *phydev)
+ {
+ 	int ret, val;
+=20
+ 	ret =3D bcm7xxx_16nm_ephy_afe_config(phydev);
+ 	if (ret)
+ 		return ret;
+=20
+ 	ret =3D bcm_phy_set_eee(phydev, true);
+ 	if (ret)
+ 		return ret;
+=20
+ 	ret =3D bcm_phy_read_shadow(phydev, BCM54XX_SHD_SCR3);
+ 	if (ret < 0)
+ 		return ret;
+=20
+ 	val =3D ret;
+=20
+ 	/* Auto power down of DLL enabled,
+ 	 * TXC/RXC disabled during auto power down.
+ 	 */
+ 	val &=3D ~BCM54XX_SHD_SCR3_DLLAPD_DIS;
+ 	val |=3D BIT(8);
+=20
+ 	ret =3D bcm_phy_write_shadow(phydev, BCM54XX_SHD_SCR3, val);
+ 	if (ret < 0)
+ 		return ret;
+=20
+ 	return bcm_phy_enable_apd(phydev, true);
+ }
+=20
+ static int bcm7xxx_16nm_ephy_resume(struct phy_device *phydev)
+ {
+ 	int ret;
+=20
+ 	/* Re-apply workarounds coming out suspend/resume */
+ 	ret =3D bcm7xxx_16nm_ephy_config_init(phydev);
+ 	if (ret)
+ 		return ret;
+=20
+ 	return genphy_config_aneg(phydev);
+ }
+=20
  static int bcm7xxx_28nm_ephy_resume(struct phy_device *phydev)
  {
  	int ret;

--Sig_/iARep1OtUpfU1T8_0NGqEDB
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFVFcQACgkQAVBC80lX
0GwQmAf9F9QgmSssLH9AGZwzdmxyzvU2A+1w2T8yG9mksX+FBAjvqFfQMRxzZneO
wD7UkzKFuSDxoDbQwc4uyJ4GWgitO5BRN4I774tvW8oHd8OgdH578OHDq6kDAyMF
5TuGxxl/EztGuujV6psce3GGxZ4rs6VJeQ1+WsBEguhyZgLRwiZ1BHNyZw3OJgGX
kKqU9Bz9NwYqXnziLO9zp7xJ8kVNt8G2z+Sa4DXxYpbXIbrFpEkLUq6zmVL36Qh9
+58miD50wXb70qOF5lsDerWcyuIo3zjSVVw/hBKX69OrkK29GJxLklPNPqqVHTkM
M95jOgv3Fm/nTDuIUgW3ePqedi9xhQ==
=yeZb
-----END PGP SIGNATURE-----

--Sig_/iARep1OtUpfU1T8_0NGqEDB--
