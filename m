Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7782579A8
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 14:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgHaMsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 08:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbgHaMsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 08:48:06 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C49C061573
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 05:48:04 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id a9so1458618wmm.2
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 05:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kmEfJJjkfBHFuIPnxRMBrkxDx52E21YOCVEEh+kuqZQ=;
        b=k0KdrO+WWSLZto4p21eHxQv3ZVCqjCGoqC6jNWCR7PbGviXzAJ0qmCMNWAtd+W68Fv
         +bzcNgV7MebohiyCYqOVvO7sHz6u+KR/XKgQvbQzg9xPAE/LXn20HS4mY5Vgkfme7xL0
         9ef70zC7w5liUyQyh9OZOGqT2Lu7+iWHel1JhKs5b1qJ/qrOKSXUu5TTwJ1BbSVEE5Yh
         IQQ2DM6BOF1XfVW4XpiYf3XUIyWAzh3m9Az6tBBkpRf5ie85ZdbVU5JDTPLhU9YAhm/x
         rqHKfJo+rbS51ThGQRy1tE8orqNzPoQbWEq4IvXNhGom4IvdIul+7gF+JxiKk+CVAQT8
         p1kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kmEfJJjkfBHFuIPnxRMBrkxDx52E21YOCVEEh+kuqZQ=;
        b=IGTGhMASsgzz2BEM1pTdyv7dyGKa4h6Pp4RTvvogUl2vw4klIgAGxd12FwHvX1R/jI
         kw9B8uiB/dVkT+x68jXzvpLJqmjO0r3x/6S6ZK8hKKosdMhvT3ET0okngNpbHnW3pGHR
         HbsO57V5qTLrG+FUFBkg7sOQ/BaGSzGSIx+pVWkrquDWs+AWMnq+0hSfQaYxKsu2leV6
         2ATn3ILYQMqwOmkfr3I+cAKPsf7BNhU1geG4IUtfHfILZxze0Li8p8mAAJztbetLF9Ar
         BB6VR8hRNswV/CeOJSEW26VbAKOoafXx4iUZsOxmNts/eS7ya7UVTpekfJiW/IKyTfUy
         WF5g==
X-Gm-Message-State: AOAM531INfS/SlPwhzHrNzorGLmQ36zl2b3k/YThXbIKo5jWxMzg5bQY
        smWZuvfZwa2TjJyGqJu0hvc=
X-Google-Smtp-Source: ABdhPJw7HSmqcoUB7AOmmWBWjRwZUZf+V0iC2v4Xn98YjR/NBf+3OIA0xk2KQ8s7xpLC3xgZANUDWg==
X-Received: by 2002:a05:600c:204e:: with SMTP id p14mr1185882wmg.182.1598878083125;
        Mon, 31 Aug 2020 05:48:03 -0700 (PDT)
Received: from [192.168.8.147] ([37.164.27.66])
        by smtp.gmail.com with ESMTPSA id r18sm12608010wrg.64.2020.08.31.05.48.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2020 05:48:02 -0700 (PDT)
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
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <3f858962-4e38-0b72-4341-1304ec03cd7a@gmail.com>
Date:   Mon, 31 Aug 2020 14:48:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <AM8PR05MB7332E91A67120D78823353F6E2510@AM8PR05MB7332.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/31/20 3:05 AM, Tuong Tong Lien wrote:
> 
> 
>> -----Original Message-----
>> From: Eric Dumazet <eric.dumazet@gmail.com>
>> Sent: Monday, August 31, 2020 4:48 PM
>> To: Tuong Tong Lien <tuong.t.lien@dektech.com.au>; Eric Dumazet <eric.dumazet@gmail.com>; davem@davemloft.net;
>> jmaloy@redhat.com; maloy@donjonn.com; ying.xue@windriver.com; netdev@vger.kernel.org
>> Cc: tipc-discussion@lists.sourceforge.net
>> Subject: Re: [net] tipc: fix using smp_processor_id() in preemptible
>>
>>
>>
>> On 8/31/20 1:33 AM, Tuong Tong Lien wrote:
>>> Hi Eric,
>>>
>>> Thanks for your comments, please see my answers inline.
>>>
>>>> -----Original Message-----
>>>> From: Eric Dumazet <eric.dumazet@gmail.com>
>>>> Sent: Monday, August 31, 2020 3:15 PM
>>>> To: Tuong Tong Lien <tuong.t.lien@dektech.com.au>; davem@davemloft.net; jmaloy@redhat.com; maloy@donjonn.com;
>>>> ying.xue@windriver.com; netdev@vger.kernel.org
>>>> Cc: tipc-discussion@lists.sourceforge.net
>>>> Subject: Re: [net] tipc: fix using smp_processor_id() in preemptible
>>>>
>>>>
>>>>
>>>> On 8/29/20 12:37 PM, Tuong Lien wrote:
>>>>> The 'this_cpu_ptr()' is used to obtain the AEAD key' TFM on the current
>>>>> CPU for encryption, however the execution can be preemptible since it's
>>>>> actually user-space context, so the 'using smp_processor_id() in
>>>>> preemptible' has been observed.
>>>>>
>>>>> We fix the issue by using the 'get/put_cpu_ptr()' API which consists of
>>>>> a 'preempt_disable()' instead.
>>>>>
>>>>> Fixes: fc1b6d6de220 ("tipc: introduce TIPC encryption & authentication")
>>>>
>>>> Have you forgotten ' Reported-by: syzbot+263f8c0d007dc09b2dda@syzkaller.appspotmail.com' ?
>>> Well, really I detected the issue during my testing instead, didn't know if it was reported by syzbot too.
>>>
>>>>
>>>>> Acked-by: Jon Maloy <jmaloy@redhat.com>
>>>>> Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
>>>>> ---
>>>>>  net/tipc/crypto.c | 12 +++++++++---
>>>>>  1 file changed, 9 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
>>>>> index c38babaa4e57..7c523dc81575 100644
>>>>> --- a/net/tipc/crypto.c
>>>>> +++ b/net/tipc/crypto.c
>>>>> @@ -326,7 +326,8 @@ static void tipc_aead_free(struct rcu_head *rp)
>>>>>  	if (aead->cloned) {
>>>>>  		tipc_aead_put(aead->cloned);
>>>>>  	} else {
>>>>> -		head = *this_cpu_ptr(aead->tfm_entry);
>>>>> +		head = *get_cpu_ptr(aead->tfm_entry);
>>>>> +		put_cpu_ptr(aead->tfm_entry);
>>>>
>>>> Why is this safe ?
>>>>
>>>> I think that this very unusual construct needs a comment, because this is not obvious.
>>>>
>>>> This really looks like an attempt to silence syzbot to me.
>>> No, this is not to silence syzbot but really safe.
>>> This is because the "aead->tfm_entry" object is "common" between CPUs, there is only its pointer to be the "per_cpu" one. So just
>> trying to lock the process on the current CPU or 'preempt_disable()', taking the per-cpu pointer and dereferencing to the actual
>> "tfm_entry" object... is enough. Later on, that’s fine to play with the actual object without any locking.
>>
>> Why using per cpu pointers, if they all point to a common object ?
>>
>> This makes the code really confusing.
> Sorry for making you confused. Yes, the code is a bit ugly and could be made in some other ways... The initial idea is to not touch or change the same pointer variable in different CPUs so avoid a penalty with the cache hits/misses...

What makes this code interrupt safe ?

Having a per-cpu list is not interrupt safe without special care.



