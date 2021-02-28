Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501C8327552
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 00:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbhB1XlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 18:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbhB1Xk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 18:40:59 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0021DC06174A
        for <netdev@vger.kernel.org>; Sun, 28 Feb 2021 15:40:16 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id o3so16288650oic.8
        for <netdev@vger.kernel.org>; Sun, 28 Feb 2021 15:40:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SPHvJj+IltyPkBB2zTHzUdkBQ7x4D/aaDL80Mdy2Gbk=;
        b=ZodKtt2Te3eK1quPXqtR4kSmqvaQxoSchuhdabhFKVaAkcJ9GolfrkrUm7i290PRzr
         b66bqLAAYloXdanaGffUkGnBkSxulCHGlzPI7dSZF7h79gib4wCtdqd5p2Fvm921OvBn
         rtCH8isPn3HlyofUBLgi5FIqEVeaXtLF2OpLqrf4hUlYYygfaqepnECvsiCD/TQnlNUO
         Ch5ZbVnDPPT24Qd1qveescRShktUiGdKIUszfiWgsjiC5K7kgZvdkn+kBmnUIgSMHSfI
         8oZOvn5g6fHtOe9gLKpBqzir7dkZibV+0lczD0IA1B/CeQ8P3D7ZYIcbhteyFTUefhYm
         y1eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SPHvJj+IltyPkBB2zTHzUdkBQ7x4D/aaDL80Mdy2Gbk=;
        b=VpbiuoUp6F/s1fbH/VJ9iCBGyjcWXer7SJ7D3xK95m2FC93og7Wxpx680NH8/Qg9Yn
         Oqf986YwGA9DHw434RvbUkh65VJn/lZ1ZSzMWmbD4XAfhNuobBfKM/ZmPxeBwnmd/8Dh
         Yr/T/exTIMIqNHD1vYcs6Mn+j1WprjoiKPpylHqAejy5S/gPOM4nVcIlvBD3lmXD32bM
         T8EuLWmw3ZGnyKcc6hW623cmsoJzXmLyGXq1pEj3p6daBDBFRMO3iwbhza12HEvqxQ51
         bPBu5CmNiRM4pCj6BnYCY11VTm9Py15RwanmIdNHeC7DYqKmLK2y+bWLE8C3TVsLXDo/
         DBGw==
X-Gm-Message-State: AOAM533Ll8t25U3t9MuSN4SRXKRU4GxY8a3q+4ybJvm5Ei5AJIKSMvUv
        lEZSzzVf5gAzMtZ5G+//GEo=
X-Google-Smtp-Source: ABdhPJy7lYTipHWmdc6Bt53xXTtrdxrHFd+Y//rULpYd/jfUvab36VAKxumXh4kOjyFa353cTbVX6g==
X-Received: by 2002:aca:4508:: with SMTP id s8mr9810491oia.118.1614555616055;
        Sun, 28 Feb 2021 15:40:16 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.40])
        by smtp.googlemail.com with ESMTPSA id w23sm862411oow.25.2021.02.28.15.40.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Feb 2021 15:40:15 -0800 (PST)
Subject: Re: [RFC PATCH net 1/2] nexthop: Do not flush blackhole nexthops when
 loopback goes down
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        sharpd@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
References: <20210228142613.1642938-1-idosch@idosch.org>
 <20210228142613.1642938-2-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1db96a26-9500-aa3d-16ce-2774e6dcc5f2@gmail.com>
Date:   Sun, 28 Feb 2021 16:40:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210228142613.1642938-2-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/28/21 7:26 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> As far as user space is concerned, blackhole nexthops do not have a
> nexthop device and therefore should not be affected by the
> administrative or carrier state of any netdev.
> 
> However, when the loopback netdev goes down all the blackhole nexthops
> are flushed. This happens because internally the kernel associates
> blackhole nexthops with the loopback netdev.

That was not intended, so definitely a bug.

> 
> This behavior is both confusing to those not familiar with kernel
> internals and also diverges from the legacy API where blackhole IPv4
> routes are not flushed when the loopback netdev goes down:
> 
>  # ip route add blackhole 198.51.100.0/24
>  # ip link set dev lo down
>  # ip route show 198.51.100.0/24
>  blackhole 198.51.100.0/24
> 
> Blackhole IPv6 routes are flushed, but at least user space knows that
> they are associated with the loopback netdev:
> 
>  # ip -6 route show 2001:db8:1::/64
>  blackhole 2001:db8:1::/64 dev lo metric 1024 pref medium
> 
> Fix this by only flushing blackhole nexthops when the loopback netdev is
> unregistered.
> 
> Fixes: ab84be7e54fc ("net: Initial nexthop code")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reported-by: Donald Sharp <sharpd@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> index f1c6cbdb9e43..743777bce179 100644
> --- a/net/ipv4/nexthop.c
> +++ b/net/ipv4/nexthop.c
> @@ -1399,7 +1399,7 @@ static int insert_nexthop(struct net *net, struct nexthop *new_nh,
>  
>  /* rtnl */
>  /* remove all nexthops tied to a device being deleted */
> -static void nexthop_flush_dev(struct net_device *dev)
> +static void nexthop_flush_dev(struct net_device *dev, unsigned long event)
>  {
>  	unsigned int hash = nh_dev_hashfn(dev->ifindex);
>  	struct net *net = dev_net(dev);
> @@ -1411,6 +1411,10 @@ static void nexthop_flush_dev(struct net_device *dev)
>  		if (nhi->fib_nhc.nhc_dev != dev)
>  			continue;
>  
> +		if (nhi->reject_nh &&
> +		    (event == NETDEV_DOWN || event == NETDEV_CHANGE))
> +			continue;
> +
>  		remove_nexthop(net, nhi->nh_parent, NULL);
>  	}
>  }
> @@ -2189,11 +2193,11 @@ static int nh_netdev_event(struct notifier_block *this,
>  	switch (event) {
>  	case NETDEV_DOWN:
>  	case NETDEV_UNREGISTER:
> -		nexthop_flush_dev(dev);
> +		nexthop_flush_dev(dev, event);
>  		break;
>  	case NETDEV_CHANGE:
>  		if (!(dev_get_flags(dev) & (IFF_RUNNING | IFF_LOWER_UP)))
> -			nexthop_flush_dev(dev);
> +			nexthop_flush_dev(dev, event);
>  		break;
>  	case NETDEV_CHANGEMTU:
>  		info_ext = ptr;
> 

LGTM. I suggest submitting without the RFC.

Reviewed-by: David Ahern <dsahern@gmail.com>

