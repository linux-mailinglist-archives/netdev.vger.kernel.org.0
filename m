Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD32107B48
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 00:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfKVXZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 18:25:43 -0500
Received: from www62.your-server.de ([213.133.104.62]:46902 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfKVXZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 18:25:43 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iYIJ0-0003O2-Ah; Sat, 23 Nov 2019 00:25:38 +0100
Received: from [178.197.248.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iYIJ0-000D0V-1G; Sat, 23 Nov 2019 00:25:38 +0100
Subject: Re: [PATCH bpf-next v2 7/8] bpf, x86: emit patchable direct jump as
 tail call
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <cover.1574452833.git.daniel@iogearbox.net>
 <6ada4c1c9d35eeb5f4ecfab94593dafa6b5c4b09.1574452833.git.daniel@iogearbox.net>
 <CAEf4BzaWhYJAdjs+8-nHHjuKfs6yBB7yx5NH-qNv2tcjiVCVhw@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ba52688c-49bf-7897-4ba2-f62f30d501a9@iogearbox.net>
Date:   Sat, 23 Nov 2019 00:25:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzaWhYJAdjs+8-nHHjuKfs6yBB7yx5NH-qNv2tcjiVCVhw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25641/Fri Nov 22 11:06:48 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/23/19 12:09 AM, Andrii Nakryiko wrote:
> On Fri, Nov 22, 2019 at 12:08 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>
>> Add initial code emission for *direct* jumps for tail call maps in
>> order to avoid the retpoline overhead from a493a87f38cf ("bpf, x64:
>> implement retpoline for tail call") for situations that allow for
>> it, meaning, for known constant keys at verification time which are
>> used as index into the tail call map. In case of Cilium which makes
>> heavy use of tail calls, constant keys are used in the vast majority,
>> only for a single occurrence we use a dynamic key.
>>
>> High level outline is that if the target prog is NULL in the map, we
>> emit a 5-byte nop for the fall-through case and if not, we emit a
>> 5-byte direct relative jmp to the target bpf_func + skipped prologue
>> offset. Later during runtime, we patch these 5-byte nop/jmps upon
>> tail call map update or deletions dynamically. Note that on x86-64
>> the direct jmp works as we reuse the same stack frame and skip
>> prologue (as opposed to some other JIT implementations).
>>
>> One of the issues is that the tail call map slots can change at any
>> given time even during JITing. Therefore, we have two passes: i) emit
>> nops for all patchable locations during main JITing phase until we
>> declare prog->jited = 1 eventually. At this point the image is stable,
>> not public yet and with all jmps disabled. While JITing, we collect
>> additional info like poke->ip in order to remember the patch location
>> for later modifications. In ii) bpf_tail_call_direct_fixup() walks
>> over the progs poke_tab, locks the tail call maps poke_mutex to
>> prevent from parallel updates and patches in the right locations via
>> __bpf_arch_text_poke(). Note, the main bpf_arch_text_poke() cannot
>> be used at this point since we're not yet exposed to kallsyms. For
>> the update we use plain memcpy() since the image is not public and
>> still in read-write mode. After patching, we activate that poke entry
>> through poke->ip_stable. Meaning, at this point any tail call map
>> updates/deletions are not going to ignore that poke entry anymore.
>> Then, bpf_arch_text_poke() might still occur on the read-write image
>> until we finally locked it as read-only. Both modifications on the
>> given image are under text_mutex to avoid interference with each
>> other when update requests come in in parallel for different tail
>> call maps (current one we have locked in JIT and different one where
>> poke->ip_stable was already set).
>>
>> Example prog:
>>
>>    # ./bpftool p d x i 1655
>>     0: (b7) r3 = 0
>>     1: (18) r2 = map[id:526]
>>     3: (85) call bpf_tail_call#12
>>     4: (b7) r0 = 1
>>     5: (95) exit
>>
>> Before:
>>
>>    # ./bpftool p d j i 1655
>>    0xffffffffc076e55c:
>>     0:   nopl   0x0(%rax,%rax,1)
>>     5:   push   %rbp
>>     6:   mov    %rsp,%rbp
>>     9:   sub    $0x200,%rsp
>>    10:   push   %rbx
>>    11:   push   %r13
>>    13:   push   %r14
>>    15:   push   %r15
>>    17:   pushq  $0x0                      _
>>    19:   xor    %edx,%edx                |_ index (arg 3)
>>    1b:   movabs $0xffff88d95cc82600,%rsi |_ map (arg 2)
>>    25:   mov    %edx,%edx                |  index >= array->map.max_entries
>>    27:   cmp    %edx,0x24(%rsi)          |
>>    2a:   jbe    0x0000000000000066       |_
>>    2c:   mov    -0x224(%rbp),%eax        |  tail call limit check
>>    32:   cmp    $0x20,%eax               |
>>    35:   ja     0x0000000000000066       |
>>    37:   add    $0x1,%eax                |
>>    3a:   mov    %eax,-0x224(%rbp)        |_
>>    40:   mov    0xd0(%rsi,%rdx,8),%rax   |_ prog = array->ptrs[index]
>>    48:   test   %rax,%rax                |  prog == NULL check
>>    4b:   je     0x0000000000000066       |_
>>    4d:   mov    0x30(%rax),%rax          |  goto *(prog->bpf_func + prologue_size)
>>    51:   add    $0x19,%rax               |
>>    55:   callq  0x0000000000000061       |  retpoline for indirect jump
>>    5a:   pause                           |
>>    5c:   lfence                          |
>>    5f:   jmp    0x000000000000005a       |
>>    61:   mov    %rax,(%rsp)              |
>>    65:   retq                            |_
>>    66:   mov    $0x1,%eax
>>    6b:   pop    %rbx
>>    6c:   pop    %r15
>>    6e:   pop    %r14
>>    70:   pop    %r13
>>    72:   pop    %rbx
>>    73:   leaveq
>>    74:   retq
>>
>> After; state after JIT:
>>
>>    # ./bpftool p d j i 1655
>>    0xffffffffc08e8930:
>>     0:   nopl   0x0(%rax,%rax,1)
>>     5:   push   %rbp
>>     6:   mov    %rsp,%rbp
>>     9:   sub    $0x200,%rsp
>>    10:   push   %rbx
>>    11:   push   %r13
>>    13:   push   %r14
>>    15:   push   %r15
>>    17:   pushq  $0x0                      _
>>    19:   xor    %edx,%edx                |_ index (arg 3)
>>    1b:   movabs $0xffff9d8afd74c000,%rsi |_ map (arg 2)
>>    25:   mov    -0x224(%rbp),%eax        |  tail call limit check
>>    2b:   cmp    $0x20,%eax               |
>>    2e:   ja     0x000000000000003e       |
>>    30:   add    $0x1,%eax                |
>>    33:   mov    %eax,-0x224(%rbp)        |_
>>    39:   jmpq   0xfffffffffffd1785       |_ [direct] goto *(prog->bpf_func + prologue_size)
>>    3e:   mov    $0x1,%eax
>>    43:   pop    %rbx
>>    44:   pop    %r15
>>    46:   pop    %r14
>>    48:   pop    %r13
>>    4a:   pop    %rbx
>>    4b:   leaveq
>>    4c:   retq
>>
>> After; state after map update (target prog):
>>
>>    # ./bpftool p d j i 1655
>>    0xffffffffc08e8930:
>>     0:   nopl   0x0(%rax,%rax,1)
>>     5:   push   %rbp
>>     6:   mov    %rsp,%rbp
>>     9:   sub    $0x200,%rsp
>>    10:   push   %rbx
>>    11:   push   %r13
>>    13:   push   %r14
>>    15:   push   %r15
>>    17:   pushq  $0x0
>>    19:   xor    %edx,%edx
>>    1b:   movabs $0xffff9d8afd74c000,%rsi
>>    25:   mov    -0x224(%rbp),%eax
>>    2b:   cmp    $0x20,%eax               .
>>    2e:   ja     0x000000000000003e       .
>>    30:   add    $0x1,%eax                .
>>    33:   mov    %eax,-0x224(%rbp)        |_
>>    39:   jmpq   0xffffffffffb09f55       |_ goto *(prog->bpf_func + prologue_size)
>>    3e:   mov    $0x1,%eax
>>    43:   pop    %rbx
>>    44:   pop    %r15
>>    46:   pop    %r14
>>    48:   pop    %r13
>>    4a:   pop    %rbx
>>    4b:   leaveq
>>    4c:   retq
>>
>> After; state after map update (no prog):
>>
>>    # ./bpftool p d j i 1655
>>    0xffffffffc08e8930:
>>     0:   nopl   0x0(%rax,%rax,1)
>>     5:   push   %rbp
>>     6:   mov    %rsp,%rbp
>>     9:   sub    $0x200,%rsp
>>    10:   push   %rbx
>>    11:   push   %r13
>>    13:   push   %r14
>>    15:   push   %r15
>>    17:   pushq  $0x0
>>    19:   xor    %edx,%edx
>>    1b:   movabs $0xffff9d8afd74c000,%rsi
>>    25:   mov    -0x224(%rbp),%eax
>>    2b:   cmp    $0x20,%eax               .
>>    2e:   ja     0x000000000000003e       .
>>    30:   add    $0x1,%eax                .
>>    33:   mov    %eax,-0x224(%rbp)        |_
>>    39:   nopl   0x0(%rax,%rax,1)         |_ fall-through nop
>>    3e:   mov    $0x1,%eax
>>    43:   pop    %rbx
>>    44:   pop    %r15
>>    46:   pop    %r14
>>    48:   pop    %r13
>>    4a:   pop    %rbx
>>    4b:   leaveq
>>    4c:   retq
>>
>> Nice bonus is that this also shrinks the code emission quite a bit
>> for every tail call invocation.
>>
>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>> ---
>>   arch/x86/net/bpf_jit_comp.c | 282 ++++++++++++++++++++++++------------
>>   1 file changed, 187 insertions(+), 95 deletions(-)
>>
> 
> [...]
> 
>> +static int __bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
>> +                               void *old_addr, void *new_addr,
>> +                               const bool text_live)
>> +{
>> +       int (*emit_patch_fn)(u8 **pprog, void *func, void *ip);
>> +       const u8 *nop_insn = ideal_nops[NOP_ATOMIC5];
>> +       u8 old_insn[X86_PATCH_SIZE] = {};
>> +       u8 new_insn[X86_PATCH_SIZE] = {};
>> +       u8 *prog;
>> +       int ret;
>> +
>> +       switch (t) {
>> +       case BPF_MOD_NOP_TO_CALL ... BPF_MOD_CALL_TO_NOP:
>> +               emit_patch_fn = emit_call;
>> +               break;
>> +       case BPF_MOD_NOP_TO_JUMP ... BPF_MOD_JUMP_TO_NOP:
>> +               emit_patch_fn = emit_jump;
>> +               break;
>> +       default:
>> +               return -ENOTSUPP;
>> +       }
>> +
>> +       switch (t) {
>> +       case BPF_MOD_NOP_TO_CALL:
>> +       case BPF_MOD_NOP_TO_JUMP:
>> +               if (!old_addr && new_addr) {
>> +                       memcpy(old_insn, nop_insn, X86_PATCH_SIZE);
>> +
>> +                       prog = new_insn;
>> +                       ret = emit_patch_fn(&prog, new_addr, ip);
>> +                       if (ret)
>> +                               return ret;
>> +                       break;
>> +               }
>> +               return -ENXIO;
>> +       case BPF_MOD_CALL_TO_CALL:
>> +       case BPF_MOD_JUMP_TO_JUMP:
>> +               if (old_addr && new_addr) {
>> +                       prog = old_insn;
>> +                       ret = emit_patch_fn(&prog, old_addr, ip);
>> +                       if (ret)
>> +                               return ret;
>> +
>> +                       prog = new_insn;
>> +                       ret = emit_patch_fn(&prog, new_addr, ip);
>> +                       if (ret)
>> +                               return ret;
>> +                       break;
>> +               }
>> +               return -ENXIO;
>> +       case BPF_MOD_CALL_TO_NOP:
>> +       case BPF_MOD_JUMP_TO_NOP:
>> +               if (old_addr && !new_addr) {
>> +                       memcpy(new_insn, nop_insn, X86_PATCH_SIZE);
>> +
>> +                       prog = old_insn;
>> +                       ret = emit_patch_fn(&prog, old_addr, ip);
>> +                       if (ret)
>> +                               return ret;
>> +                       break;
>> +               }
>> +               return -ENXIO;
>> +       default:
> 
> There is this redundancy between BPF_MOD_xxx enums and
> old_addr+new_addr (both encode what kind of transition it is), which
> leads to this cumbersome logic. Would it be simpler to have
> old_addr/new_addr determine whether it's X-to-NOP, NOP-to-Y, or X-to-Y
> transition, while separate bool or simple BPF_MOD_CALL/BPF_MOD_JUMP
> enum determining whether it's a call or a jump that we want to update.
> Seems like that should be a simpler interface overall and cleaner
> implementation?

Right we can probably simplify it further, I kept preserving the original
switch from Alexei's code where my assumption was that having the transition
explicitly spelled out was preferred in here and then based on that doing
the sanity checks to make sure we don't get bad input from any call-site
since we're modifying kernel text, e.g. in the bpf_trampoline_update() as
one example the BPF_MOD_* is a fixed constant input there.

>> +               return -ENOTSUPP;
>> +       }
>> +
>> +       ret = -EBUSY;
>> +       mutex_lock(&text_mutex);
>> +       if (memcmp(ip, old_insn, X86_PATCH_SIZE))
>> +               goto out;
>> +       if (text_live)
>> +               text_poke_bp(ip, new_insn, X86_PATCH_SIZE, NULL);
>> +       else
>> +               memcpy(ip, new_insn, X86_PATCH_SIZE);
>> +       ret = 0;
>> +out:
>> +       mutex_unlock(&text_mutex);
>> +       return ret;
>> +}
>> +
> 
> [...]
> 

