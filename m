Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D64264B33FC
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 10:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbiBLJIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 04:08:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiBLJI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 04:08:29 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2347026562
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 01:08:25 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nIoO9-00016V-1Y; Sat, 12 Feb 2022 10:08:17 +0100
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B3BCA31B4D;
        Sat, 12 Feb 2022 09:08:14 +0000 (UTC)
Date:   Sat, 12 Feb 2022 10:08:11 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Kees Cook <keescook@chromium.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: ether_addr_equal_64bits breakage with gcc-12
Message-ID: <20220212090811.uuzk6d76agw2vv73@pengutronix.de>
References: <20220211141213.l4yitk7aifehjymp@pengutronix.de>
 <20220211163541.74b0836a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <202202111642.EF22DF8BD@keescook>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="uqh7zxeyod76cbzi"
Content-Disposition: inline
In-Reply-To: <202202111642.EF22DF8BD@keescook>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--uqh7zxeyod76cbzi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11.02.2022 17:31:22, Kees Cook wrote:
> > Maybe Kees will have as suggestion - Kees, are there any best practices
> > for dealing with such issues? For the reference we do a oversized load
> > from a structure (read 8B of a 6B array):
>=20
> Wheee.
>=20
> So, the short theoretical "don't do that" scenario would be "what
> happens if":
>=20
>         struct page *page;
>         void *ptr;
> 	unsigned char *eth_addr;
>=20
>         page =3D alloc_pages(GFP_KERNEL, 0);
> 	...
>         ptr =3D page_address(page);
> 	...
> 	/* "eth_addr" at end of allocated memory */
> 	eth_addr =3D ptr + PAGE_SIZE - 6;
> 	/* access fault... */
> 	ether_addr_equal_64bits(eth_addr, ...);
>=20
> But, yes, pragmatically, this is likely extremely rare.
>=20
> Regardless, with the other cases like this that got fixed like this, it
> was a matter of finding a way to represent the "actual" available memory
> (best), or telling the compiler what real contract is (less good).
>=20
> It looks like alignment isn't a concern, so I'd say adjust the prototype
> to reflect the reality, and go with:
>=20
>=20
> diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
> index 2ad71cc90b37..92b10e67d5f8 100644
> --- a/include/linux/etherdevice.h
> +++ b/include/linux/etherdevice.h
> @@ -134,7 +134,7 @@ static inline bool is_multicast_ether_addr(const u8 *=
addr)
>  #endif
>  }
> =20
> -static inline bool is_multicast_ether_addr_64bits(const u8 addr[6+2])
> +static inline bool is_multicast_ether_addr_64bits(const u8 *addr)
>  {
>  #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG =3D=
=3D 64
>  #ifdef __BIG_ENDIAN
> @@ -372,8 +372,7 @@ static inline bool ether_addr_equal(const u8 *addr1, =
const u8 *addr2)
>   * Please note that alignment of addr1 & addr2 are only guaranteed to be=
 16 bits.
>   */
> =20
> -static inline bool ether_addr_equal_64bits(const u8 addr1[6+2],
> -					   const u8 addr2[6+2])
> +static inline bool ether_addr_equal_64bits(const u8 *addr1, const u8 *ad=
dr2)
>  {
>  #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG =3D=
=3D 64
>  	u64 fold =3D (*(const u64 *)addr1) ^ (*(const u64 *)addr2);
>=20

With that patch the warning is gone.

Tested-by: Marc Kleine-Budde <mkl@pengutronix.de>

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--uqh7zxeyod76cbzi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmIHePYACgkQrX5LkNig
011SkggAjWSRWhce1rrBnJHKfqviU1UaABxvycRRC0enujdTJIHZS5QsFF3BPa8P
fyNuUkQF7xPjHry2R/kJH72adEOs7s1MA9o466FLPnCLeNn3jQ0ZPseVbovQfk68
YFNuZ+lSTmnNK2+A01Oo8Eo1C7DY2Nx/bT+Hv8EmnRMkiooJ7GypYQTkKNU8rkyd
LVJuhcEndU0tsbha/rPKi2ELX7g6X3qXSR/90Wq8tmgerQwaoVgjRk2SZOSo5xan
xzsDXlAINkgSmu4BzSe1C3HChloYzZdLU7NjvkAOuyxT7fsziC2yIhKDnuo/BLhn
AtR5xxlFU+/3cEFY2GBxyBK7W67K3g==
=/IHD
-----END PGP SIGNATURE-----

--uqh7zxeyod76cbzi--
