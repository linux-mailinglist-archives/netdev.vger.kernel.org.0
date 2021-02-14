Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC93231B2A7
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 22:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbhBNVNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 16:13:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbhBNVNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 16:13:35 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14394C061574;
        Sun, 14 Feb 2021 13:12:55 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Df0Lr0jNYz9s1l;
        Mon, 15 Feb 2021 08:12:51 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1613337173;
        bh=heAwTC7GM5oZhn35ydvwxDvP3AVScWf/Lw91PP/LHtw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LBaeyeerjeYCfDegUMxcg+EvnmIaXNyDZpuHAaWOBBPGHZLgniCkqyvcX+32Vm66A
         B/V1/nl/yuBl1ETOh41CzLNuEvj7rGtg5/kL5trBO68FkKszsiWRqzOPj+1wZLLR14
         M69+ZqSuWoyGhOgRnU31yeQYO4DDcc1vsxbU0yDpnAkvz05SZJEaGr3qMRIVgzPXsA
         zQYIyFO1IyqT2VEK20wBtwhbqTr4dyr6TtTfEEcomcRpXKxyL1gfrCRegcDm+cX2sH
         hOqaEJ1SMxVnrLjIorMevsyj7vaBrv7Ovdg7b1ZEOC8qyVeZoeDyHPCFGhEMtS6l0F
         +ADod1SuGkJ3Q==
Date:   Mon, 15 Feb 2021 08:12:50 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Arjun Roy <arjunroy@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: linux-next: manual merge of the bpf-next tree with the net-next
 tree
Message-ID: <20210215081250.19bc8921@canb.auug.org.au>
In-Reply-To: <20210125111223.2540294c@canb.auug.org.au>
References: <20210125111223.2540294c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/oRD_PR_AcP8WZx1lBSo5l0F";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/oRD_PR_AcP8WZx1lBSo5l0F
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 25 Jan 2021 11:12:23 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>=20
> Today's linux-next merge of the bpf-next tree got a conflict in:
>=20
>   net/ipv4/tcp.c
>=20
> between commit:
>=20
>   7eeba1706eba ("tcp: Add receive timestamp support for receive zerocopy.=
")
>=20
> from the net-next tree and commit:
>=20
>   9cacf81f8161 ("bpf: Remove extra lock_sock for TCP_ZEROCOPY_RECEIVE")
>=20
> from the bpf-next tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>=20
> diff --cc net/ipv4/tcp.c
> index e1a17c6b473c,26aa923cf522..000000000000
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@@ -4160,18 -4098,13 +4160,20 @@@ static int do_tcp_getsockopt(struct soc
>   		if (copy_from_user(&zc, optval, len))
>   			return -EFAULT;
>   		lock_sock(sk);
>  -		err =3D tcp_zerocopy_receive(sk, &zc);
>  +		err =3D tcp_zerocopy_receive(sk, &zc, &tss);
> + 		err =3D BPF_CGROUP_RUN_PROG_GETSOCKOPT_KERN(sk, level, optname,
> + 							  &zc, &len, err);
>   		release_sock(sk);
>  -		if (len >=3D offsetofend(struct tcp_zerocopy_receive, err))
>  -			goto zerocopy_rcv_sk_err;
>  +		if (len >=3D offsetofend(struct tcp_zerocopy_receive, msg_flags))
>  +			goto zerocopy_rcv_cmsg;
>   		switch (len) {
>  +		case offsetofend(struct tcp_zerocopy_receive, msg_flags):
>  +			goto zerocopy_rcv_cmsg;
>  +		case offsetofend(struct tcp_zerocopy_receive, msg_controllen):
>  +		case offsetofend(struct tcp_zerocopy_receive, msg_control):
>  +		case offsetofend(struct tcp_zerocopy_receive, flags):
>  +		case offsetofend(struct tcp_zerocopy_receive, copybuf_len):
>  +		case offsetofend(struct tcp_zerocopy_receive, copybuf_address):
>   		case offsetofend(struct tcp_zerocopy_receive, err):
>   			goto zerocopy_rcv_sk_err;
>   		case offsetofend(struct tcp_zerocopy_receive, inq):

With the merge window about to open, this is a reminder that this
conflict still exists.

--=20
Cheers,
Stephen Rothwell

--Sig_/oRD_PR_AcP8WZx1lBSo5l0F
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmApklIACgkQAVBC80lX
0GwVrQf8DfYze7Pz5Wl5aIUiKJfYVXgLEgqctp/06iv/FvxwfACJNTnF3Zly7BX3
Z7Iltesm8n7XAyaCsfcte+ICkiLMCkE0XlHPM3uj9Xy5BxojNhQkpN0ymdiU3QWj
N8mnem8QubZnANKoqNiL/YZPSssKeqKKyuMx98z34aNVIRVT3t8rojAZ0dJze2sJ
AIkLN5QTlYRdFqpdaWNK7vWERObay3cf4Wkbh578vYYTuIMsAEUL3g1Jhum4cZD5
K+zoavnrhOt0MHBvkcsnqRQ3/zP41iDp1Xw9p+8WctTuEW8cRMbN+TrjXmzt4I67
U3/MxFkC8Z+4dMqe8S6hzAV6i5EIkg==
=nY0U
-----END PGP SIGNATURE-----

--Sig_/oRD_PR_AcP8WZx1lBSo5l0F--
