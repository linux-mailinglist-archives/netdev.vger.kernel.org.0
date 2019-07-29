Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0468C78982
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 12:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387441AbfG2KRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 06:17:15 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:39734 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387428AbfG2KRP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 06:17:15 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 72AA6AD22FDC85C90763;
        Mon, 29 Jul 2019 18:17:12 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Mon, 29 Jul 2019
 18:17:02 +0800
Subject: Re: [PATCH net-next 08/11] net: hns3: add interrupt affinity support
 for misc interrupt
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "tanhuazhong@huawei.com" <tanhuazhong@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "lipeng321@huawei.com" <lipeng321@huawei.com>,
        "yisen.zhuang@huawei.com" <yisen.zhuang@huawei.com>,
        "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1563938327-9865-1-git-send-email-tanhuazhong@huawei.com>
 <1563938327-9865-9-git-send-email-tanhuazhong@huawei.com>
 <67b32cdc72c0be03622e78899ac518d807ca7b85.camel@mellanox.com>
 <db2d081f-b892-b141-7fa5-44e66dd97eb9@huawei.com>
 <fa9b747119c2e7acb1ef5f139c022402cd2c854d.camel@mellanox.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <6a1d85f1-cc6c-1f5a-38c4-e08915e3bc45@huawei.com>
Date:   Mon, 29 Jul 2019 18:17:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <fa9b747119c2e7acb1ef5f139c022402cd2c854d.camel@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/7/27 7:18, Saeed Mahameed wrote:
> On Thu, 2019-07-25 at 10:05 +0800, Yunsheng Lin wrote:
>> On 2019/7/25 3:24, Saeed Mahameed wrote:
>>> On Wed, 2019-07-24 at 11:18 +0800, Huazhong Tan wrote:
>>>> From: Yunsheng Lin <linyunsheng@huawei.com>
>>>>
> 
> [...]
>>>>
>>>> +static void hclge_irq_affinity_notify(struct irq_affinity_notify
>>>> *notify,
>>>> +				      const cpumask_t *mask)
>>>> +{
>>>> +	struct hclge_dev *hdev = container_of(notify, struct hclge_dev,
>>>> +					      affinity_notify);
>>>> +
>>>> +	cpumask_copy(&hdev->affinity_mask, mask);
>>>> +	del_timer_sync(&hdev->service_timer);
>>>> +	hdev->service_timer.expires = jiffies + HZ;
>>>> +	add_timer_on(&hdev->service_timer, cpumask_first(&hdev-
>>>>> affinity_mask));
>>>> +}
>>>
>>> I don't see any relation between your misc irq vector and &hdev-
>>>> service_timer, to me this looks like an abuse of the irq affinity
>>>> API
>>> to allow the user to move the service timer affinity.
>>
>> Hi, thanks for reviewing.
>>
>> hdev->service_timer is used to schedule the periodic work
>> queue hdev->service_task， we want all the management work
>> queue including hdev->service_task to bind to the same cpu
>> to improve cache and power efficiency, it is better to move
>> service timer affinity according to that.
>>
>> The hdev->service_task is changed to delay work queue in
>> next patch " net: hns3: make hclge_service use delayed workqueue",
>> So the affinity in the timer of the delay work queue is automatically
>> set to the affinity of the delay work queue, we will move the
>> "make hclge_service use delayed workqueue" patch before the
>> "add interrupt affinity support for misc interrupt" patch, so
>> we do not have to set service timer affinity explicitly.
>>
>> Also, There is there work queues(mbx_service_task, service_task,
>> rst_service_task) in the hns3 driver, we plan to combine them
>> to one or two workqueue to improve efficiency and readability.
>>
> 
> So just to make it clear, you have 3 deferred works, 2 are triggered by
> the misc irq and 1 is periodic, you want them all on the same core and
> you want to control their affinity via the irq affinity ? for works #1
> and  #2 you get that for free since the irq is triggering them, but for
> work #3 (the periodic one) you need to manually move it when the irq
> affinity changes.

Yes, You are right.

> 
> I guess i am ok with this, since moving the irq affinity isn't only
> required by the periodic work but also for the other works that the irq
> is actually triggering (so it is not an actual abuse, sort of .. )
> 
> 
> 

