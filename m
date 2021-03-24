Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21C8D347631
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 11:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235833AbhCXKfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 06:35:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:58344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233398AbhCXKe5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 06:34:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17E3361A01;
        Wed, 24 Mar 2021 10:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616582096;
        bh=9Z2UIME5BPL9q3dzEzV84xwr0G+Ct4YPKT5HcX86PpE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OYjKAX2+aM0uhO5qQz0EdEf+Te7ComRwLmBsS2aTdvvnBX3xLOFY2Lp2DI9arPHPW
         SpMgjEEAVfkQZ1yQzZaHZOm4J26olsj8Olr7nkAJ3v2/W5/vcwft/3HV+SDKgC9xBC
         aDPoUz1j8pkGvCOPL+4l9X1Ta4y6tjuX2d8+39xNMO5YTuV3tpMPNpbaTfdxvcURrY
         YiTTFjtneDk2z8OnoXnDtjtdtnUcTuNed5x24yIJpEKRRPmrhaIBzgN9C7+uDUANWY
         SbfQJ3o8h0e6/xEkuDfhglpQsRPQ4QI+HYT7db4WSa3SZ9Bsk5pFtLns9iLL8omTef
         rwH3SF+2UWgVg==
Date:   Wed, 24 Mar 2021 12:34:52 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Yejune Deng <yejune.deng@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yejune@gmail.com
Subject: Re: [PATCH 1/2] net: ipv4: route.c: add likely() statements
Message-ID: <YFsVzP6P9l0aaIVo@unreal>
References: <20210324030923.17203-1-yejune.deng@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324030923.17203-1-yejune.deng@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 11:09:22AM +0800, Yejune Deng wrote:
> Add likely() statements in ipv4_confirm_neigh() for 'rt->rt_gw_family
> == AF_INET'.

Why? Such macros are beneficial in only specific cases, most of the time,
likely/unlikely is cargo cult.

> 
> Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
> ---
>  net/ipv4/route.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index fa68c2612252..5762d9bc671c 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -440,7 +440,7 @@ static void ipv4_confirm_neigh(const struct dst_entry *dst, const void *daddr)
>  	struct net_device *dev = dst->dev;
>  	const __be32 *pkey = daddr;
>  
> -	if (rt->rt_gw_family == AF_INET) {
> +	if (likely(rt->rt_gw_family == AF_INET)) {
>  		pkey = (const __be32 *)&rt->rt_gw4;
>  	} else if (rt->rt_gw_family == AF_INET6) {
>  		return __ipv6_confirm_neigh_stub(dev, &rt->rt_gw6);
> -- 
> 2.29.0
> 
