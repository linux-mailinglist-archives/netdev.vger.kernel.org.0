Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77A30D2625
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 11:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387914AbfJJJUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 05:20:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387478AbfJJJUh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 05:20:37 -0400
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE4DE21D7B;
        Thu, 10 Oct 2019 09:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570699236;
        bh=7sVIwoHJnmZPTcgrOIJ3/YrIrbYQ/yRq1VqtNGaeX4o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r84+txB3NAkjqmxgWCEBFr4d8ME7o8XcFhzv3dkXq3PzEFRcrWxPTnbWdj/A4cZXv
         cMxWWB2HBRMc3A5yoJwV7n0Yi88G93Mf+sgFOhJd4C/ruvEADnWjU3vKF01sFTGTFe
         0NAfGBtX37QubyE3mbdb3OUUtYS2IE+ESHVj29V8=
Date:   Thu, 10 Oct 2019 11:20:04 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        ilias.apalodimas@linaro.org, matteo.croce@redhat.com,
        mw@semihalf.com
Subject: Re: [PATCH v2 net-next 4/8] net: mvneta: sync dma buffers before
 refilling hw queues
Message-ID: <20191010092004.GB3784@localhost.localdomain>
References: <cover.1570662004.git.lorenzo@kernel.org>
 <744e01ea2c93200765ba8a77f0e6b0ca6baca513.1570662004.git.lorenzo@kernel.org>
 <20191010090831.5d6c41f2@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="0ntfKIWw70PvrIHh"
Content-Disposition: inline
In-Reply-To: <20191010090831.5d6c41f2@carbon>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--0ntfKIWw70PvrIHh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu, 10 Oct 2019 01:18:34 +0200
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>=20
> > mvneta driver can run on not cache coherent devices so it is
> > necessary to sync dma buffers before sending them to the device
> > in order to avoid memory corruption. This patch introduce a performance
> > penalty and it is necessary to introduce a more sophisticated logic
> > in order to avoid dma sync as much as we can
>=20
> Report with benchmarks here:
>  https://github.com/xdp-project/xdp-project/blob/master/areas/arm64/board=
_espressobin08_bench_xdp.org

Thx a lot Jesper for detailed report, I will include this info in the commi=
t log.

Regards,
Lorenzo

>=20
> We are testing this on an Espressobin board, and do see a huge
> performance cost associated with this DMA-sync.   Regardless we still
> want to get this patch merged, to move forward with XDP support for
> this driver.=20
>=20
> We promised each-other (on IRC freenode #xdp) that we will follow-up
> with a solution/mitigation, after this patchset is merged.  There are
> several ideas, that likely should get separate upstream review.
>=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>=20
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>=20
> > ---
> >  drivers/net/ethernet/marvell/mvneta.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >=20
> > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethern=
et/marvell/mvneta.c
> > index 79a6bac0192b..ba4aa9bbc798 100644
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > @@ -1821,6 +1821,7 @@ static int mvneta_rx_refill(struct mvneta_port *p=
p,
> >  			    struct mvneta_rx_queue *rxq,
> >  			    gfp_t gfp_mask)
> >  {
> > +	enum dma_data_direction dma_dir;
> >  	dma_addr_t phys_addr;
> >  	struct page *page;
> > =20
> > @@ -1830,6 +1831,9 @@ static int mvneta_rx_refill(struct mvneta_port *p=
p,
> >  		return -ENOMEM;
> > =20
> >  	phys_addr =3D page_pool_get_dma_addr(page) + pp->rx_offset_correction;
> > +	dma_dir =3D page_pool_get_dma_dir(rxq->page_pool);
> > +	dma_sync_single_for_device(pp->dev->dev.parent, phys_addr,
> > +				   MVNETA_MAX_RX_BUF_SIZE, dma_dir);
> >  	mvneta_rx_desc_fill(rx_desc, phys_addr, page, rxq);
> > =20
> >  	return 0;
>=20
>=20
>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer

--0ntfKIWw70PvrIHh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXZ73wgAKCRA6cBh0uS2t
rL3qAQC1qsa1z2ea1HOoNocZ72fFfOOWVEsm9sgcrXB9CyqXvgEA5TJnFfy30M4M
TCTcRjhk60c1Yzcn/vJnNQsjFiJRJQU=
=F+yR
-----END PGP SIGNATURE-----

--0ntfKIWw70PvrIHh--
