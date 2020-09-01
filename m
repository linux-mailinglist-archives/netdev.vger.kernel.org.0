Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE40258FF1
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 16:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbgIAOMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 10:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728060AbgIANPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 09:15:33 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936A9C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 06:15:29 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id c18so1474929wrm.9
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 06:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=24FG4PvxKggIOyK67TT7GbyMlfDItXfYvkk1ObP+VQg=;
        b=BTI96C8J3qVsYQhSlVt9K1T+D75D5ijzpNBcgBK1XUSLO4HwDXr+UZVVblcfeQ/4nj
         XlAMhtmw7m1oZFSw179KMSqJ3Nz5rokiNWwTclVlVp/ouDAr/YE2W4uQSH+zzK9WZSBP
         8l34ZmBrYIflbVhao8G6PUPxx+HfWhfn5SxsrGqMQgOIimB9/DypVkrUPk6cqppeS6Ka
         zVcPO8p9Lz+OQ1xwJwnTPAF6nBwevCnWZhv+9h0Ahi0CNSUKlt0bCuXSCqNtA5S+aOA4
         /3HGYa8Sna5FFqnPd8As32ZWnS9cL/PS614btxkog+lkSX8+48BM0Ds9dm2n1JY6+1V5
         djJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=24FG4PvxKggIOyK67TT7GbyMlfDItXfYvkk1ObP+VQg=;
        b=PXQqNRCJvXT4BFea4KK2yaIoxPRc3seXx4LBK7ES9xhiBN0PyLzM+7p7tzhbje2HXV
         VDFyYdvwz7dMbHjF0YfDILzvrfVAX+vaAuECcoAvD5tUxj17SWEgtWWlHt0kJqD7Cucn
         8lJA70FEQkikbulvn6WazLQ6GLdWsFs9TFdwkiVyT8oXJ7s8fSwRT/O5QUqPHpg/Yp9F
         GHLi+KHGSFHtsrul3U44JPTCzQcmBsrYCLHN5/vrkY8zZYfG181wkhTvZnFCtSCY+Zry
         UJBfPTpTPuZiZIZIwbhWX3XlyVjDcpdRUNbJN0+C2WVib2B4PStYqVVswTlgFlclvmcN
         kWQQ==
X-Gm-Message-State: AOAM531n+j7KZtYi7jgdOwIFOTVTB0Vc2Yvlf146n1bKf7Ev5KbuvjBF
        LUoOTAx8ROPk05KtjcbneaA=
X-Google-Smtp-Source: ABdhPJyARFLQmGft+cAfqJgrHfM13mndz2AmrLyMYuWyXEKvZtvvePLA/7K1ZN2W1D9N0mqfj917Pw==
X-Received: by 2002:adf:80cb:: with SMTP id 69mr1959368wrl.313.1598966124586;
        Tue, 01 Sep 2020 06:15:24 -0700 (PDT)
Received: from [192.168.8.147] ([37.171.241.11])
        by smtp.gmail.com with ESMTPSA id c9sm1847346wmf.3.2020.09.01.06.15.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 06:15:23 -0700 (PDT)
Subject: Re: [net] tipc: fix using smp_processor_id() in preemptible
To:     Tuong Tong Lien <tuong.t.lien@dektech.com.au>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jmaloy@redhat.com" <jmaloy@redhat.com>,
        "maloy@donjonn.com" <maloy@donjonn.com>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>
References: <20200829193755.9429-1-tuong.t.lien@dektech.com.au>
 <f81eafce-e1d1-bb18-cb70-cfdf45bb2ed0@gmail.com>
 <AM8PR05MB733222C45D3F0CC19E909BB0E2510@AM8PR05MB7332.eurprd05.prod.outlook.com>
 <0ed21ba7-2b3b-9d4f-563e-10d329ebeecb@gmail.com>
 <AM8PR05MB7332E91A67120D78823353F6E2510@AM8PR05MB7332.eurprd05.prod.outlook.com>
 <3f858962-4e38-0b72-4341-1304ec03cd7a@gmail.com>
 <AM8PR05MB7332BE4B6E0381D2894E057AE22E0@AM8PR05MB7332.eurprd05.prod.outlook.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <338d5df9-fe4e-7acf-1480-99984dfeab34@gmail.com>
