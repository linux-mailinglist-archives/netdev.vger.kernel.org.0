Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7861A420AE0
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 14:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbhJDM2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 08:28:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230238AbhJDM2I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 08:28:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E5556124C;
        Mon,  4 Oct 2021 12:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633350379;
        bh=S/xozdTW2Vv6URwHQvbZxlXTqDmdRuwhaA8ampD9IDk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bZGVgamiO/dFIWw3pDm1bomZoXCkpinHgJAGBDonfwuNM3EMLqsZ/3Bjyt0XAVdtp
         qy5/FZRReOqAJ6tKbDcHsJpuPLkzMUIR63f7OsHCQgkMu3ZPRcMkwDtET1a8pKeg1p
         fe1CxyOspkKIfY7f2SSsTO14ozX6Th3guTvqGY/fUf6XY1la33ArT8/0+RNKGZtSkZ
         CsuRIFChyO3O/eOp4QOCrIisp//taINqBjWCcBNgO2RXAm0D7mbntHVbBVxTLb1N+W
         4AsmRABAEbsJCKqwxYohNhjSreHgAEw224l9fwwrGmT+2F79otuAmluKIkoSr+ULbK
         vpOjbBT2PVEKA==
Date:   Mon, 4 Oct 2021 17:56:12 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] drivers: net: mhi: fix error path in mhi_net_newlink
Message-ID: <20211004122612.GF16442@workstation>
References: <20211004114601.13870-1-dnlplm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004114601.13870-1-dnlplm@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 01:46:01PM +0200, Daniele Palmas wrote:
> Fix double free_netdev when mhi_prepare_for_transfer fails.
> 
> This is a back-port of upstream:
> commit 4526fe74c3c509 ("drivers: net: mhi: fix error path in mhi_net_newlink")
> 
> Fixes: 13adac032982 ("net: mhi_net: Register wwan_ops for link creation")
> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

Thanks,
Mani

> ---
> Hello Greg,
> 
> if maintainers ack, this should go just to 5.14 branch.
> 
> Thanks,
> Daniele
> ---
>  drivers/net/mhi/net.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
> index e60e38c1f09d..5e49f7a919b6 100644
> --- a/drivers/net/mhi/net.c
> +++ b/drivers/net/mhi/net.c
> @@ -337,7 +337,7 @@ static int mhi_net_newlink(void *ctxt, struct net_device *ndev, u32 if_id,
>  	/* Start MHI channels */
>  	err = mhi_prepare_for_transfer(mhi_dev);
>  	if (err)
> -		goto out_err;
> +		return err;
>  
>  	/* Number of transfer descriptors determines size of the queue */
>  	mhi_netdev->rx_queue_sz = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
> @@ -347,7 +347,7 @@ static int mhi_net_newlink(void *ctxt, struct net_device *ndev, u32 if_id,
>  	else
>  		err = register_netdev(ndev);
>  	if (err)
> -		goto out_err;
> +		return err;
>  
>  	if (mhi_netdev->proto) {
>  		err = mhi_netdev->proto->init(mhi_netdev);
> @@ -359,8 +359,6 @@ static int mhi_net_newlink(void *ctxt, struct net_device *ndev, u32 if_id,
>  
>  out_err_proto:
>  	unregister_netdevice(ndev);
> -out_err:
> -	free_netdev(ndev);
>  	return err;
>  }
>  
> -- 
> 2.30.2
> 
