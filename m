Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 479713D24AC
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 15:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbhGVMxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 08:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231925AbhGVMxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 08:53:12 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB88C061575
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 06:33:46 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id oz7so8430311ejc.2
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 06:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=krrqgDtyw8KyZc9tOOCwvqdlmRgO5LxhC2Fe0jBFQAE=;
        b=n9qhiPberPYMoFgKThp1cazMwGPhWHUZFwcjRMh8GW8fOU8s5XLT6bpsJ9+dUHKn5K
         zrPoRUd9wfxtjNwW5ktz0S310SoYKIxTx6tbxNAtRoeqUOtpiM1I0BtFmLyNVTyNyoap
         ImzaWTuJFuqPKLLLZnZYLOmLfy+fRSS9aRTtEfksUZtxx5PCTDWHhEglg7TZ6/Nq7nkm
         /K4pJj6gUAlIdq5Kp1HNaIWfjlg1ND4O/sG4DVjeAjZ0oBl8OBqEfogkLCJ99p1ioUP1
         R/N31cx9CYheAToWqlQxG3qk4DB05oDys0ZX2gQqMiganbPCGNaGf6pydwfpOWJ3b5Em
         1QWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=krrqgDtyw8KyZc9tOOCwvqdlmRgO5LxhC2Fe0jBFQAE=;
        b=rqpsoTvmRfezh7M7rC8cNjZavMI48XqCnmCvp5LaUCz6ldbSR2mJ6f3G3gg45nV7wS
         f/40aPr53rFb7l/fJ+fWJ1aiw+rR+U6KpDndHSA1o/WduC4nHpkHrvbadgdxZxS+kSvW
         TrWKzkkYQ09nkDXw+klURB2KkeE6i95yyWDwZun1UdpqeDhzIw5xOausq3OZQEpmp12Q
         9jXvRSvLoNXkLBMYhAXUj6tvjmijZCP1mAGak96AxS/638lUHNpVhOWS410y2TdXhoR7
         KRznaECm+pDaUU3S/twlJ79k8+fd7Q3MlIMPkOaThULkIXFKVfsw3zqFVf+i+5EqNrnp
         1Gig==
X-Gm-Message-State: AOAM533bfCr7aTyIYUathoebkHEmesHaygazIWb64TVZZ3psS3KFMgp7
        bZ4mr+jlY7O0VSBPQmNB4Bk=
X-Google-Smtp-Source: ABdhPJwPaHRoep32wwHtCL5/yQfL2z4xOi+q4UAgZPYHxVTMLfFaTpY6ZtEzUQrFI+9uOgPgHZsjhw==
X-Received: by 2002:a17:907:3581:: with SMTP id ao1mr2242936ejc.85.1626960825449;
        Thu, 22 Jul 2021 06:33:45 -0700 (PDT)
Received: from [132.68.43.152] ([132.68.43.152])
        by smtp.gmail.com with ESMTPSA id n14sm12434398edo.23.2021.07.22.06.33.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 06:33:44 -0700 (PDT)
Subject: Re: [PATCH v5 net-next 01/36] net: Introduce direct data placement
 tcp offload
To:     Eric Dumazet <edumazet@google.com>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, sagi@grimberg.me, axboe@fb.com,
        kbusch@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        smalin@marvell.com, boris.pismenny@gmail.com,
        linux-nvme@lists.infradead.org, netdev <netdev@vger.kernel.org>,
        benishay@nvidia.com, ogerlitz@nvidia.com, yorayz@nvidia.com,
        Boris Pismenny <borisp@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
References: <20210722110325.371-1-borisp@nvidia.com>
 <20210722110325.371-2-borisp@nvidia.com>
 <CANn89iLP4yXDK9nOq6Lxs9NrfAOZ6RuX5B5SV0Japx50KvnEyQ@mail.gmail.com>
 <7fdb948a-6411-fce5-370f-90567d2fe985@gmail.com>
 <CANn89iLUDcL-F2RvaNz5+b8oQPnL1DnanHe0vvMb8QkM26whCQ@mail.gmail.com>
