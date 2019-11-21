Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3C11047B4
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 01:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfKUAsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 19:48:21 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:47009 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbfKUAsV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 19:48:21 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47JLX261zQz9sNx;
        Thu, 21 Nov 2019 11:48:18 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1574297298;
        bh=Eu663nPfTMySBSC5/BdH1LC8Obd3ZEPCoc8HFbZQc1Q=;
        h=Date:From:To:Cc:Subject:From;
        b=GmQHdo3jK9KAw2y7kpzVIu+Slphb1oneVrNSHv7MT2nTJDTYTeCbM0cktLI8nHByv
         4XgtgPfMJv62mbnsQ1Ag0toHomJ78ZO2WMwUlGPnikJATvRo04ybiFAURmfOjiL3LR
         gt4XCYnwJpz0RUueL0pbEv+uXg+Mtp3wUyiv1RmwSNcE5g2cvA31myzaNERZ2Ylsrw
         fIqDQNgx32ZvBh0vk1ASQoTdip/L1lbNfqQQMKHjFu3eWWjNmivgXx/RXiw5qyv2EH
         IOHHRdY84OLgHcOU9gAgpi5LibUhu7pG7dqTUCKeE6KoS8BVDOrspfbPD6vqKOgMR5
         98qBZD21vO/6Q==
Date:   Thu, 21 Nov 2019 11:48:17 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20191121114817.4da07ad7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/oh3m/JgKtzHa+Mq3FQDd5L2";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/oh3m/JgKtzHa+Mq3FQDd5L2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/s390/net/qeth_l2_main.c

between commit:

  c8183f548902 ("s390/qeth: fix potential deadlock on workqueue flush")

from the net tree and commit:

  9897d583b015 ("s390/qeth: consolidate some duplicated HW cmd code")

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

diff --cc drivers/s390/net/qeth_l2_main.c
index 4bccdce19b5a,ae69c981650d..000000000000
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@@ -802,14 -779,6 +784,7 @@@ static int qeth_l2_set_online(struct cc
  		goto out_remove;
  	}
 =20
- 	if (qeth_is_diagass_supported(card, QETH_DIAGS_CMD_TRAP)) {
- 		if (card->info.hwtrap &&
- 		    qeth_hw_trap(card, QETH_DIAGS_TRAP_ARM))
- 			card->info.hwtrap =3D 0;
- 	} else
- 		card->info.hwtrap =3D 0;
-=20
 +	mutex_lock(&card->sbp_lock);
  	qeth_bridgeport_query_support(card);
  	if (card->options.sbp.supported_funcs)
  		dev_info(&card->gdev->dev,

--Sig_/oh3m/JgKtzHa+Mq3FQDd5L2
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3V3tEACgkQAVBC80lX
0GwCXAf/aTWlvWU2Hfwv9UGOgT/7JXN9HDnUBSINFgcQXKrP2BdrBsyjM/+z7b49
0e5i12Qjow4PPm7JPnCKmjKUOlQnL8GEqzu6ALZ5vMds5HA3/jYc16qj+Oouc6Jl
okvEPEncgOmNKAB0KI8ojl8yVaeUvVPfLBcMbYaJLINpSsmEGU806nZD1gTQRrYi
bZ4JhMLTmgIuOwGLae0MLLeYV8QxHv60EfC/lsltZcfew4hFpijUD6eSO/bTGG7q
qK9Vmmwb58GfM+4qEJH/UkX3Jo3sIMIYCok06M86C0RbUKh3goKAc6rxv6YIL4gT
Co8Au3WBEr+/DoRcq38gTsZxFCM7PQ==
=a6kG
-----END PGP SIGNATURE-----

--Sig_/oh3m/JgKtzHa+Mq3FQDd5L2--
