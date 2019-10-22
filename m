Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D250E0E59
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 00:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732738AbfJVWpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 18:45:22 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59237 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731850AbfJVWpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 18:45:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571784320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xaYcQAnqa39ZWz6ewdQxce9WP2icr0d1H4tmcHP9WXg=;
        b=ZbUqwh8Ika4KM3cxoWQkT4proR7RrGB3Ja88xmd6m7lJnYeDUPO/4oxyXLTLNC6CIwgWeO
        xa0w9Z9lNwRnsxWfXCAUflnI17haFlmeuHL5UrIfsMtJGzfv5yL+am+l16ku1TCPIpbXuP
        yIAtcs9VWap0lIkFQhGW4nCRM5NuqwM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-0zXSX9PkNd6H9Osvy8pt5w-1; Tue, 22 Oct 2019 18:45:13 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D4F9801E52;
        Tue, 22 Oct 2019 22:45:12 +0000 (UTC)
Received: from carbon (ovpn-200-21.brq.redhat.com [10.40.200.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D298194BB;
        Tue, 22 Oct 2019 22:45:03 +0000 (UTC)
Date:   Wed, 23 Oct 2019 00:45:01 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Charles McLachlan <cmclachlan@solarflare.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-net-drivers@solarflare.com>, brouer@redhat.com
Subject: Re: [PATCH net-next 2/6] sfc: perform XDP processing on received
 packets.
Message-ID: <20191023004501.4a78c300@carbon>
In-Reply-To: <1c193147-d94a-111f-42d3-324c3e8b0282@solarflare.com>
References: <05b72fdb-165c-1350-787b-ca8c5261c459@solarflare.com>
        <1c193147-d94a-111f-42d3-324c3e8b0282@solarflare.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: 0zXSX9PkNd6H9Osvy8pt5w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Oct 2019 16:38:27 +0100
Charles McLachlan <cmclachlan@solarflare.com> wrote:

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
> +=09int rc;
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
> +=09=09rc =3D xdp_do_redirect(efx->net_dev, &xdp, xdp_prog);
> +=09=09if (rc) {

Can we call the 'rc' variable 'err' instead?
And give it an unlikely().


> +=09=09=09efx_free_rx_buffers(rx_queue, rx_buf, 1);
> +=09=09=09if (net_ratelimit())
> +=09=09=09=09netif_err(efx, rx_err, efx->net_dev,
> +=09=09=09=09=09  "XDP redirect failed (%d)\n", rc);
> +=09=09}
> +=09=09break;
> +
> +=09default:
> +=09=09bpf_warn_invalid_xdp_action(xdp_act);
> +=09=09/* Fall through */
> +=09case XDP_ABORTED:
> +=09=09efx_free_rx_buffers(rx_queue, rx_buf, 1);
> +=09=09break;
> +
> +=09case XDP_DROP:
> +=09=09efx_free_rx_buffers(rx_queue, rx_buf, 1);
> +=09=09break;
> +=09}
> +
> +=09return xdp_act =3D=3D XDP_PASS;
> +}
> +


--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

