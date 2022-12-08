Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFB364694D
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 07:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbiLHGeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 01:34:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiLHGeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 01:34:36 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C45AABA1E
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 22:34:34 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 0C33C22CE9;
        Thu,  8 Dec 2022 06:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1670481273; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HSajmult3NexIlzG+tkwCWKMQl0a9OWw96iK+rEe3Oc=;
        b=rIiTAlIswxzVpCRKONzrjeeI3MYACZZMWcfMwaNQPSBu58+xGr0Iia81iRwLamdNW0Hbge
        Y4qIcF5/A3wFI2DpJK2xBdPX+SEIHQAAsVW59rH/dq7oAgtmf7lgD79xFLzmUhTi5lgCwd
        8zxaPfLKsXleKKymnlz5djklBnjIkc8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1670481273;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HSajmult3NexIlzG+tkwCWKMQl0a9OWw96iK+rEe3Oc=;
        b=FlCwG8jPSONF03+FfHPL8J9K/GzotmAyr2qxMbjiLls+sPIgko4POCej/9b43RDPj+AdIE
        ZcxBLnfVwMTA0PBw==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 037292C141;
        Thu,  8 Dec 2022 06:34:33 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id CC6786045E; Thu,  8 Dec 2022 07:34:32 +0100 (CET)
Date:   Thu, 8 Dec 2022 07:34:32 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool v2 08/13] ethtool: fix runtime errors found by
 sanitizers
Message-ID: <20221208063432.rt3iunzactq6bxcp@lion.mk-sys.cz>
References: <20221208011122.2343363-1-jesse.brandeburg@intel.com>
 <20221208011122.2343363-9-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="btf7s52l3lzywb2u"
Content-Disposition: inline
In-Reply-To: <20221208011122.2343363-9-jesse.brandeburg@intel.com>
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--btf7s52l3lzywb2u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 07, 2022 at 05:11:17PM -0800, Jesse Brandeburg wrote:
> The sanitizers[1] found a couple of things, but this change addresses
> some bit shifts that cannot be contained by the target type.
>=20
> The mistake is that the code is using unsigned int a =3D (1 << N) all over
> the place, but the appropriate way to code this is unsigned int an
> assignment of (1UL << N) especially if N can ever be 31.
>=20
> Fix the most egregious of these problems by changing "1" to "1UL", as
> per it would be if we had used the BIT() macro.
>=20
> [1] make CFLAGS+=3D'-fsanitize=3Daddress,undefined' \
>          LDFLAGS+=3D'-lubsan -lasan'
>=20
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---
>  amd8111e.c         | 2 +-
>  internal.h         | 4 ++--
>  netlink/features.c | 4 ++--
>  3 files changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/amd8111e.c b/amd8111e.c
> index 175516bd2904..5a2fc2082e55 100644
> --- a/amd8111e.c
> +++ b/amd8111e.c
> @@ -75,7 +75,7 @@ typedef enum {
>  }CMD3_BITS;
>  typedef enum {
> =20
> -	INTR			=3D (1 << 31),
> +	INTR			=3D (1UL << 31),
>  	PCSINT			=3D (1 << 28),
>  	LCINT			=3D (1 << 27),
>  	APINT5			=3D (1 << 26),

While the signedness issue only directly affects only INTR value,
I would rather prefer to keep the code consistent and fix the whole enum.
Also, as you intend to introduce the BIT() macro in the series anyway,
wouldn't it be cleaner to move this patch after the UAPI update and use
BIT() instead?

Michal

--btf7s52l3lzywb2u
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmORhXMACgkQ538sG/LR
dpWT6wf/R/p4U6iOf4fXAt+cVY4fBSRBEyvYxBio93xPFStm8yhtw0wF5hrAEGQ3
VpV7Z31nWOZpUf+GqEz656U6xIUsjRD+zvii6gKai1Js4KW0Kvb39V7uyL7NKg5w
TVEpYJZnMNdT8vkjnRnys/lVInOuFaqfpUbQDKkKwnlZE1F3hyWJAHnY375TKMyR
cPr6rObz+WvnIv5apcsK8rqhyUWHakH8WmxsSuLGxoTrS0G6FBo/U/7Y0lXcfgyq
uNj2LoDP6VXGiId8c7vD5BP4CAELpIDBjTe5lf3TOc4xExnFdEWmSbdzgpoh0X3q
ThchXG3D1faD020SD8d7j7kqEO9+Fg==
=4VkE
-----END PGP SIGNATURE-----

--btf7s52l3lzywb2u--
