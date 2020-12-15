Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58B9F2DAA5B
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 10:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgLOJpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 04:45:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23930 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727750AbgLOJpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 04:45:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608025421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5DEf40TZBhJmDgffeKprAt1Jld/xfe5jp8dtrGkv+oI=;
        b=ZI9RGzWXF2CBufG9sdfFKBWkaAfpYsWhjPfr9hhhknjGhVTVh89eMcGUuPdTBpvprcL3oJ
        LU9e/rdNkRKJ4de9ONDoJhaiCSJm+AdoSVgQqY26XCapxDlRVfmIzaQcEPe2xDjkpIgqZw
        velzRTxy73K0EBs0UaSzHKh6on3SXN8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-2Wv7YS5cP-WmJ5I5cb1fug-1; Tue, 15 Dec 2020 04:43:36 -0500
X-MC-Unique: 2Wv7YS5cP-WmJ5I5cb1fug-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C15ED800D53;
        Tue, 15 Dec 2020 09:43:34 +0000 (UTC)
Received: from carbon (unknown [10.36.110.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 10E8B1E5;
        Tue, 15 Dec 2020 09:43:30 +0000 (UTC)
Date:   Tue, 15 Dec 2020 10:43:27 +0100
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
To:     Ivan Babrou <ivan@cloudflare.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@cloudflare.com,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH net-next] sfc: reduce the number of requested xdp ev
 queues
Message-ID: <20201215104327.2be76156@carbon>
In-Reply-To: <20201215012907.3062-1-ivan@cloudflare.com>
References: <20201215012907.3062-1-ivan@cloudflare.com>
Organization: Red Hat Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Dec 2020 17:29:06 -0800
Ivan Babrou <ivan@cloudflare.com> wrote:

> Without this change the driver tries to allocate too many queues,
> breaching the number of available msi-x interrupts on machines
> with many logical cpus and default adapter settings:
> 
> Insufficient resources for 12 XDP event queues (24 other channels, max 32)
> 
> Which in turn triggers EINVAL on XDP processing:
> 
> sfc 0000:86:00.0 ext0: XDP TX failed (-22)

I have a similar QA report with XDP_REDIRECT:
  sfc 0000:05:00.0 ens1f0np0: XDP redirect failed (-22)

Here we are back to the issue we discussed with ixgbe, that NIC / msi-x
interrupts hardware resources are not enough on machines with many
logical cpus.

After this fix, what will happen if (cpu >= efx->xdp_tx_queue_count) ?
(Copied efx_xdp_tx_buffers code below signature)

The question leads to, does this driver need a fallback mechanism when
HW resource or systems logical cpus exceed the one TX-queue per CPU
assumption?

 
> Signed-off-by: Ivan Babrou <ivan@cloudflare.com>
> ---
>  drivers/net/ethernet/sfc/efx_channels.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/efx_channels.c
> b/drivers/net/ethernet/sfc/efx_channels.c index
> a4a626e9cd9a..1bfeee283ea9 100644 ---
> a/drivers/net/ethernet/sfc/efx_channels.c +++
> b/drivers/net/ethernet/sfc/efx_channels.c @@ -17,6 +17,7 @@
>  #include "rx_common.h"
>  #include "nic.h"
>  #include "sriov.h"
> +#include "workarounds.h"
>  
>  /* This is the first interrupt mode to try out of:
>   * 0 => MSI-X
> @@ -137,6 +138,7 @@ static int efx_allocate_msix_channels(struct
> efx_nic *efx, {
>  	unsigned int n_channels = parallelism;
>  	int vec_count;
> +	int tx_per_ev;
>  	int n_xdp_tx;
>  	int n_xdp_ev;
>  
> @@ -149,9 +151,9 @@ static int efx_allocate_msix_channels(struct
> efx_nic *efx,
>  	 * multiple tx queues, assuming tx and ev queues are both
>  	 * maximum size.
>  	 */
> -
> +	tx_per_ev = EFX_MAX_EVQ_SIZE / EFX_TXQ_MAX_ENT(efx);
>  	n_xdp_tx = num_possible_cpus();
> -	n_xdp_ev = DIV_ROUND_UP(n_xdp_tx, EFX_MAX_TXQ_PER_CHANNEL);
> +	n_xdp_ev = DIV_ROUND_UP(n_xdp_tx, tx_per_ev);
>  
>  	vec_count = pci_msix_vec_count(efx->pci_dev);
>  	if (vec_count < 0)



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer


/* Transmit a packet from an XDP buffer
 *
 * Returns number of packets sent on success, error code otherwise.
 * Runs in NAPI context, either in our poll (for XDP TX) or a different NIC
 * (for XDP redirect).
 */
int efx_xdp_tx_buffers(struct efx_nic *efx, int n, struct xdp_frame **xdpfs,
		       bool flush)
{
	struct efx_tx_buffer *tx_buffer;
	struct efx_tx_queue *tx_queue;
	struct xdp_frame *xdpf;
	dma_addr_t dma_addr;
	unsigned int len;
	int space;
	int cpu;
	int i;

	cpu = raw_smp_processor_id();

	if (!efx->xdp_tx_queue_count ||
	    unlikely(cpu >= efx->xdp_tx_queue_count))
		return -EINVAL;

	tx_queue = efx->xdp_tx_queues[cpu];
	if (unlikely(!tx_queue))
		return -EINVAL;

	if (unlikely(n && !xdpfs))
		return -EINVAL;

	if (!n)
		return 0;

	/* Check for available space. We should never need multiple
	 * descriptors per frame.
	 */
	space = efx->txq_entries +
		tx_queue->read_count - tx_queue->insert_count;

	for (i = 0; i < n; i++) {
		xdpf = xdpfs[i];

		if (i >= space)
			break;

		/* We'll want a descriptor for this tx. */
		prefetchw(__efx_tx_queue_get_insert_buffer(tx_queue));

		len = xdpf->len;

		/* Map for DMA. */
		dma_addr = dma_map_single(&efx->pci_dev->dev,
					  xdpf->data, len,
					  DMA_TO_DEVICE);
		if (dma_mapping_error(&efx->pci_dev->dev, dma_addr))
			break;

		/*  Create descriptor and set up for unmapping DMA. */
		tx_buffer = efx_tx_map_chunk(tx_queue, dma_addr, len);
		tx_buffer->xdpf = xdpf;
		tx_buffer->flags = EFX_TX_BUF_XDP |
				   EFX_TX_BUF_MAP_SINGLE;
		tx_buffer->dma_offset = 0;
		tx_buffer->unmap_len = len;
		tx_queue->tx_packets++;
	}

	/* Pass mapped frames to hardware. */
	if (flush && i > 0)
		efx_nic_push_buffers(tx_queue);

	if (i == 0)
		return -EIO;

	efx_xdp_return_frames(n - i, xdpfs + i);

	return i;
}

