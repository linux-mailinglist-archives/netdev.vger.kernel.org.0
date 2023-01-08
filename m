Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0EC366155B
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 14:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbjAHNIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 08:08:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbjAHNIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 08:08:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEC9E0B8;
        Sun,  8 Jan 2023 05:08:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADC0DB80064;
        Sun,  8 Jan 2023 13:08:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC26BC433D2;
        Sun,  8 Jan 2023 13:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673183318;
        bh=2T8+E8cXKaNmV5uXEdKEyGuifcQK6vJrE4POSTr+RVY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BPBPKDWuLZ7pXxzmB/v6ZTfdip4gebFLSjXDb4PZFdszB+Vk9xdS68RJ8MO2eXHGM
         wSt45wihli20F2MQFsyUPLo2ttuJQo/+ToXq/fuOC8EX6opGuzKfLH3ULi/vDA69tb
         l+bmvuZTT09uWCY2UNbyQxuVJ/IlX5ph7d2dnXesxDp51PHbe/Nk4Sdd2l6E3sNCiS
         n154axi9TVxk7j/LLBxmu+LmGSWgjKi9e7AzMgDeJGpQqlEjqXwInB23mwVEz/P7Z6
         DnXt5J9Whh7nJwiEcSLz26ZJL3hArCIpAf5zD7QG1W8OCW0Yva6roMhexwNGFg2hQ6
         uTpPdWbQuYd5w==
Date:   Sun, 8 Jan 2023 15:08:33 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
        edumazet@google.com, sbhatta@marvell.com, hkelam@marvell.com,
        sgoutham@marvell.com
Subject: Re: [net PATCH] octeontx2-pf: Use GFP_ATOMIC in atomic context
Message-ID: <Y7rAUVXiRNFsuR8y@unreal>
References: <20230107044139.25787-1-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230107044139.25787-1-gakula@marvell.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 07, 2023 at 10:11:39AM +0530, Geetha sowjanya wrote:
> Use GFP_ATOMIC flag instead of GFP_KERNEL while allocating memory
> in atomic context.

Awesome, but the changed functions don't run in atomic context.

> 
> Fixes: 4af1b64f80fb ("octeontx2-pf: Fix lmtst ID used in aura free")
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> index 88f8772a61cd..12e4365d53df 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> @@ -886,7 +886,7 @@ static int otx2_sq_init(struct otx2_nic *pfvf, u16 qidx, u16 sqb_aura)
>  	}
>  
>  	sq->sqe_base = sq->sqe->base;
> -	sq->sg = kcalloc(qset->sqe_cnt, sizeof(struct sg_list), GFP_KERNEL);
> +	sq->sg = kcalloc(qset->sqe_cnt, sizeof(struct sg_list), GFP_ATOMIC);
>  	if (!sq->sg)
>  		return -ENOMEM;
>  
> @@ -1378,7 +1378,7 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
>  
>  		sq = &qset->sq[qidx];
>  		sq->sqb_count = 0;
> -		sq->sqb_ptrs = kcalloc(num_sqbs, sizeof(*sq->sqb_ptrs), GFP_KERNEL);
> +		sq->sqb_ptrs = kcalloc(num_sqbs, sizeof(*sq->sqb_ptrs), GFP_ATOMIC);
>  		if (!sq->sqb_ptrs) {
>  			err = -ENOMEM;
>  			goto err_mem;
> -- 
> 2.25.1
> 
