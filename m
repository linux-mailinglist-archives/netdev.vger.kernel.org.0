Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 970B6E9ADC
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 12:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfJ3LeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 07:34:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24683 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726065AbfJ3LeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 07:34:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572435256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iYqPtmtVuORRd78w7wOm8MNZw4AO7262LQ25jsWgirg=;
        b=bEaJu0Vs4t+M7LFqJp1uDCiPifGof46ydT3QV7VJoYU09jHlzZNdRdBpKJ99xtOI7C593w
        BtbRImZXumKgBj8jajVwDJE01U63iHKDaw3Z9YpeDAuc2NnY+JvYFszgM1WPcv99R0nUYk
        xV/fUQkPFsq5s9orBa9r362266NqcJY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-2fEkVjaHNB6BBljxlQ1ZgA-1; Wed, 30 Oct 2019 07:34:12 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF4CE107ACC0;
        Wed, 30 Oct 2019 11:34:11 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB97A5D6D4;
        Wed, 30 Oct 2019 11:34:07 +0000 (UTC)
Date:   Wed, 30 Oct 2019 12:34:06 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Charles McLachlan <cmclachlan@solarflare.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-net-drivers@solarflare.com>, brouer@redhat.com
Subject: Re: [PATCH net-next v3 5/6] sfc: handle XDP_TX outcomes of XDP eBPF
 programs
Message-ID: <20191030123406.762a51d3@carbon>
In-Reply-To: <40f6e6c0-843a-e43b-a136-8ec1979a32e3@solarflare.com>
References: <515c107e-cecb-869a-6c84-1f3c1bd3afce@solarflare.com>
        <40f6e6c0-843a-e43b-a136-8ec1979a32e3@solarflare.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: 2fEkVjaHNB6BBljxlQ1ZgA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Oct 2019 10:52:04 +0000
Charles McLachlan <cmclachlan@solarflare.com> wrote:

> +/* Transmit a packet from an XDP buffer
> + *
> + * Returns number of packets sent on success, error code otherwise.
> + * Runs in NAPI context, either in our poll (for XDP TX) or a different =
NIC
> + * (for XDP redirect).
> + */
> +int efx_xdp_tx_buffers(struct efx_nic *efx, int n, struct xdp_frame **xd=
pfs,
> +=09=09       bool flush)
> +{
> +=09struct efx_tx_buffer *tx_buffer;
> +=09struct efx_tx_queue *tx_queue;
> +=09struct xdp_frame *xdpf;
> +=09dma_addr_t dma_addr;
> +=09unsigned int len;
> +=09int space;
> +=09int cpu;
> +=09int i;
> +
> +=09cpu =3D raw_smp_processor_id();
> +
> +=09if (!efx->xdp_tx_queue_count ||
> +=09    unlikely(cpu >=3D efx->xdp_tx_queue_count))
> +=09=09return -EINVAL;
> +
> +=09tx_queue =3D efx->xdp_tx_queues[cpu];
> +=09if (unlikely(!tx_queue))
> +=09=09return -EINVAL;
> +

If you return a negative value, then it is the caller responsibility
to free *all* the xdp_frame's, e.g. see bq_xmit_all() in devmap.c.

BUT if you start to process packets, and return a positive value, then
this function MUST handle freeing the frames it couldn't send.

> +=09if (n && xdpfs) {
> +=09=09/* Check for available space. We should never need multiple
> +=09=09 * descriptors per frame.
> +=09=09 */
> +=09=09space =3D efx->txq_entries +
> +=09=09=09tx_queue->read_count - tx_queue->insert_count;
> +=09=09n =3D min(n, space);

This looks broken.  In case 'space' is too small, there will be
xdp_frame's left in xdpfs[] that was not send.  As desc above, this
function have to free those.


> +=09=09for (i =3D 0; i < n; i++) {
> +=09=09=09xdpf =3D xdpfs[i];
> +
> +=09=09=09/* We'll want a descriptor for this tx. */
> +=09=09=09prefetchw(__efx_tx_queue_get_insert_buffer(tx_queue));
> +
> +=09=09=09len =3D xdpf->len;
> +
> +=09=09=09/* Map for DMA. */
> +=09=09=09dma_addr =3D dma_map_single(&efx->pci_dev->dev,
> +=09=09=09=09=09=09  xdpf->data, len,
> +=09=09=09=09=09=09  DMA_TO_DEVICE);
> +=09=09=09if (dma_mapping_error(&efx->pci_dev->dev, dma_addr))
> +=09=09=09=09return -EIO;
> +
> +=09=09=09/*  Create descriptor and set up for unmapping DMA. */
> +=09=09=09tx_buffer =3D efx_tx_map_chunk(tx_queue, dma_addr, len);
> +=09=09=09tx_buffer->xdpf =3D xdpf;
> +=09=09=09tx_buffer->flags =3D EFX_TX_BUF_XDP |
> +=09=09=09=09=09   EFX_TX_BUF_MAP_SINGLE;
> +=09=09=09tx_buffer->dma_offset =3D 0;
> +=09=09=09tx_buffer->unmap_len =3D len;
> +=09=09}
> +=09}
> +
> +=09/* Pass to hardware. */
> +=09if (flush)
> +=09=09efx_nic_push_buffers(tx_queue);
> +
> +=09tx_queue->tx_packets +=3D n;
> +
> +=09return n;
> +}
> +


--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

