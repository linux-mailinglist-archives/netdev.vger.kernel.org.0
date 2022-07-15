Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E27A2575936
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 03:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbiGOBs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 21:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiGOBsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 21:48:25 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1807866BA5;
        Thu, 14 Jul 2022 18:48:23 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4LkZ502Xqbz4xj3;
        Fri, 15 Jul 2022 11:48:19 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1657849701;
        bh=yV9vq1Lt3C+nO9r4f9S/GlxG5/N8GYHsFwZ8YFzwp38=;
        h=Date:From:To:Cc:Subject:From;
        b=tQV2ZliHVY9T1TSHIX2YmWHGjy3+I7QsAZPXRGrMdoUII8MhmY/hlMTJPiz9ShD4M
         P9rqe7bcks2DYlKVZZzFERTl2EyJfHL0/BOyZmNmo1XDyZLiL3OL+US1iHp5AxL4xF
         A0igBfrmlFrLYEZsJZJdiC+XIkpt8OINMA6j/dKzO+dJrVFQiAzhAE+GcgpKS2JUJX
         s6j9w8HAIkScxQWTDfKZbuGd3lHYlh9Vx8Nu5J2OdxNYUD8EJL1rdWMx4UCeLCJIsL
         vAglA+1POzN+rYtbfAtYTq2BjOfqUr/xGjQpLCmzwvRpwME54U4RG+mbx4BnUE8Lio
         8GAroiKHba0QQ==
Date:   Fri, 15 Jul 2022 11:48:16 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: linux-next: manual merge of the net-next tree with Linus' tree
Message-ID: <20220715114816.671335e2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/WlX1wDD_8Q5BjVh6UzueOm2";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/WlX1wDD_8Q5BjVh6UzueOm2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/ipv4/fib_semantics.c

between commit:

  747c14307214 ("ip: fix dflt addr selection for connected nexthop")

from Linus' tree and commit:

  d62607c3fe45 ("net: rename reference+tracking helpers")

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

diff --cc net/ipv4/fib_semantics.c
index d9fdcbae16ee,a5439a8414d4..000000000000
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@@ -1229,8 -1230,8 +1230,8 @@@ static int fib_check_nh_nongw(struct ne
  	}
 =20
  	nh->fib_nh_dev =3D in_dev->dev;
- 	dev_hold_track(nh->fib_nh_dev, &nh->fib_nh_dev_tracker, GFP_ATOMIC);
+ 	netdev_hold(nh->fib_nh_dev, &nh->fib_nh_dev_tracker, GFP_ATOMIC);
 -	nh->fib_nh_scope =3D RT_SCOPE_HOST;
 +	nh->fib_nh_scope =3D RT_SCOPE_LINK;
  	if (!netif_carrier_ok(nh->fib_nh_dev))
  		nh->fib_nh_flags |=3D RTNH_F_LINKDOWN;
  	err =3D 0;

--Sig_/WlX1wDD_8Q5BjVh6UzueOm2
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmLQx2AACgkQAVBC80lX
0GzZbwf/cZvD+gHvsN/EER7RKngzUIHySDYlqp82TwWJsGhAW55exVprRrjbZRvt
RkzNL5EfnlRz26TBar9z4jU9PyxiAwCGFpx3be/2ai6wOAyo8tpDWvSl+c4lQmgN
RAjpcSUBF+p54rIwdYhx2OJNxWpNQsqmgRo7quP/NWT6dqzWw35mt1gxfeWiqUke
KlSM7JQ23kJ+189Shlts/MjP+LL3AR5pGo+uWqgQ1P/LDSPLNRD/78rP/AuDDXnn
G0MXdEHqjizTSjQAVF6y/1fp19z3MEXmCkM9FyOj3Vg9b9TGa3l1m3VqPpU73TA0
SUQpcIe5mSNo843UOmg0tinaltN1uA==
=Hu04
-----END PGP SIGNATURE-----

--Sig_/WlX1wDD_8Q5BjVh6UzueOm2--
