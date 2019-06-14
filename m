Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC52046C51
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 00:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbfFNW2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 18:28:42 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36801 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbfFNW2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 18:28:42 -0400
Received: by mail-qt1-f196.google.com with SMTP id p15so4345150qtl.3;
        Fri, 14 Jun 2019 15:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LspWOEFgqjQy/K7fxFxEzS+zsZJJ8OBl2jPUqCFmr8A=;
        b=eZO9xXfmxwDKETkbxsjYtJ4R40aS8qTE6+1ZKGUvkOX3hSp4ma2nuPHTYwM+c+q8nB
         XHJYl9jLpzjOsiJ+WVShD3HvfeYrTdUwLn27kupVb9UQ7QrZI7Rs4fJVW7m2omNuLNFX
         Q2QLXCxVzN+RZFTqDdDTT28+hyID0rkM8HPcqMiRZ3Q6Fd+iJlCm7SVNf00d0AK8o25q
         ReAVbwcmYydkk32kaInMydxj/NcNjYXVik7Wud9osSsFXMe/RsO3EcM0fjyTM78w/6Q7
         VMCz+yImP7Q1aue0ZrIMCR1fegQZnWqjrvCwRAy6nbmUzrgwMqhs43DIZ5XhgX51xsOB
         lI3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LspWOEFgqjQy/K7fxFxEzS+zsZJJ8OBl2jPUqCFmr8A=;
        b=t/U1nSY99x7qEp9lT/L+IaAqCoTSR3MzDIIScTNgODJUGIdxyRdZ7XRTLYKxTkvtTM
         CkagzsfDDuvx3hJ+s4NaHc8EeMrNRnB6Yjam8K88N8/wNUPJItD8B4PB/FZkLnZqYg2T
         x8G3MFISAkXBVoVbCMrgHSp9tlHa5xP65/jb+i/rUi74+dp8t5NrU7dXZgTR/x9yU/ZQ
         TGt6z96/6P7SGvN2pSApXKDIMcXlzCVujwOy1G92v0o6aEBOjZW2WEBXKqtx3cQ0M6dU
         mzyk+0zSU3yhDoXDZsi5FMB4t/NBgKgrTYNhFT1OdLxM6m9dF41zcO3iaKOxIoIgPPjV
         Ydfw==
X-Gm-Message-State: APjAAAV/L27o3kEYAbgodmiPji9rB2fbb5r4LGJo3IPS+npslLkR2dET
        9VM9J5iOijF7gyuNNlUDl8/BXH3lQgAiF72d+XI=
X-Google-Smtp-Source: APXvYqxjRKdKvt1fJ1EIIz66gVB0Ko5jWrSApcot4CAYlHF0AGgjVmYT2Wfzf1pAyKOki2GWAJOLOO6+DTcSzYlCXCI=
X-Received: by 2002:ac8:2fb7:: with SMTP id l52mr59214503qta.93.1560551320907;
 Fri, 14 Jun 2019 15:28:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190612113208.21865-1-naveen.n.rao@linux.vnet.ibm.com>
 <CAADnVQLp+N8pYTgmgEGfoubqKrWrnuTBJ9z2qc1rB6+04WfgHA@mail.gmail.com>
 <87sgse26av.fsf@netronome.com> <87r27y25c3.fsf@netronome.com>
 <CAADnVQJZkJu60jy8QoomVssC=z3NE4402bMnfobaWNE_ANC6sg@mail.gmail.com>
 <87ef3w5hew.fsf@netronome.com> <CAADnVQJybVNQofzROiXe1np+zNY3eBduNgFZdquSCdTeckof-g@mail.gmail.com>
In-Reply-To: <CAADnVQJybVNQofzROiXe1np+zNY3eBduNgFZdquSCdTeckof-g@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 14 Jun 2019 15:28:29 -0700
Message-ID: <CAEf4BzaGLJo2y2vUSQaCB7DZtVP3Q89TzbXO0UFvQvUw+Q2kng@mail.gmail.com>
Subject: Re: [PATCH] bpf: optimize constant blinding
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiong Wang <jiong.wang@netronome.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
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

