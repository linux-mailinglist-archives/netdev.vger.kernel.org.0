Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBE852E429
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 07:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345493AbiETFAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 01:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236697AbiETFAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 01:00:05 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEDD0473A8;
        Thu, 19 May 2022 22:00:02 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4L4Dzz62PWz4xD1;
        Fri, 20 May 2022 14:59:59 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1653022800;
        bh=kRnmZ4OBNV/AxwduMmUIJ8oc4BXAmTQDhGHrHRd55h8=;
        h=Date:From:To:Cc:Subject:From;
        b=tj0aXwk2M7h+uJmb9DgFJ2tjsLxNx4UKL4mEYwozkf76pjeDplyx6rdC6VNj2VQGQ
         xSbmPLV0iytTSZKL1MH2Bf7zQ7ugi1p5bNyfjaNYfzf9wgNeuLqmFbRf20wa8hxBNg
         KRorH1nKtgTi+5+1akkuhyn1GpbA2UIdSpVwH/ZkzkoLvC6eWuUEVbLvhgy6QDdlcO
         0XhWUGk14IpEyNVkaTNMJZ5WMXWqxSOxcuGcudbZseOhA1/ZvH6J/q3VTwLaVhowOV
         QgdYI3imGLMzSYK5L+j+kXEf54QUFG40V5BDKrTQKjp18TONGj//1rZvfz9eOSpc8K
         C092BuMIvd2Jg==
Date:   Fri, 20 May 2022 14:59:57 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20220520145957.1ec50e44@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/b2pq746HQX=u.OX6bAi6T88";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/b2pq746HQX=u.OX6bAi6T88
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/net/ethernet/mediatek/mtk_ppe_offload.c: In function 'mtk_flow_get_=
wdma_info':
drivers/net/ethernet/mediatek/mtk_ppe_offload.c:93:26: error: initializatio=
n of 'unsigned char' from 'const u8 *' {aka 'const unsigned char *'} makes =
integer from pointer without a cast [-Werror=3Dint-conversion]
   93 |                 .daddr =3D addr,
      |                          ^~~~
drivers/net/ethernet/mediatek/mtk_ppe_offload.c:93:26: note: (near initiali=
zation for 'ctx.daddr[0]')
drivers/net/ethernet/mediatek/mtk_ppe_offload.c:91:42: error: missing brace=
s around initializer [-Werror=3Dmissing-braces]
   91 |         struct net_device_path_ctx ctx =3D {
      |                                          ^
   92 |                 .dev =3D dev,
   93 |                 .daddr =3D addr,
      |                          {
   94 |         };
      |         }

Caused by commit

  cf2df74e202d ("net: fix dev_fill_forward_path with pppoe + bridge")

from Linus' tree interacting with commit

  a333215e10cb ("net: ethernet: mtk_eth_soc: implement flow offloading to W=
ED devices")

from the net-next tree.

I have applied the following merge fix patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 20 May 2022 14:49:44 +1000
Subject: [PATCH] fis up for "net: fix dev_fill_forward_path with pppoe + br=
idge"

interacting with commit a333215e10cb "net: ethernet: mtk_eth_soc: implement=
 flow offloading to WED devices"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/=
ethernet/mediatek/mtk_ppe_offload.c
index 1fe31058b0f2..d4a0126082f2 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -90,7 +90,6 @@ mtk_flow_get_wdma_info(struct net_device *dev, const u8 *=
addr, struct mtk_wdma_i
 {
 	struct net_device_path_ctx ctx =3D {
 		.dev =3D dev,
-		.daddr =3D addr,
 	};
 	struct net_device_path path =3D {};
=20
@@ -100,6 +99,7 @@ mtk_flow_get_wdma_info(struct net_device *dev, const u8 =
*addr, struct mtk_wdma_i
 	if (!dev->netdev_ops->ndo_fill_forward_path)
 		return -1;
=20
+	memcpy(ctx.daddr, addr, sizeof(ctx.daddr));
 	if (dev->netdev_ops->ndo_fill_forward_path(&ctx, &path))
 		return -1;
=20
--=20
2.35.1

--=20
Cheers,
Stephen Rothwell

--Sig_/b2pq746HQX=u.OX6bAi6T88
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmKHIE0ACgkQAVBC80lX
0Gz/PAf+JHxjakFRktMk6IYU4qE8Y4dHayVRV84Ps54oGMsVm38duWAwZCI9wA1e
W7C1e4h7GZEVWVOc8mxqVII7zIfOY4fR3WBdyMyRbXE7XhoqtfX6VYIPm69O3EvE
AxQpSKQL2jcyeEtDkE8EBmK/l1jkXJgTXSaFlNmTvfHZgAs9eXPgl7e6ozh9PdnK
AzuKB21nJlCS1iDzQ5u/XOsSGDtSfPTsYne5R7NHlfEi8mhVncWgoOsGuzaAro7A
E8cSTWd/+k2gjXKQPNYF9+fqO1w30/H7RbiRnQaFZAF3xYwerb2HbXFtQxOm0BVz
zVn1SacZbmHtAr9Y7qbUpDLtlec2CA==
=psWF
-----END PGP SIGNATURE-----

--Sig_/b2pq746HQX=u.OX6bAi6T88--
