Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A62D204678
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 03:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732389AbgFWBDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 21:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731716AbgFWBDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 21:03:37 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC8CC061573;
        Mon, 22 Jun 2020 18:03:36 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49rShP2xR3z9sSJ;
        Tue, 23 Jun 2020 11:03:32 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1592874214;
        bh=nPtFPnBowS+xlR1gfPlLfOzlnplxG1MPkj4X8y+hHnY=;
        h=Date:From:To:Cc:Subject:From;
        b=j6EwxJ5+LPwsRyljSgLkIGySR1H1743pRgnXqciAMudjbpyrSuGiLLMpGwg+Bu0M9
         0qgPIUc3yT3H5cpQdNn+m/ze4IJmc+NRzB4UXGwoFSU2KYm34QUgKwrptows1It3iJ
         WrhyGho6yoXzPj3dvGZDZC/nyqautxMeJvr/00Mc0wbktXp0ccQGz8ZR8T+dOsf5K3
         fAflkeKdi19NGZ7eB9jPWUfDjxZmYLWQCs1pg9Ycla2Me9Y7df4a+F6Q90oc/nYSPk
         wIegWy+SEX9Eqi5cm+LKuYevSRyJblrZzZc/FkVHoJllu0nsrrB3WSJwIHhYlHwQTz
         uonkgFdvCKxXQ==
Date:   Tue, 23 Jun 2020 11:03:31 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Huy Nguyen <huyn@mellanox.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jarod Wilson <jarod@redhat.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20200623110331.3f6349e1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/O/wuqT+Xgl=.=MhUIjImgu9";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/O/wuqT+Xgl=.=MhUIjImgu9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/xfrm/xfrm_device.c

between commit:

  94579ac3f6d0 ("xfrm: Fix double ESP trailer insertion in IPsec crypto off=
load.")

from the net tree and commit:

  272c2330adc9 ("xfrm: bail early on slave pass over skb")

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

diff --cc net/xfrm/xfrm_device.c
index 626096bd0d29,b8918fc5248b..000000000000
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@@ -106,9 -106,10 +106,10 @@@ struct sk_buff *validate_xmit_xfrm(stru
  	struct sk_buff *skb2, *nskb, *pskb =3D NULL;
  	netdev_features_t esp_features =3D features;
  	struct xfrm_offload *xo =3D xfrm_offload(skb);
+ 	struct net_device *dev =3D skb->dev;
  	struct sec_path *sp;
 =20
 -	if (!xo)
 +	if (!xo || (xo->flags & XFRM_XMIT))
  		return skb;
 =20
  	if (!(features & NETIF_F_HW_ESP))
@@@ -129,27 -134,20 +134,22 @@@
  		return skb;
  	}
 =20
 +	xo->flags |=3D XFRM_XMIT;
 +
- 	if (skb_is_gso(skb)) {
- 		struct net_device *dev =3D skb->dev;
-=20
- 		if (unlikely(x->xso.dev !=3D dev)) {
- 			struct sk_buff *segs;
+ 	if (skb_is_gso(skb) && unlikely(x->xso.dev !=3D dev)) {
+ 		struct sk_buff *segs;
 =20
- 			/* Packet got rerouted, fixup features and segment it. */
- 			esp_features =3D esp_features & ~(NETIF_F_HW_ESP
- 							| NETIF_F_GSO_ESP);
+ 		/* Packet got rerouted, fixup features and segment it. */
+ 		esp_features =3D esp_features & ~(NETIF_F_HW_ESP | NETIF_F_GSO_ESP);
 =20
- 			segs =3D skb_gso_segment(skb, esp_features);
- 			if (IS_ERR(segs)) {
- 				kfree_skb(skb);
- 				atomic_long_inc(&dev->tx_dropped);
- 				return NULL;
- 			} else {
- 				consume_skb(skb);
- 				skb =3D segs;
- 			}
+ 		segs =3D skb_gso_segment(skb, esp_features);
+ 		if (IS_ERR(segs)) {
+ 			kfree_skb(skb);
+ 			atomic_long_inc(&dev->tx_dropped);
+ 			return NULL;
+ 		} else {
+ 			consume_skb(skb);
+ 			skb =3D segs;
  		}
  	}
 =20

--Sig_/O/wuqT+Xgl=.=MhUIjImgu9
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7xVOMACgkQAVBC80lX
0GzM2gf8CpokgrCrdKSqihUmzzY4UWIHPsfI01o19cfy3KgOOjS3k3YdyAQiEQ8W
QTDYXHJoNTZFnlOkqtQSBNDiCzwofxGWTL1foxXRR2KlGTgnHBFcJlRJXrIPDBC6
k5oaphiyYpCMKvQPELYf6lD8RmaY4YZfjCIckEhSxiBwJI6h8BC8JODfMSLFzwuQ
A7ySiV4uNlLQfAWiygW3ond/jmg9jqApGU47iCjBENpv4HmA9Ym9MpEyQswcpVaT
JhY7VjNYWZaeZEcFmTgJZ2xpvHmA41/8RrvUNHlG7bsTPsAyLXEtNKrl9gDGNcTY
NW2uPmNMmYn7huMeOD8hL0j5oMhqdg==
=28VM
-----END PGP SIGNATURE-----

--Sig_/O/wuqT+Xgl=.=MhUIjImgu9--
