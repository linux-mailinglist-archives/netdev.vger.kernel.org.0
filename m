Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFED7E0E1C
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 00:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387571AbfJVWTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 18:19:34 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:57147 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730331AbfJVWTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 18:19:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571782772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=My9DwfKfi8IGLIxBBHjX/j2LOHDsw3kgVZcrwGUE6m8=;
        b=a1czTjmMxx1/gGij/S4PM77nA18oMNGCv4tTuHn4/cghF4HZCXl9oWEz6AWbSVFDC5w6eD
        Z2U5wk2767SFr70m20RnW6QrZQARn6NPuaq+Ml9dYQgaaULIEK23jyp6dQqQGB48qBXNYn
        /6A/FYTivFt/PO/Cr4SXfyIxEe89NS8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-bIszvY-8P9mKktFNTDLz9A-1; Tue, 22 Oct 2019 18:19:29 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 294DA80183E;
        Tue, 22 Oct 2019 22:19:28 +0000 (UTC)
Received: from carbon (ovpn-200-21.brq.redhat.com [10.40.200.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 008A05D6A9;
        Tue, 22 Oct 2019 22:19:20 +0000 (UTC)
Date:   Wed, 23 Oct 2019 00:19:17 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Charles McLachlan <cmclachlan@solarflare.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-net-drivers@solarflare.com>, brouer@redhat.com
Subject: Re: [PATCH net-next 1/6] sfc: support encapsulation of xdp_frames
 in efx_tx_buffer.
Message-ID: <20191023001917.59f51f52@carbon>
In-Reply-To: <7eca8299-a6bf-5d47-1815-4d2cfa87c070@solarflare.com>
References: <05b72fdb-165c-1350-787b-ca8c5261c459@solarflare.com>
        <7eca8299-a6bf-5d47-1815-4d2cfa87c070@solarflare.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: bIszvY-8P9mKktFNTDLz9A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Oct 2019 16:37:53 +0100
Charles McLachlan <cmclachlan@solarflare.com> wrote:

> Add a field to efx_tx_buffer so that we can track xdp_frames. Add a
> flag so that buffers that contain xdp_frames can be identified and
> passed to xdp_return_frame.
>=20
> Signed-off-by: Charles McLachlan <cmclachlan@solarflare.com>
> ---
>  drivers/net/ethernet/sfc/net_driver.h | 10 ++++++++--
>  drivers/net/ethernet/sfc/tx.c         |  2 ++
>  2 files changed, 10 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet=
/sfc/net_driver.h
> index 284a1b047ac2..7394d901e021 100644
> --- a/drivers/net/ethernet/sfc/net_driver.h
> +++ b/drivers/net/ethernet/sfc/net_driver.h
> @@ -27,6 +27,7 @@
>  #include <linux/i2c.h>
>  #include <linux/mtd/mtd.h>
>  #include <net/busy_poll.h>
> +#include <net/xdp.h>
> =20
>  #include "enum.h"
>  #include "bitfield.h"
> @@ -136,7 +137,8 @@ struct efx_special_buffer {
>   * struct efx_tx_buffer - buffer state for a TX descriptor
>   * @skb: When @flags & %EFX_TX_BUF_SKB, the associated socket buffer to =
be
>   *=09freed when descriptor completes
> - * @option: When @flags & %EFX_TX_BUF_OPTION, a NIC-specific option desc=
riptor.
> + * @xdpf: When @flags & %EFX_TX_BUF_XDP, the XDP frame information; its =
@data
> + *=09member is the associated buffer to drop a page reference on.
>   * @dma_addr: DMA address of the fragment.
>   * @flags: Flags for allocation and DMA mapping type
>   * @len: Length of this fragment.
> @@ -146,7 +148,10 @@ struct efx_special_buffer {
>   * Only valid if @unmap_len !=3D 0.
>   */
>  struct efx_tx_buffer {
> -=09const struct sk_buff *skb;
> +=09union {
> +=09=09const struct sk_buff *skb;
> +=09=09struct xdp_frame *xdpf;
> +=09};
>  =09union {
>  =09=09efx_qword_t option;
>  =09=09dma_addr_t dma_addr;
> @@ -160,6 +165,7 @@ struct efx_tx_buffer {
>  #define EFX_TX_BUF_SKB=09=092=09/* buffer is last part of skb */
>  #define EFX_TX_BUF_MAP_SINGLE=098=09/* buffer was mapped with dma_map_si=
ngle() */
>  #define EFX_TX_BUF_OPTION=090x10=09/* empty buffer for option descriptor=
 */
> +#define EFX_TX_BUF_XDP=09=090x20=09/* buffer was sent with XDP */
> =20
>  /**
>   * struct efx_tx_queue - An Efx TX queue
> diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.=
c
> index 65e81ec1b314..9905e8952a45 100644
> --- a/drivers/net/ethernet/sfc/tx.c
> +++ b/drivers/net/ethernet/sfc/tx.c
> @@ -95,6 +95,8 @@ static void efx_dequeue_buffer(struct efx_tx_queue *tx_=
queue,
>  =09=09netif_vdbg(tx_queue->efx, tx_done, tx_queue->efx->net_dev,
>  =09=09=09   "TX queue %d transmission id %x complete\n",
>  =09=09=09   tx_queue->queue, tx_queue->read_count);
> +=09} else if (buffer->flags & EFX_TX_BUF_XDP) {
> +=09=09xdp_return_frame(buffer->xdpf);

Is this efx_dequeue_buffer() function always called under NAPI protection?
(So it could use the faster xdp_return_frame_rx_napi() ... ?)


>  =09}
> =20
>  =09buffer->len =3D 0;



--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

