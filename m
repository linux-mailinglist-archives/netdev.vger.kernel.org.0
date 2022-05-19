Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E03DA52C959
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 03:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbiESBlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 21:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbiESBlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 21:41:22 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8F98A33C;
        Wed, 18 May 2022 18:41:21 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4L3XdD1CJQz4xVP;
        Thu, 19 May 2022 11:41:20 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1652924480;
        bh=oBrS4JumN9FhVfGy2QDvl7E14DwpvKRpnN1W6VFJsdg=;
        h=Date:From:To:Cc:Subject:From;
        b=QOz5Qp+cPdzA5ZG0oGRzgraCP7/0ALARIVDmDmvR2WNMVAJ+1bVeOP/kPIkHQC6kj
         zJsVP/xJj6J8+WOSZ24X8uQHKsX0+6t1i3wUe1/bLIXNYIuRLcvcuell7f4E6kkteK
         bWf5fErN9S/KM2A//2ABIpI2PhdLE0fHf0TTZ4fEN63aUcfuHnPiH7XAODMgJ6vsJr
         F9c4gh4GUeZjkLH0d3ajFO2lUim6ffhPMLXTJbvSXnHRohVLtk6NfyDfXqNyq64L7S
         w1sCOWNtycVuKgFNWGBYEayRp4bpv5Z5OevlPrtON9o2vpfC631VQmERn2vSpWM9Pm
         aTlrpuUC2ALGQ==
Date:   Thu, 19 May 2022 11:41:19 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>, Gavin Li <gavinl@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20220519114119.060ce014@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/BzpcCTeh0s6zX2CdjfO/a6f";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/BzpcCTeh0s6zX2CdjfO/a6f
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/mellanox/mlx5/core/main.c

between commit:

  16d42d313350 ("net/mlx5: Drain fw_reset when removing device")

from the net tree and commit:

  8324a02c342a ("net/mlx5: Add exit route when waiting for FW")

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

diff --cc drivers/net/ethernet/mellanox/mlx5/core/main.c
index e5871fdd5c08,87f1552b5d73..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@@ -1612,10 -1608,7 +1617,11 @@@ static void remove_one(struct pci_dev *
  	struct mlx5_core_dev *dev  =3D pci_get_drvdata(pdev);
  	struct devlink *devlink =3D priv_to_devlink(dev);
 =20
 +	/* mlx5_drain_fw_reset() is using devlink APIs. Hence, we must drain
 +	 * fw_reset before unregistering the devlink.
 +	 */
 +	mlx5_drain_fw_reset(dev);
+ 	set_bit(MLX5_BREAK_FW_WAIT, &dev->intf_state);
  	devlink_unregister(devlink);
  	mlx5_sriov_disable(pdev);
  	mlx5_crdump_disable(dev);

--Sig_/BzpcCTeh0s6zX2CdjfO/a6f
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmKFoD8ACgkQAVBC80lX
0GxjQQf+MnQ7AH0Y7b2uO7WMX6X0dT2KUYAdpsp2erfazaaYIxxEhk8i43ENfLfC
cOFsvyNdMZ8Db512f69gtjVGB17fQKjU8Uqw0IjVxgg+WEnyVjqLH0fA8b83WGBV
oN1dcqQkenoU3wfigd1K24NgOkWeELGN/kAjO51Hx2hAgAa43Tg1cbiyOWsTmYc+
cLnoEqXh0z0UntlMnTTGh2rltfNz4pviO8tv//DvBd0k6bKRVKHIZFHYZPZ0LBRM
bjsWt1yTRTWH9Ad0WANa6mxEH+h+wZgl8Au8G4tQa7Ws3i/FA9KQze4wduAxlYp3
hIDe2E4VhNTvi+YAeJMZU/XhrhHvBw==
=31xX
-----END PGP SIGNATURE-----

--Sig_/BzpcCTeh0s6zX2CdjfO/a6f--
