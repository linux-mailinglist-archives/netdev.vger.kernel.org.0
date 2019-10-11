Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F358CD44D2
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 17:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbfJKP6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 11:58:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726521AbfJKP6y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 11:58:54 -0400
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2EAA2089F;
        Fri, 11 Oct 2019 15:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570809532;
        bh=2FWYvdOjdmfFSext+W1eoZjlye4e43we7zd/XIAmo7o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2hb4Ncw/BJVwhUlHmP73obUHHN9eLqQIq311h4L8r6jA8HFAxBv7CeiiVktt2Yamq
         cIvFgDENvqyQb5cW5zu7ufXT+j12hGCMAkJIQJtH57WXzjABupu22HoOitdkI9f7iY
         4xnM+6ESlVrzR2LaB4kXi8c7n/1J/v6NjcxOXNa0=
Date:   Fri, 11 Oct 2019 17:58:47 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH net] net: socionext: netsec: fix xdp stats accounting
Message-ID: <20191011155847.GA4220@localhost.localdomain>
References: <40c5519a86f2c611de84661a9d1e136bda2cd78e.1570801159.git.lorenzo@kernel.org>
 <20191011141503.GA11359@apalos.home>
 <20191011151628.GA12122@apalos.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <20191011151628.GA12122@apalos.home>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, Oct 11, 2019 at 05:15:03PM +0300, Ilias Apalodimas wrote:
> > Hi Lorenzo,=20
> >=20
> > On Fri, Oct 11, 2019 at 03:45:38PM +0200, Lorenzo Bianconi wrote:
> > > Increment netdev rx counters even for XDP_DROP verdict. Moreover repo=
rt
> > > even tx bytes for xdp buffers (TYPE_NETSEC_XDP_TX or
> > > TYPE_NETSEC_XDP_NDO)
> >=20
> > The RX counters work fine. The TX change is causing a panic though and =
i am
> > looking into it since your patch seems harmless. In any case please don=
't merge
> > this yet
> >=20
>=20
> Ok i think i know what's going on.=20
> Our clean TX routine has a netdev_completed_queue(). This is properly acc=
ounted
> for on netsec_netdev_start_xmit() which calls netdev_sent_queue().
>=20
> Since the XDP never had support for that you need to account for the extr=
a bytes
> in netsec_xdp_queue_one(). That's what triggering the BUG_ON=20
> (lib/dynamic_queue_limits.c line 27)=20

Hi Ilias,

yes, right. We need to account pending xdp buffer len on tx side.

>=20
> Since netdev_completed_queue() enforces barrier() and in some cases smp_m=
b() i
> think i'd prefer it per function, although it looks uglier.=20
> Can you send a patch with this call in netsec_xdp_queue_one()? If we cant
> measure any performance difference i am fine with adding it in that only.

If this introduce a performance penalty we can just account netdev tx_bytes
directly (maybe it is ugly)

Regards,
Lorenzo

>=20
> Thanks
> /Ilias
>=20
> > Thanks
> > /Ilias
> >=20
> > > Fixes: ba2b232108d3 ("net: netsec: add XDP support")
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > ---
> > > just compiled not tested on a real device
> > > ---
> > >  drivers/net/ethernet/socionext/netsec.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >=20
> > > diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/et=
hernet/socionext/netsec.c
> > > index f9e6744d8fd6..b1c2a79899b3 100644
> > > --- a/drivers/net/ethernet/socionext/netsec.c
> > > +++ b/drivers/net/ethernet/socionext/netsec.c
> > > @@ -252,7 +252,6 @@
> > >  #define NETSEC_XDP_CONSUMED      BIT(0)
> > >  #define NETSEC_XDP_TX            BIT(1)
> > >  #define NETSEC_XDP_REDIR         BIT(2)
> > > -#define NETSEC_XDP_RX_OK (NETSEC_XDP_PASS | NETSEC_XDP_TX | NETSEC_X=
DP_REDIR)
> > > =20
> > >  enum ring_id {
> > >  	NETSEC_RING_TX =3D 0,
> > > @@ -661,6 +660,7 @@ static bool netsec_clean_tx_dring(struct netsec_p=
riv *priv)
> > >  			bytes +=3D desc->skb->len;
> > >  			dev_kfree_skb(desc->skb);
> > >  		} else {
> > > +			bytes +=3D desc->xdpf->len;
> > >  			xdp_return_frame(desc->xdpf);
> > >  		}
> > >  next:
> > > @@ -1030,7 +1030,7 @@ static int netsec_process_rx(struct netsec_priv=
 *priv, int budget)
> > > =20
> > >  next:
> > >  		if ((skb && napi_gro_receive(&priv->napi, skb) !=3D GRO_DROP) ||
> > > -		    xdp_result & NETSEC_XDP_RX_OK) {
> > > +		    xdp_result) {
> > >  			ndev->stats.rx_packets++;
> > >  			ndev->stats.rx_bytes +=3D xdp.data_end - xdp.data;
> > >  		}
> > > --=20
> > > 2.21.0
> > >=20

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXaCmtQAKCRA6cBh0uS2t
rNDOAQDc0I2YYzxQZjcfuP/M1h7ECb/FzZddx7uRGs1/35b25QD5AXu0UyQNL4Xh
ZUkVmuGaXzp6+SP1w7X0JWg8oGujUQo=
=axVw
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
