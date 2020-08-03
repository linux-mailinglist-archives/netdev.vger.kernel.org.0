Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0BD23AC7B
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 20:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbgHCShU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 14:37:20 -0400
Received: from www62.your-server.de ([213.133.104.62]:55908 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgHCShU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 14:37:20 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k2fKm-0003NY-6v; Mon, 03 Aug 2020 20:37:16 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k2fKm-000L9j-0W; Mon, 03 Aug 2020 20:37:16 +0200
Subject: Re: [PATCH bpf-next v3 00/29] bpf: switch to memcg-based memory
 accounting
To:     Roman Gushchin <guro@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>, kernel-team@fb.com,
        linux-kernel@vger.kernel.org
References: <20200730212310.2609108-1-guro@fb.com>
 <6b1777ac-cae1-fa1f-db53-f6061d9ae675@iogearbox.net>
 <20200803153449.GA1020566@carbon.DHCP.thefacebook.com>
 <a620f231-1e68-6ac5-d7d2-57afa68e91c9@iogearbox.net>
 <20200803170549.GC1020566@carbon.DHCP.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e17c28a7-d4ff-0689-b2d9-93495e60c4cf@iogearbox.net>
Date:   Mon, 3 Aug 2020 20:37:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200803170549.GC1020566@carbon.DHCP.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25893/Mon Aug  3 17:01:47 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/20 7:05 PM, Roman Gushchin wrote:
> On Mon, Aug 03, 2020 at 06:39:01PM +0200, Daniel Borkmann wrote:
>> On 8/3/20 5:34 PM, Roman Gushchin wrote:
>>> On Mon, Aug 03, 2020 at 02:05:29PM +0200, Daniel Borkmann wrote:
>>>> On 7/30/20 11:22 PM, Roman Gushchin wrote:
>>>>> Currently bpf is using the memlock rlimit for the memory accounting.
>>>>> This approach has its downsides and over time has created a significant
>>>>> amount of problems:
>>>>>
>>>>> 1) The limit is per-user, but because most bpf operations are performed
>>>>>       as root, the limit has a little value.
>>>>>
>>>>> 2) It's hard to come up with a specific maximum value. Especially because
>>>>>       the counter is shared with non-bpf users (e.g. memlock() users).
>>>>>       Any specific value is either too low and creates false failures
>>>>>       or too high and useless.
>>>>>
>>>>> 3) Charging is not connected to the actual memory allocation. Bpf code
>>>>>       should manually calculate the estimated cost and precharge the counter,
>>>>>       and then take care of uncharging, including all fail paths.
>>>>>       It adds to the code complexity and makes it easy to leak a charge.
>>>>>
>>>>> 4) There is no simple way of getting the current value of the counter.
>>>>>       We've used drgn for it, but it's far from being convenient.
>>>>>
>>>>> 5) Cryptic -EPERM is returned on exceeding the limit. Libbpf even had
>>>>>       a function to "explain" this case for users.
>>>>>
>>>>> In order to overcome these problems let's switch to the memcg-based
>>>>> memory accounting of bpf objects. With the recent addition of the percpu
>>>>> memory accounting, now it's possible to provide a comprehensive accounting
>>>>> of memory used by bpf programs and maps.
>>>>>
>>>>> This approach has the following advantages:
>>>>> 1) The limit is per-cgroup and hierarchical. It's way more flexible and allows
>>>>>       a better control over memory usage by different workloads.
>>>>>
>>>>> 2) The actual memory consumption is taken into account. It happens automatically
>>>>>       on the allocation time if __GFP_ACCOUNT flags is passed. Uncharging is also
>>>>>       performed automatically on releasing the memory. So the code on the bpf side
>>>>>       becomes simpler and safer.
>>>>>
>>>>> 3) There is a simple way to get the current value and statistics.
>>>>>
>>>>> The patchset consists of the following parts:
>>>>> 1) memcg-based accounting for various bpf objects: progs and maps
>>>>> 2) removal of the rlimit-based accounting
>>>>> 3) removal of rlimit adjustments in userspace samples
>>>
>>>> The diff stat looks nice & agree that rlimit sucks, but I'm missing how this is set
>>>> is supposed to work reliably, at least I currently fail to see it. Elaborating on this
>>>> in more depth especially for the case of unprivileged users should be a /fundamental/
>>>> part of the commit message.
>>>>
>>>> Lets take an example: unprivileged user adds a max sized hashtable to one of its
>>>> programs, and configures the map that it will perform runtime allocation. The load
>>>> succeeds as it doesn't surpass the limits set for the current memcg. Kernel then
>>>> processes packets from softirq. Given the runtime allocations, we end up mischarging
>>>> to whoever ended up triggering __do_softirq(). If, for example, ksoftirq thread, then
>>>> it's probably reasonable to assume that this might not be accounted e.g. limits are
>>>> not imposed on the root cgroup. If so we would probably need to drag the context of
>>>> /where/ this must be charged to __memcg_kmem_charge_page() to do it reliably. Otherwise
>>>> how do you protect unprivileged users to OOM the machine?
>>>
>>> this is a valid concern, thank you for bringing it in. It can be resolved by
>>> associating a map with a memory cgroup on creation, so that we can charge
>>> this memory cgroup later, even from a soft-irq context. The question here is
>>> whether we want to do it for all maps, or just for dynamic hashtables
>>> (or any similar cases, if there are any)? I think the second option
>>> is better. With the first option we have to annotate all memory allocations
>>> in bpf maps code with memalloc_use_memcg()/memalloc_unuse_memcg(),
>>> so it's easy to mess it up in the future.
>>> What do you think?
>>
>> We would need to do it for all maps that are configured with non-prealloc, e.g. not
>> only hash/LRU table but also others like LPM maps etc. I wonder whether program entry/
>> exit could do the memalloc_use_memcg() / memalloc_unuse_memcg() and then everything
>> would be accounted against the prog's memcg from runtime side, but then there's the
>> usual issue with 'unuse'-restore on tail calls, and it doesn't solve the syscall side.
>> But seems like the memalloc_{use,unuse}_memcg()'s remote charging is lightweight
>> anyway compared to some of the other map update work such as taking bucket lock etc.
> 
> I'll explore it and address in the next version. Thank you for suggestions!

