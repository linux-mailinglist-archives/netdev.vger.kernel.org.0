Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE3C45D2A7
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 02:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346733AbhKYB7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 20:59:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347359AbhKYB5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 20:57:17 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB738C06139E;
        Wed, 24 Nov 2021 17:23:12 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4J00W201Zhz4xbC;
        Thu, 25 Nov 2021 12:23:09 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1637803390;
        bh=BCmABNL8H1gx0oQrVYQp9yxanjIOM1oYqNOSzCOnkt0=;
        h=Date:From:To:Cc:Subject:From;
        b=fE5gMnJpJrz0hvOAW4xispXwwer4+acawz3OFkpCL59KmPoUSKVpGVUxq56RDqjsH
         xhL/iMIJJqPn9AYvJcR5WP9HolnUFUVe98c1Mp7uExmNNWnIo9qMRVN99vFQpbHKso
         +vx4EwSTFTTD7DgvrG3TlFms7QZfqJLgEutT7AkbjmQ3VlBL7DuW4QSPJR0KVAp21T
         CT6zUvYevQbYIvx4BoFCY5w1qY5nR1lvdD7O/6lcA7Tl5a2TaZavJO6Dt+xDEYAKvJ
         lmNHeU4NL3gF5k1dLDQAo9rLQMXlWVYEfNveufJnIqyhm+HXPWjo8OB6ZzsJlcbPb7
         4Z00HWSCS8PWg==
Date:   Thu, 25 Nov 2021 12:23:07 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the vhost tree
Message-ID: <20211125122307.090784cb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Kb2w7RwEjjM9ZSeleIAODtS";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Kb2w7RwEjjM9ZSeleIAODtS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the vhost tree, today's linux-next build (x86_64
allmodconfig) failed like this:

net/vmw_vsock/virtio_transport.c:734:3: error: 'struct virtio_driver' has n=
o member named 'suppress_used_validation'
  734 |  .suppress_used_validation =3D true,
      |   ^~~~~~~~~~~~~~~~~~~~~~~~
net/vmw_vsock/virtio_transport.c:734:30: error: initialization of 'const un=
signed int *' from 'int' makes pointer from integer without a cast [-Werror=
=3Dint-conversion]
  734 |  .suppress_used_validation =3D true,
      |                              ^~~~
net/vmw_vsock/virtio_transport.c:734:30: note: (near initialization for 'vi=
rtio_vsock_driver.feature_table_legacy')

Caused by commit

  f124034faa91 ("Revert "virtio_ring: validate used buffer length"")

interacting with commit

  f7a36b03a732 ("vsock/virtio: suppress used length validation")

from the net tree.

I have reverted commit f7a36b03a732 for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/Kb2w7RwEjjM9ZSeleIAODtS
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmGe5XsACgkQAVBC80lX
0GzYYQgAhCbEXUR6I7i2zyksjS/dlHgkNADubcqjyHp8LFviUaFEi4+74lhaf0AQ
Rww9iN2hfQtNwL1rJiBZ80g6nMDBu+Lf/lCM045XjJ7TuVN0VK09D3Bq8iUSI76v
xD95PiXgCNHKXqNCWi6cZMJMpCb8oC/IVWRNTAjkAY+QoXmvnzYjWBXvrmKvewVT
HzbQeoLlxp3iEsqEj+P6onmMOPULXjP0rToQ0EPxhYa/QfeenP/8/CNEypY8OTsP
xsowaSf06ZaBuWq5LS8MKtEkO/gCl4yOvvGFFeerWOlySCCe3vk00jTgL1Hs1hYt
Cq2WdF60fJiiX7J4GHIALNFIBZ8B/g==
=neLn
-----END PGP SIGNATURE-----

--Sig_/Kb2w7RwEjjM9ZSeleIAODtS--
