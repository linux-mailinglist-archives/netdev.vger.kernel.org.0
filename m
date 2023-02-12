Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAC82693B0C
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 00:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjBLXUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 18:20:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjBLXUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 18:20:45 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3FE1BC8;
        Sun, 12 Feb 2023 15:20:43 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PFNkJ4sl8z4x7W;
        Mon, 13 Feb 2023 10:20:40 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1676244041;
        bh=YcpfBkJvm0eyXiI5WWX9ZH+DXQjFdYu9GmRfUHAw6rQ=;
        h=Date:From:To:Cc:Subject:From;
        b=Jcev2Ioq0DDRYQC6AkpMDsT3D+1roAcg4gHJD/lML7L0q5oY4MRRhiZV3mTnBs6GW
         TP43cNCtjzN+nOCxRSIi3CsrC1R5ZPVfOS2GNdgkAEtt5uwdci86qNqGRXZ8wkKu70
         3aOx9yA170nI7bcwWtCjrHjU4XUzPmxgOSXOvaMMuKHLGm/0FhNy3TMkiyE9l1kxL2
         mVs6YsXe+svhQlVSOFVRwvxKOu+gKKQfr4BZoHw6MIP8uCoHwt7aHbE3NGUmga7lH3
         p2Z10Ff5kbTaWSALlWvMjph36zb7lG8hS/sJ06n5n0umUu4sTbSxptuSA61cnW6KVO
         DCB3nlIopJHUQ==
Date:   Mon, 13 Feb 2023 10:20:38 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20230213102038.54cc9060@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/tc04duNOEoYLS7.NG43Bjis";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/tc04duNOEoYLS7.NG43Bjis
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/intel/ice/ice_xsk.c

between commit:

  1f090494170e ("ice: xsk: Fix cleaning of XDP_TX frames")

from the net tree and commit:

  a24b4c6e9aab ("ice: xsk: Do not convert to buff to frame for XDP_TX")

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

diff --cc drivers/net/ethernet/intel/ice/ice_xsk.c
index 374b7f10b549,a25a68c69f22..000000000000
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@@ -597,6 -597,107 +597,110 @@@ ice_construct_skb_zc(struct ice_rx_rin
  	return skb;
  }
 =20
+ /**
+  * ice_clean_xdp_irq_zc - AF_XDP ZC specific Tx cleaning routine
+  * @xdp_ring: XDP Tx ring
+  */
+ static void ice_clean_xdp_irq_zc(struct ice_tx_ring *xdp_ring)
+ {
+ 	u16 ntc =3D xdp_ring->next_to_clean;
+ 	struct ice_tx_desc *tx_desc;
+ 	u16 cnt =3D xdp_ring->count;
+ 	struct ice_tx_buf *tx_buf;
++	u16 completed_frames =3D 0;
+ 	u16 xsk_frames =3D 0;
+ 	u16 last_rs;
+ 	int i;
+=20
+ 	last_rs =3D xdp_ring->next_to_use ? xdp_ring->next_to_use - 1 : cnt - 1;
+ 	tx_desc =3D ICE_TX_DESC(xdp_ring, last_rs);
+ 	if (tx_desc->cmd_type_offset_bsz &
+ 	    cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE)) {
+ 		if (last_rs >=3D ntc)
 -			xsk_frames =3D last_rs - ntc + 1;
++			completed_frames =3D last_rs - ntc + 1;
+ 		else
 -			xsk_frames =3D last_rs + cnt - ntc + 1;
++			completed_frames =3D last_rs + cnt - ntc + 1;
+ 	}
+=20
 -	if (!xsk_frames)
++	if (!completed_frames)
+ 		return;
+=20
 -	if (likely(!xdp_ring->xdp_tx_active))
