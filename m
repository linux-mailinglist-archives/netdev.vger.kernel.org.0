Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 196D816472F
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 15:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgBSOjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 09:39:54 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:40558 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726528AbgBSOjy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 09:39:54 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D1806581773499D5969E;
        Wed, 19 Feb 2020 22:39:50 +0800 (CST)
Received: from [127.0.0.1] (10.133.210.141) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Wed, 19 Feb 2020
 22:39:41 +0800
Subject: Re: [RFC] slip: not call free_netdev before rtnl_unlock in slip_open
From:   yangerkun <yangerkun@huawei.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        maowenan <maowenan@huawei.com>, <yangerkun@huawei.com>
References: <20200213093248.129757-1-yangerkun@huawei.com>
 <2e9edf1e-5f4f-95d6-4381-6675cded02ac@huawei.com>
Message-ID: <c6bbb6ef-2ae5-6450-fb01-1fc9265f0483@huawei.com>
Date:   Wed, 19 Feb 2020 22:39:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <2e9edf1e-5f4f-95d6-4381-6675cded02ac@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.133.210.141]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ping again..

On 2020/2/16 13:32, yangerkun wrote:
> Ping.
> 
> On 2020/2/13 17:32, yangerkun wrote:
>> As the description before netdev_run_todo, we cannot call free_netdev
>> before rtnl_unlock, fix it by reorder the code.
>>
>> Signed-off-by: yangerkun <yangerkun@huawei.com>
>> ---
>>   drivers/net/slip/slip.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
>> index 6f4d7ba8b109..babb01888b78 100644
>> --- a/drivers/net/slip/slip.c
>> +++ b/drivers/net/slip/slip.c
>> @@ -863,7 +863,10 @@ static int slip_open(struct tty_struct *tty)
>>       tty->disc_data = NULL;
>>       clear_bit(SLF_INUSE, &sl->flags);
>>       sl_free_netdev(sl->dev);
>> +    /* do not call free_netdev before rtnl_unlock */
>> +    rtnl_unlock();
>>       free_netdev(sl->dev);
>> +    return err;
>>   err_exit:
>>       rtnl_unlock();
>>

