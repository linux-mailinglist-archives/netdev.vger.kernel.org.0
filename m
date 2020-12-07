Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C23182D0948
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 04:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728700AbgLGDKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 22:10:36 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:39345 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbgLGDKf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Dec 2020 22:10:35 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Cq7b36XfXz9sVs;
        Mon,  7 Dec 2020 14:09:51 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1607310593;
        bh=5bh4tlGoUL+1XncBIhF/LpWGb65TQqPGNgtGe+PXrV0=;
        h=Date:From:To:Cc:Subject:From;
        b=jxmi+mSGmjZITruorZ0kkMOF9O5pg0Vvo2xrLAVm2Q9Z9gAvfF0FvvoZVENeEgEWt
         MSFoC7P7inCFz83TsGqzyss4t6MIlGxTjYyiHiWRNckA1LMREDPasGybn6KwsxQfw8
         z4J5Gawg1XRLDfDfo8j40i4qoUHUQO7peDRBtoJ1mo6CUKTq69ioIFCDPwIObRnaGU
         XbjhtiwZq93as04l1exa+SSFQihZ9z0rkPhi1IVyELPTBhhBFcfROAEOXDOxWLPfuO
         RBezhvI3oAIf/io4Gd2xO731hs3iyXcjR0u9zZTXp/FiQwpZq67gk7eZpVjV9V2OsF
         DUt8YOH9t5+Sw==
Date:   Mon, 7 Dec 2020 14:09:51 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Jens Axboe <axboe@kernel.dk>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florent Revest <revest@chromium.org>,
        Florent Revest <revest@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the block tree
Message-ID: <20201207140951.4c04f26f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/5kRkZNS/rNEXgq/a/ECeDM6";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/5kRkZNS/rNEXgq/a/ECeDM6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the block tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/io_uring.c: In function 'io_shutdown':
fs/io_uring.c:3782:9: error: too many arguments to function 'sock_from_file'
 3782 |  sock =3D sock_from_file(req->file, &ret);
      |         ^~~~~~~~~~~~~~
In file included from fs/io_uring.c:63:
include/linux/net.h:243:16: note: declared here
  243 | struct socket *sock_from_file(struct file *file);
      |                ^~~~~~~~~~~~~~

Caused by commit

  36f4fa6886a8 ("io_uring: add support for shutdown(2)")

interacting with commit

  dba4a9256bb4 ("net: Remove the err argument from sock_from_file")

from the bpf-next tree.

I have applied the following merge fix patch.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 7 Dec 2020 14:04:10 +1100
Subject: [PATCH] fixup for "net: Remove the err argument from sock_from_fil=
e"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cd997264dbab..91d08408f1fe 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3779,9 +3779,9 @@ static int io_shutdown(struct io_kiocb *req, bool for=
ce_nonblock)
 	if (force_nonblock)
 		return -EAGAIN;
=20
-	sock =3D sock_from_file(req->file, &ret);
+	sock =3D sock_from_file(req->file);
 	if (unlikely(!sock))
-		return ret;
+		return -ENOTSOCK;
=20
 	ret =3D __sys_shutdown_sock(sock, req->shutdown.how);
 	io_req_complete(req, ret);
--=20
2.29.2

--=20
Cheers,
Stephen Rothwell

--Sig_/5kRkZNS/rNEXgq/a/ECeDM6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/NnP8ACgkQAVBC80lX
0Gy0WQf9GaIM5CBSqUjd7N8Mw2U6mjQytrpDmJxXIlAEOic/wBwRrwkQBzjYm4Bh
qW68SyvoswdL/oYgw3N07QXs3Ktf7P0f3Ul5w70ugh0rHVMW6Q7E7dnuwtxRPCI6
qKKyBe0yXMHj/jJLSP6L4ki+N5ltUdULO3V22XrqPGbYt0xBs1BSXn3nYlQEHn8L
MwX8O69VO260FJHPz6+7MglxFW7df2WaRBsprGqfUHMY6QDVcENafpIu9wWyinRH
lhyCL09pO0l4S21N6JXbJCUbXdY4bDS3EC+fgd3t5FpIzCkCy8XGwlywTmVBc/ow
2VKP4fiZVOEsoxpbeHA6Bl41dZYeHw==
=ds5/
-----END PGP SIGNATURE-----

--Sig_/5kRkZNS/rNEXgq/a/ECeDM6--
