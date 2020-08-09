Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD98923FC44
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 05:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgHIC77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 22:59:59 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3108 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725988AbgHIC77 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Aug 2020 22:59:59 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 67C582EDB366618F78EA;
        Sun,  9 Aug 2020 10:59:55 +0800 (CST)
Received: from [10.174.61.242] (10.174.61.242) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Sun, 9 Aug 2020 10:59:54 +0800
Subject: Re: [PATCH net-next v1] hinic: fix strncpy output truncated compile
 warnings
To:     David Miller <davem@davemloft.net>
CC:     <David.Laight@ACULAB.COM>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <chiqijun@huawei.com>
References: <20200807020914.3123-1-luobin9@huawei.com>
 <e7a4fcf12a4e4d179e2fae8ffb44f992@AcuMS.aculab.com>
 <b886a6ff-8ed8-c857-f190-e99f8f735e02@huawei.com>
 <20200807.204243.696618708291045170.davem@davemloft.net>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <2e4eeea0-0531-f12c-423b-c7b858560eb5@huawei.com>
Date:   Sun, 9 Aug 2020 10:59:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200807.204243.696618708291045170.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.61.242]
X-ClientProxiedBy: dggeme716-chm.china.huawei.com (10.1.199.112) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/8/8 11:42, David Miller wrote:
> From: "luobin (L)" <luobin9@huawei.com>
> Date: Sat, 8 Aug 2020 11:36:42 +0800
> 
>> On 2020/8/7 17:32, David Laight wrote:
>>>> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
>>>> b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
>>>> index c6adc776f3c8..1ec88ebf81d6 100644
>>>> --- a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
>>>> +++ b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
>>>> @@ -342,9 +342,9 @@ static int chip_fault_show(struct devlink_fmsg *fmsg,
>>>>
>>>>  	level = event->event.chip.err_level;
>>>>  	if (level < FAULT_LEVEL_MAX)
>>>> -		strncpy(level_str, fault_level[level], strlen(fault_level[level]));
>>>> +		strncpy(level_str, fault_level[level], strlen(fault_level[level]) + 1);
>>>
>>> Have you even considered what that code is actually doing?
>  ...
>> I'm sorry that I haven't got what you mean and I haven't found any defects in that code. Can you explain more to me?
> 
> David is trying to express the same thing I was trying to explain to
> you, you should use sizeof(level_str) as the third argument because
> the code is trying to make sure that the destination buffer is not
> overrun.
> 
> If you use the strlen() of the source buffer, the strncpy() can still
> overflow the destination buffer.
> 
> Now do you understand?
> .
> 
Thanks for your explanation. I explained that why I didn't use sizeof(level_str) as the third argument in my previous reply e-mail to you.
Because using sizeof(level_str) as the third argument will still cause the following compile warning:

In function ‘strncpy’,
    inlined from ‘chip_fault_show’ at drivers/net/ethernet/huawei/hinic/hinic_devlink.c:345:3:
./include/linux/string.h:297:30: warning: ‘__builtin_strncpy’ specified bound 17 equals destination size [-Wstringop-truncation]
  297 | #define __underlying_strncpy __builtin_strncpy

Now I know that using strncpy() on NUL-terminated strings is deprecated as Kees Cook points out and actually there is no need to use it
in my code.
