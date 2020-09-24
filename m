Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E46B5277900
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 21:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgIXTO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 15:14:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:34020 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726841AbgIXTOu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 15:14:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 19E71B214;
        Thu, 24 Sep 2020 19:14:48 +0000 (UTC)
Date:   Thu, 24 Sep 2020 21:14:44 +0200
From:   Petr Tesarik <ptesarik@suse.cz>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        netdev@vger.kernel.org
Subject: Re: RTL8402 stops working after hibernate/resume
Message-ID: <20200924211444.3ba3874b@ezekiel.suse.cz>
In-Reply-To: <7e6bbb75-d8db-280d-ac5b-86013af39071@gmail.com>
References: <20200715102820.7207f2f8@ezekiel.suse.cz>
        <d742082e-42a1-d904-8a8f-4583944e88e1@gmail.com>
        <20200716105835.32852035@ezekiel.suse.cz>
        <e1c7a37f-d8d0-a773-925c-987b92f12694@gmail.com>
        <20200903104122.1e90e03c@ezekiel.suse.cz>
        <7e6bbb75-d8db-280d-ac5b-86013af39071@gmail.com>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/S=KpOjnIT.Tv_yD59wCi/ws";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/S=KpOjnIT.Tv_yD59wCi/ws
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 23 Sep 2020 11:57:41 +0200
Heiner Kallweit <hkallweit1@gmail.com> wrote:

> On 03.09.2020 10:41, Petr Tesarik wrote:
> > Hi Heiner,
> >=20
> > this issue was on the back-burner for some time, but I've got some
> > interesting news now.
> >=20
> > On Sat, 18 Jul 2020 14:07:50 +0200
> > Heiner Kallweit <hkallweit1@gmail.com> wrote:
> >  =20
> >> [...]
> >> Maybe the following gives us an idea:
> >> Please do "ethtool -d <if>" after boot and after resume from suspend,
> >> and check for differences. =20
> >=20
> > The register dump did not reveal anything of interest - the only
> > differences were in the physical addresses after a device reopen.
> >=20
> > However, knowing that reloading the driver can fix the issue, I copied
> > the initialization sequence from init_one() to rtl8169_resume() and
> > gave it a try. That works!
> >=20
> > Then I started removing the initialization calls one by one. This
> > exercise left me with a call to rtl_init_rxcfg(), which simply sets the
> > RxConfig register. In other words, these is the difference between
> > 5.8.4 and my working version:
> >=20
> > --- linux-orig/drivers/net/ethernet/realtek/r8169_main.c	2020-09-02 22:=
43:09.361951750 +0200
> > +++ linux/drivers/net/ethernet/realtek/r8169_main.c	2020-09-03 10:36:23=
.915803703 +0200
> > @@ -4925,6 +4925,9 @@
> > =20
> >  	clk_prepare_enable(tp->clk);
> > =20
> > +	if (tp->mac_version =3D=3D RTL_GIGA_MAC_VER_37)
> > +		RTL_W32(tp, RxConfig, RX128_INT_EN | RX_DMA_BURST);
> > +
> >  	if (netif_running(tp->dev))
> >  		__rtl8169_resume(tp);
> > =20
> > This is quite surprising, at least when the device is managed by
> > NetworkManager, because then it is closed on wakeup, and the open
> > method should call rtl_init_rxcfg() anyway. So, it might be a timing
> > issue, or incorrect order of register writes.
> >  =20
> Thanks for the analysis. If you manually bring down and up the
> interface, do you see the same issue?

I'm not quite sure what you mean, but if the interface is configured
(and NetworkManager is stopped), I can do 'ip link set eth0 down' and
then 'ip link set eth0 up', and the interface is fully functional.

> What is the value of RxConfig when entering the resume function?

I added a dev_info() to rtl8169_resume(). First with NetworkManager
active (i.e. interface down on suspend):

[  525.956675] r8169 0000:03:00.2: RxConfig after resume: 0x0002400f

Then I re-tried with NetworkManager stopped (i.e. interface up on
suspend). Same result:

[  785.413887] r8169 0000:03:00.2: RxConfig after resume: 0x0002400f

I hope that's what you were asking for...

Petr T

--Sig_/S=KpOjnIT.Tv_yD59wCi/ws
Content-Type: application/pgp-signature
Content-Description: Digitální podpis OpenPGP

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHl2YIZkIo5VO2MxYqlA7ya4PR6cFAl9s8CQACgkQqlA7ya4P
R6eVNQf9GsBZn3M/nnrV62bvT3kyF42/y/Fk69eMbRxlOXaEmbcEoGUB5HZRsfre
DPti+5q9heWSmUedWt80V/KF+fJcBm4GevdUXF9/KjUJhs0Xc8XmHpu1VHNN2PnY
Ecgd1Nhi0LwzX8eWZG0j+4wLG4ZrfnR7bBH27dKpcUqa5HUP1RBPC7C4uC6MM0//
W8JIJ905rujiBg0ZfERk6BDdI02ClnTNBhGtdSKPI3LEu8wHe8vMNogk/XnVLJ9e
AsbRk5qHroBtMoTGcrLSqEUnxXqp9MxV3ION5UGU0jqfii3/gVin7o5JUinVXHd+
I5XVK4a3IO9AdJzhT4A9JjHjeny3Fw==
=ohqy
-----END PGP SIGNATURE-----

--Sig_/S=KpOjnIT.Tv_yD59wCi/ws--
