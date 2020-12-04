Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01F582CE690
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 04:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbgLDD2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 22:28:15 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:34340 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726316AbgLDD2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 22:28:15 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R321e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UHTEtOx_1607052450;
Received: from DustLi-Macbook.local(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0UHTEtOx_1607052450)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 04 Dec 2020 11:27:30 +0800
Subject: Re: Long delay on estimation_timer causes packet latency
To:     Julian Anastasov <ja@ssi.bg>
Cc:     yunhong-cgl jiang <xintian1976@gmail.com>, horms@verge.net.au,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        Yunhong Jiang <yunhjiang@ebay.com>
References: <D25792C1-1B89-45DE-9F10-EC350DC04ADC@gmail.com>
 <alpine.LFD.2.21.2004171029240.3962@ja.home.ssi.bg>
 <F48099A3-ECB3-46AF-8330-B829ED2ADA3F@gmail.com>
 <d89672f8-a028-8690-0e6a-517631134ef6@linux.alibaba.com>
 <2cf7e20-89c0-2a40-d27e-3d663e7080cb@ssi.bg>
From:   "dust.li" <dust.li@linux.alibaba.com>
Message-ID: <81aff736-70f0-9e14-de24-ba943f244bd2@linux.alibaba.com>
Date:   Fri, 4 Dec 2020 11:27:30 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2cf7e20-89c0-2a40-d27e-3d663e7080cb@ssi.bg>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/3/20 4:48 PM, Julian Anastasov wrote:
> 	Hello,
>
> On Thu, 3 Dec 2020, dust.li wrote:
>
>> Hi Yunhong & Julian, any updates ?
>>
>>
>> We've encountered the same problem. With lots of ipvs
>>
>> services plus many CPUs, it's easy to reproduce this issue.
>>
>> I have a simple script to reproduce:
>>
>> First add many ipvs services:
>>
>> for((i=0;i<50000;i++)); do
>>          ipvsadm -A -t 10.10.10.10:$((2000+$i))
>> done
>>
>>
>> Then, check the latency of estimation_timer() using bpftrace:
>>
>> #!/usr/bin/bpftrace
>>
>> kprobe:estimation_timer {
>>          @enter = nsecs;
>> }
>>
>> kretprobe:estimation_timer {
>>          $exit = nsecs;
>>          printf("latency: %ld us\n", (nsecs - @enter)/1000);
>> }
>>
>> I observed about 268ms delay on my 104 CPUs test server.
>>
>> Attaching 2 probes...
>> latency: 268807 us
>> latency: 268519 us
>> latency: 269263 us
>>
>>
>> And I tried moving estimation_timer() into a delayed
>>
>> workqueue, this do make things better. But since the
>>
>> estimation won't give up CPU, it can run for pretty
>>
>> long without scheduling on a server which don't have
>>
>> preempt enabled, so tasks on that CPU can't get executed
>>
>> during that period.
>>
>>
>> Since the estimation repeated every 2s, we can't call
>>
>> cond_resched() to give up CPU in the middle of iterating the
>>
>> est_list, or the estimation will be quite inaccurate.
>>
>> Besides the est_list needs to be protected.
>>
>>
>> I haven't found any ideal solution yet, currently, we just
>>
>> moved the estimation into kworker and add sysctl to allow
>>
>> us to disable the estimation, since we don't need the
>>
>> estimation anyway.
>>
>>
>> Our patches is pretty simple now, if you think it's useful,
>>
>> I can paste them
>>
>>
>> Do you guys have any suggestions or solutions ?
> 	When I saw the report first time, I thought on this
> issue and here is what I think:
>
> - single delayed work (slow to stop them if using many)
>
> - the delayed work walks say 64 lists with estimators and
> reschedules itself for the next 30ms, as result, 30ms*64=1920ms,
> 80ms will be idle up to the 2000ms period for estimation
> for every list. As result, every list is walked once per 2000ms.
> If 30ms is odd for all kind of HZ values, this can be
> 20ms * 100.
>
> - work will use spin_lock_bh(&s->lock) to protect the
> entries, we do not want delays between /proc readers and
> the work if using mutex. But _bh locks stop timers and
> networking for short time :( Not sure yet if just spin_lock
> is safe for both /proc and estimator's work.
>
> - while walking one of the 64 lists we should use just
> rcu read locking for the current list, no cond_resched_rcu
> because we do not know how to synchronize while entries are
> removed at the same time. For now using array with 64 lists
> solves this problem.
>
> - the algorith will look like this:
>
> 	int row = 0;
>
> 	for () {
> 		rcu_read_lock();
> 		list_for_each_entry_rcu(e, &ipvs->est_list[row], list) {
>
> 		...
>
> 			/* Should we stop immediately ? */
> 			if (!ipvs->enable || stopping delayed work) {
> 				rcu_read_unlock();
> 				goto out;
> 			}
> 		}
> 		/* rcu_read_unlock will reschedule if needed
> 		 * but we know where to start from the next time,
> 		 * i.e. from next slot
> 		 */
> 		rcu_read_unlock();
> 		reschedule delayed work for +30ms or +110ms if last row
> 		by using queue_delayed_work*()
> 		row ++;
> 		if (row >= 64)
> 			row = 0;
> 	}
>
> out:
>
> - the drawback is that without cond_resched_rcu we are not
> fair to other processes, solution is needed, we just reduce
> the problem by using 64 lists which can be imbalanced.
>
> - next goal: entries should be removed with list_del_rcu,
> without any locks, we do not want to delay configurations,
> ipvs->est_lock should be removed.
>
> - now the problem is how to spread the entries to 64 lists.
> One way is randomly, in this case first estimation may be
> for less than 2000ms. In this case, less entries means
> less work for all 64 steps. But what if entries are removed
> and some slots become empty and others too large?
>
> - if we want to make the work equal for all 64 passes, we
> can rebalance the lists, say on every 2000ms move some
> entries to neighbour list. As result, one entry can be
> estimated after 1970ms or 2030ms. But this is complication
> not possible with the RCU locking, we need a safe way
> to move entries to neighbour list, say if work walks
> row 0 we can rebalance between rows 32 and 33 which are
> 1 second away of row 0. And not all list primitives allow
> it for _rcu.
>
> - next options is to insert entries in some current list,
> if their count reaches, say 128, then move to the next list
> for inserting. This option tries to provide exact 2000ms
> delay for the first estimation for the newly added entry.
>
> 	We can start with some implementation and see if
> your tests are happy.

Thanks for sharing your thoughts !


I think it's a good idea to split the est_list into different

slots, I believe it will dramatically reduce the delay brought

by estimation.


My only concern is the cost of the estimation when the number of

services is large. Splitting the est_list won't reduce the real

work to do.

In our case, each estimation cost at most 268ms/2000ms, which is

about 13% of one CPU hyper-thread, and this should be a common case

in a large K8S cluster with lots of services.

Since the estimation is not needed in our environment at all, it's

just a waste of CPU resource. Have you ever consider add a switch to

let the user turn the estimator off ?


Thanks !

Dust


