Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4B6D4F466A
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 01:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378679AbiDEUEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573251AbiDESdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 14:33:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 788F713F6F;
        Tue,  5 Apr 2022 11:31:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2573EB81E2E;
        Tue,  5 Apr 2022 18:31:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658C7C385A1;
        Tue,  5 Apr 2022 18:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649183480;
        bh=1hnkQYUuoWkC4yQdqZXmunRlJ4PgNWR3bFFQPi+NKyg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WAh2iBjp+FfhVbPaBSaaW1gZl23WvY8W7NK7nD02Ge6408pU+/hV1gDEDnPZmTwzw
         7QyNLelnig/aEflwUslwjCPrVhDTGVt/I1ic0FVr2Yo2r7/9geSY8WOPoxytkS7M//
         Z8WU+k2aZq2HLB4Y7/a+5Tc9FckxgyPiLy9TuAXn70Vh311gcXeoSufKgqtzpneRYe
         m4TOGfewkusTEIbOAyBax6kd88obeERSAjxC9l7yhfuczjIVHVZlC/yiSEaEpcAWgV
         bh9TDfaQ4FGOzXWJIjaS2mtFXSBHxzgyNoN6TpmYbpg/3yBdEKaQVudQgYDbbMSHrX
         BknM8GzlOpsuw==
Date:   Tue, 5 Apr 2022 21:31:16 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 10/11] IB/mlx5: Fix undefined behavior due to shift
 overflowing the constant
Message-ID: <YkyK9NfN57ldFuyY@unreal>
References: <20220405151517.29753-1-bp@alien8.de>
 <20220405151517.29753-11-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220405151517.29753-11-bp@alien8.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 05:15:16PM +0200, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Fix:
> 
>   drivers/infiniband/hw/mlx5/main.c: In function ‘translate_eth_legacy_proto_oper’:
>   drivers/infiniband/hw/mlx5/main.c:370:2: error: case label does not reduce to an integer constant
>     case MLX5E_PROT_MASK(MLX5E_50GBASE_KR2):
>     ^~~~
> 
> See https://lore.kernel.org/r/YkwQ6%2BtIH8GQpuct@zn.tnic for the gory
> details as to why it triggers with older gccs only.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Saeed Mahameed <saeedm@nvidia.com>
> Cc: linux-rdma@vger.kernel.org
> Cc: netdev@vger.kernel.org
> ---
>  include/linux/mlx5/port.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

I would like to take this patch to mlx5-next, but it didn't show
nor in patchworks [1] nor in lore [2].

Thanks

[1] https://patchwork.kernel.org/project/linux-rdma/list/
[2] https://lore.kernel.org/linux-rdma/

> 
> diff --git a/include/linux/mlx5/port.h b/include/linux/mlx5/port.h
> index 28a928b0684b..e96ee1e348cb 100644
> --- a/include/linux/mlx5/port.h
> +++ b/include/linux/mlx5/port.h
> @@ -141,7 +141,7 @@ enum mlx5_ptys_width {
>  	MLX5_PTYS_WIDTH_12X	= 1 << 4,
>  };
>  
> -#define MLX5E_PROT_MASK(link_mode) (1 << link_mode)
> +#define MLX5E_PROT_MASK(link_mode) (1U << link_mode)
>  #define MLX5_GET_ETH_PROTO(reg, out, ext, field)	\
>  	(ext ? MLX5_GET(reg, out, ext_##field) :	\
>  	MLX5_GET(reg, out, field))
> -- 
> 2.35.1
> 
