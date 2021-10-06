Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5839423568
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 03:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237117AbhJFBZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 21:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbhJFBZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 21:25:13 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55433C061749;
        Tue,  5 Oct 2021 18:23:21 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HPGtG6mLtz4xb7;
        Wed,  6 Oct 2021 12:23:18 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1633483399;
        bh=XXFQ0AYsYwZROOIrH+gXrXBTleEtv3lUPJDsDDqHp94=;
        h=Date:From:To:Cc:Subject:From;
        b=Zy6cYGybtRS4CF9dGGQ1xiX8FjMpoEnliGQ4lKqDxPfXnb3YtTCoEDltmuiV7sr7Z
         oBnLHpO+rVe+c6BrjP0/xJKMFQMAsGl22AD+OX3srD7idRvxaMkqn4eqE90AQEx+Li
         moWrrvHziHIlyVzJ8ubeuyviLyRnOqwGXQbmU6G7oPIQdYeMB2CTmp7RGy9tDAu2QD
         UQgTvV0rD9p0LdljZD/X+3duN/sv7t9cZlqIiXBZhUe7QZXva4aporbnik1D2+rW9k
         oYv4TzKO1/k3fNv6OKVzexUafah6qB+UtU25bEHSeB8wo5eOaa29C85vj5jzId5zvK
         15HaNCs+aq3kA==
Date:   Wed, 6 Oct 2021 12:23:15 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20211006122315.4e04fb87@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/a28eEqY1.W/qoc/cWLKMAUq";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/a28eEqY1.W/qoc/cWLKMAUq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/net/ethernet/toshiba/ps3_gelic_net.c: In function 'gelic_net_setup_=
netdev':
drivers/net/ethernet/toshiba/ps3_gelic_net.c:1480:26: error: passing argume=
nt 2 of 'eth_hw_addr_set' from incompatible pointer type [-Werror=3Dincompa=
tible-pointer-types]
 1480 |  eth_hw_addr_set(netdev, &v1);
      |                          ^~~
      |                          |
      |                          u64 * {aka long long unsigned int *}
In file included from drivers/net/ethernet/toshiba/ps3_gelic_net.c:23:
include/linux/etherdevice.h:309:70: note: expected 'const u8 *' {aka 'const=
 unsigned char *'} but argument is of type 'u64 *' {aka 'long long unsigned=
 int *'}
  309 | static inline void eth_hw_addr_set(struct net_device *dev, const u8=
 *addr)
      |                                                            ~~~~~~~~=
~~^~~~

Caused by commit

  a96d317fb1a3 ("ethernet: use eth_hw_addr_set()")

I have applied the following patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 6 Oct 2021 12:19:08 +1100
Subject: [PATCH] ethernet: fix up ps3_gelic_net.c for "ethernet: use
 eth_hw_addr_set()"

Fixes: a96d317fb1a3 ("ethernet: use eth_hw_addr_set()")
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/ethernet/toshiba/ps3_gelic_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/eth=
ernet/toshiba/ps3_gelic_net.c
index 1425623b868e..3dbfb1b20649 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -1477,7 +1477,7 @@ int gelic_net_setup_netdev(struct net_device *netdev,=
 struct gelic_card *card)
 			 __func__, status);
 		return -EINVAL;
 	}
-	eth_hw_addr_set(netdev, &v1);
+	eth_hw_addr_set(netdev, (u8 *)&v1);
=20
 	if (card->vlan_required) {
 		netdev->hard_header_len +=3D VLAN_HLEN;
--=20
2.33.0

--=20
Cheers,
Stephen Rothwell

--Sig_/a28eEqY1.W/qoc/cWLKMAUq
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFc+oMACgkQAVBC80lX
0GxoQwgAjDJfjymKtbpIqkFX0bqvsWkGvESCeOuvrvnT2t06QY6LdxBgNizs3fsk
h4JWX76Ce5LYQiQSEqxdPWXpQbKEC05Lik7VsY7HaR1iyNPJhrkg9FbOlChKPbo4
OBrPDsmz45opqxerriDJsf+8YT+P4yKiEi5bAVsevUFTyPS0k+vI15NQiVJ6UsMZ
wsrJhOdll4oZbjuPJ9kBeixVvz5dAcaiM5Juj61enDVHytokcM2rGMVv4YgC8JJ4
/k7JrW9R7KdjOizWSykiSlAZLy7S6hrOBEjNefqGPkIQj4qDZSqM3bdFbB5k/qZw
XwPSrqpFROMbkn0K1BFQmGtJlfZFZg==
=caA/
-----END PGP SIGNATURE-----

--Sig_/a28eEqY1.W/qoc/cWLKMAUq--
