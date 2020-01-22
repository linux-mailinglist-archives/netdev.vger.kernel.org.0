Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5573F144C9F
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 08:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgAVHve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 02:51:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42871 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725883AbgAVHve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 02:51:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579679493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZidysynA2t0TjHonfp4kkvTRVsqXyi0UzzW9qMz3Zig=;
        b=SXkHYokt/IGIaxO9yKLyP7hGtDiOGZHIocCgJbItSsOW76mjU2g2JwgZxOfly/3pMWqAky
        Kmk5f43a9xmJzDmnIGp/C8YyM+5Za3X9zZ0p+QbMX0wxgumRwZhXYG1JKG4REdiGfzRp4T
        5rnna7vEBtd41n9WD3nCMPYnM4RQZ3g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-B-l5Xh6zMUue72oWXga7pQ-1; Wed, 22 Jan 2020 02:51:31 -0500
X-MC-Unique: B-l5Xh6zMUue72oWXga7pQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C30B28017CC;
        Wed, 22 Jan 2020 07:51:29 +0000 (UTC)
Received: from krava (ovpn-204-206.brq.redhat.com [10.40.204.206])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B0CC385780;
        Wed, 22 Jan 2020 07:51:26 +0000 (UTC)
Date:   Wed, 22 Jan 2020 08:51:24 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH 2/6] bpf: Add bpf_perf_event_output_kfunc
Message-ID: <20200122075124.GD801240@krava>
References: <20200121120512.758929-1-jolsa@kernel.org>
 <20200121120512.758929-3-jolsa@kernel.org>
 <20200122000322.ogarpgwv3xut75m3@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200122000322.ogarpgwv3xut75m3@ast-mbp.dhcp.thefacebook.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 04:03:23PM -0800, Alexei Starovoitov wrote:
> On Tue, Jan 21, 2020 at 01:05:08PM +0100, Jiri Olsa wrote:
> > Adding support to use perf_event_output in
> > BPF_TRACE_FENTRY/BPF_TRACE_FEXIT programs.
> > 
> > Using nesting regs array from raw tracepoint helpers.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  kernel/trace/bpf_trace.c | 41 ++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 41 insertions(+)
> > 
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index 19e793aa441a..6a18e2ae6e30 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -1172,6 +1172,43 @@ raw_tp_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> >  	}
> >  }
> >  
> > +BPF_CALL_5(bpf_perf_event_output_kfunc, void *, ctx, struct bpf_map *, map,
> > +	   u64, flags, void *, data, u64, size)
> > +{
> > +	struct pt_regs *regs = get_bpf_raw_tp_regs();
> > +	int ret;
> > +
> > +	if (IS_ERR(regs))
> > +		return PTR_ERR(regs);
> > +
> > +	perf_fetch_caller_regs(regs);
> > +	ret = ____bpf_perf_event_output(regs, map, flags, data, size);
> > +	put_bpf_raw_tp_regs();
> > +	return ret;
> > +}
> 
> I'm not sure why copy paste bpf_perf_event_output_raw_tp() into new function.
> 
> > @@ -1181,6 +1218,10 @@ tracing_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> >  		return &bpf_skb_output_proto;
> >  #endif
> >  	default:
> > +		if (prog->expected_attach_type == BPF_TRACE_FENTRY ||
> > +		    prog->expected_attach_type == BPF_TRACE_FEXIT)
> > +			return kfunc_prog_func_proto(func_id, prog);
> > +
> >  		return raw_tp_prog_func_proto(func_id, prog);
> 
> Are you saying bpf_perf_event_output_raw_tp() for some reason
> didn't work for fentry/fexit?
> But above is exact copy-paste and it somehow worked?
> 
> Ditto for patches 3,4.

ugh right.. did not realize that after switching to the rawtp
regs nest arrays it's identical and we don't need that

jirka

