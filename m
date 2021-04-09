Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5990535A37B
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 18:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233824AbhDIQgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 12:36:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:39374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233038AbhDIQgX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 12:36:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93E966108B;
        Fri,  9 Apr 2021 16:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617986170;
        bh=+eGzFdHlaD4wX05Xc3S6vhxR9GXOqG9jYX5DgdrbKpw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TZxs5ro5H2YDfI4wUWanIw2DZUTkxRz5+leZ2fpgGwtEoPDWRkQpvMBBhavxWHqkH
         8sYtBLKSt/CfaIRyCrbiO90eR30BwCXfYfP1ICJd+Q35Cef14a1ZDVEswinz6OzI0B
         3DvYygamDGtKH80QW/MPk8jlCkPS5lGGBEQ6qSJGb7z1M3amO4gfkij7CgEvQJWbX1
         b8J3vHGzW9/X16rqEOVzsOr1yyvzQ0cWvdcuID2w12RyvFwLhxVEEKzDMRXvsqvcIH
         0RN1MuR8VsnRrU2Bqr/h4ZtPrzd+mbi/1HMH30jkMyAvA1JckYuFPn+HpWxNSsiTYo
         9oK6tn2naL/hQ==
Date:   Fri, 9 Apr 2021 18:36:05 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com
Subject: Re: [PATCH v8 bpf-next 05/14] net: mvneta: add multi buffer support
 to XDP_TX
Message-ID: <YHCCdSqCByo9JVp+@lore-desk>
References: <cover.1617885385.git.lorenzo@kernel.org>
 <9cd3048c42f686bd0f84378b7212d5e9f4a97abd.1617885385.git.lorenzo@kernel.org>
 <20210408184002.k2om3nrittvh7z45@skbuf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="098ibDs1GxaA3I79"
