Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 492A362936C
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 09:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbiKOImu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 03:42:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiKOImn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 03:42:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C105E1EC7A;
        Tue, 15 Nov 2022 00:42:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1D02CCE13CC;
        Tue, 15 Nov 2022 08:42:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF7CC433D6;
        Tue, 15 Nov 2022 08:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668501757;
        bh=3tEdihNiMDh/O4rr0+0Y4IpqbDxzNECv6IIRZnCzSlE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RsUEN4hcKlAD5Te3/+DP9cmB15XeyLVkI92gAPrNP5+O2J6ECTg9YJlituUnRiwJ0
         4iQE9PI4xv/SoehIVu5E+BpiNEtVEiS/ylv1e6ppcM26Ec+LqLOJnRaS2csj8IsZZU
         5wi1JEKgWxA+c89uNOodo40xEl3wNslEiCrqYMgfCzM+1/e9bCdwNPdPndGRpvSPxq
         KFwXo6O6NhsreexcF+Om8+GXleU9daRFBwjyWPZ9nZ5fKxPtmExJzcIFdpwJUStFso
         Laacgu8U3gwn+oIt3iXqR51UbqI9BSJ+nnivzog8eWfMSJt8V5AcSjuodqK2qysAKw
         j72On0BRb34KQ==
Date:   Tue, 15 Nov 2022 10:42:32 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Hui Tang <tanghui20@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        mw@semihalf.com, linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yusongping@huawei.com
Subject: Re: [PATCH] net: mvpp2: fix possible invalid pointer dereference
Message-ID: <Y3NQ+MWftmZAuUEc@unreal>
References: <20221115044632.181769-1-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115044632.181769-1-tanghui20@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 12:46:32PM +0800, Hui Tang wrote:
> It will cause invalid pointer dereference to priv->cm3_base behind,
> if PTR_ERR(priv->cm3_base) in mvpp2_get_sram().
> 
> Fixes: a59d354208a7 ("net: mvpp2: enable global flow control")
> Signed-off-by: Hui Tang <tanghui20@huawei.com>
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index d98f7e9a480e..c92bd1922421 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -7421,7 +7421,7 @@ static int mvpp2_probe(struct platform_device *pdev)
>  			dev_warn(&pdev->dev, "Fail to alloc CM3 SRAM\n");
>  
>  		/* Enable global Flow Control only if handler to SRAM not NULL */
> -		if (priv->cm3_base)
> +		if (!IS_ERR_OR_NULL(priv->cm3_base))
>  			priv->global_tx_fc = true;

The change is ok, but the patch title should include target, in your
case it is net -> [PATCH net] ....

Thanks

>  	}
>  
> -- 
> 2.17.1
> 
