Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E99FC46550
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 19:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbfFNRGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 13:06:02 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42853 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbfFNRGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 13:06:02 -0400
Received: by mail-lj1-f196.google.com with SMTP id t28so3101292lje.9;
        Fri, 14 Jun 2019 10:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yUyWgMcF8YtqLLCB/ssmwJMUkK3COGkr3CAkr8Pd3Qs=;
        b=dA3LeS1ezaJ1F1vwaadjQb9osOlxuLnDyjStmvQdrgvQrLp/OVBz0khyBBhGDd96J8
         pOhDIi4zPFFyWXmAkgs++KXuEQIDcj9uCMPNW+7MfUAIWsZpgFFw0hHu+6upx1merAJX
         s5+k8IS8MKoyRRduFogPqCueXQ2dg2K+900x1wklHNTgTdjY5hjlOx1oepSxwjBookyy
         FsxnkBNVe7p1qI3b7CKxyv4JN45XTUEYCpuNyOqeF1VK6+G5Jhcr1gM/49dXfDiEblCN
         Kwdxvyzi166El4AsCzVkAw6q04spDggjU253Vr2Rfr8LSf6zE7TAMqzinlV+f6BRXAGT
         0Tsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yUyWgMcF8YtqLLCB/ssmwJMUkK3COGkr3CAkr8Pd3Qs=;
        b=E1lmaDWxRbAlXL/1XDgVojyYptUX7mgDa+BYelAziyhAEsH3l7RuiBz/Gg67T3fNHb
         KZss1CIRAo/yLNlAeykqKCLZ90/JVgr+4PTs2iDBGvsKSy23UlhpbjOTgiBNzkW4vBUH
         dqqXe+kfGpqAIdpnt7Za7+eAYl2elD/PF9U57qkLnRZ7+cKxSW6XQfPuPqpAXxzURfGn
         eXdd4NTXZtdG2WUbylOyxaZNLe++rvFu8AZtSixmrzTBV6ZZS0H6esGu0et6I0eUs9Fp
         f41T+Ok3kVFtQrxYiItPTnoWGXEcRptf5XD9iFaZ0ULy+RbeFdqCODStIYsTCBTaPpWA
         OpOw==
X-Gm-Message-State: APjAAAX3j2PuvacHSOKSWYPtZpJFXYN1vV7edA2FfbuW8Ig7pcCVZL2G
        kTSQCnvjlhQ/B69LtMdhFpk8640jN2r8q6TrBRY=
X-Google-Smtp-Source: APXvYqwKdybAT4jHrPCu6+NoLD+MEDKQbRqUSolbhlNXvlDzQPFNIphIVPS5jQf/wuDND57EHSkU0pOel/p/+sGRJ0U=
X-Received: by 2002:a2e:86d1:: with SMTP id n17mr28518814ljj.58.1560531960033;
 Fri, 14 Jun 2019 10:06:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190612113208.21865-1-naveen.n.rao@linux.vnet.ibm.com>
 <CAADnVQLp+N8pYTgmgEGfoubqKrWrnuTBJ9z2qc1rB6+04WfgHA@mail.gmail.com>
 <87sgse26av.fsf@netronome.com> <87r27y25c3.fsf@netronome.com>
 <CAADnVQJZkJu60jy8QoomVssC=z3NE4402bMnfobaWNE_ANC6sg@mail.gmail.com> <87ef3w5hew.fsf@netronome.com>
