Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7637E646C12
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 10:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbiLHJni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 04:43:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiLHJni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 04:43:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1A65B85A
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 01:43:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7E0961E38
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 09:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A8BC433C1;
        Thu,  8 Dec 2022 09:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670492616;
        bh=5XEs3RMPVBza0i2zKRRR0IVTNSWcrTjXfCL/wctRkt0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dJsKWHYX1nTKqXn002rqKSe1tv14C9k/cIKd87nLpulJItXgION468eyQGWdjE4Lr
         ySs0TjbM5OdhEdySQyYe6SbmKWVuHWEor/rAxgTWWWVFPL+X1WrDBpj+k4yi/I6Ac8
         7iFnYgcXE5zJRVRX1SFtVMVjWmr/d2gDIvrN3Rp2Jt+BRq3IagIK42wFyVRPr26n3X
         6ZocZtoGQVRqxaK1dQTj7vMZSRFPz0i2kt7S5qhDo6LLVzEWfq5zJ1wuipFqJQmRqJ
         ejgan1A5hi95BMiu/O5ThG3MoxuI0IbPF/wdxfXRf1IGRY4rMA020I8b3yxJheyntV
         nGL+UpNumA4Vg==
Date:   Thu, 8 Dec 2022 11:43:32 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, jdmason@kudzu.us, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net v3] ethernet: s2io: don't call dev_kfree_skb() under
 spin_lock_irqsave()
Message-ID: <Y5GxxIc9EY6h/qj2@unreal>
References: <20221208092411.1961448-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221208092411.1961448-1-yangyingliang@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 08, 2022 at 05:24:11PM +0800, Yang Yingliang wrote:
> The dev_kfree_skb() is defined as consume_skb(), and it is not allowed
> to call consume_skb() from hardware interrupt context or with interrupts
> being disabled. So replace dev_kfree_skb() with dev_consume_skb_irq()
> under spin_lock_irqsave().

While dev_kfree_skb and consume_skb are the same, the dev_kfree_skb_irq
and dev_consume_skb_irq are not. You can't blindly replace
dev_kfree_skb with dev_consume_skb_irq. You should check every place, analyze
and document why specific option was chosen.

  3791 static inline void dev_kfree_skb_irq(struct sk_buff *skb)
  3792 {
  3793         __dev_kfree_skb_irq(skb, SKB_REASON_DROPPED);
  3794 }
  3795
  3796 static inline void dev_consume_skb_irq(struct sk_buff *skb)
  3797 {
  3798         __dev_kfree_skb_irq(skb, SKB_REASON_CONSUMED);
  3799 }

Thanks


> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
> v2 -> v3:
>   Update commit message.
> 
> v1 -> v2:
>   Add fix tag.
> ---
>  drivers/net/ethernet/neterion/s2io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
> index 1d3c4474b7cb..a83d61d45936 100644
> --- a/drivers/net/ethernet/neterion/s2io.c
> +++ b/drivers/net/ethernet/neterion/s2io.c
> @@ -2386,7 +2386,7 @@ static void free_tx_buffers(struct s2io_nic *nic)
>  			skb = s2io_txdl_getskb(&mac_control->fifos[i], txdp, j);
>  			if (skb) {
>  				swstats->mem_freed += skb->truesize;
> -				dev_kfree_skb(skb);
> +				dev_consume_skb_irq(skb);
>  				cnt++;
>  			}
>  		}
> -- 
> 2.25.1
> 
