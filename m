Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A410C460C6E
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 02:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235583AbhK2Bvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 20:51:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237693AbhK2Btk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 20:49:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72FBC0613E1;
        Sun, 28 Nov 2021 17:43:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73021611BC;
        Mon, 29 Nov 2021 01:43:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27538C53FCB;
        Mon, 29 Nov 2021 01:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638150195;
        bh=8nkkrdNGnlQP+jlb/Ix2bh90sJUCsjqkLdWqK4kVdXQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ozhPw+SLCFsu6IKNg4BFhaADNqJ5RR6PR5QQUA+0lhXOaNy0QIUCCs4YVDnIkopeO
         c3zmS/ZtpZqA6ly+41yYediSnvGk3dnHn9+xNpDN41zve+4OdGtz78oR+eonesIhH4
         F3gBddTOmyUo59ne0exzOlO3K18qW/A7QgRjANmzLFbqSDjfIg8c589AZ6zHehMbBo
         C1fG4pN0i6xrcEN0uAJ/iDCpB4qocZVjSb0xkhiNBzuPdHEm5ndLJ8Ut9nTWCXSW8k
         cNiBnCNpWcerykqFdbQC+rF/2MOKv892AZVCCGA0zQfT57Dkdj4tXcQu/T5E4fjOHA
         sguxglhDA9fsw==
Date:   Mon, 29 Nov 2021 10:43:09 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Ravi Bangoria <ravi.bangoria@amd.com>
Subject: Re: [PATCH 1/8] perf/kprobe: Add support to create multiple probes
Message-Id: <20211129104309.35b5cf2aa7108b0811470b3e@kernel.org>
In-Reply-To: <YaQD5d7Uc6GCvNbe@krava>
References: <20211124084119.260239-1-jolsa@kernel.org>
        <20211124084119.260239-2-jolsa@kernel.org>
        <20211128224954.11e8ac2a2ff1f45354c4a161@kernel.org>
        <YaQD5d7Uc6GCvNbe@krava>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 28 Nov 2021 23:34:13 +0100
Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > > +		if (!tk_old) {
> > > +			ret = -EINVAL;
> > > +			goto error;
> > > +		}
> > > +
> > > +		/* Append to existing event */
> > > +		ret = trace_probe_append(&tk->tp, &tk_old->tp);
> > > +		if (ret)
> > > +			goto error;
> > > +
> > > +		/* Register k*probe */
> > > +		ret = __register_trace_kprobe(tk);
> > > +		if (ret)
> > > +			goto error;
> > 
> > If "appended" probe failed to register, it must be "unlinked" from
> > the first one and goto error to free the trace_kprobe.
> > 
> > 	if (ret) {
> > 		trace_probe_unlink(&tk->tp);
> > 		goto error;
> > 	}
> > 
> > See append_trace_kprobe() for details.
> 
> so there's goto error jumping to:
> 
> error:
> 	free_trace_kprobe(tk);
> 
> that calls:
> 	trace_probe_cleanup
> 	  -> trace_probe_unlink
> 
> that should do it, right?

Ah, OK. Clean up all the kprobe events in this function. Then it's good. 

> 
> > 
> > > +
> > > +		return trace_probe_event_call(&tk->tp);
> > > +	}
> > > +
> > >  	init_trace_event_call(tk);
> > >  
> > >  	ptype = trace_kprobe_is_return(tk) ?
> > > @@ -1841,6 +1868,8 @@ create_local_trace_kprobe(char *func, void *addr, unsigned long offs,
> > >  
> > >  void destroy_local_trace_kprobe(struct trace_event_call *event_call)
> > >  {
> > > +	struct trace_probe_event *event;
> > > +	struct trace_probe *pos, *tmp;
> > >  	struct trace_kprobe *tk;
> > >  
> > >  	tk = trace_kprobe_primary_from_call(event_call);
> > > @@ -1852,9 +1881,15 @@ void destroy_local_trace_kprobe(struct trace_event_call *event_call)
> > >  		return;
> > >  	}
> > >  
> > > -	__unregister_trace_kprobe(tk);
> > > +	event = tk->tp.event;
> > > +	list_for_each_entry_safe(pos, tmp, &event->probes, list) {
> > > +		list_for_each_entry_safe(pos, tmp, &event->probes, list) {
> > > +		list_del_init(&pos->list);
> > > +		__unregister_trace_kprobe(tk);
> > > +		__free_trace_kprobe(tk);
> > > +	}
> > >  
> > > -	free_trace_kprobe(tk);
> > > +	trace_probe_event_free(event);
> > 
> > Actually, each probe already allocated the trace_probe events (which are not
> > used if it is appended). Thus you have to use trace_probe_unlink(&tk->tp) in
> > the above loop.
> > 
> > 	list_for_each_entry_safe(pos, tmp, &event->probes, list) {
> > 		list_for_each_entry_safe(pos, tmp, &event->probes, list) {
> > 		__unregister_trace_kprobe(tk);
> > 		trace_probe_unlink(&tk->tp); /* This will call trace_probe_event_free() internally */
> > 		free_trace_kprobe(tk);
> > 	}
> 
> so calling trace_probe_event_free inside this loop is a problem,
> because the loop iterates that trace_probe_event's probes list,
> and last probe removed will trigger trace_probe_event_free, that
> will free the list we iterate..  and we go down ;-)

Oops, right. So in this case, you are looping on the all probes
on an event, so event is referred outside of loop.

OK, I got it.

In the ftrace kprobe-event, this loop cursor is done by dynevent,
so this problem doesn't occur. But the BPF is only using the
trace_event, thus this special routine is needed.

Could you add such comment on your loop?

Thank you,

> 
> so that's why I added new free function '__free_trace_kprobe'
> that frees everything as free_trace_kprobe, but does not call
> trace_probe_unlink
> 
> 	event = tk->tp.event;
> 	list_for_each_entry_safe(pos, tmp, &event->probes, list) {
> 		list_for_each_entry_safe(pos, tmp, &event->probes, list) {
> 		list_del_init(&pos->list);
> 		__unregister_trace_kprobe(tk);
> 		__free_trace_kprobe(tk);
> 	}
> 
> 	trace_probe_event_free(event);
> 
> and there's trace_probe_event_free(event) to make the final free
> 
> thanks,
> jirka
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
