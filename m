Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011BE2A5B20
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 01:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730064AbgKDAoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 19:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgKDAoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 19:44:03 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEDFFC061A4B;
        Tue,  3 Nov 2020 16:44:02 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4CQnw01ZN4z9sPB;
        Wed,  4 Nov 2020 11:43:59 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1604450640;
        bh=w0opC8OEmqjeVqj+i2Je/xg3+AnOLhlxj013J6qVXgk=;
        h=Date:From:To:Cc:Subject:From;
        b=Gy4FnBUtYp6/7clc/dPA1/4uatCQIRgfs5PvZPHgcBtC4hqmDsJc644+c/toD2rhs
         nUcwOAaIfs1vVtDZK+plquYYglYvXTeaQJg/lw93bcCNbhQO4cq401pAcaqCs4gvKz
         +SD1wddBiKMRmk9ct/cvEG1suZzOcQ1UVb7tlryT3mb/SvorqJq1vMm9Pje0L2dJRu
         n84RL5XR3ARwlpf8GjG7zXA5nResZnTiwl8iJLo+vlXOQM42BoC/LnaROJGNK+Og04
         yQVE8e0Syr6JjMVJ6V17kyUOtgtRi7kqWZLO/8hVWVCnoaS+CIkR2cGN+dgUcb45S6
         ntNCRH/77fcZg==
Date:   Wed, 4 Nov 2020 11:43:58 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Lijun Pan <ljp@linux.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20201104114358.37e766a3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/E0wsBmc9+WG6NM_KLPNyZz6";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/E0wsBmc9+WG6NM_KLPNyZz6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/ibm/ibmvnic.c

between commit:

  1d8504937478 ("powerpc/vnic: Extend "failover pending" window")

from the net tree and commit:

  16b5f5ce351f ("ibmvnic: merge do_change_param_reset into do_reset")

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
index da15913879f8,f4167de30461..000000000000
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@@ -1930,17 -1841,12 +1850,20 @@@ static int do_reset(struct ibmvnic_adap
  	netdev_dbg(adapter->netdev, "Re-setting driver (%d)\n",
  		   rwi->reset_reason);
 =20
- 	rtnl_lock();
+ 	adapter->reset_reason =3D rwi->reset_reason;
+ 	/* requestor of VNIC_RESET_CHANGE_PARAM already has the rtnl lock */
+ 	if (!(adapter->reset_reason =3D=3D VNIC_RESET_CHANGE_PARAM))
+ 		rtnl_lock();
+=20
 +	/*
 +	 * Now that we have the rtnl lock, clear any pending failover.
 +	 * This will ensure ibmvnic_open() has either completed or will
 +	 * block until failover is complete.
 +	 */
 +	if (rwi->reset_reason =3D=3D VNIC_RESET_FAILOVER)
 +		adapter->failover_pending =3D false;
 +
  	netif_carrier_off(netdev);
- 	adapter->reset_reason =3D rwi->reset_reason;
 =20
  	old_num_rx_queues =3D adapter->req_rx_queues;
  	old_num_tx_queues =3D adapter->req_tx_queues;
@@@ -2214,17 -2140,7 +2157,14 @@@ static void __ibmvnic_reset(struct work
  		}
  		spin_unlock_irqrestore(&adapter->state_lock, flags);
 =20
- 		if (rwi->reset_reason =3D=3D VNIC_RESET_CHANGE_PARAM) {
- 			/* CHANGE_PARAM requestor holds rtnl_lock */
- 			rc =3D do_change_param_reset(adapter, rwi, reset_state);
- 		} else if (adapter->force_reset_recovery) {
+ 		if (adapter->force_reset_recovery) {
 +			/*
 +			 * Since we are doing a hard reset now, clear the
 +			 * failover_pending flag so we don't ignore any
 +			 * future MOBILITY or other resets.
 +			 */
 +			adapter->failover_pending =3D false;
 +
  			/* Transport event occurred during previous reset */
  			if (adapter->wait_for_reset) {
  				/* Previous was CHANGE_PARAM; caller locked */

--Sig_/E0wsBmc9+WG6NM_KLPNyZz6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl+h+U4ACgkQAVBC80lX
0GzU0wgAjjgCooO3kU1QGikDR89Xgb4zqYsvFQscOdl9z1qdlUmCrF8tym6xcFY5
5lcd9Pcm6wwTz8U3r7jJS7n1vbMI+eyU9UZ20gqh98LTcwMTfMMOWSj+soaJFeWF
JnR2agugi5Q1BJSSV6A97mTBKpmvsF3L/qqe+WcyH201EatLlVNOrgzz422JUzPa
yonaZl8Go0KgzR/M9JcP9apdRv0TxrnjTPKRai4JHaWIjS3pAa/MTDnk6RnnlOga
ZWxG9ffLv8QTYekTtb7sNpAHijGryKmEVTrBM7LVvqpxLoZ3ddh9IMct5xuv03NW
r9jBLI1aD8ojo7D9h6CwydJ3su4UiQ==
=nHoi
-----END PGP SIGNATURE-----

--Sig_/E0wsBmc9+WG6NM_KLPNyZz6--
