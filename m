Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C11F8149C47
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 19:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbgAZS1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 13:27:31 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52592 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725838AbgAZS1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 13:27:31 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ivmd5-0003L4-HJ; Sun, 26 Jan 2020 18:27:27 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ivmd5-001lmm-4S; Sun, 26 Jan 2020 18:27:27 +0000
Message-ID: <169b94304e57c246a0af2f61b98079451ff9a3c4.camel@decadent.org.uk>
Subject: Re: [PATCH stable v4.4 1/2] net: stmmac: use correct DMA buffer
 size in the RX descriptor
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Aviraj CJ <acj@cisco.com>, peppe.cavallaro@st.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        xe-linux-external@cisco.com
Date:   Sun, 26 Jan 2020 18:27:21 +0000
In-Reply-To: <20191217055228.57282-1-acj@cisco.com>
References: <20191217055228.57282-1-acj@cisco.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-5DqiiUrpoJZ2fjCLngq0"
User-Agent: Evolution 3.34.1-2+b1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-5DqiiUrpoJZ2fjCLngq0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2019-12-16 at 21:52 -0800, Aviraj CJ wrote:
> upstream 583e6361414903c5206258a30e5bd88cb03c0254 commit
>=20
> We always program the maximum DMA buffer size into the receive descriptor=
,
> although the allocated size may be less. E.g. with the default MTU size
> we allocate only 1536 bytes. If somebody sends us a bigger frame, then
> memory may get corrupted.
>=20
> Program DMA using exact buffer sizes.
>=20
> Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> [acj: backport to v4.4 -stable :
> - Modified patch since v4.4 driver has no support for Big endian
> - Skipped the section modifying non-existent functions in dwmac4_descs.c =
and
> dwxgmac2_descs.c ]
> Signed-off-by: Aviraj CJ <acj@cisco.com>

I've queued up these two fixes for 3.16.  This first patch needed a
little more adjustment as I had previously backported commit
8137b6ef0ce4 "net: stmmac: Fix RX packet size > 8191".  Perhaps that
should also be applied to 4.4?

Ben.

> ---
>  drivers/net/ethernet/stmicro/stmmac/common.h      |  2 +-
>  drivers/net/ethernet/stmicro/stmmac/descs_com.h   | 14 ++++++++++----
>  drivers/net/ethernet/stmicro/stmmac/enh_desc.c    | 10 +++++++---
>  drivers/net/ethernet/stmicro/stmmac/norm_desc.c   | 10 +++++++---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  4 ++--
>  5 files changed, 27 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/e=
thernet/stmicro/stmmac/common.h
> index 623c6ed8764a..803df6a32ba9 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/common.h
> +++ b/drivers/net/ethernet/stmicro/stmmac/common.h
> @@ -301,7 +301,7 @@ struct dma_features {
>  struct stmmac_desc_ops {
>  	/* DMA RX descriptor ring initialization */
>  	void (*init_rx_desc) (struct dma_desc *p, int disable_rx_ic, int mode,
> -			      int end);
> +			      int end, int bfsize);
>  	/* DMA TX descriptor ring initialization */
>  	void (*init_tx_desc) (struct dma_desc *p, int mode, int end);
> =20
> diff --git a/drivers/net/ethernet/stmicro/stmmac/descs_com.h b/drivers/ne=
t/ethernet/stmicro/stmmac/descs_com.h
> index 6f2cc78c5cf5..6b83fc8e6fbe 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/descs_com.h
> +++ b/drivers/net/ethernet/stmicro/stmmac/descs_com.h
> @@ -33,9 +33,10 @@
>  /* Specific functions used for Ring mode */
> =20
>  /* Enhanced descriptors */
> -static inline void ehn_desc_rx_set_on_ring(struct dma_desc *p, int end)
> +static inline void ehn_desc_rx_set_on_ring(struct dma_desc *p, int end, =
int bfsize)
>  {
> -	p->des01.erx.buffer2_size =3D BUF_SIZE_8KiB - 1;
> +	if (bfsize =3D=3D BUF_SIZE_16KiB)
> +		p->des01.erx.buffer2_size =3D BUF_SIZE_8KiB - 1;
>  	if (end)
>  		p->des01.erx.end_ring =3D 1;
>  }
> @@ -61,9 +62,14 @@ static inline void enh_set_tx_desc_len_on_ring(struct =
dma_desc *p, int len)
>  }
> =20
>  /* Normal descriptors */
> -static inline void ndesc_rx_set_on_ring(struct dma_desc *p, int end)
> +static inline void ndesc_rx_set_on_ring(struct dma_desc *p, int end, int=
 bfsize)
