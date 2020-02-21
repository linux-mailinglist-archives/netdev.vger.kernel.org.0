Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF004166C79
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 02:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728992AbgBUBpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 20:45:04 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10229 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727809AbgBUBpE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 20:45:04 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id CE0714904AB3FFC41A50;
        Fri, 21 Feb 2020 09:45:00 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Fri, 21 Feb 2020
 09:44:51 +0800
Subject: Re: [RFC rdma-next] RDMA/core: Add attribute WQ_MEM_RECLAIM to
 workqueue "infiniband"
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        "Lang Cheng" <chenglang@huawei.com>,
        Doug Ledford <dledford@redhat.com>,
        "David Miller" <davem@davemloft.net>,
        Salil Mehta <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, LinuxArm <linuxarm@huawei.com>,
        Netdev <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        <bhaktipriya96@gmail.com>, Tejun Heo <tj@kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
References: <1581996935-46507-1-git-send-email-chenglang@huawei.com>
 <20200218153156.GD31668@ziepe.ca>
 <212eda31-cc86-5487-051b-cb51c368b6fe@huawei.com>
 <20200219064507.GC15239@unreal>
 <1155d15f-4188-e5cd-3e4a-6e0c52e9b1eb@huawei.com>
 <CAKgT0Uems7Y0hhFmXYcE0Pf2-ZNih=rm6DDALXdwib7de5wqhA@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <a1d8d68e-ef2b-5d0e-bd9b-c50eddb73f1b@huawei.com>
Date:   Fri, 21 Feb 2020 09:44:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0Uems7Y0hhFmXYcE0Pf2-ZNih=rm6DDALXdwib7de5wqhA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/2/21 1:46, Alexander Duyck wrote:
> On Tue, Feb 18, 2020 at 11:42 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> 
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
> I am not sure why they added WQ_MEM_RECLAIM to the fm10k service task
> thread. It has nothing to do with memory reclaim. If a memory
> allocation fails then it will just run to the end and bring the
> interface down. The service task is related to dealing with various
> one-off events like link up and link down, sorting out hangs, and
> updating statistics. The only memory allocation it is involved with is
> if it has to reset the interface in which case I believe there may
> even be a few GFP_KERNEL calls in there since it is freeing and
> reallocating several port related structures.

Yes, the hns3 driver does a few GFP_KERNEL calls too when resetting the
interface in hclge_reset_service_task(), which will run in the hns3 driver'
wq.

> 
>> 2. If the network device driver's wq does need the WQ_MEM_RECLAIM flag, then
>>    hns3 may have tow problems here: WQ_MEM_RECLAIM wq flushing !WQ_MEM_RECLAIM
>>    wq problem and GFP_KERNEL allocations in the work queued to WQ_MEM_RECLAIM wq.
> 
> It seems like you could solve this by going the other way and dropping
> the WQ_MEM_RECLAIM from the original patch you mentioned in your fixes
> tag. I'm not seeing anything in hclge_periodic_service_task that
> justifies the use of the WQ_MEM_RECLAIM flag. It claims to be involved
> with memory reclaim but I don't see where that could be the case.

Ok, Will remove the WQ_MEM_RECLAIM first.

Thanks.

> 
> - Alex
> 
> .
> 

