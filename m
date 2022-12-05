Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24A61642FA5
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 19:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiLESOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 13:14:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbiLESOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 13:14:17 -0500
Received: from serv108.segi.ulg.ac.be (serv108.segi.ulg.ac.be [139.165.32.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F2F201B9;
        Mon,  5 Dec 2022 10:14:11 -0800 (PST)
Received: from [192.168.1.33] (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 124E9200AA45;
        Mon,  5 Dec 2022 19:14:06 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 124E9200AA45
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1670264046;
        bh=/wP+S/DrFlqf13v618zwPFuHQLLUwwEJR1zpDmSBCZE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=qIVDzcpfRyv6K+pKFYfQQ+jyxYAtzmLczwg5aFKSE69nWmo+sFcWSMQE9yMK/+rRr
         w68dl/SH63fK0j6n9RBjRuKthRH2ErcSS8E8bdY344CRHDMPPWG4+/mFzP/Wgcejor
         JeCu4grX/lh9lBNu1FYjGFfeR29LQMvkgd92nafZgckgXOM2cSaIpLpQ9DhOZ9Gaz2
         0+fpO/OiCpN6xgkPlRr+J2tr+2/8cAfIZ8hTeHnG6Lw03TpeqZJOea28PYxhrhtRjp
         FarEisBt9mUXJ6sz2gCjC0CV7U5C0c0Jg617vvOVk8ozYTolwEgz7VEQMDF68DORJX
         lm9IzEZPSBQ2g==
Message-ID: <b815e123-dc6e-52dd-76f1-b05f9424f8e0@uliege.be>
Date:   Mon, 5 Dec 2022 19:14:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [RFC net] Fixes: b63c5478e9cb ("ipv6: ioam: Support for Queue
 depth data field")
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, pabeni@redhat.com,
        stable@vger.kernel.org
References: <20221205153557.28549-1-justin.iurman@uliege.be>
 <CANn89iLjGnyh0GgW_5kkMQJBCi-KfgwyvZwT1ou2FMY4ZDcMXw@mail.gmail.com>
Content-Language: en-US
From:   Justin Iurman <justin.iurman@uliege.be>
In-Reply-To: <CANn89iLjGnyh0GgW_5kkMQJBCi-KfgwyvZwT1ou2FMY4ZDcMXw@mail.gmail.com>
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

On 12/5/22 17:30, Eric Dumazet wrote:
> Patch title seems
> 
> On Mon, Dec 5, 2022 at 4:36 PM Justin Iurman <justin.iurman@uliege.be> wrote:
>>
>> This patch fixes a NULL qdisc pointer when retrieving the TX queue depth
>> for IOAM.
>>
>> IMPORTANT: I suspect this fix is local only and the bug goes deeper (see
>> reasoning below).
>>
>> Kernel panic:
>> [...]
>> RIP: 0010:ioam6_fill_trace_data+0x54f/0x5b0
>> [...]
>>
>> ...which basically points to the call to qdisc_qstats_qlen_backlog
>> inside net/ipv6/ioam6.c.
>>
>>  From there, I directly thought of a NULL pointer (queue->qdisc). To make
>> sure, I added some printk's to know exactly *why* and *when* it happens.
>> Here is the (summarized by queue) output:
>>
>> skb for TX queue 1, qdisc is ffff8b375eee9800, qdisc_sleeping is ffff8b375eee9800
>> skb for TX queue 2, qdisc is ffff8b375eeefc00, qdisc_sleeping is ffff8b375eeefc00
>> skb for TX queue 3, qdisc is ffff8b375eeef800, qdisc_sleeping is ffff8b375eeef800
>> skb for TX queue 4, qdisc is ffff8b375eeec800, qdisc_sleeping is ffff8b375eeec800
>> skb for TX queue 5, qdisc is ffff8b375eeea400, qdisc_sleeping is ffff8b375eeea400
>> skb for TX queue 6, qdisc is ffff8b375eeee000, qdisc_sleeping is ffff8b375eeee000
>> skb for TX queue 7, qdisc is ffff8b375eee8800, qdisc_sleeping is ffff8b375eee8800
>> skb for TX queue 8, qdisc is ffff8b375eeedc00, qdisc_sleeping is ffff8b375eeedc00
>> skb for TX queue 9, qdisc is ffff8b375eee9400, qdisc_sleeping is ffff8b375eee9400
>> skb for TX queue 10, qdisc is ffff8b375eee8000, qdisc_sleeping is ffff8b375eee8000
>> skb for TX queue 11, qdisc is ffff8b375eeed400, qdisc_sleeping is ffff8b375eeed400
>> skb for TX queue 12, qdisc is ffff8b375eeea800, qdisc_sleeping is ffff8b375eeea800
>> skb for TX queue 13, qdisc is ffff8b375eee8c00, qdisc_sleeping is ffff8b375eee8c00
>> skb for TX queue 14, qdisc is ffff8b375eeea000, qdisc_sleeping is ffff8b375eeea000
>> skb for TX queue 15, qdisc is ffff8b375eeeb800, qdisc_sleeping is ffff8b375eeeb800
>> skb for TX queue 16, qdisc is NULL, qdisc_sleeping is NULL
>>
>> What the hell? So, not sure why queue #16 would *never* have a qdisc
>> attached. Is it something expected I'm not aware of? As an FYI, here is
>> the output of "tc qdisc list dev xxx":
>>
>> qdisc mq 0: root
>> qdisc fq_codel 0: parent :10 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>> qdisc fq_codel 0: parent :f limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>> qdisc fq_codel 0: parent :e limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>> qdisc fq_codel 0: parent :d limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>> qdisc fq_codel 0: parent :c limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>> qdisc fq_codel 0: parent :b limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>> qdisc fq_codel 0: parent :a limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>> qdisc fq_codel 0: parent :9 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>> qdisc fq_codel 0: parent :8 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>> qdisc fq_codel 0: parent :7 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>> qdisc fq_codel 0: parent :6 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>> qdisc fq_codel 0: parent :5 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>> qdisc fq_codel 0: parent :4 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>> qdisc fq_codel 0: parent :3 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>> qdisc fq_codel 0: parent :2 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>> qdisc fq_codel 0: parent :1 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>>
>> By the way, the NIC is an Intel XL710 40GbE QSFP+ (i40e driver, firmware
>> version 8.50 0x8000b6c7 1.3082.0) and it was tested on latest "net"
>> version (6.1.0-rc7+). Is this a bug in the i40e driver?
>>
> 
>> Cc: stable@vger.kernel.org
> 
> Patch title is mangled. The Fixes: tag should appear here, not in the title.
> 
> 
> Fixes: b63c5478e9cb ("ipv6: ioam: Support for Queue depth data field")

Correct, sorry about that. Fortunately, this is only an RFC.

>> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
>> ---
>>   net/ipv6/ioam6.c | 11 +++++++----
>>   1 file changed, 7 insertions(+), 4 deletions(-)
>>
>> diff --git a/net/ipv6/ioam6.c b/net/ipv6/ioam6.c
>> index 571f0e4d9cf3..2472a8a043c4 100644
>> --- a/net/ipv6/ioam6.c
>> +++ b/net/ipv6/ioam6.c
>> @@ -727,10 +727,13 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
>>                          *(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
>>                  } else {
>>                          queue = skb_get_tx_queue(skb_dst(skb)->dev, skb);
> 
> Are you sure skb_dst(skb)->dev is correct at this stage, what about
> stacked devices ?

It is. I don't see a problem here.

>> -                       qdisc = rcu_dereference(queue->qdisc);
>> -                       qdisc_qstats_qlen_backlog(qdisc, &qlen, &backlog);
>> -
>> -                       *(__be32 *)data = cpu_to_be32(backlog);
>> +                       if (!queue->qdisc) {
> 
> This is racy.

True. The intent was to start a discussion on the aforementioned bug. I 
can still fix that later in the PATCH version.

>> +                               *(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
>> +                       } else {
>> +                               qdisc = rcu_dereference(queue->qdisc);
>> +                               qdisc_qstats_qlen_backlog(qdisc, &qlen, &backlog);
>> +                               *(__be32 *)data = cpu_to_be32(backlog);
>> +                       }
>>                  }
>>                  data += sizeof(__be32);
>>          }
>> --
>> 2.25.1
>>
> 
> Quite frankly I suggest to revert b63c5478e9cb completely.

IMHO, I'd definitely not go for a revert. This is an important IOAM 
metric. And, besides, this is not really the topic here. The issue can 
be fixed easily for IOAM, but this thread is more about discussing the 
strange behavior I observed with qdisc's. Is it a bug? If so, let's find 
and fix the cause before fixing the consequences. Is it only for i40e or 
some others too? It's probably worth investigating, regardless of this 
patch.

> The notion of Queue depth can not be properly gathered in Linux with a
> multi queue model,
> so why trying to get a wrong value ?

I don't think it's true. The queue depth is a per queue metric, and this 
is exactly what qdisc_qstats_qlen_backlog provides in this case. I can't 
find any issue regarding a wrong value. If what you say is true, then 
let's remove it from everywhere (tc reports the queue depth). Not convinced.
