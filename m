Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8BC2130E0
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 03:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgGCBRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 21:17:17 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:6812 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725937AbgGCBRQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 21:17:16 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7CA99D6A1D543C57A24F;
        Fri,  3 Jul 2020 09:17:15 +0800 (CST)
Received: from [10.174.178.86] (10.174.178.86) by smtp.huawei.com
 (10.3.19.210) with Microsoft SMTP Server (TLS) id 14.3.487.0; Fri, 3 Jul 2020
 09:17:10 +0800
Subject: Re: [Patch net] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
To:     Roman Gushchin <guro@fb.com>, Cong Wang <xiyou.wangcong@gmail.com>
CC:     Cameron Berkenpas <cam@neo-zeon.de>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        =?UTF-8?Q?Dani=c3=abl_Sonck?= <dsonck92@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tejun Heo <tj@kernel.org>
References: <459be87d-0272-9ea9-839a-823b01e354b6@huawei.com>
 <35480172-c77e-fb67-7559-04576f375ea6@huawei.com>
 <CAM_iQpXpZd6ZaQyQifWOHSnqgAgdu1qP+fF_Na7rQ_H1vQ6eig@mail.gmail.com>
 <20200623222137.GA358561@carbon.lan>
 <b3a5298d-3c4e-ba51-7045-9643c3986054@neo-zeon.de>
 <CAM_iQpU1ji2x9Pgb6Xs7Kqoh3mmFRN3R9GKf5QoVUv82mZb8hg@mail.gmail.com>
 <20200627234127.GA36944@carbon.DHCP.thefacebook.com>
 <CAM_iQpWk4x7U_ci1WTf6BG=E3yYETBUk0yxMNSz6GuWFXfhhJw@mail.gmail.com>
 <20200630224829.GC37586@carbon.dhcp.thefacebook.com>
 <CAM_iQpWRsuFE4NRhGncihK8UmPoMv1tEHMM0ufWxVCaP9pdTQg@mail.gmail.com>
 <20200702160242.GA91667@carbon.dhcp.thefacebook.com>
From:   Zefan Li <lizefan@huawei.com>
Message-ID: <42baf0f8-627b-0ab8-72fc-12d24667ad0a@huawei.com>
Date:   Fri, 3 Jul 2020 09:17:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200702160242.GA91667@carbon.dhcp.thefacebook.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.86]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/7/3 0:02, Roman Gushchin wrote:
> On Wed, Jul 01, 2020 at 09:48:48PM -0700, Cong Wang wrote:
>> On Tue, Jun 30, 2020 at 3:48 PM Roman Gushchin <guro@fb.com> wrote:
>>>
>>> Btw if we want to backport the problem but can't blame a specific commit,
>>> we can always use something like "Cc: <stable@vger.kernel.org>    [3.1+]".
>>
>> Sure, but if we don't know which is the right commit to blame, then how
>> do we know which stable version should the patch target? :)
>>
>> I am open to all options here, including not backporting to stable at all.
> 
> It seems to be that the issue was there from bd1060a1d671 ("sock, cgroup: add sock->sk_cgroup"),
> so I'd go with it. Otherwise we can go with 5.4+, as I understand before that it was
> hard to reproduce it.
> 

Actually I think it should be very easy to reproduce the bug.

suppose default cgroup and netcls cgroup are mounted in /cgroup/default and
/cgroup/netcls respectively, and then:

1. mkdir /cgroup/default/sub1
2. mkdir /cgroup/default/sub2
3. attach some tasks into sub1/ and sub2/
4. attach bpf program to sub1/ and sub2/ # get bpf refcnt for those cgroups
5. echo 1 > /cgroup/netcls/classid       # this will disable cgroup_sk_alloc
6. kill all tasks in sub1/ and sub2/
7. rmdir sub1/ sub2/

The last step will deref bpf for the default root cgroup instead of sub1/
and sub2/, and should trigger the bug.

FYI I never use bpf, so I might be wrong.
