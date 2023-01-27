Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D84D767DB50
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 02:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjA0BgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 20:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjA0BgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 20:36:09 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5327E1B3;
        Thu, 26 Jan 2023 17:36:07 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4P30XP55mhz4xGM;
        Fri, 27 Jan 2023 12:36:05 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1674783365;
        bh=QpcQXyZx/EC9cb29y4iHNb99wmw63VWK8dYKcS0KQdE=;
        h=Date:From:To:Cc:Subject:From;
        b=l6yE4VwRHmKmbOchBtaYU4FHMaqRXE27UQwF3T/LXVKOqPDCoWkqx+fjCdGRKU60R
         PeHPYS6qbbIapwkUfHgvIuuiIa9VWmLCIrq9U5BSdRiwzJHhsTWH0ZigWUSVcs8SsF
         6SxmkWpJM0J67/8UGWILBTc+52ntqxViS4JPvtCjlRH1RAsF1/+xWqODrXhDlVt3Gn
         GmOkaUQvZKi9uKhS08IKJM5mPyydXbDxAEGjFp9VrZ6pIeE76mwipVDbRD2vgooKle
         6NhFDnXLIT/wF7E1SjgrJ1SgShLW8+VoBKkX/UhIqZXv9g7KVrmJMoT0S2L10hbIWv
         fQ6qflx0VKCww==
Date:   Fri, 27 Jan 2023 12:36:04 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20230127123604.36bb3e99@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/NZf=sKxk=GAHUS09KqeBWby";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/NZf=sKxk=GAHUS09KqeBWby
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/engleder/tsnep_main.c

between commit:

  3d53aaef4332 ("tsnep: Fix TX queue stop/wake for multiple queues")

from the net tree and commit:

  25faa6a4c5ca ("tsnep: Replace TX spin_lock with __netif_tx_lock")

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

diff --cc drivers/net/ethernet/engleder/tsnep_main.c
index 00e2108f2ca4,e9dfefba5973..000000000000
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@@ -450,10 -458,8 +458,8 @@@ static netdev_tx_t tsnep_xmit_frame_rin
  		/* ring full, shall not happen because queue is stopped if full
  		 * below
  		 */
 -		netif_stop_queue(tx->adapter->netdev);
 +		netif_stop_subqueue(tx->adapter->netdev, tx->queue_index);
 =20
- 		spin_unlock_irqrestore(&tx->lock, flags);
-=20
  		return NETDEV_TX_BUSY;
  	}
 =20
@@@ -493,11 -495,9 +495,9 @@@
 =20
  	if (tsnep_tx_desc_available(tx) < (MAX_SKB_FRAGS + 1)) {
  		/* ring can get full with next frame */
 -		netif_stop_queue(tx->adapter->netdev);
 +		netif_stop_subqueue(tx->adapter->netdev, tx->queue_index);
  	}
 =20
- 	spin_unlock_irqrestore(&tx->lock, flags);
-=20
  	return NETDEV_TX_OK;
  }
 =20
@@@ -567,13 -701,13 +701,13 @@@ static bool tsnep_tx_poll(struct tsnep_
  	} while (likely(budget));
 =20
  	if ((tsnep_tx_desc_available(tx) >=3D ((MAX_SKB_FRAGS + 1) * 2)) &&
 -	    netif_queue_stopped(tx->adapter->netdev)) {
 -		netif_wake_queue(tx->adapter->netdev);
 +	    netif_tx_queue_stopped(nq)) {
 +		netif_tx_wake_queue(nq);
  	}
 =20
- 	spin_unlock_irqrestore(&tx->lock, flags);
+ 	__netif_tx_unlock(nq);
 =20
- 	return (budget !=3D 0);
+ 	return budget !=3D 0;
  }
 =20
  static bool tsnep_tx_pending(struct tsnep_tx *tx)

--Sig_/NZf=sKxk=GAHUS09KqeBWby
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmPTKoQACgkQAVBC80lX
0GwmIAgAhq33cIDho0VbMWndYimZDUL4jf257qzHZdsWzJnvM0XwOhRThjsLSGEB
2HDsflQCIdvDlu8T+zXBEraMvoyl57H2p9xIvQ5fBunmvE0Npm4MIHV5cFnCCD/2
BY5My7WAaSjo0s9rnmlAGQGo5UX+h8w99oCpE1Bq7WlDsfIWsAGDdS/KeiS/lbBe
6wq0UhXiaJTsewwATJYRa6Jh5wkwz3rqHSOBTZcN9+RqXiRAXcuLEKdOdWSLnKU6
oA3CYb4BiG9yVkxlK4hTm3QYhvfY1FQJnpxtD7Bg0iOj/tD+PnmFxXNo4Mg9Nhbl
MuQzPHOjF/fdM+gESkSdSYCs6IPX1g==
=glic
-----END PGP SIGNATURE-----

--Sig_/NZf=sKxk=GAHUS09KqeBWby--
