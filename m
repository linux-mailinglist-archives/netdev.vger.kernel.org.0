Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C438C4783EC
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 05:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbhLQETr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 23:19:47 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60162 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232622AbhLQETr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 23:19:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B675BB826F4;
        Fri, 17 Dec 2021 04:19:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A77C36AE1;
        Fri, 17 Dec 2021 04:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639714784;
        bh=x0hkHvk18e34yjLkRd7XIXuSC+n9Puz6Q2aRYGsQVRI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TFQtas4OZYGvTi5Bgwg0pv15S1Y1H59H0oIUE3UP3boXf9oLjsPfuIij/kytUrm+n
         luCfVwJcSCaSGoImKnlwl19zpl8sUta+vM1qNHxCBwvxNPbK6bZK6Lzj0sD0aupIU/
         Sf4w3DJEHI3eaWSErMRI7ounkoWH8h09wXFCf8YCllka7L8Oo/qldVard1JdkJMGf2
         IqPpamUVbcZ+GGsX8iGq+OyzB76NBT4gK1n0RCUIWePXZDSMVbHC8QoYOL6G27N9LF
         Ifcom4THUD5c6nZScRg2ip/eAlkqE/OUotwSkGI2joKvfr183ct2eik0ad9c6g0DoA
         4FfYwXzWr2fIw==
Date:   Thu, 16 Dec 2021 20:19:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] sfc: potential dereference of null pointer
Message-ID: <20211216201942.06e10166@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211216084902.329009-1-jiasheng@iscas.ac.cn>
References: <20211216084902.329009-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Dec 2021 16:49:02 +0800 Jiasheng Jiang wrote:
> [PATCH] sfc: potential dereference of null pointer

Please give the commit a more unique name.

> The return value of kcalloc() needs to be checked.
> To avoid dereference of null pointer in case of the failure of alloc,
> such as efx_fini_rx_recycle_ring().
> Therefore, it should be better to change the definition of page_ptr_mask
> to signed int and then assign the page_ptr_mask to -1 when page_ring is
> NULL, in order to avoid the use in the loop in
> efx_fini_rx_recycle_ring().

What about uses of this ring, you mention avoiding null-deref in the
freeing function but presumably something is actually using this ring
at runtime. Seems like we should return -ENOMEM.

> Fixes: 3d95b884392f ("sfc: move more rx code")

Moving buggy code does not introduce the problem, please find a Fixes
tag referring to where the bad code was _introduced_.

> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
>  drivers/net/ethernet/sfc/net_driver.h | 2 +-
>  drivers/net/ethernet/sfc/rx_common.c  | 5 ++++-
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
> index 9b4b25704271..beba3e0a6027 100644
> --- a/drivers/net/ethernet/sfc/net_driver.h
> +++ b/drivers/net/ethernet/sfc/net_driver.h
> @@ -407,7 +407,7 @@ struct efx_rx_queue {
>  	unsigned int page_recycle_count;
>  	unsigned int page_recycle_failed;
>  	unsigned int page_recycle_full;
> -	unsigned int page_ptr_mask;
> +	int page_ptr_mask;
>  	unsigned int max_fill;
>  	unsigned int fast_fill_trigger;
>  	unsigned int min_fill;
> diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
> index 68fc7d317693..d9d0a5805f1c 100644
> --- a/drivers/net/ethernet/sfc/rx_common.c
> +++ b/drivers/net/ethernet/sfc/rx_common.c
> @@ -150,7 +150,10 @@ static void efx_init_rx_recycle_ring(struct efx_rx_queue *rx_queue)
>  					    efx->rx_bufs_per_page);
>  	rx_queue->page_ring = kcalloc(page_ring_size,
>  				      sizeof(*rx_queue->page_ring), GFP_KERNEL);
> -	rx_queue->page_ptr_mask = page_ring_size - 1;
> +	if (!rx_queue->page_ring)
> +		rx_queue->page_ptr_mask = -1;
> +	else
> +		rx_queue->page_ptr_mask = page_ring_size - 1;
>  }
>  
>  static void efx_fini_rx_recycle_ring(struct efx_rx_queue *rx_queue)

