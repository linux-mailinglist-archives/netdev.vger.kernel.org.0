Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E65203D35
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 18:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729789AbgFVQ4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 12:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729519AbgFVQ4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 12:56:30 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC41EC061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 09:56:30 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id r18so8391716pgk.11
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 09:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WdiaGqzxe5Ya6/V+/3F2SFfobDGwIFyoANb9DViO3fw=;
        b=p71UKZnuH8oC1EXrMOV2p6Kmy4KmJJBbnBE9GTaGoakpUT/R6xGE1ugsy1MfKVkfSi
         RrI/9w0dOT/MbQGLQXO4RwT61dkcAnAvhWeypOdvq7ro7i6shNuKZlVo+af3H93eSMdu
         EaxnXA/r6bsfi0GuiKDBpk3OYGAkADyCzlBT4IyfzPQyxUfVOzN69lxMiArEMl1noT9g
         AOrMAIY+BJsXIYBDFkCThzKp5xBDrRcPa2vmzeZloipP64zwjZ8aJP9l5KZpiwYvMJSO
         eUBbDkJ8JXnhKiYMP5qTwIlgrQs5oB+bzBWtk7TAsuZ/HhqHaPLYQApsDSiSqdvLv1TE
         qF+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WdiaGqzxe5Ya6/V+/3F2SFfobDGwIFyoANb9DViO3fw=;
        b=p3K3s467Vngslw1LVvbPAuuJVB5nFIOcYPbZbGf/vpolNC5UugnAN+kDullTeDdr7n
         F5fOkC/Sq4MwvrJ4H6z2ycSkjP9Sy/q7qnGlQziBHdJWcTXuIMME8pZcnzvkjyarQDis
         p3be12lR8LmWs6brbZ2bezyfA2hd+hAbLf7ZUS4hhLNxdrpRFPkuCBFoYk522tgWmx2A
         1aYVhpXo00wc46bor3ZZtTG4yJeXU5Z6PkGPk3qgUDDNdO2sJKt8YbnoqT6jSDoYmrn9
         CK7V3Q9V7XwPCdP10CvCuwbQXXAzMOZ9C2bbIqAXPUYzVkBGdx5ii5DAmrSMf9NRKJ4A
         +VoA==
X-Gm-Message-State: AOAM533hqx+JXt524dBy1V5OCOTfTPvoVcoYfnd5N81pFyuub5QTVlwn
        gbBCF6tsyiM5AMCzVNHIulI=
X-Google-Smtp-Source: ABdhPJyh/wMLc2Y2/jNgqIgGvmuEQN8vnIOSPWtxBQszHtR4PcUsH/o0pOAPWgiHu5ngXqLS/qMSJA==
X-Received: by 2002:a65:50c8:: with SMTP id s8mr14374061pgp.161.1592844990441;
        Mon, 22 Jun 2020 09:56:30 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id r7sm11623544pgu.51.2020.06.22.09.56.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 09:56:29 -0700 (PDT)
Subject: Re: [PATCH net] net: Do not clear the socket TX queue in
 sock_orphan()
To:     Tariq Toukan <tariqt@mellanox.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>
References: <1592748544-41555-1-git-send-email-tariqt@mellanox.com>
 <4254dfec-0901-73c4-a1f5-c6609db2baec@gmail.com>
 <d5d84b99-0ee4-b03d-d927-d9dcb8d36326@mellanox.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <8c810aec-b715-6fe9-2f33-f9f815e67fa7@gmail.com>
