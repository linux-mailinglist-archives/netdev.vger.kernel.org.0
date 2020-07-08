Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60BD2191CF
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 22:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgGHUsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 16:48:10 -0400
Received: from out0-157.mail.aliyun.com ([140.205.0.157]:45210 "EHLO
        out0-157.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgGHUsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 16:48:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=alibaba-inc.com; s=default;
        t=1594241287; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        bh=tEywlbnFGf5I2bzW2f2uhIhNVYxAg8r/c59uHGYh/MI=;
        b=aVJ8V71mLTFBtTDrXKUizOS5RooLv3tkCnMOIjxaOXfxrnlyw0i3Ur8LOjZ7V3D9lLxVDzh0ZzrSPnXDZHuAcHhXV+XD4QZ6hSD2VFntgI8V0YrtXvimfq8/XlmoHH/dSXqLPTk3VZgQOvunPMgf285s6sMu+IjaYaykd4jY3sk=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e02c03309;MF=xiangning.yu@alibaba-inc.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---.I-LgyGc_1594241285;
Received: from US-118000MP.local(mailfrom:xiangning.yu@alibaba-inc.com fp:SMTPD_---.I-LgyGc_1594241285)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 09 Jul 2020 04:48:06 +0800
Subject: Re: [PATCH net-next v2 1/2] irq_work: Export symbol
 "irq_work_queue_on"
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <12188783-aa3c-9a83-1e9f-c92e37485445@alibaba-inc.com>
 <20200708.123750.2177855708364007871.davem@davemloft.net>
 <e6ff5906-45a6-79c7-7f91-830eccea8a58@gmail.com>
From:   "=?UTF-8?B?WVUsIFhpYW5nbmluZw==?=" <xiangning.yu@alibaba-inc.com>
Message-ID: <0d8c5628-d5de-5eb7-9822-a63444226554@alibaba-inc.com>
Date:   Thu, 09 Jul 2020 04:48:04 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <e6ff5906-45a6-79c7-7f91-830eccea8a58@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/20 1:27 PM, Eric Dumazet wrote:
> 
> 
> On 7/8/20 12:37 PM, David Miller wrote:
>> From: "YU, Xiangning" <xiangning.yu@alibaba-inc.com>
>> Date: Thu, 09 Jul 2020 00:38:16 +0800
>>
>>> @@ -111,7 +111,7 @@ bool irq_work_queue_on(struct irq_work *work, int cpu)
>>>  	return true;
>>>  #endif /* CONFIG_SMP */
>>>  }
>>> -
>>> +EXPORT_SYMBOL_GPL(irq_work_queue_on);
>>
>> You either removed the need for kthreads or you didn't.
>>
>> If you are queueing IRQ work like this, you're still using kthreads.
>>
>> That's why Eric is asking why you still need this export.
>>
> 
> I received my copy of the 2/2 patch very late, I probably misunderstood
> the v2 changes.
> 
> It seems irq_work_queue_on() is till heavily used, and this makes me nervous.
> 
> Has this thing being tested on 256 cores platform ?
> 

Yes the IRQ is used here for inter-CPU notification after we do rate limiting. We have done extensively testing and deployment with 64 cores(at least) machines. Will see if I can get a 256 cores machine to get more results.

For rate limiting, we have this dilemma that token bucket needs to run centralized to be accurate. While packets are from all CPUS. We need a low latency mechanism to effectively notify other CPUs. It would be great if you guys can shed some light on how we can better solve this problem.

Thanks,
- Xiangning
