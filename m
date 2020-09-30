Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E82F427F114
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 20:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729157AbgI3SK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 14:10:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:36382 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgI3SK7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 14:10:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1A30AB26F;
        Wed, 30 Sep 2020 18:10:57 +0000 (UTC)
Date:   Wed, 30 Sep 2020 20:10:53 +0200
From:   Petr Tesarik <ptesarik@suse.cz>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        netdev@vger.kernel.org, linux-clk@vger.kernel.org
Subject: Re: RTL8402 stops working after hibernate/resume
Message-ID: <20200930201053.02a3b835@ezekiel.suse.cz>
In-Reply-To: <8a82a023-e361-79db-7127-769e4f6e0d1b@gmail.com>
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
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/akZ6/zfUjEjU8n0sdptnAwv";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/akZ6/zfUjEjU8n0sdptnAwv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Sep 2020 17:47:15 +0200
Heiner Kallweit <hkallweit1@gmail.com> wrote:

>[...]
> Petr,
> in the following I send two patches. First one is supposed to fix the fre=
eze.
> It also fixes another issue that existed before my ether_clk change:
> ether_clk was disabled on suspend even if WoL is enabled. And the network
> chip most likely needs the clock to check for WoL packets.
> Please let me know whether it fixes the freeze, then I'll add your Tested=
-by.
>=20
> Second patch is a re-send of the one I sent before, it should fix
> the rx issues after resume from suspend for you.
>=20
>[...]
>=20
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethe=
rnet/realtek/r8169_main.c
> index 9e4e6a883..4fb49fd0d 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -4837,6 +4837,10 @@ static int rtl8169_resume(struct device *device)
> =20
>  	rtl_rar_set(tp, tp->dev->dev_addr);
> =20
> +	/* Reportedly at least Asus X453MA corrupts packets otherwise */

Just a nitpick: The incoming packets are not corrupted, they are truncated:

+	/* Reportedly at least Asus X453MA truncates packets otherwise */

Other than that, like I have already written in another part of the thread:

Tested-by: Petr Tesarik <ptesarik@suse.com>

> +	if (tp->mac_version =3D=3D RTL_GIGA_MAC_VER_37)
> +		rtl_init_rxcfg(tp);
> +
>  	if (tp->TxDescArray)
>  		rtl8169_up(tp);
> =20
> --=20
> 2.28.0
>=20

--Sig_/akZ6/zfUjEjU8n0sdptnAwv
Content-Type: application/pgp-signature
Content-Description: Digitální podpis OpenPGP

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHl2YIZkIo5VO2MxYqlA7ya4PR6cFAl90yi0ACgkQqlA7ya4P
R6cJlAf/VedwPuX55jL7gHEpYR6OY4i30Qri47TNzoM5z5tTwuwTicWzkOdphNHj
81jdXfa9A3NFL/Cj+LAYrwJ1bzV++FzeZ3r4D/zr7FlOwYlswW1LR0j6GVSvavSv
BaoMSJ/aYCZyP8me73Ci8HFWg0y43Z1/We6G7TYblhkRF2QFWlXIJUnVmCWM5ryc
F6IxKL7NYNDSFzz7di0UTNxbQT8hHQeZGPERtsrphmf9oZRpGRPq4YImANOMd0Fq
Ae7ZO0Vul7ZnmQ9Nt/P2RyE8rkHm9wSt14DZ/GNc6wR68Q7ZhQ/RnxmylbaWFHA8
HzOHcqoK/QaqGzRfQ1Rn34MonuWQ4Q==
=q+Mq
-----END PGP SIGNATURE-----

--Sig_/akZ6/zfUjEjU8n0sdptnAwv--
