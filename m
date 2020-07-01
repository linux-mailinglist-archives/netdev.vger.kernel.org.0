Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D176210B65
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 14:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730680AbgGAM5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 08:57:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:60264 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730581AbgGAM5t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 08:57:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A6BAEADE2;
        Wed,  1 Jul 2020 12:57:47 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 13244604DC; Wed,  1 Jul 2020 14:57:47 +0200 (CEST)
Date:   Wed, 1 Jul 2020 14:57:47 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Song Liu <songliubraving@fb.com>,
        Valdis Kl =?utf-8?B?xJM=?= tnieks <valdis.kletnieks@vt.edu>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH] bpfilter: allow to build bpfilter_umh as a module
 without static library
Message-ID: <20200701125747.wu6442a5vr5phzoh@lion.mk-sys.cz>
References: <20200701092644.762234-1-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gyz6kzseltosq2ow"
Content-Disposition: inline
In-Reply-To: <20200701092644.762234-1-masahiroy@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--gyz6kzseltosq2ow
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 01, 2020 at 06:26:44PM +0900, Masahiro Yamada wrote:
> Originally, bpfilter_umh was linked with -static only when
> CONFIG_BPFILTER_UMH=3Dy.
>=20
> Commit 8a2cc0505cc4 ("bpfilter: use 'userprogs' syntax to build
> bpfilter_umh") silently, accidentally dropped the CONFIG_BPFILTER_UMH=3Dy
> test in the Makefile. Revive it in order to link it dynamically when
> CONFIG_BPFILTER_UMH=3Dm.
>=20
> Since commit b1183b6dca3e ("bpfilter: check if $(CC) can link static
> libc in Kconfig"), the compiler must be capable of static linking to
> enable CONFIG_BPFILTER_UMH, but it requires more than needed.
>=20
> To loosen the compiler requirement, I changed the dependency as follows:
>=20
>     depends on CC_CAN_LINK
>     depends on m || CC_CAN_LINK_STATIC
>=20
> If CONFIG_CC_CAN_LINK_STATIC in unset, CONFIG_BPFILTER_UMH is restricted
> to 'm' or 'n'.
>=20
> In theory, CONFIG_CC_CAN_LINK is not required for CONFIG_BPFILTER_UMH=3Dy,
> but I did not come up with a good way to describe it.
>=20
> Fixes: 8a2cc0505cc4 ("bpfilter: use 'userprogs' syntax to build bpfilter_=
umh")
> Reported-by: Michal Kubecek <mkubecek@suse.cz>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>

Tested-by: Michal Kubecek <mkubecek@suse.cz>

Thank you,
Michal

> ---
>=20
>  net/bpfilter/Kconfig  | 10 ++++++----
>  net/bpfilter/Makefile |  2 ++
>  2 files changed, 8 insertions(+), 4 deletions(-)
>=20
> diff --git a/net/bpfilter/Kconfig b/net/bpfilter/Kconfig
> index 84015ef3ee27..73d0b12789f1 100644
> --- a/net/bpfilter/Kconfig
> +++ b/net/bpfilter/Kconfig
> @@ -9,12 +9,14 @@ menuconfig BPFILTER
>  if BPFILTER
>  config BPFILTER_UMH
>  	tristate "bpfilter kernel module with user mode helper"
> -	depends on CC_CAN_LINK_STATIC
> +	depends on CC_CAN_LINK
> +	depends on m || CC_CAN_LINK_STATIC
>  	default m
>  	help
>  	  This builds bpfilter kernel module with embedded user mode helper
> =20
> -	  Note: your toolchain must support building static binaries, since
> -	  rootfs isn't mounted at the time when __init functions are called
> -	  and do_execv won't be able to find the elf interpreter.
> +	  Note: To compile this as built-in, your toolchain must support
> +	  building static binaries, since rootfs isn't mounted at the time
> +	  when __init functions are called and do_execv won't be able to find
> +	  the elf interpreter.
>  endif
> diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
> index f23b53294fba..cdac82b8c53a 100644
> --- a/net/bpfilter/Makefile
> +++ b/net/bpfilter/Makefile
> @@ -7,10 +7,12 @@ userprogs :=3D bpfilter_umh
>  bpfilter_umh-objs :=3D main.o
>  userccflags +=3D -I $(srctree)/tools/include/ -I $(srctree)/tools/includ=
e/uapi
> =20
> +ifeq ($(CONFIG_BPFILTER_UMH), y)
>  # builtin bpfilter_umh should be linked with -static
>  # since rootfs isn't mounted at the time of __init
>  # function is called and do_execv won't find elf interpreter
>  userldflags +=3D -static
> +endif
> =20
>  $(obj)/bpfilter_umh_blob.o: $(obj)/bpfilter_umh
> =20
> --=20
> 2.25.1
>=20

--gyz6kzseltosq2ow
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl78iEoACgkQ538sG/LR
dpWAzAf/anZ96cIZ4DlFNa9GThY9O1+XsFFj/6av5YNogxsfciAMQZECXJvtdYhQ
JlMcWVS2mFxSURSdP8U2fuOnT58SsZ1cc+/Zy4z3576i8ovIV2TZocOcfxtC0azh
/SO2kZFHIDot+rdxWv56bPoa6XKJEJguk2Am8JUf0C6WBaRHZiY+Wl6DbrmKeZTd
DOIh5KSR1+ovROcfX6iHiciQi0r5f2sYENNuXeJ8RJJOcM0PYIk1a0bc4HQpQlo8
1vU8lfZywgtC2PIGlYHA4I5GL3b1wDghZ3GHkMxyXFzrNb29AObaFhwSLOT5swmf
Y9NPAkvFEVT7SGu7LOi6pF85jlSTdw==
=DLqC
-----END PGP SIGNATURE-----

--gyz6kzseltosq2ow--
