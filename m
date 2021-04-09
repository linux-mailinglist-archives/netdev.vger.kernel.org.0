Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41330359B71
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 12:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234299AbhDIKLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 06:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233655AbhDIKJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 06:09:02 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289CDC0613D8
        for <netdev@vger.kernel.org>; Fri,  9 Apr 2021 03:08:16 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id f6so5046872wrv.12
        for <netdev@vger.kernel.org>; Fri, 09 Apr 2021 03:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Z0HP6AGB3zX2DMSpA12fV8eEEsWxW+4w6oYqNaThfbw=;
        b=aQGw9eUQKZnhBhK71BZ04lLPYEDgCMkrxDvyW7A9fDyK77Mp3jft2rPPFrdavpZ8Eu
         vBlnqpsNGiLDYlD8EDs/qM1AIUrTG7SiT4VgIEoivXqEsVmYs/6JcGdyoQZQokIY6SBe
         YyQy9tlIng2EqblTr880frmqQ8cVP1aZ916FB9FqecROnOxgwgUZA3bjyGBWXRlZSuz6
         jYy/GzKgGTGHG44LAhcLfEb8YPd3CMtLVxbTNyMgeRGYhqG8Q3rNBrMbirPiC/tvKO/h
         NoVNEceRIqS4U82P1nLnAVrxcJynpNsn1F05KCvsWQAfMf1nMrg0mmoTDSz3y1AvgTT6
         zBAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z0HP6AGB3zX2DMSpA12fV8eEEsWxW+4w6oYqNaThfbw=;
        b=UtfgP8t8hmydm+gw/dsZuyQaW6THz6WPgY7ChgwjqbhbfHO1siZS6dfiHxVGi2vjan
         aRjEFLi57LkEBKqFR1d/pKzpcwHPZx+9zOHK++QqrQaIftyTJnXLxWI3aW4Ai9bCAI9c
         sR+Syr8AG/NWmUYUCelNRnI8Jx888ChKPAYPPLgK4VGzz0Jg7Ld3XNWsbl5szuJ07KGk
         NqXLlbomodbW0dvBGfOW1rl2xkFEOk9xjwDm5nZE+Ur2+9qdQQSPKkdo9SitgfKz+98a
         SpWZkSspM5/TeaPNdVEsMpdwtsyvhs4whdLL29eS6/vUFv/VPGLMVnvjhvG0yo5rjg8M
         Oe8g==
X-Gm-Message-State: AOAM533wkOu7crTqN48QVb+GrB91QywCZSYc7kfZh+ozyxZRdlTSc8BC
        cjse9BXcRG5X5/dcmBurtIg=
X-Google-Smtp-Source: ABdhPJxff1h7EwX3Sluolh5fI+n6eCiLGaocU1rW8iNtDZJhKVEQ1pMX++3yNMr5HWfi1wY0uKN2wg==
X-Received: by 2002:a5d:6acf:: with SMTP id u15mr16766312wrw.392.1617962894613;
        Fri, 09 Apr 2021 03:08:14 -0700 (PDT)
Received: from [192.168.1.101] ([37.167.116.29])
        by smtp.gmail.com with ESMTPSA id f8sm3680503wro.29.2021.04.09.03.08.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Apr 2021 03:08:14 -0700 (PDT)
Subject: Re: [PATCH net] net: fix hangup on napi_disable for threaded napi
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        "David S. Miller" <davem@davemloft.net>
References: <996c4bb33166b5cf8d881871ea8b61e54ad4da24.1617230551.git.pabeni@redhat.com>
 <20210331184137.129fc965@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <9f6c5d92f1bd2e480e762a7c724d7b583988f0de.camel@redhat.com>
 <20210401164415.6426d19c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <2254885d747833eaf2b4461cd1233551140f644a.camel@redhat.com>
 <20210407111318.39c2374d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <7ff0f0e6027c3b84b0d0e1d58096392bfc0fe806.camel@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a7612caa-e375-0786-c39e-8d6581881ec7@gmail.com>
