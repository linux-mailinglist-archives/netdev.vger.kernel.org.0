Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4610B450F3
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 02:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbfFNAzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 20:55:50 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:38149 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbfFNAzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 20:55:50 -0400
Received: by mail-lf1-f65.google.com with SMTP id b11so492491lfa.5;
        Thu, 13 Jun 2019 17:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ryaPCZIxAcKEqlnkJURjQarpGjK1d3kFhw+bV3KFP9w=;
        b=Am2rlOOmSe5TZvPubrB9t5WLp99W7cGT3AFwKkLm752jiH3pKsM7TuXaV/gVBtbI0I
         Lvt/jAO2ZklUO1AuoGu4BSbAG3VQGC0Bs/G/Nudkn/xfVMLjTPELMRMyOX731rgWMoqJ
         9Gh6wD1+eyS6aCNiN3tdJ1UyKEUtUfWNfMC3eDMhMJsX44+v5DWx7n2a931/3UcXjJs5
         QbANRRVfLLaJzAf3JXE4YvgTn0D3VYoGcLZh3KqPm6iMoJOfV0OFEXA94WXq3noAf1yq
         iFlBs6bFtTBu3UnsjO3GXwg/ug1ViobK/hpmMhcfcroIa30HDFexgv6ZYKKPwspta92N
         VdvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ryaPCZIxAcKEqlnkJURjQarpGjK1d3kFhw+bV3KFP9w=;
        b=DhP81wer8GY2AoeNzp0w3CV4Q04uUa0DWyPXb1srpOHIx3Ib/zE/GVDlzsz/J8bkqE
         GSViQVBYm0F27uuSXJs7yj6Uxny3WG4W+PQ3FNvm4j827EhxRgchJoTescpXhegWo0dr
         EA+/SMzLvphSAhNfMPV/RwxBraSeewXjf9v8lzNbo/zwRoN0DymXKUPUi83XgpRz/HZo
         XDQOvBtw9ZLRUug4+SF0DIjkxJSUTx1jVLQ0DnqI8Z8qonFvdi8oLpneFh73RCdLVKpM
         v2W3feCLGxc7AFIkJzZx/kbqllA1W5kPvMmJsmbU0xJaGYJAWU29lTPru1R8MjBYcg0e
         /SIA==
X-Gm-Message-State: APjAAAUEs+RAWOZGMdbf1ZKdJKOCWLlQND/Qxb+1pi+lbZ0lDBWf9M7k
        Sy3CSH9ZMYHSU0CF6gODDR9S7xGZnmJIJOPhO+M=
X-Google-Smtp-Source: APXvYqx9lJ1Egqv+7WXAkIM2x8BJIXO6TIeTHbKoqF+cwbEj1hpPLT6iy6bgD8dz8+Z+cP0erI7MZ1fSdo/A3fdlVgE=
X-Received: by 2002:a19:ab1a:: with SMTP id u26mr8730266lfe.6.1560473747165;
 Thu, 13 Jun 2019 17:55:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190611215304.28831-1-mmullins@fb.com> <CAEf4BzZ_Gypm32mSnrpGWw_U9q8LfTn7hag-p-LvYKVNkFdZGw@mail.gmail.com>
 <4aa26670-75b8-118d-68ca-56719af44204@iogearbox.net> <9c77657414993332987ca79d4081c4d71cc48d66.camel@fb.com>
