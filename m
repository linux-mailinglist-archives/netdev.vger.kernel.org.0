Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A95C6520BB3
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 05:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235129AbiEJDKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 23:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233370AbiEJDKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 23:10:05 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B17517DF;
        Mon,  9 May 2022 20:06:04 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Ky2x30FVWz4xTX;
        Tue, 10 May 2022 13:05:58 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1652151959;
        bh=A1G4GSy0V0Cm3Vv6oTLpnNeT8n3BdkJrtvfBTJhZVvU=;
        h=Date:From:To:Cc:Subject:From;
        b=THo5jTMknwC2YJqQqOtZXL6T+1rf9QmtFPiTct8ZZdpI59+drAPL5AorOp1LKHLKy
         JnTQQKPIL7T6q3Ap24FUh8usOomM6WP7qtNiJk2YLApnZmPleKCEv5S4cNpYlBCp2U
         tkPMBb+4M5cYCoRcQ2lhZ0oNU1xRhNAJQfKmc+klawbxmUE1SoFDnhr4q9ucFZxoyM
         RdCO5zh7Dr+Bu6WKY9AqA9izlwwqffAaSRam2/UUJP2RDZgOOB8UkhkViIGR5p7K+J
         P6p7S+Haym1wXfki77fv0f2NE3pXDUOGo8xC72coNmKSpFJT5EQxya7N+ib0bbQ+zm
         1uJIOQrYCGAVg==
Date:   Tue, 10 May 2022 13:05:56 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Taehee Yoo <ap420073@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20220510130556.52598fe2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/S5P4vjS+eFW2D4is1FV5ZOw";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/S5P4vjS+eFW2D4is1FV5ZOw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/net/ethernet/sfc/ptp.c:2191:35: error: 'efx_copy_channel' undeclare=
d here (not in a function); did you mean 'efx_ptp_channel'?
 2191 |         .copy                   =3D efx_copy_channel,
      |                                   ^~~~~~~~~~~~~~~~
      |                                   efx_ptp_channel

Caused by commit

  54fccfdd7c66 ("sfc: efx_default_channel_type APIs can be static")

interacting with commit

  49e6123c65da ("net: sfc: fix memory leak due to ptp channel")

from the net tree.

I have added the following merge fix patch.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 10 May 2022 12:56:18 +1000
Subject: [PATCH] fix up for "net: sfc: fix memory leak due to ptp channel"

This is a partial revert of

  54fccfdd7c66 ("sfc: efx_default_channel_type APIs can be static")

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/ethernet/sfc/efx_channels.c | 1 -
 drivers/net/ethernet/sfc/efx_channels.h | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet=
/sfc/efx_channels.c
index ec913f62790b..79df636d6df8 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -598,7 +598,6 @@ void efx_fini_channels(struct efx_nic *efx)
 /* Allocate and initialise a channel structure, copying parameters
  * (but not resources) from an old channel structure.
  */
-static
 struct efx_channel *efx_copy_channel(const struct efx_channel *old_channel)
 {
 	struct efx_rx_queue *rx_queue;
diff --git a/drivers/net/ethernet/sfc/efx_channels.h b/drivers/net/ethernet=
/sfc/efx_channels.h
index 64abb99a56b8..46b702648721 100644
--- a/drivers/net/ethernet/sfc/efx_channels.h
+++ b/drivers/net/ethernet/sfc/efx_channels.h
@@ -39,6 +39,7 @@ int efx_set_channels(struct efx_nic *efx);
 void efx_remove_channel(struct efx_channel *channel);
 void efx_remove_channels(struct efx_nic *efx);
 void efx_fini_channels(struct efx_nic *efx);
+struct efx_channel *efx_copy_channel(const struct efx_channel *old_channel=
);
 void efx_start_channels(struct efx_nic *efx);
 void efx_stop_channels(struct efx_nic *efx);
=20
--=20
2.35.1

--=20
Cheers,
Stephen Rothwell

--Sig_/S5P4vjS+eFW2D4is1FV5ZOw
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmJ51pUACgkQAVBC80lX
0GzvHwf9EXy4w+uGpo0tk+2WihFJ/UZdyu+oOvJ7oTwzstQeXxhGeVKmVEy4PQHB
ZH8eGfJkOB7STfEWjndNAKeTBJcd6zuOVNZIj9Wtyylrh4CbI8YZS4tqxLvwVbFp
UvtZAbxTIzbjq7BQls/I4Xa3O5XB4XMj3KZE2W+ZSm3XYAVlhJkQwnylbReg8PeK
6InMQkZ4mHjkn2AerjPUkAHMn8uC1vNNJcU/9ctl2NVhaaGk19z5P1RqXJATpO70
dysS0c2OeWuDpL876/FO1fqVnEgc2wCqV/vgHsxkeCUXvQq87aCR8IyPCWlYfG0P
Y9ufcIfmk5IMIe1PezKD6N1O+AQZvA==
=7VI9
-----END PGP SIGNATURE-----

--Sig_/S5P4vjS+eFW2D4is1FV5ZOw--
