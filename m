Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8336469FB
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 08:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiLHH4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 02:56:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiLHH4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 02:56:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B631F2228C
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 23:56:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4293E61DA3
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 07:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC10C433C1;
        Thu,  8 Dec 2022 07:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670486190;
        bh=qER3r0ftsMJBfAmDo/rPg5SPFjPAZBdS1INKfQAhCWA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NE6UPefSwicrPpjjK0JSo2tUlOIJWIn8+sreTfZZpg9QnOpekXuAJfTqmqoL2Lkar
         TTUTmTLarvltSJX2RaQXfSFDC20aJc7w/GRi96BAkXSgJoj00wFl6dcb5bNQkTX7qL
         8hNfvo3zBoBSw1Zw7gGUIE/tZgqdN0MEo9Aqa2YFd9O4W1HbYnTZqOYEcusxc0VN9q
         xgfiMCFbhdoRJHdNerXz/awkaO3/ksY0Dx9u75NTVaKhpmoR2+ZbS1laTc8NIke7qU
         smHupbWnrRCRDZcrniA+ilSqrMFj05x/Rf8zrt8+KA1cxn6KeFa/Yf2RIYnk3DAnMI
         QWuBpLrNQkgsQ==
Date:   Thu, 8 Dec 2022 09:56:26 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, jdmason@kudzu.us, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net v2] ethernet: s2io: don't call dev_kfree_skb() under
 spin_lock_irqsave()
Message-ID: <Y5GYqsgKxhUpfTn/@unreal>
References: <20221207012540.2717379-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207012540.2717379-1-yangyingliang@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 09:25:40AM +0800, Yang Yingliang wrote:
> It is not allowed to call consume_skb() from hardware interrupt context
> or with interrupts being disabled. So replace dev_kfree_skb() with
> dev_consume_skb_irq() under spin_lock_irqsave().
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
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

And why did you use dev_consume_skb_irq() and not dev_kfree_skb_irq()?

Thanks

>  				cnt++;
>  			}
>  		}
> -- 
> 2.25.1
> 
