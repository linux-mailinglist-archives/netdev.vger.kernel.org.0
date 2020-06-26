Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A93B20ABE2
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 07:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgFZFiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 01:38:06 -0400
Received: from neo-zeon.de ([96.90.244.226]:20290 "EHLO neo-zeon.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726968AbgFZFiE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 01:38:04 -0400
X-Greylist: delayed 849 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jun 2020 01:38:03 EDT
Received: from [192.168.0.55] (ukyo.nerv.lan [192.168.0.55])
        (authenticated bits=0)
        by neo-zeon.de (8.15.2/8.15.2) with ESMTPSA id 05Q5NrvO004725
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Thu, 25 Jun 2020 22:23:53 -0700 (PDT)
        (envelope-from cam@neo-zeon.de)
Subject: Re: [Patch net] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
To:     Roman Gushchin <guro@fb.com>, Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Zefan Li <lizefan@huawei.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
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
 <459be87d-0272-9ea9-839a-823b01e354b6@huawei.com>
 <35480172-c77e-fb67-7559-04576f375ea6@huawei.com>
 <CAM_iQpXpZd6ZaQyQifWOHSnqgAgdu1qP+fF_Na7rQ_H1vQ6eig@mail.gmail.com>
 <20200623222137.GA358561@carbon.lan>
From:   Cameron Berkenpas <cam@neo-zeon.de>
Message-ID: <b3a5298d-3c4e-ba51-7045-9643c3986054@neo-zeon.de>
Date:   Thu, 25 Jun 2020 22:23:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200623222137.GA358561@carbon.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Somewhere along the way I got the impression that it generally takes 
those affected hours before their systems lock up. I'm (generally) able 
to reproduce this issue much faster than that. Regardless, I can help test.

Are there any patches that need testing or is this all still pending 
discussion around the  best way to resolve the issue?

Thanks!

On 6/23/20 3:21 PM, Roman Gushchin wrote:
> On Fri, Jun 19, 2020 at 08:31:14PM -0700, Cong Wang wrote:
>> On Fri, Jun 19, 2020 at 5:51 PM Zefan Li <lizefan@huawei.com> wrote:
>>> 在 2020/6/20 8:45, Zefan Li 写道:
>>>> On 2020/6/20 3:51, Cong Wang wrote:
>>>>> On Thu, Jun 18, 2020 at 11:40 PM Zefan Li <lizefan@huawei.com> wrote:
>>>>>> On 2020/6/19 5:09, Cong Wang wrote:
>>>>>>> On Thu, Jun 18, 2020 at 12:36 PM Roman Gushchin <guro@fb.com> wrote:
>>>>>>>> On Thu, Jun 18, 2020 at 12:19:13PM -0700, Cong Wang wrote:
>>>>>>>>> On Wed, Jun 17, 2020 at 6:44 PM Zefan Li <lizefan@huawei.com> wrote:
>>>>>>>>>> Cc: Roman Gushchin <guro@fb.com>
>>>>>>>>>>
>>>>>>>>>> Thanks for fixing this.
>>>>>>>>>>
>>>>>>>>>> On 2020/6/17 2:03, Cong Wang wrote:
>>>>>>>>>>> When we clone a socket in sk_clone_lock(), its sk_cgrp_data is
>>>>>>>>>>> copied, so the cgroup refcnt must be taken too. And, unlike the
>>>>>>>>>>> sk_alloc() path, sock_update_netprioidx() is not called here.
>>>>>>>>>>> Therefore, it is safe and necessary to grab the cgroup refcnt
>>>>>>>>>>> even when cgroup_sk_alloc is disabled.
>>>>>>>>>>>
>>>>>>>>>>> sk_clone_lock() is in BH context anyway, the in_interrupt()
>>>>>>>>>>> would terminate this function if called there. And for sk_alloc()
>>>>>>>>>>> skcd->val is always zero. So it's safe to factor out the code
>>>>>>>>>>> to make it more readable.
>>>>>>>>>>>
>>>>>>>>>>> Fixes: 090e28b229af92dc5b ("netprio_cgroup: Fix unlimited memory leak of v2 cgroups")
>>>>>>>>>> but I don't think the bug was introduced by this commit, because there
>>>>>>>>>> are already calls to cgroup_sk_alloc_disable() in write_priomap() and
>>>>>>>>>> write_classid(), which can be triggered by writing to ifpriomap or
>>>>>>>>>> classid in cgroupfs. This commit just made it much easier to happen
>>>>>>>>>> with systemd invovled.
>>>>>>>>>>
>>>>>>>>>> I think it's 4bfc0bb2c60e2f4c ("bpf: decouple the lifetime of cgroup_bpf from cgroup itself"),
>>>>>>>>>> which added cgroup_bpf_get() in cgroup_sk_alloc().
>>>>>>>>> Good point.
>>>>>>>>>
>>>>>>>>> I take a deeper look, it looks like commit d979a39d7242e06
>>>>>>>>> is the one to blame, because it is the first commit that began to
>>>>>>>>> hold cgroup refcnt in cgroup_sk_alloc().
>>>>>>>> I agree, ut seems that the issue is not related to bpf and probably
>>>>>>>> can be reproduced without CONFIG_CGROUP_BPF. d979a39d7242e06 indeed
>>>>>>>> seems closer to the origin.
>>>>>>> Yeah, I will update the Fixes tag and send V2.
>>>>>>>
>>>>>> Commit d979a39d7242e06 looks innocent to me. With this commit when cgroup_sk_alloc
>>>>>> is disabled and then a socket is cloned the cgroup refcnt will not be incremented,
>>>>>> but this is fine, because when the socket is to be freed:
>>>>>>
>>>>>>   sk_prot_free()
>>>>>>     cgroup_sk_free()
>>>>>>       cgroup_put(sock_cgroup_ptr(skcd)) == cgroup_put(&cgrp_dfl_root.cgrp)
>>>>>>
>>>>>> cgroup_put() does nothing for the default root cgroup, so nothing bad will happen.
>>>>> But skcd->val can be a pointer to a non-root cgroup:
>>>> It returns a non-root cgroup when cgroup_sk_alloc is not disabled. The bug happens
>>>> when cgroup_sk_alloc is disabled.
>>>>
>>> And please read those recent bug reports, they all happened when bpf cgroup was in use,
>>> and there was no bpf cgroup when d979a39d7242e06 was merged into mainline.
>> I am totally aware of this. My concern is whether cgroup
>> has the same refcnt bug as it always pairs with the bpf refcnt.
>>
>> But, after a second look, the non-root cgroup refcnt is immediately
>> overwritten by sock_update_classid() or sock_update_netprioidx(),
>> which effectively turns into a root cgroup again. :-/
>>
>> (It seems we leak a refcnt here, but this is not related to my patch).
> Yeah, I looked over this code, and I have the same suspicion.
> Especially in sk_alloc(), where cgroup_sk_alloc() is followed by
> sock_update_classid() and sock_update_netprioidx().
>
> I also think your original patch is good, but there are probably
> some other problems which it doesn't fix.
>
> I looked over cgroup bpf code again, and the only difference with cgroup
> refcounting I see (behind the root cgroup, which is a non-issue) is
> here:
>
> void cgroup_sk_alloc(struct sock_cgroup_data *skcd)
> {
> 	...
> 	while (true) {
> 		struct css_set *cset;
>
> 		cset = task_css_set(current);
> 		if (likely(cgroup_tryget(cset->dfl_cgrp))) {
> 			  ^^^^^^^^^^^^^^^
> 			skcd->val = (unsigned long)cset->dfl_cgrp;
> 			cgroup_bpf_get(cset->dfl_cgrp);
> 			^^^^^^^^^^^^^^
> 			break;
> 			...
>
> So, in theory, cgroup_bpf_get() can be called here after cgroup_bpf_release().
> We might wanna introduce something like cgroup_bpf_tryget_live().
> Idk if it can happen in reality, because it would require opening a new socket
> in a deleted cgroup (without any other associated sockets).
>
> Other than that I don't see any differences between cgroup and cgroup bpf
> reference counting.
>
> Thanks!
>
> PS I'll be completely offline till the end of the week. I'll answer all
> e-mails on Monday (Jun 29th).

