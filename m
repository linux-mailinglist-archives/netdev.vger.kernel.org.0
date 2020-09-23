Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1355C275398
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 10:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgIWIqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 04:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIWIqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 04:46:54 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A05C061755
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 01:46:54 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z4so20065950wrr.4
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 01:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MCuR1LyFiSzxfdFAfVVVzVgwVeTLoxVE83Zm8MIgQro=;
        b=bBZy5YKClex0nUCK8kVURSk3YKexMAuz0I1yl/ahu0Y6SgPEgsywHKIeHjo/0pKK/b
         ydQlMI2pLE5EUjFU30ya6Th4wJDmfvTFprgII1pDyxvs6kZY6cm1lFiHmuj08+8hJB5z
         KLEt4BhUhQmQuB9Q0KmBdais4MR7QZOfdYL0z5YUlnEDctnaYoV9tMXWpdF7Z8pf42Di
         HQTLX6LUyfyBQ4yUzOScKfEYeZlk3t/eu2F4SfM7hxEJzy8YLybUJdRZxtUFnAEVEezm
         XH7mBv65hXUNghVmm/NgPz7hyKlNJn7NQbzl6hiz8B32wrjk6jBkSA4sXx74sfSPmOmp
         M0HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MCuR1LyFiSzxfdFAfVVVzVgwVeTLoxVE83Zm8MIgQro=;
        b=e7VISuIy+3VeYCrLuPYqSyGNXsv/oFiLH/3IrutYIWge9BgPP3+dUrdBdRIlkj/om1
         gYDHQCN0NnB8zIoO/rOXR0HQcIV9S4zQKuqMDt9fKvxkZb92L7fp0zbV9RexD6zfDeVP
         FO6/7cgmKt+krL0BS48wEfo+moT7lWe/Bwp2s/iN4PovKdHbaDDtrNvwRASWZu8LlmoO
         1PAswY6gPHZlrz1dtpGzH1c0+kmuwTUuDXbGdGcCMy7jW4OoOH98B1jORAnUEnsoidCj
         xZ8kQS0ATKucuZJDu73gf9TimGAiuUC3QdZaxQfeSJJI711RAJSkUjn/mFSQTcuJhIh9
         Vftw==
X-Gm-Message-State: AOAM532j4aD44nDOryARR6OkagNfxZWFf4g84iGd2E8YqQDxFJxc4FHl
        FJEHSMp8HY5KzHPi7FyFXpk=
X-Google-Smtp-Source: ABdhPJy7srZrixyfXDmXwlUMgBYsQ+wsn+IMdsSbg9CPOa0vjppdWeQ7ysiTFbGXUryLgGu5lTVqBQ==
X-Received: by 2002:adf:f290:: with SMTP id k16mr10467656wro.124.1600850813107;
        Wed, 23 Sep 2020 01:46:53 -0700 (PDT)
Received: from [192.168.8.147] ([37.164.220.209])
        by smtp.gmail.com with ESMTPSA id a15sm31543784wrn.3.2020.09.23.01.46.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 01:46:52 -0700 (PDT)
Subject: Re: [PATCH v2] net/ipv4: always honour route mtu during forwarding
To:     =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <zenczykowski@gmail.com>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Sunmeet Gill <sgill@quicinc.com>,
        Vinay Paradkar <vparadka@qti.qualcomm.com>,
        Tyler Wear <twear@quicinc.com>,
        David Ahern <dsahern@kernel.org>
References: <CANP3RGcTy5MyAyChUh7pTma60aLcBmOV4kKjh_OnGtBZag-gbg@mail.gmail.com>
 <20200923045143.3755128-1-zenczykowski@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <10fbde1b-f852-2cc1-2e23-4c014931fed8@gmail.com>
Date:   Wed, 23 Sep 2020 10:46:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200923045143.3755128-1-zenczykowski@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/23/20 6:51 AM, Maciej Żenczykowski wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> Documentation/networking/ip-sysctl.txt:46 says:
>   ip_forward_use_pmtu - BOOLEAN
>     By default we don't trust protocol path MTUs while forwarding
>     because they could be easily forged and can lead to unwanted
>     fragmentation by the router.
>     You only need to enable this if you have user-space software
>     which tries to discover path mtus by itself and depends on the
>     kernel honoring this information. This is normally not the case.
>     Default: 0 (disabled)
>     Possible values:
>     0 - disabled
>     1 - enabled
> 
> Which makes it pretty clear that setting it to 1 is a potential
> security/safety/DoS issue, and yet it is entirely reasonable to want
> forwarded traffic to honour explicitly administrator configured
> route mtus (instead of defaulting to device mtu).
> 
> Indeed, I can't think of a single reason why you wouldn't want to.
> Since you configured a route mtu you probably know better...
> 
> It is pretty common to have a higher device mtu to allow receiving
> large (jumbo) frames, while having some routes via that interface
> (potentially including the default route to the internet) specify
> a lower mtu.
> 
> Note that ipv6 forwarding uses device mtu unless the route is locked
> (in which case it will use the route mtu).
> 
> This approach is not usable for IPv4 where an 'mtu lock' on a route
> also has the side effect of disabling TCP path mtu discovery via
> disabling the IPv4 DF (don't frag) bit on all outgoing frames.
> 
> I'm not aware of a way to lock a route from an IPv6 RA, so that also
> potentially seems wrong.
> 
> Signed-off-by: Maciej Żenczykowski <maze@google.com>
> Cc: Eric Dumazet <maze@google.com>

Note that my email address is more like : <edumazet@google.com>

> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Lorenzo Colitti <lorenzo@google.com>
> Cc: Sunmeet Gill (Sunny) <sgill@quicinc.com>
> Cc: Vinay Paradkar <vparadka@qti.qualcomm.com>
> Cc: Tyler Wear <twear@quicinc.com>
> Cc: David Ahern <dsahern@kernel.org>
> ---
>  include/net/ip.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/net/ip.h b/include/net/ip.h
> index b09c48d862cc..c2188bebbc54 100644
> --- a/include/net/ip.h
> +++ b/include/net/ip.h
> @@ -436,12 +436,17 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
>  						    bool forwarding)
>  {
>  	struct net *net = dev_net(dst->dev);
> +	unsigned int mtu;
>  
>  	if (net->ipv4.sysctl_ip_fwd_use_pmtu ||
>  	    ip_mtu_locked(dst) ||
>  	    !forwarding)
>  		return dst_mtu(dst);
>  
> +	/* 'forwarding = true' case should always honour route mtu */
> +	mtu = dst_metric_raw(dst, RTAX_MTU);
> +	if (mtu) return mtu;


        if (mtu)
                return mtu;

Apparently route mtu are capped to 65520, not sure where it is done exactly IP_MAX_MTU being 65535)

# ip ro add 1.1.1.4 dev wlp2s0 mtu 100000
# ip ro get 1.1.1.4
1.1.1.4 dev wlp2s0 src 192.168.8.147 uid 0 
    cache mtu 65520 




> +
>  	return min(READ_ONCE(dst->dev->mtu), IP_MAX_MTU);
>  }
>  
> 
