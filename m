Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9A02D842A
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 04:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438028AbgLLDhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 22:37:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:59064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407008AbgLLDhL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 22:37:11 -0500
Date:   Fri, 11 Dec 2020 19:36:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607744190;
        bh=Bpyoin4kSevlRQ+ZKbW0MDlP4lfIWSpJBcCY7G6yx/8=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=jBwawvEmo6f6de6WGI6zI1PCURFoNo9htrPcwYRyfAiB6susRS5RuXRr/7PEyhiuj
         levhFESQI5rTrgy7LpOojk8/x9MGcUihabtGKQiuIkFjGel2EGVrMffUdET4WC6QXS
         BfBabOnEFdEb/jbQjVRuIhfhNBke/lilF7tWrw8o3Wf7TTMX3J1Q35VUsOBbOfqoEm
         R33n0DdTcEzgk8z63cuV6IJk5xmAPR5ItX2JHAS/+tOkmyj11vNAJj7GRe+oZCfs2d
         10q/xcQi87WWZKYPyaRbGzJWTp2teHi5v9oM2akJUwSWGkZ6Lpl9R4gHP9hfzuFenn
         DHorJK/Mj5TDg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ivan Babrou <ivan@cloudflare.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next] sfc: backport XDP EV queue sharing from the
 out-of-tree driver
Message-ID: <20201211193629.7c7860a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CABWYdi0+PRk8h-Az=b3GqNDO=m6RZgqDL27tgwo3yMK_05OLAw@mail.gmail.com>
References: <CABWYdi0+PRk8h-Az=b3GqNDO=m6RZgqDL27tgwo3yMK_05OLAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Dec 2020 16:18:53 -0800 Ivan Babrou wrote:
> Queue sharing behaviour already exists in the out-of-tree sfc driver,
> available under xdp_alloc_tx_resources module parameter.
> 
> This avoids the following issue on machines with many cpus:
> 
> Insufficient resources for 12 XDP event queues (24 other channels, max 32)
> 
> Which in turn triggers EINVAL on XDP processing:
> 
> sfc 0000:86:00.0 ext0: XDP TX failed (-22)
> 
> Signed-off-by: Ivan Babrou <ivan@cloudflare.com>

Please drop the references to the out-of-tree driver, the source of the
idea is not that relevant, what matters is the motivation and trade
offs.

Your patch got mangled by your email client, please try sending it with
git send-email.

> diff --git a/drivers/net/ethernet/sfc/efx_channels.c
> b/drivers/net/ethernet/sfc/efx_channels.c
> index a4a626e9cd9a..1bfeee283ea9 100644
> --- a/drivers/net/ethernet/sfc/efx_channels.c
> +++ b/drivers/net/ethernet/sfc/efx_channels.c
> @@ -17,6 +17,7 @@
>  #include "rx_common.h"
>  #include "nic.h"
>  #include "sriov.h"
> +#include "workarounds.h"
> 
>  /* This is the first interrupt mode to try out of:
>   * 0 => MSI-X
> @@ -137,6 +138,7 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
>  {
>   unsigned int n_channels = parallelism;
>   int vec_count;
> + int tx_per_ev;
>   int n_xdp_tx;
>   int n_xdp_ev;
> 
> @@ -149,9 +151,9 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
>   * multiple tx queues, assuming tx and ev queues are both
>   * maximum size.
>   */
> -
> + tx_per_ev = EFX_MAX_EVQ_SIZE / EFX_TXQ_MAX_ENT(efx);
>   n_xdp_tx = num_possible_cpus();
> - n_xdp_ev = DIV_ROUND_UP(n_xdp_tx, EFX_MAX_TXQ_PER_CHANNEL);
> + n_xdp_ev = DIV_ROUND_UP(n_xdp_tx, tx_per_ev);
> 
>   vec_count = pci_msix_vec_count(efx->pci_dev);
>   if (vec_count < 0)
> --
> 2.29.2

