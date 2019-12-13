Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3872411EA83
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 19:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbfLMShF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 13:37:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22303 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728829AbfLMShF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 13:37:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576262223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/AzDNeFt/JNl5YH190khbXQVeplcQDkLb2NoTZrjPVQ=;
        b=Mrj5/HLR7+T1Y4jWoqcdq//F1hwdt4EBiUxkSu1DmLPIAkAgKilh1yl7Ir4CAmDMO4D5Yf
        i6KhYO+iALVigd8anntAjNBkyeNpQTk8uNoIlhBF7dUFzoMy2da6M1PfHuYPbBPX/DuIOY
        ghkhnFzpfkr64dfrUYc3strg2ttyPQ4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-lHpy5HR0PEavOMKwnb1K8Q-1; Fri, 13 Dec 2019 13:37:02 -0500
X-MC-Unique: lHpy5HR0PEavOMKwnb1K8Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE88D1005502;
        Fri, 13 Dec 2019 18:36:59 +0000 (UTC)
Received: from krava (ovpn-204-48.brq.redhat.com [10.40.204.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BADE160BC2;
        Fri, 13 Dec 2019 18:36:49 +0000 (UTC)
Date:   Fri, 13 Dec 2019 19:36:46 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
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
Message-ID: <20191213183646.GB8994@krava>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 01:29:41PM -0500, Steven Rostedt wrote:
> On Fri, 13 Dec 2019 19:02:23 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Fri, Dec 13, 2019 at 12:11:18PM -0500, Steven Rostedt wrote:
> > > On Fri, 13 Dec 2019 08:51:57 -0800
> > > Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > >   
> > > > It had two choices. Both valid. I don't know why gdb picked this one.
> > > > So yeah I think renaming 'ring_buffer' either in ftrace or in perf would be
> > > > good. I think renaming ftrace one would be better, since gdb picked perf one
> > > > for whatever reason.  
> > > 
> > > Because of the sort algorithm. But from a technical perspective, the
> > > ring buffer that ftrace uses is generic, where the perf ring buffer can
> > > only be used for perf. Call it "event_ring_buffer" or whatever, but
> > > it's not generic and should not have a generic name.  
> > 
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
> 
> > 
> > Nor is the perf buffer fundamentally specific to perf, but there not
> > being another user means there has been very little effort to remove
> > perf specific things from it.
> 
> I took a look at doing so, and it was not a trivial task.
> 
> > 
> > There are major design differences between them, which is
> > unquestionably, but I don't think it is fair to say one is more or less
> > generic.
> > 
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

sounds good to me.. and too good to be true ;-)
please let me know if I should send the perf change

thanks,
jirka

