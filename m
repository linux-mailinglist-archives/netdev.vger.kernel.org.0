Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D7C2B84DD
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 20:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgKRTWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 14:22:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:36580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726281AbgKRTWJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 14:22:09 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D67CB22227;
        Wed, 18 Nov 2020 19:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605727329;
        bh=X7i2Ovs2XIa0XrN5iNbC+JANL7tnUkE/DKJ6hArBgn0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UB57vGKFvR7EV8G9t47RNnDnCU5nRTVXap+y3SRksDZgbJvJ122gIq5tECV99WVBe
         PEos7J7LjR49AL6krUKeNpDNQO7BW767cgSj03Esevi9za5g6vhj1kkVXBxsWiOAJH
         5KBEJtXHcDoPrv4otSLFS0exHvY0mXOuc0ucmKAI=
Date:   Wed, 18 Nov 2020 11:22:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Maxim Mikityanskiy" <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net 2/2] net: Call skb destructor on
 NAPI_GRO_FREE_STOLEN_HEAD
Message-ID: <20201118112207.2b8bea44@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201117203355.389661-2-saeedm@nvidia.com>
References: <20201117203355.389661-1-saeedm@nvidia.com>
        <20201117203355.389661-2-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 12:33:55 -0800 Saeed Mahameed wrote:
> From: Maxim Mikityanskiy <maximmi@mellanox.com>
> 
> All GRO flows except one call skb->destructor, however, GRO_MERGED_FREE
> doesn't do it in case of NAPI_GRO_FREE_STOLEN_HEAD. For better
> consistency and to add resiliency against the drivers that may pass SKBs
> with a destructor, this patch changes napi_skb_free_stolen_head to use
> skb_release_head_state, which should perform all the needed cleanups,
> including a call to the destructor. This way the code of GRO_MERGED_FREE
> becomes similar to kfree_skb_partial.
> 
> Fixes: e44699d2c280 ("net: handle NAPI_GRO_FREE_STOLEN_HEAD case also in napi_frags_finish()")
> Fixes: d7e8883cfcf4 ("net: make GRO aware of skb->head_frag")
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

CC Eric for GRO expertise.

Makes sense to me, but do you still need "net/mlx5e: Fix refcount leak
on kTLS RX resync" even with this applied?

> diff --git a/net/core/dev.c b/net/core/dev.c
> index 82dc6b48e45f..85dcc7f19902 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6048,8 +6048,7 @@ EXPORT_SYMBOL(gro_find_complete_by_type);
>  
>  static void napi_skb_free_stolen_head(struct sk_buff *skb)
>  {
> -	skb_dst_drop(skb);
> -	skb_ext_put(skb);
> +	skb_release_head_state(skb);
>  	kmem_cache_free(skbuff_head_cache, skb);
>  }
>  

