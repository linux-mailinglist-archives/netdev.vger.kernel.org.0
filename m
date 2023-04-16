Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F204D6E370B
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 12:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbjDPKSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 06:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDPKSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 06:18:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F953E4C
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 03:17:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFC246192D
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 10:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C339BC433EF;
        Sun, 16 Apr 2023 10:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681640278;
        bh=91HTTHau7ntCstaTlX8pA3IBfIbxmV5K9XvoTbPCpS8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QvJNklSfjAXTOAQLx0nQjL1pVg0gZy+wY8LCsm8372TwlfXnCXRaXbaS0KnAbP3Uf
         qTrUBcFnZzr5/xeRicqGotagANNQSw7Q500IwFPEEetotf9O6Ke1p51TB05Mu1MFpO
         7XPXQcePFXblRWwARQSEbQ6Hquk6gSktOIwibCl7QUw/OK8WEzJWMte8F3k8gHECpd
         KMtiP8aQ33JuNL/xZnmCPj/84ttEWYbcPqLE8+FSJfYfG9plLJu0h3rZnth150CHhI
         22lSq5B1rwdt3ZKgTjbh+NigQM336MWZ1vGdAAsV9+2U8GsnCph59OjEH+BsbqqC9B
         r4EAGPWgUxp9Q==
Date:   Sun, 16 Apr 2023 13:17:53 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, saeedm@nvidia.com
Subject: Re: [PATCH net-next] eth: mlx5: avoid iterator use outside of a loop
Message-ID: <20230416101753.GB15386@unreal>
References: <20230414180729.198284-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414180729.198284-1-kuba@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 14, 2023 at 11:07:29AM -0700, Jakub Kicinski wrote:
> Fix the following warning about risky iterator use:
> 
> drivers/net/ethernet/mellanox/mlx5/core/eq.c:1010 mlx5_comp_irq_get_affinity_mask() warn: iterator used outside loop: 'eq'
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: saeedm@nvidia.com
> CC: leon@kernel.org
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/eq.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> index eb41f0abf798..03c0165a8fd5 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> @@ -1070,10 +1070,11 @@ mlx5_comp_irq_get_affinity_mask(struct mlx5_core_dev *dev, int vector)
>  
>  	list_for_each_entry(eq, &table->comp_eqs_list, list) {
>  		if (i++ == vector)
> -			break;
> +			return mlx5_irq_get_affinity_mask(eq->core.irq);
>  	}
>  
> -	return mlx5_irq_get_affinity_mask(eq->core.irq);
> +	WARN_ON_ONCE(1);
> +	return 0;

I would do it without changing last return, but "return ERR_PTR(0);"
will do the trick too.

Thanks

>  }
>  EXPORT_SYMBOL(mlx5_comp_irq_get_affinity_mask);
>  
> -- 
> 2.39.2
> 
