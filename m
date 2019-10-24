Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4A95E2BEC
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 10:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438078AbfJXIS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 04:18:29 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:31726 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726395AbfJXIS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 04:18:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571905108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iUU4XisJlicj+W2Ht8NrSYQhFK2TGjm36W78eDFsQYw=;
        b=TkXB0Hsz18VwuQhVSfUCQRAtZwj8LMYco6ztzA/DhHXxOkOQh/U3+VM07TeSFjYjKJKEnn
        dSeGpzehEgz1k+l0RSbGfz/s+q0LtCLprRkXANxMXdqEfX29ETXrcdzVPk6/PX5ZDXCKp1
        GZ2J34wJ5YwXBqgQlT/tN4HRKX6tsvY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-9zpOSi7ZMAaRh8uSwKlnsA-1; Thu, 24 Oct 2019 04:18:25 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44ACF107AD31;
        Thu, 24 Oct 2019 08:18:24 +0000 (UTC)
Received: from localhost (unknown [10.43.2.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 759715D9CA;
        Thu, 24 Oct 2019 08:18:18 +0000 (UTC)
Date:   Thu, 24 Oct 2019 10:18:16 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     kvalo@codeaurora.org, linux-wireless@vger.kernel.org, nbd@nbd.name,
        lorenzo.bianconi@redhat.com, oleksandr@natalenko.name,
        netdev@vger.kernel.org
Subject: Re: [PATCH wireless-drivers 2/2] mt76: dma: fix buffer unmap with
 non-linear skbs
Message-ID: <20191024081816.GA2440@redhat.com>
References: <cover.1571868221.git.lorenzo@kernel.org>
 <1f7560e10edd517bfd9d3c0dd9820e6f420726b6.1571868221.git.lorenzo@kernel.org>
MIME-Version: 1.0
In-Reply-To: <1f7560e10edd517bfd9d3c0dd9820e6f420726b6.1571868221.git.lorenzo@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: 9zpOSi7ZMAaRh8uSwKlnsA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 12:23:16AM +0200, Lorenzo Bianconi wrote:
> mt76 dma layer is supposed to unmap skb data buffers while keep txwi
> mapped on hw dma ring. At the moment mt76 wrongly unmap txwi or does
> not unmap data fragments in even positions for non-linear skbs. This
> issue may result in hw hangs with A-MSDU if the system relies on IOMMU
> or SWIOTLB. Fix this behaviour properly unmapping data fragments on
> non-linear skbs.

If we have to keep txwi mapped, before unmap fragments, when then
txwi is unmaped ?

Stanislaw

> Fixes: 17f1de56df05 ("mt76: add common code shared between multiple chips=
ets")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/wireless/mediatek/mt76/dma.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wirel=
ess/mediatek/mt76/dma.c
> index c747eb24581c..8c27956875e7 100644
> --- a/drivers/net/wireless/mediatek/mt76/dma.c
> +++ b/drivers/net/wireless/mediatek/mt76/dma.c
> @@ -93,11 +93,14 @@ static void
>  mt76_dma_tx_cleanup_idx(struct mt76_dev *dev, struct mt76_queue *q, int =
idx,
>  =09=09=09struct mt76_queue_entry *prev_e)
>  {
> -=09struct mt76_queue_entry *e =3D &q->entry[idx];
>  =09__le32 __ctrl =3D READ_ONCE(q->desc[idx].ctrl);
> +=09struct mt76_queue_entry *e =3D &q->entry[idx];
>  =09u32 ctrl =3D le32_to_cpu(__ctrl);
> +=09bool mcu =3D e->skb && !e->txwi;
> +=09bool first =3D e->skb =3D=3D DMA_DUMMY_DATA || e->txwi =3D=3D DMA_DUM=
MY_DATA ||
> +=09=09     (e->skb && !skb_is_nonlinear(e->skb));
> =20
> -=09if (!e->txwi || !e->skb) {
> +=09if (!first || mcu) {
>  =09=09__le32 addr =3D READ_ONCE(q->desc[idx].buf0);
>  =09=09u32 len =3D FIELD_GET(MT_DMA_CTL_SD_LEN0, ctrl);
> =20
> @@ -105,7 +108,8 @@ mt76_dma_tx_cleanup_idx(struct mt76_dev *dev, struct =
mt76_queue *q, int idx,
>  =09=09=09=09 DMA_TO_DEVICE);
>  =09}
> =20
> -=09if (!(ctrl & MT_DMA_CTL_LAST_SEC0)) {
> +=09if (!(ctrl & MT_DMA_CTL_LAST_SEC0) ||
> +=09    e->txwi =3D=3D DMA_DUMMY_DATA) {
>  =09=09__le32 addr =3D READ_ONCE(q->desc[idx].buf1);
>  =09=09u32 len =3D FIELD_GET(MT_DMA_CTL_SD_LEN1, ctrl);
> =20
> --=20
> 2.21.0
>=20

