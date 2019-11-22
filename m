Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC95107B15
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 00:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfKVXHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 18:07:00 -0500
Received: from www62.your-server.de ([213.133.104.62]:43718 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfKVXHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 18:07:00 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iYI0v-0001KR-2h; Sat, 23 Nov 2019 00:06:57 +0100
Received: from [178.197.248.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iYI0u-000GVF-Qi; Sat, 23 Nov 2019 00:06:56 +0100
Subject: Re: [PATCH bpf-next v2 5/8] bpf: add poke dependency tracking for
 prog array maps
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <cover.1574452833.git.daniel@iogearbox.net>
 <1fb364bb3c565b3e415d5ea348f036ff379e779d.1574452833.git.daniel@iogearbox.net>
 <CAEf4BzaZf+_WyARsmZ_rgO_+Ug1iSKsqaoWpB-dPXS6uejT=Qg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d019af80-e6ac-fbd5-f4fd-4743d4df5119@iogearbox.net>
Date:   Sat, 23 Nov 2019 00:06:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzaZf+_WyARsmZ_rgO_+Ug1iSKsqaoWpB-dPXS6uejT=Qg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25641/Fri Nov 22 11:06:48 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/22/19 11:55 PM, Andrii Nakryiko wrote:
> On Fri, Nov 22, 2019 at 12:08 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>
>> This work adds program tracking to prog array maps. This is needed such
>> that upon prog array updates/deletions we can fix up all programs which
>> make use of this tail call map. We add ops->map_poke_{un,}track()
>> helpers to maps to maintain the list of programs and ops->map_poke_run()
>> for triggering the actual update.
>>
>> bpf_array_aux is extended to contain the list head and poke_mutex in
>> order to serialize program patching during updates/deletions.
>> bpf_free_used_maps() will untrack the program shortly before dropping
>> the reference to the map. For clearing out the prog array once all urefs
>> are dropped we need to use schedule_work() to have a sleepable context.
>>
>> The prog_array_map_poke_run() is triggered during updates/deletions and
>> walks the maintained prog list. It checks in their poke_tabs whether the
>> map and key is matching and runs the actual bpf_arch_text_poke() for
>> patching in the nop or new jmp location. Depending on the type of update,
>> we use one of BPF_MOD_{NOP_TO_JUMP,JUMP_TO_NOP,JUMP_TO_JUMP}.
>>
>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>> ---
>>   include/linux/bpf.h   |  12 +++
>>   kernel/bpf/arraymap.c | 183 +++++++++++++++++++++++++++++++++++++++++-
>>   kernel/bpf/core.c     |   9 ++-
>>   kernel/bpf/syscall.c  |  20 +++--
>>   4 files changed, 212 insertions(+), 12 deletions(-)
>>
> 
> [...]
> 
>> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
>> index 5a9873e58a01..bb002f15b32a 100644
>> --- a/kernel/bpf/syscall.c
>> +++ b/kernel/bpf/syscall.c
>> @@ -26,12 +26,13 @@
>>   #include <linux/audit.h>
>>   #include <uapi/linux/btf.h>
>>
>> -#define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PROG_ARRAY || \
>> -                          (map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
>> -                          (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
>> -                          (map)->map_type == BPF_MAP_TYPE_ARRAY_OF_MAPS)
>> +#define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
>> +                         (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
>> +                         (map)->map_type == BPF_MAP_TYPE_ARRAY_OF_MAPS)
>> +#define IS_FD_PROG_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PROG_ARRAY)
>>   #define IS_FD_HASH(map) ((map)->map_type == BPF_MAP_TYPE_HASH_OF_MAPS)
>> -#define IS_FD_MAP(map) (IS_FD_ARRAY(map) || IS_FD_HASH(map))
>> +#define IS_FD_MAP(map) (IS_FD_ARRAY(map) || IS_FD_PROG_ARRAY(map) || \
>> +                       IS_FD_HASH(map))
>>
>>   #define BPF_OBJ_FLAG_MASK   (BPF_F_RDONLY | BPF_F_WRONLY)
>>
>> @@ -878,7 +879,7 @@ static int map_lookup_elem(union bpf_attr *attr)
>>                  err = bpf_percpu_cgroup_storage_copy(map, key, value);
>>          } else if (map->map_type == BPF_MAP_TYPE_STACK_TRACE) {
>>                  err = bpf_stackmap_copy(map, key, value);
>> -       } else if (IS_FD_ARRAY(map)) {
>> +       } else if (IS_FD_ARRAY(map) || IS_FD_PROG_ARRAY(map)) {
> 
> Why BPF_MAP_TYPE_PROG_ARRAY couldn't still stay as "IS_FD_ARRAY"?
> Seems like it's still handled the same here and is technically an
> array containing FDs, no? You can still have more precise

For the update and delete method we need to hold the mutex in prog array
which is why we cannot be under RCU there. For the lookup itself it can
stay as-is since it's not a modification hence the or above.

> IS_FD_PROG_ARRAY, for cases like in map_update_elem(), where you need
> to special-handle just that map type.
> 
>>                  err = bpf_fd_array_map_lookup_elem(map, key, value);
>>          } else if (IS_FD_HASH(map)) {
>>                  err = bpf_fd_htab_map_lookup_elem(map, key, value);
>> @@ -1005,6 +1006,10 @@ static int map_update_elem(union bpf_attr *attr)
>>                     map->map_type == BPF_MAP_TYPE_SOCKMAP) {
>>                  err = map->ops->map_update_elem(map, key, value, attr->flags);
>>                  goto out;
>> +       } else if (IS_FD_PROG_ARRAY(map)) {
>> +               err = bpf_fd_array_map_update_elem(map, f.file, key, value,
>> +                                                  attr->flags);
>> +               goto out;
>>          }
>>
>>          /* must increment bpf_prog_active to avoid kprobe+bpf triggering from
>> @@ -1087,6 +1092,9 @@ static int map_delete_elem(union bpf_attr *attr)
>>          if (bpf_map_is_dev_bound(map)) {
>>                  err = bpf_map_offload_delete_elem(map, key);
>>                  goto out;
>> +       } else if (IS_FD_PROG_ARRAY(map)) {
>> +               err = map->ops->map_delete_elem(map, key);
> 
> map->ops->map_delete_elem would be called below anyways, except under
> rcu_read_lock() with preempt_disable() (maybe_wait_bpf_programs() is
> no-op for prog_array). So if there is specific reason we want to avoid
> preempt_disable and rcu_read_lock(), would be nice to have a comment
> explaining that.

See answer above. I didn't add an explicit comment there since it's not done
for all the others either, but seems obvious when looking at the map implementation
and prog_array_map_poke_run() / bpf_arch_text_poke().

Thanks,
Daniel
