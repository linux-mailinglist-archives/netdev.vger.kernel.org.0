Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C261D11DF
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 13:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730936AbgEMLyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 07:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729758AbgEMLyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 07:54:45 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DA3C061A0C;
        Wed, 13 May 2020 04:54:45 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49MY4f6q8Lz9sRK;
        Wed, 13 May 2020 21:54:42 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1589370883;
        bh=3T+lgSc67nG88CAar7Vf0TDXY5ZfpVC7nYvqytN5sYA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LqN/gv1iTibO8JXPWWbV654vC1YJxhEggzfdp2qCrZDNYOAJtzYt7KNVpoF2kfkQk
         R+US6MXwoHV3rGvLzFEWu32dX7LulBk4Pom52Z3zB08weVDLQFSFVIyXgOIGyzgfp8
         wQv5o0joI2vSF3Pu4MjOoRBsvDXe8Ty6eXd2hgfAIrDZNN5ut1fnK+oz6Q42TlOGdR
         trwrkaqHVXtfQxDkP0610r5+WUmUQiCrETUtpTygZKm5bRGAcvCjpBZvZl+CNES3US
         D3QaxWNUyznpKkowMqAQIK1xGddb2aGSObbGAHeTsbibwPSkk7u9aXlaf6DKOW+od+
         HX+tZgm5g2Hew==
Date:   Wed, 13 May 2020 21:54:41 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Cc:     kuba@kernel.org, Amol Grover <frextrite@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH net 2/2 RESEND] ipmr: Add lockdep expression to
 ipmr_for_each_table macro
Message-ID: <20200513215441.22653800@canb.auug.org.au>
In-Reply-To: <20200512051705.GB9585@madhuparna-HP-Notebook>
References: <20200509072243.3141-1-frextrite@gmail.com>
        <20200509072243.3141-2-frextrite@gmail.com>
        <20200509141938.028fa959@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200512051705.GB9585@madhuparna-HP-Notebook>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/G21wR.Rlh9nJMI_uLF+zR.9";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/G21wR.Rlh9nJMI_uLF+zR.9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 12 May 2020 10:47:05 +0530 Madhuparna Bhowmik <madhuparnabhowmik10@=
gmail.com> wrote:
> >=20
> > I think what is happening is this:
> >=20
> > ipmr_net_init() -> ipmr_rules_init() -> ipmr_new_table()
> >=20
> > ipmr_new_table() returns an existing table if there is one, but
> > obviously none can exist at init.  So a better fix would be:
> >=20
> > #define ipmr_for_each_table(mrt, net)					\
> > 	list_for_each_entry_rcu(mrt, &net->ipv4.mr_tables, list,	\
> > 				lockdep_rtnl_is_held() ||		\
> > 				list_empty(&net->ipv4.mr_tables))
> > =20
> (adding Stephen)

I have changed the patch in my fixes tree to this.

--=20
Cheers,
Stephen Rothwell

--Sig_/G21wR.Rlh9nJMI_uLF+zR.9
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl674AIACgkQAVBC80lX
0GwJeQf/WMFPCJ/Bcct2RJ78Xar0HrrX2pKIBOUdfYIYHWltb4+jgrHS4s9JUDAr
qwpk4IVWSTS/mCCdW3A+GU7wXNfCW5hJtMVprpwJpulGvsTWeHHSFePPESje0uvS
OQn8YwYk5a5Qxm6xPgbcmJqLW3b3ud4O+rA4t6EegtDIDMeaI5TUg6xJFpfl42KD
AD3w6ukWA0O5iQulxiqTBOTXBCR1QN4plkafmfgYXXaUQfWLMGmLHJRs6OU/f4uJ
QTtQlUiNa4yiiyYw6CfDsG5xs7NFjhOKmPydw8LdpzB8WYVBQGTp2kK/1emWUv1f
gwDrocR3dPMr8mGcsTF3GdoRFCtc/w==
=QuXY
-----END PGP SIGNATURE-----

--Sig_/G21wR.Rlh9nJMI_uLF+zR.9--
