Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F811B8ED0
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 12:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgDZK1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 06:27:42 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3305 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726116AbgDZK1m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Apr 2020 06:27:42 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id D2826C434DE7060B6EB2;
        Sun, 26 Apr 2020 18:27:38 +0800 (CST)
Received: from [127.0.0.1] (10.166.213.7) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Sun, 26 Apr 2020
 18:27:34 +0800
Subject: Re: [PATCH] ray_cs: use true,false for bool variable
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <adobriyan@gmail.com>, <tglx@linutronix.de>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200426094103.23213-1-yanaijie@huawei.com>
 <9c67aee9-ece6-01f0-895a-e690b967d819@cogentembedded.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <0b7407e4-c7ad-f97b-0050-9086f245c6cc@huawei.com>
Date:   Sun, 26 Apr 2020 18:27:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <9c67aee9-ece6-01f0-895a-e690b967d819@cogentembedded.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.166.213.7]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2020/4/26 17:47, Sergei Shtylyov 写道:
> Hello!
> 
> On 26.04.2020 12:41, Jason Yan wrote:
> 
>> Fix the following coccicheck warning:
>>
>> drivers/net/wireless/ray_cs.c:2797:5-14: WARNING: Comparison of 0/1 to
>> bool variable
>> drivers/net/wireless/ray_cs.c:2798:2-11: WARNING: Assignment of 0/1 to
>> bool variable
>>
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>> ---
>>   drivers/net/wireless/ray_cs.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ray_cs.c 
>> b/drivers/net/wireless/ray_cs.c
>> index c1d542bfa530..f9402424accd 100644
>> --- a/drivers/net/wireless/ray_cs.c
>> +++ b/drivers/net/wireless/ray_cs.c
>> @@ -2794,8 +2794,8 @@ static int __init init_ray_cs(void)
>>       proc_create_data("driver/ray_cs/translate", 0200, NULL, 
>> &int_proc_ops,
>>                &translate);
>>   #endif
>> -    if (translate != 0)
>> -        translate = 1;
>> +    if (!translate)
> 
>     That inverts the original logic, no?

Oh, yes.

> 
>> +        translate = true;
> 
>     Actually, that whole comparison/assignment doesn't make sense, if we 
> use bool...
> 

So may be we can do this:

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index c1d542bfa530..9ea695459342 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -2794,8 +2794,7 @@ static int __init init_ray_cs(void)
         proc_create_data("driver/ray_cs/translate", 0200, NULL, 
&int_proc_ops,
                          &translate);
  #endif
-       if (translate != 0)
-               translate = 1;
+       translate == !!translate;
         return 0;
  } /* init_ray_cs */

> [...]
> 
> MBR, Sergei
> 
> .

