Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B11D91CBC8D
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 04:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbgEICbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 22:31:12 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4360 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728353AbgEICbM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 22:31:12 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 875F0357F44AF9147B08;
        Sat,  9 May 2020 10:31:08 +0800 (CST)
Received: from [127.0.0.1] (10.166.215.99) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Sat, 9 May 2020
 10:31:01 +0800
Subject: Re: cgroup pointed by sock is leaked on mode switch
To:     Zefan Li <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <netdev@vger.kernel.org>,
        "Libin (Huawei)" <huawei.libin@huawei.com>, <guofan5@huawei.com>,
        <wangkefeng.wang@huawei.com>
References: <03dab6ab-0ffe-3cae-193f-a7f84e9b14c5@huawei.com>
 <20200505160639.GG12217@mtj.thefacebook.com>
 <c9879fd2-cb91-2a08-8293-c6a436b5a539@huawei.com>
 <0a6ae984-e647-5ada-8849-3fa2fb994ff3@huawei.com>
 <1edd6b6c-ab3c-6a51-6460-6f5d7f37505e@huawei.com>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <6ff6124e-72d9-5739-22cf-2f0aea938a19@huawei.com>
Date:   Sat, 9 May 2020 10:31:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1edd6b6c-ab3c-6a51-6460-6f5d7f37505e@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.166.215.99]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/5/6 15:51, Zefan Li wrote:
> On 2020/5/6 10:16, Zefan Li wrote:
>> On 2020/5/6 9:50, Yang Yingliang wrotee:
>>> +cc lizefan@huawei.com
>>>
>>> On 2020/5/6 0:06, Tejun Heo wrote:
>>>> Hello, Yang.
>>>>
>>>> On Sat, May 02, 2020 at 06:27:21PM +0800, Yang Yingliang wrote:
>>>>> I find the number nr_dying_descendants is increasing:
>>>>> linux-dVpNUK:~ # find /sys/fs/cgroup/ -name cgroup.stat -exec grep
>>>>> '^nr_dying_descendants [^0]'  {} +
>>>>> /sys/fs/cgroup/unified/cgroup.stat:nr_dying_descendants 80
>>>>> /sys/fs/cgroup/unified/system.slice/cgroup.stat:nr_dying_descendants 
>>>>> 1
>>>>> /sys/fs/cgroup/unified/system.slice/system-hostos.slice/cgroup.stat:nr_dying_descendants 
>>>>>
>>>>> 1
>>>>> /sys/fs/cgroup/unified/lxc/cgroup.stat:nr_dying_descendants 79
>>>>> /sys/fs/cgroup/unified/lxc/5f1fdb8c54fa40c3e599613dab6e4815058b76ebada8a27bc1fe80c0d4801764/cgroup.stat:nr_dying_descendants 
>>>>>
>>>>> 78
>>>>> /sys/fs/cgroup/unified/lxc/5f1fdb8c54fa40c3e599613dab6e4815058b76ebada8a27bc1fe80c0d4801764/system.slice/cgroup.stat:nr_dying_descendants 
>>>>>
>>>>> 78
>>>> Those numbers are nowhere close to causing oom issues. There are some
>>>> aspects of page and other cache draining which is being improved 
>>>> but unless
>>>> you're seeing numbers multiple orders of magnitude higher, this 
>>>> isn't the
>>>> source of your problem.
>>>>
>>>>> The situation is as same as the commit bd1060a1d671 ("sock, 
>>>>> cgroup: add
>>>>> sock->sk_cgroup") describes.
>>>>> "On mode switch, cgroup references which are already being pointed 
>>>>> to by
>>>>> socks may be leaked."
>>>> I'm doubtful that you're hitting that issue. Mode switching means 
>>>> memcg
>>>> being switched between cgroup1 and cgroup2 hierarchies, which is 
>>>> unlikely to
>>>> be what's happening when you're launching docker containers.
>>>>
>>>> The first step would be identifying where memory is going and 
>>>> finding out
>>>> whether memcg is actually being switched between cgroup1 and 2 - 
>>>> look at the
>>>> hierarchy number in /proc/cgroups, if that's switching between 0 and
>>>> someting not zero, it is switching.
>>>>
>>
>> I think there's a bug here which can lead to unlimited memory leak.
>> This should reproduce the bug:
>>
>>     # mount -t cgroup -o netprio xxx /cgroup/netprio
>>     # mkdir /cgroup/netprio/xxx
>>     # echo PID > /cgroup/netprio/xxx/tasks
>>     /* this PID process starts to do some network thing and then 
>> exits */
>>     # rmdir /cgroup/netprio/xxx
>>     /* now this cgroup will never be freed */
>>
>
> Correction (still not tested):
>
>     # mount -t cgroup2 none /cgroup/v2
>     # mkdir /cgroup/v2/xxx
>     # echo PID > /cgroup/v2/xxx/cgroup.procs
>     /* this PID process starts to do some network thing */
>
>     # mount -t cgroup -o netprio xxx /cgroup/netprio
>     # mkdir /cgroup/netprio/xxx
>     # echo PID > /cgroup/netprio/xxx/tasks
>     ...
>     /* the PID process exits */
>
>     rmdir /cgroup/netprio/xxx
>     rmdir /cgroup/v2/xxx
>     /* now looks like this v2 cgroup will never be freed */
>
>> Look at the code:
>>
>> static inline void sock_update_netprioidx(struct sock_cgroup_data *skcd)
>> {
>>      ...
>>      sock_cgroup_set_prioidx(skcd, task_netprioidx(current));
>> }
>>
>> static inline void sock_cgroup_set_prioidx(struct sock_cgroup_data 
>> *skcd,
>>                      u16 prioidx)
>> {
>>      ...
>>      if (sock_cgroup_prioidx(&skcd_buf) == prioidx)
>>          return ;
>>      ...
>>      skcd_buf.prioidx = prioidx;
>>      WRITE_ONCE(skcd->val, skcd_buf.val);
>> }
>>
>> task_netprioidx() will be the cgrp id of xxx which is not 1, but
>> sock_cgroup_prioidx(&skcd_buf) is 1 because it thought it's in v2 mode.
>> Now we have a memory leak.
>>
>> I think the eastest fix is to do the mode switch here:
>>
>> diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
>> index b905747..2397866 100644
>> --- a/net/core/netprio_cgroup.c
>> +++ b/net/core/netprio_cgroup.c
>> @@ -240,6 +240,8 @@ static void net_prio_attach(struct cgroup_taskset 
>> *tset)
>>          struct task_struct *p;
>>          struct cgroup_subsys_state *css;
>>
>> +       cgroup_sk_alloc_disable();
>> +
>>          cgroup_taskset_for_each(p, css, tset) {
>>                  void *v = (void *)(unsigned long)css->cgroup->id;
>
I've do some test with this change, here is the test result:


Without this change, nr_dying_descendants is increased and the cgroup is 
leaked:

linux-dVpNUK:~ # mount | grep cgroup
tmpfs on /sys/fs/cgroup type tmpfs (ro,nosuid,nodev,noexec,mode=755)
cgroup2 on /sys/fs/cgroup/unified type cgroup2 
(rw,nosuid,nodev,noexec,relatime,nsdelegate)
cgroup on /sys/fs/cgroup/systemd type cgroup 
(rw,nosuid,nodev,noexec,relatime,xattr,name=systemd)
cgroup on /sys/fs/cgroup/blkio type cgroup 
(rw,nosuid,nodev,noexec,relatime,blkio)
cgroup on /sys/fs/cgroup/cpu,cpuacct type cgroup 
(rw,nosuid,nodev,noexec,relatime,cpu,cpuacct)
cgroup on /sys/fs/cgroup/net_cls,net_prio type cgroup 
(rw,nosuid,nodev,noexec,relatime,net_cls,net_prio)
cgroup on /sys/fs/cgroup/freezer type cgroup 
(rw,nosuid,nodev,noexec,relatime,freezer)
cgroup on /sys/fs/cgroup/devices type cgroup 
(rw,nosuid,nodev,noexec,relatime,devices)
cgroup on /sys/fs/cgroup/memory type cgroup 
(rw,nosuid,nodev,noexec,relatime,memory)
cgroup on /sys/fs/cgroup/cpuset type cgroup 
(rw,nosuid,nodev,noexec,relatime,cpuset)
cgroup on /sys/fs/cgroup/perf_event type cgroup 
(rw,nosuid,nodev,noexec,relatime,perf_event)
cgroup on /sys/fs/cgroup/pids type cgroup 
(rw,nosuid,nodev,noexec,relatime,pids)
cgroup on /sys/fs/cgroup/hugetlb type cgroup 
(rw,nosuid,nodev,noexec,relatime,hugetlb)
linux-dVpNUK:~ # mkdir /sys/fs/cgroup/net_cls,net_prio/test
linux-dVpNUK:~ # ps -ef | grep bash
root     12151 12150  0 00:31 pts/0    00:00:00 -bash
root     12322 12321  0 00:31 pts/1    00:00:00 -bash
root     12704 12703  0 00:31 pts/2    00:00:00 -bash
root     13359 12704  0 00:31 pts/2    00:00:00 grep --color=auto bash
linux-dVpNUK:~ # echo 12151 > /sys/fs/cgroup/net_cls,net_prio/test/tasks
linux-dVpNUK:~ # echo 12322 > /sys/fs/cgroup/net_cls,net_prio/test/tasks

(Use bash(12151/12322) do some network things, then kill them, the 
nr_dying_descendants is increased.)
linux-dVpNUK:~ # find /sys/fs/cgroup/ -name cgroup.stat -exec grep 
'^nr_dying_descendants [^0]'  {} +
/sys/fs/cgroup/unified/cgroup.stat:nr_dying_descendants 1
/sys/fs/cgroup/unified/system.slice/cgroup.stat:nr_dying_descendants 1
/sys/fs/cgroup/unified/system.slice/system-hostos.slice/cgroup.stat:nr_dying_descendants 
1
linux-dVpNUK:~ # kill 12151 12322
linux-dVpNUK:~ # find /sys/fs/cgroup/ -name cgroup.stat -exec grep 
'^nr_dying_descendants [^0]'  {} +
/sys/fs/cgroup/unified/cgroup.stat:nr_dying_descendants 3
/sys/fs/cgroup/unified/user.slice/cgroup.stat:nr_dying_descendants 2
/sys/fs/cgroup/unified/user.slice/user-0.slice/cgroup.stat:nr_dying_descendants 
2
/sys/fs/cgroup/unified/system.slice/cgroup.stat:nr_dying_descendants 1
/sys/fs/cgroup/unified/system.slice/system-hostos.slice/cgroup.stat:nr_dying_descendants 
1

(after rmdir test, the nr_dying_descendants is not decreased.)
linux-dVpNUK:~ # rmdir /sys/fs/cgroup/net_cls,net_prio/test
linux-dVpNUK:~ # find /sys/fs/cgroup/ -name cgroup.stat -exec grep 
'^nr_dying_descendants [^0]'  {} +
/sys/fs/cgroup/unified/cgroup.stat:nr_dying_descendants 3
/sys/fs/cgroup/unified/user.slice/cgroup.stat:nr_dying_descendants 2
/sys/fs/cgroup/unified/user.slice/user-0.slice/cgroup.stat:nr_dying_descendants 
2
/sys/fs/cgroup/unified/system.slice/cgroup.stat:nr_dying_descendants 1
/sys/fs/cgroup/unified/system.slice/system-hostos.slice/cgroup.stat:nr_dying_descendants 
1


With this change, nr_dying_descendants is not increased:

linux-dVpNUK:~ # mkdir /sys/fs/cgroup/net_cls,net_prio/test
linux-dVpNUK:~ # ps -ef | grep bash
root      5466  5443  0 00:50 pts/1    00:00:00 -bash
root      5724  5723  0 00:50 pts/2    00:00:00 -bash
root      6701 17013  0 00:50 pts/0    00:00:00 grep --color=auto bash
root     17013 17012  0 00:46 pts/0    00:00:00 -bash
linux-dVpNUK:~ # echo 5466 > /sys/fs/cgroup/net_cls,net_prio/test/tasks
linux-dVpNUK:~ # echo 5724 > /sys/fs/cgroup/net_cls,net_prio/test/tasks
linux-dVpNUK:~ # find /sys/fs/cgroup/ -name cgroup.stat -exec grep 
'^nr_dying_descendants [^0]'  {} +
/sys/fs/cgroup/unified/cgroup.stat:nr_dying_descendants 1
/sys/fs/cgroup/unified/system.slice/cgroup.stat:nr_dying_descendants 1
/sys/fs/cgroup/unified/system.slice/system-hostos.slice/cgroup.stat:nr_dying_descendants 
1
linux-dVpNUK:~ # kill 5466 5724
linux-dVpNUK:~ # find /sys/fs/cgroup/ -name cgroup.stat -exec grep 
'^nr_dying_descendants [^0]'  {} +
/sys/fs/cgroup/unified/cgroup.stat:nr_dying_descendants 1
/sys/fs/cgroup/unified/system.slice/cgroup.stat:nr_dying_descendants 1
/sys/fs/cgroup/unified/system.slice/system-hostos.slice/cgroup.stat:nr_dying_descendants 
1
linux-dVpNUK:~ # rmdir /sys/fs/cgroup/net_cls,net_prio/test/
linux-dVpNUK:~ # find /sys/fs/cgroup/ -name cgroup.stat -exec grep 
'^nr_dying_descendants [^0]'  {} +
/sys/fs/cgroup/unified/cgroup.stat:nr_dying_descendants 1
/sys/fs/cgroup/unified/system.slice/cgroup.stat:nr_dying_descendants 1
/sys/fs/cgroup/unified/system.slice/system-hostos.slice/cgroup.stat:nr_dying_descendants 
1

> .

