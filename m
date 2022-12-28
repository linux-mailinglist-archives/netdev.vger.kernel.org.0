Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE4FB6574B0
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 10:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbiL1Jfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 04:35:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiL1Jfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 04:35:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D137DD2D2
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 01:35:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A8BC6136F
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 09:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BECC433EF;
        Wed, 28 Dec 2022 09:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672220134;
        bh=+sNc/TkmwLtCuF3WdXUxEZNFgs58QUzSnzN5GtPJVfQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gWvaKSvMzqNgHPGYNKYYTD26RNYZg+26+xbce1Ck4DozO6BjV8y0NGM/4bFQZWTlt
         4BiV/ZviwuyM+yd13FwXa1jyVhfOQ6oqXo+vvHYmOjNEpaIP+CaGwO3bB4rk0yJ6HU
         EO5GgFkNDEZ3323L9Q4H9VtypC3SsHmgZJuPGfanDeJMhXQ9CIzH5kjNy+Pt4PIv32
         Q6+EYKrr29hKBnwDO7AHlnZjgHDWDE5YgNJ6jvsOzCyMGTY8BOunaj3DZpt/5hqtq9
         rgP8JUw/KS95TVcKijBY4N1VEuUhAd8zuCgJ/c3XxGsa+k3YxIYdi35dE9tZNZ9ayI
         ArmL/BRq2HhrQ==
Date:   Wed, 28 Dec 2022 11:35:30 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        ericvh@gmail.com, lucho@ionkov.net, asmadeus@codewreck.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux_oss@crudebyte.com,
        tom@opengridcomputing.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
Subject: Re: [PATCH] 9p/rdma: unmap receive dma buffer in rdma_request()
Message-ID: <Y6wN4uBZwPV+rKXi@unreal>
References: <20221220031223.3890143-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220031223.3890143-1-shaozhengchao@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 20, 2022 at 11:12:23AM +0800, Zhengchao Shao wrote:
> When down_interruptible() failed in rdma_request(), receive dma buffer
> is not unmapped. Add unmap action to error path.
> 
> Fixes: fc79d4b104f0 ("9p: rdma: RDMA Transport Support for 9P")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  net/9p/trans_rdma.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
> index 83f9100d46bf..da83023fecbf 100644
> --- a/net/9p/trans_rdma.c
> +++ b/net/9p/trans_rdma.c
> @@ -499,6 +499,8 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
>  
>  	if (down_interruptible(&rdma->sq_sem)) {
>  		err = -EINTR;
> +		ib_dma_unmap_single(rdma->cm_id->device, c->busa,
> +				    c->req->tc.size, DMA_TO_DEVICE);
>  		goto send_error;
>  	}

It is not the only place where ib_dma_unmap_single() wasn't called.
Even at the same function if ib_post_send() fails, the unmap is not
called. Also post_recv() is missing call to ib_dma_unmap_single() too.

Thanks

>  
> -- 
> 2.34.1
> 
