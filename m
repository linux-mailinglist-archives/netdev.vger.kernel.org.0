Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 289AB1FBB17
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 18:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731877AbgFPQQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 12:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730380AbgFPQQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 12:16:39 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5584FC06174E
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 09:16:39 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id s88so1818337pjb.5
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 09:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qsEbXgCIYCBCLKaFXplMHlizt931I2PdzhHrBl7kETo=;
        b=r9mV8HdspLD2YYvkU19+k9AwGFtAFpS/m8bTd/YKzOMIdh2hlObPrkccTIILYc11Iu
         km4sLCWonz0IvgnFqt2i305obnHUXj456Oc1yupwvrB1a8Hi5iqMPEe4OyvK14LUzQXX
         KzH0xDOykUWxlnMRlUUK4NJ1hkDpFiPd5OKplfzjGQsHytsbTWaBSVozJAxCdWIE84xU
         CuWA7qDlea5o7zyK0+7blRyMwMQIyyyBReAYaFoTLoylBzRLKgQ/G306V5iO8iQGUZZV
         8PNdNQa9zP1rz1vdeceDgYK1sB1y73KV59QGZ8+OafYfjtXDzsdjzQBWFtBG7/YZJpoI
         0WcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qsEbXgCIYCBCLKaFXplMHlizt931I2PdzhHrBl7kETo=;
        b=ouJmp0maLdauLMPovCLh1PfnwK751ao1nxZ469HkrWA9m2qKWKFdTevXPOowD7KT77
         a6DeQjXW5dwi0DR+2B8vZazMZaJ+CHYApa0brtaOXToBtCDOkYuXuZxaAk6uEQfpIXVs
         sMU3H+Ub4WVv99spL9tFqDJARxNQmKcBn9WbMG/eKqEuNY3KI2axxiD4Qa2ME6Jb3DaL
         OPVMcKgsriOQGxfFzYDjRYLUNub1TdcIuCP9RZRL/tjjLkAI/0CnurNle21YAqIlm3wo
         V1V08ZEgpDU+o+2rajrxbsI4OYZA4Pxy0P642hy8hWlw8WjixkByjqqm9Aa5IbSARCAR
         VlYA==
X-Gm-Message-State: AOAM5324qVz6TjFY0nvb+kt/C+rY4E3yKbOXZfDQ2vbJLc6zn0mb6RIY
        5OckAE7toAqX2eOsSeGVmg/7Z7Bb
X-Google-Smtp-Source: ABdhPJw2hM2P9edhnBO4pAaDOgoaiWa6LwjLplaCw3cyzcnMIGlHYMMOTlZIiejeeVgWJparsGOmvA==
X-Received: by 2002:a17:90a:dc0f:: with SMTP id i15mr3407142pjv.221.1592324198822;
        Tue, 16 Jun 2020 09:16:38 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id e128sm4444152pfe.196.2020.06.16.09.16.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2020 09:16:38 -0700 (PDT)
Subject: Re: [PATCH net v2] ip_tunnel: fix use-after-free in
 ip_tunnel_lookup()
