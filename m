Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89612100E2E
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 22:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbfKRVpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 16:45:31 -0500
Received: from www62.your-server.de ([213.133.104.62]:55416 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbfKRVpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 16:45:31 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iWops-0000jK-6A; Mon, 18 Nov 2019 22:45:28 +0100
Received: from [178.197.248.45] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iWopr-000CvC-Sz; Mon, 18 Nov 2019 22:45:27 +0100
Subject: Re: [PATCH rfc bpf-next 8/8] bpf: constant map key tracking for prog
 array pokes
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <cover.1573779287.git.daniel@iogearbox.net>
 <fa3c2f6e2f4fbe45200d54a3c6d4c65c4f84f790.1573779287.git.daniel@iogearbox.net>
 <CAEf4BzZJEgVKVZsBvHZuhQWBTN6G7zY9mQH8o5xoyrDEUNG2DA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ebe7fe42-d2e4-bb47-e9a0-09a914d25473@iogearbox.net>
Date:   Mon, 18 Nov 2019 22:45:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZJEgVKVZsBvHZuhQWBTN6G7zY9mQH8o5xoyrDEUNG2DA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25637/Mon Nov 18 10:53:23 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/19 7:11 PM, Andrii Nakryiko wrote:
> On Thu, Nov 14, 2019 at 5:04 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>
>> Add tracking of constant keys into tail call maps. The signature of
>> bpf_tail_call_proto is that arg1 is ctx, arg2 map pointer and arg3
>> is a index key. The direct call approach for tail calls can be enabled
>> if the verifier asserted that for all branches leading to the tail call
>> helper invocation, the map pointer and index key were both constant
>> and the same. Tracking of map pointers we already do from prior work
>> via c93552c443eb ("bpf: properly enforce index mask to prevent out-of-bounds
>> speculation") and 09772d92cd5a ("bpf: avoid retpoline for lookup/update/
>> delete calls on maps"). Given the tail call map index key is not on
>> stack but directly in the register, we can add similar tracking approach
>> and later in fixup_bpf_calls() add a poke descriptor to the progs poke_tab
>> with the relevant information for the JITing phase. We internally reuse
>> insn->imm for the rewritten BPF_JMP | BPF_TAIL_CALL instruction in order
>> to point into the prog's poke_tab and keep insn->imm == 0 as indicator
>> that current indirect tail call emission must be used.
>>
>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>> ---
>>   include/linux/bpf_verifier.h |  1 +
>>   kernel/bpf/verifier.c        | 98 ++++++++++++++++++++++++++++++++++++
>>   2 files changed, 99 insertions(+)
>>
>> diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
>> index cdd08bf0ec06..f494f0c9ac13 100644
>> --- a/include/linux/bpf_verifier.h
>> +++ b/include/linux/bpf_verifier.h
>> @@ -301,6 +301,7 @@ struct bpf_insn_aux_data {
>>                          u32 map_off;            /* offset from value base address */
>>                  };
>>          };
>> +       u64 key_state; /* constant key tracking for maps */
>>          int ctx_field_size; /* the ctx field size for load insn, maybe 0 */
>>          int sanitize_stack_off; /* stack slot to be cleared */
>>          bool seen; /* this insn was processed by the verifier */
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index e9dc95a18d44..48d5c9030d60 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -171,6 +171,9 @@ struct bpf_verifier_stack_elem {
>>   #define BPF_COMPLEXITY_LIMIT_JMP_SEQ   8192
>>   #define BPF_COMPLEXITY_LIMIT_STATES    64
>>
>> +#define BPF_MAP_KEY_POISON     (1ULL << 63)
>> +#define BPF_MAP_KEY_SEEN       (1ULL << 62)
>> +
>>   #define BPF_MAP_PTR_UNPRIV     1UL
>>   #define BPF_MAP_PTR_POISON     ((void *)((0xeB9FUL << 1) +     \
>>                                            POISON_POINTER_DELTA))
>> @@ -195,6 +198,29 @@ static void bpf_map_ptr_store(struct bpf_insn_aux_data *aux,
>>                           (unpriv ? BPF_MAP_PTR_UNPRIV : 0UL);
>>   }
>>
>> +static bool bpf_map_key_poisoned(const struct bpf_insn_aux_data *aux)
>> +{
>> +       return aux->key_state & BPF_MAP_KEY_POISON;
>> +}
>> +
>> +static bool bpf_map_key_unseen(const struct bpf_insn_aux_data *aux)
>> +{
>> +       return !(aux->key_state & BPF_MAP_KEY_SEEN);
>> +}
>> +
>> +static u64 bpf_map_key_immediate(const struct bpf_insn_aux_data *aux)
>> +{
>> +       return aux->key_state & ~BPF_MAP_KEY_SEEN;
>> +}
> 
> This works out for current logic you've implemented, but it's a bit
> misleading that bpf_map_key_immediate is also going to return POISON
> bit, was this intentional?

Had it intentional, but fair enough, I'll mask it out to make it more clear.

>> +static void bpf_map_key_store(struct bpf_insn_aux_data *aux, u64 state)
>> +{
>> +       bool poisoned = bpf_map_key_poisoned(aux);
>> +
>> +       aux->key_state = state | BPF_MAP_KEY_SEEN |
>> +                        (poisoned ? BPF_MAP_KEY_POISON : 0ULL);
>> +}
>> +
>>   struct bpf_call_arg_meta {
>>          struct bpf_map *map_ptr;
>>          bool raw_mode;
>> @@ -4088,6 +4114,37 @@ record_func_map(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
>>          return 0;
>>   }
>>
>> +static int
>> +record_func_key(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
>> +               int func_id, int insn_idx)
>> +{
>> +       struct bpf_insn_aux_data *aux = &env->insn_aux_data[insn_idx];
>> +       struct bpf_reg_state *regs = cur_regs(env), *reg;
>> +       struct tnum range = tnum_range(0, U32_MAX);
> 
> why U32_MAX, instead of actual size of a map?

Hm, good point. That works given we poison that value and then skip later when
add add the poke entry.

>> +       struct bpf_map *map = meta->map_ptr;
>> +       u64 val;
>> +
>> +       if (func_id != BPF_FUNC_tail_call)
>> +               return 0;
>> +       if (!map || map->map_type != BPF_MAP_TYPE_PROG_ARRAY) {
>> +               verbose(env, "kernel subsystem misconfigured verifier\n");
>> +               return -EINVAL;
>> +       }
>> +
>> +       reg = &regs[BPF_REG_3];
>> +       if (!register_is_const(reg) || !tnum_in(range, reg->var_off)) {
>> +               bpf_map_key_store(aux, BPF_MAP_KEY_POISON);
>> +               return 0;
>> +       }
>> +
>> +       val = reg->var_off.value;
>> +       if (bpf_map_key_unseen(aux))
>> +               bpf_map_key_store(aux, val);
>> +       else if (bpf_map_key_immediate(aux) != val)
>> +               bpf_map_key_store(aux, BPF_MAP_KEY_POISON);
> 
> imo, checking for poison first would make this logic a bit more
> straightforward (and will avoid unnecessary key_store calls, but
> that's minor)

Makes sense.

>> +       return 0;
>> +}
>> +
>>   static int check_reference_leak(struct bpf_verifier_env *env)
>>   {
>>          struct bpf_func_state *state = cur_func(env);
> 
> [...]

Thanks,
Daniel
