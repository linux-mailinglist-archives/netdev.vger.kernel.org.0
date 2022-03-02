Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 951994C99CE
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 01:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234875AbiCBAXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 19:23:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiCBAXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 19:23:01 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5653E0EE;
        Tue,  1 Mar 2022 16:22:18 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4K7ZYv1ChRz4xcq;
        Wed,  2 Mar 2022 11:22:10 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1646180533;
        bh=dAP0ZGftN0DtRSKRVIj+eVXmzd7nsxKydwHZQ5ZXAdU=;
        h=Date:From:To:Cc:Subject:From;
        b=JhtfPjOE5b6myYSkCUuDgBHozNF6u6Nrfrz3jV1YxZRWd4sUKgmS4p3bzc8jqLaAo
         /pK1SbTPgOPmYzPo7/OiYN9xn1jL/5eFpDUnbcfA05V5q9+SK4eHFbKweng01Y84Y2
         h1sSGahRk6oYEgpye91jCIp0HOkgvxovcpEm+2vHef8u8ffAIR+GNj8AeHr9Vwpk2f
         HVyH3Bc6FCFI5eGfQLipZjcn6zUjvLGZuhDY8TbtOGf9Jf37KjolXnH2CGynCXhiqB
         Y0/mE18GssuBlS405k/rUiKRQ51hYCa55fgdQ2sxOF3kUSGJ3glqSNmOAz8ZC9GlPI
         k/ercW7sE0zwA==
Date:   Wed, 2 Mar 2022 11:22:09 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Dust Li <dust.li@linux.alibaba.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Tony Lu <tonylu@linux.alibaba.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20220302112209.355def40@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/3rw2I3JrDfSWQiBsGkIt2sO";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/3rw2I3JrDfSWQiBsGkIt2sO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/smc/af_smc.c

between commit:

  4d08b7b57ece ("net/smc: Fix cleanup when register ULP fails")

from the net tree and commit:

  462791bbfa35 ("net/smc: add sysctl interface for SMC")

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

diff --cc net/smc/af_smc.c
index 284befa90967,6447607675fa..000000000000
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@@ -3087,14 -3287,20 +3293,22 @@@ static int __init smc_init(void
  	rc =3D tcp_register_ulp(&smc_ulp_ops);
  	if (rc) {
  		pr_err("%s: tcp_ulp_register fails with %d\n", __func__, rc);
 -		goto out_sock;
 +		goto out_ib;
  	}
 =20
+ 	rc =3D smc_sysctl_init();
+ 	if (rc) {
+ 		pr_err("%s: sysctl_init fails with %d\n", __func__, rc);
+ 		goto out_ulp;
+ 	}
+=20
  	static_branch_enable(&tcp_have_smc);
  	return 0;
 =20
+ out_ulp:
+ 	tcp_unregister_ulp(&smc_ulp_ops);
 +out_ib:
 +	smc_ib_unregister_client();
  out_sock:
  	sock_unregister(PF_SMC);
  out_proto6:

--Sig_/3rw2I3JrDfSWQiBsGkIt2sO
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmIeuLEACgkQAVBC80lX
0GxXxAf/c3JLhvQZbbd21vYirxRsH8mlecMX7Qi1f3zpj/Dp+5yAgjmtWcOTlhkh
dXB6ZkWwv5DoZOtrFZKjx/ron4dtrDlkzUnI1bO3Mq9q5UEph4h0NK2g/5AOt2dq
UEPQ6hjAGVJTT5q6dsuisnkELd5dsgVL7B9d2+uppODO78/mzk1BYJsN5YXwWVNw
cKtY3k850jiKnZYGXL2G7cKrKSE4J7gYD5GblXG3ILB/gZlJ5jXG4dSDniOPUgXg
Id+a94mxqGWEFYC/qny8A3Pb2pv6vYdEvdqYyjrVGh4XG6slIpvtPZuZscWRPs7d
HdC5hxhKAMDKfgLqdnVGNue5ja2ybQ==
=m+8O
-----END PGP SIGNATURE-----

--Sig_/3rw2I3JrDfSWQiBsGkIt2sO--
