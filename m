Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C9726DDAA
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 16:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbgIQOLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 10:11:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:45450 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727331AbgIQOK5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 10:10:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9E8CBB297;
        Thu, 17 Sep 2020 14:11:23 +0000 (UTC)
Date:   Thu, 17 Sep 2020 16:10:44 +0200
From:   Petr Tesarik <ptesarik@suse.cz>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        netdev@vger.kernel.org
Subject: Re: RTL8402 stops working after hibernate/resume
Message-ID: <20200917161044.714521ff@ezekiel.suse.cz>
In-Reply-To: <20200903104122.1e90e03c@ezekiel.suse.cz>
References: <20200715102820.7207f2f8@ezekiel.suse.cz>
        <d742082e-42a1-d904-8a8f-4583944e88e1@gmail.com>
        <20200716105835.32852035@ezekiel.suse.cz>
        <e1c7a37f-d8d0-a773-925c-987b92f12694@gmail.com>
        <20200903104122.1e90e03c@ezekiel.suse.cz>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/+tZ1ZTMtZhHZDUUFMoQb6v1";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/+tZ1ZTMtZhHZDUUFMoQb6v1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Heiner,

any comment on my findings?

On Thu, 3 Sep 2020 10:41:22 +0200
Petr Tesarik <ptesarik@suse.cz> wrote:

> Hi Heiner,
>=20
> this issue was on the back-burner for some time, but I've got some
> interesting news now.
>=20
> On Sat, 18 Jul 2020 14:07:50 +0200
> Heiner Kallweit <hkallweit1@gmail.com> wrote:
>=20
> >[...]
> > Maybe the following gives us an idea:
> > Please do "ethtool -d <if>" after boot and after resume from suspend,
> > and check for differences. =20
>=20
> The register dump did not reveal anything of interest - the only
> differences were in the physical addresses after a device reopen.
>=20
> However, knowing that reloading the driver can fix the issue, I copied
> the initialization sequence from init_one() to rtl8169_resume() and
> gave it a try. That works!
>=20
> Then I started removing the initialization calls one by one. This
> exercise left me with a call to rtl_init_rxcfg(), which simply sets the
> RxConfig register. In other words, these is the difference between
> 5.8.4 and my working version:
>=20
> --- linux-orig/drivers/net/ethernet/realtek/r8169_main.c	2020-09-02 22:43=
:09.361951750 +0200
> +++ linux/drivers/net/ethernet/realtek/r8169_main.c	2020-09-03 10:36:23.9=
15803703 +0200
> @@ -4925,6 +4925,9 @@
> =20
>  	clk_prepare_enable(tp->clk);
> =20
> +	if (tp->mac_version =3D=3D RTL_GIGA_MAC_VER_37)
> +		RTL_W32(tp, RxConfig, RX128_INT_EN | RX_DMA_BURST);
> +
>  	if (netif_running(tp->dev))
>  		__rtl8169_resume(tp);
> =20
> This is quite surprising, at least when the device is managed by
> NetworkManager, because then it is closed on wakeup, and the open
> method should call rtl_init_rxcfg() anyway. So, it might be a timing
> issue, or incorrect order of register writes.
>=20
> Since I have no idea why the above change fixes my issue, I'm hesitant
> to post it as a patch. It might break other people's systems...

Petr T

--Sig_/+tZ1ZTMtZhHZDUUFMoQb6v1
Content-Type: application/pgp-signature
Content-Description: Digitální podpis OpenPGP

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHl2YIZkIo5VO2MxYqlA7ya4PR6cFAl9jbmQACgkQqlA7ya4P
R6d2NggA1k2BONNttO7ZM6XpTiea5D2fwNn3UAjDedurL7dlNGzLwcvIKkbAFbl4
oW7FWXovgCnHiPhWZelrTaVMQWzwMPRfh6Yr7GvLE+UjwR8obZniWM6TY72ZgSE+
l06hiQEWR2mRqMZb0L0t/MZD1+XHqeHR1GGhepQd8dxM8juCMp/hkrInHZaLx111
d9L2UOdQ24ZSl9tU7ntNsuMgGer9yxmns2FSXgPvYrJUy/3TA9G0/Je2uAC+Nyl2
4G+zhIEu4rTDmkhxU47n5cSmszr4hP20xCdahyckXTKah3Sb/ZpynpYSMIO74whj
2GIOkNfOlBXLhQkG8YMMW7rYFz3QYQ==
=E450
-----END PGP SIGNATURE-----

--Sig_/+tZ1ZTMtZhHZDUUFMoQb6v1--
