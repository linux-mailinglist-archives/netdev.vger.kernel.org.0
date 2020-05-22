Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C671DDDD9
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 05:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbgEVD0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 23:26:49 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5273 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727024AbgEVD0s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 23:26:48 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 5264D3B8B9B8A21A4CC9;
        Fri, 22 May 2020 11:26:47 +0800 (CST)
Received: from [10.166.213.22] (10.166.213.22) by smtp.huawei.com
 (10.3.19.202) with Microsoft SMTP Server (TLS) id 14.3.487.0; Fri, 22 May
 2020 11:26:41 +0800
Subject: Re: [PATCH v2] netprio_cgroup: Fix unlimited memory leak of v2
 cgroups
To:     John Fastabend <john.fastabend@gmail.com>,
        Tejun Heo <tj@kernel.org>, <ast@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        yangyingliang <yangyingliang@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        <huawei.libin@huawei.com>, <guofan5@huawei.com>,
        <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <939566f5-abe3-3526-d4ff-ec6bf8e8c138@huawei.com>
 <2fcd921d-8f42-9d33-951c-899d0bbdd92d@huawei.com>
 <20200508225829.0880cf8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200509210214.408e847a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <5ec6ef43d98e7_3bbf2ab912c625b4eb@john-XPS-13-9370.notmuch>
From:   Zefan Li <lizefan@huawei.com>
Message-ID: <37ad9c6e-b8e9-d23a-f168-fca2292ef5c5@huawei.com>
Date:   Fri, 22 May 2020 11:26:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <5ec6ef43d98e7_3bbf2ab912c625b4eb@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.166.213.22]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/5/22 5:14, John Fastabend wrote:
> Jakub Kicinski wrote:
>> On Fri, 8 May 2020 22:58:29 -0700 Jakub Kicinski wrote:
>>> On Sat, 9 May 2020 11:32:10 +0800 Zefan Li wrote:
>>>> If systemd is configured to use hybrid mode which enables the use of
>>>> both cgroup v1 and v2, systemd will create new cgroup on both the default
>>>> root (v2) and netprio_cgroup hierarchy (v1) for a new session and attach
>>>> task to the two cgroups. If the task does some network thing then the v2
>>>> cgroup can never be freed after the session exited.
>>>>
>>>> One of our machines ran into OOM due to this memory leak.
>>>>
>>>> In the scenario described above when sk_alloc() is called cgroup_sk_alloc()
>>>> thought it's in v2 mode, so it stores the cgroup pointer in sk->sk_cgrp_data
>>>> and increments the cgroup refcnt, but then sock_update_netprioidx() thought
>>>> it's in v1 mode, so it stores netprioidx value in sk->sk_cgrp_data, so the
>>>> cgroup refcnt will never be freed.
>>>>
>>>> Currently we do the mode switch when someone writes to the ifpriomap cgroup
>>>> control file. The easiest fix is to also do the switch when a task is attached
>>>> to a new cgroup.
>>>>
>>>> Fixes: bd1060a1d671("sock, cgroup: add sock->sk_cgroup")  
>>>
>>>                      ^ space missing here
>>>
>>>> Reported-by: Yang Yingliang <yangyingliang@huawei.com>
>>>> Tested-by: Yang Yingliang <yangyingliang@huawei.com>
>>>> Signed-off-by: Zefan Li <lizefan@huawei.com>
>>
>> Fixed up the commit message and applied, thank you.
> 
> Hi Zefan, Tejun,
> 
> This is causing a regression where previously cgroupv2 bpf sockops programs
> could be attached and would run even if netprio_cgroup was enabled as long
> as  the netprio cgroup had not been configured. After this the bpf sockops
> programs can still be attached but only programs attached to the root cgroup
> will be run. For example I hit this when I ran bpf selftests on a box that
> also happened to have netprio cgroup enabled, tests started failing after
> bumping kernel to rc5.
> 
> I'm a bit on the fence here if it needs to be reverted. For my case its just
> a test box and easy enough to work around. Also all the production cases I
> have already have to be aware of this to avoid the configured error. So it
> may be fine but worth noting at least. Added Alexei to see if he has any
> opinion and/or uses net_prio+cgroubv2. I only looked it over briefly but
> didn't see any simple rc6 worthy fixes that would fix the issue above and
> also keep the original behavior.
> 

Me neither. If we really want to keep the original behavior we probably need
to do something similar to what netclassid cgroup does, which is to iterate
all the tasks in the cgroup to update netprioidx when netprio cgroup is
configured, and we also need to not update netprioidx when a task is attached
to a new cgroup.

> And then while reviewing I also wonder do we have the same issue described
> here in netclasid_cgroup.c with the cgrp_attach()? It would be best to keep
> netcls and netprio in sync in this regard imo. At least netcls calls
> cgroup_sk_alloc_disable in the write_classid() hook so I suspect it makes
> sense to also add that to the attach hook?
> 

Fortunately we don't have this issue in netclassid cgroup. :)

Because task_cls_classid() remains 0 as long as netclassid cgroup is not
configured.