>  {
> -	p->des01.rx.buffer2_size =3D BUF_SIZE_2KiB - 1;
> +	int size;
> +
> +	if (bfsize >=3D BUF_SIZE_2KiB) {
> +		size =3D min(bfsize - BUF_SIZE_2KiB + 1, BUF_SIZE_2KiB - 1);
> +		p->des01.rx.buffer2_size =3D size;
> +	}
>  	if (end)
>  		p->des01.rx.end_ring =3D 1;
>  }
> diff --git a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c b/drivers/net=
/ethernet/stmicro/stmmac/enh_desc.c
> index 7d944449f5ef..9ecb3a948f86 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
> @@ -238,16 +238,20 @@ static int enh_desc_get_rx_status(void *data, struc=
t stmmac_extra_stats *x,
>  }
> =20
>  static void enh_desc_init_rx_desc(struct dma_desc *p, int disable_rx_ic,
> -				  int mode, int end)
> +				  int mode, int end, int bfsize)
>  {
> +	int bfsize1;
> +
>  	p->des01.all_flags =3D 0;
>  	p->des01.erx.own =3D 1;
> -	p->des01.erx.buffer1_size =3D BUF_SIZE_8KiB - 1;
> +
> +	bfsize1 =3D min(bfsize, BUF_SIZE_8KiB - 1);
> +	p->des01.erx.buffer1_size =3D bfsize1;
> =20
>  	if (mode =3D=3D STMMAC_CHAIN_MODE)
>  		ehn_desc_rx_set_on_chain(p, end);
>  	else
> -		ehn_desc_rx_set_on_ring(p, end);
> +		ehn_desc_rx_set_on_ring(p, end, bfsize);
> =20
>  	if (disable_rx_ic)
>  		p->des01.erx.disable_ic =3D 1;
> diff --git a/drivers/net/ethernet/stmicro/stmmac/norm_desc.c b/drivers/ne=
t/ethernet/stmicro/stmmac/norm_desc.c
> index 48c3456445b2..07e0c03cfb10 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
> @@ -121,16 +121,20 @@ static int ndesc_get_rx_status(void *data, struct s=
tmmac_extra_stats *x,
>  }
> =20
>  static void ndesc_init_rx_desc(struct dma_desc *p, int disable_rx_ic, in=
t mode,
> -			       int end)
> +			       int end, int bfsize)
>  {
> +	int bfsize1;
> +
>  	p->des01.all_flags =3D 0;
>  	p->des01.rx.own =3D 1;
> -	p->des01.rx.buffer1_size =3D BUF_SIZE_2KiB - 1;
> +
> +	bfsize1 =3D min(bfsize, (BUF_SIZE_2KiB - 1));
> +	p->des01.rx.buffer1_size =3D bfsize1;
> =20
>  	if (mode =3D=3D STMMAC_CHAIN_MODE)
>  		ndesc_rx_set_on_chain(p, end);
>  	else
> -		ndesc_rx_set_on_ring(p, end);
> +		ndesc_rx_set_on_ring(p, end, bfsize);
> =20
>  	if (disable_rx_ic)
>  		p->des01.rx.disable_ic =3D 1;
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/=
net/ethernet/stmicro/stmmac/stmmac_main.c
> index f4d6512f066c..e9d41e03121c 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -964,11 +964,11 @@ static void stmmac_clear_descriptors(struct stmmac_=
priv *priv)
>  		if (priv->extend_desc)
>  			priv->hw->desc->init_rx_desc(&priv->dma_erx[i].basic,
>  						     priv->use_riwt, priv->mode,
> -						     (i =3D=3D rxsize - 1));
> +						     (i =3D=3D rxsize - 1), priv->dma_buf_sz);
>  		else
>  			priv->hw->desc->init_rx_desc(&priv->dma_rx[i],
>  						     priv->use_riwt, priv->mode,
> -						     (i =3D=3D rxsize - 1));
> +						     (i =3D=3D rxsize - 1), priv->dma_buf_sz);
>  	for (i =3D 0; i < txsize; i++)
>  		if (priv->extend_desc)
>  			priv->hw->desc->init_tx_desc(&priv->dma_etx[i].basic,
--=20
Ben Hutchings
The program is absolutely right; therefore, the computer must be wrong.


--=-5DqiiUrpoJZ2fjCLngq0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl4t2gkACgkQ57/I7JWG
EQl09Q//dTUioQJ2+b34uTS7ENp9GiJHzed8pdKL9Hftyt6onvvbdyMdQf1mNbOS
sKR7TAeXKbvYPSevEsI9C93TtViUerxFW8PNbShzXHgFv3nctAK12380X497Zjj4
jAHSkAGp81ut5a52PmFYfLq3/He2x4e4H8KPzVurMiD3WSBIka7VfSZEMaaMuRtq
wXImABvIULlZU5Rl0QrrtkY+KsgPqMvn3xUxSQkveE0AMcZ9XlxWpsW07zytgBFT
3cOGdFP7zQg6nD0Q8CPsB/M4rx2Yy3XehrSl0uaRVI17V8jVzf/dVIPgKEqH9M6Y
KntERh88BM9eVFL9c4V3Xs4glVykh2+WLXEKVmWfLxGLRucQI/47Q715a9IcRAcA
6ooIMZSL6OFBs7b8ZsM5TFdnhaYjQt0KjJui9m+h25T2DN3BsziPGiXJ4/5mNJUg
JMgE4tGI2KZ1ftsuIDImYhH/fPEBxbCf+qLu2DXJRStB6SouV2bmjIhvjk12cF8C
cMdKK5cjf5Zypc4ObAzzZXpDS1Xa2UasW2atRgdesn0hkI1AjXaX2w+Ohy0/iZ2O
yIO4HqwGGuoH1bpt2GK48isttjwQDi2doQxUFF0otG9FbSfk/GRGe+fs+bMQP10y
FpXGyrj8Bjg2dQCQQMhWnoR2AoX8DGUZQH9ZuyBt3/N9JtDX7lM=
=U3qG
-----END PGP SIGNATURE-----

--=-5DqiiUrpoJZ2fjCLngq0--
