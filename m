Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6400E61EDF5
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 09:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbiKGI6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 03:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiKGI6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 03:58:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319755F6C
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 00:58:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C41A560F5B
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 08:58:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66975C433D6;
        Mon,  7 Nov 2022 08:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667811498;
        bh=kdGu69qi6jXqhpK5Fc527HUeUF+YTWang2jPLeQMF4c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JUNIQCQfJTfTk/fkqqcgKDpWQQkcQcIOLsXa7vaeOUAFWM9pVM4T1pBfJBbuZoUHr
         T/JpBSgkzYOxFYpGAt2wQFc6xg8dtt1eEKinhgRk1E1iFn4c7wWgfIu31/qwWjW4uT
         XNGn58GLQcT92X0b5krHxM32zsyk4zyo2NdSR+g6uvKgsYB9FVK9QpkpsvS5zNlaLg
         wlJVtVZdgn4YEKhG7Otp+Q1msVLFJQH30EzLaPSmbOq5NaCnVzxQs5HG5YhJjkm/km
         xa6aHcCFbxVTMmGNGebAZ8Zjhsl3cY6crYDeGnhq/NumwXe8hwE1gnoVMTbk9T5xhD
         q+p6ifXvHK4gQ==
Date:   Mon, 7 Nov 2022 10:58:13 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jamie Gloudon <jamie.gloudon@gmx.fr>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org
Subject: Re: [PATCH net v3 1/1] ip6_tunnel: Correct mistake in if statement.
Message-ID: <Y2jIpSCdti8lv73X@unreal>
References: <Y2jCWvICWQ8AiQyR@gmx.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2jCWvICWQ8AiQyR@gmx.fr>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 07, 2022 at 04:31:22AM -0400, Jamie Gloudon wrote:
> Make sure t->dev->flags & IFF_UP is check first for logical reason.
> 
> Fixes: 6c1cb4393cc7 ("ip6_tunnel: fix ip6 tunnel lookup in collect_md
> mode")
> Signed-off-by: Jamie Gloudon <jamie.gloudon@gmx.fr>
> ---
>  net/ipv6/ip6_tunnel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
> index 2fb4c6ad7243..22c71f991bb7 100644
> --- a/net/ipv6/ip6_tunnel.c
> +++ b/net/ipv6/ip6_tunnel.c
> @@ -162,7 +162,7 @@ ip6_tnl_lookup(struct net *net, int link,
>  		return cand;
>  
>  	t = rcu_dereference(ip6n->collect_md_tun);
> -	if (t && t->dev->flags & IFF_UP)
> +	if (t && (t->dev->flags & IFF_UP))

While this change makes is less ambiguous for reader, the C precedence
rules are clear and & evaluated before &&.
https://en.cppreference.com/w/c/language/operator_precedence

There is nothing to fix here.

Thanks

>  		return t;
>  
>  	t = rcu_dereference(ip6n->tnls_wc[0]);
> -- 
> 2.28.0
> 
