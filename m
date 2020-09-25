Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B46278355
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 10:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbgIYIzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 04:55:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:60622 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726990AbgIYIzE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 04:55:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 00FF5ADCA;
        Fri, 25 Sep 2020 08:55:03 +0000 (UTC)
Date:   Fri, 25 Sep 2020 10:54:55 +0200
From:   Petr Tesarik <ptesarik@suse.cz>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        netdev@vger.kernel.org
Subject: Re: RTL8402 stops working after hibernate/resume
Message-ID: <20200925105455.50d4d1cc@ezekiel.suse.cz>
In-Reply-To: <20200925093037.0fac65b7@ezekiel.suse.cz>
References: <20200715102820.7207f2f8@ezekiel.suse.cz>
        <d742082e-42a1-d904-8a8f-4583944e88e1@gmail.com>
        <20200716105835.32852035@ezekiel.suse.cz>
        <e1c7a37f-d8d0-a773-925c-987b92f12694@gmail.com>
        <20200903104122.1e90e03c@ezekiel.suse.cz>
        <7e6bbb75-d8db-280d-ac5b-86013af39071@gmail.com>
        <20200924211444.3ba3874b@ezekiel.suse.cz>
        <a10f658b-7fdf-2789-070a-83ad5549191a@gmail.com>
        <20200925093037.0fac65b7@ezekiel.suse.cz>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/PmTxwrOMJoLGsLynIiMVBOH";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/PmTxwrOMJoLGsLynIiMVBOH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 25 Sep 2020 09:30:37 +0200
Petr Tesarik <ptesarik@suse.cz> wrote:

> On Thu, 24 Sep 2020 22:12:24 +0200
> Heiner Kallweit <hkallweit1@gmail.com> wrote:
>=20
> > On 24.09.2020 21:14, Petr Tesarik wrote: =20
> > > On Wed, 23 Sep 2020 11:57:41 +0200
> > > Heiner Kallweit <hkallweit1@gmail.com> wrote:
> > >  =20
> > >> On 03.09.2020 10:41, Petr Tesarik wrote: =20
> > >>> Hi Heiner,
> > >>>
> > >>> this issue was on the back-burner for some time, but I've got some
> > >>> interesting news now.
> > >>>
> > >>> On Sat, 18 Jul 2020 14:07:50 +0200
> > >>> Heiner Kallweit <hkallweit1@gmail.com> wrote:
> > >>>    =20
> > >>>> [...]
> > >>>> Maybe the following gives us an idea:
> > >>>> Please do "ethtool -d <if>" after boot and after resume from suspe=
nd,
> > >>>> and check for differences.   =20
> > >>>
> > >>> The register dump did not reveal anything of interest - the only
> > >>> differences were in the physical addresses after a device reopen.
> > >>>
> > >>> However, knowing that reloading the driver can fix the issue, I cop=
ied
> > >>> the initialization sequence from init_one() to rtl8169_resume() and
> > >>> gave it a try. That works!
> > >>>
> > >>> Then I started removing the initialization calls one by one. This
> > >>> exercise left me with a call to rtl_init_rxcfg(), which simply sets=
 the
> > >>> RxConfig register. In other words, these is the difference between
> > >>> 5.8.4 and my working version:
> > >>>
> > >>> --- linux-orig/drivers/net/ethernet/realtek/r8169_main.c	2020-09-02=
 22:43:09.361951750 +0200
> > >>> +++ linux/drivers/net/ethernet/realtek/r8169_main.c	2020-09-03 10:3=
6:23.915803703 +0200
> > >>> @@ -4925,6 +4925,9 @@
> > >>> =20
> > >>>  	clk_prepare_enable(tp->clk);
> > >>> =20
> > >>> +	if (tp->mac_version =3D=3D RTL_GIGA_MAC_VER_37)
> > >>> +		RTL_W32(tp, RxConfig, RX128_INT_EN | RX_DMA_BURST);
> > >>> +
> > >>>  	if (netif_running(tp->dev))
> > >>>  		__rtl8169_resume(tp);
> > >>> =20
> > >>> This is quite surprising, at least when the device is managed by
> > >>> NetworkManager, because then it is closed on wakeup, and the open
> > >>> method should call rtl_init_rxcfg() anyway. So, it might be a timing
> > >>> issue, or incorrect order of register writes.
> > >>>    =20
> > >> Thanks for the analysis. If you manually bring down and up the
> > >> interface, do you see the same issue? =20
> > >=20
> > > I'm not quite sure what you mean, but if the interface is configured
> > > (and NetworkManager is stopped), I can do 'ip link set eth0 down' and
> > > then 'ip link set eth0 up', and the interface is fully functional.
> > >  =20
> > >> What is the value of RxConfig when entering the resume function? =20
> > >=20
> > > I added a dev_info() to rtl8169_resume(). First with NetworkManager
> > > active (i.e. interface down on suspend):
> > >=20
> > > [  525.956675] r8169 0000:03:00.2: RxConfig after resume: 0x0002400f
> > >=20
> > > Then I re-tried with NetworkManager stopped (i.e. interface up on
> > > suspend). Same result:
> > >=20
> > > [  785.413887] r8169 0000:03:00.2: RxConfig after resume: 0x0002400f
> > >=20
> > > I hope that's what you were asking for...
> > >=20
> > > Petr T
> > >  =20
> >=20
> > rtl8169_resume() has been changed in 5.9, therefore the patch doesn't
> > apply cleanly on older kernel versions. Can you test the following
> > on a 5.9-rc version or linux-next? =20
>=20
> I tried installing 5.9-rc6, but it freezes hard at boot, last message is:
>=20
> [   14.916259] libphy: r8169: probed
>=20
> At this point, I suspect you're right that the BIOS is seriously buggy.
> Let me check if ASUSTek has released any update for this model.

Hm, it took me about an hour wondering why I cannot flash the 314 update, b=
ut then I finally noticed that this was for X543, while mine is an X453... =
*sigh*

So, I'm at BIOS version 214, released in 2015, and that's the latest versio=
n. There are some older versions available, but the BIOS Flash utility won'=
t let me downgrade.

Does it make sense to bisect the change that broke the driver for me, or sh=
ould I rather dispose of this waste^Wlaptop in an environmentally friendly =
manner? I mean, would you eventually accept a workaround for a few machines=
 with a broken BIOS?

Petr T

--Sig_/PmTxwrOMJoLGsLynIiMVBOH
Content-Type: application/pgp-signature
Content-Description: Digitální podpis OpenPGP

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHl2YIZkIo5VO2MxYqlA7ya4PR6cFAl9tsGAACgkQqlA7ya4P
R6dZnAgAk7F+38ift1QVY7b1q5meA1ash//fqGi9DKB89EpT2bIWhE4KomGrZQmm
UfbaBlttawdD3pnCieYWdu9xqY4y5be3xDFdqib9DMNlrMsYojI/cTAe8GGZteJb
XSsy4ozVTTTIzvCkAbFZBVyBrGE2+mf/TKz3aWdA/ZNXnPEcHlOX+TS/Ztv9O6mv
/ISnIeCQC/HtOMF112XoVkSmaHpmEP7xC8EzbJ2ih54H01kcACJx29jfBLxemiFM
xwYCsqeCP2SpMWMS2zjGnJmWFcAHyrme7TPd6eUpPBGgYjrrsZTeDvIoRaI0YY2C
wkkbM56tHsfixHW7gd+Q6CpAAvaFkg==
=eNlK
-----END PGP SIGNATURE-----

--Sig_/PmTxwrOMJoLGsLynIiMVBOH--
