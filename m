Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69B7A32670
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 04:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbfFCCLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 22:11:38 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:38538 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726941AbfFCCLi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Jun 2019 22:11:38 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D78CB515A48FE1F0898B;
        Mon,  3 Jun 2019 10:11:35 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Mon, 3 Jun 2019
 10:11:29 +0800
Subject: Re: [PATCH v2 net-next] net: link_watch: prevent starvation when
 processing linkwatch wq
To:     Salil Mehta <salil.mehta@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>
References: <1559293233-43017-1-git-send-email-linyunsheng@huawei.com>
 <8a93eecf7a7a4ffd81f1b7d08f1a7442@huawei.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <58960b44-63bb-21da-b995-2b9701a58126@huawei.com>
Date:   Mon, 3 Jun 2019 10:11:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <8a93eecf7a7a4ffd81f1b7d08f1a7442@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/5/31 19:17, Salil Mehta wrote:
>> From: netdev-owner@vger.kernel.org [mailto:netdev-
>> owner@vger.kernel.org] On Behalf Of Yunsheng Lin
>> Sent: Friday, May 31, 2019 10:01 AM
>> To: davem@davemloft.net
>> Cc: hkallweit1@gmail.com; f.fainelli@gmail.com;
>> stephen@networkplumber.org; netdev@vger.kernel.org; linux-
>> kernel@vger.kernel.org; Linuxarm <linuxarm@huawei.com>
>> Subject: [PATCH v2 net-next] net: link_watch: prevent starvation when
>> processing linkwatch wq
>>
>> When user has configured a large number of virtual netdev, such
>> as 4K vlans, the carrier on/off operation of the real netdev
>> will also cause it's virtual netdev's link state to be processed
>> in linkwatch. Currently, the processing is done in a work queue,
>> which may cause cpu and rtnl locking starvation problem.
>>
>> This patch releases the cpu and rtnl lock when link watch worker
>> has processed a fixed number of netdev' link watch event.
>>
>> Currently __linkwatch_run_queue is called with rtnl lock, so
>> enfore it with ASSERT_RTNL();
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> ---
>> V2: use cond_resched and rtnl_unlock after processing a fixed
>>     number of events
>> ---
>>  net/core/link_watch.c | 17 +++++++++++++++++
>>  1 file changed, 17 insertions(+)
>>
>> diff --git a/net/core/link_watch.c b/net/core/link_watch.c
>> index 7f51efb..07eebfb 100644
>> --- a/net/core/link_watch.c
>> +++ b/net/core/link_watch.c
>> @@ -168,9 +168,18 @@ static void linkwatch_do_dev(struct net_device
>> *dev)
>>
>>  static void __linkwatch_run_queue(int urgent_only)
>>  {
>> +#define MAX_DO_DEV_PER_LOOP	100
>> +
>> +	int do_dev = MAX_DO_DEV_PER_LOOP;
>>  	struct net_device *dev;
>>  	LIST_HEAD(wrk);
>>
>> +	ASSERT_RTNL();
>> +
>> +	/* Give urgent case more budget */
>> +	if (urgent_only)
>> +		do_dev += MAX_DO_DEV_PER_LOOP;
>> +
>>  	/*
>>  	 * Limit the number of linkwatch events to one
>>  	 * per second so that a runaway driver does not
>> @@ -200,6 +209,14 @@ static void __linkwatch_run_queue(int urgent_only)
>>  		}
>>  		spin_unlock_irq(&lweventlist_lock);
>>  		linkwatch_do_dev(dev);
>> +
>> +		if (--do_dev < 0) {
>> +			rtnl_unlock();
>> +			cond_resched();
> 
> 
> 
> Sorry, missed in my earlier comment. I could see multiple problems here
> and please correct me if I am wrong:
> 
> 1. It looks like releasing the rtnl_lock here and then res-scheduling might
>    not be safe, especially when you have already held *lweventlist_lock*
>    (which is global and not per-netdev), and when you are trying to
>    reschedule. This can cause *deadlock* with itself.
> 
>    Reason: once you release the rtnl_lock() the similar leg of function 
>    netdev_wait_allrefs() could be called for some other netdevice which
>    might end up in waiting for same global linkwatch event list lock
>    i.e. *lweventlist_lock*.

lweventlist_lock has been released before releasing the rtnl_lock and
rescheduling.

> 
> 2. After releasing the rtnl_lock() we have not ensured that all the rcu
>    operations are complete. Perhaps we need to take rcu_barrier() before
>    retaking the rtnl_lock()
Why do we need to ensure all the rcu operations are complete here?

> 
> 
> 
> 
>> +			do_dev = MAX_DO_DEV_PER_LOOP;
> 
> 
> 
> Here, I think rcu_barrier() should exist.

In netdev_wait_allrefs, rcu_barrier is indeed called between
__rtnl_unlock and rtnl_lock and is added by below commit
0115e8e30d6f ("net: remove delay at device dismantle"), which
seems to work with NETDEV_UNREGISTER_FINAL.

And the NETDEV_UNREGISTER_FINAL is removed by commit
070f2d7e264a ("net: Drop NETDEV_UNREGISTER_FINAL"), which says
something about whether the rcu_barrier is still needed.

"dev_change_net_namespace() and netdev_wait_allrefs()
have rcu_barrier() before NETDEV_UNREGISTER_FINAL call,
and the source commits say they were introduced to
delemit the call with NETDEV_UNREGISTER, but this patch
leaves them on the places, since they require additional
analysis, whether we need in them for something else."

So the reason of calling rcu_barrier in netdev_wait_allrefs
is unclear now.

Also rcu_barrier in netdev_wait_allrefs is added to fix the
device dismantle problem, so for linkwatch, maybe it is not
needed.

> 
> 
> 
>> +			rtnl_lock();
>> +		}
>> +
>>  		spin_lock_irq(&lweventlist_lock);
>>  	}
> 
> 
> .
> 

