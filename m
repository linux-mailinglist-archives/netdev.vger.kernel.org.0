Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420ED35FFE6
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 04:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbhDOCRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 22:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbhDOCRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 22:17:41 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668FDC061574;
        Wed, 14 Apr 2021 19:17:19 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FLNJq5XTKz9sRR;
        Thu, 15 Apr 2021 12:17:14 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1618453036;
        bh=BrLsH1TkjXEcCa78Xs9wEftT5atraye9p1XkCrViQ1M=;
        h=Date:From:To:Cc:Subject:From;
        b=k/d3M3n0/2KyaBBQWcvDQrdhNAvSke0iP25flsyvDGIUmiN9AVnlywVJeE73IMBRg
         d4WC/U2v/vugOKoT0kKNJYYdxYkaDpHmJRz6J7rBMXB8YtAo0Y9oe3Swp1FCY2osmw
         80gL0ycPFp43zxL4z4iXu+sL11jvV3yAiQ7ajaQfT009pgHN35vKWl9RRYTgoIRYov
         VHNyLVj0wM9aC3nhWq2TDPFQpTz9/rkupTfvD+Kpg2NIxmIkhcMuIXLRicUI9IpFEx
         IYiOqYCx7YNmLq4DGOfa4o4X+/s9rMe6m2tzk/1Gc7DPUorqX3bRBa0JU+37XODiug
         bpfCaMFXH3fRQ==
Date:   Thu, 15 Apr 2021 12:17:13 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Thierry Reding <treding@nvidia.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20210415121713.28af219a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/36b1V7G3c2gIvsXhhZpAXM=";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/36b1V7G3c2gIvsXhhZpAXM=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c

between commit:

  00423969d806 ("Revert "net: stmmac: re-init rx buffers when mac resume ba=
ck"")

