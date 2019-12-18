Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C10D6124D0F
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 17:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbfLRQWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 11:22:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:55844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727021AbfLRQWX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 11:22:23 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC2CC20717;
        Wed, 18 Dec 2019 16:22:21 +0000 (UTC)
Date:   Wed, 18 Dec 2019 11:22:19 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNl?= =?UTF-8?B?bg==?= 
        <toke@redhat.com>, Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [RFC] btf: Some structs are doubled because of struct
 ring_buffer
Message-ID: <20191218112219.309d1031@gandalf.local.home>
In-Reply-To: <20191218161401.GC15571@krava>
References: <20191213153553.GE20583@krava>
        <20191213112438.773dff35@gandalf.local.home>
        <20191213165155.vimm27wo7brkh3yu@ast-mbp.dhcp.thefacebook.com>
        <20191213121118.236f55b8@gandalf.local.home>
        <20191213180223.GE2844@hirez.programming.kicks-ass.net>
        <20191213132941.6fa2d1bd@gandalf.local.home>
        <20191213184621.GG2844@hirez.programming.kicks-ass.net>
        <20191213140349.5a42a8af@gandalf.local.home>
        <20191213140531.116b3200@gandalf.local.home>
        <20191214113510.GB12440@krava>
        <20191218161401.GC15571@krava>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Dec 2019 17:14:01 +0100
Jiri Olsa <jolsa@redhat.com> wrote:

> On Sat, Dec 14, 2019 at 12:35:10PM +0100, Jiri Olsa wrote:
> > On Fri, Dec 13, 2019 at 02:05:31PM -0500, Steven Rostedt wrote:
> > 
> > SNIP
> >   
> > >  	struct trace_array *tr = filp->private_data;
> > > -	struct ring_buffer *buffer = tr->trace_buffer.buffer;
> > > +	struct trace_buffer *buffer = tr->trace_buffer.buffer;
> > >  	unsigned long val;
> > >  	int ret;
> > >  
> > > diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> > > index 63bf60f79398..308fcd673102 100644
> > > --- a/kernel/trace/trace.h
> > > +++ b/kernel/trace/trace.h
> > > @@ -178,7 +178,7 @@ struct trace_option_dentry;
> > >  
> > >  struct trace_buffer {
> > >  	struct trace_array		*tr;
> > > -	struct ring_buffer		*buffer;
> > > +	struct trace_buffer		*buffer;  
> > 
> > perf change is fine, but 'trace_buffer' won't work because
> > we already have 'struct trace_buffer' defined in here
> > 
> > maybe we could change this name to trace_buffer_array?  
> 
> ..like in patch below? it's independent of your previous changes
> 
>

Actually, I would prefer to call it either trace_array_buffer, or just
array_buffer.

-- Steve
