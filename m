Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2DB22FF18A
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 18:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388442AbhAURNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 12:13:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45656 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388314AbhAURNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 12:13:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611249100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zpfe9pV1wDccOzvvQj2AB8KEGCkQf3RaJd2xe765gDc=;
        b=JyAAT15NXXJpLSwEMIvL2Npy1A1F5zYBt5A6M4TupvYuxGAF/lNBzq84Ph/rxi1mRUR8+R
        RpOgKNmmf1UE2vfVgusukD91dpqrAF8/pqez15E3nC9ONaWNOBsLNsmmNQd9Ed5PYTz4vb
        ys6GnvT/+DCNmVCmT9+7e6cIEsPmWiA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-glX1a6oRMK6Ogrp9MQn1ng-1; Thu, 21 Jan 2021 12:11:38 -0500
X-MC-Unique: glX1a6oRMK6Ogrp9MQn1ng-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B87C80A5D7;
        Thu, 21 Jan 2021 17:11:36 +0000 (UTC)
Received: from carbon (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 356AD5F9D7;
        Thu, 21 Jan 2021 17:11:32 +0000 (UTC)
Date:   Thu, 21 Jan 2021 18:11:30 +0100
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
Message-ID: <20210121181130.77c06723@carbon>
In-Reply-To: <20210120212759.81548-1-ivan@cloudflare.com>
References: <20210120212759.81548-1-ivan@cloudflare.com>
Organization: Red Hat Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 13:27:59 -0800
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
> 
> Signed-off-by: Ivan Babrou <ivan@cloudflare.com>
> ---

I guess the patch is good in itself due to available msi-x interrupts.

Per earlier discussion: What will happen if a CPU with an ID higher
than available XDP TX-queues redirect a packet out this driver?


>  drivers/net/ethernet/sfc/efx_channels.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
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
>  	unsigned int n_channels = parallelism;
>  	int vec_count;
> +	int tx_per_ev;
>  	int n_xdp_tx;
>  	int n_xdp_ev;
>  
> @@ -149,9 +151,9 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
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

