Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8777F204819
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 05:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731898AbgFWDvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 23:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731216AbgFWDvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 23:51:39 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24235C061573;
        Mon, 22 Jun 2020 20:51:39 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49rXQJ0Lntz9sRf;
        Tue, 23 Jun 2020 13:51:35 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1592884296;
        bh=oX9hOgZTi2rUuknzxDFes0F/Fx3ZrN09adoPuWtwlKk=;
        h=Date:From:To:Cc:Subject:From;
        b=RdRRL9W54vURvfOUEWzWUFe1JpkpN0tDYndnweuzgGaGj1ePw7uiP/AAPFG0c3IqQ
         zko8ab81ATU4iUSD83BXpFSPsuSVRJ0olTpQiRFUiUpDpg4xbNWZdnuXmxlj4kRQOu
         2T5mgwIJfSqGw+ScRyDQBZuRSiRsksFU7HG/IjmpEYSd6iIVKOPKLV6UqjT1/Z5r+d
         lSLOLOrp9q+tKG4gQ7ulyhA1ixrTcLz2AE5Tojr9ZsUHbQo2FuRTFPw7R3gUnHv2Lg
         lfuWn++buyOthJ6OZqYUI23ghBBpMfKwCcKRyq2d1tsjsJqiM1cuT/Qu9x7hm7p/B0
         8HC8QEmGAFGhA==
Date:   Tue, 23 Jun 2020 13:51:34 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Kees Cook <keescook@google.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>
Subject: linux-next: build failure after merge of the kspp tree
Message-ID: <20200623135134.61741e78@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/5foXKLlbgHi8PXwJHI11zgF";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/5foXKLlbgHi8PXwJHI11zgF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kspp tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

net/core/devlink.c: In function 'devlink_nl_port_function_attrs_put':
net/core/devlink.c:586:3: warning: parameter names (without types) in funct=
ion declaration
  586 |   int uninitialized_var(hw_addr_len);
      |   ^~~
net/core/devlink.c:589:65: error: 'hw_addr_len' undeclared (first use in th=
is function); did you mean 'hw_addr'?
  589 |   err =3D ops->port_function_hw_addr_get(devlink, port, hw_addr, &h=
w_addr_len, extack);
      |                                                                 ^~~=
~~~~~~~~
      |                                                                 hw_=
addr
net/core/devlink.c:589:65: note: each undeclared identifier is reported onl=
y once for each function it appears in

Caused by commit

  2e6d06799c15 ("compiler: Remove uninitialized_var() macro")

interacting with commit

  2a916ecc4056 ("net/devlink: Support querying hardware address of port fun=
ction")

from the net-next tree.

I have added the following merge fix patch.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 23 Jun 2020 13:43:06 +1000
Subject: [PATCH] net/core/devlink.c: remove new uninitialized_var() usage

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/core/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 455998a57671..6ae36808c152 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -583,7 +583,7 @@ devlink_nl_port_function_attrs_put(struct sk_buff *msg,=
 struct devlink_port *por
=20
 	ops =3D devlink->ops;
 	if (ops->port_function_hw_addr_get) {
-		int uninitialized_var(hw_addr_len);
+		int hw_addr_len;
 		u8 hw_addr[MAX_ADDR_LEN];
=20
 		err =3D ops->port_function_hw_addr_get(devlink, port, hw_addr, &hw_addr_=
len, extack);
--=20
2.27.0

--=20
Cheers,
Stephen Rothwell

--Sig_/5foXKLlbgHi8PXwJHI11zgF
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7xfEYACgkQAVBC80lX
0Gw0zgf+J+8qUbGRN1MxmKLPDLfvEeyIjd9dPZDnrll/oUQHkSEmbmyz4n4iWj81
LC+xmARul1dP7xQg8GG1Q4PlJj9jJz6mg2NuvSsn+H3uVtxN/Bc/+uA2p2zEJeX0
s9+H9Qiv+nEIrGK96Vhqvxf5mvBfzAEzJDkkaLaFyHDOiUCsdq8TWEdxt0Hetd9p
rEWhkB6VtXxm9K/dPHynsufNbpsBsQV0LdMAihkkdAaz2IA6NGPyKxaIfzxFU1HY
6JULxmD3n7OO6l9sC8y6qWSOVn+dbkD/CMW6spsMLdyVnCXHqVfj5zc4NYPv4jWp
1xL7zRIyd+/6M2cfHf+6NQJrglDcRw==
=/+9e
-----END PGP SIGNATURE-----

--Sig_/5foXKLlbgHi8PXwJHI11zgF--
