Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 665246D5025
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 20:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbjDCSVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 14:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjDCSVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 14:21:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63EC71FD0;
        Mon,  3 Apr 2023 11:21:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E427D6259F;
        Mon,  3 Apr 2023 18:21:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A31C433D2;
        Mon,  3 Apr 2023 18:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680546070;
        bh=hS/VW/TmI+v9QWd3BkT134CkMeiHYQz/F42CtU77k/M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mlFtLysxR/1n/VdHAV3icMCupfxFR65LyXMYSMwKqCe6l+LADE+L7gN5AmBIrOMVM
         cpihKXbrJsAxJ1GG70v9/Amx9j1UCvMEhehd9KfyNvzNEFkxCq0ZttpP/GJe7zMLRT
         7sPljFIXVjwyBwynzHaOklVv17QGvz0on7TXi9Zax4OLVeFoDupHyjC9pXlioTV2eJ
         I6E/X1q+bDT3BVZCywPU6DVKgZwYhJBrk8CUK6HjR+Ns9vqfCJMpOKVb1/yE5vPlEz
         RAi+AzAHk9hGLMBwYOQnIAJ6tQwn3IpoICAWL37rl8rem2rqZXh3nBDB39nlYJ4PP8
         ZttOWWK1r875w==
Date:   Mon, 3 Apr 2023 21:21:05 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Gerd Bayer <gbayer@linux.ibm.com>,
        Alexander Schmidt <alexs@linux.ibm.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5: stop waiting for PCI link if reset is required
Message-ID: <20230403182105.GC4514@unreal>
References: <20230403075657.168294-1-schnelle@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403075657.168294-1-schnelle@linux.ibm.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 09:56:56AM +0200, Niklas Schnelle wrote:
> after an error on the PCI link, the driver does not need to wait
> for the link to become functional again as a reset is required. Stop
> the wait loop in this case to accelerate the recovery flow.
> 
> Co-developed-by: Alexander Schmidt <alexs@linux.ibm.com>
> Signed-off-by: Alexander Schmidt <alexs@linux.ibm.com>
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/health.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
> index f9438d4e43ca..81ca44e0705a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
> @@ -325,6 +325,8 @@ int mlx5_health_wait_pci_up(struct mlx5_core_dev *dev)
>  	while (sensor_pci_not_working(dev)) {

According to the comment in sensor_pci_not_working(), this loop is
supposed to wait till PCI will be ready again. Otherwise, already in
first iteration, we will bail out with pci_channel_offline() error.

Thanks

>  		if (time_after(jiffies, end))
>  			return -ETIMEDOUT;
> +		if (pci_channel_offline(dev->pdev))
> +			return -EIO;
>  		msleep(100);
>  	}
>  	return 0;
> @@ -332,10 +334,16 @@ int mlx5_health_wait_pci_up(struct mlx5_core_dev *dev)
>  
>  static int mlx5_health_try_recover(struct mlx5_core_dev *dev)
>  {
> +	int rc;
> +
>  	mlx5_core_warn(dev, "handling bad device here\n");
>  	mlx5_handle_bad_state(dev);
> -	if (mlx5_health_wait_pci_up(dev)) {
> -		mlx5_core_err(dev, "health recovery flow aborted, PCI reads still not working\n");
> +	rc = mlx5_health_wait_pci_up(dev);
> +	if (rc) {
> +		if (rc == -ETIMEDOUT)
> +			mlx5_core_err(dev, "health recovery flow aborted, PCI reads still not working\n");
> +		else
> +			mlx5_core_err(dev, "health recovery flow aborted, PCI channel offline\n");
>  		return -EIO;
>  	}
>  	mlx5_core_err(dev, "starting health recovery flow\n");
> 
> base-commit: 7e364e56293bb98cae1b55fd835f5991c4e96e7d
> -- 
> 2.37.2
> 
