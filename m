Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDA5FE2CC1
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 11:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388036AbfJXJBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 05:01:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727079AbfJXJBy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 05:01:54 -0400
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B740120856;
        Thu, 24 Oct 2019 09:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571907713;
        bh=37iuuaGpSmraY0pA/lBQbaIYjNaOnB//MJRR10tlGlg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WsYd/vXeUwGgRpVKkKMB3UTUOugINmUCmt2cIG6og3xSmeYIrEmJsw3QG8yaFNRMi
         7pcoeqAIa7nI8dhQ/WyxVBaGMCSf1W/w39q7gaFHsLnv4U4gIIYKc+EsN2UND+5Fei
         au6SML7ioSVxbWJZFH1odvzNnDd9NYyN5l9+L9Uo=
Date:   Thu, 24 Oct 2019 11:01:48 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     kvalo@codeaurora.org, linux-wireless@vger.kernel.org, nbd@nbd.name,
        lorenzo.bianconi@redhat.com, oleksandr@natalenko.name,
        netdev@vger.kernel.org
Subject: Re: [PATCH wireless-drivers 2/2] mt76: dma: fix buffer unmap with
 non-linear skbs
Message-ID: <20191024090148.GC9346@localhost.localdomain>
References: <cover.1571868221.git.lorenzo@kernel.org>
 <1f7560e10edd517bfd9d3c0dd9820e6f420726b6.1571868221.git.lorenzo@kernel.org>
 <20191024081816.GA2440@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="S1BNGpv0yoYahz37"
Content-Disposition: inline
In-Reply-To: <20191024081816.GA2440@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--S1BNGpv0yoYahz37
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu, Oct 24, 2019 at 12:23:16AM +0200, Lorenzo Bianconi wrote:
> > mt76 dma layer is supposed to unmap skb data buffers while keep txwi
> > mapped on hw dma ring. At the moment mt76 wrongly unmap txwi or does
> > not unmap data fragments in even positions for non-linear skbs. This
> > issue may result in hw hangs with A-MSDU if the system relies on IOMMU
> > or SWIOTLB. Fix this behaviour properly unmapping data fragments on
> > non-linear skbs.
>=20
> If we have to keep txwi mapped, before unmap fragments, when then
> txwi is unmaped ?

txwi are mapped when they are crated in mt76_alloc_txwi(). Whenever we need=
 to
modify them we sync the DMA in mt76_dma_tx_queue_skb(). txwi are unmapped in
mt76_tx_free() at driver unload.

Regards,
Lorenzo

>=20
> Stanislaw
>=20
> > Fixes: 17f1de56df05 ("mt76: add common code shared between multiple chi=
psets")
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/wireless/mediatek/mt76/dma.c | 10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wir=
eless/mediatek/mt76/dma.c
> > index c747eb24581c..8c27956875e7 100644
> > --- a/drivers/net/wireless/mediatek/mt76/dma.c
> > +++ b/drivers/net/wireless/mediatek/mt76/dma.c
> > @@ -93,11 +93,14 @@ static void
> >  mt76_dma_tx_cleanup_idx(struct mt76_dev *dev, struct mt76_queue *q, in=
t idx,
> >  			struct mt76_queue_entry *prev_e)
> >  {
> > -	struct mt76_queue_entry *e =3D &q->entry[idx];
> >  	__le32 __ctrl =3D READ_ONCE(q->desc[idx].ctrl);
> > +	struct mt76_queue_entry *e =3D &q->entry[idx];
> >  	u32 ctrl =3D le32_to_cpu(__ctrl);
> > +	bool mcu =3D e->skb && !e->txwi;
> > +	bool first =3D e->skb =3D=3D DMA_DUMMY_DATA || e->txwi =3D=3D DMA_DUM=
MY_DATA ||
> > +		     (e->skb && !skb_is_nonlinear(e->skb));
> > =20
> > -	if (!e->txwi || !e->skb) {
> > +	if (!first || mcu) {
> >  		__le32 addr =3D READ_ONCE(q->desc[idx].buf0);
> >  		u32 len =3D FIELD_GET(MT_DMA_CTL_SD_LEN0, ctrl);
> > =20
> > @@ -105,7 +108,8 @@ mt76_dma_tx_cleanup_idx(struct mt76_dev *dev, struc=
t mt76_queue *q, int idx,
> >  				 DMA_TO_DEVICE);
> >  	}
> > =20
> > -	if (!(ctrl & MT_DMA_CTL_LAST_SEC0)) {
> > +	if (!(ctrl & MT_DMA_CTL_LAST_SEC0) ||
> > +	    e->txwi =3D=3D DMA_DUMMY_DATA) {
> >  		__le32 addr =3D READ_ONCE(q->desc[idx].buf1);
> >  		u32 len =3D FIELD_GET(MT_DMA_CTL_SD_LEN1, ctrl);
> > =20
> > --=20
> > 2.21.0
> >=20
>=20

--S1BNGpv0yoYahz37
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXbFoeQAKCRA6cBh0uS2t
rAfIAQCKXW+QaHwFSGNhLoEhG13ebnxRYqwqcGerYQkBKs7z2QEA0NHlfRKfi1KU
hyVS0QnEWEh+SMgUeS3fVzeLjXCdHgU=
=T+m5
-----END PGP SIGNATURE-----

--S1BNGpv0yoYahz37--