Date:   Tue, 1 Sep 2020 15:15:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <AM8PR05MB7332BE4B6E0381D2894E057AE22E0@AM8PR05MB7332.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/1/20 5:18 AM, Tuong Tong Lien wrote:
> 
> 
>> -----Original Message-----
>> From: Eric Dumazet <eric.dumazet@gmail.com>
>> Sent: Monday, August 31, 2020 7:48 PM
>> To: Tuong Tong Lien <tuong.t.lien@dektech.com.au>; Eric Dumazet <eric.dumazet@gmail.com>; davem@davemloft.net;
>> jmaloy@redhat.com; maloy@donjonn.com; ying.xue@windriver.com; netdev@vger.kernel.org
>> Cc: tipc-discussion@lists.sourceforge.net
>> Subject: Re: [net] tipc: fix using smp_processor_id() in preemptible
>>
>>
>>
>> On 8/31/20 3:05 AM, Tuong Tong Lien wrote:
>>>
>>>
>>>> -----Original Message-----
>>>> From: Eric Dumazet <eric.dumazet@gmail.com>
>>>> Sent: Monday, August 31, 2020 4:48 PM
>>>> To: Tuong Tong Lien <tuong.t.lien@dektech.com.au>; Eric Dumazet <eric.dumazet@gmail.com>; davem@davemloft.net;
>>>> jmaloy@redhat.com; maloy@donjonn.com; ying.xue@windriver.com; netdev@vger.kernel.org
>>>> Cc: tipc-discussion@lists.sourceforge.net
>>>> Subject: Re: [net] tipc: fix using smp_processor_id() in preemptible
>>>>
>>>>
>>>>
>>>> On 8/31/20 1:33 AM, Tuong Tong Lien wrote:
>>>>> Hi Eric,
>>>>>
>>>>> Thanks for your comments, please see my answers inline.
>>>>>
>>>>>> -----Original Message-----
>>>>>> From: Eric Dumazet <eric.dumazet@gmail.com>
>>>>>> Sent: Monday, August 31, 2020 3:15 PM
>>>>>> To: Tuong Tong Lien <tuong.t.lien@dektech.com.au>; davem@davemloft.net; jmaloy@redhat.com; maloy@donjonn.com;
>>>>>> ying.xue@windriver.com; netdev@vger.kernel.org
>>>>>> Cc: tipc-discussion@lists.sourceforge.net
>>>>>> Subject: Re: [net] tipc: fix using smp_processor_id() in preemptible
>>>>>>
>>>>>>
>>>>>>
>>>>>> On 8/29/20 12:37 PM, Tuong Lien wrote:
>>>>>>> The 'this_cpu_ptr()' is used to obtain the AEAD key' TFM on the current
>>>>>>> CPU for encryption, however the execution can be preemptible since it's
>>>>>>> actually user-space context, so the 'using smp_processor_id() in
>>>>>>> preemptible' has been observed.
>>>>>>>
>>>>>>> We fix the issue by using the 'get/put_cpu_ptr()' API which consists of
>>>>>>> a 'preempt_disable()' instead.
>>>>>>>
>>>>>>> Fixes: fc1b6d6de220 ("tipc: introduce TIPC encryption & authentication")
>>>>>>
>>>>>> Have you forgotten ' Reported-by: syzbot+263f8c0d007dc09b2dda@syzkaller.appspotmail.com' ?
>>>>> Well, really I detected the issue during my testing instead, didn't know if it was reported by syzbot too.
>>>>>
>>>>>>
>>>>>>> Acked-by: Jon Maloy <jmaloy@redhat.com>
>>>>>>> Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
>>>>>>> ---
>>>>>>>  net/tipc/crypto.c | 12 +++++++++---
>>>>>>>  1 file changed, 9 insertions(+), 3 deletions(-)
>>>>>>>
>>>>>>> diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
>>>>>>> index c38babaa4e57..7c523dc81575 100644
>>>>>>> --- a/net/tipc/crypto.c
>>>>>>> +++ b/net/tipc/crypto.c
>>>>>>> @@ -326,7 +326,8 @@ static void tipc_aead_free(struct rcu_head *rp)
>>>>>>>  	if (aead->cloned) {
>>>>>>>  		tipc_aead_put(aead->cloned);
>>>>>>>  	} else {
>>>>>>> -		head = *this_cpu_ptr(aead->tfm_entry);
>>>>>>> +		head = *get_cpu_ptr(aead->tfm_entry);
>>>>>>> +		put_cpu_ptr(aead->tfm_entry);
>>>>>>
>>>>>> Why is this safe ?
>>>>>>
>>>>>> I think that this very unusual construct needs a comment, because this is not obvious.
>>>>>>
>>>>>> This really looks like an attempt to silence syzbot to me.
>>>>> No, this is not to silence syzbot but really safe.
>>>>> This is because the "aead->tfm_entry" object is "common" between CPUs, there is only its pointer to be the "per_cpu" one. So
>> just
>>>> trying to lock the process on the current CPU or 'preempt_disable()', taking the per-cpu pointer and dereferencing to the actual
>>>> "tfm_entry" object... is enough. Later on, that’s fine to play with the actual object without any locking.
>>>>
>>>> Why using per cpu pointers, if they all point to a common object ?
>>>>
>>>> This makes the code really confusing.
>>> Sorry for making you confused. Yes, the code is a bit ugly and could be made in some other ways... The initial idea is to not touch or
>> change the same pointer variable in different CPUs so avoid a penalty with the cache hits/misses...
>>
>> What makes this code interrupt safe ?
>>
> Why is it unsafe? Its "parent" object is already managed by RCU mechanism. Also, it is never modified but just "read-only" in all cases...

tipc_aead_tfm_next() is _not_ read-only, since it contains :

*tfm_entry = list_next_entry(*tfm_entry, list);

If tipc_aead_tfm_next() can be called both from process context and irq context,
using a percpu variable to track a cursor in a list is unsafe.

_Unless_ special care is taken by callers to make sure irqs are disabled.

RCU does not protect this, not sure why you mention RCU at all.

To be re-entrant, each thread should have its own cursor, usually stored in an automatic variable,
not in a per-cpu location.