On Fri, Jun 14, 2019 at 10:06 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Jun 14, 2019 at 8:13 AM Jiong Wang <jiong.wang@netronome.com> wrote:
> >
> >
> > Alexei Starovoitov writes:
> >
> > > On Wed, Jun 12, 2019 at 8:25 AM Jiong Wang <jiong.wang@netronome.com> wrote:
> > >>
> > >>
> > >> Jiong Wang writes:
> > >>
> > >> > Alexei Starovoitov writes:
> > >> >
> > >> >> On Wed, Jun 12, 2019 at 4:32 AM Naveen N. Rao
> > >> >> <naveen.n.rao@linux.vnet.ibm.com> wrote:
> > >> >>>
> > >> >>> Currently, for constant blinding, we re-allocate the bpf program to
> > >> >>> account for its new size and adjust all branches to accommodate the
> > >> >>> same, for each BPF instruction that needs constant blinding. This is
> > >> >>> inefficient and can lead to soft lockup with sufficiently large
> > >> >>> programs, such as the new verifier scalability test (ld_dw: xor
> > >> >>> semi-random 64 bit imms, test 5 -- with net.core.bpf_jit_harden=2)
> > >> >>
> > >> >> Slowdown you see is due to patch_insn right?
> > >> >> In such case I prefer to fix the scaling issue of patch_insn instead.
> > >> >> This specific fix for blinding only is not addressing the core of the problem.
> > >> >> Jiong,
> > >> >> how is the progress on fixing patch_insn?
> > >>
> > >> And what I have done is I have digested your conversion with Edward, and is
> > >> slightly incline to the BB based approach as it also exposes the inserted
> > >> insn to later pass in a natural way, then was trying to find a way that
> > >> could create BB info in little extra code based on current verifier code,
> > >> for example as a side effect of check_subprogs which is doing two insn
> > >> traversal already. (I had some such code before in the historical
> > >> wip/bpf-loop-detection branch, but feel it might be still too heavy for
> > >> just improving insn patching)
> > >
> > > BB - basic block?
> > > I'm not sure that was necessary.
> > > The idea was that patching is adding stuff to linked list instead
> > > and single pass at the end to linearize it.
> >
> > Just an update and keep people posted.
> >
> > Working on linked list based approach, the implementation looks like the
> > following, mostly a combine of discussions happened and Naveen's patch,
> > please feel free to comment.
> >
> >   - Use the reserved opcode 0xf0 with BPF_ALU as new pseudo insn code
> >     BPF_LIST_INSN. (0xf0 is also used with BPF_JMP class for tail call).
> >
> >   - Introduce patch pool into bpf_prog->aux to keep all patched insns.
> >     Pool structure looks like:
> >
> >     struct {
> >       int num;
> >       int prev;
> >       int next;
> >     } head_0;
> >     NUM patched insns for head_0
> >     head_1;
> >     patched insns for head_1
> >     head_2;
> >     ...
> >
> >   - Now when doing bpf_patch_insn_single, it doesn't change the original
> >     prog etc, instead, it merely update the insn at patched offset into a
> >     BPF_LIST_INSN, and pushed the patched insns plus a patch header into
> >     the patch pool. Fields of BPF_LIST_INSN is updated to setup the links:
> >
> >       BPF_LIST_INSN.off += patched_size
> >       (accumulating the size attached to this list_insn, it is possible a
> >       later patch pass patches insn in the patch pool, this means insn
> >       traversal needs to be changed, when seeing BPF_LIST_INSN, should go
> >       through the list)
> >
> >       BPF_LIST_INSN.imm = offset of the patch header in patch pool
> >       (off is 16-bit, imm is 32-bit, the patch pool is 32-bit length, so
> >       use imm for keeping offset, meaning a BPF_LIST_INSN can contains no
> >       more than 8192 insns, guess it is enough)
> >
> >   - When doing linearize:
> >     1. a quick scan of prog->insnsi to know the final
> >        image size, would be simple as:
> >
> >       fini_size = 0;
> >       for_each_insn:
> >         if (insn.code == (BPF_ALU | BPF_LIST_HEAD))
> >           fini_size += insn->off;
> >         else
> >           fini_size++;
> >
> >     2. Resize prog into fini_size, and a second scan of prog->insnsi to
> >        copy over all insns and patched insns, at the same time generate a
> >        auxiliary index array which maps an old index to the new index in
> >        final image, like the "clone_index" in Naveen's patch.
> >
> >     3. Finally, a single pass to update branch target, the same algo used
> >        by this patch.
> >
> >   - The APIs for doing insning patch looks like:
> >       bpf_patch_insn_init:   init the generic patch pool.
> >       bpf_patch_insn_single: push patched insns to the pool.
> >                              link them to the associated BPF_LIST_INSN.
> >       bpf_patch_insn_fini:   linearize a bpf_prog contains BPF_LIST_INSN.
> >                              destroy patch pool in prog->aux.
> >
> > I am trying to making the implementation working with jit blind first to make
> > sure basic things are ready. As JIT blinds happens after verification so no
> > need to both aux update etc. Then will cleanup quite a few things for
> > example patch a patched insn, adjust aux data, what to do with insn delete
> > etc.
>
> explicit indices feels like premature optimization.
> May be use vanilla singly linked list instead?
> Also do we have a case when patched insn will be patched again?
> In such case 'patch insn pool' will become recursive?
> Feels difficult to think through all offsets and indices.
> Whereas with linked list patching patched insns will be inserting
> them into link list.
>
> May be better alternative is to convert the whole program to link list
> of insns with branch targets becoming pointers and insert patched
> insns into this single singly linked list ?

I think converting to a singly-linked list is a good, simple and
straightforward approach. The only downside is 3x more memory (insn +
next pointer + branch pointer for instructions that branch/call), but
it shouldn't be a big deal in practice. But it seems like a good
opportunity to simplify and clean up patching code, so I'd definitely
vote to start with this approach.
