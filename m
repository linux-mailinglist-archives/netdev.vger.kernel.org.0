Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8117E2CCFB5
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 07:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387431AbgLCGnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 01:43:09 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:52866 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727677AbgLCGnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 01:43:08 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UHOJr3o_1606977744;
Received: from DustLi-Macbook.local(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0UHOJr3o_1606977744)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 03 Dec 2020 14:42:25 +0800
Subject: Re: Long delay on estimation_timer causes packet latency
To:     yunhong-cgl jiang <xintian1976@gmail.com>,
        Julian Anastasov <ja@ssi.bg>
Cc:     horms@verge.net.au, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, Yunhong Jiang <yunhjiang@ebay.com>
References: <D25792C1-1B89-45DE-9F10-EC350DC04ADC@gmail.com>
 <alpine.LFD.2.21.2004171029240.3962@ja.home.ssi.bg>
 <F48099A3-ECB3-46AF-8330-B829ED2ADA3F@gmail.com>
From:   "dust.li" <dust.li@linux.alibaba.com>
Message-ID: <d89672f8-a028-8690-0e6a-517631134ef6@linux.alibaba.com>
Date:   Thu, 3 Dec 2020 14:42:24 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <F48099A3-ECB3-46AF-8330-B829ED2ADA3F@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yunhong & Julian, any updates ?


We've encountered the same problem. With lots of ipvs

services plus many CPUs, it's easy to reproduce this issue.

I have a simple script to reproduce:

First add many ipvs services:

for((i=0;i<50000;i++)); do
         ipvsadm -A -t 10.10.10.10:$((2000+$i))
done


Then, check the latency of estimation_timer() using bpftrace:

#!/usr/bin/bpftrace

kprobe:estimation_timer {
         @enter = nsecs;
}

kretprobe:estimation_timer {
         $exit = nsecs;
         printf("latency: %ld us\n", (nsecs - @enter)/1000);
}

I observed about 268ms delay on my 104 CPUs test server.

Attaching 2 probes...
latency: 268807 us
latency: 268519 us
latency: 269263 us


And I tried moving estimation_timer() into a delayed

workqueue, this do make things better. But since the

estimation won't give up CPU, it can run for pretty

long without scheduling on a server which don't have

preempt enabled, so tasks on that CPU can't get executed

during that period.


Since the estimation repeated every 2s, we can't call

cond_resched() to give up CPU in the middle of iterating the

est_list, or the estimation will be quite inaccurate.

Besides the est_list needs to be protected.


I haven't found any ideal solution yet, currently, we just

moved the estimation into kworker and add sysctl to allow

us to disable the estimation, since we don't need the

estimation anyway.


Our patches is pretty simple now, if you think it's useful,

I can paste them


Do you guys have any suggestions or solutions ?


Thanks a lot !

Dust



On 4/18/20 12:56 AM, yunhong-cgl jiang wrote:
> Thanks for reply.
>
> Yes, our patch changes the est_list to a RCU list. Will do more testing and send out the patch.
>
> Thanks
> —Yunhong
>
>
>> On Apr 17, 2020, at 12:47 AM, Julian Anastasov <ja@ssi.bg> wrote:
>>
>>
>> 	Hello,
>>
>> On Thu, 16 Apr 2020, yunhong-cgl jiang wrote:
>>
>>> Hi, Simon & Julian,
>>> 	We noticed that on our kubernetes node utilizing IPVS, the estimation_timer() takes very long (>200sm as shown below). Such long delay on timer softirq causes long packet latency.
>>>
>>>           <idle>-0     [007] dNH. 25652945.670814: softirq_raise: vec=1 [action=TIMER]
>>> .....
>>>           <idle>-0     [007] .Ns. 25652945.992273: softirq_exit: vec=1 [action=TIMER]
>>>
>>> 	The long latency is caused by the big service number (>50k) and large CPU number (>80 CPUs),
>>>
>>> 	We tried to move the timer function into a kernel thread so that it will not block the system and seems solves our problem. Is this the right direction? If yes, we will do more testing and send out the RFC patch. If not, can you give us some suggestion?
>> 	Using kernel thread is a good idea. For this to work, we can
>> also remove the est_lock and to use RCU for est_list.
>> The writers ip_vs_start_estimator() and ip_vs_stop_estimator() already
>> run under common mutex __ip_vs_mutex, so they not need any
>> synchronization. We need _bh lock usage in estimation_timer().
>> Let me know if you need any help with the patch.
>>
>> Regards
>>
>> --
>> Julian Anastasov <ja@ssi.bg>
