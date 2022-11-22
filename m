Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 266C7633F33
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 15:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbiKVOsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 09:48:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232665AbiKVOsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 09:48:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8B62606;
        Tue, 22 Nov 2022 06:48:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36B3161733;
        Tue, 22 Nov 2022 14:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E235EC433D6;
        Tue, 22 Nov 2022 14:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669128499;
        bh=lqCUWdMmeZtamXQEK/uSvDyJ1N+krRb43evlfpRGSZs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d0fdR4ivk8mJ4v0r1rJsp6WCI3EU7K/tUh595I3GwFieuAQHMyGmgY5LBpa1seKdQ
         vSrlvi7NAL5KWYM6Ux5Ksb+6/faI94FqMijFBnY5u5cP8qMzVEYUi2nNOdrnFaL4Fc
         KcowLouD0A+ZQ0+LTp/SEGtTTEum05N1sIk/zGFfcwKZ4Ksk2BmijqRsaCjkIFPoI1
         UVaCCQn27h+vkXj0xZgp5RJASAgCoOtamEyEa/g4d0yybXGqEyRPlxrBuiTGekLIRc
         6QGKhejqw4g7PZzT07liwrL+xQBNPNEQ6WZ3R7vPhM+Pm0Kss83bnBEqiDWWuIY5/g
         bT7KVaS8d1CRw==
Date:   Tue, 22 Nov 2022 16:48:15 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Peter Kosyh <pkosyh@yandex.ru>
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH] mlx4: use snprintf() instead of sprintf() for safety
Message-ID: <Y3zhL0/OItHF1R03@unreal>
References: <20221122130453.730657-1-pkosyh@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122130453.730657-1-pkosyh@yandex.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 04:04:53PM +0300, Peter Kosyh wrote:
> Use snprintf() to avoid the potential buffer overflow. Although in the
> current code this is hardly possible, the safety is unclean.

Let's fix the tools instead. The kernel code is correct.

Thanks

> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Peter Kosyh <pkosyh@yandex.ru>
> ---
>  drivers/net/ethernet/mellanox/mlx4/main.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
> index d3fc86cd3c1d..0616d352451b 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/main.c
> @@ -3057,7 +3057,8 @@ static int mlx4_init_port_info(struct mlx4_dev *dev, int port)
>  		info->base_qpn = mlx4_get_base_qpn(dev, port);
>  	}
>  
> -	sprintf(info->dev_name, "mlx4_port%d", port);
> +	snprintf(info->dev_name, sizeof(info->dev_name),
> +		 "mlx4_port%d", port);
>  	info->port_attr.attr.name = info->dev_name;
>  	if (mlx4_is_mfunc(dev)) {
>  		info->port_attr.attr.mode = 0444;
> @@ -3077,7 +3078,8 @@ static int mlx4_init_port_info(struct mlx4_dev *dev, int port)
>  		return err;
>  	}
>  
> -	sprintf(info->dev_mtu_name, "mlx4_port%d_mtu", port);
> +	snprintf(info->dev_mtu_name, sizeof(info->dev_mtu_name),
> +		 "mlx4_port%d_mtu", port);
>  	info->port_mtu_attr.attr.name = info->dev_mtu_name;
>  	if (mlx4_is_mfunc(dev)) {
>  		info->port_mtu_attr.attr.mode = 0444;
> -- 
> 2.38.1
> 
