Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72F56E2CBB
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 10:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387888AbfJXI5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 04:57:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:40942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727079AbfJXI5s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 04:57:48 -0400
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A391320684;
        Thu, 24 Oct 2019 08:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571907467;
        bh=BTjr1t8fwFjOffdX8X6seEXqc/YhqXcaeGnwIltXBCs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P5YVo+tjFBL9EadMv5DGXk+gWlFsjGzZiJPQ8yl1PHoUUhyGtBviOCs+rRJABvnio
         RJ/QYdTeqF5Qa0agkS5pYRj4GkrDqQbPnFhQf1HOcVYC9OPzOxj5Ibo31N6xUpTRwa
         hcxwObmfhCHQd+cI7tFx0U8OPxQpAGXgxGsOef/w=
Date:   Thu, 24 Oct 2019 10:57:41 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        sgruszka@redhat.com, lorenzo.bianconi@redhat.com,
        oleksandr@natalenko.name, netdev@vger.kernel.org
Subject: Re: [PATCH wireless-drivers 2/2] mt76: dma: fix buffer unmap with
 non-linear skbs
Message-ID: <20191024085741.GB9346@localhost.localdomain>
References: <cover.1571868221.git.lorenzo@kernel.org>
 <1f7560e10edd517bfd9d3c0dd9820e6f420726b6.1571868221.git.lorenzo@kernel.org>
 <d1cf048c-3541-091e-7237-14199ddc89bc@nbd.name>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="61jdw2sOBCFtR2d/"
Content-Disposition: inline
In-Reply-To: <d1cf048c-3541-091e-7237-14199ddc89bc@nbd.name>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--61jdw2sOBCFtR2d/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Oct 24, Felix Fietkau wrote:
> On 2019-10-24 00:23, Lorenzo Bianconi wrote:
> > mt76 dma layer is supposed to unmap skb data buffers while keep txwi
> > mapped on hw dma ring. At the moment mt76 wrongly unmap txwi or does
> > not unmap data fragments in even positions for non-linear skbs. This
> > issue may result in hw hangs with A-MSDU if the system relies on IOMMU
> > or SWIOTLB. Fix this behaviour properly unmapping data fragments on
> > non-linear skbs.
> >=20
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
> It seems to me that these conditions could be true not just for the
> first entry, but also following entries except for the last one.
> I think we should add a 'bool has_txwi' field in struct mt76_queue_entry
> to indicate that the first dma address points to a txwi that should not
> be unmapped.

I agree 'first' is misleading since this condition is used to unamp even the
very last data fragment if we have an even number of data fragments
(e.g linear area + one fragment). For the following entries except for the =
last
one 'first' is false since e->skb is NULL (e->skb is not NULL just for the =
very
last entry), right? Btw we can remove mcu bool.
In order to improve code readability I agree to add a bool in mt76_queue_en=
try to
unmap buf0. I will fix it in v2.

Regards,
Lorenzo

>=20
> - Felix

--61jdw2sOBCFtR2d/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXbFngAAKCRA6cBh0uS2t
rIOMAP4kXYaGXu6TyfeMHj4m9Sph4eULmVOtlmKWnY/rG9ZzPgD+Ig0ULFYk70p2
x/mfRJzltLsK/Ek+dmCvDDUBYf58FAQ=
=VoWZ
-----END PGP SIGNATURE-----

--61jdw2sOBCFtR2d/--
