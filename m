Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D17B921A6BD
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 20:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgGISUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 14:20:06 -0400
Received: from out0-134.mail.aliyun.com ([140.205.0.134]:50669 "EHLO
        out0-134.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbgGISUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 14:20:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=alibaba-inc.com; s=default;
        t=1594318803; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        bh=dPRl5SXYkofeFiG/LX5Y66r6m+NsbIgqLMpHLZHvMvg=;
        b=Tj3hiAoQA9+w7x7Z8qRQf+jLkbq2xSvZcS8bEIC+zJmmsyrF3hae80Q2oWkapeB02A8mTDW6KXXvKgP9r52l3jYsotgm6tC6wkaXN4rJOCPOa/tPFmEU71wAmcBIQx0fnXeguf3g5ElRrdT2oqZOI79w6xVf0wqiXS7OyFAYa8k=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e02c03268;MF=xiangning.yu@alibaba-inc.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---.I-zs8tE_1594318801;
Received: from US-118000MP.local(mailfrom:xiangning.yu@alibaba-inc.com fp:SMTPD_---.I-zs8tE_1594318801)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 10 Jul 2020 02:20:02 +0800
Subject: Re: [PATCH net-next v2 2/2] net: sched: Lockless Token Bucket (LTB)
 qdisc
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <4835f4cb-eee0-81e7-d935-5ad85767802c@alibaba-inc.com>
 <554197ce-cef1-0e75-06d7-56dbef7c13cc@gmail.com>
 <d1716bc1-a975-54a3-8b7e-a3d3bcac69c5@alibaba-inc.com>
 <91fc642f-6447-4863-a182-388591cc1cc0@gmail.com>
 <387fe086-9596-c71e-d1d9-998749ae093c@alibaba-inc.com>
 <c4796548-5c3b-f3db-a060-1e46fb42970a@gmail.com>
 <7ea368d0-d12c-2f04-17a7-1e31a61bbe2b@alibaba-inc.com>
 <825c8af6-66b5-eaf4-2c46-76d018489ebd@gmail.com>
From:   "=?UTF-8?B?WVUsIFhpYW5nbmluZw==?=" <xiangning.yu@alibaba-inc.com>
Message-ID: <345bf201-f7cf-c821-1dba-50d0f2b76101@alibaba-inc.com>
Date:   Fri, 10 Jul 2020 02:20:00 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <825c8af6-66b5-eaf4-2c46-76d018489ebd@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/9/20 10:15 AM, Eric Dumazet wrote:
> 
> 
> On 7/9/20 10:04 AM, YU, Xiangning wrote:
>>
>>
>> On 7/8/20 6:24 PM, Eric Dumazet wrote:
>>>
>>>
>>> On 7/8/20 5:58 PM, YU, Xiangning wrote:
>>>>
>>>>
>>>> On 7/8/20 5:08 PM, Eric Dumazet wrote:
>>>>>
>>>>>
>>>>> On 7/8/20 4:59 PM, YU, Xiangning wrote:
>>>>>
>>>>>>
>>>>>> Yes, we are touching a cache line here to make sure aggregation tasklet is scheduled immediately. In most cases it is a call to test_and_set_bit(). 
>>>>>
>>>>>
>>>>> test_and_set_bit() is dirtying the cache line even if the bit is already set.
>>>>>
>>>>
>>>> Yes. I do hope we can avoid this.
>>>>
>>>>>>
>>>>>> We might be able to do some inline processing without tasklet here, still we need to make sure the aggregation won't run simultaneously on multiple CPUs. 
>>>>>
>>>>> I am actually surprised you can reach 8 Mpps with so many cache line bouncing around.
>>>>>
>>>>> If you replace the ltb qdisc with standard mq+pfifo_fast, what kind of throughput do you get ?
>>>>>
>>>>
>>>> Just tried it using pktgen, we are far from baseline. I can get 13Mpps with 10 threads in my test setup.
>>>
>>> This is quite low performance.
>>>
>>> I suspect your 10 threads are sharing a smaller number of TX queues perhaps ?
>>>
>>
>> Thank you for the hint. Looks like pktgen only used the first 10 queues.
>>
>> I fined tuned ltb to reach 10M pps with 10 threads last night. I can further push the limit. But we probably won't be able to get close to baseline. Rate limiting really brings a lot of headache, at least we are not burning CPUs to get this result.
> 
> Well, at Google we no longer have this issue.
> 
> We adopted EDT model, so that rate limiting can be done in eBPF, by simply adjusting skb->tstamp.
> 
> The qdisc is MQ + FQ.
> 
> Stanislas Fomichev will present this use case at netdev conference 
> 
> https://netdevconf.info/0x14/session.html?talk-replacing-HTB-with-EDT-and-BPF
> 
This is cool, I would love to learn more about this!

Still please correct me if I'm wrong. This looks more like pacing on a per-flow basis, how do you support an overall rate limiting of multiple flows? Each individual flow won't have a global rate usage about others.

Thanks,
- Xiangning
