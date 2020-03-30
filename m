Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99BD019724D
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 04:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgC3CGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 22:06:48 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:36265 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727801AbgC3CGs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Mar 2020 22:06:48 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48rG6W4swcz9sPR;
        Mon, 30 Mar 2020 13:06:43 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1585534005;
        bh=0y0U+Mr8OwI1iN2DZ+X0btlBxibOGWhQY/KkqJ6L2GU=;
        h=Date:From:To:Cc:Subject:From;
        b=iqTUzPx+Pj3Vvc04JgYyAFf6JTcSaVBbbS5K599XRLvuy7f/o6QksUkrv75QvRL6J
         2Gq9OeApjUvHzFoYglF302jpWYfv+A1XBEIbWCy0EKf8j8UdEKdXqKhDw5XmtNXnjn
         i+NEwZuQGnz1CR/ZK2H5ENnZKlkjo1h1Kf6WVDbQnTrJTm21fut2ggRuWUbJuHiM3F
         q2eOjA86RvtxIZ40exX20Pqjw70K7sQXkfIAQwUMzqhyu7vVdncXM0ZlwndDGnpFay
         cv3iu17baKj7dy2/h7YsPrx1eJAMVSzVjJddqzbswjXjKslYcDkHxMnLtj5wHH/LVT
         5ie0iDrdhMxug==
Date:   Mon, 30 Mar 2020 13:06:36 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Howells <dhowells@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KP Singh <kpsingh@google.com>
Subject: linux-next: manual merge of the keys tree with the bpf-next tree
Message-ID: <20200330130636.0846e394@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/=kvtbqHtnR+XTN_0xhli37h";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/=kvtbqHtnR+XTN_0xhli37h
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the keys tree got a conflict in:

  include/linux/lsm_hooks.h

between commit:

  98e828a0650f ("security: Refactor declaration of LSM hooks")

from the bpf-next tree and commits:

  e8fa137bb3cb ("security: Add hooks to rule on setting a watch")
  858bc27762c1 ("security: Add a hook for the point of notification inserti=
on")

from the keys tree.

I fixed it up (I used the former version of this file and added the
following merge resolution patch) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 30 Mar 2020 12:55:31 +1100
Subject: [PATCH] security: keys: fixup for "security: Refactor declaration =
of
 LSM hooks"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/lsm_hook_defs.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 9cd4455528e5..4f8d63fd1327 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -252,6 +252,16 @@ LSM_HOOK(int, 0, inode_notifysecctx, struct inode *ino=
de, void *ctx, u32 ctxlen)
 LSM_HOOK(int, 0, inode_setsecctx, struct dentry *dentry, void *ctx, u32 ct=
xlen)
 LSM_HOOK(int, 0, inode_getsecctx, struct inode *inode, void **ctx,
 	 u32 *ctxlen)
+#ifdef CONFIG_KEY_NOTIFICATIONS
+LSM_HOOK(int, 0, watch_key, struct key *key)
+#endif
+#ifdef CONFIG_DEVICE_NOTIFICATIONS
+LSM_HOOK(int, 0, watch_devices, void)
+#endif
+#ifdef CONFIG_WATCH_QUEUE
+LSM_HOOK(int, 0, post_notification, const struct cred *w_cred,
+	 const struct cred *cred, struct watch_notification *n)
+#endif
=20
 #ifdef CONFIG_SECURITY_NETWORK
 LSM_HOOK(int, 0, unix_stream_connect, struct sock *sock, struct sock *othe=
r,
--=20
2.25.0

--=20
Cheers,
Stephen Rothwell

--Sig_/=kvtbqHtnR+XTN_0xhli37h
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl6BVCwACgkQAVBC80lX
0GxbRAf/SOe5GZaT6ReH7/jAinE4d7OsRxl89mO6U4JsHx/OoLjs6jeSSg3axjbD
23biOI4B0FT6r0ABXGiQ3vK39bGmDCuvhB4ZrHat4sKeIy6i175JHEO5FtQvBX0D
HNJvhaty5MeYqyXFioLecza6fcbEgEGg+Qio477a2y6wyIu1/UqVYCOeSxfQqgkW
o97Wy1T+UVTJCnKKG7K+lqYKfpgOASjfokqw5RVCmaEUQKVRsdQ07qb8MEmFeZTf
ksTk5pVb6DpNyoDghy5Sz+iAZPyvgxVMCl2Um9ZI6/2sY9qbwflF9lTzBUBlmzlr
OlFjIlU7A4Vfk+sBjWNO8pZ3KNQMGA==
=Uhwq
-----END PGP SIGNATURE-----

--Sig_/=kvtbqHtnR+XTN_0xhli37h--
