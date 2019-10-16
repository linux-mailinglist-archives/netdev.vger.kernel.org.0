Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD6C6D9042
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 14:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732396AbfJPMAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 08:00:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726372AbfJPMAa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 08:00:30 -0400
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 044A620854;
        Wed, 16 Oct 2019 12:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571227229;
        bh=EaLF60NqvvwudTWjnaqkNZUbdFH7w7RYYULlUS2IiqM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=glxBkLl5rt++BX6R8Ell1f6hh0qkJLx02RlszFCYiFEpLz8/PhrE9Xq6tRHT7r2tg
         QQ4b8n+B6tlskhCqV81ziqQYTWJb3oAnmf03W1oqgkqA4XRF1Tq1JWX0TzsS5waIOR
         hwKwOfvnGxPLPuOgRN7EKnX6B3SqS3z5J/yN6QYU=
Date:   Wed, 16 Oct 2019 14:00:23 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        matteo.croce@redhat.com, mw@semihalf.com
Subject: Re: [PATCH v3 net-next 8/8] net: mvneta: add XDP_TX support
Message-ID: <20191016120023.GF2638@localhost.localdomain>
References: <cover.1571049326.git.lorenzo@kernel.org>
 <a964f1a704f194169e80f9693cf3150adffc1278.1571049326.git.lorenzo@kernel.org>
 <20191015171152.41d9a747@cakuba.netronome.com>
 <20191016100900.GE2638@localhost.localdomain>
 <20191016105506.GA19689@apalos.home>
 <20191016131638.7b489b1e@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="B0nZA57HJSoPbsHY"
Content-Disposition: inline
In-Reply-To: <20191016131638.7b489b1e@carbon>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--B0nZA57HJSoPbsHY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Wed, 16 Oct 2019 13:55:06 +0300
> Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:
>=20
> > On Wed, Oct 16, 2019 at 12:09:00PM +0200, Lorenzo Bianconi wrote:
> > > > On Mon, 14 Oct 2019 12:49:55 +0200, Lorenzo Bianconi wrote: =20
> > > > > Implement XDP_TX verdict and ndo_xdp_xmit net_device_ops function
> > > > > pointer
> > > > >=20
> > > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org> =20
> > > >  =20
> > > > > @@ -1972,6 +1975,109 @@ int mvneta_rx_refill_queue(struct mvneta_=
port *pp, struct mvneta_rx_queue *rxq)
> > > > >  	return i;
> > > > >  }
> > > > > =20
> > > > > +static int
> > > > > +mvneta_xdp_submit_frame(struct mvneta_port *pp, struct mvneta_tx=
_queue *txq,
> > > > > +			struct xdp_frame *xdpf, bool dma_map)
> > > > > +{
> > > > > +	struct mvneta_tx_desc *tx_desc;
> > > > > +	struct mvneta_tx_buf *buf;
> > > > > +	dma_addr_t dma_addr;
> > > > > +
> > > > > +	if (txq->count >=3D txq->tx_stop_threshold)
> > > > > +		return MVNETA_XDP_CONSUMED;
> > > > > +
> > > > > +	tx_desc =3D mvneta_txq_next_desc_get(txq);
> > > > > +
> > > > > +	buf =3D &txq->buf[txq->txq_put_index];
> > > > > +	if (dma_map) {
> > > > > +		/* ndo_xdp_xmit */
> > > > > +		dma_addr =3D dma_map_single(pp->dev->dev.parent, xdpf->data,
> > > > > +					  xdpf->len, DMA_TO_DEVICE);
> > > > > +		if (dma_mapping_error(pp->dev->dev.parent, dma_addr)) {
> > > > > +			mvneta_txq_desc_put(txq);
> > > > > +			return MVNETA_XDP_CONSUMED;
> > > > > +		}
> > > > > +		buf->type =3D MVNETA_TYPE_XDP_NDO;
> > > > > +	} else {
> > > > > +		struct page *page =3D virt_to_page(xdpf->data);
> > > > > +
> > > > > +		dma_addr =3D page_pool_get_dma_addr(page) +
> > > > > +			   pp->rx_offset_correction + MVNETA_MH_SIZE;
> > > > > +		dma_sync_single_for_device(pp->dev->dev.parent, dma_addr,
> > > > > +					   xdpf->len, DMA_BIDIRECTIONAL); =20
> > > >=20
> > > > This looks a little suspicious, XDP could have moved the start of f=
rame
> > > > with adjust_head, right? You should also use xdpf->data to find whe=
re
> > > > the frame starts, no? =20
> > >=20
> > > uhm, right..we need to update the dma_addr doing something like:
> > >=20
> > > dma_addr =3D page_pool_get_dma_addr(page) + xdpf->data - xdpf; =20
> >=20
> > Can we do  page_pool_get_dma_addr(page) + xdpf->headroom as well right?
>=20
> We actually have to do:
>  page_pool_get_dma_addr(page) + xdpf->headroom + sizeof(struct xdp_frame)
>=20
> As part of part of headroom was reserved to xdpf.  I've considered
> several times to change xdpf->headroom to include sizeof(struct xdp_frame)
> as use-cases (e.g. in veth and cpumap) ended needing the "full" headroom.

correct, I will add it in v4. Thx.

Regards,
Lorenzo

>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer

--B0nZA57HJSoPbsHY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXacGVQAKCRA6cBh0uS2t
rKN4AQDTMuew98K8eY0SZlO/qB/qTOwzYSlL6qDHH1yTuhpvSAD/VumYNuZEdy64
xqqeYROjqsmwuQItSzyFroTATi4MpA8=
=d4Rw
-----END PGP SIGNATURE-----

--B0nZA57HJSoPbsHY--
