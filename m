Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A873A8E8C
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 03:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbhFPBt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 21:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbhFPBt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 21:49:28 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD60FC061574;
        Tue, 15 Jun 2021 18:47:22 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4G4Sjg4Wmbz9sXG;
        Wed, 16 Jun 2021 11:47:19 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1623808039;
        bh=HqB8/rIQjzzdFHS5jt6c0a5Xbi1MdIsHYatrLuz5Cdc=;
        h=Date:From:To:Cc:Subject:From;
        b=LW+1VwgrzRP8aytHjLEhUlUVstdmUc2OKhwzc5/Nyy1jX4URs0zrR8MngViFiJ47o
         NjsSkPOdbX5pVT1o2Oah76tP6gRhCeV8YCNUCqmpww08Wxw4VIJ6NOnASy57VloJYl
         6sAqZmR0NUWr/l5CKTFew/1KkAM7Rdw4kEyxBgS2U00GNW7hKc+hLWPhGcHVws6BiQ
         JL9v8KZ5WNCse27Kfpgyom8P/3GwJWfHQXFFUtT//DGYEh5r33WKXSl0TbLhOmsGx7
         YeGxrZDSPbqyYcs7TXwqAs7K9Pwzehln4h/ePdmj+3vjEc/yI5BTBXABL2bgkq8o2L
         aDXKHFAxkNWXQ==
Date:   Wed, 16 Jun 2021 11:47:18 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20210616114718.0e4c2142@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/kU7q5ibiMbRW+64.mILUzuZ";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/kU7q5ibiMbRW+64.mILUzuZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got conflicts in:

  drivers/ptp/ptp_clock.c
  include/linux/ptp_clock_kernel.h

between commit:

  475b92f93216 ("ptp: improve max_adj check against unreasonable values")

from the net tree and commit:

  9d9d415f0048 ("ptp: ptp_clock: make scaled_ppm_to_ppb static inline")

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

diff --cc drivers/ptp/ptp_clock.c
index 21c4c34c52d8,a780435331c8..000000000000
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
diff --cc include/linux/ptp_clock_kernel.h
index 51d7f1b8b32a,a311bddd9e85..000000000000
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@@ -186,6 -186,32 +186,32 @@@ struct ptp_clock_event=20
  	};
  };
 =20
+ /**
+  * scaled_ppm_to_ppb() - convert scaled ppm to ppb
+  *
+  * @ppm:    Parts per million, but with a 16 bit binary fractional field
+  */
 -static inline s32 scaled_ppm_to_ppb(long ppm)
++static inline long scaled_ppm_to_ppb(long ppm)
+ {
+ 	/*
+ 	 * The 'freq' field in the 'struct timex' is in parts per
+ 	 * million, but with a 16 bit binary fractional field.
+ 	 *
+ 	 * We want to calculate
+ 	 *
+ 	 *    ppb =3D scaled_ppm * 1000 / 2^16
+ 	 *
+ 	 * which simplifies to
+ 	 *
+ 	 *    ppb =3D scaled_ppm * 125 / 2^13
+ 	 */
+ 	s64 ppb =3D 1 + ppm;
+=20
+ 	ppb *=3D 125;
+ 	ppb >>=3D 13;
 -	return (s32)ppb;
++	return (long)ppb;
+ }
+=20
  #if IS_REACHABLE(CONFIG_PTP_1588_CLOCK)
 =20
  /**

--Sig_/kU7q5ibiMbRW+64.mILUzuZ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmDJWCYACgkQAVBC80lX
0GwY9ggAlL++Z7Qp9Ucae6uNHUn1vWtDB25abwu1HEiByc5lnASHpwQ3/wNcihmj
GcPL3OCDN3467FGH75OHcYH86NREXK8/ddjKtzPYCmvXfye9CmnlszP6fbf85YBT
gyukvJ5F6+poro9hO8Cy+epLXR6WU6P9EMzLsSJ+mEo19+x7yM7mU9cUHO6dW9Rd
HReLWSAxZuQaJNrYsagL8TDjHkklx7Sz0N8FSolK/LWQ+EhJ+IECVaVAm1yzIwQo
8eDCR02DvAgP74nBjlEYC38tGzpONYosKBk4rwGccIGLgLknDZhluOW33w1CO+zd
RMzG5qPRT3mP80P9KJY4Fi6uWnqXUw==
=mTd7
-----END PGP SIGNATURE-----

--Sig_/kU7q5ibiMbRW+64.mILUzuZ--
