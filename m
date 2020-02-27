Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0D13171D81
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 15:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389845AbgB0OVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 09:21:02 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11117 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730611AbgB0OVB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 09:21:01 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 11996F31DA52EF086C6A;
        Thu, 27 Feb 2020 22:20:36 +0800 (CST)
Received: from [127.0.0.1] (10.133.210.141) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Thu, 27 Feb 2020
 22:20:31 +0800
Subject: Re: [PATCH 4.4-stable] slip: stop double free sl->dev in slip_open
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20200222094649.10933-1-yangerkun@huawei.com>
 <4e89e339-e161-fd8e-85e0-e59cdcc9688f@huawei.com>
 <20200227124911.GA1007215@kroah.com>
From:   yangerkun <yangerkun@huawei.com>
Message-ID: <0ad6a6ea-d93c-4900-013d-c781a18e987d@huawei.com>
Date:   Thu, 27 Feb 2020 22:20:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200227124911.GA1007215@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.210.141]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/2/27 20:49, Greg KH wrote:
> On Mon, Feb 24, 2020 at 11:06:48AM +0800, yangerkun wrote:
>> cc David and netdev mail list too.
>>
>> On 2020/2/22 17:46, yangerkun wrote:
>>> After commit e4c157955483 ("slip: Fix use-after-free Read in slip_open"),
>>> we will double free sl->dev since sl_free_netdev will free sl->dev too.
>>> It's fine for mainline since sl_free_netdev in mainline won't free
>>> sl->dev.
>>>
>>> Signed-off-by: yangerkun <yangerkun@huawei.com>
>>> ---
>>>    drivers/net/slip/slip.c | 1 -
>>>    1 file changed, 1 deletion(-)
>>>
>>> diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
>>> index ef6b25ec75a1..7fe9183fad0e 100644
>>> --- a/drivers/net/slip/slip.c
>>> +++ b/drivers/net/slip/slip.c
>>> @@ -861,7 +861,6 @@ err_free_chan:
>>>    	tty->disc_data = NULL;
>>>    	clear_bit(SLF_INUSE, &sl->flags);
>>>    	sl_free_netdev(sl->dev);
>>> -	free_netdev(sl->dev);
>>>    err_exit:
>>>    	rtnl_unlock();
>>>
>>
> 
> What commit causes this only to be needed on the 4.4-stable tree?  Can
> you please list it in the commit log so that we know this?
> 
> And this is only for 4.4.y, not 4.9.y or anything else?  Why?
Hi,

Sorry for does not check other stable branch!

The problem exist in 4.4 stable branch because we merged 3b5a39979daf 
("slip: Fix memory leak in slip_open error path") and e58c19124189 
("slip: Fix use-after-free Read in slip_open") without the patch 
cf124db566e6 ("net: Fix inconsistent teardown and release of private 
netdev state."). And since cf124db566e6 has remove the free_netdev exist 
in sl_free_netdev, so fault branch err_free_chan in slip_open will not 
call free_netdev twice in mainline. However, 4.4 stable branch will do it.

Futhermore, since sl_free_netdev will do the all we need, so I think 
delete the free_netdev below sl_free_netdev in slip_open will be fine to 
fix the double free problem, also two problem describes by previous two 
patch.

After check for 3.16.y/4.9.y/4.14.y/4.19.y/5.4.y/5.5.y, and the result 
show as below:

3.16.y:
No double free problem since below two commit has not merged in:
e58c19124189 slip: Fix use-after-free Read in slip_open
3b5a39979daf slip: Fix memory leak in slip_open error path

4.9.y:
problem exist

4.14.y/4.19.y/5.4.y/5.5.y:
no double free problem since cf124db566e6 ("net: Fix inconsistent 
teardown and release of private netdev state.") has been included

So, 4.9.y need this patch too! I will resend the patch for 4.4.y and 
4.9.y with commit message refresh.

Thanks,
Kun.


> 
> thanks,
> 
> greg k-h
> 
> .
> 

