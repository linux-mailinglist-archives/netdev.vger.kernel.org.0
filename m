Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A7C416F7A
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 11:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245346AbhIXJuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 05:50:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245357AbhIXJus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 05:50:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7571C61050;
        Fri, 24 Sep 2021 09:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632476955;
        bh=UmlGe7qRwuHtn7L5yamuZOKZreKeYbx5LHLiWuDF55o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B7BTynlk4MSmVS5866aoqA0wm3a87LbLHMsrMBdcCdiZWny87RN9CFbempEs60rEI
         +c69CzBQPKCFDpNzcJSk1280J9H42ywPqr4qlv9LLL3nj1CVMGhiBpGPUz36jduO4b
         uHkd1y8Un8KbNWdfnM/Hc5F1lljausnnlsv4QcFb2ayyZdEXcj/DOW3YFXEGd5QAIn
         l4iI30Ku/rQHpeTAultVBywLGZ2K2cWmQC5w9R6d8m8VUUoPK5xAKgGX21xFcATUAs
         3IVgbiE/hhoZfxfq+IfxxpzbnsrLCZ4vH9xVPgvqRGPAt2KrQItGl5iH9GgvLjh+NO
         /NIwDk7Zsk7Ng==
Date:   Fri, 24 Sep 2021 15:19:09 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] drivers: net: mhi: fix error path in mhi_net_newlink
Message-ID: <20210924094909.GA19050@workstation>
References: <20210924092652.3707-1-dnlplm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924092652.3707-1-dnlplm@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 24, 2021 at 11:26:52AM +0200, Daniele Palmas wrote:
> Fix double free_netdev when mhi_prepare_for_transfer fails.
> 
> Fixes: 3ffec6a14f24 ("net: Add mhi-net driver")
> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>

I guess this patch should be backported to stable kernels. So please CC stable
list.

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

Thanks,
Mani

> ---
>  drivers/net/mhi_net.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
> index d127eb6e9257..aaa628f859fd 100644
> --- a/drivers/net/mhi_net.c
> +++ b/drivers/net/mhi_net.c
> @@ -321,7 +321,7 @@ static int mhi_net_newlink(struct mhi_device *mhi_dev, struct net_device *ndev)
>  	/* Start MHI channels */
>  	err = mhi_prepare_for_transfer(mhi_dev);
>  	if (err)
> -		goto out_err;
> +		return err;
>  
>  	/* Number of transfer descriptors determines size of the queue */
>  	mhi_netdev->rx_queue_sz = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
> @@ -331,10 +331,6 @@ static int mhi_net_newlink(struct mhi_device *mhi_dev, struct net_device *ndev)
>  		return err;
>  
>  	return 0;
> -
> -out_err:
> -	free_netdev(ndev);
> -	return err;
>  }
>  
>  static void mhi_net_dellink(struct mhi_device *mhi_dev, struct net_device *ndev)
> -- 
> 2.30.2
> 
