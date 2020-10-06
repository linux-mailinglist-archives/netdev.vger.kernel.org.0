Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67CE9284472
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 05:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbgJFD6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 23:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbgJFD6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 23:58:52 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29761C0613CE;
        Mon,  5 Oct 2020 20:58:52 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4C53c84q97z9sTK;
        Tue,  6 Oct 2020 14:58:48 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1601956729;
        bh=iWcvZufCX12F8E6C2qQJJzj37lQzvnAo1HzQn3tI6Ew=;
        h=Date:From:To:Cc:Subject:From;
        b=h1C2vyTYHFhG9P8BBJmDM+h1xGcNLnZ0P7V3xKT9tvwjUTT38XCZ1Gmw5m9lJjIUW
         copf6yKlgRQHc27VuadxJurUby8Mj+Rh4zIJxU3EbJ6S2Tm2onh3H0U0Hqpg0mNw+z
         BfbhONNi0D0vBXUAm6FwVqf1EFshQgRjg0Dw5KmqvlvlRm2ZteAAd++I69rDiLQLdu
         LKJBzogripmKTFMUa6lZ8vANjB5ChX0soViCHtUrLjvlX0clF0CTfhBZ1NbvO4Ezki
         styUDI1nkKH4a1wTYhURh0u9iyEj/wp4GrMmJigpTI1CL4roWRquQUImB5kz7Hky1g
         Pd9IPaEG1IzkQ==
Date:   Tue, 6 Oct 2020 14:58:47 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20201006145847.14093e47@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/GOR2XLLXM54SlDFaOXrQc09";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/GOR2XLLXM54SlDFaOXrQc09
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

net/xdp/xsk_buff_pool.c:7:10: fatal error: linux/dma-noncoherent.h: No such=
 file or directory
    7 | #include <linux/dma-noncoherent.h>
      |          ^~~~~~~~~~~~~~~~~~~~~~~~~

Caused by commit

  1c1efc2af158 ("xsk: Create and free buffer pool independently from umem")

interacting with commit

  a3cf77774abf ("dma-mapping: merge <linux/dma-noncoherent.h> into <linux/d=
ma-map-ops.h>")

from the dma-mapping tree.

I have applied teh following merge fix patch.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 6 Oct 2020 14:53:30 +1100
Subject: [PATCH] xsk: fix up for "dma-mapping: merge <linux/dma-noncoherent=
.h>
 into <linux/dma-map-ops.h>"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/xdp/xsk_buff_pool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index e63fadd000db..dbed16648607 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -4,7 +4,7 @@
 #include <net/xdp_sock.h>
 #include <net/xdp_sock_drv.h>
 #include <linux/dma-direct.h>
-#include <linux/dma-noncoherent.h>
+#include <linux/dma-map-ops.h>
 #include <linux/swiotlb.h>
=20
 #include "xsk_queue.h"
--=20
2.28.0

--=20
Cheers,
Stephen Rothwell

--Sig_/GOR2XLLXM54SlDFaOXrQc09
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl9763cACgkQAVBC80lX
0Gxj4gf/ZtndFDmPS9Mp3VF4QxjujNTo5QCp5q/ZejkSYif1YuECt41iMBYw5a/i
9rFE3Ftn7MKaJc4OAqopm2RhFtceSQm6FrluKyeKcFOla7a7dvOa+aoS3Lv3MnXe
Ha7Ab5TH3KqygD2txXAtTX2b8rIPUHQ5dP6LG/7zkWj8LdaVFzaBzJcz2zuKBG1O
CcuJjc6iKjjVT/zIecwWGeyOVU6+KQwgQoZX6GbnF+vy21F9BGC2Xe9RZOFlYgjL
83YIOGc9+oDQELmJNcM8jLoJZen5UCi1sMhQC/Cxdm/3BSDkzqP1cRlRVV+uIE8K
+8K23TBseF1h1Z0/eO614aAqV7nm2Q==
=peB6
-----END PGP SIGNATURE-----

--Sig_/GOR2XLLXM54SlDFaOXrQc09--
