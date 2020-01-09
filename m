Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3732113641C
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 00:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729804AbgAIX5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 18:57:50 -0500
Received: from ozlabs.org ([203.11.71.1]:34947 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729706AbgAIX5t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 18:57:49 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47v32d5WMzz9sPJ;
        Fri, 10 Jan 2020 10:57:44 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1578614265;
        bh=TD8bO5jX3Cr1I+bGYFerSH/F4hLEBVl6YkrtZuz68zM=;
        h=Date:From:To:Cc:Subject:From;
        b=LsQyQfMlP1tgYGBZJgmTIEEz5R1UP4JmnyNqf8bBsjEzii9VSjUr3hvHaVyGT7aU5
         GemcnYx75IR4YAWxpC6B75fahuRcIofOMbLX9FryEFfokKgjQ0VLmNG4NwP+pR7/3X
         2ecdPXeJnJKqDBQf+Ah703P0P3Mo/3Zwn6BXh+xlMsyekJTnLHoef577NnFvgwTj4Q
         2cpowU1NwBf/UxOOw85XLkrGb3aaND3+14ipaoxgmXbaqYRtLYKDTvGIWc2uG7exvS
         0QrLfyqJTTvUqeu5jHN2iO031Z2tnalqQtxKnWJ3rWNIbEvY0wvWxwujx5VWcaDsSz
         +mFuIAINK+Lvg==
Date:   Fri, 10 Jan 2020 10:57:38 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Petr Machata <petrm@mellanox.com>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20200110105738.2b20cbad@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/=q81v8uInKOM8jRoLd774bH";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/=q81v8uInKOM8jRoLd774bH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c: In function '__mlxsw_=
sp_qdisc_ets_graft':
drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c:770:7: error: 'p' unde=
clared (first use in this function); did you mean 'up'?
  770 |  if (!p->child_handle) {
      |       ^
      |       up

Caused by commit

  345457a6e2cd ("Merge remote-tracking branch 'net-next/master'")

i.e. an incorrect automatic merge between commit

  3971a535b839 ("mlxsw: spectrum_qdisc: Ignore grafting of invisible FIFO")

from Linus' tree and commit

  7917f52ae188 ("mlxsw: spectrum_qdisc: Generalize PRIO offload to support =
ETS")

from the net-next tree.

I have applied the following merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 10 Jan 2020 10:52:33 +1100
Subject: [PATCH] mlxws: fix up for "mlxsw: spectrum_qdisc: Ignore grafting =
of invisible FIFO"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers=
/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 17b29e2d19ed..54807b4930fe 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -767,7 +767,7 @@ __mlxsw_sp_qdisc_ets_graft(struct mlxsw_sp_port *mlxsw_=
sp_port,
 	    mlxsw_sp_port->tclass_qdiscs[tclass_num].handle =3D=3D child_handle)
 		return 0;
=20
-	if (!p->child_handle) {
+	if (!child_handle) {
 		/* This is an invisible FIFO replacing the original Qdisc.
 		 * Ignore it--the original Qdisc's destroy will follow.
 		 */
--=20
2.24.0

--=20
Cheers,
Stephen Rothwell

--Sig_/=q81v8uInKOM8jRoLd774bH
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl4XvfIACgkQAVBC80lX
0Gyy6Af/dR6/7p0+dYPXSjL00vZvIfMYEflpo+BHgiCVgt/cElOmeuOZhlz287x7
RgdjhIBDD0LrYn+zmUmIgIrSxtv46bKvFaxJ17T7Fjf+jdWuWKfL4JJL0cLwidov
Z5kQTG8zS67f0+nnE/P24XzHWK4Ds+d6lPbDqHgyJWo3Xk0e97XbpwvCX38WwSBu
0nFiToIbHMYA2a5z/NmfL3m/DVjwFEQiX5KT7kBP9LRe30pwu8Sd/PmKF4ndNE1v
NhWB98zQ5idy3YSJmMVZcqa3HxEGOZkSqbBBvJgwXF3VgY1beBiDhRVvqKZzV+il
FFHo8f+J7QOeT/S5uNk6G+3TYmWR7A==
=vAoK
-----END PGP SIGNATURE-----

--Sig_/=q81v8uInKOM8jRoLd774bH--
