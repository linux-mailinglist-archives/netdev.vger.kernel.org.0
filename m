Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF130E7654
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 17:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391034AbfJ1Qdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 12:33:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32400 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732987AbfJ1Qdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 12:33:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572280413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H+vpFdwjiqNzZ1sKl8TIfefL1/u3b4iPGY2awqm7MuU=;
        b=GTprHPO59iOQtSXBDf29XFjp2o+pXJHzBGy+i6/wbSezCZpYBYFQ4DSBAscMvDPeGl0iRd
        RNzND8MKxnLZwKdPgsr06GBuEK5MOcw0Jg+u+cGR/iwgnzEV70Gsc6tjNtB5RS0knhTHGj
        Qkd+f/c/EJt/Nz9IA65UfjZ/AK9CxLk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-rbmpyIfQNmSKWCwZ215gEw-1; Mon, 28 Oct 2019 12:33:28 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 768C9476;
        Mon, 28 Oct 2019 16:33:27 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37C5B5C1B2;
        Mon, 28 Oct 2019 16:33:22 +0000 (UTC)
Date:   Mon, 28 Oct 2019 17:33:21 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Charles McLachlan <cmclachlan@solarflare.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-net-drivers@solarflare.com>, brouer@redhat.com
Subject: Re: [PATCH net-next v2 2/6] sfc: perform XDP processing on received
 packets
Message-ID: <20191028173321.5254abf3@carbon>
In-Reply-To: <38a43fa5-5682-ffd9-f33e-5b7e04d50903@solarflare.com>
References: <74c15338-c13e-5b7b-9cc5-844cd9262be3@solarflare.com>
        <38a43fa5-5682-ffd9-f33e-5b7e04d50903@solarflare.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: rbmpyIfQNmSKWCwZ215gEw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Oct 2019 13:59:21 +0000
Charles McLachlan <cmclachlan@solarflare.com> wrote:

> diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.=
c
> index 85ec07f5a674..6fabb1925ff1 100644
> --- a/drivers/net/ethernet/sfc/rx.c
> +++ b/drivers/net/ethernet/sfc/rx.c
[...]
> @@ -635,6 +642,103 @@ static void efx_rx_deliver(struct efx_channel *chan=
nel, u8 *eh,
>  =09=09netif_receive_skb(skb);
>  }
> =20
> +/** efx_do_xdp: perform XDP processing on a received packet
> + *
> + * Returns true if packet should still be delivered.
> + */
> +static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
> +=09=09       struct efx_rx_buffer *rx_buf, u8 **ehp)
> +{
> +=09u8 rx_prefix[EFX_MAX_RX_PREFIX_SIZE];
> +=09struct efx_rx_queue *rx_queue;
> +=09struct bpf_prog *xdp_prog;
> +=09struct xdp_buff xdp;
> +=09u32 xdp_act;
> +=09s16 offset;
> +=09int err;
> +
> +=09rcu_read_lock();
> +=09xdp_prog =3D rcu_dereference(efx->xdp_prog);
> +=09if (!xdp_prog) {
> +=09=09rcu_read_unlock();
> +=09=09return true;
> +=09}
> +
> +=09rx_queue =3D efx_channel_get_rx_queue(channel);
> +
> +=09if (unlikely(channel->rx_pkt_n_frags > 1)) {
> +=09=09/* We can't do XDP on fragmented packets - drop. */
> +=09=09rcu_read_unlock();
> +=09=09efx_free_rx_buffers(rx_queue, rx_buf,
> +=09=09=09=09    channel->rx_pkt_n_frags);
> +=09=09if (net_ratelimit())
> +=09=09=09netif_err(efx, rx_err, efx->net_dev,
> +=09=09=09=09  "XDP is not possible with multiple receive fragments (%d)\=
n",
> +=09=09=09=09  channel->rx_pkt_n_frags);
> +=09=09return false;
> +=09}
> +
> +=09dma_sync_single_for_cpu(&efx->pci_dev->dev, rx_buf->dma_addr,
> +=09=09=09=09rx_buf->len, DMA_FROM_DEVICE);
> +
> +=09/* Save the rx prefix. */
> +=09EFX_WARN_ON_PARANOID(efx->rx_prefix_size > EFX_MAX_RX_PREFIX_SIZE);
> +=09memcpy(rx_prefix, *ehp - efx->rx_prefix_size,
> +=09       efx->rx_prefix_size);
> +
> +=09xdp.data =3D *ehp;
> +=09xdp.data_hard_start =3D xdp.data - XDP_PACKET_HEADROOM;
> +
> +=09/* No support yet for XDP metadata */
> +=09xdp_set_data_meta_invalid(&xdp);
> +=09xdp.data_end =3D xdp.data + rx_buf->len;
> +=09xdp.rxq =3D &rx_queue->xdp_rxq_info;

You can optimize this and only assign xdp_rxq_info once per NAPI.  E.g.
if you "allocate" struct xdp_buff on the callers stack, and pass it in
as a pointer.

> +
> +=09xdp_act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> +=09rcu_read_unlock();
> +
> +=09offset =3D (u8 *)xdp.data - *ehp;
> +
> +=09switch (xdp_act) {
> +=09case XDP_PASS:
> +=09=09/* Fix up rx prefix. */
> +=09=09if (offset) {
> +=09=09=09*ehp +=3D offset;
> +=09=09=09rx_buf->page_offset +=3D offset;
> +=09=09=09rx_buf->len -=3D offset;
> +=09=09=09memcpy(*ehp - efx->rx_prefix_size, rx_prefix,
> +=09=09=09       efx->rx_prefix_size);
> +=09=09}
> +=09=09break;
> +
> +=09case XDP_TX:
> +=09=09return -EOPNOTSUPP;
> +
> +=09case XDP_REDIRECT:
> +=09=09err =3D xdp_do_redirect(efx->net_dev, &xdp, xdp_prog);
> +=09=09if (unlikely(err)) {
> +=09=09=09efx_free_rx_buffers(rx_queue, rx_buf, 1);
> +=09=09=09if (net_ratelimit())
> +=09=09=09=09netif_err(efx, rx_err, efx->net_dev,
> +=09=09=09=09=09  "XDP redirect failed (%d)\n", err);
> +=09=09}
> +=09=09break;
> +
> +=09default:
> +=09=09bpf_warn_invalid_xdp_action(xdp_act);
> +=09=09/* Fall through */
> +=09case XDP_ABORTED:

You are missing a tracepoint to catch ABORTED, e.g:
  trace_xdp_exception(netdev, xdp_prog, xdp_act);

> +=09=09efx_free_rx_buffers(rx_queue, rx_buf, 1);
> +=09=09break;

You can do a /* Fall through */ to case XDP_DROP.

> +=09case XDP_DROP:
> +=09=09efx_free_rx_buffers(rx_queue, rx_buf, 1);
> +=09=09break;
> +=09}
> +
> +=09return xdp_act =3D=3D XDP_PASS;
> +}

You can verify/test tracepoint for ABORTED as described here:

 https://github.com/xdp-project/xdp-tutorial/tree/master/basic02-prog-by-na=
me#assignment-2-add-xdp_abort-program


Thanks for working on this!
--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

