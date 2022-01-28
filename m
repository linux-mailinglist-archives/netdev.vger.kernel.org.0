Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF7C49F4C2
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 08:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243077AbiA1H4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 02:56:31 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.51]:44221 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiA1H4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 02:56:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1643356584;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:References:Cc:To:From:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=ZzqXPa82IBNEGYKQz95uFBzc3aktCqKLWKlNwv1H0BQ=;
    b=nnLF4/VjWRZcHBwOJGZZJsxraZK0Z2DtdPg7gQ/hadNYiI/mneKwtNcrO1+2bWnHEE
    vfVDxn8/qtKM2G6q/5QkUN6QqwtVF4jCW0CST54/PNjnLl4ZRbAfinXOw594kUr2AI1X
    k/vooVhSW7z4vaoH+O9P0YWsR6SEIZTCxGCff9cn97vUIYIaA24/nCtfCgSlS0wAVlhx
    RZwUnwfIPTqunaHOfQMB9DDSXuRVaDpCEJXOj4vzDWRaoOh5ZlBLXvKcNGoOGGoDNOEG
    ePGuwQsooOgQIWBCCQ3reiBDzNAsjcN5ZOEiX2LnojoPFFRhTyeltwUtPn9zDbqHx59u
    J2jQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVuBOfXW6v7w=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfa:f900::b82]
    by smtp.strato.de (RZmta 47.38.0 AUTH)
    with ESMTPSA id zaacbfy0S7uOPvv
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 28 Jan 2022 08:56:24 +0100 (CET)
Message-ID: <24e6da96-a3e5-7b4e-102b-b5676770b80e@hartkopp.net>
Date:   Fri, 28 Jan 2022 08:56:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net] can: isotp: isotp_rcv_cf(): fix so->rx race problem
Content-Language: en-US
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        mkl@pengutronix.de
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220117120102.2395157-1-william.xuanziyang@huawei.com>
 <53279d6d-298c-5a85-4c16-887c95447825@hartkopp.net>
 <280e10c1-d1f4-f39e-fa90-debd56f1746d@huawei.com>
 <eaafaca3-f003-ca56-c04c-baf6cf4f7627@hartkopp.net>
 <890d8209-f400-a3b0-df9c-3e198e3834d6@huawei.com>
 <1fb4407a-1269-ec50-0ad5-074e49f91144@hartkopp.net>
 <2aba02d4-0597-1d55-8b3e-2c67386f68cf@huawei.com>
 <64695483-ff75-4872-db81-ca55763f95cf@hartkopp.net>
 <d7e69278-d741-c706-65e1-e87623d9a8e8@huawei.com>
 <97339463-b357-3e0e-1cbf-c66415c08129@hartkopp.net>
In-Reply-To: <97339463-b357-3e0e-1cbf-c66415c08129@hartkopp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Answering myself ...

I've seen the frame processing sometimes freezes for one second when 
stressing the isotp_rcv() from multiple sources. This finally freezes 
the entire softirq which is either not good and not needed as we only 
need to fix this race for stress tests - and not for real world usage 
that does not create this case.

Therefore I created a V2 patch which uses the spin_trylock() to simply 
drop the incomming frame in the race condition.

https://lore.kernel.org/linux-can/20220128074327.52229-1-socketcan@hartkopp.net/T/

Please take a look, if it also fixes the issue in your test setup.

Thanks & best regards,
Oliver

On 27.01.22 20:44, Oliver Hartkopp wrote:
> Hello Ziyang Xuan,
> 
> On 21.01.22 02:50, Ziyang Xuan (William) wrote:
>>>
>>> On 20.01.22 12:28, Ziyang Xuan (William) wrote:
>>>>>
>>>>> On 20.01.22 07:24, Ziyang Xuan (William) wrote:
>>>>>
>>>>>> I have reproduced the syz problem with Marc's commit, the commit 
>>>>>> can not fix the panic problem.
>>>>>> So I tried to find the root cause for panic and gave my solution.
>>>>>>
>>>>>> Marc's commit just fix the condition that packet size bigger than 
>>>>>> INT_MAX which trigger
>>>>>> tpcon::{idx,len} integer overflow, but the packet size is 4096 in 
>>>>>> the syz problem.
>>>>>>
>>>>>> so->rx.len is 0 after the following logic in isotp_rcv_ff():
>>>>>>
>>>>>> /* get the FF_DL */
>>>>>> so->rx.len = (cf->data[ae] & 0x0F) << 8;
>>>>>> so->rx.len += cf->data[ae + 1];
>>>>>>
>>>>>> so->rx.len is 4096 after the following logic in isotp_rcv_ff():
>>>>>>
>>>>>> /* FF_DL = 0 => get real length from next 4 bytes */
>>>>>> so->rx.len = cf->data[ae + 2] << 24;
>>>>>> so->rx.len += cf->data[ae + 3] << 16;
>>>>>> so->rx.len += cf->data[ae + 4] << 8;
>>>>>> so->rx.len += cf->data[ae + 5];
>>>>>>
>>>>>
>>>>> In these cases the values 0 could be the minimum value in 
>>>>> so->rx.len - but e.g. the value 0 can not show up in isotp_rcv_cf() 
>>>>> as this function requires so->rx.state to be ISOTP_WAIT_DATA.
>>>>
>>>> Consider the scenario that isotp_rcv_cf() and isotp_rcv_cf() are 
>>>> concurrent for the same isotp_sock as following sequence:
>>>
>>> o_O
>>>
>>> Sorry but the receive path is not designed to handle concurrent 
>>> receptions that would run isotp_rcv_cf() and isotp_rcv_ff() 
>>> simultaneously.
>>>
>>>> isotp_rcv_cf()
>>>> if (so->rx.state != ISOTP_WAIT_DATA) [false]
>>>>                          isotp_rcv_ff()
>>>>                          so->rx.state = ISOTP_IDLE
>>>>                          /* get the FF_DL */ [so->rx.len == 0]
>>>> alloc_skb() [so->rx.len == 0]
>>>>                          /* FF_DL = 0 => get real length from next 4 
>>>> bytes */ [so->rx.len == 4096]
>>>> skb_put(nskb, so->rx.len) [so->rx.len == 4096]
>>>> skb_over_panic()
>>>>
>>>
>>> Even though this case is not possible with a real CAN bus due to the 
>>> CAN frame transmission times we could introduce some locking (or 
>>> dropping of concurrent CAN frames) in isotp_rcv() - but this code 
>>> runs in net softirq context ...
>>>
> 
> As discussed off-list I added a spin_lock() in isotp_rcv() as 
> https://www.kernel.org/doc/htmldocs/kernel-locking/lock-softirqs.html 
> suggests.
> 
> Please give this patch[1] a try in your test setup.
> 
> Many thanks,
> Oliver
> 
> [1]: 
> https://lore.kernel.org/linux-can/20220127192429.336335-1-socketcan@hartkopp.net/T/ 
> 
