Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF3ECD2618
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 11:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387783AbfJJJSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 05:18:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733144AbfJJJSd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 05:18:33 -0400
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15F502067B;
        Thu, 10 Oct 2019 09:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570699112;
        bh=A47oZj/pbuZ6MgCP4PraUx/9AD8nkqqyaVmA3XFn5So=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Im8uU19dOu4DDS0/DEVzU/INb+gdkoeR+CC4dBKbf+vUjk+Jy4Pn+lQ6H7KveWTN0
         NOylkde3VbJsB9ffAn/OkpuWLLbYfWZQRMC5XRyd/zx+jR0hs7yBpozqlrMj0tqQ2F
         uHoJaTN0A+vH4CbyflJIZjG09web9Yye4fmSBgRA=
Date:   Thu, 10 Oct 2019 11:18:15 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, matteo.croce@redhat.com,
        mw@semihalf.com
Subject: Re: [PATCH v2 net-next 4/8] net: mvneta: sync dma buffers before
 refilling hw queues
Message-ID: <20191010091815.GA3784@localhost.localdomain>
References: <cover.1570662004.git.lorenzo@kernel.org>
 <744e01ea2c93200765ba8a77f0e6b0ca6baca513.1570662004.git.lorenzo@kernel.org>
 <20191010090831.5d6c41f2@carbon>
 <20191010072157.GA31883@apalos.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
In-Reply-To: <20191010072157.GA31883@apalos.home>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Hi Lorenzo, Jesper,
>=20
> On Thu, Oct 10, 2019 at 09:08:31AM +0200, Jesper Dangaard Brouer wrote:
> > On Thu, 10 Oct 2019 01:18:34 +0200
> > Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> >=20
> > > mvneta driver can run on not cache coherent devices so it is
> > > necessary to sync dma buffers before sending them to the device
> > > in order to avoid memory corruption. This patch introduce a performan=
ce
> > > penalty and it is necessary to introduce a more sophisticated logic
> > > in order to avoid dma sync as much as we can
> >=20
> > Report with benchmarks here:
> >  https://github.com/xdp-project/xdp-project/blob/master/areas/arm64/boa=
rd_espressobin08_bench_xdp.org
> >=20
> > We are testing this on an Espressobin board, and do see a huge
> > performance cost associated with this DMA-sync.   Regardless we still
> > want to get this patch merged, to move forward with XDP support for
> > this driver.=20
> >=20
> > We promised each-other (on IRC freenode #xdp) that we will follow-up
> > with a solution/mitigation, after this patchset is merged.  There are
> > several ideas, that likely should get separate upstream review.
>=20
> I think mentioning that the patch *introduces* a performance penalty is a=
 bit
> misleading.=20
> The dma sync does have a performance penalty but it was always there.=20
> The initial driver was mapping the DMA with DMA_FROM_DEVICE, which implies
> syncing as well. In page_pool we do not explicitly sync buffers on alloca=
tion
> and leave it up the driver writer (and allow him some tricks to avoid tha=
t),
> thus this patch is needed.

Reviewing the commit log I definitely agree, I will rewrite it in v3. Thx

Regards,
Lorenzo

>=20
> In any case what Jesper mentions is correct, we do have a plan :)
>=20
> >=20
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> >=20
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> >=20
> > > ---
> > >  drivers/net/ethernet/marvell/mvneta.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > >=20
> > > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethe=
rnet/marvell/mvneta.c
> > > index 79a6bac0192b..ba4aa9bbc798 100644
> > > --- a/drivers/net/ethernet/marvell/mvneta.c
> > > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > > @@ -1821,6 +1821,7 @@ static int mvneta_rx_refill(struct mvneta_port =
*pp,
> > >  			    struct mvneta_rx_queue *rxq,
> > >  			    gfp_t gfp_mask)
> > >  {
> > > +	enum dma_data_direction dma_dir;
> > >  	dma_addr_t phys_addr;
> > >  	struct page *page;
> > > =20
> > > @@ -1830,6 +1831,9 @@ static int mvneta_rx_refill(struct mvneta_port =
*pp,
> > >  		return -ENOMEM;
> > > =20
> > >  	phys_addr =3D page_pool_get_dma_addr(page) + pp->rx_offset_correcti=
on;
> > > +	dma_dir =3D page_pool_get_dma_dir(rxq->page_pool);
> > > +	dma_sync_single_for_device(pp->dev->dev.parent, phys_addr,
> > > +				   MVNETA_MAX_RX_BUF_SIZE, dma_dir);
> > >  	mvneta_rx_desc_fill(rx_desc, phys_addr, page, rxq);
> > > =20
> > >  	return 0;
> >=20
> >=20
> >=20
> > --=20
> > Best regards,
> >   Jesper Dangaard Brouer
> >   MSc.CS, Principal Kernel Engineer at Red Hat
> >   LinkedIn: http://www.linkedin.com/in/brouer
>=20
> Thanks!
> /Ilias

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXZ73VAAKCRA6cBh0uS2t
rJ3nAPwPkIk7MO9quTfVjCmiPl1yLTAIlPgzGvsQaNLUfKyy3wD+KRgKVAEJma87
9+T327m4z9oYwt5LnMuo/tXlwd++/AM=
=ULjS
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
