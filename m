Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE26B30AF91
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 19:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbhBASi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 13:38:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbhBASip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 13:38:45 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACE8C0613D6
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 10:38:04 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1l6e5K-0002eC-Is; Mon, 01 Feb 2021 19:38:02 +0100
Received: from mgr by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1l6e5F-0002Bb-KG; Mon, 01 Feb 2021 19:37:57 +0100
Date:   Mon, 1 Feb 2021 19:37:57 +0100
From:   Michael Grzeschik <mgr@pengutronix.de>
To:     Tristram.Ha@microchip.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        matthias.schiffer@ew.tq-group.com, Woojung.Huh@microchip.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v5 4/6] net: dsa: microchip: ksz8795: add support for
 ksz88xx chips
Message-ID: <20210201183757.GA6935@pengutronix.de>
References: <20201207125627.30843-5-m.grzeschik@pengutronix.de>
 <BYAPR11MB35585C642A2073D0CBC85E44ECC50@BYAPR11MB3558.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
In-Reply-To: <BYAPR11MB35585C642A2073D0CBC85E44ECC50@BYAPR11MB3558.namprd11.prod.outlook.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 19:32:45 up 61 days,  6:59, 90 users,  load average: 0.58, 0.37,
 0.22
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tristam!

On Wed, Dec 16, 2020 at 06:33:06AM +0000, Tristram.Ha@microchip.com wrote:
>>  static void ksz8_r_vlan_table(struct ksz_device *dev, u16 vid, u32 *vla=
n)
>>  {
>> -       int index;
>> -       u16 *data;
>> -       u16 addr;
>> +       u16 addr =3D vid / dev->phy_port_cnt;
>>         u64 buf;
>>
>> -       data =3D (u16 *)&buf;
>> -       addr =3D vid / dev->phy_port_cnt;
>> -       index =3D vid & 3;
>>         ksz8_r_table(dev, TABLE_VLAN, addr, &buf);
>> -       *vlan =3D data[index];
>> +       if (dev->features & IS_88X3) {
>> +               *vlan =3D (u32)buf;
>> +       } else {
>> +               u16 *data =3D (u16 *)&buf;
>> +
>> +               *vlan =3D data[vid & 3];
>> +       }
>>  }
>>
>>  static void ksz8_w_vlan_table(struct ksz_device *dev, u16 vid, u32 vlan)
>>  {
>> -       int index;
>> -       u16 *data;
>> -       u16 addr;
>> +       u16 addr =3D vid / dev->phy_port_cnt;
>>         u64 buf;
>>
>> -       data =3D (u16 *)&buf;
>> -       addr =3D vid / dev->phy_port_cnt;
>> -       index =3D vid & 3;
>>         ksz8_r_table(dev, TABLE_VLAN, addr, &buf);
>> -       data[index] =3D vlan;
>> +
>> +       if (dev->features & IS_88X3) {
>> +               buf =3D vlan;
>> +       } else {
>> +               u16 *data =3D (u16 *)&buf;
>> +
>> +               data[vid & 3] =3D vlan;
>> +       }
>> +
>>         dev->vlan_cache[vid].table[0] =3D vlan;
>>         ksz8_w_table(dev, TABLE_VLAN, addr, buf);
>>  }
>
>I am confused about how the addr is derived.
>
>In KSZ8795 vid is in range of 0-4095.  The addr is just (vid / 4) as there
>are 4 entries in one access.  The data are lined up in 16-bit boundary
>so that the VLAN information can be accessed using the array.
>
>For KSZ8895 the VLAN data are not lined up so the 64-bit variable
>needs to be shifted accordingly and masked.
>
>For KSZ8863 the addr is a hard value from 0 to 15.  The data buffer is just
>32-bit.  The vid value is contained in the entry.  You need to match that =
vid
>with the input vid to return the right information.
>
>You need a different VLAN read function to check if the VLAN is already
>programmed in the VLAN table by searching all 16 entries.
>
>For the VLAN write function you need to check if there is available space
>to add a new entry.  The VID range is still 0-4095, but the FID range is 0=
-15.

Thanks for the clarification. Its possible that I missed that when
porting this from your first RFC.

Regarding the drivers for ksz88{6,7}3, did you also plan to mainline
some work? Do you have some code that could be shared? If so I would
not need to implement everything again. In case you have some work
pending, please let me know. Than we could colaborate to get this
chips finaly mainline.

Thanks,
Michael

--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEElXvEUs6VPX6mDPT8C+njFXoeLGQFAmAYSoEACgkQC+njFXoe
LGSivhAAxOUqf07SGl3hAH/MDxvOHkNyWWvjkQ9gEQetcGCspfE5HuoXwpqf2jQH
Ho9dLdF9FYWYL+UuY1EodrLsDtdcfX5tWZVRdpIneA/UgkhvmfPVyUF14PHIzUaO
PlGN9O2ier+ScKNrgEPGyFB+nV+t16fAorXQUxYACnjITObtdzPugR6RHZ1cKdZi
GyOQOU2cA1GoaHes6qCZcUVQqfMOWcHI/pnFj+8VGo6BzPBT9F65TtBN9vTPbwdo
8gg5dhRcsRf/8RSHmiM+CBpDSzP7JX38Y78LLr2HmwSVmXUl3H7XZUIwdZPMR4IG
iojGHwqisJ1UpaGCSTQhYyQxLfZbWeNG+IDYcz2wIJ61mqfvgXkKgkiClM6V58/r
FSROJ0DDzurj+2Wc5qgXaOEURBfh+6Z1p6crMz8OhSKglomoC1wNRDGiyM1Yox+M
4WlnUlLz5Bobn74Ygs0k0R59l41iGJBKeYtmtk4TpxDgKoqqwdd58zyVIfr6x1Xy
dn+gSREOi/V2kj17L247gY8W0zPOaHCCm242MkpAkLtwXuO8lMbv7alxL9RXgxeJ
niBrRcLgTFzEqDl4p3uk8RQtaIhYjR2jKt4DX2ZrAESBnlpZ14K2NWwHo5fKlxar
yU2gvH7wle20YdKnA8GzM8IMPl+n1ja5qXTh05qilGPj6h1EKFs=
=Ge1z
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