In-Reply-To: <9c77657414993332987ca79d4081c4d71cc48d66.camel@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 13 Jun 2019 17:55:35 -0700
Message-ID: <CAADnVQLV3n3ozBbz-7dJbYfptDwQtL_zM95Z5rcAF-A72aJ9DA@mail.gmail.com>
Subject: Re: [PATCH bpf v2] bpf: fix nested bpf tracepoints with per-cpu data
To:     Matt Mullins <mmullins@fb.com>
Cc:     "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Song Liu <songliubraving@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "ast@kernel.org" <ast@kernel.org>, Andrew Hall <hall@fb.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 5:52 PM Matt Mullins <mmullins@fb.com> wrote:
>
> On Fri, 2019-06-14 at 00:47 +0200, Daniel Borkmann wrote:
> > On 06/12/2019 07:00 AM, Andrii Nakryiko wrote:
> > > On Tue, Jun 11, 2019 at 8:48 PM Matt Mullins <mmullins@fb.com> wrote:
> > > >
> > > > BPF_PROG_TYPE_RAW_TRACEPOINTs can be executed nested on the same CP=
U, as
> > > > they do not increment bpf_prog_active while executing.
> > > >
> > > > This enables three levels of nesting, to support
> > > >   - a kprobe or raw tp or perf event,
> > > >   - another one of the above that irq context happens to call, and
> > > >   - another one in nmi context
> > > > (at most one of which may be a kprobe or perf event).
> > > >
> > > > Fixes: 20b9d7ac4852 ("bpf: avoid excessive stack usage for perf_sam=
ple_data")
> >
> > Generally, looks good to me. Two things below:
> >
> > Nit, for stable, shouldn't fixes tag be c4f6699dfcb8 ("bpf: introduce B=
PF_RAW_TRACEPOINT")
> > instead of the one you currently have?
>
> Ah, yeah, that's probably more reasonable; I haven't managed to come up
> with a scenario where one could hit this without raw tracepoints.  I'll
> fix up the nits that've accumulated since v2.
>
> > One more question / clarification: we have __bpf_trace_run() vs trace_c=
all_bpf().
> >
> > Only raw tracepoints can be nested since the rest has the bpf_prog_acti=
ve per-CPU
> > counter via trace_call_bpf() and would bail out otherwise, iiuc. And ra=
w ones use
> > the __bpf_trace_run() added in c4f6699dfcb8 ("bpf: introduce BPF_RAW_TR=
ACEPOINT").
> >
> > 1) I tried to recall and find a rationale for mentioned trace_call_bpf(=
) split in
> > the c4f6699dfcb8 log, but couldn't find any. Is the raison d'=C3=AAtre =
purely because of
> > performance overhead (and desire to not miss events as a result of nest=
ing)? (This
> > also means we're not protected by bpf_prog_active in all the map ops, o=
f course.)
> > 2) Wouldn't this also mean that we only need to fix the raw tp programs=
 via
> > get_bpf_raw_tp_regs() / put_bpf_raw_tp_regs() and won't need this dupli=
cation for
> > the rest which relies upon trace_call_bpf()? I'm probably missing somet=
hing, but
> > given they have separate pt_regs there, how could they be affected then=
?
>
> For the pt_regs, you're correct: I only used get/put_raw_tp_regs for
> the _raw_tp variants.  However, consider the following nesting:
>
>                                     trace_nest_level raw_tp_nest_level
>   (kprobe) bpf_perf_event_output            1               0
>   (raw_tp) bpf_perf_event_output_raw_tp     2               1
>   (raw_tp) bpf_get_stackid_raw_tp           2               2
>
> I need to increment a nest level (and ideally increment it only once)
> between the kprobe and the first raw_tp, because they would otherwise
> share the struct perf_sample_data.  But I also need to increment a nest
> level between the two raw_tps, since they share the pt_regs -- I can't
> use trace_nest_level for everything because it's not used by
> get_stackid, and I can't use raw_tp_nest_level for everything because
> it's not incremented by kprobes.
>
> If raw tracepoints were to bump bpf_prog_active, then I could get away
> with just using that count in these callsites -- I'm reluctant to do
> that, though, since it would prevent kprobes from ever running inside a
> raw_tp.  I'd like to retain the ability to (e.g.)
>   trace.py -K htab_map_update_elem
> and get some stack traces from at least within raw tracepoints.
>
> That said, as I wrote up this example, bpf_trace_nest_level seems to be
> wildly misnamed; I should name those after the structure they're
> protecting...

I still don't get what's wrong with the previous approach.
Didn't I manage to convince both of you that perf_sample_data
inside bpf_perf_event_array doesn't have any issue that Daniel brought up?
I think this refcnting approach is inferior.