In-Reply-To: <87ef3w5hew.fsf@netronome.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 14 Jun 2019 10:05:48 -0700
Message-ID: <CAADnVQJybVNQofzROiXe1np+zNY3eBduNgFZdquSCdTeckof-g@mail.gmail.com>
Subject: Re: [PATCH] bpf: optimize constant blinding
To:     Jiong Wang <jiong.wang@netronome.com>
Cc:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 8:13 AM Jiong Wang <jiong.wang@netronome.com> wrote:
>
>
> Alexei Starovoitov writes:
>
> > On Wed, Jun 12, 2019 at 8:25 AM Jiong Wang <jiong.wang@netronome.com> wrote:
> >>
> >>
> >> Jiong Wang writes:
> >>
> >> > Alexei Starovoitov writes:
> >> >
> >> >> On Wed, Jun 12, 2019 at 4:32 AM Naveen N. Rao
> >> >> <naveen.n.rao@linux.vnet.ibm.com> wrote:
> >> >>>
> >> >>> Currently, for constant blinding, we re-allocate the bpf program to
> >> >>> account for its new size and adjust all branches to accommodate the
> >> >>> same, for each BPF instruction that needs constant blinding. This is
> >> >>> inefficient and can lead to soft lockup with sufficiently large
> >> >>> programs, such as the new verifier scalability test (ld_dw: xor
> >> >>> semi-random 64 bit imms, test 5 -- with net.core.bpf_jit_harden=2)
> >> >>
> >> >> Slowdown you see is due to patch_insn right?
> >> >> In such case I prefer to fix the scaling issue of patch_insn instead.
> >> >> This specific fix for blinding only is not addressing the core of the problem.
> >> >> Jiong,
> >> >> how is the progress on fixing patch_insn?
> >>
> >> And what I have done is I have digested your conversion with Edward, and is
> >> slightly incline to the BB based approach as it also exposes the inserted
> >> insn to later pass in a natural way, then was trying to find a way that
> >> could create BB info in little extra code based on current verifier code,
> >> for example as a side effect of check_subprogs which is doing two insn
> >> traversal already. (I had some such code before in the historical
> >> wip/bpf-loop-detection branch, but feel it might be still too heavy for
> >> just improving insn patching)
> >
> > BB - basic block?
> > I'm not sure that was necessary.
> > The idea was that patching is adding stuff to linked list instead
> > and single pass at the end to linearize it.
>
> Just an update and keep people posted.
>
> Working on linked list based approach, the implementation looks like the
> following, mostly a combine of discussions happened and Naveen's patch,
> please feel free to comment.
>
>   - Use the reserved opcode 0xf0 with BPF_ALU as new pseudo insn code
>     BPF_LIST_INSN. (0xf0 is also used with BPF_JMP class for tail call).
>
>   - Introduce patch pool into bpf_prog->aux to keep all patched insns.
>     Pool structure looks like:
>
>     struct {
>       int num;
>       int prev;
>       int next;
>     } head_0;
>     NUM patched insns for head_0
>     head_1;
>     patched insns for head_1
>     head_2;
>     ...
>
>   - Now when doing bpf_patch_insn_single, it doesn't change the original
>     prog etc, instead, it merely update the insn at patched offset into a
>     BPF_LIST_INSN, and pushed the patched insns plus a patch header into
>     the patch pool. Fields of BPF_LIST_INSN is updated to setup the links:
>
>       BPF_LIST_INSN.off += patched_size
>       (accumulating the size attached to this list_insn, it is possible a
>       later patch pass patches insn in the patch pool, this means insn
>       traversal needs to be changed, when seeing BPF_LIST_INSN, should go
>       through the list)
>
>       BPF_LIST_INSN.imm = offset of the patch header in patch pool
>       (off is 16-bit, imm is 32-bit, the patch pool is 32-bit length, so
>       use imm for keeping offset, meaning a BPF_LIST_INSN can contains no
>       more than 8192 insns, guess it is enough)
>
>   - When doing linearize:
>     1. a quick scan of prog->insnsi to know the final
>        image size, would be simple as:
>
>       fini_size = 0;
>       for_each_insn:
>         if (insn.code == (BPF_ALU | BPF_LIST_HEAD))
>           fini_size += insn->off;
>         else
>           fini_size++;
>
>     2. Resize prog into fini_size, and a second scan of prog->insnsi to
>        copy over all insns and patched insns, at the same time generate a
>        auxiliary index array which maps an old index to the new index in
>        final image, like the "clone_index" in Naveen's patch.
>
>     3. Finally, a single pass to update branch target, the same algo used
>        by this patch.
>
>   - The APIs for doing insning patch looks like:
>       bpf_patch_insn_init:   init the generic patch pool.
>       bpf_patch_insn_single: push patched insns to the pool.
>                              link them to the associated BPF_LIST_INSN.
>       bpf_patch_insn_fini:   linearize a bpf_prog contains BPF_LIST_INSN.
>                              destroy patch pool in prog->aux.
>
> I am trying to making the implementation working with jit blind first to make
> sure basic things are ready. As JIT blinds happens after verification so no
> need to both aux update etc. Then will cleanup quite a few things for
> example patch a patched insn, adjust aux data, what to do with insn delete
> etc.

explicit indices feels like premature optimization.
May be use vanilla singly linked list instead?
Also do we have a case when patched insn will be patched again?
In such case 'patch insn pool' will become recursive?
Feels difficult to think through all offsets and indices.
Whereas with linked list patching patched insns will be inserting
them into link list.

May be better alternative is to convert the whole program to link list
of insns with branch targets becoming pointers and insert patched
insns into this single singly linked list ?
