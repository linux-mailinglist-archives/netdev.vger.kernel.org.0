Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9047716BCD6
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 09:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729282AbgBYI5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 03:57:31 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10686 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726916AbgBYI5b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 03:57:31 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 04C089DD6460F3EEB239;
        Tue, 25 Feb 2020 16:57:25 +0800 (CST)
Received: from [127.0.0.1] (10.133.210.141) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Tue, 25 Feb 2020
 16:57:16 +0800
Subject: Re: [RFC] slip: not call free_netdev before rtnl_unlock in slip_open
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        maowenan <maowenan@huawei.com>, <yangerkun@huawei.com>
References: <20200213093248.129757-1-yangerkun@huawei.com>
 <2e9edf1e-5f4f-95d6-4381-6675cded02ac@huawei.com>
 <c6bbb6ef-2ae5-6450-fb01-1fc9265f0483@huawei.com>
From:   yangerkun <yangerkun@huawei.com>
Message-ID: <5f3e0e02-c900-1956-9628-e25babad2dd9@huawei.com>
Date:   Tue, 25 Feb 2020 16:57:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <c6bbb6ef-2ae5-6450-fb01-1fc9265f0483@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.133.210.141]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ping. And anyone can give some advise about this patch?

Thanks,
Kun.

On 2020/2/19 22:39, yangerkun wrote:
> Ping again..
> 
> On 2020/2/16 13:32, yangerkun wrote:
>> Ping.
>>
>> On 2020/2/13 17:32, yangerkun wrote:
>>> As the description before netdev_run_todo, we cannot call free_netdev
>>> before rtnl_unlock, fix it by reorder the code.
>>>
>>> Signed-off-by: yangerkun <yangerkun@huawei.com>
>>> ---
>>>   drivers/net/slip/slip.c | 3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
>>> index 6f4d7ba8b109..babb01888b78 100644
>>> --- a/drivers/net/slip/slip.c
>>> +++ b/drivers/net/slip/slip.c
>>> @@ -863,7 +863,10 @@ static int slip_open(struct tty_struct *tty)
>>>       tty->disc_data = NULL;
>>>       clear_bit(SLF_INUSE, &sl->flags);
>>>       sl_free_netdev(sl->dev);
>>> +    /* do not call free_netdev before rtnl_unlock */
>>> +    rtnl_unlock();
>>>       free_netdev(sl->dev);
>>> +    return err;
>>>   err_exit:
>>>       rtnl_unlock();
>>>

