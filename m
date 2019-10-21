Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 311FADE15D
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 02:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfJUAIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 20:08:07 -0400
Received: from ozlabs.org ([203.11.71.1]:60091 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726576AbfJUAIH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Oct 2019 20:08:07 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46xH5w6D4Nz9sNx;
        Mon, 21 Oct 2019 11:08:04 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1571616485;
        bh=X9w5V/XTy4bCeUmkoajC65IM6vFKbBsy/YOD7h9VvnA=;
        h=Date:From:To:Cc:Subject:From;
        b=BeMyn70HjTuQED2UU0IF+TeZAEmEE8infGIEHcwdKmVz1u1HCYrdA/dCVoa/dSADU
         QA/xgnstFLEoUvv6W+mDuEwip4wU2TWJLg/VwvT9wcPr48d3kmTa1Yp7uy1l7UFEUT
         b8poZEZiGqHlQetJ65+cnOy/0TTcVh2XwpmJxM0rT6EdPU7n+LWDOO99x2WpHRz/AC
         50cmAYp0YIkDNtzNTVZn1RdBcEfr7qA5sdJMUd+l2Vm2yZn79Ou+lDoW47YYDYAAnK
         5QL6eKtzTATDpKz861VWNwVmJNt+l36AsiUuoJ9sXuVbXm1Vz93Bmh7y5lY8ZDFOop
         walcMpYzqnubw==
Date:   Mon, 21 Oct 2019 11:07:45 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: linux-next: manual merge of the net-next tree with Linus' tree
Message-ID: <20191021110745.3c7563a4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/QMu1u_AWC0pXc5bHC_x_aNk";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/QMu1u_AWC0pXc5bHC_x_aNk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  include/net/net_namespace.h

between commit:

  2a06b8982f8f ("net: reorder 'struct net' fields to avoid false sharing")

from Linus' tree and commit:

  a30c7b429f2d ("net: introduce per-netns netdevice notifiers")

from the net-next tree.

I fixed it up (see below - but it clearly needs more thought) and can
carry the fix as necessary. This is now fixed as far as linux-next is
concerned, but any non trivial conflicts should be mentioned to your
upstream maintainer when your tree is submitted for merging.  You may
also want to consider cooperating with the maintainer of the conflicting
tree to minimise any particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc include/net/net_namespace.h
index 4c2cd9378699,5ac2bb16d4b3..000000000000
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@@ -102,14 -94,14 +103,15 @@@ struct net=20
 =20
  	struct uevent_sock	*uevent_sock;		/* uevent socket */
 =20
 -	struct list_head 	dev_base_head;
  	struct hlist_head 	*dev_name_head;
  	struct hlist_head	*dev_index_head;
+ 	struct raw_notifier_head	netdev_chain;
 +	/* Note that @hash_mix can be read millions times per second,
 +	 * it is critical that it is on a read_mostly cache line.
 +	 */
 +	u32			hash_mix;
 =20
 -	unsigned int		dev_base_seq;	/* protected by rtnl_mutex */
 -	int			ifindex;
 -	unsigned int		dev_unreg_count;
 +	struct net_device       *loopback_dev;          /* The loopback */
 =20
  	/* core fib_rules */
  	struct list_head	rules_ops;

--Sig_/QMu1u_AWC0pXc5bHC_x_aNk
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl2s9tEACgkQAVBC80lX
0GwZpwgAkoebksFVR77r9Wjmyx1QSfLT6xE+3K8mT+eQ70TVcHY4DzSFxuqNhp9C
nwCyGorGYrcdi4toAQrE7pxExLdArXdma90EHa7HjRxyO6hJO+UUJKE6wTQVF9Hw
pX85LM0jtoUJewpPdngcv+lY4T2Q75GqLyNHUeTcJCdosATgrCmvsiB9zKGUPJo8
yZtXvQexcfDTKZmRclVAxBCCuhe78R+2Ptc0EwbBmnDisZFoXLUYT2A/ZyOjVoWR
RK9803tVm0KVNCVHvpwTyTR4zRIi23GnzmH2oMkNoykdbGioT0gIC+5muEvlVy9+
hhw2kK5a7Ml6ROqFRgJYhhvn25hCVQ==
=fbdo
-----END PGP SIGNATURE-----

--Sig_/QMu1u_AWC0pXc5bHC_x_aNk--