Date:   Fri, 9 Apr 2021 12:08:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <7ff0f0e6027c3b84b0d0e1d58096392bfc0fe806.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/9/21 11:24 AM, Paolo Abeni wrote:
> On Wed, 2021-04-07 at 11:13 -0700, Jakub Kicinski wrote:
>> On Wed, 07 Apr 2021 16:54:29 +0200 Paolo Abeni wrote:
>>>>> I think in the above example even the normal processing will be
>>>>> fooled?!? e.g. even without the napi_disable(), napi_thread_wait() will
>>>>>  will miss the event/will not understand to it really own the napi and
>>>>> will call schedule().
>>>>>
>>>>> It looks a different problem to me ?!?
>>>>>
>>>>> I *think* that replacing inside the napi_thread_wait() loop:
>>>>>
>>>>> 	if (test_bit(NAPI_STATE_SCHED_THREADED, &napi->state) || woken) 
>>>>>
>>>>> with:
>>>>>
>>>>> 	unsigned long state = READ_ONCE(napi->state);
>>>>>
>>>>> 	if (state & NAPIF_STATE_SCHED &&
>>>>> 	    !(state & (NAPIF_STATE_IN_BUSY_POLL | NAPIF_STATE_DISABLE)) 
>>>>>
>>>>> should solve it and should also allow removing the
>>>>> NAPI_STATE_SCHED_THREADED bit. I feel like I'm missing some relevant
>>>>> point here.  
>>>>
>>>> Heh, that's closer to the proposal Eric put forward.
>>>>
>>>> I strongly dislike   
>>>
>>> I guess that can't be addressed ;)
>>
>> I'm not _that_ unreasonable, I hope :) if there is multiple people
>> disagreeing with me then so be it.
> 
> I'm sorry, I mean no offence! Just joking about the fact that is
> usually hard changing preferences ;)
> 
>>> If you have strong opinion against the above, the only other option I
>>> can think of is patching napi_schedule_prep() to set
>>> both NAPI_STATE_SCHED and NAPI_STATE_SCHED_THREADED if threaded mode is
>>> enabled for the running NAPI. That looks more complex and error prone,
>>> so I really would avoid that.
>>>
>>> Any other better option?
>>>
>>> Side note: regardless of the above, I think we still need something
>>> similar to the code in this patch, can we address the different issues
>>> separately?
>>
>> Not sure what issues you're referring to.
> 
> The patch that started this thread was ment to address a slightly
> different race: napi_disable() hanging because napi_threaded_poll()
> don't clear the NAPI_STATE_SCHED even when owning the napi instance.
> 
>> Right, I think the problem is disable_pending check is out of place.
>>
>> How about this:
>>
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index 9d1a8fac793f..e53f8bfed6a1 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -7041,7 +7041,7 @@ static int napi_thread_wait(struct napi_struct *napi)
>>  
>>         set_current_state(TASK_INTERRUPTIBLE);
>>  
>> -       while (!kthread_should_stop() && !napi_disable_pending(napi)) {
>> +       while (!kthread_should_stop()) {
>>                 /* Testing SCHED_THREADED bit here to make sure the current
>>                  * kthread owns this napi and could poll on this napi.
>>                  * Testing SCHED bit is not enough because SCHED bit might be
>> @@ -7049,8 +7049,14 @@ static int napi_thread_wait(struct napi_struct *napi)
>>                  */
>>                 if (test_bit(NAPI_STATE_SCHED_THREADED, &napi->state) || woken) {
>>                         WARN_ON(!list_empty(&napi->poll_list));
>> -                       __set_current_state(TASK_RUNNING);
>> -                       return 0;
>> +                       if (unlikely(napi_disable_pending(napi))) {
>> +                               clear_bit(NAPI_STATE_SCHED, &napi->state);
>> +                               clear_bit(NAPI_STATE_SCHED_THREADED,
>> +                                         &napi->state);
>> +                       } else {
>> +                               __set_current_state(TASK_RUNNING);
>> +                               return 0;
>> +                       }
>>                 }
>>  
>>                 schedule();
> 
> It looks like the above works, and also fixes the problem I originally
> reported. 
> 
> I think it can be simplified as the following - if NAPIF_STATE_DISABLE
> is set, napi_threaded_poll()/__napi_poll() will return clearing the
> SCHEDS bits after trying to poll the device:
> 
> ---
> diff --git a/net/core/dev.c b/net/core/dev.c
> index d9db02d4e044..5cb6f411043d 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6985,7 +6985,7 @@ static int napi_thread_wait(struct napi_struct *napi)
>  
>         set_current_state(TASK_INTERRUPTIBLE);
>  
> -       while (!kthread_should_stop() && !napi_disable_pending(napi)) {
> +       while (!kthread_should_stop()) {
>                 /* Testing SCHED_THREADED bit here to make sure the current
>                  * kthread owns this napi and could poll on this napi.
>                  * Testing SCHED bit is not enough because SCHED bit might be
> 
> ---
> 
> And works as intended here. I'll submit that formally, unless there are
> objection.
> 

This looks much better ;)

> Thanks!
> 
> Paolo
>>
> 
