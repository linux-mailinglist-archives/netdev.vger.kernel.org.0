Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBFC462D11
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 02:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbfGIA1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 20:27:34 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:49499 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbfGIA1e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 20:27:34 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45jNSK1HYJz9s8m;
        Tue,  9 Jul 2019 10:27:29 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1562632050;
        bh=jKvKlrFXe07Fpw3txFGQXGR5J2AXGtNYEGJMdD5adJ0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ljg9018W1CfPYY7OP0Z79VM7KwIphqePyLGfwxoBC2GcxeRzvtnjBGKFYKuZFlxxE
         y56glV/BvdwfbObqPEnEWqd8Y1j777rM15dJ1+qktiyYmZz9X8s86WJPg7HCF6753o
         ogO9vk7rD+9xIiFVtqLSNJBNFF+tBkwATXOUsJPxDH5Qr31l1v7RPF7OzgsAxtv1M1
         AXvHxBIjCw1/uaR91VCKnXf5a0s1AYClAjLKjfwbTRY6cgnahAEkCag7PvuIYITwiS
         JWpOusNm7XqtQCiilPfl++IXwuzNWi90qKAK7ETVOzB825nwBuz3DhPN3CqwBdylKj
         0XI5c80q9PaSQ==
Date:   Tue, 9 Jul 2019 10:27:28 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matteo Croce <mcroce@redhat.com>,
        Florian Westphal <fw@strlen.de>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20190709102728.70299ba8@canb.auug.org.au>
In-Reply-To: <20190702121357.65f9b0b4@canb.auug.org.au>
References: <20190702121357.65f9b0b4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/V3hnu3YvyhoLQaqhVeqx3Ds"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/V3hnu3YvyhoLQaqhVeqx3Ds
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 2 Jul 2019 12:13:57 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Today's linux-next merge of the net-next tree got a conflict in:
>=20
>   net/ipv4/devinet.c
>=20
> between commit:
>=20
>   2e6054636816 ("ipv4: don't set IPv6 only flags to IPv4 addresses")
>=20
> from the net tree and commit:
>=20
>   2638eb8b50cf ("net: ipv4: provide __rcu annotation for ifa_list")
>=20
> from the net-next tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>=20
> --=20
> Cheers,
> Stephen Rothwell
>=20
> diff --cc net/ipv4/devinet.c
> index c5ebfa199794,137d1892395d..000000000000
> --- a/net/ipv4/devinet.c
> +++ b/net/ipv4/devinet.c
> @@@ -473,11 -482,10 +487,13 @@@ static int __inet_insert_ifa(struct in_
>   	ifa->ifa_flags &=3D ~IFA_F_SECONDARY;
>   	last_primary =3D &in_dev->ifa_list;
>  =20
>  +	/* Don't set IPv6 only flags to IPv4 addresses */
>  +	ifa->ifa_flags &=3D ~IPV6ONLY_FLAGS;
>  +
> - 	for (ifap =3D &in_dev->ifa_list; (ifa1 =3D *ifap) !=3D NULL;
> - 	     ifap =3D &ifa1->ifa_next) {
> + 	ifap =3D &in_dev->ifa_list;
> + 	ifa1 =3D rtnl_dereference(*ifap);
> +=20
> + 	while (ifa1) {
>   		if (!(ifa1->ifa_flags & IFA_F_SECONDARY) &&
>   		    ifa->ifa_scope <=3D ifa1->ifa_scope)
>   			last_primary =3D &ifa1->ifa_next;


I am still getting this conflict (the commit ids may have changed).
Just a reminder in case you think Linus may need to know.

--=20
Cheers,
Stephen Rothwell

--Sig_/V3hnu3YvyhoLQaqhVeqx3Ds
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0j33AACgkQAVBC80lX
0GwB1gf/bYeymsjEJKZD7rtNgI+l/u3G+WhPHOMWD4mqBf9HDXEbuhm9eh6w0eiH
UwCykKCsLEn0/xhDcOkhRXSkoMX/UkgxdfX2meLcXJIHIRISVjv+xu4+0cw1892T
ik+L/JWA1hdUOAvVQmVWHX16/CUHwluS3fsT/teiZ0GUeKDMEvRShcXg5PguXomY
gjX0LE1WOIn7Y4+wYeuBUHoo4lYgOFb00WYjGpf4zaJ/4Lar6mP3ZNclbG7TQNk8
HxkIn284NvLARWuAxHk5fEb2t4lH/WNz9WrLBdqLCFrbBNHcS22MzyS1LSv3/wDU
Zkezcwet1MPmiTw/UrDWUIiyXPtNuQ==
=qFgw
-----END PGP SIGNATURE-----

--Sig_/V3hnu3YvyhoLQaqhVeqx3Ds--
