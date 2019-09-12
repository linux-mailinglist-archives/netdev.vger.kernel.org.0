Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C89EFB12BC
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 18:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730260AbfILQZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 12:25:41 -0400
Received: from ozlabs.org ([203.11.71.1]:40705 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728558AbfILQZk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 12:25:40 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46Tkdp19g3z9s4Y;
        Fri, 13 Sep 2019 02:25:33 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1568305537;
        bh=x7EVpTBrd+PPAAF9JFRVmnGBnTTrRhrlDywgHHXaI34=;
        h=Date:From:To:Cc:Subject:From;
        b=PbGH0BY0NAMFxGPupNcDEm5tbm3pMVYFzYC1/hEP5mBqkaN0qt6v/P1hR5g4w1ZpO
         BN/xP5R8h9YpnoGNwumuMSwE9EUS2FzQfJCS+CDefvcUnIZDsoC6pAHOHgfpOJb6gP
         QKwmXuS5BDs4MksGudG8ns/z3/z45KlkI/m5fStSUjLrjOEM7SIkoeE08EWYnVt3HM
         9GWL1A0fiwhwNLVCIiUaStzBx238jNinmmNwZEa4ZcMqkUwk0dipP9RdiZuatY3AtT
         Mr9LqZLFmsD2dZwW/x+LPP/Pm68yyzDtObIeY13HnqqLAtRDY+P09uLQXGYax24+Gc
         ycDPgM7UgVQqg==
Date:   Fri, 13 Sep 2019 02:25:35 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ilya Maximets <i.maximets@samsung.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20190913022535.65ac3420@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/sbg=Xp7+qeyvMgODT6LsEMi";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/sbg=Xp7+qeyvMgODT6LsEMi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c

between commit:

  5c129241e2de ("ixgbe: add support for AF_XDP need_wakeup feature")

from the net tree and commit:

  bf280c0387eb ("ixgbe: fix double clean of Tx descriptors with xdp")

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

diff --cc drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index a3b6d8c89127,ad802a8909e0..000000000000
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@@ -682,10 -697,19 +691,17 @@@ bool ixgbe_clean_xdp_tx_irq(struct ixgb
  	if (xsk_frames)
  		xsk_umem_complete_tx(umem, xsk_frames);
 =20
+ 	if (xsk_umem_uses_need_wakeup(tx_ring->xsk_umem)) {
+ 		if (tx_ring->next_to_clean =3D=3D tx_ring->next_to_use)
+ 			xsk_set_tx_need_wakeup(tx_ring->xsk_umem);
+ 		else
+ 			xsk_clear_tx_need_wakeup(tx_ring->xsk_umem);
+ 	}
+=20
 -	xmit_done =3D ixgbe_xmit_zc(tx_ring, q_vector->tx.work_limit);
 -
 -	return budget > 0 && xmit_done;
 +	return ixgbe_xmit_zc(tx_ring, q_vector->tx.work_limit);
  }
 =20
- int ixgbe_xsk_async_xmit(struct net_device *dev, u32 qid)
+ int ixgbe_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
  {
  	struct ixgbe_adapter *adapter =3D netdev_priv(dev);
  	struct ixgbe_ring *ring;

--Sig_/sbg=Xp7+qeyvMgODT6LsEMi
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl16cX8ACgkQAVBC80lX
0GwBhAf/evG/FHTCIzFZ1rTeK+jbbNeZsXpl5HZ0fj8MyXTbSzkoeA+EI7PjLNcC
PskWO637GNeb4wCldExYvZRcFBLpaVRoYSkusSh3J54Yzy101/fGMYTDFW6t5WnC
ywGLlwAaIwHt3qkEYm4nN0vNY0dBdc7EHFTUEKM02g2OfL3jeIClDojMato8zYxK
OPm3BtA1IFd6WiTVA53mjjV9bmvo9ClZ6m+nOZRdRIkkSTiro1x1AZ/aL5tPOSBp
zqPc6fHTAHhLknQmxSvlY4btadDH2QGcqOLKVqWsLkQV4k56DWqkgjsQsfo3Q6DX
3oCNWcOo/gtBvqIkHG91Fw/h5D3QAQ==
=krD2
-----END PGP SIGNATURE-----

--Sig_/sbg=Xp7+qeyvMgODT6LsEMi--