Ok.

I'm probably still missing one more thing, but could you elaborate what limits would
be enforced if an unprivileged user creates a prog/map on the host (w/o further action
such as moving to a specific cgroup)?

 From what I can tell via looking at systemd:

   $ cat /proc/self/cgroup
   11:cpuset:/
   10:hugetlb:/
   9:devices:/user.slice
   8:cpu,cpuacct:/
   7:freezer:/
   6:pids:/user.slice/user-1000.slice/user@1000.service
   5:memory:/user.slice/user-1000.slice/user@1000.service
   4:net_cls,net_prio:/
   3:perf_event:/
   2:blkio:/
   1:name=systemd:/user.slice/user-1000.slice/user@1000.service/gnome-terminal-server.service
   0::/user.slice/user-1000.slice/user@1000.service/gnome-terminal-server.service

And then:

   $ systemctl cat user-1000.slice
   # /usr/lib/systemd/system/user-.slice.d/10-defaults.conf
   #  SPDX-License-Identifier: LGPL-2.1+
   #
   #  This file is part of systemd.
   #
   #  systemd is free software; you can redistribute it and/or modify it
   #  under the terms of the GNU Lesser General Public License as published by
   #  the Free Software Foundation; either version 2.1 of the License, or
   #  (at your option) any later version.

   [Unit]
   Description=User Slice of UID %j
   Documentation=man:user@.service(5)
   After=systemd-user-sessions.service
   StopWhenUnneeded=yes

   [Slice]
   TasksMax=33%

So that has a Pid limit in place by default, but it does not say anything on memory. I
presume the accounting relevant to us is tracked in memory.kmem.limit_in_bytes and
memory.kmem.usage_in_bytes, is that correct? If true, it looks like the default would
not prevent from OOM, no?

   $ cat /sys/fs/cgroup/memory/user.slice/user-1000.slice/user@1000.service/memory.kmem.usage_in_bytes
   257966080
   $ cat /sys/fs/cgroup/memory/user.slice/user-1000.slice/user@1000.service/memory.kmem.limit_in_bytes
   9223372036854771712

>>>> Similarly, what happens to unprivileged users if kmemcg was not configured into the
>>>> kernel or has been disabled?
>>>
>>> Well, I don't think we can address it. Memcg-based memory accounting requires
>>> enabled memory cgroups, a properly configured cgroup tree and also the kernel
>>> memory accounting turned on to function properly.
>>> Because we at Facebook are using cgroup for the memory accounting and control
>>> everywhere, I might be biased. If there are real !memcg systems which are
>>> actively using non-privileged bpf, we should keep the old system in place
>>> and make it optional, so everyone can choose between having both accounting
>>> systems or just the new one. Or we can disable the rlimit-based accounting
>>> for root. But eliminating it completely looks so much nicer to me.
>>
>> Eliminating it entirely feels better indeed. Another option could be that BPF kconfig
>> would select memcg, so it's always built with it. Perhaps that is an acceptable tradeoff.
> 
> But wouldn't it limit the usage of bpf on embedded devices?
> Where memory cgroups are probably not used, but bpf still can be useful for tracing,
> for example.
> 
> Adding this build dependency doesn't really guarantee anything (e.g. cgroupfs
> can be simple not mounted on the system), so I'm not sure if we really need it.

Argh, true as well. :/ Is there some fallback accounting/limitation that could be done
either explicit or ideally hidden via __GFP_ACCOUNT for unprivileged? We still need to
prevent unprivileged users to easily cause OOM damage in those situations, too.

Thanks,
Daniel
