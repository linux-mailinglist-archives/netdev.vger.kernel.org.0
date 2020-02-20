Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 477B7165412
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 02:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727584AbgBTBQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 20:16:44 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:43438 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726962AbgBTBQo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 20:16:44 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 763A6FD898E32C2BA605;
        Thu, 20 Feb 2020 09:16:40 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Thu, 20 Feb 2020
 09:16:33 +0800
Subject: Re: [RFC rdma-next] RDMA/core: Add attribute WQ_MEM_RECLAIM to
 workqueue "infiniband"
To:     Leon Romanovsky <leon@kernel.org>
CC:     Jason Gunthorpe <jgg@ziepe.ca>, Lang Cheng <chenglang@huawei.com>,
        <dledford@redhat.com>, <davem@davemloft.net>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>,
        <bhaktipriya96@gmail.com>, <tj@kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
References: <1581996935-46507-1-git-send-email-chenglang@huawei.com>
 <20200218153156.GD31668@ziepe.ca>
 <212eda31-cc86-5487-051b-cb51c368b6fe@huawei.com>
 <20200219064507.GC15239@unreal>
 <1155d15f-4188-e5cd-3e4a-6e0c52e9b1eb@huawei.com>
 <20200219110700.GK15239@unreal>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <5ecef6a2-788e-948a-15b9-f3ccc29859a9@huawei.com>
