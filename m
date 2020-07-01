Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83B70210167
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 03:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbgGABSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 21:18:23 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:60078 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725937AbgGABSW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 21:18:22 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6CF32D9EA7B2E3042D43;
        Wed,  1 Jul 2020 09:18:18 +0800 (CST)
Received: from [10.174.178.86] (10.174.178.86) by smtp.huawei.com
 (10.3.19.203) with Microsoft SMTP Server (TLS) id 14.3.487.0; Wed, 1 Jul 2020
 09:18:15 +0800
Subject: Re: [Patch net] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
To:     Roman Gushchin <guro@fb.com>, Cong Wang <xiyou.wangcong@gmail.com>
CC:     Cameron Berkenpas <cam@neo-zeon.de>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        =?UTF-8?Q?Dani=c3=abl_Sonck?= <dsonck92@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tejun Heo <tj@kernel.org>
References: <4f17229e-1843-5bfc-ea2f-67ebaa9056da@huawei.com>
 <CAM_iQpVKqFi00ohqPARxaDw2UN1m6CtjqsmBAP-pcK0GT2p_fQ@mail.gmail.com>
 <459be87d-0272-9ea9-839a-823b01e354b6@huawei.com>
 <35480172-c77e-fb67-7559-04576f375ea6@huawei.com>
 <CAM_iQpXpZd6ZaQyQifWOHSnqgAgdu1qP+fF_Na7rQ_H1vQ6eig@mail.gmail.com>
 <20200623222137.GA358561@carbon.lan>
 <b3a5298d-3c4e-ba51-7045-9643c3986054@neo-zeon.de>
 <CAM_iQpU1ji2x9Pgb6Xs7Kqoh3mmFRN3R9GKf5QoVUv82mZb8hg@mail.gmail.com>
 <20200627234127.GA36944@carbon.DHCP.thefacebook.com>
 <CAM_iQpWk4x7U_ci1WTf6BG=E3yYETBUk0yxMNSz6GuWFXfhhJw@mail.gmail.com>
 <20200630224829.GC37586@carbon.dhcp.thefacebook.com>
From:   Zefan Li <lizefan@huawei.com>
Message-ID: <b6fa2c3a-4f4e-9b93-89a2-d972652f7bb6@huawei.com>
Date:   Wed, 1 Jul 2020 09:18:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200630224829.GC37586@carbon.dhcp.thefacebook.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.86]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/7/1 6:48, Roman Gushchin wrote:
> On Tue, Jun 30, 2020 at 03:22:34PM -0700, Cong Wang wrote:
>> On Sat, Jun 27, 2020 at 4:41 PM Roman Gushchin <guro@fb.com> wrote:
>>>
>>> On Fri, Jun 26, 2020 at 10:58:14AM -0700, Cong Wang wrote:
>>>> On Thu, Jun 25, 2020 at 10:23 PM Cameron Berkenpas <cam@neo-zeon.de> wrote:
>>>>>
>>>>> Hello,
>>>>>
>>>>> Somewhere along the way I got the impression that it generally takes
>>>>> those affected hours before their systems lock up. I'm (generally) able
>>>>> to reproduce this issue much faster than that. Regardless, I can help test.
>>>>>
>>>>> Are there any patches that need testing or is this all still pending
>>>>> discussion around the  best way to resolve the issue?
>>>>
>>>> Yes. I come up with a (hopefully) much better patch in the attachment.
>>>> Can you help to test it? You need to unapply the previous patch before
>>>> applying this one.
>>>>
>>>> (Just in case of any confusion: I still believe we should check NULL on
>>>> top of this refcnt fix. But it should be a separate patch.)
>>>>
>>>> Thank you!
>>>
>>> Not opposing the patch, but the Fixes tag is still confusing me.
>>> Do we have an explanation for what's wrong with 4bfc0bb2c60e?
>>>
>>> It looks like we have cgroup_bpf_get()/put() exactly where we have
>>> cgroup_get()/put(), so it would be nice to understand what's different
>>> if the problem is bpf-related.
>>
>> Hmm, I think it is Zefan who believes cgroup refcnt is fine, the bug
>> is just in cgroup bpf refcnt, in our previous discussion.
>>
>> Although I agree cgroup refcnt is buggy too, it may not necessarily
>> cause any real problem, otherwise we would receive bug report
>> much earlier than just recently, right?
>>
>> If the Fixes tag is confusing, I can certainly remove it, but this also
>> means the patch will not be backported to stable. I am fine either
>> way, this crash is only reported after Zefan's recent change anyway.
> 
> Well, I'm not trying to protect my commit, I just don't understand
> the whole picture and what I see doesn't make complete sense to me.
> 
> I understand a problem which can be described as copying the cgroup pointer
> on cgroup cloning without bumping the reference counter.
> It seems that this problem is not caused by bpf changes, so if we're adding
> a Fixes tag, it must point at an earlier commit. Most likely, it was there from
> scratch, i.e. from bd1060ad671 ("sock, cgroup: add sock->sk_cgroup").
> Do we know why Zefan's change made it reproducible?
> 

Actually I've explain it in my earlier reply.

https://www.spinics.net/lists/netdev/msg661004.html

With my change cgroup_sk_alloc will be disabled when we create a cgroup in
netprio cgroup subsystem, and systemd keeps creating cgroups with high
frequency.

Before this change, it will be disabled only when someone writes to ifpriomap
or classid in cgroupfs, and he's very unlikely to do this if he's using
bpf in the default cgroup tree I think.

So the bug has been there for sometime.

> Btw if we want to backport the problem but can't blame a specific commit,
> we can always use something like "Cc: <stable@vger.kernel.org>    [3.1+]".
> 
