Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2661B3209
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 22:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbfIOUbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 16:31:33 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:42732 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725270AbfIOUbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 16:31:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=DHTmG2flx5Wbb2G57ya+nWxxfsP7y93jPXl0YK0JzTk=; b=Nz24fm+0BTQFwfOk/jevo5rDx
        za+kiDHAri1sNXmkQZXlDSvPGv29cZiA5lA6h9fsmcsNuyxplaDhc1n+v5OK3qE7HK/Ivey28ZOcR
        5pqwavRYho2HnSJzLGtKHCnpdm8+byZF8t1/yvuhblnZOUPAe0VZWrko1+pHu+/L8Cxa0=;
Received: from ypsilon.sirena.org.uk ([2001:470:1f1d:6b5::7])
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.co.uk>)
        id 1i9bBA-0001Fr-T3; Sun, 15 Sep 2019 20:31:28 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
        id 205AF274154D; Sun, 15 Sep 2019 21:31:28 +0100 (BST)
Date:   Sun, 15 Sep 2019 21:31:28 +0100
From:   Mark Brown <broonie@kernel.org>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: manual merge of the net-next tree with Linus' tree
Message-ID: <20190915203128.GE4352@sirena.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Dzs2zDY0zgkG72+7"
Content-Disposition: inline
X-Cookie: Man and wife make one fool.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Dzs2zDY0zgkG72+7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c

between commit:

  bf280c0387ebbf8ee ("ixgbe: fix double clean of Tx descriptors with xdp")

=66rom Linus' tree and commit:

  5c129241e2de79f09 ("ixgbe: add support for AF_XDP need_wakeup feature")

=66rom the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --cc drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index a3b6d8c89127f,ad802a8909e0d..0000000000000
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

--Dzs2zDY0zgkG72+7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl1+n58ACgkQJNaLcl1U
h9DwzQf/aI32IeWsaQisGJxSgnZg4D4nmlJ1QxJewGNBtuW4snQcWR+HkdHA4C1S
kOC5o/sh62IZOrz/SH/zy7zOzHTxxbcV4kZtPdaW9p+EtK/Bzeo2FSZaQ0M0E9LM
Ml2pMWy4odAnBuluqc71tdcBhLz1q34GGTKwESpfAysxihHMqQv6gPNQwPTvDuvx
+l5DjOM6rNqUEhvzelT3AlhsowD++F7p9TogbPjrcEz3KQ7F7et5EWH+qW16Itmy
aNEUYnx/hidqxNYALmh8qj7GKr/1/i13NSwKrjsOvFr1WSU0K0QQYZbxuPLZ0zcc
csPcEF6g+EkkwTkw8Ic/e2cjgEJh0A==
=hX7O
-----END PGP SIGNATURE-----

--Dzs2zDY0zgkG72+7--
