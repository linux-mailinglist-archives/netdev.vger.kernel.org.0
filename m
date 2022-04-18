Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21A32506042
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 01:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235370AbiDRXhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 19:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234905AbiDRXhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 19:37:20 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB3327CD2;
        Mon, 18 Apr 2022 16:34:38 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Kj3Dr4N2zz4xNl;
        Tue, 19 Apr 2022 09:34:35 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1650324877;
        bh=/AeN/7aJIIso3ET4fMDtzGqTqxQGLuQTHEy8Tnj+Qh0=;
        h=Date:From:To:Cc:Subject:From;
        b=Orh87OQ3tq0CwVqFvHXAFQTBNqZWBQTQ/HVJJE0qQlPv961AWzRcbEIdK/VnVsJTH
         FJ71EFObrYUmH+oit+iJ8nK7Yl50hBPBwuYT7nMCha+g6c4FJZ0SLWaZlLHCVIVswo
         JNR34iG8wlYwcSeo3TNvMmSPctHpVJbgEdggpdXEqNQsrKOTbFyNKO/F1diR9IkOHK
         YU20CiYZeQjRFy7C67oO/YT9qEgq99FvU11x3yAj4IAc95lfmMUszFNsLRe8s4rF12
         PWZUEnau9HZ8q/PC8KahlUIVVcZiHY+voMyP722e/X5I/J2qDcirSaszCKxwZNPYfj
         +MaROILBvmoVw==
Date:   Tue, 19 Apr 2022 09:34:34 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20220419093434.299253fc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/V9uDdZ69AsCGpskbcXSi__P";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/V9uDdZ69AsCGpskbcXSi__P
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/microchip/lan966x/lan966x_main.c

between commit:

  d08ed852560e ("net: lan966x: Make sure to release ptp interrupt")

from the net tree and commit:

  c8349639324a ("net: lan966x: Add FDMA functionality")

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

diff --cc drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 95830e3e2b1f,106d8c83544d..000000000000
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@@ -672,8 -687,8 +687,10 @@@ static void lan966x_cleanup_ports(struc
  		lan966x->ana_irq =3D -ENXIO;
  	}
 =20
 +	if (lan966x->ptp_irq)
 +		devm_free_irq(lan966x->dev, lan966x->ptp_irq, lan966x);
+ 	if (lan966x->fdma)
+ 		devm_free_irq(lan966x->dev, lan966x->fdma_irq, lan966x);
  }
 =20
  static int lan966x_probe_port(struct lan966x *lan966x, u32 p,

--Sig_/V9uDdZ69AsCGpskbcXSi__P
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmJd9YoACgkQAVBC80lX
0GyqWQf/euXTCgDxe+ali9/TS5X1yIQtAqS4WHWIZxOwbuloicnvuqvqm7tTnxxR
Orxh6IFZx59A0k0JqV98efA0sey9e2gDKlsw5vmug92WVkW88mc3z5FLe4dqAE0M
P0syTCPtO9GjLegmbpmRVzRHg1HbQ5hPzqG1m+EQDAx1zLnhyTt+jIWNGnXcC6P4
HvylsXbLlcTQiVFzRgsMTOCRAKUwU8fOBxnKY+xakUadRA7Fj0XCt/nHlrh6U+G3
ChmhPyMBLYLCSKGgtNQdiKg2knFnqTi5lBXNuwbea7OFBNzYroTASdvsqIl0MYQC
BetiCaTVB5V+LCdbY1kSjQ2hF0iBcQ==
=mgnY
-----END PGP SIGNATURE-----

--Sig_/V9uDdZ69AsCGpskbcXSi__P--
