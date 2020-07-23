Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24B122A50F
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 04:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387700AbgGWCIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 22:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733203AbgGWCIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 22:08:07 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393D9C0619DC;
        Wed, 22 Jul 2020 19:08:07 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BBwhz0Yhmz9sQt;
        Thu, 23 Jul 2020 12:08:02 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1595470083;
        bh=owUD0kdlOFOzkEkx8FaWp1UtnZL9GuFvwkguaeSWoMU=;
        h=Date:From:To:Cc:Subject:From;
        b=B27qBmpRz0BLqdjaFaffcL5xJtBOGDWZ/iXiDNQZRQJH5Bb0kI2IpkbkltMZLyeBl
         1vZfWXN4bwy0rVAbbNHblgpYLrp1Ed4f8JSM+EasO7eJjgLSvJ9Qo9+dPCvUmVFq0/
         7E4HPS29wbgmQ9H5q+hwp3cSVKCLWtuFLQXoaUS1puPXanOrfK80oliM3YRPvh4AIs
         6BOGFoNoimeMPkwi8zWV7KmX046o42cstFdVDbsCx2BdRSAX61t/rNVcNu8kA/YuJu
         U1L5SjzLGY2mWR20DGGwJiKwHrTIh7LNHK5Fs3QR4jF+nX9m2bkGBL8+rGRaTpPrzd
         Xx18nb01mWrLA==
Date:   Thu, 23 Jul 2020 12:08:00 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Taehee Yoo <ap420073@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20200723120800.4b47765d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/hzHZ8ZhWYP=KJq6Hn.AHKvx";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/hzHZ8ZhWYP=KJq6Hn.AHKvx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/netdevsim/netdev.c

between commit:

  2c9d8e01f0c6 ("netdevsim: fix unbalaced locking in nsim_create()")

from the net tree and commit:

  424be63ad831 ("netdevsim: add UDP tunnel port offload support")

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

diff --cc drivers/net/netdevsim/netdev.c
index 23950e7a0f81,9d0d18026434..000000000000
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@@ -316,8 -323,10 +323,10 @@@ nsim_create(struct nsim_dev *nsim_dev,=20
  err_ipsec_teardown:
  	nsim_ipsec_teardown(ns);
  	nsim_bpf_uninit(ns);
 +err_rtnl_unlock:
  	rtnl_unlock();
 -err_utn_destroy:
+ 	nsim_udp_tunnels_info_destroy(dev);
+ err_free_netdev:
  	free_netdev(dev);
  	return ERR_PTR(err);
  }

--Sig_/hzHZ8ZhWYP=KJq6Hn.AHKvx
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8Y8QAACgkQAVBC80lX
0GwfGQf+M5Bo9PDLJS0r7D63Fo5fqMVE7pcMYJsQ4T5qv8dtA8INYp5IWicI85iW
WDnU51kXS2rTs3WCHxXQi2aYuu1xnhKQe1EE1+Frf/mdqbXYGKU87B/vlrbjXE+F
v3trWILt3onYiOTyzRHc/tRLT9fa+WuesVqWXqeG5pQvLKhOtQk+0HfMa7OY7S7w
hFaiGnESbk5telpTDh2xS/uE+RTlPpBh20oISI+dmDD1Wgd9LygJ7YKxhVtYjlD5
x/Tk04lpi3XyPGmjNIjdnXbgK2V9rKrTrI5nyOarVe4EDHN1BIen2MJIrpfareyi
VS5dfEla2B4YC1jVpZ2vDtVGdUwmug==
=UbRI
-----END PGP SIGNATURE-----

--Sig_/hzHZ8ZhWYP=KJq6Hn.AHKvx--