Date:   Mon, 22 Jun 2020 09:56:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <d5d84b99-0ee4-b03d-d927-d9dcb8d36326@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/22/20 9:24 AM, Tariq Toukan wrote:
> 
> 
> On 6/22/2020 6:53 PM, Eric Dumazet wrote:
>>
>>
>> On 6/21/20 7:09 AM, Tariq Toukan wrote:
>>> sock_orphan() call to sk_set_socket() implies clearing the sock TX queue.
>>> This might cause unexpected out-of-order transmit, as outstanding packets
>>> can pick a different TX queue and bypass the ones already queued.
>>> This is undesired in general. More specifically, it breaks the in-order
>>> scheduling property guarantee for device-offloaded TLS sockets.
>>>
>>> Introduce a function variation __sk_set_socket() that does not clear
>>> the TX queue, and call it from sock_orphan().
>>> All other callers of sk_set_socket() do not operate on an active socket,
>>> so they do not need this change.
>>>
>>> Fixes: e022f0b4a03f ("net: Introduce sk_tx_queue_mapping")
>>> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
>>> Reviewed-by: Boris Pismenny <borisp@mellanox.com>
>>> ---
>>>   include/net/sock.h | 9 +++++++--
>>>   1 file changed, 7 insertions(+), 2 deletions(-)
>>>
>>> Please queue for -stable.
>>>
>>> diff --git a/include/net/sock.h b/include/net/sock.h
>>> index c53cc42b5ab9..23e43f3d79f0 100644
>>> --- a/include/net/sock.h
>>> +++ b/include/net/sock.h
>>> @@ -1846,10 +1846,15 @@ static inline int sk_rx_queue_get(const struct sock *sk)
>>>   }
>>>   #endif
>>>   +static inline void __sk_set_socket(struct sock *sk, struct socket *sock)
>>> +{
>>> +    sk->sk_socket = sock;
>>> +}
>>> +
>>>   static inline void sk_set_socket(struct sock *sk, struct socket *sock)
>>>   {
>>>       sk_tx_queue_clear(sk);
>>> -    sk->sk_socket = sock;
>>> +    __sk_set_socket(sk, sock);
>>>   }
>>>   
>>
>> Hmm...
>>
>> I think we should have a single sk_set_socket() call, and remove
>> the sk_tx_queue_clear() from it.
>>
>> sk_tx_queue_clear() should be put where it is needed, instead of being hidden
>> in sk_set_socket()
>>
> 
> Thanks Eric, sounds good to me, I will respin, just have some questions below.
> 
>> diff --git a/include/net/sock.h b/include/net/sock.h
>> index c53cc42b5ab92d0062519e60435b85c75564a967..3428619faae4340485b200f49d9cce4fb09086b3 100644
>> --- a/include/net/sock.h
>> +++ b/include/net/sock.h
>> @@ -1848,7 +1848,6 @@ static inline int sk_rx_queue_get(const struct sock *sk)
>>     static inline void sk_set_socket(struct sock *sk, struct socket *sock)
>>   {
>> -       sk_tx_queue_clear(sk);
>>          sk->sk_socket = sock;
>>   }
>>   diff --git a/net/core/sock.c b/net/core/sock.c
>> index 6c4acf1f0220b1f925ebcfaa847632ec0dbe0b9b..134de0d37f77ba781b2b3341c94a97a1b2d57a2d 100644
>> --- a/net/core/sock.c
>> +++ b/net/core/sock.c
>> @@ -1767,6 +1767,7 @@ struct sock *sk_alloc(struct net *net, int family, gfp_t priority,
>>                  cgroup_sk_alloc(&sk->sk_cgrp_data);
>>                  sock_update_classid(&sk->sk_cgrp_data);
>>                  sock_update_netprioidx(&sk->sk_cgrp_data);
>> +               sk_tx_queue_clear(sk);
> 
> Why add it here?
> I don't see a call to sk_set_socket().

Yes, but the intent is to set the initial value of sk->sk_tx_queue_mapping (USHRT_MAX)
when socket object is allocated/populated, not later in some unrelated paths.

We move into one location all the initializers.
(Most fields initial value is 0, so we do not clear them a second time)

> 
>>          }
>>            return sk;
>> @@ -1990,6 +1991,7 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
>>                   */
>>                  sk_refcnt_debug_inc(newsk);
>>                  sk_set_socket(newsk, NULL);
>> +               sk_tx_queue_clear(newsk);
>>                  RCU_INIT_POINTER(newsk->sk_wq, NULL);
>>                    if (newsk->sk_prot->sockets_allocated)
>>
> 
> So in addition to sock_orphan(), now sk_tx_queue_clear() won't be called also from:
> 1. sock_graft(): Looks fine to me.
> 2. sock_init_data(): I think we should add an explicit call to sk_tx_queue_clear() here. The one for RX sk_rx_queue_clear() is already there.

Why ? Initial value found is socket should be just fine.

If not, normal skb->ooo_okay should prevail, if protocols really care about OOO.

> 3. mptcp_sock_graft(): Looks fine to me.
> 
> Regards,
> Tariq
