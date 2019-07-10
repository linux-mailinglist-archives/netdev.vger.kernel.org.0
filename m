Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBA864B90
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 19:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbfGJRj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 13:39:57 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:40320 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727095AbfGJRj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 13:39:57 -0400
Received: by mail-qk1-f196.google.com with SMTP id s145so2556277qke.7;
        Wed, 10 Jul 2019 10:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sRBLPUfKU8/KyORKHXEwE1vwOfzt/c0FHqEYNKoNCps=;
        b=Aecrv8GSAdUeWwE0q0oSwSsVlVmpu28F3OWCFSH8lomD6HNp+RN15xXdQITKicPH77
         SE8dQUj9KlmmITNOEzzzKZ0FoKcHJdQ0+BrYKyCkQZ8vrrub5nipzBF1PaifFRSwZLeZ
         /QR/3xeG4cwJrZ95Mdl036ETRtyeItF+ThsOw9pDBAIrg5EIqvA9N3MWNzyNukwu4ACr
         UY+Cyvagd1oXmfFb2IGQI1MS37OYIF6+M/ijB1lhXyoJCVK+d95HyUI28UrgRIfnugB5
         SS+Mqorh4KZ63owsyn9Hy1PMwn4npsHkDx+P+M9SmL0WdrRBiH6On/nRmcQekxSAhVRk
         Aoog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sRBLPUfKU8/KyORKHXEwE1vwOfzt/c0FHqEYNKoNCps=;
        b=poqMEHC8eYI6QxcSbioSV5NCNueGU8jOJ+eioe8RjqmLV5u2lUmpDuHpzfrfKKcupq
         3T6yvOPJbxX3h0gmECL+Ee8f61Ewh7aynDCFXGt9ftZu2oequOG2kRWllctHnwP3C0+W
         /FAUqBBzB9K+Zw3Zu1XI2gHmpU05i2W+ujz0whMycVLuFiPnlpHcpdf1qsW/FCSA88Yi
         74gZ82EGMvDwyb41dGnxCRfYEcM9Ae+6KL+bTJJPjFagkcaLrATP7+3Rhb7g2JrPuHWE
         WV9FncMYSBsgXm25mohrDShMJweVWsB53WNQ+5DF0E2Ldm0+Y2nc/uGXZEhcSYzVdbIB
         SShw==
X-Gm-Message-State: APjAAAWJ05EMUDCcjYmfLYJtx+BWnQ1pbNreotuWQT5Ql7xyMZTtz9mU
        fkgusx35Lo5/qrDUmTunVOFWj6KrfffXeZwwDC4=
X-Google-Smtp-Source: APXvYqwialyIVK20zf19WwzgJj0i+xPgPzdV3GH64HnN6uFVFxKRp5LBxU6AX7ZxGI8XvFN1DG+a4aLuFccqGy0WPjw=
X-Received: by 2002:a37:660d:: with SMTP id a13mr25203597qkc.36.1562780395543;
 Wed, 10 Jul 2019 10:39:55 -0700 (PDT)
MIME-Version: 1.0
References: <1562275611-31790-1-git-send-email-jiong.wang@netronome.com>
In-Reply-To: <1562275611-31790-1-git-send-email-jiong.wang@netronome.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 10 Jul 2019 10:39:44 -0700
Message-ID: <CAEf4BzavePpW-C+zORN1kwSUJAWuJ3LxZ6QGxqaE9msxCq8ZLA@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/8] bpf: accelerate insn patching speed
To:     Jiong Wang <jiong.wang@netronome.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Edward Cree <ecree@solarflare.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 4, 2019 at 2:31 PM Jiong Wang <jiong.wang@netronome.com> wrote:
>
> This is an RFC based on latest bpf-next about acclerating insn patching
> speed, it is now near the shape of final PATCH set, and we could see the
> changes migrating to list patching would brings, so send out for
> comments. Most of the info are in cover letter. I splitted the code in a
> way to show API migration more easily.


Hey Jiong,


Sorry, took me a while to get to this and learn more about instruction
patching. Overall this looks good and I think is a good direction.
I'll post high-level feedback here, and some more
implementation-specific ones in corresponding patches.


>
> Test Results
> ===
>   - Full pass on test_verifier/test_prog/test_prog_32 under all three
>     modes (interpreter, JIT, JIT with blinding).
>
>   - Benchmarking shows 10 ~ 15x faster on medium sized prog, and reduce
>     patching time from 5100s (nearly one and a half hour) to less than
>     0.5s for 1M insn patching.
>
> Known Issues
> ===
>   - The following warning is triggered when running scale test which
>     contains 1M insns and patching:
>       warning of mm/page_alloc.c:4639 __alloc_pages_nodemask+0x29e/0x330
>
>     This is caused by existing code, it can be reproduced on bpf-next
>     master with jit blinding enabled, then run scale unit test, it will
>     shown up after half an hour. After this set, patching is very fast, so
>     it shows up quickly.
>
>   - No line info adjustment support when doing insn delete, subprog adj
>     is with bug when doing insn delete as well. Generally, removal of insns
>     could possibly cause remove of entire line or subprog, therefore
>     entries of prog->aux->linfo or env->subprog needs to be deleted. I
>     don't have good idea and clean code for integrating this into the
>     linearization code at the moment, will do more experimenting,
>     appreciate ideas and suggestions on this.