To:     Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Cc:     pshelar@nicira.com, eric.dumazet@gmail.com
References: <20200616160153.8479-1-ap420073@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <fd5f2683-caac-6ed1-7da7-11e8fce2fe42@gmail.com>
Date:   Tue, 16 Jun 2020 09:16:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200616160153.8479-1-ap420073@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/16/20 9:01 AM, Taehee Yoo wrote:
> In the datapath, the ip_tunnel_lookup() is used and it internally uses
> fallback tunnel device pointer, which is fb_tunnel_dev.
> This pointer variable should be set to NULL when a fb interface is deleted.
> But there is no routine to set fb_tunnel_dev pointer to NULL.
> So, this pointer will be still used after interface is deleted and
> it eventually results in the use-after-free problem.
> 
> Test commands:
>     ip netns add A
>     ip netns add B
>     ip link add eth0 type veth peer name eth1
>     ip link set eth0 netns A
>     ip link set eth1 netns B
> 
>     ip netns exec A ip link set lo up
>     ip netns exec A ip link set eth0 up
>     ip netns exec A ip link add gre1 type gre local 10.0.0.1 \
> 	    remote 10.0.0.2
>     ip netns exec A ip link set gre1 up
>     ip netns exec A ip a a 10.0.100.1/24 dev gre1
>     ip netns exec A ip a a 10.0.0.1/24 dev eth0
> 
>     ip netns exec B ip link set lo up
>     ip netns exec B ip link set eth1 up
>     ip netns exec B ip link add gre1 type gre local 10.0.0.2 \
> 	    remote 10.0.0.1
>     ip netns exec B ip link set gre1 up
>     ip netns exec B ip a a 10.0.100.2/24 dev gre1
>     ip netns exec B ip a a 10.0.0.2/24 dev eth1
>     ip netns exec A hping3 10.0.100.2 -2 --flood -d 60000 &
>     ip netns del B
> 
> Splat looks like:
> [  133.319668][    C3] BUG: KASAN: use-after-free in ip_tunnel_lookup+0x9d6/0xde0
> [  133.343852][    C3] Read of size 4 at addr ffff8880b1701c84 by task hping3/1222
> [  133.344724][    C3]
> [  133.345002][    C3] CPU: 3 PID: 1222 Comm: hping3 Not tainted 5.7.0+ #591
> [  133.345814][    C3] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [  133.373336][    C3] Call Trace:
> [  133.374792][    C3]  <IRQ>
> [  133.375205][    C3]  dump_stack+0x96/0xdb
> [  133.375789][    C3]  print_address_description.constprop.6+0x2cc/0x450
> [  133.376720][    C3]  ? ip_tunnel_lookup+0x9d6/0xde0
> [  133.377431][    C3]  ? ip_tunnel_lookup+0x9d6/0xde0
> [  133.378130][    C3]  ? ip_tunnel_lookup+0x9d6/0xde0
> [  133.378851][    C3]  kasan_report+0x154/0x190
> [  133.379494][    C3]  ? ip_tunnel_lookup+0x9d6/0xde0
> [  133.380200][    C3]  ip_tunnel_lookup+0x9d6/0xde0
> [  133.380894][    C3]  __ipgre_rcv+0x1ab/0xaa0 [ip_gre]
> [  133.381630][    C3]  ? rcu_read_lock_sched_held+0xc0/0xc0
> [  133.382429][    C3]  gre_rcv+0x304/0x1910 [ip_gre]
> [ ... ]
> 
> Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
> Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
> 
> v1 -> v2:
>  - Do not add a new variable.
> 
>  net/ipv4/ip_tunnel.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
> index f4f1d11eab50..701f150f11e1 100644
> --- a/net/ipv4/ip_tunnel.c
> +++ b/net/ipv4/ip_tunnel.c
> @@ -85,9 +85,10 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
>  				   __be32 remote, __be32 local,
>  				   __be32 key)
>  {
> -	unsigned int hash;
>  	struct ip_tunnel *t, *cand = NULL;
>  	struct hlist_head *head;
> +	struct net_device *ndev;
> +	unsigned int hash;
>  
>  	hash = ip_tunnel_hash(key, remote);
>  	head = &itn->tunnels[hash];
> @@ -162,8 +163,9 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
>  	if (t && t->dev->flags & IFF_UP)
>  		return t;
>  
> -	if (itn->fb_tunnel_dev && itn->fb_tunnel_dev->flags & IFF_UP)
> -		return netdev_priv(itn->fb_tunnel_dev);
> +	ndev = READ_ONCE(itn->fb_tunnel_dev);
> +	if (ndev && ndev->flags & IFF_UP)
> +		return netdev_priv(ndev);
>  
>  	return NULL;
>  }
> @@ -1260,8 +1262,9 @@ void ip_tunnel_uninit(struct net_device *dev)
>  
>  	itn = net_generic(net, tunnel->ip_tnl_net_id);
>  	/* fb_tunnel_dev will be unregisted in net-exit call. */

Is this comment still correct ?

> -	if (itn->fb_tunnel_dev != dev)
> -		ip_tunnel_del(itn, netdev_priv(dev));
> +	ip_tunnel_del(itn, netdev_priv(dev));
> +	if (itn->fb_tunnel_dev == dev)
> +		WRITE_ONCE(itn->fb_tunnel_dev, NULL);
>  
>  	dst_cache_reset(&tunnel->dst_cache);
>  }
> 
