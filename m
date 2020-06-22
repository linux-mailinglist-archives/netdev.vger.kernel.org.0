Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 463FF204419
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 00:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731249AbgFVWzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 18:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730785AbgFVWzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 18:55:23 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4F9C061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 15:55:23 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id j4so8239959plk.3
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 15:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=atEJQhpAHyQXPxp4uVh+6Q5k2xbBPtBNLwPduVp+vR0=;
        b=tsRx3VTr+TctPfwhc5TLf1RbphfdMuS9QI/umggJrAwvfvdzqB+3Rixaz8XzDVsCbh
         UTuijgHAJFxh7YF17y8FjCO7xo09F9iqI4SquioHZ1CmACgWS5yLhclVCY7/tO1EpqIz
         Nj0MwbhvU9hsjuacjq1RAmr7GQ5fEbNKeavVX+s2GVyGdF2wB8t+1pJrPl77HrPoVhGT
         k1T+rzNDn0olUeJOPH60P0YCqPNFvzvoMp8Bu/t2k8HN5s+o0ptW2R392d7lNvznlrmN
         f5UF3zTF1K68X5YZA4/doIzBlyMZ/WwTYpjuTtQ0c3kY1LUHNlfivliLluVzQ1FW22aO
         JKFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=atEJQhpAHyQXPxp4uVh+6Q5k2xbBPtBNLwPduVp+vR0=;
        b=ZJf9eBxHB0yIyIzo6Ad9wPCMom7kgEbKoLffq58aj5PFBUb/CWPuooFfAFCj+jRUoC
         MUJEdV61aBHtb6dTGVl/dKKENthiAiSZapq4pMxprcd3yEu/MQgia2wv+0+bR5cwizyv
         QAh2oRdpKB7ncQAJioRdj73HEtfT9vzke5Xt8xHqfltuUFL6ksrIPkGbcmChtyiNqVAZ
         HF+fz2aSamfuLlch8oTDIDhujcqG4/XkpOqPWpvqDDtJ9g5TjpublvMdMrUxARixegxX
         tB4rUFPhb2um3fubFQVuNhpKv0YVAdLxX7bFngCUbzK2mNg5FuCd6iRrV6/EknpR5DRv
         GwDA==
X-Gm-Message-State: AOAM5319ovQYuihZY4EM2Ho1nawe8KlrODx1mXmWtiugjp73L5E+Np+P
        bdopH3Ptxyv0Mp7uHgCTOlw=
X-Google-Smtp-Source: ABdhPJykgRs1KiCie9/Mfuvw7tJ20SXwJFY6C8CzApyVe97wyq6FBv4udX90DpwXWzYppN1dBjbMaw==
X-Received: by 2002:a17:90a:a40b:: with SMTP id y11mr21566154pjp.54.1592866523316;
        Mon, 22 Jun 2020 15:55:23 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id d2sm11759123pgp.56.2020.06.22.15.55.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 15:55:22 -0700 (PDT)
Subject: Re: [PATCH] IPv6: Fix CPU contention on FIB6 GC
To:     Oliver Herms <oliver.peter.herms@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
References: <20200622205355.GA869719@tws>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <32da6a56-0217-acda-c12c-49f7c74275ef@gmail.com>
Date:   Mon, 22 Jun 2020 15:55:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200622205355.GA869719@tws>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/22/20 1:53 PM, Oliver Herms wrote:
> When fib6_run_gc is called with parameter force=true the spinlock in
> /net/ipv6/ip6_fib.c:2310 can lock all CPUs in softirq when
> net.ipv6.route.max_size is exceeded (seen this multiple times).
> One sotirq/CPU get's the lock. All others spin to get it. It takes
> substantial time until all are done. Effectively it's a DOS vector.
> 
> As the splinlock is only enforcing that there is at most one GC running
> at a time, it should IMHO be safe to use force=false here resulting
> in spin_trylock_bh instead of spin_lock_bh, thus avoiding the lock
> contention.
> 
> Finding a locked spinlock means some GC is going on already so it is
> save to just skip another execution of the GC.
> 
> Signed-off-by: Oliver Herms <oliver.peter.herms@gmail.com>
> ---
>  net/ipv6/route.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 82cbb46a2a4f..7e6fbaf43549 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -3205,7 +3205,7 @@ static int ip6_dst_gc(struct dst_ops *ops)
>  		goto out;
>  
>  	net->ipv6.ip6_rt_gc_expire++;
> -	fib6_run_gc(net->ipv6.ip6_rt_gc_expire, net, true);
> +	fib6_run_gc(net->ipv6.ip6_rt_gc_expire, net, false);
>  	entries = dst_entries_get_slow(ops);
>  	if (entries < ops->gc_thresh)
>  		net->ipv6.ip6_rt_gc_expire = rt_gc_timeout>>1;


On which kernel have you seen a contention ?

I am asking this because I recently pushed a patch that basically should have
been enough to take care of the problem.

commit d8882935fcae28bceb5f6f56f09cded8d36d85e6
Author: Eric Dumazet <edumazet@google.com>
Date:   Fri May 8 07:34:14 2020 -0700

    ipv6: use DST_NOCOUNT in ip6_rt_pcpu_alloc()
