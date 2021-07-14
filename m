Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E719C3C94B0
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 01:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236075AbhGNXx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 19:53:29 -0400
Received: from ozlabs.org ([203.11.71.1]:51131 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229535AbhGNXx3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Jul 2021 19:53:29 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GQDlZ1KHxz9sWS;
        Thu, 15 Jul 2021 09:50:33 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1626306635;
        bh=TZ+Ih+kFcBCph+/kBsHHs9MZ5aSAXfKg0yPMfB7RdaQ=;
        h=Date:From:To:Cc:Subject:From;
        b=L9hw79C30kzPY1ZQnPrd/nNdKgeVFiP5BTeidq344loZ0P7d1thaudUm/lalQZ7Xj
         FSFKkoazlztRv7XdxK4k0gpxK8+052/Vb4H7nsyMlbt6hJ5QFIyjMT0Vml07tDxd94
         m3+3sIYUZnPAG8+lbwlWQxun8QFDT/bvpOk7ucaycNSccKfvMwKYA6ox1lVqe3ro9E
         Z0vKu1PLOtRCAm5PCoMznUeO5BLiJ3XencZImcyiKa0hBe4/+n+I4/80loWk2WIQ4r
         brmIBbimeO+u5iZ4yauWToiNKAWa42wxKzJp2OVC3GM1EtRwiN6NVUSr0yFJ5n3iVa
         vPuHCaSoDQ+fA==
Date:   Thu, 15 Jul 2021 09:50:32 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: linux-next: build failure in Linus' tree
Message-ID: <20210715095032.6897f1f6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/r2jI.7wTppluivW9I5VE6nv";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/r2jI.7wTppluivW9I5VE6nv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

While compiling Linus' tree, a powerpc-allmodconfig build (and others)
with gcc 4.9 failed like this:

drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c: In function 'ifh_enc=
ode_bitfield':
include/linux/compiler_types.h:328:38: error: call to '__compiletime_assert=
_431' declared with attribute error: Unsupported width, must be <=3D 40
  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
                                      ^
include/linux/compiler_types.h:309:4: note: in definition of macro '__compi=
letime_assert'
    prefix ## suffix();    \
    ^
include/linux/compiler_types.h:328:2: note: in expansion of macro '_compile=
time_assert'
  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
  ^
drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c:28:2: note: in expans=
ion of macro 'compiletime_assert'
  compiletime_assert(width <=3D 40, "Unsupported width, must be <=3D 40");
  ^

Caused by commit

  f3cad2611a77 ("net: sparx5: add hostmode with phylink support")

I guess this is caused by the call to ifh_encode_bitfield() not being
inlined.



--=20
Cheers,
Stephen Rothwell

--Sig_/r2jI.7wTppluivW9I5VE6nv
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmDveEgACgkQAVBC80lX
0GwVUAgAiQDCnchrG4xRHyq7tAgVlXvSwS/XJHARhkuL8tFULxlc64XOTtiQ2MUH
D6uw7acPR0GZo6M57zghh3j9SopBVh4w6dJHwgCOL5omwsEs3hoe96ckJizGTjmU
x+TC90CeQJX/NELLFFvyrhSI8lC1e4u7UbF+Yfg8nEJ2kDDYAhSgu83uMM7jwV/Y
T/ZxayQnS20hGAxGUfMJBmDS41tH+FO03NUpEuF/XyY4DrBbdfxDUg7wUvAsTk0s
x8w7Pru61FjKogwHNwRq5mrbOaEIr1bFtSHz7Fp12lzvZIjYaLJ6Bv91eeCeE5V1
Cu8i+z3o9Q1rwBPVKAZ4AiM+xeyiKQ==
=S897
-----END PGP SIGNATURE-----

--Sig_/r2jI.7wTppluivW9I5VE6nv--
