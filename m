Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56CA6133F38
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 11:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbgAHKYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 05:24:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48140 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726252AbgAHKYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 05:24:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578479064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nrS5otik1Pvab3eQ+3jEa52lfJnkxclar8YBkXJgaGw=;
        b=UaQqY8zhy51Wyjn4jkb/XA/fOIRi/s/kYLor2JXxO76E2jripXH/TF67xrOJ2IeuAIXu2c
        dKIQZFbYwqjgMXZ8liRmHw4TOlByfsyvBQh/HU++EwZaKmN9JMpMxKT+CoJQx+Dmrj5RVn
        +Kd1VEmyKINZrdBaVWDXknijO5FzHxA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-emm6gywGNfqc0bCcaMrb2A-1; Wed, 08 Jan 2020 05:24:21 -0500
X-MC-Unique: emm6gywGNfqc0bCcaMrb2A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4409A80059E;
        Wed,  8 Jan 2020 10:24:19 +0000 (UTC)
Received: from krava (ovpn-205-199.brq.redhat.com [10.40.205.199])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DAF19610B0;
        Wed,  8 Jan 2020 10:24:13 +0000 (UTC)
Date:   Wed, 8 Jan 2020 11:24:06 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>
Subject: Re: [PATCH 2/5] bpf: Add bpf_perf_event_output_kfunc
Message-ID: <20200108102406.GB360164@krava>
References: <20191229143740.29143-1-jolsa@kernel.org>
 <20191229143740.29143-3-jolsa@kernel.org>
 <20200106232719.nk4k27ijm4uuwwo3@ast-mbp>
 <20200107122513.GH290055@krava>
 <CAADnVQKHPk=rcb_aV_SyL5iEyjxHtgv2XnTkDmeKFMHxgF0vbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQKHPk=rcb_aV_SyL5iEyjxHtgv2XnTkDmeKFMHxgF0vbg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 07, 2020 at 02:13:42PM -0800, Alexei Starovoitov wrote:
> On Tue, Jan 7, 2020 at 4:25 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Mon, Jan 06, 2020 at 03:27:21PM -0800, Alexei Starovoitov wrote:
> > > On Sun, Dec 29, 2019 at 03:37:37PM +0100, Jiri Olsa wrote:
> > > > Adding support to use perf_event_output in
> > > > BPF_TRACE_FENTRY/BPF_TRACE_FEXIT programs.
> > > >
> > > > There are no pt_regs available in the trampoline,
> > > > so getting one via bpf_kfunc_regs array.
> > > >
> > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > > ---
> > > >  kernel/trace/bpf_trace.c | 67 ++++++++++++++++++++++++++++++++++++++++
> > > >  1 file changed, 67 insertions(+)
> > > >
> > > > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > > > index e5ef4ae9edb5..1b270bbd9016 100644
> > > > --- a/kernel/trace/bpf_trace.c
> > > > +++ b/kernel/trace/bpf_trace.c
> > > > @@ -1151,6 +1151,69 @@ raw_tp_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> > > >     }
> > > >  }
> > > >
> > > > +struct bpf_kfunc_regs {
> > > > +   struct pt_regs regs[3];
> > > > +};
> > > > +
> > > > +static DEFINE_PER_CPU(struct bpf_kfunc_regs, bpf_kfunc_regs);
> > > > +static DEFINE_PER_CPU(int, bpf_kfunc_nest_level);
> > >
> > > Thanks a bunch for working on it.
> > >
> > > I don't understand why new regs array and nest level is needed.
> > > Can raw_tp_prog_func_proto() be reused as-is?
> > > Instead of patches 2,3,4 ?
> >
> > I thought that we might want to trace functions within the
> > raw tracepoint call, which would be prevented if we used
> > the same nest variable
> >
> > now I'm not sure if there's not some other issue with nesting
> > bpf programs like that.. I'll need to check
> 
> but nesting is what bpf_raw_tp_nest_level suppose to solve, no?
> I just realized that we already have three *_nest_level counters
> in that file. Not sure why one is not enough.
> There was an issue in the past when tracepoint, kprobe and skb
> collided and we had nasty memory corruption, but that was before
> _nest_level was introduced. Not sure how we got to three independent
> counters.

ok, I'm not sure what was the initial impuls for that now,
I'll make it share the counter with raw tracepoints

jirka

