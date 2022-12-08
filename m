Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98A966469FD
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 08:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiLHH6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 02:58:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiLHH6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 02:58:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8695654348
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 23:58:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3911EB81CB2
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 07:58:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30ADCC433C1;
        Thu,  8 Dec 2022 07:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670486316;
        bh=VWQjfOKBOct2RwWswK4YX3ro3qI0cMpWxwegLgqaZcE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H7BxKMOcfWaMxApJXK53l4Kvdha/+eTydojTdKXvuypoBRuDaq/4fQJKninRSXFng
         cdJ/5z8CrjpJEIzZK12GH7sZFQKpM6ahz42kbdF3R/xUWtxizRYhbvCI66r2v2NUEF
         D8xsYPsaz0JcLmo7aoM95BESNwOXgvLNK+96Gkop+sX00QtTUQ+1uQX2vsAYfAFJLL
         OV5EdFlB29DD0hc+aZPZm4vHGbq5zEi5NcXxFcviCfAPNQWOiWCbSzWGjgk7M6Sk2Y
         o4PwHBK8EVqkaxVJuqemeXt/JxjkVXfCjFqYIdSi15w1bOc4G0vdYqRzixf4F+WqNf
         Kbfj3UwmZqqWA==
Date:   Thu, 8 Dec 2022 09:58:31 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net v2 1/2] net: apple: mace: don't call dev_kfree_skb()
 under spin_lock_irqsave()
Message-ID: <Y5GZJ2rBuMZoZ0e7@unreal>
References: <20221207012959.2800421-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207012959.2800421-1-yangyingliang@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 09:29:58AM +0800, Yang Yingliang wrote:
> It is not allowed to call consume_skb() from hardware interrupt context
> or with interrupts being disabled. So replace dev_kfree_skb() with
> dev_consume_skb_irq() under spin_lock_irqsave().
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
> v1 -> v2:
>   Add a fix tag.
> ---
>  drivers/net/ethernet/apple/mace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/apple/mace.c b/drivers/net/ethernet/apple/mace.c
> index d0a771b65e88..77b4ed05140b 100644
> --- a/drivers/net/ethernet/apple/mace.c
> +++ b/drivers/net/ethernet/apple/mace.c
> @@ -846,7 +846,7 @@ static void mace_tx_timeout(struct timer_list *t)
>      if (mp->tx_bad_runt) {
>  	mp->tx_bad_runt = 0;
>      } else if (i != mp->tx_fill) {
> -	dev_kfree_skb(mp->tx_bufs[i]);
> +	dev_consume_skb_irq(mp->tx_bufs[i]);

Same question, why did you chose dev_consume_skb_irq and not dev_kfree_skb_irq?

Thanks

>  	if (++i >= N_TX_RING)
>  	    i = 0;
>  	mp->tx_empty = i;
> -- 
> 2.25.1
> 
