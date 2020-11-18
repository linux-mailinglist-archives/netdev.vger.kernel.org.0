Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5872B7B2A
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 11:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbgKRKXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 05:23:01 -0500
Received: from www62.your-server.de ([213.133.104.62]:51336 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbgKRKXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 05:23:01 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kfKc4-0000UL-9U; Wed, 18 Nov 2020 11:22:56 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kfKc4-000Rqw-1h; Wed, 18 Nov 2020 11:22:56 +0100
Subject: Re: [PATCH bpf-next v6 06/34] bpf: prepare for memcg-based memory
 accounting for bpf maps
To:     Roman Gushchin <guro@fb.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>, hannes@cmpxchg.org
References: <20201117034108.1186569-1-guro@fb.com>
 <20201117034108.1186569-7-guro@fb.com>
 <41eb5e5b-e651-4cb3-a6ea-9ff6b8aa41fb@iogearbox.net>
 <20201118004634.GA179309@carbon.dhcp.thefacebook.com>
 <20201118010703.GC156448@carbon.DHCP.thefacebook.com>
 <CAADnVQ+vSLfgVCXB7KnXMBzVe3rL20qLwrKf=xrJXpZTmUEnYA@mail.gmail.com>
 <20201118012841.GA186396@carbon.dhcp.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <43c845d6-ea33-0d9d-98bb-e743af4940a3@iogearbox.net>
Date:   Wed, 18 Nov 2020 11:22:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201118012841.GA186396@carbon.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25991/Tue Nov 17 14:12:35 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/20 2:28 AM, Roman Gushchin wrote:
> On Tue, Nov 17, 2020 at 05:11:00PM -0800, Alexei Starovoitov wrote:
>> On Tue, Nov 17, 2020 at 5:07 PM Roman Gushchin <guro@fb.com> wrote:
>>> On Tue, Nov 17, 2020 at 04:46:34PM -0800, Roman Gushchin wrote:
>>>> On Wed, Nov 18, 2020 at 01:06:17AM +0100, Daniel Borkmann wrote:
>>>>> On 11/17/20 4:40 AM, Roman Gushchin wrote:
>>>>>> In the absolute majority of cases if a process is making a kernel
>>>>>> allocation, it's memory cgroup is getting charged.
>>>>>>
>>>>>> Bpf maps can be updated from an interrupt context and in such
>>>>>> case there is no process which can be charged. It makes the memory
>>>>>> accounting of bpf maps non-trivial.
>>>>>>
>>>>>> Fortunately, after commit 4127c6504f25 ("mm: kmem: enable kernel
>>>>>> memcg accounting from interrupt contexts") and b87d8cefe43c
>>>>>> ("mm, memcg: rework remote charging API to support nesting")
>>>>>> it's finally possible.
>>>>>>
>>>>>> To do it, a pointer to the memory cgroup of the process which created
>>>>>> the map is saved, and this cgroup is getting charged for all
>>>>>> allocations made from an interrupt context.
>>>>>>
>>>>>> Allocations made from a process context will be accounted in a usual way.
>>>>>>
>>>>>> Signed-off-by: Roman Gushchin <guro@fb.com>
>>>>>> Acked-by: Song Liu <songliubraving@fb.com>
>>>>> [...]
>>>>>> +#ifdef CONFIG_MEMCG_KMEM
>>>>>> +static __always_inline int __bpf_map_update_elem(struct bpf_map *map, void *key,
>>>>>> +                                          void *value, u64 flags)
>>>>>> +{
>>>>>> + struct mem_cgroup *old_memcg;
>>>>>> + bool in_interrupt;
>>>>>> + int ret;
>>>>>> +
>>>>>> + /*
>>>>>> +  * If update from an interrupt context results in a memory allocation,
>>>>>> +  * the memory cgroup to charge can't be determined from the context
>>>>>> +  * of the current task. Instead, we charge the memory cgroup, which
>>>>>> +  * contained a process created the map.
>>>>>> +  */
>>>>>> + in_interrupt = in_interrupt();
>>>>>> + if (in_interrupt)
>>>>>> +         old_memcg = set_active_memcg(map->memcg);
>>>>>> +
>>>>>> + ret = map->ops->map_update_elem(map, key, value, flags);
>>>>>> +
>>>>>> + if (in_interrupt)
>>>>>> +         set_active_memcg(old_memcg);
>>>>>> +
>>>>>> + return ret;
>>>>>
>>>>> Hmm, this approach here won't work, see also commit 09772d92cd5a ("bpf: avoid
>>>>> retpoline for lookup/update/delete calls on maps") which removes the indirect
>>>>> call, so the __bpf_map_update_elem() and therefore the set_active_memcg() is
>>>>> not invoked for the vast majority of cases.
>>>>
>>>> I see. Well, the first option is to move these calls into map-specific update
>>>> functions, but the list is relatively long:
>>>>    nsim_map_update_elem()
>>>>    cgroup_storage_update_elem()
>>>>    htab_map_update_elem()
>>>>    htab_percpu_map_update_elem()
>>>>    dev_map_update_elem()
>>>>    dev_map_hash_update_elem()
>>>>    trie_update_elem()
>>>>    cpu_map_update_elem()
>>>>    bpf_pid_task_storage_update_elem()
>>>>    bpf_fd_inode_storage_update_elem()
>>>>    bpf_fd_sk_storage_update_elem()
>>>>    sock_map_update_elem()
>>>>    xsk_map_update_elem()
>>>>
>>>> Alternatively, we can set the active memcg for the whole duration of bpf
>>>> execution. It's simpler, but will add some overhead. Maybe we can somehow
>>>> mark programs calling into update helpers and skip all others?
>>>
>>> Actually, this is problematic if a program updates several maps, because
>>> in theory they can belong to different cgroups.
>>> So it seems that the first option is the way to go. Do you agree?
>>
>> May be instead of kmalloc_node() that is used by most of the map updates
>> introduce bpf_map_kmalloc_node() that takes a map pointer as an argument?
>> And do set_memcg inside?
> 
> I suspect it's not only kmalloc_node(), but if there will be 2-3 allocation
> helpers, it sounds like a good idea to me! I'll try and get back with v7 soon.

Could this be baked into kmalloc*() API itself given we also need to pass in
__GFP_ACCOUNT everywhere, so we'd have a new API with additional argument where
we pass the memcg pointer to tell it directly where to account it for instead of
having to have the extra set_active_memcg() set/restore dance via BPF wrapper?
It seems there would be not much specifics on BPF itself and if it's more generic
it could also be used by other subsystems.

Thanks,
Daniel
