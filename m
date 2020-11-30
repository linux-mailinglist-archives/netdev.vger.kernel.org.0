Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312752C7CA1
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 03:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbgK3CDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 21:03:08 -0500
Received: from ozlabs.org ([203.11.71.1]:59621 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726304AbgK3CDH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Nov 2020 21:03:07 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4CkpQT3mkXz9sVD;
        Mon, 30 Nov 2020 13:02:24 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1606701745;
        bh=2VqswGgISJ85b78+3RIRPfPLRDwCtT1hBsQh9lU4WMg=;
        h=Date:From:To:Cc:Subject:From;
        b=Y4ln3O0pTFu4JUKztf2AiKENqu09E8uJVffywreLp0UHRznOG69ub065XBgTVsIGM
         8sF/Jpq/0NOF+JaxGVOtIN/F70amCfB3IqCswFskM4h9Kfm+oPf386Zvi24ycyEe95
         +El8IbmT47yixafklKHQvafM5jiSvKvBqSgk1n5VYF1hPFSi0dXXkvF+SgZ5Ffx8mU
         b2TfH6bm0HzcTebslSZEmphS4UGsgxcDv8DhShw8lUGpAcGDiKYt/kwefJZlBH5F1P
         kaojLYjN3LgGGXENB6qUAkd0mny7iDQHzBJw9hL2Jnwyws8sTFyTBQKhw+o+ecuqiP
         NXrSDB7KleFtQ==
Date:   Mon, 30 Nov 2020 13:02:23 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20201130130223.7788ec13@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/i6spTRcI96U1kQSjQcHWAur";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/i6spTRcI96U1kQSjQcHWAur
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/ibm/ibmvnic.c

between commit:

  9281cf2d5840 ("ibmvnic: avoid memset null scrq msgs")

from the net tree and commit:

  f019fb6392e5 ("ibmvnic: Introduce indirect subordinate Command Response Q=
ueue buffer")

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
index bca1becd33f0,cdd1ff9aa9c4..000000000000
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@@ -2874,14 -2959,11 +2968,15 @@@ static int reset_one_sub_crq_queue(stru
  		irq_dispose_mapping(scrq->irq);
  		scrq->irq =3D 0;
  	}
 -
 -	memset(scrq->msgs, 0, 4 * PAGE_SIZE);
 -	atomic_set(&scrq->used, 0);
 -	scrq->cur =3D 0;
 -	scrq->ind_buf.index =3D 0;
 +	if (scrq->msgs) {
 +		memset(scrq->msgs, 0, 4 * PAGE_SIZE);
 +		atomic_set(&scrq->used, 0);
 +		scrq->cur =3D 0;
++		scrq->ind_buf.index =3D 0;
 +	} else {
 +		netdev_dbg(adapter->netdev, "Invalid scrq reset\n");
 +		return -EINVAL;
 +	}
 =20
  	rc =3D h_reg_sub_crq(adapter->vdev->unit_address, scrq->msg_token,
  			   4 * PAGE_SIZE, &scrq->crq_num, &scrq->hw_irq);

--Sig_/i6spTRcI96U1kQSjQcHWAur
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/EUq8ACgkQAVBC80lX
0GxrBQf9GFHS+B+ySn7XhaqVfFFHEjb7eEke822BTjurjhtu8+coEuIFBMbU1e6n
ldHlmx6h4QE8AuaVAI8BHHct+9Z8OuGJ79glHJEj7+OCq3O/6QaJ2FVM+uCdcB54
n1Lg+IObiMVBbx5Y8WKnF+omPyVlykPc7KnSXxqvSxAG0OzKKnPhrCIuei8k5LCD
GfpfL73gNTqj+1+sWPWDiQ0L11yTM8I1wveHHC++cDtdCKZV27lVUjTuz4xZQDoB
4gmQNJ8BDpc6VvCFuarZMkGUi9DkhfNCeO/BJpzxqWYjgnoZhDONn4jK6ayGo9Wo
b95wa1vfXquxS83XlOdPWt9oN1Knzg==
=fqtQ
-----END PGP SIGNATURE-----

--Sig_/i6spTRcI96U1kQSjQcHWAur--
