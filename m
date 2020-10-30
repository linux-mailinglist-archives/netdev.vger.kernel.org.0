Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40E029FF92
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 09:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgJ3IWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 04:22:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:44422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgJ3IWx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 04:22:53 -0400
Received: from localhost (unknown [151.66.29.159])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9286D22210;
        Fri, 30 Oct 2020 08:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604046172;
        bh=tw9ZIbGM1l3QaYwhoYxULYl8xwmfWBMkqsLUQwH5Iqg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sCOg4XOeHUvSaznQWeHjUrDcvnA1HF8T7JnluU3Tr3SQ7vJPBK5DUqoieAA+oFocQ
         BDDtUf1jBHJBpwEzKSUHCTk+Qy4YbyeoPnqW5LKM8w1nzth7byaWD9MRySPUfknF+h
         xgJu9TeCRGSCXX5mhY1jqhL0bPzed+8bq5LCGT/Y=
Date:   Fri, 30 Oct 2020 09:22:47 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com
Subject: Re: [PATCH v2 net-next 1/4] net: xdp: introduce bulking for xdp tx
 return path
Message-ID: <20201030082247.GA2041@lore-desk>
References: <cover.1603998519.git.lorenzo@kernel.org>
 <aaf417930ccfdd57ee3a7339e2fff59b8ad50409.1603998519.git.lorenzo@kernel.org>
 <20201030043254.GA100756@apalos.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <20201030043254.GA100756@apalos.home>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Hi Lorenzo,=20
>=20
> On Thu, Oct 29, 2020 at 08:28:44PM +0100, Lorenzo Bianconi wrote:
[...]
> > index 54b0bf574c05..43ab8a73900e 100644
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > @@ -1834,8 +1834,10 @@ static void mvneta_txq_bufs_free(struct mvneta_p=
ort *pp,
> >  				 struct netdev_queue *nq, bool napi)
> >  {
> >  	unsigned int bytes_compl =3D 0, pkts_compl =3D 0;
> > +	struct xdp_frame_bulk bq;
> >  	int i;
> > =20
> > +	bq.xa =3D NULL;
> >  	for (i =3D 0; i < num; i++) {
> >  		struct mvneta_tx_buf *buf =3D &txq->buf[txq->txq_get_index];
> >  		struct mvneta_tx_desc *tx_desc =3D txq->descs +
> > @@ -1857,9 +1859,10 @@ static void mvneta_txq_bufs_free(struct mvneta_p=
ort *pp,
> >  			if (napi && buf->type =3D=3D MVNETA_TYPE_XDP_TX)
> >  				xdp_return_frame_rx_napi(buf->xdpf);
> >  			else
> > -				xdp_return_frame(buf->xdpf);
> > +				xdp_return_frame_bulk(buf->xdpf, &bq);
> >  		}
> >  	}
> > +	xdp_flush_frame_bulk(&bq);
> > =20
> >  	netdev_tx_completed_queue(nq, pkts_compl, bytes_compl);
> >  }
>=20
> Sorry I completely forgot to mention this on the v1 review.
> I think this belongs to a patch of it's own similar to mellanox and mvpp2=
=20
> drivers

ack, I am fine with it. I will fix it in v3.

Regards,
Lorenzo