Is there any specific problem to detect which line info to delete? Or
what am I missing besides careful implementation?

>
>     Insn delete doesn't happen on normal programs, for example Cilium
>     benchmarks, and happens rarely on test_progs, so the test coverage is
>     not good. That's also why this RFC have a full pass on selftest with
>     this known issue.

I hope you'll add test for deletion (and w/ corresponding line info)
in final patch set :)

>
>   - Could further use mem pool to accelerate the speed, changes are trivial
>     on top of this RFC, and could be 2x extra faster. Not included in this
>     RFC as reducing the algo complexity from quadratic to linear of insn
>     number is the first step.

Honestly, I think that would add more complexity than necessary, and I
think we can further speed up performance without that, see below.

>
> Background
> ===
> This RFC aims to accelerate BPF insn patching speed, patching means expand
> one bpf insn at any offset inside bpf prog into a set of new insns, or
> remove insns.
>
> At the moment, insn patching is quadratic of insn number, this is due to
> branch targets of jump insns needs to be adjusted, and the algo used is:
>
>   for insn inside prog
>     patch insn + regeneate bpf prog
>     for insn inside new prog
>       adjust jump target
>
> This is causing significant time spending when a bpf prog requires large
> amount of patching on different insns. Benchmarking shows it could take
> more than half minutes to finish patching when patching number is more
> than 50K, and the time spent could be more than one hour when patching
> number is around 1M.
>
>   15000   :    3s
>   45000   :   29s
>   95000   :  125s
>   195000  :  712s
>   1000000 : 5100s
>
> This RFC introduces new patching infrastructure. Before doing insn
> patching, insns in bpf prog are turned into a singly linked list, insert
> new insns just insert new list node, delete insns just set delete flag.
> And finally, the list is linearized back into array, and branch target
> adjustment is done for all jump insns during linearization. This algo
> brings the time complexity from quadratic to linear of insn number.
>
> Benchmarking shows the new patching infrastructure could be 10 ~ 15x faster
> on medium sized prog, and for a 1M patching it reduce the time from 5100s
> to less than 0.5s.
>
> Patching API
> ===
> Insn patching could happen on two layers inside BPF. One is "core layer"
> where only BPF insns are patched. The other is "verification layer" where
> insns have corresponding aux info as well high level subprog info, so
> insn patching means aux info needs to be patched as well, and subprog info
> needs to be adjusted. BPF prog also has debug info associated, so line info
> should always be updated after insn patching.
>
> So, list creation, destroy, insert, delete is the same for both layer,
> but lineration is different. "verification layer" patching require extra
> work. Therefore the patch APIs are:
>
>    list creation:                bpf_create_list_insn
>    list patch:                   bpf_patch_list_insn
>    list pre-patch:               bpf_prepatch_list_insn

I think pre-patch name is very confusing, until I read full
description I couldn't understand what it's supposed to be used for.
Speaking of bpf_patch_list_insn, patch is also generic enough to leave
me wondering whether instruction buffer is inserted after instruction,
or instruction is replaced with a bunch of instructions.

So how about two more specific names:
bpf_patch_list_insn -> bpf_list_insn_replace (meaning replace given
instruction with a list of patch instructions)
bpf_prepatch_list_insn -> bpf_list_insn_prepend (well, I think this
one is pretty clear).

>    list lineration (core layer): prog = bpf_linearize_list_insn(prog, list)
>    list lineration (veri layer): env = verifier_linearize_list_insn(env, list)

These two functions are both quite involved, as well as share a lot of
common code. I'd rather have one linearize instruction, that takes env
as an optional parameter. If env is specified (which is the case for
all cases except for constant blinding pass), then adjust aux_data and
subprogs along the way.

This would keep logic less duplicated and shouldn't complexity beyond
few null checks in few places.

>    list destroy:                 bpf_destroy_list_insn
>

I'd also add a macro foreach_list_insn instead of explicit for loops
in multiple places. That would also allow to skip deleted instructions
transparently.

> list patch could change the insn at patch point, it will invalid the aux

typo: invalid -> invalidate

