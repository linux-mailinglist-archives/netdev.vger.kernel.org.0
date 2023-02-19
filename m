Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B512A69C329
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 00:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjBSXBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 18:01:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjBSXBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 18:01:05 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8427919F3A;
        Sun, 19 Feb 2023 15:01:00 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PKgyK28rzz4x7y;
        Mon, 20 Feb 2023 10:00:56 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1676847658;
        bh=8ql69qLYLVAhMw3ceWj0faqhwOkcspKfnR4XgN8PKZQ=;
        h=Date:From:To:Cc:Subject:From;
        b=uoZqQ2WQbJeO6Xs4WawluFLsW+wMwHKE4xuKqhtOmOiSaftaxH1BZMnCGj7HBCmvr
         IPSgpTXbCZZjiGMFkmFibyKX228NNMBcyMaCYoE8PUM9RBC8O4Vh26dVG4s6Hghb/f
         YFqXXXW84nmUBHK+B9jE9B0rg8iTiN4xrnhGqWQvQ9h7DHHWsWoh2FrpTfjGrAhsI8
         a37dEoyr4MpkM7qw7wHiD7YVgPJN+uHURpVjx2caIYAMuO0OWcQDdx/pLwOVGwHnHT
         CUOIeZ7BQiVcE+kcYrM72K69PQhAOAthUDdjhn1gDKnt01B0LKBImXk13tyI1lcEdi
         H3KWndF0pkp/A==
Date:   Mon, 20 Feb 2023 10:00:56 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the bpf-next tree with the net-next
 tree
Message-ID: <20230220100056.363793d7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/4sV48rQdRWTBxFQGMeKYQ=6";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/4sV48rQdRWTBxFQGMeKYQ=6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  drivers/net/ethernet/intel/ice/ice_xsk.c

between commit:

  675f176b4dcc ("Merge ra.kernel.org:/pub/scm/linux/kernel/git/netdev/net")

from the net-next tree and commit:

  aa1d3faf71a6 ("ice: Robustify cleaning/completing XDP Tx buffers")

from the bpf-next tree.

I fixed it up (I guessed - see below) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc drivers/net/ethernet/intel/ice/ice_xsk.c
index b2d96ae5668c,917c75e530ca..000000000000
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@@ -629,29 -613,28 +629,30 @@@ static void ice_clean_xdp_irq_zc(struc
 =20
  	last_rs =3D xdp_ring->next_to_use ? xdp_ring->next_to_use - 1 : cnt - 1;
  	tx_desc =3D ICE_TX_DESC(xdp_ring, last_rs);
 -	if (tx_desc->cmd_type_offset_bsz &
 -	    cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE)) {
 +	if ((tx_desc->cmd_type_offset_bsz &
 +	    cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE))) {
  		if (last_rs >=3D ntc)
 -			xsk_frames =3D last_rs - ntc + 1;
 +			completed_frames =3D last_rs - ntc + 1;
  		else
 -			xsk_frames =3D last_rs + cnt - ntc + 1;
 +			completed_frames =3D last_rs + cnt - ntc + 1;
  	}
 =20
 -	if (!xsk_frames)
 +	if (!completed_frames)
  		return;
 =20
 -	if (likely(!xdp_ring->xdp_tx_active))
 +	if (likely(!xdp_ring->xdp_tx_active)) {
 +		xsk_frames =3D completed_frames;
  		goto skip;
 +	}
 =20
  	ntc =3D xdp_ring->next_to_clean;
 -	for (i =3D 0; i < xsk_frames; i++) {
 +	for (i =3D 0; i < completed_frames; i++) {
  		tx_buf =3D &xdp_ring->tx_buf[ntc];
 =20
- 		if (tx_buf->raw_buf) {
+ 		if (tx_buf->type =3D=3D ICE_TX_BUF_XSK_TX) {
+ 			tx_buf->type =3D ICE_TX_BUF_EMPTY;
 -			xsk_buff_free(tx_buf->xdp);
 -			xdp_ring->xdp_tx_active--;
 +			ice_clean_xdp_tx_buf(xdp_ring, tx_buf);
 +			tx_buf->raw_buf =3D NULL;
  		} else {
  			xsk_frames++;
  		}

--Sig_/4sV48rQdRWTBxFQGMeKYQ=6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmPyqigACgkQAVBC80lX
0Gxcywf/d67R26+70qJRePcUA/2hLebeQO/NVhclP2sX1KENDkcnLqKEmwdqsq2l
W4ztCvfHdq/g+9u7ZLnKG7hbkorlq3c8Y2NrUt+Ot1CS+KIeVGxGa394tsDS/Xyq
Tu0d58L5+MMxiM6g9yArj+M2/KeHjLeNrj011fVJwCG/eK/NcYHTotiqYo/d5p8K
qs3gbXFG1u0Tn4kdnZAJ2SJl7OV716GQx7jQ6L+iCCV2EVkXw8Qi+1oRWsHqlEoa
t7+FPSjzLtF3ggTIeKNgHwd0ReMFp+29W2vjukf2GWK62beaBGMHof9sUhP8NPwK
tdyjq+plMLlCEPtQl//rQBnCdyxH0w==
=L/Ay
-----END PGP SIGNATURE-----

--Sig_/4sV48rQdRWTBxFQGMeKYQ=6--