from the net tree and commits:

  bba2556efad6 ("net: stmmac: Enable RX via AF_XDP zero-copy")
  de0b90e52a11 ("net: stmmac: rearrange RX and TX desc init into per-queue =
basis")

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

diff --cc drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 4749bd0af160,3a5ca5833ce1..000000000000
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@@ -1380,8 -1519,182 +1519,131 @@@ static void stmmac_free_tx_buffer(struc
  }
 =20
  /**
-  * init_dma_rx_desc_rings - init the RX descriptor rings
-  * @dev: net device structure
+  * dma_free_rx_skbufs - free RX dma buffers
+  * @priv: private structure
+  * @queue: RX queue index
+  */
+ static void dma_free_rx_skbufs(struct stmmac_priv *priv, u32 queue)
+ {
+ 	int i;
+=20
+ 	for (i =3D 0; i < priv->dma_rx_size; i++)
+ 		stmmac_free_rx_buffer(priv, queue, i);
+ }
+=20
+ static int stmmac_alloc_rx_buffers(struct stmmac_priv *priv, u32 queue,
+ 				   gfp_t flags)
+ {
+ 	struct stmmac_rx_queue *rx_q =3D &priv->rx_queue[queue];
+ 	int i;
+=20
+ 	for (i =3D 0; i < priv->dma_rx_size; i++) {
+ 		struct dma_desc *p;
+ 		int ret;
+=20
+ 		if (priv->extend_desc)
+ 			p =3D &((rx_q->dma_erx + i)->basic);
+ 		else
+ 			p =3D rx_q->dma_rx + i;
+=20
+ 		ret =3D stmmac_init_rx_buffers(priv, p, i, flags,
+ 					     queue);
+ 		if (ret)
+ 			return ret;
+=20
+ 		rx_q->buf_alloc_num++;
+ 	}
+=20
+ 	return 0;
+ }
+=20
+ /**
+  * dma_recycle_rx_skbufs - recycle RX dma buffers
+  * @priv: private structure
+  * @queue: RX queue index
+  */
+ static void dma_recycle_rx_skbufs(struct stmmac_priv *priv, u32 queue)
+ {
+ 	struct stmmac_rx_queue *rx_q =3D &priv->rx_queue[queue];
+ 	int i;
+=20
+ 	for (i =3D 0; i < priv->dma_rx_size; i++) {
+ 		struct stmmac_rx_buffer *buf =3D &rx_q->buf_pool[i];
+=20
+ 		if (buf->page) {
+ 			page_pool_recycle_direct(rx_q->page_pool, buf->page);
+ 			buf->page =3D NULL;
+ 		}
+=20
+ 		if (priv->sph && buf->sec_page) {
+ 			page_pool_recycle_direct(rx_q->page_pool, buf->sec_page);
+ 			buf->sec_page =3D NULL;
+ 		}
+ 	}
+ }
+=20
+ /**
+  * dma_free_rx_xskbufs - free RX dma buffers from XSK pool
+  * @priv: private structure
+  * @queue: RX queue index
+  */
+ static void dma_free_rx_xskbufs(struct stmmac_priv *priv, u32 queue)
+ {
+ 	struct stmmac_rx_queue *rx_q =3D &priv->rx_queue[queue];
+ 	int i;
+=20
+ 	for (i =3D 0; i < priv->dma_rx_size; i++) {
+ 		struct stmmac_rx_buffer *buf =3D &rx_q->buf_pool[i];
+=20
+ 		if (!buf->xdp)
+ 			continue;
+=20
+ 		xsk_buff_free(buf->xdp);
+ 		buf->xdp =3D NULL;
+ 	}
+ }
+=20
+ static int stmmac_alloc_rx_buffers_zc(struct stmmac_priv *priv, u32 queue)
+ {
+ 	struct stmmac_rx_queue *rx_q =3D &priv->rx_queue[queue];
+ 	int i;
+=20
+ 	for (i =3D 0; i < priv->dma_rx_size; i++) {
+ 		struct stmmac_rx_buffer *buf;
+ 		dma_addr_t dma_addr;
+ 		struct dma_desc *p;
+=20
+ 		if (priv->extend_desc)
+ 			p =3D (struct dma_desc *)(rx_q->dma_erx + i);
+ 		else
+ 			p =3D rx_q->dma_rx + i;
+=20
+ 		buf =3D &rx_q->buf_pool[i];
+=20
+ 		buf->xdp =3D xsk_buff_alloc(rx_q->xsk_pool);
+ 		if (!buf->xdp)
+ 			return -ENOMEM;
+=20
+ 		dma_addr =3D xsk_buff_xdp_get_dma(buf->xdp);
+ 		stmmac_set_desc_addr(priv, p, dma_addr);
+ 		rx_q->buf_alloc_num++;
+ 	}
+=20
+ 	return 0;
+ }
+=20
 -/**
 - * stmmac_reinit_rx_buffers - reinit the RX descriptor buffer.
 - * @priv: driver private structure
 - * Description: this function is called to re-allocate a receive buffer, =
perform
 - * the DMA mapping and init the descriptor.
 - */
 -static void stmmac_reinit_rx_buffers(struct stmmac_priv *priv)
 -{
 -	u32 rx_count =3D priv->plat->rx_queues_to_use;
 -	u32 queue;
 -
 -	for (queue =3D 0; queue < rx_count; queue++) {
 -		struct stmmac_rx_queue *rx_q =3D &priv->rx_queue[queue];
 -
 -		if (rx_q->xsk_pool)
 -			dma_free_rx_xskbufs(priv, queue);
 -		else
 -			dma_recycle_rx_skbufs(priv, queue);
 -
 -		rx_q->buf_alloc_num =3D 0;
 -	}
 -
 -	for (queue =3D 0; queue < rx_count; queue++) {
 -		struct stmmac_rx_queue *rx_q =3D &priv->rx_queue[queue];
 -		int ret;
 -
 -		if (rx_q->xsk_pool) {
 -			/* RX XDP ZC buffer pool may not be populated, e.g.
 -			 * xdpsock TX-only.
 -			 */
 -			stmmac_alloc_rx_buffers_zc(priv, queue);
 -		} else {
 -			ret =3D stmmac_alloc_rx_buffers(priv, queue, GFP_KERNEL);
 -			if (ret < 0)
 -				goto err_reinit_rx_buffers;
 -		}
 -	}
 -
 -	return;
 -
 -err_reinit_rx_buffers:
 -	while (queue >=3D 0) {
 -		dma_free_rx_skbufs(priv, queue);
 -
 -		if (queue =3D=3D 0)
 -			break;
 -
 -		queue--;
 -	}
 -}
 -
+ static struct xsk_buff_pool *stmmac_get_xsk_pool(struct stmmac_priv *priv=
, u32 queue)
+ {
+ 	if (!stmmac_xdp_is_enabled(priv) || !test_bit(queue, priv->af_xdp_zc_qps=
))
+ 		return NULL;
+=20
+ 	return xsk_get_pool_from_qid(priv->dev, queue);
+ }
+=20
+ /**
+  * __init_dma_rx_desc_rings - init the RX descriptor ring (per queue)
+  * @priv: driver private structure
+  * @queue: RX queue index
   * @flags: gfp flag.
   * Description: this function initializes the DMA RX descriptors
   * and allocates the socket buffers. It supports the chained and ring

--Sig_/36b1V7G3c2gIvsXhhZpAXM=
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmB3oikACgkQAVBC80lX
0GyDJwf+KVq1amHrqU9tXwJfJuPPV9y7YPJwyvgBfYi8HWEXLL2coLsHMfdGsSg8
GS4KJJWIuMXu1ccZkE6pvm4y3K+CZIdIpGST1RNISvx8sJ50/c1xinkCXvE3oTer
KlLtryKxGkHwQwCDKK95kkMjSxCWsLqGcQYOT9A4yycVETuhP3NMFwt4QnwjToT4
UPu1R2/lTYcCbOnbJycN9xGWM3l6J1SjDm3mhi6l4yKWbZjNPpW4P842HJFjmNQH
r1YyCucl8Omxi2spwoWocbd9wm8kG+c7LM/daiOhkMG1mDBXpAXxkfv/lFVx9xBf
rlMM6XnJaEPDqPllttaxKn0VZC615Q==
=cyCm
-----END PGP SIGNATURE-----

--Sig_/36b1V7G3c2gIvsXhhZpAXM=--
