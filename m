Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A39576D8C26
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 02:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbjDFAte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 20:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbjDFAtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 20:49:33 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8B64ED5;
        Wed,  5 Apr 2023 17:49:32 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PsNDp1TJqz4x91;
        Thu,  6 Apr 2023 10:49:29 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1680742171;
        bh=zpUvxjvHIXJ+KL1mMiQcCdPhGDYp+/oHa5Cn/32a+D0=;
        h=Date:From:To:Cc:Subject:From;
        b=EKhtp0QpxCKEuPuzooSaS/mbw8Wm8AgVfHmedu+W6HOnyDrPy9q+L8VZnQ92YtAV2
         8XNj/KqsoUWpYeyu3aRrQD2QsUzKPsdfEcbdQJjWGxZ9zBmxwmDEPpOafsvzDkqpoj
         37KnUHQhKTLEAd2yylyuibG5vyfv6bIG0yLKc5miaehEBZAjALNc53h0spmDbw9Nxs
         oGa9A4rXHFex7m/2VWoX022pyEe+2m06Qh92w2vUOwIKSl8f3VZ4IkhEw9YMfdyulq
         LpKRMq2HyVSuzYkKeGGpU/MGeqfVUfO7EbpdJwMQ+WX/Z39+nTg6B5+6u6krBXXNBA
         SvNARDD9L4BhQ==
Date:   Thu, 6 Apr 2023 10:49:27 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Praveen Kaligineedi <pkaligineedi@google.com>,
        Shailend Chand <shailend@google.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20230406104927.45d176f5@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/VrxD0TXPjQ5VZeU1RZLkr5Y";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/VrxD0TXPjQ5VZeU1RZLkr5Y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/google/gve/gve.h

between commit:

  3ce934558097 ("gve: Secure enough bytes in the first TX desc for all TCP =
pkts")

from the net tree and commit:

  75eaae158b1b ("gve: Add XDP DROP and TX support for GQI-QPL format")

from the net-next tree.

Matthieu, thanks for the head up.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc drivers/net/ethernet/google/gve/gve.h
index 005cb9dfe078,e214b51d3c8b..000000000000
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@@ -47,8 -47,10 +47,12 @@@
 =20
  #define GVE_RX_BUFFER_SIZE_DQO 2048
 =20
 +#define GVE_GQ_TX_MIN_PKT_DESC_BYTES 182
 +
+ #define GVE_XDP_ACTIONS 5
+=20
+ #define GVE_TX_MAX_HEADER_SIZE 182
+=20
  /* Each slot in the desc ring has a 1:1 mapping to a slot in the data rin=
g */
  struct gve_rx_desc_queue {
  	struct gve_rx_desc *desc_ring; /* the descriptor ring */

--Sig_/VrxD0TXPjQ5VZeU1RZLkr5Y
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmQuFxcACgkQAVBC80lX
0GysmwgAmGFqGdHEnspTgHXVlv7FWqkHag/8zckbD//AJ+SP8CvVHkaGd4iFwU5m
WuLYrUPgO/wvDR4QE7nnocVkEFexHGzYRkCQFo81DT50wHSIe4F3pLcE0gCYmo8s
hEf2/4rVgJV5/lM8cK6gT9l0R1t0SM5fVixSEfX770McG8t/CNrDV/fjG/YDJK+F
dlm2XbVItQiN/peHxdZ+UzZyzcjKukKhOkECCkptLU4l87A2EBxBwuV8o7pGeCTv
9Ab5d0bbbWzfJj89eWpLMlnuWwFrxwt0XHXYZLhiV4dTk+dnTioSg4o1dMrpAbn7
+oXdRqH4eF2gdzVi6t06xdJSB4CFSA==
=1SrI
-----END PGP SIGNATURE-----

--Sig_/VrxD0TXPjQ5VZeU1RZLkr5Y--
