Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E54C27EC6
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 15:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730780AbfEWNvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 09:51:39 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34070 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730323AbfEWNvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 09:51:38 -0400
Received: by mail-pg1-f193.google.com with SMTP id h2so125800pgg.1;
        Thu, 23 May 2019 06:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OavM6MumMoRvL9UPRjFZpjMK+yzvoInjaSnzKRdf7us=;
        b=M+3JiUVZTxT2pFZbK9TVQ81poHvRkWlqD14ZStkrKr3uDKm2RyGabGAKzwKJmFjRpd
         kOTiWsevrQ+9JJh+k7qz0I+CLTghV1twR/dOTrDOgMe6mhtckrzfiKzOlAOtwTvgk4PE
         U30Cdx7knc0s+xlOJSyIpkJDry0u5gFt5ARBv58BsFpOXtBvBQrkdZzOVvi1JM/vbtHO
         vgY+8PmRVPkCHaJBAYAnBoXJo44PZ2dGJqRG5J3eKkLpy1JoZWmE9C7v5PHjESFWn/lH
         uuqlSj80VufsmeaJhR56An0WikRZFcLEVbpqwOsLb31gX0S1MR/cFHaM0g1szVgVjO9A
         ktXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OavM6MumMoRvL9UPRjFZpjMK+yzvoInjaSnzKRdf7us=;
        b=MlJW+VvaAiH9rna6EZvkF06DBR5LKv9HqWl5TRAkkM7nYnX7qxbWSRJBdgMNnYB5Ma
         BXUmKx4K5yj33kRZW5AZmdV0zb7jzHDjivrc+E6+0FRPTzjQsP6x1JFcst8sfpJ6ACs8
         KpKsArKbkLMBj22JrYMB62ANGi44jGAOwhX32sl6f5gdjRIorAFaBMH0q5EmKXsp41rF
         NdmkhM0vzJNn72lBp1RRXH0C/h6La+684AbrAWWdG7FNlK6C92ohB+Y5OHwCHr8yPZJX
         ZfvKkxxhcG64jadt2bo/KdRuaCKFvp3mQOWNwFDxBPSmrkE0f9opJatj49KmrVh7bUis
         Kgwg==
X-Gm-Message-State: APjAAAXI1yKHGiuGEk/7U+tfFLC0dgf2wW/o3BSQFLfle6/BVXVjhXYx
        Vg/0Qd1VkxTbutboeYt9xdNnumkJ
X-Google-Smtp-Source: APXvYqyUFs+7RvEAMG+TW9I0x/07/AstYaPEVFKFUiV/+Hvf+gSHq5zX2ruBZ6dFqBVF5XOXQ9MKZA==
X-Received: by 2002:a63:1a03:: with SMTP id a3mr99040179pga.412.1558619497841;
        Thu, 23 May 2019 06:51:37 -0700 (PDT)
Received: from [192.168.1.9] (i223-218-240-142.s42.a013.ap.plala.or.jp. [223.218.240.142])
        by smtp.googlemail.com with ESMTPSA id j10sm28429187pgk.37.2019.05.23.06.51.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 06:51:37 -0700 (PDT)
Subject: Re: [PATCH bpf-next 3/3] veth: Support bulk XDP_TX
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org
References: <1558609008-2590-1-git-send-email-makita.toshiaki@lab.ntt.co.jp>
 <1558609008-2590-4-git-send-email-makita.toshiaki@lab.ntt.co.jp>
 <87zhnd1kg9.fsf@toke.dk> <599302b2-96d2-b571-01ee-f4914acaf765@lab.ntt.co.jp>
 <20190523152927.14bf7ed1@carbon>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <c902c0f4-947b-ba9e-7baa-628ba87a8f01@gmail.com>
Date:   Thu, 23 May 2019 22:51:34 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190523152927.14bf7ed1@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/05/23 (木) 22:29:27, Jesper Dangaard Brouer wrote:
> On Thu, 23 May 2019 20:35:50 +0900
> Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp> wrote:
> 
>> On 2019/05/23 20:25, Toke Høiland-Jørgensen wrote:
>>> Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp> writes:
>>>    
>>>> This improves XDP_TX performance by about 8%.
>>>>
>>>> Here are single core XDP_TX test results. CPU consumptions are taken
>>>> from "perf report --no-child".
>>>>
>>>> - Before:
>>>>
>>>>    7.26 Mpps
>>>>
>>>>    _raw_spin_lock  7.83%
>>>>    veth_xdp_xmit  12.23%
>>>>
>>>> - After:
>>>>
>>>>    7.84 Mpps
>>>>
>>>>    _raw_spin_lock  1.17%
>>>>    veth_xdp_xmit   6.45%
>>>>
>>>> Signed-off-by: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
>>>> ---
>>>>   drivers/net/veth.c | 26 +++++++++++++++++++++++++-
>>>>   1 file changed, 25 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
>>>> index 52110e5..4edc75f 100644
>>>> --- a/drivers/net/veth.c
>>>> +++ b/drivers/net/veth.c
>>>> @@ -442,6 +442,23 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
>>>>   	return ret;
>>>>   }
>>>>   
>>>> +static void veth_xdp_flush_bq(struct net_device *dev)
>>>> +{
>>>> +	struct xdp_tx_bulk_queue *bq = this_cpu_ptr(&xdp_tx_bq);
>>>> +	int sent, i, err = 0;
>>>> +
>>>> +	sent = veth_xdp_xmit(dev, bq->count, bq->q, 0);
>>>
>>> Wait, veth_xdp_xmit() is just putting frames on a pointer ring. So
>>> you're introducing an additional per-cpu bulk queue, only to avoid lock
>>> contention around the existing pointer ring. But the pointer ring is
>>> per-rq, so if you have lock contention, this means you must have
>>> multiple CPUs servicing the same rq, no?
>>
>> Yes, it's possible. Not recommended though.
>>
> 
> I think the general per-cpu TX bulk queue is overkill.  There is a loop
> over packets in veth_xdp_rcv(struct veth_rq *rq, budget, *status), and
> the caller veth_poll() will call veth_xdp_flush(rq->dev).
> 
> Why can't you store this "temp" bulk array in struct veth_rq ?

Of course I can. But I thought tun has the same problem and we can 
decrease memory footprint by sharing the same storage between devices.
Or if other devices want to reduce queues so that we can use XDP on 
many-cpu servers and introduce locks, we can use this storage for that 
case as well.

Still do you prefer veth-specific solution?

> 
> You could even alloc/create it on the stack of veth_poll() and send it
> along via a pointer to veth_xdp_rcv).
> 

Toshiaki Makita
