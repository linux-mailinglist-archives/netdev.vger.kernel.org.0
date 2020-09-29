Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98BF727D669
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 21:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbgI2THn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 15:07:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:55708 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727740AbgI2THn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 15:07:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BF19AAFAA;
        Tue, 29 Sep 2020 19:07:41 +0000 (UTC)
Date:   Tue, 29 Sep 2020 21:07:37 +0200
From:   Petr Tesarik <ptesarik@suse.cz>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        netdev@vger.kernel.org, linux-clk@vger.kernel.org
Subject: Re: RTL8402 stops working after hibernate/resume
Message-ID: <20200929210737.7f4a6da7@ezekiel.suse.cz>
In-Reply-To: <30969885-9611-06d8-d50a-577897fcab29@gmail.com>
References: <20200715102820.7207f2f8@ezekiel.suse.cz>
        <d742082e-42a1-d904-8a8f-4583944e88e1@gmail.com>
        <20200716105835.32852035@ezekiel.suse.cz>
        <e1c7a37f-d8d0-a773-925c-987b92f12694@gmail.com>
        <20200903104122.1e90e03c@ezekiel.suse.cz>
        <7e6bbb75-d8db-280d-ac5b-86013af39071@gmail.com>
        <20200924211444.3ba3874b@ezekiel.suse.cz>
        <a10f658b-7fdf-2789-070a-83ad5549191a@gmail.com>
        <20200925093037.0fac65b7@ezekiel.suse.cz>
        <20200925105455.50d4d1cc@ezekiel.suse.cz>
        <aa997635-a5b5-75e3-8a30-a77acb2adf35@gmail.com>
        <20200925115241.3709caf6@ezekiel.suse.cz>
        <20200925145608.66a89e73@ezekiel.suse.cz>
        <30969885-9611-06d8-d50a-577897fcab29@gmail.com>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/5NIX3CuMdDx9m3Ed8bZcLEz";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/5NIX3CuMdDx9m3Ed8bZcLEz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Heiner (and now also Hans)!

@Hans: I'm adding you to this conversation, because you're the author
of commit b1e3454d39f99, which seems to break the r8169 driver on a
laptop of mine.

On Fri, 25 Sep 2020 16:47:54 +0200
Heiner Kallweit <hkallweit1@gmail.com> wrote:

> On 25.09.2020 14:56, Petr Tesarik wrote:
> > On Fri, 25 Sep 2020 11:52:41 +0200
> > Petr Tesarik <ptesarik@suse.cz> wrote:
> >  =20
> >> On Fri, 25 Sep 2020 11:44:09 +0200
> >> Heiner Kallweit <hkallweit1@gmail.com> wrote:
> >> =20
> >>> On 25.09.2020 10:54, Petr Tesarik wrote:   =20
> >> [...] =20
> >>>> Does it make sense to bisect the change that broke the driver for me=
, or should I rather dispose of this waste^Wlaptop in an environmentally fr=
iendly manner? I mean, would you eventually accept a workaround for a few m=
achines with a broken BIOS?
> >>>>      =20
> >>> If the workaround is small and there's little chance to break other s=
tuff: then usually yes.
> >>> If you can spend the effort to bisect the issue, this would be apprec=
iated.   =20
> >>
> >> OK, then I'm going to give it a try. =20
> >=20
> > Done. The system freezes when this commit is applied:
> >=20
> > commit 9f0b54cd167219266bd3864570ae8f4987b57520
> > Author: Heiner Kallweit <hkallweit1@gmail.com>
> > Date:   Wed Jun 17 22:55:40 2020 +0200
> >=20
> >     r8169: move switching optional clock on/off to pll power functions
> >  =20
> This sounds weird. On your system tp->clk should be NULL, making
> clk_prepare_enable() et al no-ops. Please check whether tp->clk
> is NULL after the call to rtl_get_ether_clk().

This might be part of the issue. On my system tp->clk is definitely not
NULL:

crash> *rtl8169_private.clk 0xffff9277aca58940
  clk =3D 0xffff9277ac2c82a0

crash> *clk 0xffff9277ac2c82a0
struct clk {
  core =3D 0xffff9277aef65d00,=20
  dev =3D 0xffff9277aed000b0,=20
  dev_id =3D 0xffff9277aec60c00 "0000:03:00.2",=20
  con_id =3D 0xffff9277ad04b080 "ether_clk",=20
  min_rate =3D 0,=20
  max_rate =3D 18446744073709551615,=20
  exclusive_count =3D 0,=20
  clks_node =3D {
    next =3D 0xffff9277ad2428d8,=20
    pprev =3D 0xffff9277aef65dc8
  }
}

The dev_id corresponds to the Ethernet controller:

03:00.2 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL810xE PCI E=
xpress Fast Ethernet controller (rev 06)

Looking at clk_find(), it matches this entry in clocks:

struct clk_lookup {
  node =3D {
    next =3D 0xffffffffbc702f40,=20
    prev =3D 0xffff9277bf7190c0
  },=20
  dev_id =3D 0x0,=20
  con_id =3D 0xffff9277bf719524 "ether_clk",=20
  clk =3D 0x0,=20
  clk_hw =3D 0xffff9277ad2427f8
}

That's because this kernel is built with CONFIG_PMC_ATOM=3Dy, and looking
at the platform initialization code, the "ether_clk" alias is created
unconditionally. Hans already added.

Petr T

--Sig_/5NIX3CuMdDx9m3Ed8bZcLEz
Content-Type: application/pgp-signature
Content-Description: Digitální podpis OpenPGP

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHl2YIZkIo5VO2MxYqlA7ya4PR6cFAl9zhfkACgkQqlA7ya4P
R6dRrggAtS8yhdmtAZwoaP0L4XoTFwCaIdxFpl40AbCb0KPPHue+FMWQoph7Rljt
K1gRwCD1xTQcR2CTXM1H4M95mIR+wLSGtkqkKSp71MSHZ+K1kp9nycfU7ew0bHrm
gDrov/5CrAedi3uNOoVeMW5y+qfawjNewX+92hU+wy1QGuZA4yYjy2nUfBrk1d/i
/4+yAUQJDgiNXfdCct6BzLLVj1HOPS1COCcAgY3n9hKIOlHia3N7IzQis91MbBoK
2oI+t5mi1S1fEPXJYFs3ULHXcaIQKOcV1U2xMckv6RlrWIPTSC8KWf4m2TCGFU/l
ed6zYz4Lqw2TLzINiaY1RU6V3m6+rw==
=D/V5
-----END PGP SIGNATURE-----

--Sig_/5NIX3CuMdDx9m3Ed8bZcLEz--
