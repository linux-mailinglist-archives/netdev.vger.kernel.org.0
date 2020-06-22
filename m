Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEF7204479
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 01:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730388AbgFVXaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 19:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728131AbgFVXaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 19:30:35 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86084C061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 16:30:32 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id p20so19660647ejd.13
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 16:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NnKhqYDwdzKABY0fW9cWBUMG5e2OlFBhpq67Z/KPCP8=;
        b=YPyiYI8ZCyGHZ59ZDDaZMTKZDSZ7JIlDbDKruxd0ft9ZjkYqb48EqqJjn1ySA6XjQe
         7/hQHW7lG5okeWmYWFZ8BRtGxhU69bf2Bg5G7SeD1dst8xIKpPgP+bk2vXbTWeSu8JNH
         XQc+w7bfaAkdB3KF09sN5DhppbRfKnnUXGlGpLIMxfvqqwm78TLx0xQWKuHr/Pr5cxGy
         YfRLtkHa+Mxf7fGGFmFbsp2kkKkR2l5xnL/NWqDo9l6cjvIztfv6ECQlNiImBCPWVoXQ
         MlH+rePxhF7EsgLUeWqkK54EYBpqexPraWKOlqIRdtT6knVpc9CSoP1VVS6Tl/CkRQTj
         Rkjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NnKhqYDwdzKABY0fW9cWBUMG5e2OlFBhpq67Z/KPCP8=;
        b=VB79FxkZHaA6Yqed/A1Rp3NNLDR1QF8RXGUPa645e8g9krLhbX9P25+Ulu8eoy9VoB
         a4nfZTY1jj/9DGznwTXv4RZIlSm3tI7iB37aHybBXZplbLwvIQjGkvgMN/zNGcqU68Hk
         ru8WJMW4SQf3/Zs+yzz1OLURS8XEUg6qjOhzpzsJ2/Ry+iQDFUZ/jr4rTV0CCKGXHu35
         uz5s8nfLeityeIxee6EuOy4PpYuvu+2dIW0u8dpCb66SwVPvjhP1gMii6WsJOoM0i6/G
         /QT3XAZQ6QQaTqSF5yd/TgDLvxV/fc6rHV67DDoi0T3626OhONnlzX4Lq3Qy1w9zzAVu
         Mrlw==
X-Gm-Message-State: AOAM531OEeC1b4/Hp+Z5cPcra9ff9mAxG6EOeK5PHIBnP13Kka1i0Pv7
        WXQ2xiWMHGpE3LTJJ4rxnZw=
X-Google-Smtp-Source: ABdhPJxah0ASnaf4D9C3UhwQRY7ESvAZzOGgk1Pd6h7rqi2Yzez0D4HSfd5GLuAhIdE99Glnt4A2cQ==
X-Received: by 2002:a17:906:958f:: with SMTP id r15mr3970800ejx.77.1592868631091;
        Mon, 22 Jun 2020 16:30:31 -0700 (PDT)
Received: from ?IPv6:2a02:8071:21c1:4200:5089:20ae:4811:8fc? ([2a02:8071:21c1:4200:5089:20ae:4811:8fc])
        by smtp.gmail.com with ESMTPSA id cd17sm12554909ejb.115.2020.06.22.16.30.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 16:30:30 -0700 (PDT)
Subject: Re: [PATCH] IPv6: Fix CPU contention on FIB6 GC
To:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
References: <20200622205355.GA869719@tws>
 <32da6a56-0217-acda-c12c-49f7c74275ef@gmail.com>
From:   Oliver Herms <oliver.peter.herms@gmail.com>
Message-ID: <3230b95a-1ce0-b569-3d00-f7063ae9f1d9@gmail.com>
Date:   Tue, 23 Jun 2020 01:30:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <32da6a56-0217-acda-c12c-49f7c74275ef@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.06.20 00:55, Eric Dumazet wrote:
> 
> 
> On 6/22/20 1:53 PM, Oliver Herms wrote:
>> When fib6_run_gc is called with parameter force=true the spinlock in
>> /net/ipv6/ip6_fib.c:2310 can lock all CPUs in softirq when
>> net.ipv6.route.max_size is exceeded (seen this multiple times).
>> One sotirq/CPU get's the lock. All others spin to get it. It takes
>> substantial time until all are done. Effectively it's a DOS vector.
>>
>> As the splinlock is only enforcing that there is at most one GC running
>> at a time, it should IMHO be safe to use force=false here resulting
>> in spin_trylock_bh instead of spin_lock_bh, thus avoiding the lock
>> contention.
>>
>> Finding a locked spinlock means some GC is going on already so it is
>> save to just skip another execution of the GC.
>>
>> Signed-off-by: Oliver Herms <oliver.peter.herms@gmail.com>
>> ---
>>  net/ipv6/route.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
>> index 82cbb46a2a4f..7e6fbaf43549 100644
>> --- a/net/ipv6/route.c
>> +++ b/net/ipv6/route.c
>> @@ -3205,7 +3205,7 @@ static int ip6_dst_gc(struct dst_ops *ops)
>>  		goto out;
>>  
>>  	net->ipv6.ip6_rt_gc_expire++;
>> -	fib6_run_gc(net->ipv6.ip6_rt_gc_expire, net, true);
>> +	fib6_run_gc(net->ipv6.ip6_rt_gc_expire, net, false);
>>  	entries = dst_entries_get_slow(ops);
>>  	if (entries < ops->gc_thresh)
>>  		net->ipv6.ip6_rt_gc_expire = rt_gc_timeout>>1;
> 
> 
Hi Eric,

> On which kernel have you seen a contention ?
I've freshly checked out from here:
staging-testing@git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git 

Reproduced my issue I've encountered with 4.15 (from Ubuntu) in prod, 
applied the patch, checked that it solves my problem.

I'm encountering the issues due to cache entries that are created by 
tnl_update_pmtu. However, I'm going to address that issue in another thread
and patch.

As entries in the cache can be caused on many ways this should be fixed on the GC
level.

> 
> I am asking this because I recently pushed a patch that basically should have
> been enough to take care of the problem.
> 
> commit d8882935fcae28bceb5f6f56f09cded8d36d85e6
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Fri May 8 07:34:14 2020 -0700
> 
>     ipv6: use DST_NOCOUNT in ip6_rt_pcpu_alloc()
> 
I've checked: Your patch was in when I tested in the lab today.
as well.

Kind Regards
Oliver
