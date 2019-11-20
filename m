Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C11C1043DC
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 20:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbfKTTDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 14:03:02 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:44000 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbfKTTDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 14:03:02 -0500
Received: by mail-qv1-f66.google.com with SMTP id cg2so342270qvb.10;
        Wed, 20 Nov 2019 11:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2AUCamBdV/1OFD6oVTdqrJewE5eYbqBenyh0S0UjgDM=;
        b=C4ebGW/csKzVIDfCYwkXLDzHylU1ipKpTJ3KydR9WPrOXSmWeBYCI3/MotsVM+XvKa
         IL3Pn/FGHh+FzqSO1BpBOOUKunauNCsXxEgBECbrg7DXga0KsD6Q3FubHw5B1Kse3aUB
         mEJui1BkpSzlpTvHdOwDyKNwZS+dOc/TSqj7CQ4ajg7IbO1H9IbM+po9EhGCxshMBjZA
         c+WMwwlUonGsrVSAD25rmSLCuIFjTNb6bdVrMAQ6cW3EMMPiw28amusooCRgCFboklM3
         yLemAhRFmnNNRPmiW/Kcd97oUnEApQ9YU9PhCzf1OvJmYVcYvPuZGR/8WvfVwr/JtmpI
         ICDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2AUCamBdV/1OFD6oVTdqrJewE5eYbqBenyh0S0UjgDM=;
        b=SelhxoT3a6f5Nac4KE3XJdmlVeWVnDDu2mPPiTZBxP2G4uCUalOntBO8/0U0lGyTLn
         7gX87PqvotIr7QIOULW//KW3Q7OFRAIo6h1WT1jsuVsRb2R35WeIkNvABkB28rr7jWCJ
         sLx/I3HyyYAtYYFbo4WwwnxhgENMTgJG2PA30z58R5+bBBLMR9yZ1rFYLdY0SOKRXW+7
         7/1MoKvPD7A0/xHx1amSb6Gxi3dstGKep4L8/0XIfpXmmU4HUHoo+MnFBXcxnGvFJg71
         n8r6mBbOD1pBw4wOAHLe+ThQYuTYXal7nTN3iW6HLPPSerXeIby+wt/vfxDabOYtoVFF
         7NXA==
X-Gm-Message-State: APjAAAUUAI6eov46u9dzR6yV80RGpf92p5ZFjOVfMLcdycB4Ti6RyvWb
        R6eEzoCXjl/xgEoH334Sf+4IHeUHihByTaTuvXc=
X-Google-Smtp-Source: APXvYqyt8hM/9w99IBeTB1PRAp+M5d5x3py79Y9HxZ54wLwQNJFhFz/wwNrLVE4OlZdPmVEMY3OBHok+pxZm3iIAFHg=
X-Received: by 2002:ad4:4042:: with SMTP id r2mr4141962qvp.196.1574276580792;
 Wed, 20 Nov 2019 11:03:00 -0800 (PST)
MIME-Version: 1.0
References: <cover.1574126683.git.daniel@iogearbox.net> <2732992b223912c340367afc5af80766d9e588b0.1574126683.git.daniel@iogearbox.net>
In-Reply-To: <2732992b223912c340367afc5af80766d9e588b0.1574126683.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 20 Nov 2019 11:02:49 -0800
Message-ID: <CAEf4BzYZO8ytf4inRQA7+gWrNQzK-0C5e1_4b1K6y30Fcqa-RQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 6/8] bpf: constant map key tracking for prog
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

On Mon, Nov 18, 2019 at 5:38 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
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
>
> Future work can generalize and add similar approach to optimize plain
> array map lookups. Difference there is that we need to look into the key
> value that sits on stack. For clarity in bpf_insn_aux_data, map_state
> has been renamed into map_ptr_state, so we get map_{ptr,key}_state as
> trackers.
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/linux/bpf_verifier.h |   3 +-
>  kernel/bpf/verifier.c        | 116 ++++++++++++++++++++++++++++++++---
>  2 files changed, 110 insertions(+), 9 deletions(-)
>

[...]
