Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F30C5C6FE
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 04:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfGBCOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 22:14:02 -0400
Received: from ozlabs.org ([203.11.71.1]:57601 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbfGBCOC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 22:14:02 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45d78Q1cP6z9s3Z;
        Tue,  2 Jul 2019 12:13:58 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1562033639;
        bh=WohRocbKc1/BYUZ1CZ0fjG50w3K0ohtYN8fEqw9/btQ=;
        h=Date:From:To:Cc:Subject:From;
        b=YXzIkke6BuLN9R+kWiShZtgGXRM61FsQeOLYUs9NuomaDKB/BFKEVnC+HdrJVAtJD
         TmLC+BeQy/ZCdLXFi4xgC5Y8Wb/347rsmCD5jdq3c6oHyPnC3kWiYnfWK3pUw0cKak
         Smd/js4IVvIlSnwbU/cGL2vlE0hbPXXyvIARndJTMIoU7wF/+XXk9YNOAPpsFrBLWp
         DUDq5j7FlN+jIfqiWvZ775QfpvQgERBgGj0ZBEksTkcSmdXI6NSSGxSa0S1IuBiNyU
         xTtvlZTsnaK1IVB1pRox+6GsapdpGRMQOejSGh5mjCUai5uxMkYSmaC32jCwYEEYKl
         ydLkAc0ad3ykw==
Date:   Tue, 2 Jul 2019 12:13:57 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matteo Croce <mcroce@redhat.com>,
        Florian Westphal <fw@strlen.de>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20190702121357.65f9b0b4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/cJcBb_F.weJj.YnDE.cMylQ"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/cJcBb_F.weJj.YnDE.cMylQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/ipv4/devinet.c

between commit:

  2e6054636816 ("ipv4: don't set IPv6 only flags to IPv4 addresses")

from the net tree and commit:

  2638eb8b50cf ("net: ipv4: provide __rcu annotation for ifa_list")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc net/ipv4/devinet.c
index c5ebfa199794,137d1892395d..000000000000
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@@ -473,11 -482,10 +487,13 @@@ static int __inet_insert_ifa(struct in_
  	ifa->ifa_flags &=3D ~IFA_F_SECONDARY;
  	last_primary =3D &in_dev->ifa_list;
 =20
 +	/* Don't set IPv6 only flags to IPv4 addresses */
 +	ifa->ifa_flags &=3D ~IPV6ONLY_FLAGS;
 +
- 	for (ifap =3D &in_dev->ifa_list; (ifa1 =3D *ifap) !=3D NULL;
- 	     ifap =3D &ifa1->ifa_next) {
+ 	ifap =3D &in_dev->ifa_list;
+ 	ifa1 =3D rtnl_dereference(*ifap);
+=20
+ 	while (ifa1) {
  		if (!(ifa1->ifa_flags & IFA_F_SECONDARY) &&
  		    ifa->ifa_scope <=3D ifa1->ifa_scope)
  			last_primary =3D &ifa1->ifa_next;

--Sig_/cJcBb_F.weJj.YnDE.cMylQ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0aveUACgkQAVBC80lX
0GxJoQf/WarVGNz/Zgngol0mMUT9nAZnvqMDw6GEEmUY+axJQ3mRjrp3C4gtYu8S
o/z9qGntzvQx6oo1xw5KcxFpFwjgZ3DlNIlBxOKFcF6JeMTRc752I+IyWyznE4J1
K5b11CYiMMiTJ3gr2G7Yw0kxGr6W0U5JVZ0bIovIKw7AVMZdPbBXFahDX0BQHaFz
RDy5KdkyKqmu+9HEd8/nB3oGZGmroJPlQu5L5oq8fZXmar9xhgpyrtitbYr5i1Uk
1Vchsul63zfrPizy6HQEY2WcZPMtD19Z7mtsnax4Ud6n4iWbjdBO9UBsMkYGFRQa
Zh5yRoHYjCUMSeTfaDuzdeTPtuZ8pg==
=/Xl9
-----END PGP SIGNATURE-----

--Sig_/cJcBb_F.weJj.YnDE.cMylQ--
