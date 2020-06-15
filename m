Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDBC21F9C7A
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 18:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730213AbgFOQCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 12:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729772AbgFOQCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 12:02:31 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8667BC061A0E
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 09:02:30 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id s88so32466pjb.5
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 09:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dJUhvyO//lHGqMFFO734EEKu/lbY5z8+byYaLy11KBs=;
        b=UEBS9zVp1Jt7sG3z97db4npV7uDa2IfCMtTaJ9k3naN0yscYbBRM4wT/vxI5nuW9HA
         KLqmsVzl33AR1j1cVEJL650LZspDW+FKyxtLlKYnfTBfmm65sPLjGTX4GVTD2kP9jRYX
         Mm65LtAfeDPsPESA/mhKGj+YfI3Uky4kKy1a21y9+BKen1JJ5HytDcZC592zXl4Qg0Ic
         cDmzTU2k7RYL//PMmpZPnGldxkQuN0qBC0UchvvNVpx3tQS59SeKYkdQM8t5rEe6/6//
         p5FZwhfpLaRh+h1k1T3ak7236aViEKNvHtBINnfFekZ3hkJOxhOTWS2WHsVCa9uw/geY
         6Ucw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dJUhvyO//lHGqMFFO734EEKu/lbY5z8+byYaLy11KBs=;
        b=X/O1GIe2F+UyBlklmPxRZTJA91JkKj8alGtj/hW44FMV0IrkP1CbsHfJmcwlya+SGG
         qUwz5+5CvAmvNMg36sZZRQJazVj2gDRCbupCSh310rXGKJRDItkKO8crhuJTC8utjzVG
         jcwWUVF3u9QXYfuf2d0umw98eyZd1bfvWY9wIUPBP3r4xd9XKVf9AtixeFBFnPVfxN6o
         qqtsp80siC+ElrD9bcK6th/QzIKFIJ+HVZP95PoWUgVfjbgLrm3RDWHxV8bHQurvww6w
         oyUkoRFFiG9lI2BqxYWUDMgmBxzD3TdYg9jxqaBPINTMEFNH0NyP6MpNnTroH1ngWqiL
         pf5g==
X-Gm-Message-State: AOAM530bgpsW/GuRklQIiroYUu7V+omJUz6LZNV3VnhDhJNo4MCrm6xb
        yimwYgI6FbXgh5ypvPwRMn4=
X-Google-Smtp-Source: ABdhPJyjYpdem7br9LJh8IlogUwnfzsDb5wKdnrh/Nk39bL5HbwG4DeSXOA5LIRaTJebQAAqfZBgGg==
X-Received: by 2002:a17:90b:190e:: with SMTP id mp14mr23775pjb.198.1592236949484;
        Mon, 15 Jun 2020 09:02:29 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id m7sm12560167pgg.69.2020.06.15.09.02.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2020 09:02:28 -0700 (PDT)
Subject: Re: [PATCH net] ip_tunnel: fix use-after-free in ip_tunnel_lookup()
To:     Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Cc:     pshelar@nicira.com
References: <20200615150613.21698-1-ap420073@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e879112d-3285-d6d8-457b-2ae2f8d38aaf@gmail.com>
Date:   Mon, 15 Jun 2020 09:02:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200615150613.21698-1-ap420073@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/15/20 8:06 AM, Taehee Yoo wrote:
> In the datapath, the ip_tunnel_lookup() is used and it internally uses
> fallback tunnel device pointer, which is fb_tunnel_dev.
> This pointer is protected by RTNL. It's not enough to be used
> in the datapath.
> So, this pointer would be used after an interface is deleted.
> It eventually results in the use-after-free problem.
> 
> In order to avoid the problem, the new tunnel pointer variable is added,
> which indicates a fallback tunnel device's tunnel pointer.
> This is protected by both RTNL and RCU.
> So, it's safe to be used in the datapath.
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
> Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
>  include/net/ip_tunnels.h |  1 +
>  net/ipv4/ip_tunnel.c     | 11 ++++++++---
>  2 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
> index 076e5d7db7d3..7442c517bb75 100644
> --- a/include/net/ip_tunnels.h
> +++ b/include/net/ip_tunnels.h
> @@ -164,6 +164,7 @@ struct ip_tunnel_net {
>  	struct rtnl_link_ops *rtnl_link_ops;
>  	struct hlist_head tunnels[IP_TNL_HASH_SIZE];
>  	struct ip_tunnel __rcu *collect_md_tun;
> +	struct ip_tunnel __rcu *fb_tun;
>  	int type;
>  };
>  
> diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
> index f4f1d11eab50..285b863e2fcc 100644
> --- a/net/ipv4/ip_tunnel.c
> +++ b/net/ipv4/ip_tunnel.c
> @@ -162,8 +162,9 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
>  	if (t && t->dev->flags & IFF_UP)
>  		return t;
>  
> -	if (itn->fb_tunnel_dev && itn->fb_tunnel_dev->flags & IFF_UP)
> -		return netdev_priv(itn->fb_tunnel_dev);
> +	t = rcu_dereference(itn->fb_tun);
> +	if (t && t->dev->flags & IFF_UP)
> +		return t;
>  

There is no need for a new variable.

Your patch does not add any new rcu grace period, so it seems obvious that you
relied on existing grace periods.

The real question is why ip_tunnel_uninit() does not clear itn->fb_tunnel_dev

And of course why ip_tunnel_lookup() does not a READ_ONCE()

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index f4f1d11eab502290f9d74e2c8aafd69bceb58763..2416aa33d3645e1da967ec4c914564c5727a4d80 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -87,6 +87,7 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
 {
        unsigned int hash;
        struct ip_tunnel *t, *cand = NULL;
+       struct net_device *ndev;
        struct hlist_head *head;
 
        hash = ip_tunnel_hash(key, remote);
@@ -162,8 +163,9 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
        if (t && t->dev->flags & IFF_UP)
                return t;
 
-       if (itn->fb_tunnel_dev && itn->fb_tunnel_dev->flags & IFF_UP)
-               return netdev_priv(itn->fb_tunnel_dev);
+       ndev = READ_ONCE(itn->fb_tunnel_dev);
+       if (ndev && ndev->flags & IFF_UP)
+               return netdev_priv(ndev);
 
        return NULL;
 }




