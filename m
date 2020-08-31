Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF7B2576D2
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 11:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgHaJs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 05:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgHaJsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 05:48:24 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375CCC061573
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 02:48:22 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id q9so4757350wmj.2
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 02:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TVBu51iXRxffbTJT1ie/4/EHqQSiUlmT+OghNVHoqtY=;
        b=iXuwELY4kIw1AJX4/8L1nVeumSqL5pJip003MOUkL43jtXSFjtF+Zj/cc6X0raVVi5
         Ol4pHghRHHRoSc0PlAwH5Dm781edV3OximUm/iPrvDcQyP+pl30JzczOBUYQcVz+Ya8P
         hSd50WUi5OuEpA+qDQGuNwgyGRZMz/l/RRBJy/NaGfLP76wWex3hQRqv5g8Q5bwgfWq1
         sim+HnVxzkDEpiTt4sRiLe1UqJwTLuGqKaUiTnCv7DeoGa2lkeuEQ006q39zHZoMut/b
         RJd2UrvmCAUBelN651uKZ6C/Y5+4652kOb2BkgNv4d1a26GRD3au4qZ/JUvWYikTTzsg
         eUyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TVBu51iXRxffbTJT1ie/4/EHqQSiUlmT+OghNVHoqtY=;
        b=UbQjbU6khPv2eV+vLlv9tMD8SpaVxQJLzMFX/MUVhTWqNwbS32i+ZnGZ96iiQhYPgo
         6YqkdXocTjCu0ZNdrxW7dN6osr99EmGF9iTutx2YKFcSbqVpYBDGAmqKHmuchH0OE2ep
         0ilXW/C6GCTLkVzfrDuA4km6UkA4YMmJLMXKwptdOgZS2SGi/ypSafJaSO23IbAngnOr
         sD73Y9sP3I02MXP50GO2g+pgEVupa2fyRyi5TT0eC7lwIRNziPp/Q4UY/d2cEzGkLkmo
         Lia6z+QI5kdtOR212itY39QNB3nzIscSr5Sh6Ph5mqDLNjAG7TnDa+uHQVQJI2NO+AZk
         QbbA==
X-Gm-Message-State: AOAM532mm7cVURkxBr6tl4XPCtItlmhhGKKS/Kk6tULBACZQiEgE+DHx
        tXzTuJH1v2jDZwADRuFO6FE=
X-Google-Smtp-Source: ABdhPJzV5lPlrIFPxSH0rR9rc+rF8dEYLA3wBbYvDeAsRaYZxMBdLv0Zd7kZzUWRoHgca9+KK/qYNg==
X-Received: by 2002:a1c:a789:: with SMTP id q131mr562152wme.141.1598867300836;
        Mon, 31 Aug 2020 02:48:20 -0700 (PDT)
Received: from [192.168.8.147] ([37.164.5.65])
        by smtp.gmail.com with ESMTPSA id h5sm11107452wrc.45.2020.08.31.02.48.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2020 02:48:20 -0700 (PDT)
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
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <0ed21ba7-2b3b-9d4f-563e-10d329ebeecb@gmail.com>
Date:   Mon, 31 Aug 2020 11:47:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <AM8PR05MB733222C45D3F0CC19E909BB0E2510@AM8PR05MB7332.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/31/20 1:33 AM, Tuong Tong Lien wrote:
> Hi Eric,
> 
> Thanks for your comments, please see my answers inline.
> 
>> -----Original Message-----
>> From: Eric Dumazet <eric.dumazet@gmail.com>
>> Sent: Monday, August 31, 2020 3:15 PM
>> To: Tuong Tong Lien <tuong.t.lien@dektech.com.au>; davem@davemloft.net; jmaloy@redhat.com; maloy@donjonn.com;
>> ying.xue@windriver.com; netdev@vger.kernel.org
>> Cc: tipc-discussion@lists.sourceforge.net
>> Subject: Re: [net] tipc: fix using smp_processor_id() in preemptible
>>
>>
>>
>> On 8/29/20 12:37 PM, Tuong Lien wrote:
>>> The 'this_cpu_ptr()' is used to obtain the AEAD key' TFM on the current
>>> CPU for encryption, however the execution can be preemptible since it's
>>> actually user-space context, so the 'using smp_processor_id() in
>>> preemptible' has been observed.
>>>
>>> We fix the issue by using the 'get/put_cpu_ptr()' API which consists of
>>> a 'preempt_disable()' instead.
>>>
>>> Fixes: fc1b6d6de220 ("tipc: introduce TIPC encryption & authentication")
>>
>> Have you forgotten ' Reported-by: syzbot+263f8c0d007dc09b2dda@syzkaller.appspotmail.com' ?
> Well, really I detected the issue during my testing instead, didn't know if it was reported by syzbot too.
> 
>>
>>> Acked-by: Jon Maloy <jmaloy@redhat.com>
>>> Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
>>> ---
>>>  net/tipc/crypto.c | 12 +++++++++---
>>>  1 file changed, 9 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
>>> index c38babaa4e57..7c523dc81575 100644
>>> --- a/net/tipc/crypto.c
>>> +++ b/net/tipc/crypto.c
>>> @@ -326,7 +326,8 @@ static void tipc_aead_free(struct rcu_head *rp)
>>>  	if (aead->cloned) {
>>>  		tipc_aead_put(aead->cloned);
>>>  	} else {
>>> -		head = *this_cpu_ptr(aead->tfm_entry);
>>> +		head = *get_cpu_ptr(aead->tfm_entry);
>>> +		put_cpu_ptr(aead->tfm_entry);
>>
>> Why is this safe ?
>>
>> I think that this very unusual construct needs a comment, because this is not obvious.
>>
>> This really looks like an attempt to silence syzbot to me.
> No, this is not to silence syzbot but really safe.
> This is because the "aead->tfm_entry" object is "common" between CPUs, there is only its pointer to be the "per_cpu" one. So just trying to lock the process on the current CPU or 'preempt_disable()', taking the per-cpu pointer and dereferencing to the actual "tfm_entry" object... is enough. Later on, that’s fine to play with the actual object without any locking.

Why using per cpu pointers, if they all point to a common object ?

This makes the code really confusing.

Why no lock is required ? This seems hard to believe, given lack of clear explanations anywhere
in commit fc1b6d6de220 ("tipc: introduce TIPC encryption & authentication").

If the object can be used without locking, it should be marked const.

tipc_aead_tfm_next() has side effects that I really can not understand in SMP world,
and presumably with soft interrupts in UP as well.