Date:   Thu, 20 Feb 2020 09:16:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20200219110700.GK15239@unreal>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/2/19 19:07, Leon Romanovsky wrote:
> On Wed, Feb 19, 2020 at 03:40:59PM +0800, Yunsheng Lin wrote:
>> +cc Bhaktipriya, Tejun and Jeff
>>
>> On 2020/2/19 14:45, Leon Romanovsky wrote:
>>> On Wed, Feb 19, 2020 at 09:13:23AM +0800, Yunsheng Lin wrote:
>>>> On 2020/2/18 23:31, Jason Gunthorpe wrote:
>>>>> On Tue, Feb 18, 2020 at 11:35:35AM +0800, Lang Cheng wrote:
>>>>>> The hns3 driver sets "hclge_service_task" workqueue with
>>>>>> WQ_MEM_RECLAIM flag in order to guarantee forward progress
>>>>>> under memory pressure.
>>>>>
>>>>> Don't do that. WQ_MEM_RECLAIM is only to be used by things interlinked
>>>>> with reclaimed processing.
>>>>>
>>>>> Work on queues marked with WQ_MEM_RECLAIM can't use GFP_KERNEL
>>>>> allocations, can't do certain kinds of sleeps, can't hold certain
>>>>> kinds of locks, etc.
>>
>> By the way, what kind of sleeps and locks can not be done in the work
>> queued to wq marked with WQ_MEM_RECLAIM?
> 
> I didn't see this knowledge documented, but I would assume that
> everything that can block memory reclaim progress should not be
> in such workqueue.
> 
>>
>>>>
>>>> From mlx5 driver, it seems that there is GFP_KERNEL allocations
>>>> on wq marked with WQ_MEM_RECLAIM too:
>>>>
>>>> mlx5e_tx_timeout_work() -> mlx5e_safe_reopen_channels() ->
>>>> mlx5e_safe_switch_channels() -> mlx5e_open_channels()
>>>>
>>>> kcalloc() is called with GFP_KERNEL in mlx5e_open_channels(),
>>>> and mlx5e_tx_timeout_work() is queued with priv->wq, which is
>>>> allocated with WQ_MEM_RECLAIM flags. see:
>>>>
>>>> mlx5e_netdev_init() -> create_singlethread_workqueue()
>>>
>>> There are two reasons for that, first mlx5 driver was written far before
>>> WQ_MEM_RECLAIM usage was clarified, second mlx5 has bugs.
>>>
>>>>
>>>>
>>>> From the comment in kernel/workqueue.c, the work queued with
>>>> wq with WQ_MEM_RECLAIM flag set seems to be executed without
>>>> blocking under some rare case. I still not quite understand
>>>> the comment, and I can not find any doc that point out the
>>>> GFP_KERNEL allocations can not be done in wq with WQ_MEM_RECLAIM
>>>> yet. Is there any doc that mentions that GFP_KERNEL allocations
>>>> can not be done in wq with WQ_MEM_RECLAIM?
>>>
>>> It is whole purpose of WQ_MEM_RECLAIM flag - allow progress in case of
>>> memory pressure. Allocation memory while we are under memory pressure
>>> is an invitation for a disaster.
>>
>> Ok, make sense.
>>
>>>
>>>>
>>>>
>>>> /**
>>>>  * rescuer_thread - the rescuer thread function
>>>>  * @__rescuer: self
>>>>  *
>>>>  * Workqueue rescuer thread function.  There's one rescuer for each
>>>>  * workqueue which has WQ_MEM_RECLAIM set.
>>>>  *
>>>>  * Regular work processing on a pool may block trying to create a new
>>>>  * worker which uses GFP_KERNEL allocation which has slight chance of
>>>>  * developing into deadlock if some works currently on the same queue
>>>>  * need to be processed to satisfy the GFP_KERNEL allocation.  This is
>>>>  * the problem rescuer solves.
>>>>  *
>>>>  * When such condition is possible, the pool summons rescuers of all
>>>>  * workqueues which have works queued on the pool and let them process
>>>>  * those works so that forward progress can be guaranteed.
>>>>  *
>>>>  * This should happen rarely.
>>>>  *
>>>>  * Return: 0
>>>>  */
>>>>
>>>>
>>>> The below is the reason we add the sets "hclge_service_task" workqueue
>>>> with WQ_MEM_RECLAIM through analysing why other ethernet drivers has
>>>> allocated wq with WQ_MEM_RECLAIM flag, I may be wrong about that:
>>>
>>> Many drivers are developed using copy/paste technique, so it is wrong
>>> to assume that "other ethernet drivers" did the right thing.
>>>
>>>>
>>>> hns3 ethernet driver may be used as the low level transport of a
>>>> network file system, memory reclaim data path may depend on the
>>>> worker in hns3 driver to bring back the ethernet link so that it flush
>>>> the some cache to network based disk.
>>>
>>> Unlikely that this "network file system" dependency on ethernet link is correct.
>>
>> Ok, I may be wrong about the above usecase.
>> but the below commit explicitly state that network devices may be used in
>> memory reclaim path.
>>
>> 0a38c17a21a0 ("fm10k: Remove create_workqueue"):
>>
>> fm10k: Remove create_workqueue
>>
>> alloc_workqueue replaces deprecated create_workqueue().
>>
>> A dedicated workqueue has been used since the workitem (viz
>> fm10k_service_task, which manages and runs other subtasks) is involved in
>> normal device operation and requires forward progress under memory
>> pressure.
>>
>> create_workqueue has been replaced with alloc_workqueue with max_active
>> as 0 since there is no need for throttling the number of active work
>> items.
>>
>> Since network devices may be used in memory reclaim path,
>> WQ_MEM_RECLAIM has been set to guarantee forward progress.
>>
>> flush_workqueue is unnecessary since destroy_workqueue() itself calls
>> drain_workqueue() which flushes repeatedly till the workqueue
>> becomes empty. Hence the call to flush_workqueue() has been dropped.
>>
>> Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
>> Acked-by: Tejun Heo <tj@kernel.org>
>> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>>
>> So:
>> 1. Maybe the above commit log is misleading, and network device driver's
>>    wq does not need the WQ_MEM_RECLAIM flag, then maybe document what can
>>    not be done in the work queued to wq marked with WQ_MEM_RECLAIM, and
>>    remove the WQ_MEM_RECLAIM flag for the wq of network device driver.
> 
> I wouldn't truly count on what is written in commit messages of patch
> series which globally replaced create_workqueue() interface.
> 
>>
>>
>> 2. If the network device driver's wq does need the WQ_MEM_RECLAIM flag, then
>>    hns3 may have tow problems here: WQ_MEM_RECLAIM wq flushing !WQ_MEM_RECLAIM
>>    wq problem and GFP_KERNEL allocations in the work queued to WQ_MEM_RECLAIM wq.
> 
> You are proposing to put WQ_MEM_RECLAIM in infiniband queue and not to
> special queue inside of the driver.

In the commit log, we thought of three ways to avoid the warning.
which is:

1. Allocate the "hclge_service_task" workqueue without
WQ_MEM_RECLAIM flag, which may cause deadlock problem
when hns3 driver is used as the low level transport of
a network file system

2. Do not unregister ib_device during reset process, maybe
only disable accessing to the ib_device using disable_device()
as rdma_dev_change_netns() does.

3. Allocate the "infiniband" workqueue with WQ_MEM_RECLAIM flag.


Actually I prefer the second one, which need IB stack to provide
interface to disable and enable ib_device in the roce device driver
when there is hardware reset happening.

Is the above interface reasonable?

> 
>>
>>>
>>> Thanks
>>>
>>>>
>>>>>
>>>>> Jason
>>>>>
>>>>>
>>>>
>>>
>>> .
>>>
>>
> 
> .
> 