From:   Boris Pismenny <borispismenny@gmail.com>
Message-ID: <ba72f780-840e-de73-31b3-137908c52868@gmail.com>
Date:   Thu, 22 Jul 2021 16:33:41 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CANn89iLUDcL-F2RvaNz5+b8oQPnL1DnanHe0vvMb8QkM26whCQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/07/2021 16:10, Eric Dumazet wrote:
> On Thu, Jul 22, 2021 at 2:18 PM Boris Pismenny <borispismenny@gmail.com> wrote:
>>
>> On 22/07/2021 14:26, Eric Dumazet wrote:
>>> On Thu, Jul 22, 2021 at 1:04 PM Boris Pismenny <borisp@nvidia.com> wrote:
>>>>
>>>> From: Boris Pismenny <borisp@mellanox.com>
>>>>
>>>>
>>> ...
>>>
>>>>  };
>>>>
>>>>  const char
>>>> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
>>>> index e6ca5a1f3b59..4a7160bba09b 100644
>>>> --- a/net/ipv4/tcp_input.c
>>>> +++ b/net/ipv4/tcp_input.c
>>>> @@ -5149,6 +5149,9 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
>>>>                 memcpy(nskb->cb, skb->cb, sizeof(skb->cb));
>>>>  #ifdef CONFIG_TLS_DEVICE
>>>>                 nskb->decrypted = skb->decrypted;
>>>> +#endif
>>>> +#ifdef CONFIG_ULP_DDP
>>>> +               nskb->ddp_crc = skb->ddp_crc;
>>>
>>> Probably you do not want to attempt any collapse if skb->ddp_crc is
>>> set right there.
>>>
>>
>> Right.
>>
>>>>  #endif
>>>>                 TCP_SKB_CB(nskb)->seq = TCP_SKB_CB(nskb)->end_seq = start;
>>>>                 if (list)
>>>> @@ -5182,6 +5185,11 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
>>>>  #ifdef CONFIG_TLS_DEVICE
>>>>                                 if (skb->decrypted != nskb->decrypted)
>>>>                                         goto end;
>>>> +#endif
>>>> +#ifdef CONFIG_ULP_DDP
>>>> +
>>>> +                               if (skb->ddp_crc != nskb->ddp_crc)
>>>
>>> This checks only the second, third, and remaining skbs.
>>>
>>
>> Right, as we handle the head skb above. Could you clarify?
> 
> I was simply saying you missed the first skb.
> 

But, the first SKB got handled in the change above. The code here is the
same for TLS, if it is wrong, then we already have an issue here.

>>
>>>> +                                       goto end;
>>>>  #endif
>>>>                         }
>>>>                 }
>>>
>>>
>>> tcp_collapse() is copying data from small skbs to pack it to bigger
>>> skb (one page of payload), in case
>>> of memory emergency/pressure (socket queues are full)
>>>
>>> If your changes are trying to avoid 'needless'  copies, maybe you
>>> should reconsider and let the emergency packing be done.
>>>
>>> If the copy is not _possible_, you should rephrase your changelog to
>>> clearly state the kernel _cannot_ access this memory in any way.
>>>
>>
>> The issue is that skb_condense also gets called on many skbs in
>> tcp_add_backlog and it will identify skbs that went through DDP as ideal
>> for packing, even though they are not small and packing is
>> counter-productive as data already resides in its destination.
>>
>> As mentioned above, it is possible to copy, but it is counter-productive
>> in this case. If there was a real need to access this memory, then it is
>> allowed.
> 
> Standard GRO packets from high perf drivers have no room in their
> skb->head (ie skb_tailroom() should be 0)
> 
> If you have a driver using GRO and who pulled some payload in
> skb->head, it is already too late for DDP.
> 
> So I think you are trying to add code in TCP that should not be
> needed. Perhaps mlx5 driver is doing something it should not ?
> (If this is ' copybreak'  this has been documented as being
> suboptimal, transports have better strategies)
> 
> Secondly, tcp_collapse() should absolutely not be called under regular
> workloads.
> 
> Trying to optimize this last-resort thing is a lost cause:
> If an application is dumb enough to send small packets back-to-back,
> it should be fixed (sender side has this thing called autocork, for
> applications that do not know about MSG_MORE or TC_CORK.)
> 
> (tcp_collapse is a severe source of latencies)
> 


Sorry. My response above was about skb_condense which I've confused with
tcp_collapse.

In tcp_collapse, we could allow the copy, but the problem is CRC, which
like TLS's skb->decrypted marks that the data passed the digest
validation in the NIC. If we allow collapsing SKBs with mixed marks, we
will need to force software copy+crc verification. As TCP collapse is
indeed rare and the offload is opportunistic in nature, we can make this
change and submit another version, but I'm confused; why was it OK for
TLS, while it is not OK for DDP+CRC?

