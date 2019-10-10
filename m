Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE3ED26D6
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 11:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387734AbfJJJ60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 05:58:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387637AbfJJJ60 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 05:58:26 -0400
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 821D52054F;
        Thu, 10 Oct 2019 09:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570701505;
        bh=YMkN8MKyomXnrechr1SBvBjnXgYt24Nq5aOTRDMvUGU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Oww99Jc7FIhbC1uYMurYAU72ioUUwgUzdBdEL45Kat1Hcf6e9v1NB5kOlZ5oteGfj
         T2qQG3CAEfRGjFgdz9zGEPbEhOPPRQIkiC9plS8lDO5M4IY9aHq2npk8Uz+EVMO2eh
         XfLQk4GPi2FM4auxH2Rqfc2SUmAtoftaAOC/C8l8=
Date:   Thu, 10 Oct 2019 11:58:19 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        brouer@redhat.com, matteo.croce@redhat.com, mw@semihalf.com
Subject: Re: [PATCH v2 net-next 3/8] net: mvneta: rely on build_skb in
 mvneta_rx_swbm poll routine
Message-ID: <20191010095819.GD3784@localhost.localdomain>
References: <cover.1570662004.git.lorenzo@kernel.org>
 <e9ad915633d1e7e02d4b9021761d325d4b130101.1570662004.git.lorenzo@kernel.org>
 <20191010071652.GA31160@apalos.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="LKTjZJSUETSlgu2t"
Content-Disposition: inline
In-Reply-To: <20191010071652.GA31160@apalos.home>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--LKTjZJSUETSlgu2t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Hi Lorenzo,=20
>=20
> On Thu, Oct 10, 2019 at 01:18:33AM +0200, Lorenzo Bianconi wrote:
> > Refactor mvneta_rx_swbm code introducing mvneta_swbm_rx_frame and
> > mvneta_swbm_add_rx_fragment routines. Rely on build_skb in oreder to
> > allocate skb since the previous patch introduced buffer recycling using
> > the page_pool API.
> > This patch fixes even an issue in the original driver where dma buffers
> > are accessed before dma sync
> >=20
> > Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/ethernet/marvell/mvneta.c | 198 ++++++++++++++------------
> >  1 file changed, 104 insertions(+), 94 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethern=
et/marvell/mvneta.c
> > index 31cecc1ed848..79a6bac0192b 100644
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > @@ -323,6 +323,11 @@
> >  	      ETH_HLEN + ETH_FCS_LEN,			     \
> >  	      cache_line_size())
> > =20
> > +#define MVNETA_SKB_PAD	(SKB_DATA_ALIGN(sizeof(struct skb_shared_info) =
+ \
> > +			 NET_SKB_PAD))
> > +#define MVNETA_SKB_SIZE(len)	(SKB_DATA_ALIGN(len) + MVNETA_SKB_PAD)
> > +#define MVNETA_MAX_RX_BUF_SIZE	(PAGE_SIZE - MVNETA_SKB_PAD)
> > +
> >  #define IS_TSO_HEADER(txq, addr) \
> >  	((addr >=3D txq->tso_hdrs_phys) && \
> >  	 (addr < txq->tso_hdrs_phys + txq->size * TSO_HEADER_SIZE))
> > @@ -646,7 +651,6 @@ static int txq_number =3D 8;
> >  static int rxq_def;
> > =20
> >  static int rx_copybreak __read_mostly =3D 256;
> > -static int rx_header_size __read_mostly =3D 128;
> > =20
> >  /* HW BM need that each port be identify by a unique ID */
> >  static int global_port_id;
> > +	if (rxq->left_size > MVNETA_MAX_RX_BUF_SIZE) {
>=20
> [...]
>=20
> > +		len =3D MVNETA_MAX_RX_BUF_SIZE;
> > +		data_len =3D len;
> > +	} else {
> > +		len =3D rxq->left_size;
> > +		data_len =3D len - ETH_FCS_LEN;
> > +	}
> > +	dma_dir =3D page_pool_get_dma_dir(rxq->page_pool);
> > +	dma_sync_single_range_for_cpu(dev->dev.parent,
> > +				      rx_desc->buf_phys_addr, 0,
> > +				      len, dma_dir);
> > +	if (data_len > 0) {
> > +		/* refill descriptor with new buffer later */
> > +		skb_add_rx_frag(rxq->skb,
> > +				skb_shinfo(rxq->skb)->nr_frags,
> > +				page, NET_SKB_PAD, data_len,
> > +				PAGE_SIZE);
> > +
> > +		page_pool_release_page(rxq->page_pool, page);
> > +		rx_desc->buf_phys_addr =3D 0;
>=20
> Shouldn't we unmap and set the buf_phys_addr to 0 regardless of the data_=
len?

ack, right. I will fix it in v3.

Regards,
Lorenzo

>=20
> > +	}
> > +	rxq->left_size -=3D len;
> > +}
> > +
> >  		mvneta_rxq_buf_size_set(pp, rxq, PAGE_SIZE < SZ_64K ?
>=20
> [...]
>=20
> > -					PAGE_SIZE :
> > +					MVNETA_MAX_RX_BUF_SIZE :
> >  					MVNETA_RX_BUF_SIZE(pp->pkt_size));
> >  		mvneta_rxq_bm_disable(pp, rxq);
> >  		mvneta_rxq_fill(pp, rxq, rxq->size);
> > @@ -4656,7 +4666,7 @@ static int mvneta_probe(struct platform_device *p=
dev)
> >  	SET_NETDEV_DEV(dev, &pdev->dev);
> > =20
> >  	pp->id =3D global_port_id++;
> > -	pp->rx_offset_correction =3D 0; /* not relevant for SW BM */
> > +	pp->rx_offset_correction =3D NET_SKB_PAD;
> > =20
> >  	/* Obtain access to BM resources if enabled and already initialized */
> >  	bm_node =3D of_parse_phandle(dn, "buffer-manager", 0);
> > --=20
> > 2.21.0
> >=20
>=20
> Regards
> /Ilias

--LKTjZJSUETSlgu2t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXZ8AuAAKCRA6cBh0uS2t
rExoAP0YCrOZWOZoVGlwrXNi+fbu/SHF+Lms4y8xPqsOxZbp4QEAn/GiD64MLr2D
HCrDJTu1loHrjoqz6fGzn4CGRcmWKw0=
=2S70
-----END PGP SIGNATURE-----

--LKTjZJSUETSlgu2t--
