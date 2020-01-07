Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A45C2132621
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 13:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgAGMZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 07:25:24 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:30961 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727664AbgAGMZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 07:25:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578399923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VdXnV13onXJfhTEnlZ2gDhND7HWhSR5rePAbevPiBdM=;
        b=L9IVyNd9HtomtT4ucP/7RlTIq5YYNVOZqnRINY0GbzaGyWeoyMDuMBbXh8eO9ppaDX12QK
        p8qWFPSZSvk7AiTxHXhA/T39ATppa8VJZGs0jJ4ZMArGqznm3/TmwkeTvsYYMu9t2bU1ss
        7l5gHFexGBN5t1NK3Hy0bGVq0sHa3/4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-R4QjC570PpSTHjzoZdcTvQ-1; Tue, 07 Jan 2020 07:25:20 -0500
X-MC-Unique: R4QjC570PpSTHjzoZdcTvQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81048800D41;
        Tue,  7 Jan 2020 12:25:18 +0000 (UTC)
Received: from krava (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6663C7FB54;
        Tue,  7 Jan 2020 12:25:16 +0000 (UTC)
Date:   Tue, 7 Jan 2020 13:25:13 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>
Subject: Re: [PATCH 2/5] bpf: Add bpf_perf_event_output_kfunc
Message-ID: <20200107122513.GH290055@krava>
References: <20191229143740.29143-1-jolsa@kernel.org>
 <20191229143740.29143-3-jolsa@kernel.org>
 <20200106232719.nk4k27ijm4uuwwo3@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200106232719.nk4k27ijm4uuwwo3@ast-mbp>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 06, 2020 at 03:27:21PM -0800, Alexei Starovoitov wrote:
> On Sun, Dec 29, 2019 at 03:37:37PM +0100, Jiri Olsa wrote:
> > Adding support to use perf_event_output in
> > BPF_TRACE_FENTRY/BPF_TRACE_FEXIT programs.
> > 
> > There are no pt_regs available in the trampoline,
> > so getting one via bpf_kfunc_regs array.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  kernel/trace/bpf_trace.c | 67 ++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 67 insertions(+)
> > 
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index e5ef4ae9edb5..1b270bbd9016 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -1151,6 +1151,69 @@ raw_tp_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> >  	}
> >  }
> >  
> > +struct bpf_kfunc_regs {
> > +	struct pt_regs regs[3];
> > +};
> > +
> > +static DEFINE_PER_CPU(struct bpf_kfunc_regs, bpf_kfunc_regs);
> > +static DEFINE_PER_CPU(int, bpf_kfunc_nest_level);
> 
> Thanks a bunch for working on it.
> 
> I don't understand why new regs array and nest level is needed.
> Can raw_tp_prog_func_proto() be reused as-is?
> Instead of patches 2,3,4 ?

I thought that we might want to trace functions within the
raw tracepoint call, which would be prevented if we used
the same nest variable

now I'm not sure if there's not some other issue with nesting
bpf programs like that.. I'll need to check

jirka

