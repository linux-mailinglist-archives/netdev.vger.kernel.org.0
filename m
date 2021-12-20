Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0E247AB1E
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 15:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233520AbhLTOQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 09:16:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233487AbhLTOQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 09:16:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF54EC061574;
        Mon, 20 Dec 2021 06:16:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CD896116D;
        Mon, 20 Dec 2021 14:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E6FC36AE8;
        Mon, 20 Dec 2021 14:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640009791;
        bh=7sGEbzlUMwIOcKcozCdxOdT+mDoelkMEDXmoiUlQOVE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R0Vf0MB+Tw+29zYUdgx7tCRafPSTzaVDYi9ZNCBZo3VguStkdHBbdLzLY0/jb/EAu
         SyGEIeOxRZSWkwLiOcYF4LVJ6NVsEQH4ORdYNygBi/l9HZjw4J52SMTBZy5lUOpXZY
         IBCoq/2RCeXC/NrQ4mDifKCH5FDz5b27NvVXH/BI=
Date:   Mon, 20 Dec 2021 15:16:28 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] sfc: Check null pointer of rx_queue->page_ring
Message-ID: <YcCQPA/EnHxYikYj@kroah.com>
References: <20211220135603.954944-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220135603.954944-1-jiasheng@iscas.ac.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 20, 2021 at 09:56:03PM +0800, Jiasheng Jiang wrote:
> Because of the possible failure of the kcalloc, it should be better to
> set rx_queue->page_ptr_mask to 0 when it happens in order to maintain
> the consistency.
> 
> Fixes: 5a6681e22c14 ("sfc: separate out SFC4000 ("Falcon") support into new sfc-falcon driver")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
>  drivers/net/ethernet/sfc/rx_common.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
> index 68fc7d317693..0983abc0cc5f 100644
> --- a/drivers/net/ethernet/sfc/rx_common.c
> +++ b/drivers/net/ethernet/sfc/rx_common.c
> @@ -150,7 +150,10 @@ static void efx_init_rx_recycle_ring(struct efx_rx_queue *rx_queue)
>  					    efx->rx_bufs_per_page);
>  	rx_queue->page_ring = kcalloc(page_ring_size,
>  				      sizeof(*rx_queue->page_ring), GFP_KERNEL);
> -	rx_queue->page_ptr_mask = page_ring_size - 1;
> +	if (!rx_queue->page_ring)
> +		rx_queue->page_ptr_mask = 0;
> +	else
> +		rx_queue->page_ptr_mask = page_ring_size - 1;
>  }

Why not return an error?

