Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12E781CA174
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 05:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgEHDS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 23:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726542AbgEHDS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 23:18:56 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78EACC05BD43;
        Thu,  7 May 2020 20:18:56 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49JFsn3wgHz9sRf;
        Fri,  8 May 2020 13:18:52 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1588907934;
        bh=B4uY3Ex4bWgXSuVrB2Et/OmOJWIppEgzW97Ll3wlefI=;
        h=Date:From:To:Cc:Subject:From;
        b=A2vwtIRtSVg424z6C+2p//DAZ1FfgTNGTd7Ht/TnyTrxFRbiED6Sjqy3UGKXisBKB
         7aXVz4UeXGXWR0yqAuLYIdVDEoTqLa4JblvWnpibfa8pHN4lUkg6OOiPqd6aPp9Nti
         84khbuLjIfqBEMvYHMgW/IahPT54oQYTpQZFR7+g/bKNDyvrY6jpf04DbeAGpWx2mS
         S0dkHilRC3tdSdIP4/9zNTb0IZjkEeoMj7EgHATjYg14SRtZHvVg+k7YGmqaP+NKIC
         B0KxSUi0WZQBYn6RP3ALsu9zb28l8Z1c7O6c81lgz3PT1pTDkcgByE74OBKdb1SrJ3
         yos+AtoGdhDRw==
Date:   Fri, 8 May 2020 13:18:51 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: linux-next: manual merge of the net-next tree with the rdma tree
Message-ID: <20200508131851.5818d84d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/CRmOGYW+uQitPtT5btr_GSR";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/CRmOGYW+uQitPtT5btr_GSR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/bonding/bond_main.c

between commits:

  ed7d4f023b1a ("bonding: Rename slave_arr to usable_slaves")
  c071d91d2a89 ("bonding: Add helper function to get the xmit slave based o=
n hash")
  29d5bbccb3a1 ("bonding: Add helper function to get the xmit slave in rr m=
ode")

from the rdma and mlx5-next trees and commit:

  ae46f184bc1f ("bonding: propagate transmit status")

from the net-next tree.

I fixed it up (I think - see below) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc drivers/net/bonding/bond_main.c
index 39b1ad7edbb4,4f9e7c421f57..000000000000
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@@ -4022,32 -4024,12 +4022,30 @@@ static struct slave *bond_xmit_roundrob
  non_igmp:
  	slave_cnt =3D READ_ONCE(bond->slave_cnt);
  	if (likely(slave_cnt)) {
 -		slave_id =3D bond_rr_gen_slave_id(bond);
 -		return bond_xmit_slave_id(bond, skb, slave_id % slave_cnt);
 +		slave_id =3D bond_rr_gen_slave_id(bond) % slave_cnt;
 +		return bond_get_slave_by_id(bond, slave_id);
  	}
 +	return NULL;
 +}
 +
 +static netdev_tx_t bond_xmit_roundrobin(struct sk_buff *skb,
 +					struct net_device *bond_dev)
 +{
 +	struct bonding *bond =3D netdev_priv(bond_dev);
 +	struct slave *slave;
 +
 +	slave =3D bond_xmit_roundrobin_slave_get(bond, skb);
 +	if (slave)
- 		bond_dev_queue_xmit(bond, skb, slave->dev);
- 	else
- 		bond_tx_drop(bond_dev, skb);
- 	return NETDEV_TX_OK;
++		return bond_dev_queue_xmit(bond, skb, slave->dev);
+ 	return bond_tx_drop(bond_dev, skb);
  }
 =20
 +static struct slave *bond_xmit_activebackup_slave_get(struct bonding *bon=
d,
 +						      struct sk_buff *skb)
 +{
 +	return rcu_dereference(bond->curr_active_slave);
 +}
 +
  /* In active-backup mode, we know that bond->curr_active_slave is always =
valid if
   * the bond has a usable interface.
   */
@@@ -4057,13 -4039,11 +4055,11 @@@ static netdev_tx_t bond_xmit_activeback
  	struct bonding *bond =3D netdev_priv(bond_dev);
  	struct slave *slave;
 =20
 -	slave =3D rcu_dereference(bond->curr_active_slave);
 +	slave =3D bond_xmit_activebackup_slave_get(bond, skb);
  	if (slave)
- 		bond_dev_queue_xmit(bond, skb, slave->dev);
- 	else
- 		bond_tx_drop(bond_dev, skb);
+ 		return bond_dev_queue_xmit(bond, skb, slave->dev);
 =20
- 	return NETDEV_TX_OK;
+ 	return bond_tx_drop(bond_dev, skb);
  }
 =20
  /* Use this to update slave_array when (a) it's not appropriate to update
@@@ -4254,17 -4178,17 +4250,14 @@@ static netdev_tx_t bond_3ad_xor_xmit(st
  				     struct net_device *dev)
  {
  	struct bonding *bond =3D netdev_priv(dev);
 -	struct slave *slave;
  	struct bond_up_slave *slaves;
 -	unsigned int count;
 +	struct slave *slave;
 =20
 -	slaves =3D rcu_dereference(bond->slave_arr);
 -	count =3D slaves ? READ_ONCE(slaves->count) : 0;
 -	if (likely(count)) {
 -		slave =3D slaves->arr[bond_xmit_hash(bond, skb) % count];
 +	slaves =3D rcu_dereference(bond->usable_slaves);
 +	slave =3D bond_xmit_3ad_xor_slave_get(bond, skb, slaves);
 +	if (likely(slave))
- 		bond_dev_queue_xmit(bond, skb, slave->dev);
- 	else
- 		bond_tx_drop(dev, skb);
-=20
- 	return NETDEV_TX_OK;
+ 		return bond_dev_queue_xmit(bond, skb, slave->dev);
 -	}
+ 	return bond_tx_drop(dev, skb);
  }
 =20
  /* in broadcast mode, we send everything to all usable interfaces. */

--Sig_/CRmOGYW+uQitPtT5btr_GSR
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl60z5sACgkQAVBC80lX
0Gxkdwf+Iiz1xXqu9tmYBlt2uVHfYlCJyyD/bHqzdGntC6aAUn2IKsQG0FG8LnND
2NwBhOhSbsmRelrVZSgl8c4n1Q9zIkQxNlHqVA4OdGGUaDPrfOUEeUtprOqF7IYf
zGtsf7AgTESiv4aqJJTlGRdhNMXwZAD25oLeWukLAVIdwNgmW79rnvq2nV3OyMXD
vGaBcFdF0KrhDH+Jzbhj6PWr/Dsv2b+QLIw15ynH5xwP8kKaB4bhA9FFORz+a52S
A/4emvBL7pC32EmwhrRdjPKxZ47QBWvE0CZrTfBHJPkxY2iyaZw/2G9fhxyQu5YV
Gjw1twFjQEx6kRQ/FG8lc4TPmGn3Kg==
=/Djr
-----END PGP SIGNATURE-----

--Sig_/CRmOGYW+uQitPtT5btr_GSR--
