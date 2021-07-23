Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98BD43D31D5
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 04:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbhGWBvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 21:51:44 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:54991 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233166AbhGWBvn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 21:51:43 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GWCyR6zrGz9sRf;
        Fri, 23 Jul 2021 12:32:15 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1627007536;
        bh=koKq4TgjUYq9/R+UtF4SotsRvhgnCeYaWHfyAdtWN38=;
        h=Date:From:To:Cc:Subject:From;
        b=snHmio27KXWOC8YyLuSXO49MhT6QepEY/rtiduHufDnRgdYQO2FovZilwxrF6Wb+p
         ZX66DufrRNbYpzjXaRJayta4WQfWpGHjb1Keo5J3ll27A7K+6LvY83qtPtDJ7EdnlX
         87k8q0nvvlm9H94CAp2OcAs2NmSwAN0Jso4UydYiTgATnpO7CqHwXD0WbSS2yTINaE
         qu2NQCUSPYXT9Mglo1wVCmLOzFh4ODQW4NAVZAL9bKssy4jcsQFges52NjDrVOoXSm
         brusGyUg0nEZJHFGr+DUS4g9Ml/ja0+j8qAcg+vSgXDszFrwRu1As+spGunfRAdtfo
         hJ8uwWWqSGVqQ==
Date:   Fri, 23 Jul 2021 12:32:13 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Wei Wang <weiwan@google.com>
Subject: linux-next: manual merge of the net-next tree with Linus' tree
Message-ID: <20210723123213.0a970ac7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/jzgtEvjBY3eTR9W_rvEUN.D";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/jzgtEvjBY3eTR9W_rvEUN.D
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/ipv4/tcp_ipv4.c

between commit:

  213ad73d0607 ("tcp: disable TFO blackhole logic by default")

from Linus' tree and commit:

  e93abb840a2c ("net/tcp_fastopen: remove tcp_fastopen_ctx_lock")

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

diff --cc net/ipv4/tcp_ipv4.c
index a692626c19e4,e9321dd39cdb..000000000000
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@@ -2964,8 -2964,7 +2964,7 @@@ static int __net_init tcp_sk_init(struc
  	net->ipv4.sysctl_tcp_comp_sack_slack_ns =3D 100 * NSEC_PER_USEC;
  	net->ipv4.sysctl_tcp_comp_sack_nr =3D 44;
  	net->ipv4.sysctl_tcp_fastopen =3D TFO_CLIENT_ENABLE;
- 	spin_lock_init(&net->ipv4.tcp_fastopen_ctx_lock);
 -	net->ipv4.sysctl_tcp_fastopen_blackhole_timeout =3D 60 * 60;
 +	net->ipv4.sysctl_tcp_fastopen_blackhole_timeout =3D 0;
  	atomic_set(&net->ipv4.tfo_active_disable_times, 0);
 =20
  	/* Reno is always built in */

--Sig_/jzgtEvjBY3eTR9W_rvEUN.D
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmD6Ki0ACgkQAVBC80lX
0GxZUgf/W9224sGFp0kqxPny1PD1fa2vNdUgOYvI8sLWEext9qFDZ3bJgN3vgzyR
lDe/ph7OEKj3yOGdN1DRjWWSMPmP74BPW1EX0csRWG5KaPH0/vMjHqTBtP8NEnfu
MMU67INKIniQi38nVIwruBpFJGg+P2FyE31lleznkBapy4PPrnpyXoUB5VEIwUkS
1DczvTNpyHh39kS7f0r2bvME09RIkX8jeFv0VwkypErz6ijFQprYcD7tpEGsxGcZ
76NdMOjFi5lk8nwp2H/g4elzr7Rr0LVRLIUuHl/W1XnTpfQoZ8bcKe5TPdMuAvDe
WaT31X8PubruI/k5rujT3rv01eblew==
=i9Q5
-----END PGP SIGNATURE-----

--Sig_/jzgtEvjBY3eTR9W_rvEUN.D--
