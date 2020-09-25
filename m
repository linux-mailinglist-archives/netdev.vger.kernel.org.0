Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3996C278190
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 09:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbgIYHan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 03:30:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:39980 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726990AbgIYHan (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 03:30:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 67A12ACC8;
        Fri, 25 Sep 2020 07:30:41 +0000 (UTC)
Date:   Fri, 25 Sep 2020 09:30:37 +0200
From:   Petr Tesarik <ptesarik@suse.cz>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        netdev@vger.kernel.org
Subject: Re: RTL8402 stops working after hibernate/resume
Message-ID: <20200925093037.0fac65b7@ezekiel.suse.cz>
In-Reply-To: <a10f658b-7fdf-2789-070a-83ad5549191a@gmail.com>
References: <20200715102820.7207f2f8@ezekiel.suse.cz>
        <d742082e-42a1-d904-8a8f-4583944e88e1@gmail.com>
        <20200716105835.32852035@ezekiel.suse.cz>
        <e1c7a37f-d8d0-a773-925c-987b92f12694@gmail.com>
        <20200903104122.1e90e03c@ezekiel.suse.cz>
        <7e6bbb75-d8db-280d-ac5b-86013af39071@gmail.com>
        <20200924211444.3ba3874b@ezekiel.suse.cz>
        <a10f658b-7fdf-2789-070a-83ad5549191a@gmail.com>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/KSXtigMn0BwY3w9s.z/B=4F";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/KSXtigMn0BwY3w9s.z/B=4F
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 24 Sep 2020 22:12:24 +0200
Heiner Kallweit <hkallweit1@gmail.com> wrote:

> On 24.09.2020 21:14, Petr Tesarik wrote:
> > On Wed, 23 Sep 2020 11:57:41 +0200
> > Heiner Kallweit <hkallweit1@gmail.com> wrote:
> >=20
> >> On 03.09.2020 10:41, Petr Tesarik wrote:
> >>> Hi Heiner,
> >>>
> >>> this issue was on the back-burner for some time, but I've got some
> >>> interesting news now.
> >>>
> >>> On Sat, 18 Jul 2020 14:07:50 +0200
> >>> Heiner Kallweit <hkallweit1@gmail.com> wrote:
> >>>  =20
> >>>> [...]
> >>>> Maybe the following gives us an idea:
> >>>> Please do "ethtool -d <if>" after boot and after resume from suspend,
> >>>> and check for differences. =20
> >>>
> >>> The register dump did not reveal anything of interest - the only
> >>> differences were in the physical addresses after a device reopen.
> >>>
> >>> However, knowing that reloading the driver can fix the issue, I copied
> >>> the initialization sequence from init_one() to rtl8169_resume() and
> >>> gave it a try. That works!
> >>>
> >>> Then I started removing the initialization calls one by one. This
> >>> exercise left me with a call to rtl_init_rxcfg(), which simply sets t=
he
> >>> RxConfig register. In other words, these is the difference between
> >>> 5.8.4 and my working version:
> >>>
> >>> --- linux-orig/drivers/net/ethernet/realtek/r8169_main.c	2020-09-02 2=
2:43:09.361951750 +0200
> >>> +++ linux/drivers/net/ethernet/realtek/r8169_main.c	2020-09-03 10:36:=
23.915803703 +0200
> >>> @@ -4925,6 +4925,9 @@
> >>> =20
> >>>  	clk_prepare_enable(tp->clk);
> >>> =20
> >>> +	if (tp->mac_version =3D=3D RTL_GIGA_MAC_VER_37)
> >>> +		RTL_W32(tp, RxConfig, RX128_INT_EN | RX_DMA_BURST);
> >>> +
> >>>  	if (netif_running(tp->dev))
> >>>  		__rtl8169_resume(tp);
> >>> =20
> >>> This is quite surprising, at least when the device is managed by
> >>> NetworkManager, because then it is closed on wakeup, and the open
> >>> method should call rtl_init_rxcfg() anyway. So, it might be a timing
> >>> issue, or incorrect order of register writes.
> >>>  =20
> >> Thanks for the analysis. If you manually bring down and up the
> >> interface, do you see the same issue?
> >=20
> > I'm not quite sure what you mean, but if the interface is configured
> > (and NetworkManager is stopped), I can do 'ip link set eth0 down' and
> > then 'ip link set eth0 up', and the interface is fully functional.
> >=20
> >> What is the value of RxConfig when entering the resume function?
> >=20
> > I added a dev_info() to rtl8169_resume(). First with NetworkManager
> > active (i.e. interface down on suspend):
> >=20
> > [  525.956675] r8169 0000:03:00.2: RxConfig after resume: 0x0002400f
> >=20
> > Then I re-tried with NetworkManager stopped (i.e. interface up on
> > suspend). Same result:
> >=20
> > [  785.413887] r8169 0000:03:00.2: RxConfig after resume: 0x0002400f
> >=20
> > I hope that's what you were asking for...
> >=20
> > Petr T
> >=20
>=20
> rtl8169_resume() has been changed in 5.9, therefore the patch doesn't
> apply cleanly on older kernel versions. Can you test the following
> on a 5.9-rc version or linux-next?

I tried installing 5.9-rc6, but it freezes hard at boot, last message is:

[   14.916259] libphy: r8169: probed

At this point, I suspect you're right that the BIOS is seriously buggy.
Let me check if ASUSTek has released any update for this model.

Thanks for your effort so far!

Petr T

--Sig_/KSXtigMn0BwY3w9s.z/B=4F
Content-Type: application/pgp-signature
Content-Description: Digitální podpis OpenPGP

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHl2YIZkIo5VO2MxYqlA7ya4PR6cFAl9tnJ0ACgkQqlA7ya4P
R6ckDwf/SmjxT6foW7dI7hYe8HLvM0zD0wuW5DFcbheXHbx/qN7u6fd6mdHf2UdQ
UaidgwX7muYT5eSxx14rw8EQiIyaJeO+eiAbA44EPXTsQyKY+LrmOOIhBHRXbtkx
cniwaE/qUadRC6CtEEOwFCpjWBiSN9uYXBjk+8rDQtoOyYnf9Vwau+s8XiWJ0WID
V/wMT46GYagEyfF+TZc6D3nh54azCxJ4Q+u/F1h7X8M+p6bdXyCdgDJhtBUaHxyq
X9fg1R5lAjCtes0KqMUDwY1s4UewkLrZM57qIPWInsmfQn1GIrCmYD8XfGQKwAvU
mHZSPd6kafEkaZooRPHJlPb/JM0uPw==
=OPnQ
-----END PGP SIGNATURE-----

--Sig_/KSXtigMn0BwY3w9s.z/B=4F--
