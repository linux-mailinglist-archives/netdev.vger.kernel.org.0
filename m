Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696A631D3D8
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 02:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbhBQBo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 20:44:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhBQBoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 20:44:23 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBBA0C061574;
        Tue, 16 Feb 2021 17:43:42 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DgLGL4tglz9sBy;
        Wed, 17 Feb 2021 12:43:38 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1613526219;
        bh=YxHG4aTt8Q+DJqmCsA/7VHsTg8HAhTeywx2/Ow/y8mk=;
        h=Date:From:To:Cc:Subject:From;
        b=QET1vpacsoO/PsOPZm50Zg9AUU6GXGCBMqBu9uz0ujKGRaXrMjvevwqqVInfVqwbw
         Xizy4XdoTryCce0Y1tUQquHrmLvg9kYYs1O8Ewj5+9m1y9mHZx4vaBaJaOqHCc28bo
         1pRHFtSvcmUevRyvr6nJW6k6FwC4O07Eo4NbpaCy5kWAgKkpzRmDqpk0RLnsGpQW1O
         1F+wvPksGVIhVWh41lS3KehEs0hvyFsFJS+2D0HoK3V5RCnerTE+bQcxjPKXJxe0u4
         cRMxkFNBPKUywk6kBJ0eBo76kjLcjJcjcTeoSOXPDc1o61xoc5LSMtj1b4HUfWysR8
         CPI8UwmHty//Q==
Date:   Wed, 17 Feb 2021 12:43:37 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Lijun Pan <lijunp213@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20210217124337.47db7c69@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/LS2qvUpNPap5oaYhIxbUHgR";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/LS2qvUpNPap5oaYhIxbUHgR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got conflicts in:

  drivers/net/ethernet/ibm/ibmvnic.c
  drivers/net/ethernet/ibm/ibmvnic.h

between commit:

  4a41c421f367 ("ibmvnic: serialize access to work queue on remove")

from the net tree and commits:

  bab08bedcdc3 ("ibmvnic: fix block comments")
  a369d96ca554 ("ibmvnic: add comments for spinlock_t definitions")

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

diff --cc drivers/net/ethernet/ibm/ibmvnic.c
index 13ae7eee7ef5,927d5f36d308..000000000000
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@@ -2395,10 -2288,7 +2294,9 @@@ static int ibmvnic_reset(struct ibmvnic
  	unsigned long flags;
  	int ret;
 =20
 +	spin_lock_irqsave(&adapter->rwi_lock, flags);
 +
- 	/*
- 	 * If failover is pending don't schedule any other reset.
+ 	/* If failover is pending don't schedule any other reset.
  	 * Instead let the failover complete. If there is already a
  	 * a failover reset scheduled, we will detect and drop the
  	 * duplicate reset when walking the ->rwi_list below.
diff --cc drivers/net/ethernet/ibm/ibmvnic.h
index 72fea3b1c87d,270d1cac86a4..000000000000
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@@ -1080,10 -1081,12 +1081,16 @@@ struct ibmvnic_adapter=20
 =20
  	struct tasklet_struct tasklet;
  	enum vnic_state state;
 -	/* Used for serializatin of state field */
++	/* Used for serialization of state field. When taking both state
++	 * and rwi locks, take state lock first.
++	 */
+ 	spinlock_t state_lock;
  	enum ibmvnic_reset_reason reset_reason;
- 	/* when taking both state and rwi locks, take state lock first */
- 	spinlock_t rwi_lock;
  	struct list_head rwi_list;
 -	/* Used for serialization of rwi_list */
++	/* Used for serialization of rwi_list. When taking both state
++	 * and rwi locks, take state lock first
++	 */
+ 	spinlock_t rwi_lock;
  	struct work_struct ibmvnic_reset;
  	struct delayed_work ibmvnic_delayed_reset;
  	unsigned long resetting;

--Sig_/LS2qvUpNPap5oaYhIxbUHgR
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmAsdMkACgkQAVBC80lX
0Gzo1Af/WN8ZaEECThEe1tEdCs7VQuezb+570ogkGwa7mRW+6+jfe1eUXEqsMcRh
y6HkWZLIeUqF3JL3a/QJutpxz2orsZJksSohEEzuOL9UW6KFmBmDo8bT+JaU175S
wh0cquRKBuuMf41rWCo5i3McFllK1IfITDcz5HKXakACMtddkmvCd5doleDovx8f
VsnheZoqE/Awg9NxIFw1UgPn0J4e4kI+VXvRhTzdtoMU5Z/sq54S5+upkRpRPIdQ
o39CH+rm79Wuad49QGPbjH70Yd7e/Nj9xbVKqAXbkjnYSS/o6G/4R1kxBWkWZU6i
7y+OOSjcXkpO/BLNhrcgf1UX6v84Pw==
=eiXC
-----END PGP SIGNATURE-----

--Sig_/LS2qvUpNPap5oaYhIxbUHgR--
