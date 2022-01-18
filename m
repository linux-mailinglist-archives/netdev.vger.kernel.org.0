Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF8E491F37
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 07:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239953AbiARGBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 01:01:33 -0500
Received: from hmm.wantstofly.org ([213.239.204.108]:54506 "EHLO
        mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239857AbiARGBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 01:01:32 -0500
Received: by mail.wantstofly.org (Postfix, from userid 1000)
        id F28647F078; Tue, 18 Jan 2022 08:01:30 +0200 (EET)
Date:   Tue, 18 Jan 2022 08:01:30 +0200
From:   Lennert Buytenhek <buytenh@wantstofly.org>
To:     Corinna Vinschen <vinschen@redhat.com>
Cc:     intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: Re: [PATCH 3/3 net-next v5] igb/igc: RX queues: fix DMA leak in
 error case
Message-ID: <YeZXuoRa/39zzoEY@wantstofly.org>
References: <20220117182915.1283151-1-vinschen@redhat.com>
 <20220117182915.1283151-4-vinschen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220117182915.1283151-4-vinschen@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 17, 2022 at 07:29:15PM +0100, Corinna Vinschen wrote:

> When setting up the rx queues, igb and igc neglect to free DMA memory
> in error case.  Add matching dma_free_coherent calls.
> 
> Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 1 +
>  drivers/net/ethernet/intel/igc/igc_main.c | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index cea89d301bfd..343568d4ff7f 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -4389,6 +4389,7 @@ int igb_setup_rx_resources(struct igb_ring *rx_ring)
>  	return 0;
>  
>  err:
> +	dma_free_coherent(dev, rx_ring->size, rx_ring->desc, rx_ring->dma);
>  	vfree(rx_ring->rx_buffer_info);
>  	rx_ring->rx_buffer_info = NULL;
>  	dev_err(dev, "Unable to allocate memory for the Rx descriptor ring\n");
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index 56ed0f1463e5..f323cec0b74f 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -540,6 +540,7 @@ int igc_setup_rx_resources(struct igc_ring *rx_ring)
>  	return 0;
>  
>  err:
> +	dma_free_coherent(dev, rx_ring->size, rx_ring->desc, rx_ring->dma);
>  	vfree(rx_ring->rx_buffer_info);
>  	rx_ring->rx_buffer_info = NULL;
>  	netdev_err(ndev, "Unable to allocate memory for Rx descriptor ring\n");

If the vzalloc() call in igc_setup_rx_resources() fails, and we jump
to 'err' before dma_alloc_coherent() was reached, won't dma_free_coherent()
be called inadvertently here?
