Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67392CB267
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 02:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727748AbgLBBjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 20:39:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727096AbgLBBjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 20:39:01 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCB5C0613CF;
        Tue,  1 Dec 2020 17:38:21 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Cm1nk12lyz9sVl;
        Wed,  2 Dec 2020 12:38:17 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1606873099;
        bh=SbDrqvHmNU+7sLlQ9flvOc2UKJ3kLdEy5wt51QQ+3DY=;
        h=Date:From:To:Cc:Subject:From;
        b=fhcmCTOoHg3PrG5J06IrIgyy3nmG863Ke3dEyNoW0YvbY3UnCVBqq/uekuCBzqIF8
         yswQEUYSfQzmFhYi90W3MvFCR46w5t74uEJn9HdDFMwWWWrLKBx0XDdxE0/ivAiQkG
         M9vehRFo/31P2SzVo0SAPyhbTUpjNMeNslY3QjdOaPNQsnX4zejgDKkNduWZXEtyRn
         tUalso9Ox7usdBY+Bh2Utzjsdu2l3bnJbI/AnaMucxQS59rc8siqqXWpmpdzW7TOFz
         F/4H8KePLIgOJ9vdUhM+7RjG1GIsNk0oAYJ7OypDDoKFooIfbHupb64GUT9nMUcc8l
         opkrU5+FZHYcA==
Date:   Wed, 2 Dec 2020 12:38:16 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20201202123816.5f3a9743@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/wa_Yzs8HfPUZ7fGukU2BnR2";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/wa_Yzs8HfPUZ7fGukU2BnR2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

net/core/xdp.c: In function 'xdp_return_frame_bulk':
net/core/xdp.c:417:3: error: too few arguments to function '__xdp_return'
  417 |   __xdp_return(xdpf->data, &xdpf->mem, false);
      |   ^~~~~~~~~~~~
net/core/xdp.c:340:13: note: declared here
  340 | static void __xdp_return(void *data, struct xdp_mem_info *mem, bool=
 napi_direct,
      |             ^~~~~~~~~~~~

Caused by commit

  8965398713d8 ("net: xdp: Introduce bulking for xdp tx return path")

interacting with commit

  ed1182dc004d ("xdp: Handle MEM_TYPE_XSK_BUFF_POOL correctly in xdp_return=
_buff()")

from the bpf tree.

I applied the following merge fix patch.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 2 Dec 2020 12:33:14 +1100
Subject: [PATCH] fix up for "xdp: Handle MEM_TYPE_XSK_BUFF_POOL correctly in
 xdp_return_buff()"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/core/xdp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index f2cdacd81d43..3100f9711eae 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -414,7 +414,7 @@ void xdp_return_frame_bulk(struct xdp_frame *xdpf,
 	struct xdp_mem_allocator *xa;
=20
 	if (mem->type !=3D MEM_TYPE_PAGE_POOL) {
-		__xdp_return(xdpf->data, &xdpf->mem, false);
+		__xdp_return(xdpf->data, &xdpf->mem, false, NULL);
 		return;
 	}
=20
--=20
2.29.2

--=20
Cheers,
Stephen Rothwell

--Sig_/wa_Yzs8HfPUZ7fGukU2BnR2
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/G8AgACgkQAVBC80lX
0GzoKAf/VhBLkVMWK5Qbkyv2cKPJUXYFJser/bUO+Q3divBH99kXtddLdlVPoFon
vZSljGFn9Sy52v0Zy99jALhXiLjvfNJZ2kSiSIy9qnB+Oc8cUpo+XBy+x0XL6sHQ
KCb0xPlfTrmkKANBKbtxnxaPbXkR4+qdYXIGsWCKn89MGvcV/Y+SqQISed3JlS4Y
3N9epBK3YNWRti//EwAhNbzjMsPRnGNVWcV0Zsr6ir5uiBMpa1/zS05zajOhFOxa
eDpbO8Fko3ZrPUkQfhX/gXT25oG7Ot4xMH5/N6ZG/sKaG9LB9xr7UND6MXIuUyKz
vDuEc6NYd6QXdQtmiQIHiLgdgWVSRA==
=q/7e
-----END PGP SIGNATURE-----

--Sig_/wa_Yzs8HfPUZ7fGukU2BnR2--
