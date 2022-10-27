Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4F6610664
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 01:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235132AbiJ0X2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 19:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiJ0X2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 19:28:19 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9631921246;
        Thu, 27 Oct 2022 16:28:16 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Mz20s1K73z4x1G;
        Fri, 28 Oct 2022 10:28:12 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1666913294;
        bh=l1mZYQANjUQZxBeBSrpWYKI49wKEgcpLkLLgYPYl7Wo=;
        h=Date:From:To:Cc:Subject:From;
        b=dCPyAPs28vq7MKXTAOO86ymMHNDlajjvwHlKR0rPKEtGrlTwBrkiPN3WNRKS/YjXs
         zKWFydZ63ZDG4QtFoFyiiw0776SXeoAmMD4tbfRq576+V03Mk+Q5fHFsX0AWa9HSdH
         482FfslG+ZsDulxp9TeiYPxPYvSWXKnmU38k9Mpb0gdDXXOvoFNS/HWJvQlLQ63rTV
         kZQ1y3lpPyAsTW1aGII7J3VNdEQn4H6upxRhmqIvsm0yq2oSm4JHMeOyR1j/BnDv4Y
         hrLrGWhLhuB1WpIrmMU/ENW9YOYNK/zF1HxQwwf5b8k37XgkR+0eCCIvgjCFhvfEAY
         N+P6jxn1aprZg==
Date:   Fri, 28 Oct 2022 10:28:11 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Anssi Hannula <anssi.hannula@bitwise.fi>,
        Jimmy Assarsson <extja@kvaser.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: linux-next: manual merge of the net-next tree with Linus' tree
Message-ID: <20221028102811.5938f029@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/pW=4nL90RBLWfjr45coo/tP";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/pW=4nL90RBLWfjr45coo/tP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c

between commit:

  2871edb32f46 ("can: kvaser_usb: Fix possible completions during init_comp=
letion")

from Linus' tree and commit:

  abb8670938b2 ("can: kvaser_usb_leaf: Ignore stale bus-off after start")

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

diff --cc drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 19958037720f,5225e2da6437..000000000000
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@@ -1318,9 -1632,12 +1632,12 @@@ static int kvaser_usb_leaf_set_opt_mode
 =20
  static int kvaser_usb_leaf_start_chip(struct kvaser_usb_net_priv *priv)
  {
+ 	struct kvaser_usb_net_leaf_priv *leaf =3D priv->sub_priv;
  	int err;
 =20
+ 	leaf->joining_bus =3D true;
+=20
 -	init_completion(&priv->start_comp);
 +	reinit_completion(&priv->start_comp);
 =20
  	err =3D kvaser_usb_leaf_send_simple_cmd(priv->dev, CMD_START_CHIP,
  					      priv->channel);
@@@ -1336,10 -1653,13 +1653,13 @@@
 =20
  static int kvaser_usb_leaf_stop_chip(struct kvaser_usb_net_priv *priv)
  {
+ 	struct kvaser_usb_net_leaf_priv *leaf =3D priv->sub_priv;
  	int err;
 =20
 -	init_completion(&priv->stop_comp);
 +	reinit_completion(&priv->stop_comp);
 =20
+ 	cancel_delayed_work(&leaf->chip_state_req_work);
+=20
  	err =3D kvaser_usb_leaf_send_simple_cmd(priv->dev, CMD_STOP_CHIP,
  					      priv->channel);
  	if (err)

--Sig_/pW=4nL90RBLWfjr45coo/tP
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmNbFAsACgkQAVBC80lX
0Gy57QgAlO+AdQG1WKqPqWdkLyZqFf82xrI8EJbuveeIgC0Aw5+1042URuSoiKpZ
LtzCkhydPObHPvZiBEIKhnOx3rUaktnGxW0KOUqOkor3QzH3i8cNYklD1LmAYoq7
w9X2/Xph91mDf1RVBBsj7LPg8+u/MHYC50mpNcSrUMRwnaUuvDxNa87VpH4sQQzK
qLSI+BrMgqtHZFWzMuotCz4blkZBeUlRyhI9lNILJcd2ii+VjW5t4XiiylX8kxHU
FEiq6LcT3P3q28/oEgj5Qg2NJAZuUfKuvEI7R1Yj/UzYVwujNzSVIcPEgdMYEZuf
GyHKt4A3rrS//LXpwjl057MKdwU0dQ==
=KNc4
-----END PGP SIGNATURE-----

--Sig_/pW=4nL90RBLWfjr45coo/tP--
