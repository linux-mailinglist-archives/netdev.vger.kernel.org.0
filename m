Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCFB2165406
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 02:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbgBTBGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 20:06:30 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10222 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726841AbgBTBGa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 20:06:30 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E83BAB7B19837AF6ED97;
        Thu, 20 Feb 2020 09:06:26 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Thu, 20 Feb 2020
 09:06:18 +0800
Subject: Re: [RFC rdma-next] RDMA/core: Add attribute WQ_MEM_RECLAIM to
 workqueue "infiniband"
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Leon Romanovsky <leon@kernel.org>,
        Lang Cheng <chenglang@huawei.com>, <dledford@redhat.com>,
        <davem@davemloft.net>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        <bhaktipriya96@gmail.com>, <tj@kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
References: <1581996935-46507-1-git-send-email-chenglang@huawei.com>
 <20200218153156.GD31668@ziepe.ca>
 <212eda31-cc86-5487-051b-cb51c368b6fe@huawei.com>
 <20200219064507.GC15239@unreal>
 <1155d15f-4188-e5cd-3e4a-6e0c52e9b1eb@huawei.com>
 <20200219130455.GL31668@ziepe.ca>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <d015c23f-444d-ae69-50ac-b3aa3f8359e0@huawei.com>
Date:   Thu, 20 Feb 2020 09:06:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20200219130455.GL31668@ziepe.ca>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/2/19 21:04, Jason Gunthorpe wrote:
> On Wed, Feb 19, 2020 at 03:40:59PM +0800, Yunsheng Lin wrote:
>> +cc Bhaktipriya, Tejun and Jeff
>> 
>> On 2020/2/19 14:45, Leon Romanovsky wrote:
>>> On Wed, Feb 19, 2020 at 09:13:23AM +0800, Yunsheng Lin wrote:
>>>> On 2020/2/18 23:31, Jason Gunthorpe wrote:
>>>>> On Tue, Feb 18, 2020 at 11:35:35AM +0800, Lang Cheng wrote:
>>>>>> The hns3 driver sets "hclge_service_task" workqueue with WQ_MEM_RECLAIM flag in order to guarantee forward progress under memory pressure.
>>>>> 
>>>>> Don't do that. WQ_MEM_RECLAIM is only to be used by things interlinked with reclaimed processing.
>>>>> 
>>>>> Work on queues marked with WQ_MEM_RECLAIM can't use GFP_KERNEL allocations, can't do certain kinds of sleeps, can't hold certain kinds of locks, etc.
>> 
>> By the way, what kind of sleeps and locks can not be done in the work queued to wq marked with WQ_MEM_RECLAIM?
> 
> Anything that recurses back into a blocking allocation function.
> 
> If we are freeing memory because an allocation failed (eg GFP_KERNEL) then we cannot go back into a blockable allocation while trying to progress the first failing allocation. That is a deadlock.
> 
> So a WQ cannot hold any locks that enclose GFP_KERNEL in any other threads.
> 
> Unfortunately we don't have a lockdep test for this by default.
> 
>>>> hns3 ethernet driver may be used as the low level transport of a network file system, memory reclaim data path may depend on the worker in hns3 driver to bring back the ethernet link so that it flush the some cache to network based disk.
>>> 
>>> Unlikely that this "network file system" dependency on ethernet link is correct.
>> 
>> Ok, I may be wrong about the above usecase.  but the below commit explicitly state that network devices may be used in memory reclaim path.
> 
> I don't really know how this works when the networking stacks intersect with the block stack.
> 
> Forward progress on something like a NVMeOF requires a lot of stuff to be working, and presumably under reclaim.
> 
> But, we can't make everything WQ_MEM_RECLAIM safe, because we could never do a GFP_KERNEL allocation..
> 
> I have never seen specific guidance what to do here, I assume it is broken.

I assume the forward progress guarantee of network device's wq is broken
too, at least for the case of hns3, fm10k and mlx5 driver.

So I suggest to remove WQ_MEM_RECLAIM for hns3' wq for now.

For now there are two known problems which defeat the forward progress
guarantee of WQ_MEM_RECLAIM  when adding the WQ_MEM_RECLAIM for hns3'
wq:
1. GFP_KERNEL allocation in the hns3' work queued to WQ_MEM_RECLAIM wq.
2. hns3' WQ_MEM_RECLAIM wq flushing infiniband' !WQ_MEM_RECLAIM wq.

We can add the WQ_MEM_RECLAIM back when we have fixed the above problem and
find more specific guidance about handling progress guarantee in network
device's wq .

Thanks for the feedback.

> 
> Jason
> 
> .
> 
f

