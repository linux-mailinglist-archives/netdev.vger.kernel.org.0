Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6238B5FDF2C
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 19:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiJMRmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 13:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiJMRmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 13:42:08 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4EE8E09C4
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 10:42:06 -0700 (PDT)
Message-ID: <c4f74864-0a6a-5075-891c-d20d0dc20f2f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1665682924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+PugGeeHuOFAHK4K5Jw6vx1wsrq9Nb6z9GV4h7SiBwA=;
        b=Uhu1Zf24q1/6Bs7JJE26O/eul6JdWRLakWiqOStk9Pv20iWBVjXddGVFnkArk4V+qzICnP
        ZhH6cUc2ydFrKR3JGbNCElHZtiIgO1A5Yra2yHh7b2hWfZE3qKcWmzU73mHEBhaYB3gtMi
        uMa4C5cYEbbuKr+MET65JiWar7pv4Z4=
Date:   Thu, 13 Oct 2022 10:41:53 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v2 net] udp: Update reuse->has_conns under reuseport_lock.
Content-Language: en-US
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, dsahern@kernel.org,
        Eric Dumazet <edumazet@google.com>, kraig@google.com,
        kuba@kernel.org, kuni1840@gmail.com, martin.lau@kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, willemb@google.com,
        yoshfuji@linux-ipv6.org
References: <CANn89iJn-T_rKg67h6deW0Oyh=X4kWXVBrtvUJU+VpDTfpde0w@mail.gmail.com>
 <20221012192739.91505-1-kuniyu@amazon.com>
 <CANn89iLja=eQHbsM_Ta2sQF0tOGU8vAGrh_izRuuHjuO1ouUag@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <CANn89iLja=eQHbsM_Ta2sQF0tOGU8vAGrh_izRuuHjuO1ouUag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/22 9:09 AM, Eric Dumazet wrote:
>>>> diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
>>>> index 5daa1fa54249..abb414ed4aa7 100644
>>>> --- a/net/core/sock_reuseport.c
>>>> +++ b/net/core/sock_reuseport.c
>>>> @@ -21,6 +21,21 @@ static DEFINE_IDA(reuseport_ida);
>>>>   static int reuseport_resurrect(struct sock *sk, struct sock_reuseport *old_reuse,
>>>>                                 struct sock_reuseport *reuse, bool bind_inany);
>>>>
>>>> +void reuseport_has_conns_set(struct sock *sk)
>>>> +{
>>>> +       struct sock_reuseport *reuse;
>>>> +
>>>> +       if (!rcu_access_pointer(sk->sk_reuseport_cb))
>>>> +               return;
>>>> +
>>>> +       spin_lock(&reuseport_lock);

It seems other paths are still using the spin_lock_bh().  It will be useful to 
have a few words here why _bh() is not needed.

>>>> +       reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
>>>> +                                         lockdep_is_held(&reuseport_lock));
>>>
>>> Could @reuse be NULL at this point ?
>>>
>>> Previous  test was performed without reuseport_lock being held.
>>
>> Usually, sk_reuseport_cb is changed under lock_sock().
>>
>> The only exception is reuseport_grow() & TCP reqsk migration case.
>>
>> 1) shutdown() TCP listener, which is moved into the latter part of
>>     reuse->socks[] to migrate reqsk.
>>
>> 2) New listen() overflows reuse->socks[] and call reuseport_grow().
>>
>> 3) reuse->max_socks overflows u16 with the new listener.
>>
>> 4) reuseport_grow() pops the old shutdown()ed listener from the array
>>     and update its sk->sk_reuseport_cb as NULL without lock_sock().
>>
>> shutdown()ed sk->sk_reuseport_cb can be changed without lock_sock().
>>
>> But, reuseport_has_conns_set() is called only for UDP and under
>> lock_sock(), so @reuse never be NULL in this case.
> 
> Given the complexity of this code and how much time is needed to
> review all possibilities, please add an additional
> 
> if (reuse)
>     reuse->has_conns = 1;

+1

