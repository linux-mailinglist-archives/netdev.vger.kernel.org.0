Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9A3FD8D51
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 12:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392223AbfJPKJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 06:09:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:33220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388365AbfJPKJH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 06:09:07 -0400
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCB9B20650;
        Wed, 16 Oct 2019 10:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571220545;
        bh=QhSU60vMaizKKtvPqqXp9g4hr8kDZDFL2fL9qvHc4oA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hzbVQqX2lp1SJlOo0TW9O94vGxY2gJnE8KL5DaIzDxwkYP29rE15am20Mml+YQZG7
         KPsoqCtZrL9Jc3NhbiIY6hQhromyLFG4YS3rdOSpJaat/ot7A+9KsOVioYUjPwq5Wd
         BPt4IbStA3kPBswaFOp8nnS/0njANeqav06Hr2AU=
Date:   Wed, 16 Oct 2019 12:09:00 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        brouer@redhat.com, ilias.apalodimas@linaro.org,
        matteo.croce@redhat.com, mw@semihalf.com
Subject: Re: [PATCH v3 net-next 8/8] net: mvneta: add XDP_TX support
Message-ID: <20191016100900.GE2638@localhost.localdomain>
References: <cover.1571049326.git.lorenzo@kernel.org>
 <a964f1a704f194169e80f9693cf3150adffc1278.1571049326.git.lorenzo@kernel.org>
 <20191015171152.41d9a747@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="d8Lz2Tf5e5STOWUP"
Content-Disposition: inline
In-Reply-To: <20191015171152.41d9a747@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--d8Lz2Tf5e5STOWUP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, 14 Oct 2019 12:49:55 +0200, Lorenzo Bianconi wrote:
> > Implement XDP_TX verdict and ndo_xdp_xmit net_device_ops function
> > pointer
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>=20
> > @@ -1972,6 +1975,109 @@ int mvneta_rx_refill_queue(struct mvneta_port *=
pp, struct mvneta_rx_queue *rxq)
> >  	return i;
> >  }
> > =20
> > +static int
> > +mvneta_xdp_submit_frame(struct mvneta_port *pp, struct mvneta_tx_queue=
 *txq,
> > +			struct xdp_frame *xdpf, bool dma_map)
> > +{
> > +	struct mvneta_tx_desc *tx_desc;
> > +	struct mvneta_tx_buf *buf;
> > +	dma_addr_t dma_addr;
> > +
> > +	if (txq->count >=3D txq->tx_stop_threshold)
> > +		return MVNETA_XDP_CONSUMED;
> > +
> > +	tx_desc =3D mvneta_txq_next_desc_get(txq);
> > +
> > +	buf =3D &txq->buf[txq->txq_put_index];
> > +	if (dma_map) {
> > +		/* ndo_xdp_xmit */
> > +		dma_addr =3D dma_map_single(pp->dev->dev.parent, xdpf->data,
> > +					  xdpf->len, DMA_TO_DEVICE);
> > +		if (dma_mapping_error(pp->dev->dev.parent, dma_addr)) {
> > +			mvneta_txq_desc_put(txq);
> > +			return MVNETA_XDP_CONSUMED;
> > +		}
> > +		buf->type =3D MVNETA_TYPE_XDP_NDO;
> > +	} else {
> > +		struct page *page =3D virt_to_page(xdpf->data);
> > +
> > +		dma_addr =3D page_pool_get_dma_addr(page) +
> > +			   pp->rx_offset_correction + MVNETA_MH_SIZE;
> > +		dma_sync_single_for_device(pp->dev->dev.parent, dma_addr,
> > +					   xdpf->len, DMA_BIDIRECTIONAL);
>=20
> This looks a little suspicious, XDP could have moved the start of frame
> with adjust_head, right? You should also use xdpf->data to find where
> the frame starts, no?

uhm, right..we need to update the dma_addr doing something like:

dma_addr =3D page_pool_get_dma_addr(page) + xdpf->data - xdpf;

and then use xdpf->len for dma-sync

>=20
> > +		buf->type =3D MVNETA_TYPE_XDP_TX;
> > +	}
> > +	buf->xdpf =3D xdpf;
> > +
> > +	tx_desc->command =3D MVNETA_TXD_FLZ_DESC;
> > +	tx_desc->buf_phys_addr =3D dma_addr;
> > +	tx_desc->data_size =3D xdpf->len;
> > +
> > +	mvneta_update_stats(pp, 1, xdpf->len, true);
> > +	mvneta_txq_inc_put(txq);
> > +	txq->pending++;
> > +	txq->count++;
> > +
> > +	return MVNETA_XDP_TX;
> > +}
> > +
> > +static int
> > +mvneta_xdp_xmit_back(struct mvneta_port *pp, struct xdp_buff *xdp)
> > +{
> > +	struct xdp_frame *xdpf =3D convert_to_xdp_frame(xdp);
> > +	int cpu =3D smp_processor_id();
> > +	struct mvneta_tx_queue *txq;
> > +	struct netdev_queue *nq;
> > +	u32 ret;
> > +
> > +	if (unlikely(!xdpf))
> > +		return MVNETA_XDP_CONSUMED;
>=20
> Personally I'd prefer you haven't called a function which return code
> has to be error checked in local variable init.

do you mean moving cpu =3D smp_processor_id(); after the if condition?

Regards,
Lorenzo

>=20
> > +
> > +	txq =3D &pp->txqs[cpu % txq_number];
> > +	nq =3D netdev_get_tx_queue(pp->dev, txq->id);
> > +
> > +	__netif_tx_lock(nq, cpu);
> > +	ret =3D mvneta_xdp_submit_frame(pp, txq, xdpf, false);
> > +	if (ret =3D=3D MVNETA_XDP_TX)
> > +		mvneta_txq_pend_desc_add(pp, txq, 0);
> > +	__netif_tx_unlock(nq);
> > +
> > +	return ret;
> > +}

--d8Lz2Tf5e5STOWUP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXabsNgAKCRA6cBh0uS2t
rIPIAP43Al/FTgcC7gkd3l+YQKe6ktONQLKSFObf1gOuOjjb1QD+J19DdsFN0EPr
ZBSf8tkcaK9z66wy6zNRu4NwVKg75Q0=
=tWcU
-----END PGP SIGNATURE-----

--d8Lz2Tf5e5STOWUP--
