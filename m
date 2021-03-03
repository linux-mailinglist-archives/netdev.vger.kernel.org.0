Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7E6E32C4AA
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1450228AbhCDAP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:15:58 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:53393 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1390898AbhCCWSy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 17:18:54 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DrT0F5Yrnz9sR4;
        Thu,  4 Mar 2021 09:18:05 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1614809887;
        bh=wmOp8R+qJFjoY4UzTY5NdSgLMMwegXgTcKNOkqrFtjM=;
        h=Date:From:To:Cc:Subject:From;
        b=OHjL5ebtaH90mjqhkglHCx00AnYGd0KUXVY4dc/vMTfKx3vlVUDSOXU2IINAisg1J
         exOUkR0p0F0QPPCnMrVz0ZmHOSNDtZIc1YyIdZvdjOd4Ok66Kol27DR2scI/B3sVjo
         sEcWySMBWQnNUhTnxex8hJKT7Tbcdf5ETy3AJRpVu+lBcShCLewh/Q7Qgf6IcYlQCl
         8zY3bEtCuz/fgtIzNifGAQaqjPHpSir4dpM11027KwqOlQ/jRIbMYHIYVKh4S3GonR
         HbqyfvpvhIDfB9JJnjsrqmw78iCqPbfevzZa+MhShbYcXfQxr37sc6i30hLzB8uvws
         Sl4NkqeVsNA5g==
Date:   Thu, 4 Mar 2021 09:18:04 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Eyal Birger <eyal.birger@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the ipsec tree with the net tree
Message-ID: <20210304091804.06055c81@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/l/gWjPPpz17v8Fczr_3KV9m";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/l/gWjPPpz17v8Fczr_3KV9m
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the ipsec tree got conflicts in:

  net/ipv4/ip_vti.c
  net/ipv6/ip6_vti.c

between commit:

  4372339efc06 ("net: always use icmp{,v6}_ndo_send from ndo_start_xmit")

from the net tree and commits:

  c7c1abfd6d42 ("vti: fix ipv4 pmtu check to honor ip header df")
  4c38255892c0 ("vti6: fix ipv4 pmtu check to honor ip header df")

from the ipsec tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc net/ipv4/ip_vti.c
index eb207089ece0,613741384490..000000000000
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@@ -238,8 -238,10 +238,10 @@@ static netdev_tx_t vti_xmit(struct sk_b
  	if (skb->len > mtu) {
  		skb_dst_update_pmtu_no_confirm(skb, mtu);
  		if (skb->protocol =3D=3D htons(ETH_P_IP)) {
+ 			if (!(ip_hdr(skb)->frag_off & htons(IP_DF)))
+ 				goto xmit;
 -			icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
 -				  htonl(mtu));
 +			icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
 +				      htonl(mtu));
  		} else {
  			if (mtu < IPV6_MIN_MTU)
  				mtu =3D IPV6_MIN_MTU;
diff --cc net/ipv6/ip6_vti.c
index f10e7a72ea62,2f0be5ac021c..000000000000
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@@ -521,10 -521,12 +521,12 @@@ vti6_xmit(struct sk_buff *skb, struct n
  			if (mtu < IPV6_MIN_MTU)
  				mtu =3D IPV6_MIN_MTU;
 =20
 -			icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
 +			icmpv6_ndo_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
  		} else {
+ 			if (!(ip_hdr(skb)->frag_off & htons(IP_DF)))
+ 				goto xmit;
 -			icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
 -				  htonl(mtu));
 +			icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
 +				      htonl(mtu));
  		}
 =20
  		err =3D -EMSGSIZE;

--Sig_/l/gWjPPpz17v8Fczr_3KV9m
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBACxwACgkQAVBC80lX
0GxMCQf/eo2wIC4MrucE//qOZg6XJY4LIaYECtv4rKXVR+Ol2090h9PzB9USPIhD
AprwJUtkVGhZ/v3af9vlGDXGcDWjJ+PC5NUiXDd1tlDtw1osAaZBZI/ikTUHp/8K
JxeHl9VrxBCZdf8Efb5KkuDa2TNndOG84I2JUy5z3BGfU51aZbaH2I5W3ENMn5E5
1WkIugvu0/B27Nrxfwww5haSpkpD2JpAWUbnyzkNUyEkvxaJR/p2j+uXshejWB8A
M4I9sf1gAL7gib+3F+1/HYP7RlakjtrWQzj1YZ3uXPg9zPiFnMA4Kqwvu/xoae5h
5a0olNxroDDiBfey1YpkpQ39n6AZng==
=zTOC
-----END PGP SIGNATURE-----

--Sig_/l/gWjPPpz17v8Fczr_3KV9m--
