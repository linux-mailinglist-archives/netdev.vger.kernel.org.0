Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5033362F05
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 05:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbfGIDqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 23:46:49 -0400
Received: from ozlabs.org ([203.11.71.1]:52477 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbfGIDqt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 23:46:49 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45jStB5NYqz9sBt;
        Tue,  9 Jul 2019 13:46:42 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1562644006;
        bh=nHzLCbzwOV9uhVfOZRGsKJkoxc4O3gqIAXYqO/91fd8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V3cyEHLM+b1ErXqO42BE4qh31+NWL8ijE4USSnd2m9UrdsJV4kD5EwYh5icdQ5SXI
         5YuWiqBfdFUgyEW8mxd4ZhSu46fanoC5uVeBF+XO8aMuEVATqWwIheIaGx1Wmyjsk0
         P6tF7hv+xXZQpz8rOiePEnb+JcYBCP4yy/gd0zW5+/2r22qfTeYuk8poUlv5cDm0aI
         vZFhm/JMtv4OCvColW+1EUXIKvCupjp4c6MBwakTssrGz+Ureo/ucZ3Y9W/5XHUu0G
         CMPGGx+z+GHlEdipTMSCo+ajTo+84Vu/ag5pyznX41si4D/RbIHtfCGsdg3mAxT7r9
         rw71y6HCVLPPg==
Date:   Tue, 9 Jul 2019 13:46:42 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christian Lamparter <chunkeey@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the tip tree
Message-ID: <20190709134642.626a24ad@canb.auug.org.au>
In-Reply-To: <20190625160432.533aa140@canb.auug.org.au>
References: <20190625160432.533aa140@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/+ae4Rc7ixR6m4km5K/=mPG7"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/+ae4Rc7ixR6m4km5K/=mPG7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 25 Jun 2019 16:04:32 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
>=20
> drivers/net/wireless/intersil/p54/txrx.c: In function 'p54_rx_data':
> drivers/net/wireless/intersil/p54/txrx.c:386:28: error: implicit declarat=
ion of function 'ktime_get_boot_ns'; did you mean 'ktime_get_raw_ns'? [-Wer=
ror=3Dimplicit-function-declaration]
>    rx_status->boottime_ns =3D ktime_get_boot_ns();
>                             ^~~~~~~~~~~~~~~~~
>                             ktime_get_raw_ns
>=20
> Caused by commit
>=20
>   c11c75ec784e ("p54: Support boottime in scan results")
>=20
> from the wireless-drivers-next tree interacting with commit
>=20
>   9285ec4c8b61 ("timekeeping: Use proper clock specifier names in functio=
ns")
>=20
> from the tip tree.
>=20
> I have added the following merge fix patch:
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 25 Jun 2019 15:55:36 +1000
> Subject: [PATCH] p54: fix up for ktime_get_boot_ns() name change
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/net/wireless/intersil/p54/txrx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/wireless/intersil/p54/txrx.c b/drivers/net/wirel=
ess/intersil/p54/txrx.c
> index be6968454282..873fea59894f 100644
> --- a/drivers/net/wireless/intersil/p54/txrx.c
> +++ b/drivers/net/wireless/intersil/p54/txrx.c
> @@ -383,7 +383,7 @@ static int p54_rx_data(struct p54_common *priv, struc=
t sk_buff *skb)
> =20
>  	fc =3D ((struct ieee80211_hdr *)skb->data)->frame_control;
>  	if (ieee80211_is_probe_resp(fc) || ieee80211_is_beacon(fc))
> -		rx_status->boottime_ns =3D ktime_get_boot_ns();
> +		rx_status->boottime_ns =3D ktime_get_boottime_ns();
> =20
>  	if (unlikely(priv->hw->conf.flags & IEEE80211_CONF_PS))
>  		p54_pspoll_workaround(priv, skb);

This patch is now needed in the merge between the net-next tree and
Linus' tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/+ae4Rc7ixR6m4km5K/=mPG7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0kDiIACgkQAVBC80lX
0GzYZgf9HOLssZn+Arsy5zw2mfgZzL6iIJTq68XoSSRDf65s/4MCU2z0I7QMcG70
a4b0mUsOI1av46cVqOuDYoB9j1LpQoRg8BI5Tq1pu+/z1AJ41Slzmg86kwrB/HPy
uua7aNow181mziJUIa4RMWPHUI4I4+W4RMpUIP3M51GEtd6Nyvwk7csf+XpcDuOn
2OY7oRgY5RIba6ahi/e+Jgll05qZQMx1I5KHKcA5B9x6UB+TccyMv4dkVjG2CH0a
F4bbL1okSgAkd3aB5mqUrGyzC2eQsVdoxO5HqN737mzdUHHwLEChWX1oPgJj4pSr
dm0shAudcD5hGyh9+/YVhH2ohs8v+g==
=fM1z
-----END PGP SIGNATURE-----

--Sig_/+ae4Rc7ixR6m4km5K/=mPG7--
