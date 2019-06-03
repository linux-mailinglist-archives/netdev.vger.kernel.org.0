Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEFC1325F5
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 03:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfFCBUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 21:20:14 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17645 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726305AbfFCBUO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Jun 2019 21:20:14 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 507545137AFE3F29BA21;
        Mon,  3 Jun 2019 09:20:11 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Mon, 3 Jun 2019
 09:20:00 +0800
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
 <0500aaf60c464528b6bae010c7f9994d@huawei.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <802fef29-d525-2559-f2fc-d88ac3193f06@huawei.com>
Date:   Mon, 3 Jun 2019 09:20:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <0500aaf60c464528b6bae010c7f9994d@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/5/31 17:54, Salil Mehta wrote:
>> From: netdev-owner@vger.kernel.org On Behalf Of Yunsheng Lin
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
> 
> 
> Typo enfore --> enforce ?

My mistake.

thanks.

> 
> 
> 
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
> 
> 
> A comment like below would be helpful in explaining the reason of the code.
>  
> /* This function is called with rtnl_lock held. If excessive events
>  * are present as part of the watch list, their processing could
>  * monopolize the rtnl_lock and which could lead to starvation in
>  * other modules which want to acquire this lock. Hence, co-operative
>  * scheme like below might be helpful in mitigating the problem.
>  * This also tries to be fair CPU wise by conditional rescheduling.
>  */

Yes, thanks for the helpful comment.

> 
> 
>> +		if (--do_dev < 0) {
>> +			rtnl_unlock();
>> +			cond_resched();
>> +			do_dev = MAX_DO_DEV_PER_LOOP;
>> +			rtnl_lock();
>> +		}
>> +
>>  		spin_lock_irq(&lweventlist_lock);
>>  	}
> 
> .
> 