++	if (likely(!xdp_ring->xdp_tx_active)) {
++		xsk_frames =3D completed_frames;
+ 		goto skip;
++	}
+=20
+ 	ntc =3D xdp_ring->next_to_clean;
 -	for (i =3D 0; i < xsk_frames; i++) {
++	for (i =3D 0; i < completed_frames; i++) {
+ 		tx_buf =3D &xdp_ring->tx_buf[ntc];
+=20
+ 		if (tx_buf->xdp) {
+ 			xsk_buff_free(tx_buf->xdp);
+ 			xdp_ring->xdp_tx_active--;
+ 		} else {
+ 			xsk_frames++;
+ 		}
+=20
+ 		ntc++;
+ 		if (ntc =3D=3D cnt)
+ 			ntc =3D 0;
+ 	}
+ skip:
+ 	tx_desc->cmd_type_offset_bsz =3D 0;
 -	xdp_ring->next_to_clean +=3D xsk_frames;
++	xdp_ring->next_to_clean +=3D completed_frames;
+ 	if (xdp_ring->next_to_clean >=3D cnt)
+ 		xdp_ring->next_to_clean -=3D cnt;
+ 	if (xsk_frames)
+ 		xsk_tx_completed(xdp_ring->xsk_pool, xsk_frames);
+ }
+=20
+ /**
+  * ice_xmit_xdp_tx_zc - AF_XDP ZC handler for XDP_TX
+  * @xdp: XDP buffer to xmit
+  * @xdp_ring: XDP ring to produce descriptor onto
+  *
+  * note that this function works directly on xdp_buff, no need to convert
+  * it to xdp_frame. xdp_buff pointer is stored to ice_tx_buf so that clea=
ning
+  * side will be able to xsk_buff_free() it.
+  *
+  * Returns ICE_XDP_TX for successfully produced desc, ICE_XDP_CONSUMED if=
 there
+  * was not enough space on XDP ring
+  */
+ static int ice_xmit_xdp_tx_zc(struct xdp_buff *xdp,
+ 			      struct ice_tx_ring *xdp_ring)
+ {
+ 	u32 size =3D xdp->data_end - xdp->data;
+ 	u32 ntu =3D xdp_ring->next_to_use;
+ 	struct ice_tx_desc *tx_desc;
+ 	struct ice_tx_buf *tx_buf;
+ 	dma_addr_t dma;
+=20
+ 	if (ICE_DESC_UNUSED(xdp_ring) < ICE_RING_QUARTER(xdp_ring)) {
+ 		ice_clean_xdp_irq_zc(xdp_ring);
+ 		if (!ICE_DESC_UNUSED(xdp_ring)) {
+ 			xdp_ring->ring_stats->tx_stats.tx_busy++;
+ 			return ICE_XDP_CONSUMED;
+ 		}
+ 	}
+=20
+ 	dma =3D xsk_buff_xdp_get_dma(xdp);
+ 	xsk_buff_raw_dma_sync_for_device(xdp_ring->xsk_pool, dma, size);
+=20
+ 	tx_buf =3D &xdp_ring->tx_buf[ntu];
+ 	tx_buf->xdp =3D xdp;
+ 	tx_desc =3D ICE_TX_DESC(xdp_ring, ntu);
+ 	tx_desc->buf_addr =3D cpu_to_le64(dma);
+ 	tx_desc->cmd_type_offset_bsz =3D ice_build_ctob(ICE_TX_DESC_CMD_EOP,
+ 						      0, size, 0);
+ 	xdp_ring->xdp_tx_active++;
+=20
+ 	if (++ntu =3D=3D xdp_ring->count)
+ 		ntu =3D 0;
+ 	xdp_ring->next_to_use =3D ntu;
+=20
+ 	return ICE_XDP_TX;
+ }
+=20
  /**
   * ice_run_xdp_zc - Executes an XDP program in zero-copy path
   * @rx_ring: Rx ring

--Sig_/tc04duNOEoYLS7.NG43Bjis
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmPpdEYACgkQAVBC80lX
0GxOeAf9EWsX0B0MecMGqw5G4HSDx3pkxfHLv3sJKlY0mu6JRQPc+lkyfENcJrgG
7B9rwjJptf5nc+B0TsKReWDcPGfmHfQUyHiCMinatc/EhCf59rGEKtiyAfy2jIqm
COivqUihk0aWiyx+ca70XSvgnUHoMSFsl01bOA7mLW68bo6ZNJmuJ24L4K1jotYb
xwFuFG43NZifdfkNhLAjeIE3vembJ+ogxZuwjDkOFh5yBmv5Y+5iWlOlzmJDiQZh
YjUC8eHgvqdY9MqSeNyVMB+f+Tp/ayWGendRa1VKP/aSHUknHTRsbD3vkn4dEvCg
4dkg74JGEU6EA3MufmyiuWcu0qQPKQ==
=ipTx
-----END PGP SIGNATURE-----

--Sig_/tc04duNOEoYLS7.NG43Bjis--
