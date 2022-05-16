Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF528527B4F
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 03:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239004AbiEPBOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 21:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236470AbiEPBOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 21:14:47 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C705BF76;
        Sun, 15 May 2022 18:14:43 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4L1h9n4gxCz4xZ2;
        Mon, 16 May 2022 11:14:37 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1652663679;
        bh=DOzVSuiLWwoYauUsaFUFtUlDaTPA5dFC/+2t4lAmiiQ=;
        h=Date:From:To:Cc:Subject:From;
        b=sz3TvfnJY8/DEszo2jtX9bR2X2E6DMRuEIuGGe1dQWldZLo/Er3IjTt9bb4MQIXZg
         51oi+N72LCnpd0XZtTnnBhm6zcnNj161w4nwo6q0Vjx/XQ5aReIhPvPGBh6W7o7TS/
         HFKXzNQWXFlK+5ZBE9X7ilZzQUAP5E3Ykif10aLjYtXXnS7P6seYRRHEYUqPH+TkBc
         iuRInUIWZ88OnzgICWtrr1gu6e7h7Xwlwlxzuc+Hn9dCOvLWaNB3yu3iIAL4QIe335
         I0vthRCHJSacyFbvcuZ9W0fWcfExTz2B+bl4o28hDEVP2tCpX3u3YrsgyPiI2tz49H
         KoEn8KAqbCfoA==
Date:   Mon, 16 May 2022 11:14:35 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Kishen Maloor <kishen.maloor@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20220516111435.72f35dca@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/=bSpMFCrknkyhKjg7.oo9ho";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/=bSpMFCrknkyhKjg7.oo9ho
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/mptcp/pm.c

between commit:

  95d686517884 ("mptcp: fix subflow accounting on close")

from the net tree and commit:

  4d25247d3ae4 ("mptcp: bypass in-kernel PM restrictions for non-kernel PMs=
")

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

diff --cc net/mptcp/pm.c
index aa51b100e033,cdc2d79071f8..000000000000
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@@ -178,7 -181,9 +181,8 @@@ void mptcp_pm_subflow_check_next(struc
  	struct mptcp_pm_data *pm =3D &msk->pm;
  	bool update_subflows;
 =20
- 	update_subflows =3D subflow->request_join || subflow->mp_join;
 -	update_subflows =3D (ssk->sk_state =3D=3D TCP_CLOSE) &&
 -			  (subflow->request_join || subflow->mp_join) &&
++	update_subflows =3D (subflow->request_join || subflow->mp_join) &&
+ 			  mptcp_pm_is_kernel(msk);
  	if (!READ_ONCE(pm->work_pending) && !update_subflows)
  		return;
 =20

--Sig_/=bSpMFCrknkyhKjg7.oo9ho
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmKBpXsACgkQAVBC80lX
0Gwu7wf5AfjCT4pglRirSN4IKmmpw1HVddjVaRGqwydlR/RdVwyZxaRCZDRhltZY
+Fl633ZPSog1AhX6YbsZN9rSz5wb9KVIEwbtlAetWtdNqQfF1RDkeGm3dYQVnP/C
kA883Z2I+sb33t9DGUinZsBuM/HG6qpqjKFouAgYzV6zNKR8g7AOpClcbPzBYpQT
XJ8DlEkhLtQ59dJu//Tg7/Ap9T4FdPkj56LtevP8pLPoI4AeV5vP0s0iHTdloQrH
bG7RyB/8fWA2CfMRVVv8+LgoFM7JfKmlq/I3b/H9srAuxlH4DbLUTgscR6cP3HCl
IqdRzR6rHxcBi30tiBOUTi5GPntqFA==
=E97s
-----END PGP SIGNATURE-----

--Sig_/=bSpMFCrknkyhKjg7.oo9ho--