>=20
> > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > index 3814fb631d52..a1f48a73e6df 100644
> > --- a/include/net/xdp.h
> > +++ b/include/net/xdp.h
> > @@ -104,6 +104,12 @@ struct xdp_frame {
> >  	struct net_device *dev_rx; /* used by cpumap */
> >  };
> > =20
> > +#define XDP_BULK_QUEUE_SIZE	16
> > +struct xdp_frame_bulk {
> > +	int count;
> > +	void *xa;
> > +	void *q[XDP_BULK_QUEUE_SIZE];
> > +};
> > =20
> >  static inline struct skb_shared_info *
> >  xdp_get_shared_info_from_frame(struct xdp_frame *frame)
> > @@ -194,6 +200,9 @@ struct xdp_frame *xdp_convert_buff_to_frame(struct =
xdp_buff *xdp)
> >  void xdp_return_frame(struct xdp_frame *xdpf);
> >  void xdp_return_frame_rx_napi(struct xdp_frame *xdpf);
> >  void xdp_return_buff(struct xdp_buff *xdp);
> > +void xdp_flush_frame_bulk(struct xdp_frame_bulk *bq);
> > +void xdp_return_frame_bulk(struct xdp_frame *xdpf,
> > +			   struct xdp_frame_bulk *bq);
> > =20
> >  /* When sending xdp_frame into the network stack, then there is no
> >   * return point callback, which is needed to release e.g. DMA-mapping
> > diff --git a/net/core/xdp.c b/net/core/xdp.c
> > index 48aba933a5a8..66ac275a0360 100644
> > --- a/net/core/xdp.c
> > +++ b/net/core/xdp.c
> > @@ -380,6 +380,67 @@ void xdp_return_frame_rx_napi(struct xdp_frame *xd=
pf)
> >  }
> >  EXPORT_SYMBOL_GPL(xdp_return_frame_rx_napi);
> > =20
> > +/* XDP bulk APIs introduce a defer/flush mechanism to return
> > + * pages belonging to the same xdp_mem_allocator object
> > + * (identified via the mem.id field) in bulk to optimize
> > + * I-cache and D-cache.
> > + * The bulk queue size is set to 16 to be aligned to how
> > + * XDP_REDIRECT bulking works. The bulk is flushed when
> > + * it is full or when mem.id changes.
> > + * xdp_frame_bulk is usually stored/allocated on the function
> > + * call-stack to avoid locking penalties.
> > + */
> > +void xdp_flush_frame_bulk(struct xdp_frame_bulk *bq)
> > +{
> > +	struct xdp_mem_allocator *xa =3D bq->xa;
> > +	int i;
> > +
> > +	if (unlikely(!xa))
> > +		return;
> > +
> > +	for (i =3D 0; i < bq->count; i++) {
> > +		struct page *page =3D virt_to_head_page(bq->q[i]);
> > +
> > +		page_pool_put_full_page(xa->page_pool, page, false);
> > +	}
> > +	bq->count =3D 0;
> > +}
> > +EXPORT_SYMBOL_GPL(xdp_flush_frame_bulk);
> > +
> > +void xdp_return_frame_bulk(struct xdp_frame *xdpf,
> > +			   struct xdp_frame_bulk *bq)
> > +{
> > +	struct xdp_mem_info *mem =3D &xdpf->mem;
> > +	struct xdp_mem_allocator *xa;
> > +
> > +	if (mem->type !=3D MEM_TYPE_PAGE_POOL) {
> > +		__xdp_return(xdpf->data, &xdpf->mem, false);
> > +		return;
> > +	}
> > +
> > +	rcu_read_lock();
> > +
> > +	xa =3D bq->xa;
> > +	if (unlikely(!xa)) {
> > +		xa =3D rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
> > +		bq->count =3D 0;
> > +		bq->xa =3D xa;
> > +	}
> > +
> > +	if (bq->count =3D=3D XDP_BULK_QUEUE_SIZE)
> > +		xdp_flush_frame_bulk(bq);
> > +
> > +	if (mem->id !=3D xa->mem.id) {
> > +		xdp_flush_frame_bulk(bq);
> > +		bq->xa =3D rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
> > +	}
> > +
> > +	bq->q[bq->count++] =3D xdpf->data;
> > +
> > +	rcu_read_unlock();
> > +}
> > +EXPORT_SYMBOL_GPL(xdp_return_frame_bulk);
> > +
> >  void xdp_return_buff(struct xdp_buff *xdp)
> >  {
> >  	__xdp_return(xdp->data, &xdp->rxq->mem, true);
> > --=20
> > 2.26.2
> >=20
>=20
>=20
> Cheers
> /Ilias

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX5vNUwAKCRA6cBh0uS2t
rOg0AP9pBwNK7NMtva8Bh06OlVD04ffBRe6Y5LMbqca50IV7DwEA0kJ2O/Ci3Y3y
i6wnVNkq2QMyTNBbTCNZ5ofEsZlr4gQ=
=HAq8
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
