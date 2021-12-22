Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C411547CBA8
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 04:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242109AbhLVDQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 22:16:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242113AbhLVDQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 22:16:47 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B997C061574;
        Tue, 21 Dec 2021 19:16:46 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JJdlc1JGrz4xgt;
        Wed, 22 Dec 2021 14:16:43 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1640143004;
        bh=iYgqFIm8ULq1DlSm3akFzLfd8AsyHdppdSnDqF7SclE=;
        h=Date:From:To:Cc:Subject:From;
        b=ibeCjHwdphoo2ZOxXJ7IWqfqx7dDA4P4rUW110hQBIioNjo9QOMSs1vp09HyP0UKT
         RHR3J9RV7FEZaktxzqepeVlr78r+so2/Aab25LCnSeGOpE8vvLm0cjwRpzfklN4F+E
         OozD6oQp752kuIQJ7J/RAUxvqFvBfXXHw/Mh1Q/ss+3Ouim2DofvpII/JUucKvucsf
         7i6wSUkNvpW3LyT0EOen+oFsSSi/uGLbxtUJpE87QUjB0COLkw2XwnJ3m88IPXZYd+
         e/929fmAYzhpy5VLtx56gtoGsKFBLBUB0P8QaNi0RN8yIYqJqUC7/OGJF6CILY9IO2
         Ych9g0oLXo/8w==
Date:   Wed, 22 Dec 2021 14:16:41 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20211222141641.0caa0ab3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/eKoLIghqCw2qxAp807NB7qa";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/eKoLIghqCw2qxAp807NB7qa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  include/net/sock.h

between commit:

  8f905c0e7354 ("inet: fully convert sk->sk_rx_dst to RCU rules")

from the net tree and commit:

  43f51df41729 ("net: move early demux fields close to sk_refcnt")

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

diff --cc include/net/sock.h
index d47e9658da28,37f878564d25..000000000000
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@@ -391,6 -392,11 +392,11 @@@ struct sock=20
  #define sk_flags		__sk_common.skc_flags
  #define sk_rxhash		__sk_common.skc_rxhash
 =20
+ 	/* early demux fields */
 -	struct dst_entry	*sk_rx_dst;
++	struct dst_entry __rcu	*sk_rx_dst;
+ 	int			sk_rx_dst_ifindex;
+ 	u32			sk_rx_dst_cookie;
+=20
  	socket_lock_t		sk_lock;
  	atomic_t		sk_drops;
  	int			sk_rcvlowat;

--Sig_/eKoLIghqCw2qxAp807NB7qa
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmHCmJkACgkQAVBC80lX
0GzRNQf+I+1qB0F4KqeeUMBCNm+o1GxWTZJJXJ1vfF9ugDV5PmiWgNAXo8lIXeJA
WqL2InnXBeL44Uhyj5An1/Zlnn90i9VwMrZCGWiAnXRp2wr1kM5fOk+sKHD0UdYV
JR8V1ktNOLM0Y9MPPpcpfc7u1wbxt3iHh9kfGl+3Q/WFevilpcYpgpDhWLvLZjw/
j9+jWUkKFzzqKz3Bo4bAMieM0yH6ak1SMXIj9Y8I+QpNcaZ6xLNeETabQa2UgO7t
gFyu/YlG09BwcHZr4exuim3JlungvKE3WfSMlRZm/3Iiz3fS2dowdBfGtdBK6+bn
aK0WR3pDq/D9+HdbWR2wQ1e+ul9gaA==
=WkVm
-----END PGP SIGNATURE-----

--Sig_/eKoLIghqCw2qxAp807NB7qa--
