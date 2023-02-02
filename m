Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8E46889F5
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 23:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbjBBWpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 17:45:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231744AbjBBWpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 17:45:03 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E8069B3B;
        Thu,  2 Feb 2023 14:44:58 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4P7DPh2x5jz4xGq;
        Fri,  3 Feb 2023 09:44:55 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1675377896;
        bh=6wZYEA3Bc4iGOhxen05MNQBeHSf3sRdVjqTcfmUFB2s=;
        h=Date:From:To:Cc:Subject:From;
        b=lF0qN0f4T5MQfonwxYClmpGhgaDTkty9mI/4V7YIYoZtpx/+SWPXrnSyb/rU577wH
         P6g3iKqOxh5f9CWakZ1VSO2OeHKYHZhCjVwA4x9eiWjqp3Glyo51dt3QrlBcGL6Vop
         0AI7o63oVFJtjFUahuzk9iAjXaFAuMDbKEs8Qw/VUqfDlfgqbfnjA0rD4LukwR0U6J
         wTmd12tKaxNIBK1f9o6iG/Z/VNWb5NukzDiEhAwxGVUCCPwdojHKaigynC/dzPcr+8
         DbzzxmOSWaSZw/5M98asBzwNnGVTv49J/xYUHF5nCIfiuO/gVc4ZBAk5hqa4PUvUJP
         HAx+LDJuza1NQ==
Date:   Fri, 3 Feb 2023 09:44:54 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Alexander Duyck <alexanderduyck@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Xin Long <lucien.xin@gmail.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20230203094454.5766f160@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/s/FRUrAPveFg9cpX4M.mCl9";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/s/FRUrAPveFg9cpX4M.mCl9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/core/gro.c

between commit:

  7d2c89b32587 ("skb: Do mix page pool and page referenced frags in GRO")

from the net tree and commit:

  b1a78b9b9886 ("net: add support for ipv4 big tcp")

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

diff --cc net/core/gro.c
index 4bac7ea6e025,b15f85546bdd..000000000000
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@@ -162,17 -162,10 +162,19 @@@ int skb_gro_receive(struct sk_buff *p,=20
  	struct sk_buff *lp;
  	int segs;
 =20
 +	/* Do not splice page pool based packets w/ non-page pool
 +	 * packets. This can result in reference count issues as page
 +	 * pool pages will not decrement the reference count and will
 +	 * instead be immediately returned to the pool or have frag
 +	 * count decremented.
 +	 */
 +	if (p->pp_recycle !=3D skb->pp_recycle)
 +		return -ETOOMANYREFS;
 +
- 	/* pairs with WRITE_ONCE() in netif_set_gro_max_size() */
- 	gro_max_size =3D READ_ONCE(p->dev->gro_max_size);
+ 	/* pairs with WRITE_ONCE() in netif_set_gro(_ipv4)_max_size() */
+ 	gro_max_size =3D p->protocol =3D=3D htons(ETH_P_IPV6) ?
+ 			READ_ONCE(p->dev->gro_max_size) :
+ 				READ_ONCE(p->dev->gro_ipv4_max_size);
 =20
  	if (unlikely(p->len + len >=3D gro_max_size || NAPI_GRO_CB(skb)->flush))
  		return -E2BIG;

--Sig_/s/FRUrAPveFg9cpX4M.mCl9
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmPcPOcACgkQAVBC80lX
0GwvCQf/UZLTuCF02LLqxZ+UdmtZy40lDfuMEcaiREJ1g1MtWBY+48XZ8bO2qJix
nu1BkrArHYxo9mFctsOowVMLUZnSlxXDJSFlo6f2fJiPK4q38RosuF3Z7rVLEiLA
z1jZ34+0O5R08u26hlu7LI72Og6I7y0PVmhldVjabiV8A0GoyaFEIxjEzRiIgZkA
blA9uuM6Rxf72f8EKlgeCMia8aYVLXVbK5h4G5hBx/2LAAEQvVNNU2KNIPo5mzsL
3bwPsa4MSLTP8fVC1hSUVObnbSWuEBtabhObw2G35GqnCbr3ka/MHhbj5l5fKUyD
m/QgjUm0fMEw2rzME19Q3tSDKrFK/A==
=xLLM
-----END PGP SIGNATURE-----

--Sig_/s/FRUrAPveFg9cpX4M.mCl9--
