Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4F5201F50
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 02:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731066AbgFTApZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 20:45:25 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:44232 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731055AbgFTApN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 20:45:13 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 2475A98F2E7F8B086F37;
        Sat, 20 Jun 2020 08:45:09 +0800 (CST)
Received: from [10.166.213.22] (10.166.213.22) by smtp.huawei.com
 (10.3.19.212) with Microsoft SMTP Server (TLS) id 14.3.487.0; Sat, 20 Jun
 2020 08:45:06 +0800
Subject: Re: [Patch net] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Roman Gushchin <guro@fb.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cameron Berkenpas <cam@neo-zeon.de>,
        Peter Geis <pgwipeout@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        =?UTF-8?Q?Dani=c3=abl_Sonck?= <dsonck92@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tejun Heo <tj@kernel.org>
References: <20200616180352.18602-1-xiyou.wangcong@gmail.com>
 <141629e1-55b5-34b1-b2ab-bab6b68f0671@huawei.com>
 <CAM_iQpUFFHPnMxS2sAHZqMUs80tTn0+C_jCcne4Ddx2b9omCxg@mail.gmail.com>
 <20200618193611.GE24694@carbon.DHCP.thefacebook.com>
 <CAM_iQpWuNnHqNHKz5FMgAXoqQ5qGDEtNbBKDXpmpeNSadCZ-1w@mail.gmail.com>
 <4f17229e-1843-5bfc-ea2f-67ebaa9056da@huawei.com>
 <CAM_iQpVKqFi00ohqPARxaDw2UN1m6CtjqsmBAP-pcK0GT2p_fQ@mail.gmail.com>
From:   Zefan Li <lizefan@huawei.com>
Message-ID: <459be87d-0272-9ea9-839a-823b01e354b6@huawei.com>
Date:   Sat, 20 Jun 2020 08:45:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpVKqFi00ohqPARxaDw2UN1m6CtjqsmBAP-pcK0GT2p_fQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.166.213.22]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/6/20 3:51, Cong Wang wrote:
> On Thu, Jun 18, 2020 at 11:40 PM Zefan Li <lizefan@huawei.com> wrote:
>>
>> On 2020/6/19 5:09, Cong Wang wrote:
>>> On Thu, Jun 18, 2020 at 12:36 PM Roman Gushchin <guro@fb.com> wrote:
>>>>
>>>> On Thu, Jun 18, 2020 at 12:19:13PM -0700, Cong Wang wrote:
>>>>> On Wed, Jun 17, 2020 at 6:44 PM Zefan Li <lizefan@huawei.com> wrote:
>>>>>>
>>>>>> Cc: Roman Gushchin <guro@fb.com>
>>>>>>
>>>>>> Thanks for fixing this.
>>>>>>
>>>>>> On 2020/6/17 2:03, Cong Wang wrote:
>>>>>>> When we clone a socket in sk_clone_lock(), its sk_cgrp_data is
>>>>>>> copied, so the cgroup refcnt must be taken too. And, unlike the
>>>>>>> sk_alloc() path, sock_update_netprioidx() is not called here.
>>>>>>> Therefore, it is safe and necessary to grab the cgroup refcnt
>>>>>>> even when cgroup_sk_alloc is disabled.
>>>>>>>
>>>>>>> sk_clone_lock() is in BH context anyway, the in_interrupt()
>>>>>>> would terminate this function if called there. And for sk_alloc()
>>>>>>> skcd->val is always zero. So it's safe to factor out the code
>>>>>>> to make it more readable.
>>>>>>>
>>>>>>> Fixes: 090e28b229af92dc5b ("netprio_cgroup: Fix unlimited memory leak of v2 cgroups")
>>>>>>
>>>>>> but I don't think the bug was introduced by this commit, because there
>>>>>> are already calls to cgroup_sk_alloc_disable() in write_priomap() and
>>>>>> write_classid(), which can be triggered by writing to ifpriomap or
>>>>>> classid in cgroupfs. This commit just made it much easier to happen
>>>>>> with systemd invovled.
>>>>>>
>>>>>> I think it's 4bfc0bb2c60e2f4c ("bpf: decouple the lifetime of cgroup_bpf from cgroup itself"),
>>>>>> which added cgroup_bpf_get() in cgroup_sk_alloc().
>>>>>
>>>>> Good point.
>>>>>
>>>>> I take a deeper look, it looks like commit d979a39d7242e06
>>>>> is the one to blame, because it is the first commit that began to
>>>>> hold cgroup refcnt in cgroup_sk_alloc().
>>>>
>>>> I agree, ut seems that the issue is not related to bpf and probably
>>>> can be reproduced without CONFIG_CGROUP_BPF. d979a39d7242e06 indeed
>>>> seems closer to the origin.
>>>
>>> Yeah, I will update the Fixes tag and send V2.
>>>
>>
>> Commit d979a39d7242e06 looks innocent to me. With this commit when cgroup_sk_alloc
>> is disabled and then a socket is cloned the cgroup refcnt will not be incremented,
>> but this is fine, because when the socket is to be freed:
>>
>>  sk_prot_free()
>>    cgroup_sk_free()
>>      cgroup_put(sock_cgroup_ptr(skcd)) == cgroup_put(&cgrp_dfl_root.cgrp)
>>
>> cgroup_put() does nothing for the default root cgroup, so nothing bad will happen.
> 
> But skcd->val can be a pointer to a non-root cgroup:

It returns a non-root cgroup when cgroup_sk_alloc is not disabled. The bug happens
when cgroup_sk_alloc is disabled.

> 
> static inline struct cgroup *sock_cgroup_ptr(struct sock_cgroup_data *skcd)
> {
> #if defined(CONFIG_CGROUP_NET_PRIO) || defined(CONFIG_CGROUP_NET_CLASSID)
>         unsigned long v;
> 
>         /*
>          * @skcd->val is 64bit but the following is safe on 32bit too as we
>          * just need the lower ulong to be written and read atomically.
>          */
>         v = READ_ONCE(skcd->val);
> 
>         if (v & 1)
>                 return &cgrp_dfl_root.cgrp;
> 
>         return (struct cgroup *)(unsigned long)v ?: &cgrp_dfl_root.cgrp;
> #else
>         return (struct cgroup *)(unsigned long)skcd->val;
> #endif
> }
> .
> 

