Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 772B45128AF
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 03:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238251AbiD1BWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 21:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbiD1BWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 21:22:20 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF215A143;
        Wed, 27 Apr 2022 18:19:06 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Kpd7F0CClz4xLb;
        Thu, 28 Apr 2022 11:19:04 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1651108745;
        bh=43HtDbfov9ywobu++a/VyX3WEjSfwilq4zhhR4X/4X0=;
        h=Date:From:To:Cc:Subject:From;
        b=TbvNJM5oVVvFrmNbZrJjAjdZV3wawqDwoxLwhxoyV4rz7JisMJwp39sIluCJPB/13
         j2JIlgMuNK7kXtN2XE0f2ds2ol2mBYenLfVqUcYqHqtygevB6r4/TKkxNlp+HWQ1J9
         +ME3HkFOadhmt/L0LpB87ulh0dZ39O87h6woC8m1NnB0M+V0z6HE5dNLOcq7AtYAqp
         rBqwmfOkaEf5JNDN56pGNX1SC0rDXp2dqhKk25I8PYf9dsYuqibnewVb/GC4PK/BIG
         4wwxCims+QTQJ8dpRZjYwrAGdMPcK8+pXOV4NMxZCffjiO/S1Iwe8582vyYTKwDQ5I
         39x5vbiim/vLw==
Date:   Thu, 28 Apr 2022 11:19:03 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jeffrey Ji <jeffreyji@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20220428111903.5f4304e0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/gj=TM246SW5=dUwNSlFzx5S";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/gj=TM246SW5=dUwNSlFzx5S
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got conflicts in:

  include/linux/netdevice.h
  net/core/dev.c

between commit:

  6510ea973d8d ("net: Use this_cpu_inc() to increment net->core_stats")

from the net tree and commit:

  794c24e9921f ("net-core: rx_otherhost_dropped to core_stats")

from the net-next tree.

I fixed it up (hopefully - see below) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc include/linux/netdevice.h
index b1fbe21650bb,ac8a5f71220a..000000000000
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@@ -199,10 -200,11 +200,11 @@@ struct net_device_stats=20
   * Try to fit them in a single cache line, for dev_get_stats() sake.
   */
  struct net_device_core_stats {
 -	local_t		rx_dropped;
 -	local_t		tx_dropped;
 -	local_t		rx_nohandler;
 -	local_t		rx_otherhost_dropped;
 -} __aligned(4 * sizeof(local_t));
 +	unsigned long	rx_dropped;
 +	unsigned long	tx_dropped;
 +	unsigned long	rx_nohandler;
++	unsigned long	rx_otherhost_dropped;
 +} __aligned(4 * sizeof(unsigned long));
 =20
  #include <linux/cache.h>
  #include <linux/skbuff.h>
diff --cc net/core/dev.c
index 1461c2d9dec8,611bd7197064..000000000000
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@@ -10352,9 -10409,10 +10405,10 @@@ struct rtnl_link_stats64 *dev_get_stats
 =20
  		for_each_possible_cpu(i) {
  			core_stats =3D per_cpu_ptr(p, i);
 -			storage->rx_dropped +=3D local_read(&core_stats->rx_dropped);
 -			storage->tx_dropped +=3D local_read(&core_stats->tx_dropped);
 -			storage->rx_nohandler +=3D local_read(&core_stats->rx_nohandler);
 -			storage->rx_otherhost_dropped +=3D local_read(&core_stats->rx_otherhos=
t_dropped);
 +			storage->rx_dropped +=3D READ_ONCE(core_stats->rx_dropped);
 +			storage->tx_dropped +=3D READ_ONCE(core_stats->tx_dropped);
 +			storage->rx_nohandler +=3D READ_ONCE(core_stats->rx_nohandler);
++			storage->rx_otherhost_dropped +=3D READ_ONCE(&core_stats->rx_otherhost=
_dropped);
  		}
  	}
  	return storage;

--Sig_/gj=TM246SW5=dUwNSlFzx5S
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmJp64cACgkQAVBC80lX
0GwXdQf9Gm34hFT0KZVEKUmaJuIi0V1wuOq2mxu0KK2JmiTmcjeNY4oMqBtpoyRG
/QMCHbZezLjd2tywJFrYZs/uL1LNaCbFuEsivwTI16B2/4acsFXigJHjwjkZunJr
JIEAGyKnTmZUeHQCDhM9rom2p/RZgkQvgb5e38/bxS9VH4HnvB8HiJcpPLACOira
Ug6vNgyloozGGJ7mRqS+lV/w+QMCH3Y+ncZqy4qv/dm7Fh69txrhwA8lECc/HGFF
T9j2p+ceoUbrxlCdK/SWodplc4yORqEuF6qXxpggdr1Le1jmPAvx/XD9oKJUODop
BsKnsHppQmhai6RkLSUoHZDQZ+FJYw==
=bQMN
-----END PGP SIGNATURE-----

--Sig_/gj=TM246SW5=dUwNSlFzx5S--
