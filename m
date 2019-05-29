Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A11B22D7F4
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 10:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbfE2Ilg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 04:41:36 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17619 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725935AbfE2Ilg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 04:41:36 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 4C206269DD259F2AAC39;
        Wed, 29 May 2019 16:41:33 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Wed, 29 May 2019
 16:41:26 +0800
Subject: Re: [PATCH net-next] net: link_watch: prevent starvation when
 processing linkwatch wq
To:     Salil Mehta <salil.mehta@huawei.com>,
        Stephen Hemminger <stephen@networkplumber.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>
References: <1558921674-158349-1-git-send-email-linyunsheng@huawei.com>
 <20190527075838.5a65abf9@hermes.lan>
 <a0fe690b-2bfa-7d1a-40c5-5fb95cf57d0b@huawei.com>
 <cddd414bbf454cbaa8321a92f0d1b9b2@huawei.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <aa8d92eb-5683-9b7d-1c3f-69eec30f3a61@huawei.com>
Date:   Wed, 29 May 2019 16:41:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <cddd414bbf454cbaa8321a92f0d1b9b2@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/5/29 16:12, Salil Mehta wrote:
>> From: netdev-owner@vger.kernel.org [mailto:netdev-owner@vger.kernel.org] On Behalf Of Yunsheng Lin
>> Sent: Tuesday, May 28, 2019 2:04 AM
>>
>> On 2019/5/27 22:58, Stephen Hemminger wrote:
>>> On Mon, 27 May 2019 09:47:54 +0800
>>> Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>>
>>>> When user has configured a large number of virtual netdev, such
>>>> as 4K vlans, the carrier on/off operation of the real netdev
>>>> will also cause it's virtual netdev's link state to be processed
>>>> in linkwatch. Currently, the processing is done in a work queue,
>>>> which may cause worker starvation problem for other work queue.
> 
> 
> I think we had already discussed about this internally and using separate
> workqueue with WQ_UNBOUND should solve this problem. HNS3 driver was sharing
> workqueue with the system workqueue. 

Yes, using WQ_UNBOUND wq in hns3 solved the cpu starvation for hns3
workqueue.

But the rtnl_lock taken by linkwatch is still a problem for hns3's
reset workqueue to do the down operation, which need a rtnl_lock.

> 
> 
>>>> This patch releases the cpu when link watch worker has processed
>>>> a fixed number of netdev' link watch event, and schedule the
>>>> work queue again when there is still link watch event remaining.
> 
> 
> We need proper examples/use-cases because of which we require above
> kind of co-operative scheduling. Touching the common shared queue logic
> which solid argument might invite for more problem to other modules.
> 
> 
>>>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>>>
>>> Why not put link watch in its own workqueue so it is scheduled
>>> separately from the system workqueue?
>>
>> From testing and debuging, the workqueue runs on the cpu where the
>> workqueue is schedule when using normal workqueue, even using its
>> own workqueue instead of system workqueue. So if the cpu is busy
>> processing the linkwatch event, it is not able to process other
>> workqueue' work when the workqueue is scheduled on the same cpu.
>>
>> Using unbound workqueue may solve the cpu starvation problem.
> 
> [...]
> 
>> But the __linkwatch_run_queue is called with rtnl_lock, so if it
>> takes a lot time to process, other need to take the rtnl_lock may
>> not be able to move forward.
> 
> Please help me in understanding, Are you trying to pitch this patch
> to solve more general system issue OR still your argument/concern
> is related to the HNS3 driver problem mentioned in this patch?

As about.

> 
> Salil.
> 
> 
> 
> 
> 
> 
> 

