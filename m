Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158CD21C79D
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 07:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbgGLFG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 01:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgGLFG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 01:06:58 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2148C08C5DD;
        Sat, 11 Jul 2020 22:06:57 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id j80so9280713qke.0;
        Sat, 11 Jul 2020 22:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QAuIgUlyx0NcAgvFi4UCXRdkXlOyU9Eym+vjtofH6xc=;
        b=NKU6jc9/eBK/JAe1uymTij9SwQNxCDVEKCiWujObLWCE44KEcDWFCMzs+e03rupU0E
         7RID5Bp39ayXrgYWUdDN4pvGjiaukNoXk5+fd8aE6CuEpmQUsiy9U4bB9xSYO6hNBRlo
         rIqp2xFOm7a/gzmLwjw9UFgTs4pRONzYa0Hk6StbWyim4CznqAPbG856BkMS1t7hdQSS
         VFWVp2JhfN6j+rsnID7ZtBlbUlVokau75PzUtecZJt+ijrZnJa5nvAuvWg8O8IN2riPo
         xyH7sAAFZpXtWoyWWU1ZMmVIcMW+H9eyf1Xm4E1cwlRFdo+1OFhzR3dLFQKCsvnX7faK
         y0ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QAuIgUlyx0NcAgvFi4UCXRdkXlOyU9Eym+vjtofH6xc=;
        b=NU1hRDFqZzHc4YY8SWzp7HB3FfBsdiGmJ8Bb0U2Ih9R6f6EAMxeCiRsFOtF79731kM
         BJLzJ+gWafGFfSwRU0orKgAKiqSMolPjB+n2CRPeV2Q5Tj8XyoyK0+YRPvEpzeuny1R9
         zTMnlgICQ/PFNUbYi8NtHDdZbsBAuvtnUqVGLO3cHOgJTzfgeJEbYg7ZC1d9I1UA8W4s
         445CGydcJSJNIoi9b5xBASX2ZMABFCRXz0e/a1WukOAutjwMF5d8cSxgi9kSpokWKCu4
         g6idMxTg8UQaOEgWpeAXdK4oAgz2JK8iGPMftRGBH026U1TD3UoUN2rl1cjP3e1rqxGf
         6wTQ==
X-Gm-Message-State: AOAM531DZFP4KtBkRk5pUt28iq4As8gcDW/zeZFUNL2lE+PccxE9pFnF
        s1ODyIwsqOjcVIXNFMEv1Z9qp8Awh+bFs096Oq4=
X-Google-Smtp-Source: ABdhPJzf/ifl2V0QHB4AVv/RcZCgAOwMyXpCjJUPLxlKuEGK/PBSadlSUeVbyxb8wVW2Ol0W7Ahi5HlEQB11hHF6wqY=
X-Received: by 2002:a05:620a:1666:: with SMTP id d6mr78293499qko.449.1594530416664;
 Sat, 11 Jul 2020 22:06:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200711012639.3429622-1-songliubraving@fb.com>
 <20200711012639.3429622-2-songliubraving@fb.com> <CAEf4BzaHAFNdEPp38ZnKOYTy3CfRCwaxDykS_Xir_VqDm0Kiug@mail.gmail.com>
 <DEF050B0-E423-4442-9C95-02FB20F6BA57@fb.com>
In-Reply-To: <DEF050B0-E423-4442-9C95-02FB20F6BA57@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 11 Jul 2020 22:06:45 -0700
Message-ID: <CAEf4Bzbur1KBM3aPMMtQmsYXbHTfwsx4ULbNxpzR-DF7g=HDeA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/5] bpf: block bpf_get_[stack|stackid] on
 perf_event with PEBS entries
To:     Song Liu <songliubraving@fb.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Peter Ziljstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 11:28 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Jul 10, 2020, at 8:53 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Fri, Jul 10, 2020 at 6:30 PM Song Liu <songliubraving@fb.com> wrote:
> >>
> >> Calling get_perf_callchain() on perf_events from PEBS entries may cause
> >> unwinder errors. To fix this issue, the callchain is fetched early. Such
> >> perf_events are marked with __PERF_SAMPLE_CALLCHAIN_EARLY.
> >>
> >> Similarly, calling bpf_get_[stack|stackid] on perf_events from PEBS may
> >> also cause unwinder errors. To fix this, block bpf_get_[stack|stackid] on
> >> these perf_events. Unfortunately, bpf verifier cannot tell whether the
> >> program will be attached to perf_event with PEBS entries. Therefore,
> >> block such programs during ioctl(PERF_EVENT_IOC_SET_BPF).
> >>
> >> Signed-off-by: Song Liu <songliubraving@fb.com>
> >> ---
> >
> > Perhaps it's a stupid question, but why bpf_get_stack/bpf_get_stackid
> > can't figure out automatically that they are called from
> > __PERF_SAMPLE_CALLCHAIN_EARLY perf event and use different callchain,
> > if necessary?
> >
> > It is quite suboptimal from a user experience point of view to require
> > two different BPF helpers depending on PEBS or non-PEBS perf events.
>
> I am not aware of an easy way to tell the difference in bpf_get_stack.
> But I do agree that would be much better.
>

Hm... Looking a bit more how all this is tied together in the kernel,
I think it's actually quite easy. So, for perf_event BPF program type:

1. return a special prototype for bpf_get_stack/bpf_get_stackid, which
will have this extra bit of logic for callchain. All other program
types with access to bpf_get_stack/bpf_get_stackid should use the
current one, probably.
2. For that special program, just like for bpf_read_branch_records(),
we know that context is actually `struct bpf_perf_event_data_kern *`,
and it has pt_regs, perf_sample_data and perf_event itself.
3. With that, it seems like you'll have everything you need to
automatically choose a proper callchain.

All this absolutely transparently to the BPF program.

Am I missing something?

> Thanks,
> Song
