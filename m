Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7428742BB
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 02:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387993AbfGYA6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 20:58:32 -0400
Received: from ozlabs.org ([203.11.71.1]:44507 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727364AbfGYA6b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 20:58:31 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45vDNd2jmCz9sBt;
        Thu, 25 Jul 2019 10:58:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1564016309;
        bh=PPuO+Wxvc09i2eFH/arezdXXxJeN18c0zhD/Fc+fE9o=;
        h=Date:From:To:Cc:Subject:From;
        b=uPq/hUDVxd2V4wrQ7uj6GvE5l52FsLbXrQJ+k1TKrN/sbZzrc+hgnRT69eWxmVDJQ
         B+pXy87eaIndxIT7fhjP9PJkntL3Aaz0HrBiBCpgNyqxSiQ4zKo76ImraUM9byojNw
         NRXEg/FBsWYfivX5xnbTpRMMmzLMYZvAiAGwPuOD3ZlU2GfXDv6RiOgEQDkNrKsEgo
         AshuYYtmgQX3p3DYRftiYtrCSkE9MRmcvXtAZYG6qbWix7wDKcK9Q7zrjRulQ1xkxl
         S3XkK+UhIPYyJX3P/VoQIowZ64EG+J1fn0EltsxG+H6qJlypPU5Xx6wU4UDJnulRF0
         yBdbGJNJ/h+PQ==
Date:   Thu, 25 Jul 2019 10:58:24 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Wen Yang <wen.yang99@zte.com.cn>,
        Sean Nyekjaer <sean@geanix.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20190725105824.4e628c43@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/k5AIR+Ny/7Yd5oGlEAw1gLx";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/k5AIR+Ny/7Yd5oGlEAw1gLx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/can/flexcan.c

between commit:

  e9f2a856e102 ("can: flexcan: fix an use-after-free in flexcan_setup_stop_=
mode()")

from the net tree and commit:

  915f9666421c ("can: flexcan: add support for DT property 'wakeup-source'")

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

diff --cc drivers/net/can/flexcan.c
index fcec8bcb53d6,09d8e623dcf6..000000000000
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@@ -1473,9 -1473,10 +1491,12 @@@ static int flexcan_setup_stop_mode(stru
 =20
  	device_set_wakeup_capable(&pdev->dev, true);
 =20
+ 	if (of_property_read_bool(np, "wakeup-source"))
+ 		device_set_wakeup_enable(&pdev->dev, true);
+=20
 -	return 0;
 +out_put_node:
 +	of_node_put(gpr_np);
 +	return ret;
  }
 =20
  static const struct of_device_id flexcan_of_match[] =3D {

--Sig_/k5AIR+Ny/7Yd5oGlEAw1gLx
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl04/rAACgkQAVBC80lX
0GyiVAf+MH+vKU+Xk/7uRhw3NEVTbPL8rqUhF4NnbV/gg8TYjFUEgPCYmpi0XEMQ
C5Irjn7+z2skP7HjrUqEx2XFesmYaD7zYibKTKBv2p22RFs5h00rs3OJIBYU6BKf
6C0Y/+tczdwzGupkK5FZJOtXLlMItApFMthS2J/Ukua12TNo1p/TrzKZlaX4hEmm
XYtMsXd/Qm4/5dDgCt1nc8LBpGVEGyoUos0YGxxke4uDLNbkv+X5ak6AQQu1U4Xq
a4y9+lzaamtpNBIwNCzFUGLSlRSZPhlPFF73RBN7uVhD1TFxA3S4WZeLMWLb/dNr
Oza9Twf+VCb1Q8beyRTVTQ7Vd/KYqA==
=wiVc
-----END PGP SIGNATURE-----

--Sig_/k5AIR+Ny/7Yd5oGlEAw1gLx--
