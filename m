Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B96FC137755
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 20:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728824AbgAJTg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 14:36:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:49768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727709AbgAJTg6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 14:36:58 -0500
Received: from localhost.localdomain (mob-176-246-50-46.net.vodafone.it [176.246.50.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAAE7205F4;
        Fri, 10 Jan 2020 19:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578685017;
        bh=H7yWwy7jZIh/F+vloo1vHZSg3/SeqQch+QseF6TeZ7Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CJGs47Bc4jYBb68hYmt7tEVn9KMnfGNfS2q5xsdVwV39+EVRWXY/sW5FP7cUzu0ou
         MX9sSgV7o+hOcRmfU5Jkg5XTnSzhNLZHn4KphOJgcK7hGXc5Q5Ea0ahHBkP9Kxj+fD
         Zu7oTYf49jehmDb8TuKkGRFO865uqp59LwMU21SM=
Date:   Fri, 10 Jan 2020 20:36:51 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v2 net-next] net: socionext: get rid of huge dma sync in
 netsec_alloc_rx_data
Message-ID: <20200110193651.GA14384@localhost.localdomain>
References: <81eeb4aaf1cbbbdcd4f58c5a7f06bdab67f20633.1578664483.git.lorenzo@kernel.org>
 <20200110145631.GA69461@apalos.home>
 <20200110153413.GA31419@localhost.localdomain>
 <20200110183328.219ed2bd@carbon>
 <20200110181940.GB31419@localhost.localdomain>
 <20200110200156.041f063f@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <20200110200156.041f063f@carbon>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, 10 Jan 2020 19:19:40 +0100
> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:
>=20
> > > On Fri, 10 Jan 2020 16:34:13 +0100
> > > Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > >  =20
> > > > > On Fri, Jan 10, 2020 at 02:57:44PM +0100, Lorenzo Bianconi wrote:=
   =20
> > > > > > Socionext driver can run on dma coherent and non-coherent devic=
es.
> > > > > > Get rid of huge dma_sync_single_for_device in netsec_alloc_rx_d=
ata since
> > > > > > now the driver can let page_pool API to managed needed DMA sync
> > > > > >=20
> > > > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > > > ---
> > > > > > Changes since v1:
> > > > > > - rely on original frame size for dma sync
> > > > > > ---
> > > > > >  drivers/net/ethernet/socionext/netsec.c | 43 +++++++++++++++--=
--------
> > > > > >  1 file changed, 26 insertions(+), 17 deletions(-)
> > > > > >    =20
> > > >=20
> > > > [...]
> > > >  =20
> > > > > > @@ -883,6 +881,8 @@ static u32 netsec_xdp_xmit_back(struct nets=
ec_priv *priv, struct xdp_buff *xdp)
> > > > > >  static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf=
_prog *prog,
> > > > > >  			  struct xdp_buff *xdp)
> > > > > >  {
> > > > > > +	struct netsec_desc_ring *dring =3D &priv->desc_ring[NETSEC_RI=
NG_RX];
> > > > > > +	unsigned int len =3D xdp->data_end - xdp->data;   =20
> > > > >=20
> > > > > We need to account for XDP expanding the headers as well here.=20
> > > > > So something like max(xdp->data_end(before bpf), xdp->data_end(af=
ter bpf)) -
> > > > > xdp->data (original)   =20
> > > >=20
> > > > correct, the corner case that is not covered at the moment is when =
data_end is
> > > > moved forward by the bpf program. I will fix it in v3. Thx =20
> > >=20
> > > Maybe we can simplify do:
> > >=20
> > >  void *data_start =3D NETSEC_RXBUF_HEADROOM + xdp->data_hard_start;
> > >  unsigned int len =3D xdp->data_end - data_start;
> > >  =20
> >=20
> > Hi Jesper,
> >=20
> > please correct me if I am wrong but this seems to me the same as v2.
>=20
> No, this is v2, where you do:
>    len =3D xdp->data_end - xdp->data;

I mean in the solution you proposed you set (before running the bpf program=
):

len =3D xdp->data_end - data_start
where:
data_start =3D NETSEC_RXBUF_HEADROOM + xdp->data_hard_start

that is equivalent to what I did in v2 (before running the bpf program):
len =3D xdp->data_end - xdp->data

since:
xdp->data =3D xdp->data_hard_start + NETSEC_RXBUF_HEADROOM
(set in netsec_process_rx())

Am I missing something?

>=20
> Maybe you mean v1? where you calc len like:
>    len =3D xdp->data_end - xdp->data_hard_start;
>   =20
>=20
> > The leftover corner case is if xdp->data_end is moved 'forward' by
> > the bpf program (I guess it is possible, right?). In this case we
> > will not sync xdp->data_end(new) - xdp->data_end(old)
>=20
> Currently xdp->data_end can only shrink (but I plan to extend it). Yes,
> this corner case is left, but I don't think we need to handle it.  When
> a BPF prog shrink xdp->data_end, then i believe it cannot change that
> part the shunk part any longer.
>=20

ack, fine to me.

Regards,
Lorenzo

>=20
> >=20
> > > The cache-lines that need to be flushed/synced for_device is the area
> > > used by NIC DMA engine.  We know it will always start at a certain
> > > point (given driver configured hardware to this).
>=20
>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXhjSUAAKCRA6cBh0uS2t
rF8QAQCiqlvXDKsa0Uzij672FQ5I7HKbae2VMn//q+rsbI/DrwEAybFbDQ3sDmVM
vcuDf6YCYLMxAOKSnc5RYwMG5Ol3fg0=
=9J07
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