> info at patching point. list pre-patch insert new insns before patch point
> where the insn and associated aux info are not touched, it is used for
> example in convert_ctx_access when generating prologue.
>
> Typical API sequence for one patching pass:
>
>    struct bpf_list_insn list = bpf_create_list_insn(struct bpf_prog);
>    for (elem = list; elem; elem = elem->next)
>       patch_buf = gen_patch_buf_logic;
>       elem = bpf_patch_list_insn(elem, patch_buf, cnt);
>    bpf_prog = bpf_linearize_list_insn(list)
>    bpf_destroy_list_insn(list)
>
> Several patching passes could also share the same list:
>
>    struct bpf_list_insn list = bpf_create_list_insn(struct bpf_prog);
>    for (elem = list; elem; elem = elem->next)
>       patch_buf = gen_patch_buf_logic1;
>       elem = bpf_patch_list_insn(elem, patch_buf, cnt);
>    for (elem = list; elem; elem = elem->next)
>       patch_buf = gen_patch_buf_logic2;
>       elem = bpf_patch_list_insn(elem, patch_buf, cnt);
>    bpf_prog = bpf_linearize_list_insn(list)
>    bpf_destroy_list_insn(list)
>
> but note new inserted insns int early passes won't have aux info except
> zext info. So, if one patch pass requires all aux info updated and
> recalculated for all insns including those pathced, it should first
> linearize the old list, then re-create the list. The RFC always create and
> linearize the list for each migrated patching pass separately.

I think we should do just one list creation, few passes of patching
and then linearize once. That will save quite a lot of memory
allocation and will speed up a lot of things. All the verifier
patching happens one after the other without any other functionality
in between, so there shouldn't be any problem.

As for aux_data. We can solve that even more simply and reliably by
storing a pointer along the struct bpf_list_insn (btw, how about
calling it bpf_patchable_insn?).

Here's how I propose to represent this patchable instruction:

struct bpf_list_insn {
       struct bpf_insn insn;
       struct bpf_list_insn *next;
       struct bpf_list_insn *target;
       struct bpf_insn_aux_data *aux_data;
       s32 orig_idx; // can repurpose this to have three meanings:
                     // -2 - deleted
                     // -1 - patched/inserted insn
                     // >=0 - original idx
};

The idea would be as follows:
1. when creating original list, target pointer will point directly to
a patchable instruction wrapper for jumps/calls. This will allow to
stop tracking and re-calculating jump offsets and instruction indicies
until linearization.
2. aux_data is also filled at that point. Later at linearization time
you'd just iterate over all the instructions in final order and copy
original aux_data, if it's present. And then just repace env's
aux_data array at the end, should be very simple and fast.
3. during fix_bpf_calls, zext, ctx rewrite passes, we'll reuse the
same list of instructions and those passes will just keep inserting
instruction buffers. Given we have restriction that all the jumps are
only within patch buffer, it will be trivial to construct proper
patchable instruction wrappers for newly added instructions, with NULL
for aux_data and possibly non-NULL target (if it's a JMP insn).
4. After those passes, linearize, adjust subprogs (for this you'll
probably still need to create index mapping, right?), copy or create
new aux_data.
5. Done.

What do you think? I think this should be overall simpler and faster.
But let me know if I'm missing something.

>
> Compared with old patching code, this new infrastructure has much less core
> code, even though the final code has a couple of extra lines but that is
> mostly due to for list based infrastructure, we need to do more error
> checks, so the list and associated aux data structure could be freed when
> errors happens.
>
> Patching Restrictions
> ===
>   - For core layer, the linearization assume no new jumps inside patch buf.
>     Currently, the only user of this layer is jit blinding.
>   - For verifier layer, there could be new jumps inside patch buf, but
>     they should have branch target resolved themselves, meaning new jumps
>     doesn't jump to insns out of the patch buf. This is the case for all
>     existing verifier layer users.
>   - bpf_insn_aux_data for all patched insns including the one at patch
>     point are invalidated, only 32-bit zext info will be recalcuated.
>     If the aux data of insn at patch point needs to be retained, it is
>     purely insn insertion, so need to use the pre-patch API.
>
> I plan to send out a PATCH set once I finished insn deletion line info adj
> support, please have a looks at this RFC, and appreciate feedbacks.
>
> Jiong Wang (8):
>   bpf: introducing list based insn patching infra to core layer
>   bpf: extend list based insn patching infra to verification layer
>   bpf: migrate jit blinding to list patching infra
>   bpf: migrate convert_ctx_accesses to list patching infra
>   bpf: migrate fixup_bpf_calls to list patching infra
>   bpf: migrate zero extension opt to list patching infra
>   bpf: migrate insn remove to list patching infra
>   bpf: delete all those code around old insn patching infrastructure
>
>  include/linux/bpf_verifier.h |   1 -
>  include/linux/filter.h       |  27 +-
>  kernel/bpf/core.c            | 431 +++++++++++++++++-----------
>  kernel/bpf/verifier.c        | 649 +++++++++++++++++++------------------------
>  4 files changed, 580 insertions(+), 528 deletions(-)
>
> --
> 2.7.4
>
