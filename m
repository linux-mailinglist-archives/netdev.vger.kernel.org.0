Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 316127498F
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 11:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390196AbfGYJFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 05:05:19 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2755 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388104AbfGYJFT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 05:05:19 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 5F708DB57924582CF9E2;
        Thu, 25 Jul 2019 17:05:16 +0800 (CST)
Received: from [127.0.0.1] (10.74.221.148) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Thu, 25 Jul 2019
 17:05:10 +0800
Subject: Re: [RFC] performance regression with commit-id<adb03115f459> ("net:
 get rid of an signed integer overflow in ip_idents_reserve()")
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <051e93d4-0206-7416-e639-376b8d2eb98b@hisilicon.com>
 <3d77a08a-22e9-16e8-4091-c5ba4851ff13@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "guoyang (C)" <guoyang2@huawei.com>,
        "zhudacai@hisilicon.com" <zhudacai@hisilicon.com>
From:   Zhangshaokun <zhangshaokun@hisilicon.com>
Message-ID: <80cfa8a8-5143-df42-2524-6ce4cade1592@hisilicon.com>
Date:   Thu, 25 Jul 2019 17:05:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.1.1
MIME-Version: 1.0
In-Reply-To: <3d77a08a-22e9-16e8-4091-c5ba4851ff13@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.74.221.148]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

Thanks your quick reply.

On 2019/7/24 16:56, Eric Dumazet wrote:
> 
> 
> On 7/24/19 10:38 AM, Zhangshaokun wrote:
>> Hi,
>>
>> I've observed an significant performance regression with the following commit-id <adb03115f459>
>> ("net: get rid of an signed integer overflow in ip_idents_reserve()").
> 
> Yes this UBSAN false positive has been painful
> 
> 
> 
>>
>> Here are my test scenes:
>> ----Server----
>> Cmd: iperf3 -s xxx.xxx.xxxx.xxx -p 10000 -i 0 -A 0
>> Kenel: 4.19.34
>> Server number: 32
>> Port: 10000 – 10032
>> CPU affinity: 0 – 32
>> CPU architecture: aarch64
>> NUMA node0 CPU(s): 0-23
>> NUMA node1 CPU(s): 24-47
>>
>> ----Client----
>> Cmd: iperf3 -u -c xxx.xxx.xxxx.xxx -p 10000 -l 16 -b 0 -t 0 -i 0 -A 8
>> Kenel: 4.19.34
>> Client number: 32
>> Port: 10000 – 10032
>> CPU affinity: 0 – 32
>> CPU architecture: aarch64
>> NUMA node0 CPU(s): 0-23
>> NUMA node1 CPU(s): 24-47
>>
>> Firstly, With patch <adb03115f459> ("net: get rid of an signed integer overflow in ip_idents_reserve()") ,
>> client’s cpu is 100%, and function ip_idents_reserve() cpu usage is very high, but the result is not good.
>> 03:08:32 AM     IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s   %ifutil
>> 03:08:33 AM      eth0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
>> 03:08:33 AM      eth1      0.00 3461296.00      0.00 196049.97      0.00      0.00      0.00      0.00
>> 03:08:33 AM        lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
>>
>> Secondly, revert that patch, use atomic_add_return() instead, the result is better, as below:
>> 03:23:24 AM     IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s   %ifutil
>> 03:23:25 AM        lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
>> 03:23:25 AM      eth1      0.00 12834590.00      0.00 726959.20      0.00      0.00      0.00      0.00
>> 03:23:25 AM      eth0      7.00     11.00      0.40      2.95      0.00      0.00      0.00      0.00
>>
>> Thirdly, atomic is not used in ip_idents_reserve() completely ,while each cpu core allocates its own ID segment,
>> Such as: cpu core0 allocate ID 0 – 1023, cpu core1 allocate 1024 – 2047, …,etc
>> the result is the best:
> 
> Not sure what you mean.
> 
> Less entropy in IPv4 ID is not going to help when fragments _are_ needed.
> 
> Send 40,000 datagrams of 2000 bytes each, add delays, reorders, and boom, most of the packets will be lost.
> 
> This is not because your use case does not need proper IP ID that we can mess with them.
> 

Got it, thanks your more explanation.

> If you need to send packets very fast,  maybe use AF_PACKET ?
> 

Ok, I will try it later.

>> 03:27:06 AM     IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s   %ifutil
>> 03:27:07 AM        lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
>> 03:27:07 AM      eth1      0.00 14275505.00      0.00 808573.53      0.00      0.00      0.00      0.00
>> 03:27:07 AM      eth0      0.00      2.00      0.00      0.18      0.00      0.00      0.00      0.00
>>
>> Because atomic operation performance is bottleneck when cpu core number increase, Can we revert the patch or
>> use ID segment for each cpu core instead?
> 
> 
> This has been discussed in the past.
> 
> https://lore.kernel.org/lkml/b0160f4b-b996-b0ee-405a-3d5f1866272e@gmail.com/
> 
> We can revert now UBSAN has been fixed.
> 
> Or even use Peter patch : https://lore.kernel.org/lkml/20181101172739.GA3196@hirez.programming.kicks-ass.net/
> 

I have tried this patch under the condition that I remove try_cmpxchg because there is no this API in arm64 :
09:21:16 PM     IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s   %ifutil
09:21:17 PM        lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
09:21:17 PM      eth1      0.00 10434613.00      0.00 591023.00      0.00      0.00      0.00      0.00
09:21:17 PM      eth0      1.00      0.00      0.12      0.00      0.00      0.00      0.00      0.00

The result is 10434613.00 pps and it is less than the atomic_add_return(12834590.00 pps).
Any thoughts?

Thanks,
Shaokun

> However, you will still hit badly a shared cache line, not matter what.
> 
> Some arches are known to have terrible LL/SC implementation :/
> 
> 
> .
> 

