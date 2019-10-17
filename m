Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80584DA8F7
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 11:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405802AbfJQJo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 05:44:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728022AbfJQJo4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 05:44:56 -0400
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 199FD20663;
        Thu, 17 Oct 2019 09:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571305496;
        bh=3C9SShNr4MVvEoON7YeeNsfCVuYnbAYxOaVtcbNiRWk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MVtvZl7FZ91zBnRCQlyTBDPTntVkiWzulqjfvkwnwEHC3QTyiP0zT3d1bDyHpWmqE
         OYbSDUddEDGJmu4z76VNgj87mfkH5JchnfAm4KyzC4MZqgUOkcREgJzmkSBWV02Tsq
         2J1T8yvzoYVoO2O4fOduAfJvQ5lcn6fsVDbohGuY=
Date:   Thu, 17 Oct 2019 11:44:50 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        brouer@redhat.com, ilias.apalodimas@linaro.org,
        matteo.croce@redhat.com, mw@semihalf.com
Subject: Re: [PATCH v4 net-next 7/7] net: mvneta: add XDP_TX support
Message-ID: <20191017094450.GB2861@localhost.localdomain>
References: <cover.1571258792.git.lorenzo@kernel.org>
 <41267f6501185d6bcf0bc9a883b77e83d5c1f533.1571258793.git.lorenzo@kernel.org>
 <20191016182849.27d130db@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="RASg3xLB4tUQ4RcS"
Content-Disposition: inline
In-Reply-To: <20191016182849.27d130db@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--RASg3xLB4tUQ4RcS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Wed, 16 Oct 2019 23:03:12 +0200, Lorenzo Bianconi wrote:
> > Implement XDP_TX verdict and ndo_xdp_xmit net_device_ops function
> > pointer
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>=20
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
> > +		return MVNETA_XDP_DROPPED;
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
> > +			return MVNETA_XDP_DROPPED;
> > +		}
> > +		buf->type =3D MVNETA_TYPE_XDP_NDO;
> > +	} else {
> > +		struct page *page =3D virt_to_page(xdpf->data);
> > +
> > +		dma_addr =3D page_pool_get_dma_addr(page) +
> > +			   xdpf->headroom + sizeof(*xdpf);
>=20
> nit:
>=20
>  sizeof(*xdpf) + xdpf->headroom
>=20
> order would be slightly preferable since it matches field ordering in
> memory.

ack, agree. Will do in v5.

Regards,
Lorenzo

>=20
> > +		dma_sync_single_for_device(pp->dev->dev.parent, dma_addr,
> > +					   xdpf->len, DMA_BIDIRECTIONAL);
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

--RASg3xLB4tUQ4RcS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXag4DgAKCRA6cBh0uS2t
rM4IAQDWab5ttliW9FzBp/fwPbyn+eRdhnaCS2MD5yan74dgVQD/RbSgV5+qg+fX
vS+Qb0DhJ4iC+BXUri8fZzoCiEgqfQo=
=bxSD
-----END PGP SIGNATURE-----

--RASg3xLB4tUQ4RcS--