Content-Disposition: inline
In-Reply-To: <20210408184002.k2om3nrittvh7z45@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--098ibDs1GxaA3I79
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu, Apr 08, 2021 at 02:50:57PM +0200, Lorenzo Bianconi wrote:
> > Introduce the capability to map non-linear xdp buffer running
> > mvneta_xdp_submit_frame() for XDP_TX and XDP_REDIRECT
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/ethernet/marvell/mvneta.c | 94 +++++++++++++++++----------
> >  1 file changed, 58 insertions(+), 36 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethern=
et/marvell/mvneta.c
> > index 94e29cce693a..e95d8df0fcdb 100644
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > @@ -1860,8 +1860,8 @@ static void mvneta_txq_bufs_free(struct mvneta_po=
rt *pp,
> >  			bytes_compl +=3D buf->skb->len;
> >  			pkts_compl++;
> >  			dev_kfree_skb_any(buf->skb);
> > -		} else if (buf->type =3D=3D MVNETA_TYPE_XDP_TX ||
> > -			   buf->type =3D=3D MVNETA_TYPE_XDP_NDO) {
> > +		} else if ((buf->type =3D=3D MVNETA_TYPE_XDP_TX ||
> > +			    buf->type =3D=3D MVNETA_TYPE_XDP_NDO) && buf->xdpf) {
> >  			if (napi && buf->type =3D=3D MVNETA_TYPE_XDP_TX)
> >  				xdp_return_frame_rx_napi(buf->xdpf);
> >  			else
> > @@ -2057,45 +2057,67 @@ mvneta_xdp_put_buff(struct mvneta_port *pp, str=
uct mvneta_rx_queue *rxq,
> > =20
> >  static int
> >  mvneta_xdp_submit_frame(struct mvneta_port *pp, struct mvneta_tx_queue=
 *txq,
> > -			struct xdp_frame *xdpf, bool dma_map)
> > +			struct xdp_frame *xdpf, int *nxmit_byte, bool dma_map)
> >  {
> > -	struct mvneta_tx_desc *tx_desc;
> > -	struct mvneta_tx_buf *buf;
> > -	dma_addr_t dma_addr;
> > +	struct mvneta_tx_desc *tx_desc =3D NULL;
> > +	struct xdp_shared_info *xdp_sinfo;
> > +	struct page *page;
> > +	int i, num_frames;
> > +
> > +	xdp_sinfo =3D xdp_get_shared_info_from_frame(xdpf);
> > +	num_frames =3D xdpf->mb ? xdp_sinfo->nr_frags + 1 : 1;
> > =20
> > -	if (txq->count >=3D txq->tx_stop_threshold)
> > +	if (txq->count + num_frames >=3D txq->size)
> >  		return MVNETA_XDP_DROPPED;
> > =20
> > -	tx_desc =3D mvneta_txq_next_desc_get(txq);
> > +	for (i =3D 0; i < num_frames; i++) {
>=20
> I get the feeling this is more like num_bufs than num_frames.

naming is the hardest part :)

>=20
> > +		struct mvneta_tx_buf *buf =3D &txq->buf[txq->txq_put_index];
> > +		skb_frag_t *frag =3D i ? &xdp_sinfo->frags[i - 1] : NULL;
> > +		int len =3D i ? xdp_get_frag_size(frag) : xdpf->len;
> > +		dma_addr_t dma_addr;
> > =20
> > -	buf =3D &txq->buf[txq->txq_put_index];
> > -	if (dma_map) {
> > -		/* ndo_xdp_xmit */
> > -		dma_addr =3D dma_map_single(pp->dev->dev.parent, xdpf->data,
> > -					  xdpf->len, DMA_TO_DEVICE);
> > -		if (dma_mapping_error(pp->dev->dev.parent, dma_addr)) {
> > -			mvneta_txq_desc_put(txq);
> > -			return MVNETA_XDP_DROPPED;
> > +		tx_desc =3D mvneta_txq_next_desc_get(txq);
> > +		if (dma_map) {
> > +			/* ndo_xdp_xmit */
> > +			void *data;
> > +
> > +			data =3D frag ? xdp_get_frag_address(frag) : xdpf->data;
> > +			dma_addr =3D dma_map_single(pp->dev->dev.parent, data,
> > +						  len, DMA_TO_DEVICE);
> > +			if (dma_mapping_error(pp->dev->dev.parent, dma_addr)) {
> > +				for (; i >=3D 0; i--)
> > +					mvneta_txq_desc_put(txq);
>=20
> Don't you need to unmap the previous buffers too?

ack, right since these buffers do not belong to the pool, I will fix it.

Regards,
Lorenzo

>=20
> > +				return MVNETA_XDP_DROPPED;
> > +			}
> > +			buf->type =3D MVNETA_TYPE_XDP_NDO;
> > +		} else {
> > +			page =3D frag ? xdp_get_frag_page(frag)
> > +				    : virt_to_page(xdpf->data);
> > +			dma_addr =3D page_pool_get_dma_addr(page);
> > +			if (frag)
> > +				dma_addr +=3D xdp_get_frag_offset(frag);
> > +			else
> > +				dma_addr +=3D sizeof(*xdpf) + xdpf->headroom;
> > +			dma_sync_single_for_device(pp->dev->dev.parent,
> > +						   dma_addr, len,
> > +						   DMA_BIDIRECTIONAL);
> > +			buf->type =3D MVNETA_TYPE_XDP_TX;
> >  		}
> > -		buf->type =3D MVNETA_TYPE_XDP_NDO;
> > -	} else {
> > -		struct page *page =3D virt_to_page(xdpf->data);
> > +		buf->xdpf =3D i ? NULL : xdpf;
> > =20
> > -		dma_addr =3D page_pool_get_dma_addr(page) +
> > -			   sizeof(*xdpf) + xdpf->headroom;
> > -		dma_sync_single_for_device(pp->dev->dev.parent, dma_addr,
> > -					   xdpf->len, DMA_BIDIRECTIONAL);
> > -		buf->type =3D MVNETA_TYPE_XDP_TX;
> > +		tx_desc->command =3D !i ? MVNETA_TXD_F_DESC : 0;
> > +		tx_desc->buf_phys_addr =3D dma_addr;
> > +		tx_desc->data_size =3D len;
> > +		*nxmit_byte +=3D len;
> > +
> > +		mvneta_txq_inc_put(txq);
> >  	}
> > -	buf->xdpf =3D xdpf;
> > =20
> > -	tx_desc->command =3D MVNETA_TXD_FLZ_DESC;
> > -	tx_desc->buf_phys_addr =3D dma_addr;
> > -	tx_desc->data_size =3D xdpf->len;
> > +	/*last descriptor */
> > +	tx_desc->command |=3D MVNETA_TXD_L_DESC | MVNETA_TXD_Z_PAD;
> > =20
> > -	mvneta_txq_inc_put(txq);
> > -	txq->pending++;
> > -	txq->count++;
> > +	txq->pending +=3D num_frames;
> > +	txq->count +=3D num_frames;
> > =20
> >  	return MVNETA_XDP_TX;
> >  }
> > @@ -2106,8 +2128,8 @@ mvneta_xdp_xmit_back(struct mvneta_port *pp, stru=
ct xdp_buff *xdp)
> >  	struct mvneta_pcpu_stats *stats =3D this_cpu_ptr(pp->stats);
> >  	struct mvneta_tx_queue *txq;
> >  	struct netdev_queue *nq;
> > +	int cpu, nxmit_byte =3D 0;
> >  	struct xdp_frame *xdpf;
> > -	int cpu;
> >  	u32 ret;
> > =20
> >  	xdpf =3D xdp_convert_buff_to_frame(xdp);
> > @@ -2119,10 +2141,10 @@ mvneta_xdp_xmit_back(struct mvneta_port *pp, st=
ruct xdp_buff *xdp)
> >  	nq =3D netdev_get_tx_queue(pp->dev, txq->id);
> > =20
> >  	__netif_tx_lock(nq, cpu);
> > -	ret =3D mvneta_xdp_submit_frame(pp, txq, xdpf, false);
> > +	ret =3D mvneta_xdp_submit_frame(pp, txq, xdpf, &nxmit_byte, false);
> >  	if (ret =3D=3D MVNETA_XDP_TX) {
> >  		u64_stats_update_begin(&stats->syncp);
> > -		stats->es.ps.tx_bytes +=3D xdpf->len;
> > +		stats->es.ps.tx_bytes +=3D nxmit_byte;
> >  		stats->es.ps.tx_packets++;
> >  		stats->es.ps.xdp_tx++;
> >  		u64_stats_update_end(&stats->syncp);
> > @@ -2161,11 +2183,11 @@ mvneta_xdp_xmit(struct net_device *dev, int num=
_frame,
> > =20
> >  	__netif_tx_lock(nq, cpu);
> >  	for (i =3D 0; i < num_frame; i++) {
> > -		ret =3D mvneta_xdp_submit_frame(pp, txq, frames[i], true);
> > +		ret =3D mvneta_xdp_submit_frame(pp, txq, frames[i], &nxmit_byte,
> > +					      true);
> >  		if (ret !=3D MVNETA_XDP_TX)
> >  			break;
> > =20
> > -		nxmit_byte +=3D frames[i]->len;
> >  		nxmit++;
> >  	}
> > =20
> > --=20
> > 2.30.2
> >=20

--098ibDs1GxaA3I79
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYHCCcwAKCRA6cBh0uS2t
rJiAAQD129xcjnnuo1ymIYXJ/Hp+LprwObGMDLi+w5R2VxJzOwEApgUb7Iqc65sv
qBcQ2zokj+3JbYhyHUw76HrPr667JA0=
=Ip6p
-----END PGP SIGNATURE-----

--098ibDs1GxaA3I79--
