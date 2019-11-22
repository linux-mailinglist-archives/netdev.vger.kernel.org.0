Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3A2107AEF
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 23:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfKVW5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 17:57:44 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:44591 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfKVW5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 17:57:43 -0500
Received: by mail-qv1-f67.google.com with SMTP id d3so3558507qvs.11;
        Fri, 22 Nov 2019 14:57:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6NEyHTvxPo7kejEqf+MsIN4Fn+IimqPv3MeDXnOOYr4=;
        b=FVzsqWz+mEvN9eKn0ZRZEPihUjok13aaCHZ0YAcDZGtTVpiSWhi62j/dPxshxGVaTM
         +G0t2cztc1mHZ78X8zVHHzhtnr0Fr/lKoO6dznJgPHEJxKXMDmecVdD1Ll6QBKNlLVdR
         0VPDWT8i3vk1L0vy+2rN7ZVVIqA/YWA7ORCgdLntn9w8ZW4ZflF81LjROx8hai9JzmeQ
         bR8/e2yWuwFtPLJML7oPdRVtqoNZaFGurT54aDNxarMbVrZkPB9L0fdL4SBhBKC8A2vu
         wM98r1+KQ4WM95//qS2qCo/+2ul1GGfLpRqFvqW4wIPiyrLDDWhkOD0Nls0GTXDdt8bM
         JrIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6NEyHTvxPo7kejEqf+MsIN4Fn+IimqPv3MeDXnOOYr4=;
        b=H+FngEENt/5TJvAoWNdQPNpoHZbJIMK0f30RlZzyGrbjaQFG0VD1OKR863ygkh9Sqw
         B0/CZccBcGyprR+JCOgD9E76dpUbalylQdHCnng76nJzvXCXGo9n8KwI7PtVqlGSAfVS
         BIE9KB5HCOi1B4I1Cz5uUDocEoDhD+kik9thVl5cZKp+oAl3w6smkmicv9f8AdQZrmmq
         tR8dt4ekFz/hDrFJJj+6EatKZxzl4TKQ/J1D5OLUrJd7PUnPmbw+OmkQE6jw2khdENrw
         MTnD94mCLXsYi2js7RgaEHmJxLijT/2VfzbtdOftUCNZv34uDDW9eB537YCf7DAQBitS
         CJHg==
X-Gm-Message-State: APjAAAUHO/vMa5ZHhDyB1uhB84q9WNfhFzAaJSFKaWewzAujDhp8YBvB
        tLMGTrM9EtfLmOgR35aClqTP41FbkjYUHfCJ/Pk=
X-Google-Smtp-Source: APXvYqwQEE0IzBI1R+E/4/W/B4kFfgIY0+epUvW5tUfPy0FDyYs40H9xjKorWbbTTJI+b5wF3hbiL8eaTRpesrDt1f8=
X-Received: by 2002:a0c:eb47:: with SMTP id c7mr16895155qvq.163.1574463461175;
 Fri, 22 Nov 2019 14:57:41 -0800 (PST)
MIME-Version: 1.0
References: <cover.1574452833.git.daniel@iogearbox.net> <e8db37f6b2ae60402fa40216c96738ee9b316c32.1574452833.git.daniel@iogearbox.net>
In-Reply-To: <e8db37f6b2ae60402fa40216c96738ee9b316c32.1574452833.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 22 Nov 2019 14:57:30 -0800
Message-ID: <CAEf4BzbGisir256Bype9X7wRKgpdP5xYH1_rfRSoXbVM0Q6cbg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 6/8] bpf: constant map key tracking for prog
 array pokes
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 22, 2019 at 12:08 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Add tracking of constant keys into tail call maps. The signature of
> bpf_tail_call_proto is that arg1 is ctx, arg2 map pointer and arg3
> is a index key. The direct call approach for tail calls can be enabled
> if the verifier asserted that for all branches leading to the tail call
> helper invocation, the map pointer and index key were both constant
> and the same.
>
> Tracking of map pointers we already do from prior work via c93552c443eb
> ("bpf: properly enforce index mask to prevent out-of-bounds speculation")
> and 09772d92cd5a ("bpf: avoid retpoline for lookup/update/ delete calls
> on maps").
>
> Given the tail call map index key is not on stack but directly in the
> register, we can add similar tracking approach and later in fixup_bpf_calls()
> add a poke descriptor to the progs poke_tab with the relevant information
> for the JITing phase.
>
> We internally reuse insn->imm for the rewritten BPF_JMP | BPF_TAIL_CALL
> instruction in order to point into the prog's poke_tab, and keep insn->imm
> as 0 as indicator that current indirect tail call emission must be used.
> Note that publishing to the tracker must happen at the end of fixup_bpf_calls()
> since adding elements to the poke_tab reallocates its memory, so we need
> to wait until its in final state.
>
> Future work can generalize and add similar approach to optimize plain
> array map lookups. Difference there is that we need to look into the key
> value that sits on stack. For clarity in bpf_insn_aux_data, map_state
> has been renamed into map_ptr_state, so we get map_{ptr,key}_state as
> trackers.
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/linux/bpf_verifier.h |   3 +-
>  kernel/bpf/verifier.c        | 120 ++++++++++++++++++++++++++++++++---
>  2 files changed, 113 insertions(+), 10 deletions(-)
>

[...]
