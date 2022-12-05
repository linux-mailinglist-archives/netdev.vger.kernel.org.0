Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7C5642FDF
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 19:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbiLESYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 13:24:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbiLESY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 13:24:29 -0500
Received: from serv108.segi.ulg.ac.be (serv108.segi.ulg.ac.be [139.165.32.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9900AD67;
        Mon,  5 Dec 2022 10:24:27 -0800 (PST)
Received: from [192.168.1.33] (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 4AF24200AA55;
        Mon,  5 Dec 2022 19:24:26 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 4AF24200AA55
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1670264666;
        bh=oegBx7D9n9UZeLT5ZPWyzKQlRqgn7avVd5TC0coCwdQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=LLQVA6R2QqfN70BMJnbVkm+7a0rJK6/1IKDDI98N4BuHpvUnaflGVghahjrCzdPkT
         rUvkDicF388iRZjwaBS1WI2pa7w+WkFILC4fZt9qMEFAtYOS/H/Gvc+hFGIYbp8FNI
         3sIbM+GjPoJJHNiRbyjWvlC7l/xoBqZl/6ggvZVs7UhSif2wVW3sggcH8mwq4d9ezk
         YR+z/gEFt+Cpq4Ut0e/JP5vceWJIcubg9+5Hu1e1LioBneWTLr3BxgexX+DzjMBHP/
         in9SHu/pWTq5Fh0H3Jmw6S28Un36BhIIWSU3HFYqAwnAzPWhU+ctNG/MUeQhjKVDbO
         du8CwYsuRIipQ==
Message-ID: <a8dcb88c-16be-058b-b890-5d479d22c8a8@uliege.be>
Date:   Mon, 5 Dec 2022 19:24:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [RFC net] Fixes: b63c5478e9cb ("ipv6: ioam: Support for Queue
 depth data field")
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, pabeni@redhat.com,
        stable@vger.kernel.org
References: <20221205153557.28549-1-justin.iurman@uliege.be>
 <CANn89iLjGnyh0GgW_5kkMQJBCi-KfgwyvZwT1ou2FMY4ZDcMXw@mail.gmail.com>
 <CANn89iK3hMpJQ1w4peg2g35W+Oi3t499C5rUv7rcwzYtxDGBuw@mail.gmail.com>
From:   Justin Iurman <justin.iurman@uliege.be>
In-Reply-To: <CANn89iK3hMpJQ1w4peg2g35W+Oi3t499C5rUv7rcwzYtxDGBuw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/5/22 17:50, Eric Dumazet wrote:
> On Mon, Dec 5, 2022 at 5:30 PM Eric Dumazet <edumazet@google.com> wrote:
>>
>> Patch title seems
>>
>> On Mon, Dec 5, 2022 at 4:36 PM Justin Iurman <justin.iurman@uliege.be> wrote:
>>>
>>> This patch fixes a NULL qdisc pointer when retrieving the TX queue depth
>>> for IOAM.
>>>
>>> IMPORTANT: I suspect this fix is local only and the bug goes deeper (see
>>> reasoning below).
>>>
>>> Kernel panic:
>>> [...]
>>> RIP: 0010:ioam6_fill_trace_data+0x54f/0x5b0
>>> [...]
>>>
>>> ...which basically points to the call to qdisc_qstats_qlen_backlog
>>> inside net/ipv6/ioam6.c.
>>>
>>>  From there, I directly thought of a NULL pointer (queue->qdisc). To make
>>> sure, I added some printk's to know exactly *why* and *when* it happens.
>>> Here is the (summarized by queue) output:
>>>
>>> skb for TX queue 1, qdisc is ffff8b375eee9800, qdisc_sleeping is ffff8b375eee9800
>>> skb for TX queue 2, qdisc is ffff8b375eeefc00, qdisc_sleeping is ffff8b375eeefc00
>>> skb for TX queue 3, qdisc is ffff8b375eeef800, qdisc_sleeping is ffff8b375eeef800
>>> skb for TX queue 4, qdisc is ffff8b375eeec800, qdisc_sleeping is ffff8b375eeec800
>>> skb for TX queue 5, qdisc is ffff8b375eeea400, qdisc_sleeping is ffff8b375eeea400
>>> skb for TX queue 6, qdisc is ffff8b375eeee000, qdisc_sleeping is ffff8b375eeee000
>>> skb for TX queue 7, qdisc is ffff8b375eee8800, qdisc_sleeping is ffff8b375eee8800
>>> skb for TX queue 8, qdisc is ffff8b375eeedc00, qdisc_sleeping is ffff8b375eeedc00
>>> skb for TX queue 9, qdisc is ffff8b375eee9400, qdisc_sleeping is ffff8b375eee9400
>>> skb for TX queue 10, qdisc is ffff8b375eee8000, qdisc_sleeping is ffff8b375eee8000
>>> skb for TX queue 11, qdisc is ffff8b375eeed400, qdisc_sleeping is ffff8b375eeed400
>>> skb for TX queue 12, qdisc is ffff8b375eeea800, qdisc_sleeping is ffff8b375eeea800
>>> skb for TX queue 13, qdisc is ffff8b375eee8c00, qdisc_sleeping is ffff8b375eee8c00
>>> skb for TX queue 14, qdisc is ffff8b375eeea000, qdisc_sleeping is ffff8b375eeea000
>>> skb for TX queue 15, qdisc is ffff8b375eeeb800, qdisc_sleeping is ffff8b375eeeb800
>>> skb for TX queue 16, qdisc is NULL, qdisc_sleeping is NULL
>>>
>>> What the hell? So, not sure why queue #16 would *never* have a qdisc
>>> attached. Is it something expected I'm not aware of? As an FYI, here is
>>> the output of "tc qdisc list dev xxx":
>>>
>>> qdisc mq 0: root
>>> qdisc fq_codel 0: parent :10 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>>> qdisc fq_codel 0: parent :f limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>>> qdisc fq_codel 0: parent :e limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>>> qdisc fq_codel 0: parent :d limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>>> qdisc fq_codel 0: parent :c limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>>> qdisc fq_codel 0: parent :b limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>>> qdisc fq_codel 0: parent :a limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>>> qdisc fq_codel 0: parent :9 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>>> qdisc fq_codel 0: parent :8 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>>> qdisc fq_codel 0: parent :7 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>>> qdisc fq_codel 0: parent :6 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>>> qdisc fq_codel 0: parent :5 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>>> qdisc fq_codel 0: parent :4 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>>> qdisc fq_codel 0: parent :3 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>>> qdisc fq_codel 0: parent :2 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>>> qdisc fq_codel 0: parent :1 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>>>
>>> By the way, the NIC is an Intel XL710 40GbE QSFP+ (i40e driver, firmware
>>> version 8.50 0x8000b6c7 1.3082.0) and it was tested on latest "net"
>>> version (6.1.0-rc7+). Is this a bug in the i40e driver?
>>>
>>
>>> Cc: stable@vger.kernel.org
>>
>> Patch title is mangled. The Fixes: tag should appear here, not in the title.
>>
>>
>> Fixes: b63c5478e9cb ("ipv6: ioam: Support for Queue depth data field")
>>
>>> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
>>> ---
>>>   net/ipv6/ioam6.c | 11 +++++++----
>>>   1 file changed, 7 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/net/ipv6/ioam6.c b/net/ipv6/ioam6.c
>>> index 571f0e4d9cf3..2472a8a043c4 100644
>>> --- a/net/ipv6/ioam6.c
>>> +++ b/net/ipv6/ioam6.c
>>> @@ -727,10 +727,13 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
>>>                          *(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
>>>                  } else {
>>>                          queue = skb_get_tx_queue(skb_dst(skb)->dev, skb);
>>
>> Are you sure skb_dst(skb)->dev is correct at this stage, what about
>> stacked devices ?
>>
>>> -                       qdisc = rcu_dereference(queue->qdisc);
>>> -                       qdisc_qstats_qlen_backlog(qdisc, &qlen, &backlog);
>>> -
>>> -                       *(__be32 *)data = cpu_to_be32(backlog);
>>> +                       if (!queue->qdisc) {
>>
>> This is racy.
>>
>>> +                               *(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
>>> +                       } else {
>>> +                               qdisc = rcu_dereference(queue->qdisc);
>>> +                               qdisc_qstats_qlen_backlog(qdisc, &qlen, &backlog);
>>> +                               *(__be32 *)data = cpu_to_be32(backlog);
>>> +                       }
>>>                  }
>>>                  data += sizeof(__be32);
>>>          }
>>> --
>>> 2.25.1
>>>
>>
>> Quite frankly I suggest to revert b63c5478e9cb completely.
>>
>> The notion of Queue depth can not be properly gathered in Linux with a
>> multi queue model,
>> so why trying to get a wrong value ?
> 
> Additional reason for a revert is that qdisc_qstats_qlen_backlog() is
> reserved for net/sched

If by "reserved" you mean "only used by at the moment", then yes (with 
the only exception being IOAM). But some other functions are defined as 
well, and some are used elsewhere than the "net/sched" context. So I 
don't think it's really an issue to use this function "from somewhere else".

> code, I think it needs the qdisc lock to be held.

Good point. But is it really needed when called with rcu_read_lock?
