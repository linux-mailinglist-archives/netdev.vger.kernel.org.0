Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C6F6CD7BB
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 12:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjC2KdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 06:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbjC2KdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 06:33:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8997846B7;
        Wed, 29 Mar 2023 03:32:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD8C6B82249;
        Wed, 29 Mar 2023 10:32:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E6EC433EF;
        Wed, 29 Mar 2023 10:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680085923;
        bh=JEMZ7a8VyRXa464/6X16h2yk9oFHy6v0/9AAyYJ/b9Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MLzYUfsjToBk0czLWMTlznACdT5r223s/gbgttK3lsp8Nzd+xOx47nnthOlrVDXb7
         /8oRKfKoYSo/7nTJ0xcTJpb8M1xxJnqXXi1BX4e35thZR4AkY+nJxsASpmcwZCy/W1
         JTjNSGX/gHo/5Hu0v4MZgJFR8s3tRLeAMkCofb1SOc/fvfA4M/fcwXmuHSP/4LRyKH
         cZyhxDeERT19IPleg6I1M4z1IEw2IiqgESsSr9rPMQIFoc2EAFiO23sJE26aHRgwWw
         PC7hNfCCTL7xfmxcCpiWN6R7k81LFWUzgZUQTyXWTktUBcgx6he7RRAzWRdubPybaT
         a9kM3fulidCQg==
Date:   Wed, 29 Mar 2023 13:31:58 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     saeedm@nvidia.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: Re: [PATCH 1/2] net/mlx5e: Fix missing error code in
 mlx5e_rx_reporter_err_icosq_cqe_recover()
Message-ID: <20230329103158.GJ831478@unreal>
References: <20230324025541.38458-1-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230324025541.38458-1-jiapeng.chong@linux.alibaba.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 24, 2023 at 10:55:40AM +0800, Jiapeng Chong wrote:
> The error code is missing in this code scenario, add the error code
> '-EINVAL' to the return value 'err'.
> 
> drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c:104 mlx5e_rx_reporter_err_icosq_cqe_recover() warn: missing error code 'err'.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4601
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
> index b621f735cdc3..b66183204be3 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
> @@ -100,8 +100,10 @@ static int mlx5e_rx_reporter_err_icosq_cqe_recover(void *ctx)
>  		goto out;
>  	}
>  
> -	if (state != MLX5_SQC_STATE_ERR)
> +	if (state != MLX5_SQC_STATE_ERR) {
> +		err = -EINVAL;

I'm not sure about correctness of this change. SQC is not in error
state, there is nothing to recover here.

Thanks

>  		goto out;
> +	}
>  
>  	mlx5e_deactivate_rq(rq);
>  	if (xskrq)
> -- 
> 2.20.1.7.g153144c
> 
