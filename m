Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41B5511EAA4
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 19:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728610AbfLMSqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 13:46:50 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51506 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728455AbfLMSqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 13:46:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=k6bX98yPAK/DWwqLyqs0Jt4qhMgt0hIUQCq2lotOApw=; b=YkA/V1SrXrgr0WXo9DcHht8QV
        TqqvJGWVNJ6H22xf5/TmBH5JgYQ+V8YnsfttRvffykjeXO/T0IJaOx6TfbpGuJmbI20AShiBsLviH
        Bx+S36f+y68qo6Gtjin0PdmZCwQwIafgVKXbpaChYxWwD7Kypcwa/WBmNgNq6Tm5lEU2xDq5US6wi
        RhYQnyNqDrFfqXBY9Akut+5Wcg4IoqT2d4eKWwvWy+vpOzwMNJCJ6l3au5yMxCWC3JR2tgQcD/dE1
        rjVZ65tfajlnPupA8sseaU5pKyx+UtyJVZDZ+pL4RdH9iVO/BvHjnp5H/rnJq3lZ666WrEuCYCMk1
        Ei24SjF4w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ifpxG-000125-Ir; Fri, 13 Dec 2019 18:46:22 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3E5C03058B4;
        Fri, 13 Dec 2019 19:45:00 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 232B829D73AB4; Fri, 13 Dec 2019 19:46:21 +0100 (CET)
Date:   Fri, 13 Dec 2019 19:46:21 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
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
Subject: Re: [RFC] btf: Some structs are doubled because of struct ring_buffer
Message-ID: <20191213184621.GG2844@hirez.programming.kicks-ass.net>
References: <20191213153553.GE20583@krava>
 <20191213112438.773dff35@gandalf.local.home>
 <20191213165155.vimm27wo7brkh3yu@ast-mbp.dhcp.thefacebook.com>
 <20191213121118.236f55b8@gandalf.local.home>
 <20191213180223.GE2844@hirez.programming.kicks-ass.net>
 <20191213132941.6fa2d1bd@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213132941.6fa2d1bd@gandalf.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 01:29:41PM -0500, Steven Rostedt wrote:
> On Fri, 13 Dec 2019 19:02:23 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:

> > Your ring buffer was so generic that I gave up trying to use it after
> > trying for days :-( (the fundamental problem was that it was impossible
> > to have a single cpu buffer; afaik that is still true today)
> 
> Yeah, but that could have been fixed, and the only reason it's not
> today, is because it requires more overhead to do so.
> 
> IIRC, the main reason that you didn't use it then, is because it wasn't
> fully lockless at the time (it is today), and you couldn't use it from
> NMI context.

What I remember is that I couldn't get a single cpu buffer, the whole
per-cpu stuff was mangled in at the wrong layer. But who knows, my
memory is faulty.


> > How about we rename both? I'm a bit adverse to long names, so how about
> > we rename the perf one to perf_buffer and the trace one to trace_buffer?
> 
> I'm fine with this idea! Now what do we call the ring buffer that
> tracing uses, as it is not specific for tracing, it was optimized for
> splicing. But sure, I can rename it to trace_buffer. I just finished
> renaming perf's...
> 
> Thinking about this, perhaps we should remove the word "ring" from
> both. That is:
> 
>   perf_buffer and trace_buffer ?

That's what I just proposed, right? So ACK on that ;-)
