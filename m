Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F843B1C61
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 16:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbhFWO1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 10:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbhFWO1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 10:27:40 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FC0C061574
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 07:25:22 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id p10-20020a05600c430ab02901df57d735f7so4116102wme.3
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 07:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wu1QJVWkASr8HYvQ5u7lWWnDN6nQgSr3pnYJZYH4XWE=;
        b=dFwnvNW1lKHQhOLIrtgk/gASSgxPS6JMAtuyHXqCMD/D4B+ja6FoSSL6Z/DlFzP2ON
         HMgAUAJpeyiu1T9eP1UHnok+jMGgQjXRPyAqTIURkOquQpuJltXqQm6QMeWK0mDqg2or
         dvLX0rN87vxNg+qLHHfGx9ZSAocqyBDAfnIHxwiga42ZyKLWI70ijKA70BEgi0RYPpo7
         E+uJwrZxTIa42WSP23bZbd2URxD1mFWm2mkULXHUfxis7teDxdlJau2NcmEQfQk4bgve
         1DHs7g+qzRZQPREUogG3EZ25USnC7t6fYy30+m3pwbLPendbQNXTdt/gh6MB67bRL5DU
         oBiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wu1QJVWkASr8HYvQ5u7lWWnDN6nQgSr3pnYJZYH4XWE=;
        b=ADrsTI3mN+QtrKcfBFsS1ZYKRrox37OtRIxZpK38Ybh2nxk++29SrPkkYFXVK5QTuD
         10oKb1SBJRxk45oNGGdS3D9RVBykRneKb/Ln+UEZUeNAXQApwIqsHGtbGHl1YeuSkEl7
         P4NO3yp3g9T2akk44STVQIC9iZXOsb/MtPNof5IVg/pRJoeaF4WVIoV5IO0C40ZzGo6R
         NOATYeuHq1Uf9iuezqJaRcL0i0KnHTPG8THY0pZi1MpORpqs7LVm6FiGWXbg5wpGOHZ5
         sQNagTt9zLIaDwhI3X2RHWRbuKFD7w0pn3bawMSMrU5jOhdQkQCK9N9GjNgwCnFrj+x+
         rtUA==
X-Gm-Message-State: AOAM533CpWnu12wScCkXJxtzkjMZ/Ctvlkl0SQ4RtkmIizp67njbrxjt
        fTskRJbWRIB1WBOxfV7CiwY=
X-Google-Smtp-Source: ABdhPJz7QyMSB7c7TPocj3F5tpu1n4L96dTr+MX0NlYtd+r023dGfPSOY91PeGWf6dmX8aaucI92lA==
X-Received: by 2002:a1c:183:: with SMTP id 125mr11116793wmb.160.1624458321152;
        Wed, 23 Jun 2021 07:25:21 -0700 (PDT)
Received: from [192.168.98.98] (8.249.23.93.rev.sfr.net. [93.23.249.8])
        by smtp.gmail.com with ESMTPSA id n8sm153905wrt.95.2021.06.23.07.25.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 07:25:20 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/2] net: ip: avoid OOM kills with large UDP
 sends over loopback
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, willemb@google.com, eric.dumazet@gmail.com,
        dsahern@gmail.com, yoshfuji@linux-ipv6.org, Dave Jones <dsj@fb.com>
References: <20210622225057.2108592-1-kuba@kernel.org>
 <20210622225057.2108592-2-kuba@kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <11f88247-3193-bae4-39e5-03a5672578f9@gmail.com>
Date:   Wed, 23 Jun 2021 16:25:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210622225057.2108592-2-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/23/21 12:50 AM, Jakub Kicinski wrote:
> Dave observed number of machines hitting OOM on the UDP send
> path. The workload seems to be sending large UDP packets over
> loopback. Since loopback has MTU of 64k kernel will try to
> allocate an skb with up to 64k of head space. This has a good
> chance of failing under memory pressure. What's worse if
> the message length is <32k the allocation may trigger an
> OOM killer.
> 
> This is entirely avoidable, we can use an skb with frags.

Are you referring to IP fragments, or page frags ?

> 
> af_unix solves a similar problem by limiting the head
> length to SKB_MAX_ALLOC. This seems like a good and simple
> approach. It means that UDP messages > 16kB will now
> use fragments if underlying device supports SG, if extra
> allocator pressure causes regressions in real workloads
> we can switch to trying the large allocation first and
> falling back.
> 
> Reported-by: Dave Jones <dsj@fb.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/ipv4/ip_output.c  | 2 +-
>  net/ipv6/ip6_output.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index 90031f5446bd..1ab140c173d0 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -1077,7 +1077,7 @@ static int __ip_append_data(struct sock *sk,
>  
>  			if ((flags & MSG_MORE) && !has_sg)
>  				alloclen = mtu;
> -			else if (!paged)
> +			else if (!paged && (fraglen < SKB_MAX_ALLOC || !has_sg))

This looks indeed better, but there are some boundary conditions,
caused by the fact that we add hh_len+15 later when allocating the skb.

(I expect hh_len+15 being 31)


You probably need 
	else if (!paged && (fraglen + hh_len + 15 < SKB_MAX_ALLOC || !has_sg))

Otherwise we might still attempt order-3 allocations ?

SKB_MAX_ALLOC is 16064 currently (skb_shinfo size being 320 on 64bit arches)

An UDP message with 16034 bytes of payload would translate to
alloclen==16062. If we add 28 bytes for UDP+IP headers, plus 31 bytes for hh_len+31
this would go to 16413, thus asking for 32768 bytes (order-3 page)

(16062+320 = 16382, which is smaller than 16384)


>  				alloclen = fraglen;
>  			else {
>  				alloclen = min_t(int, fraglen, MAX_HEADER);
> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> index c667b7e2856f..46d805097a79 100644
> --- a/net/ipv6/ip6_output.c
> +++ b/net/ipv6/ip6_output.c
> @@ -1585,7 +1585,7 @@ static int __ip6_append_data(struct sock *sk,
>  
>  			if ((flags & MSG_MORE) && !has_sg)
>  				alloclen = mtu;
> -			else if (!paged)
> +			else if (!paged && (fraglen < SKB_MAX_ALLOC || !has_sg))
>  				alloclen = fraglen;
>  			else {
>  				alloclen = min_t(int, fraglen, MAX_HEADER);
> 
