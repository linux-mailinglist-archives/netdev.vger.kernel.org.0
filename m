Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322774CEE58
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 00:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbiCFXPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 18:15:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbiCFXPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 18:15:36 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA7323BF9;
        Sun,  6 Mar 2022 15:14:42 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KBcqd2hTvz4xvS;
        Mon,  7 Mar 2022 10:14:36 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1646608477;
        bh=aEQWMqXdoCOIPAGzph08yIKzBRNDLEBPjztdvdKgsxI=;
        h=Date:From:To:Cc:Subject:From;
        b=da4/zggK4h0oxQLkbp+BpzP6JTFgUvdgJscjxkUoAMfSGLahGu7I4l/gmaIW+ZXcC
         6WqfFZ9got+GeFy9Str5JVyp0eL+ddGXdGT+PMsxYpSr6ZE8p0AHdRRyQxGiZl8zAC
         b1dvxSCYGJCK3+lbk3V4/wIwwaJFAv5p61DnFQucF4XA5xMrlIMt2oo9dGZvKg7TzC
         dhoNwbxjq1vO6UCsaIOL6f5fLHjwrPn4rrWqOHJt1tMhsOGMwOLxE+RuwHyz3ulEOT
         6L//q4SQvyrMeFWYNwmkEO2olPO7DWpLYYWAhrLaB6yHpbzLMQHiHkxaOe3yb7mZTG
         ERMXk9axjWqzg==
Date:   Mon, 7 Mar 2022 10:14:36 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20220307101436.7ae87da0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/YFuQs165iYKTP7YjEyi1H7z";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/YFuQs165iYKTP7YjEyi1H7z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/dsa/dsa2.c

between commit:

  afb3cc1a397d ("net: dsa: unlock the rtnl_mutex when dsa_master_setup() fa=
ils")

from the net tree and commit:

  e83d56537859 ("net: dsa: replay master state events in dsa_tree_{setup,te=
ardown}_master")

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

diff --cc net/dsa/dsa2.c
index 074e4a69a728,d5f21a770689..000000000000
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@@ -1064,9 -1078,18 +1078,18 @@@ static int dsa_tree_setup_master(struc
 =20
  	list_for_each_entry(dp, &dst->ports, list) {
  		if (dsa_port_is_cpu(dp)) {
- 			err =3D dsa_master_setup(dp->master, dp);
+ 			struct net_device *master =3D dp->master;
+ 			bool admin_up =3D (master->flags & IFF_UP) &&
+ 					!qdisc_tx_is_noop(master);
+=20
+ 			err =3D dsa_master_setup(master, dp);
  			if (err)
 -				return err;
 +				break;
+=20
+ 			/* Replay master state event */
+ 			dsa_tree_master_admin_state_change(dst, master, admin_up);
+ 			dsa_tree_master_oper_state_change(dst, master,
+ 							  netif_oper_up(master));
  		}
  	}
 =20

--Sig_/YFuQs165iYKTP7YjEyi1H7z
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmIlQFwACgkQAVBC80lX
0GzeuQf7Bwf9dz0BDxU3kURL6XgCo4QmQ7w1lTSP9AIfFMHX/G6PLiHzH6eOPnfW
00ED2iMXzLRaCRwXs7Pm+d656HEPLgfAZCTC9nV8dAPxtPtEUjGLXJmgEAyXsP0Y
FhL8OzHd3/5xovWqUbavMWxIgwfpGOo+ngMRRFerMt0yolum3HwAAIWjLPukPYA5
MQRw1gM0dzqRToLRCNl+Bzzkfx0tLz5KJi29HEpTk6ok6HTJoZ0VHutViqJelssD
G+5GNXu7t/MZ10ZxL16JCH4NiSbBmwTmvbe59IA5pFbCXok7AWDLXHtJbpJAVq74
ptqYQ4Bm9kfR+ppux7N8fNmYNBAdrA==
=AcCJ
-----END PGP SIGNATURE-----

--Sig_/YFuQs165iYKTP7YjEyi1H7z--
