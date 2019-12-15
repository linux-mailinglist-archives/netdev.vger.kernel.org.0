Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62FC511FBE6
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 00:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbfLOXim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 18:38:42 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:43657 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726346AbfLOXim (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Dec 2019 18:38:42 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47bgp63K7Hz9sP3;
        Mon, 16 Dec 2019 10:38:37 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1576453120;
        bh=LWwx46X/jK+HwaSLc5VFTlSHwQrlPJp/QnBR0I2tYV4=;
        h=Date:From:To:Cc:Subject:From;
        b=pOXVjKCjN4hLjtbRJ1D7SxprD1wYlQwO4HuY9wtzLoZx9d4mVNwVEOwCqVGcfLOMq
         xviZOORu1gwywR1q+mJRPXKCBEVfajZwYG9eQ5Oc2rrufoaGYNb3L8FC+r698SJm9D
         lcipo3E+JvywVnMepC31K9cy5l3xP5NeA2a4PE6tYlQzYYMOaeFVRC5VlCHxxRlOK1
         vdZM55nLtHh0urlgLGRd166zaXTIAWwQK6WBxTOf3Sy3C0CAG/TNyMLaHT3Rw/G1jI
         kxwszBr+lyI+m+24CWO3NhdMmV3aTZ3esOyW9l51wRdVwwW5/NZasQJCk+OqBTH66d
         0+W5IOu/PL8fw==
Date:   Mon, 16 Dec 2019 10:38:37 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: linux-next: manual merge of the ipsec-next tree with the net-next
 tree
Message-ID: <20191216103837.6b5d856b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/89HXB6vvh2nRwNy5pbK5wEX";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/89HXB6vvh2nRwNy5pbK5wEX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the ipsec-next tree got a conflict in:

  net/unix/af_unix.c

between commit:

  3c32da19a858 ("unix: Show number of pending scm files of receive queue in=
 fdinfo")

from the net-next tree and commit:

  b50b0580d27b ("net: add queue argument to __skb_wait_for_more_packets and=
 __skb_{,try_}recv_datagram")

from the ipsec-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc net/unix/af_unix.c
index 6756a3ccc392,a7f707fc4cac..000000000000
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@@ -2100,8 -2058,8 +2100,8 @@@ static int unix_dgram_recvmsg(struct so
  		mutex_lock(&u->iolock);
 =20
  		skip =3D sk_peek_offset(sk, flags);
- 		skb =3D __skb_try_recv_datagram(sk, flags, scm_stat_del,
- 					      &skip, &err, &last);
+ 		skb =3D __skb_try_recv_datagram(sk, &sk->sk_receive_queue, flags,
 -					      NULL, &skip, &err, &last);
++					      scm_stat_del, &skip, &err, &last);
  		if (skb)
  			break;
 =20

--Sig_/89HXB6vvh2nRwNy5pbK5wEX
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl32w/0ACgkQAVBC80lX
0GystAf/VW5r7ZW8n2KvN/QoaDD3atlYHHPaVY3sZUYjfd16rUrPjF/9+3gL1TUb
xeuYtzjX5+BjTyODk5MPmvjm7Y7XDtzq343xLCpUGvF3IUj2rbaiMx/qdoZDUU80
7j3Ed42pxJ3S+ORoj/n6Z9Kq1z1mzQDMAXa0/XgchkzisduGy9Jdi+BSZEjdmM0c
Ow8GA0CnFCi9UgfRx9xRjgqKPO+YL0n6mJEBq03LUY57/cMVHwjOlWQrF4KpX5Ef
UaMAn2fpp94BalTyf/fSodtDi/kcZZskOC2ENvDgMSXMcAadPBPJgTAwglQDhqAR
F8Tgu1WOWML+fzL7ejWWUshJmEsnMw==
=p8Wu
-----END PGP SIGNATURE-----

--Sig_/89HXB6vvh2nRwNy5pbK5wEX--
