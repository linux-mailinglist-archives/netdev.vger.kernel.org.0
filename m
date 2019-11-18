Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C80C100DCE
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 22:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfKRVgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 16:36:02 -0500
Received: from www62.your-server.de ([213.133.104.62]:54312 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbfKRVgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 16:36:02 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iWogh-00009f-Mj; Mon, 18 Nov 2019 22:35:59 +0100
Received: from [178.197.248.45] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iWogh-0001gt-Bk; Mon, 18 Nov 2019 22:35:59 +0100
Subject: Re: [PATCH rfc bpf-next 6/8] bpf: add poke dependency tracking for
 prog array maps
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <cover.1573779287.git.daniel@iogearbox.net>
 <ff9a3829fb46802262a20dbad1123cd66c118b8b.1573779287.git.daniel@iogearbox.net>
 <CAEf4BzaxyULFPYd8OGfoc5FLSDt2ecppLFakjRJ2TyK5F-fJOw@mail.gmail.com>
 <4ae5ae7b-d7bb-4a59-0f5f-0f7f41bd6f6d@iogearbox.net>
 <CAEf4BzZ9SaQ_idpP8P8mG26KC72GG+xY57A76nsBCvOPSxOJEA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c21cff3f-c504-15ee-1d27-e9e45d1d9bc6@iogearbox.net>
Date:   Mon, 18 Nov 2019 22:35:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZ9SaQ_idpP8P8mG26KC72GG+xY57A76nsBCvOPSxOJEA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25637/Mon Nov 18 10:53:23 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/19 7:46 PM, Andrii Nakryiko wrote:
> On Mon, Nov 18, 2019 at 10:39 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 11/18/19 6:39 PM, Andrii Nakryiko wrote:
>>> On Thu, Nov 14, 2019 at 5:04 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>>>
>>>> This work adds program tracking to prog array maps. This is needed such
>>>> that upon prog array updates/deletions we can fix up all programs which
>>>> make use of this tail call map. We add ops->map_poke_{un,}track() helpers
>>>> to maps to maintain the list of programs and ops->map_poke_run() for
>>>> triggering the actual update. bpf_array_aux is extended to contain the
>>>> list head and poke_mutex in order to serialize program patching during
>>>> updates/deletions. bpf_free_used_maps() will untrack the program shortly
>>>> before dropping the reference to the map.
>>>>
>>>> The prog_array_map_poke_run() is triggered during updates/deletions and
>>>> walks the maintained prog list. It checks in their poke_tabs whether the
>>>> map and key is matching and runs the actual bpf_arch_text_poke() for
>>>> patching in the nop or new jmp location. Depending on the type of update,
>>>> we use one of BPF_MOD_{NOP_TO_JUMP,JUMP_TO_NOP,JUMP_TO_JUMP}.
>>>>
>>>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>>>> ---
>>>>    include/linux/bpf.h   |  36 +++++++++++++
>>>>    kernel/bpf/arraymap.c | 120 +++++++++++++++++++++++++++++++++++++++++-
>>>>    kernel/bpf/core.c     |   9 +++-
>>>>    3 files changed, 162 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>>>> index 0ff06a0d0058..62a369fb8d98 100644
>>>> --- a/include/linux/bpf.h
>>>> +++ b/include/linux/bpf.h
>>>> @@ -21,6 +21,7 @@ struct bpf_verifier_env;
>>>>    struct bpf_verifier_log;
>>>>    struct perf_event;
>>>>    struct bpf_prog;
>>>> +struct bpf_prog_aux;
>>>>    struct bpf_map;
>>>>    struct sock;
>>>>    struct seq_file;
>>>> @@ -63,6 +64,12 @@ struct bpf_map_ops {
>>>>                                const struct btf_type *key_type,
>>>>                                const struct btf_type *value_type);
>>>>
>>>> +       /* Prog poke tracking helpers. */
>>>> +       int (*map_poke_track)(struct bpf_map *map, struct bpf_prog_aux *aux);
>>>> +       void (*map_poke_untrack)(struct bpf_map *map, struct bpf_prog_aux *aux);
>>>> +       void (*map_poke_run)(struct bpf_map *map, u32 key, struct bpf_prog *old,
>>>> +                            struct bpf_prog *new);
>>>
>>> You are passing bpf_prog_aux for track/untrack, but bpf_prog itself
>>> for run. Maybe stick to just bpf_prog everywhere?
>>
>> This needs to be bpf_prog_aux as prog itself is not stable yet and can still
>> change, but aux itself is stable.
> 
> no one will prevent doing container_of() and get bpf_prog itself, so
> it's just an implicit knowledge that bpf_prog might be incomplete yet,
> that has to be remembered (btw, might be good to add a brief comment
> stating that). But I don't feel strongly either way.

Makes sense, expanded the comment to state this.

Thanks,
Daniel
