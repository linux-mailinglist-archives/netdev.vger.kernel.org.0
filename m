Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82BB227F097
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 19:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731428AbgI3RdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 13:33:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:47528 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgI3RdH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 13:33:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F160EABE3;
        Wed, 30 Sep 2020 17:33:05 +0000 (UTC)
Date:   Wed, 30 Sep 2020 19:32:59 +0200
From:   Petr Tesarik <ptesarik@suse.cz>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        netdev@vger.kernel.org
Subject: Re: RTL8402 stops working after hibernate/resume
Message-ID: <20200930193231.205ee7bd@ezekiel.suse.cz>
In-Reply-To: <20200930184124.68a86b1d@ezekiel.suse.cz>
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
        <20200929210737.7f4a6da7@ezekiel.suse.cz>
        <217ae37d-f2b0-1805-5696-11644b058819@redhat.com>
        <5f2d3d48-9d1d-e9fe-49bc-d1feeb8a92eb@gmail.com>
        <1c2d888a-5702-cca9-195c-23c3d0d936b9@redhat.com>
        <8a82a023-e361-79db-7127-769e4f6e0d1b@gmail.com>
        <20200930184124.68a86b1d@ezekiel.suse.cz>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/8iCcC0dje9QsRLffn29/8ty";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/8iCcC0dje9QsRLffn29/8ty
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Heiner,

On Wed, 30 Sep 2020 18:41:24 +0200
Petr Tesarik <ptesarik@suse.cz> wrote:

> HI Heiner,
>=20
> On Wed, 30 Sep 2020 17:47:15 +0200
> Heiner Kallweit <hkallweit1@gmail.com> wrote:
>[...]
> > Petr,
> > in the following I send two patches. First one is supposed to fix the f=
reeze.
> > It also fixes another issue that existed before my ether_clk change:
> > ether_clk was disabled on suspend even if WoL is enabled. And the netwo=
rk
> > chip most likely needs the clock to check for WoL packets. =20
>=20
> Should I also check whether WoL works? Plus, it would be probably good
> if I could check whether it indeed didn't work before the change. ;-)
>=20
> > Please let me know whether it fixes the freeze, then I'll add your
> >   Tested-by. =20
>=20
> Will do.

Here are the results:

- WoL does not work without your patch; this was tested with 5.8.4,
  because master freezes hard on load.

- I got a kernel crash when I woke up the laptop through keyboard; I am
  not sure if it is related, although I could spend some time looking
  at the resulting crash dump if you think it's worth the time.

- After applying your first patch on top of v5.9-rc6, the driver can be
  loaded, but stops working properly on suspend/resume.

- WoL still does not work, but I'm no longer getting a kernel crash at
  least. ;-)

Tested-by: Petr Tesarik <ptesarik@suse.com>

> > Second patch is a re-send of the one I sent before, it should fix
> > the rx issues after resume from suspend for you. =20
>=20
> All right, going to rebuild the kernel and see how it goes.

This second patch does not fix suspend/resume for me, unfortunately. The
receive is still erratic, but the behaviour is now different: some
packets are truncated, other packets are delayed by approx. 1024 ms.
Yes, 1024 may ring a bell, but I've no idea which.

HTH,
Petr T

> Stay tuned,
> Petr T
>=20
>=20
> > diff --git a/drivers/net/ethernet/realtek/r8169_main.c
> >   b/drivers/net/ethernet/realtek/r8169_main.c index
> >   6c7c004c2..72351c5b0 100644 ---
> >   a/drivers/net/ethernet/realtek/r8169_main.c +++
> >   b/drivers/net/ethernet/realtek/r8169_main.c @@ -2236,14 +2236,10
> >   @@ static void rtl_pll_power_down(struct rtl8169_private *tp)
> >   default: break;
> >  	}
> > -
> > -	clk_disable_unprepare(tp->clk);
> >  }
> > =20
> >  static void rtl_pll_power_up(struct rtl8169_private *tp)
> >  {
> > -	clk_prepare_enable(tp->clk);
> > -
> >  	switch (tp->mac_version) {
> >  	case RTL_GIGA_MAC_VER_25 ... RTL_GIGA_MAC_VER_33:
> >  	case RTL_GIGA_MAC_VER_37:
> > @@ -4820,29 +4816,39 @@ static void rtl8169_net_suspend(struct
> >   rtl8169_private *tp)=20
> >  #ifdef CONFIG_PM
> > =20
> > +static int rtl8169_net_resume(struct rtl8169_private *tp)
> > +{
> > +	rtl_rar_set(tp, tp->dev->dev_addr);
> > +
> > +	if (tp->TxDescArray)
> > +		rtl8169_up(tp);
> > +
> > +	netif_device_attach(tp->dev);
> > +
> > +	return 0;
> > +}
> > +
> >  static int __maybe_unused rtl8169_suspend(struct device *device)
> >  {
> >  	struct rtl8169_private *tp =3D dev_get_drvdata(device);
> > =20
> >  	rtnl_lock();
> >  	rtl8169_net_suspend(tp);
> > +	if (!device_may_wakeup(tp_to_dev(tp)))
> > +		clk_disable_unprepare(tp->clk);
> >  	rtnl_unlock();
> > =20
> >  	return 0;
> >  }
> > =20
> > -static int rtl8169_resume(struct device *device)
> > +static int __maybe_unused rtl8169_resume(struct device *device)
> >  {
> >  	struct rtl8169_private *tp =3D dev_get_drvdata(device);
> > =20
> > -	rtl_rar_set(tp, tp->dev->dev_addr);
> > -
> > -	if (tp->TxDescArray)
> > -		rtl8169_up(tp);
> > +	if (!device_may_wakeup(tp_to_dev(tp)))
> > +		clk_prepare_enable(tp->clk);
> > =20
> > -	netif_device_attach(tp->dev);
> > -
> > -	return 0;
> > +	return rtl8169_net_resume(tp);
> >  }
> > =20
> >  static int rtl8169_runtime_suspend(struct device *device)
> > @@ -4868,7 +4874,7 @@ static int rtl8169_runtime_resume(struct
> >   device *device)=20
> >  	__rtl8169_set_wol(tp, tp->saved_wolopts);
> > =20
> > -	return rtl8169_resume(device);
> > +	return rtl8169_net_resume(tp);
> >  }
> > =20
> >  static int rtl8169_runtime_idle(struct device *device) =20
>=20


--Sig_/8iCcC0dje9QsRLffn29/8ty
Content-Type: application/pgp-signature
Content-Description: Digitální podpis OpenPGP

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHl2YIZkIo5VO2MxYqlA7ya4PR6cFAl90wUsACgkQqlA7ya4P
R6cRxwf8Cl/IUwG/SO2KIf4McAU0hOPMrgHxZcZ9o1b1giFKlCoY6HZxnK8/bsOx
wogQmzmsjWxBKHxk1iQXst6dk9bYoGdV4ALxdUcCYa/UaGJxJhYFc3pv16B2B2Y+
JjHqgxdXn8TxdeTGMmSFAb36ryqGlX4j/mtBApSHlvT4rzRJN3bzU9iMKH9qYYJR
OLBmRHTf5lRUsXA43CSAQsy5sP0/gNh24esQMPLfBMDhFlKcSk///JPLZLWRqSjQ
0PN8ydD0c09tWNsX6mYHZGuKTnhAbCSSO5fTQSEgdJhL2ku1RKjeNpRo6ZS6EdW5
4nYdCD42gXzvdJd9omyXPhGJw+IzrQ==
=q08E
-----END PGP SIGNATURE-----

--Sig_/8iCcC0dje9QsRLffn29/8ty--
