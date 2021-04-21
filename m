Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203003674DA
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 23:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244056AbhDUVio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 17:38:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29661 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235570AbhDUVin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 17:38:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619041089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=USJ1rCHDtsnQSbIgkOCEI2gwi3SlCmfjemci6IwfevY=;
        b=fLNNrh5vW7PnM9Du8ozUYnMVGpes9xEFo2mBekpASjzEafZ8ztw1gWQZMYdPa2CUfwxlfN
        ZRgewPTU3q3jdlzqX8geDL8X2bdrLAsDgpwT868Lw9lAtj3oOtgCfbl7HL6Fi9hGPChBWx
        Dc0pJjGvV4JMqt6skHjOfX14gM99+Lw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-oTwVE_hVMYuMlagTwG_sIQ-1; Wed, 21 Apr 2021 17:37:58 -0400
X-MC-Unique: oTwVE_hVMYuMlagTwG_sIQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44ACC107ACE8;
        Wed, 21 Apr 2021 21:37:56 +0000 (UTC)
Received: from krava (unknown [10.40.195.227])
        by smtp.corp.redhat.com (Postfix) with SMTP id 6455919726;
        Wed, 21 Apr 2021 21:37:48 +0000 (UTC)
Date:   Wed, 21 Apr 2021 23:37:47 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Jesper Brouer <jbrouer@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCHv2 RFC bpf-next 0/7] bpf: Add support for ftrace probe
Message-ID: <YICbK5JLqRXnjgEW@krava>
References: <CAEf4BzY=yBZH2Aad1hNcqCt51u0+SmNdkD6NfJRVMzF7DsvG+A@mail.gmail.com>
 <20210415170007.31420132@gandalf.local.home>
 <20210417000304.fc987dc00d706e7551b29c04@kernel.org>
 <20210416124834.05862233@gandalf.local.home>
 <YH7OXrjBIqvEZbsc@krava>
 <CAADnVQK55WzR6_JfxkMzEfUnLJnX75bRHjCkaptcVF=nQ_gWfw@mail.gmail.com>
 <YH8GxNi5VuYjwNmK@krava>
 <CAADnVQLh3tCWi=TiWnJVaMrYhJ=j-xSrJ72+XnZDP8CMZM+1mQ@mail.gmail.com>
 <YIArVa6IE37vsazU@krava>
 <20210421100541.3ea5c3bf@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421100541.3ea5c3bf@gandalf.local.home>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 10:05:41AM -0400, Steven Rostedt wrote:
> On Wed, 21 Apr 2021 15:40:37 +0200
> Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > ok, I understand why this would be the best solution for calling
> > the program from multiple probes
> > 
> > I think it's the 'attach' layer which is the source of problems
> > 
> > currently there is ftrace's fgraph_ops support that allows fast mass
> > attach and calls callbacks for functions entry and exit:
> >   https://lore.kernel.org/lkml/20190525031633.811342628@goodmis.org/
> > 
> > these callbacks get ip/parent_ip and can get pt_regs (that's not
> > implemented at the moment)
> > 
> > but that gets us to the situation of having full pt_regs on both
> > entry/exit callbacks that you described above and want to avoid,
> > but I think it's the price for having this on top of generic
> > tracing layer
> > 
> > the way ftrace's fgraph_ops is implemented, I'm not sure it can
> > be as fast as current bpf entry/exit trampoline
> 
> Note, the above mentioned code was an attempt to consolidate the code that
> does the "highjacking" of the return pointer in order to record the
> return of a function. At the time there was only kretprobes and function
> graph tracing. Now bpf has another version. That means there's three
> utilities that record the exit of the function.
> 
> What we need is a single method that works for all three utilities. And I'm
> perfectly fine with a rewrite of function graph tracer to do that. The one
> problem is that function graph and kretprobes works for pretty much all the
> architectures now, and whatever we decide to do, we can't break those
> architectures.
> 
> One way is to have an abstract layer that allows function graph and
> kretprobes to work with the old implementation as well as, depending on a
> config set, a new implementation that also supports bpf trampolines.
> 
> > 
> > but to better understand the pain points I think I'll try to implement
> > the 'mass trampolines' call to the bpf program you described above and
> > attach it for now to fgraph_ops callbacks
> 
> One thing that ftrace gives you is a way to have each function call its own
> trampoline, then depending on what is attached, each one can have multiple
> implementations.

but that would cut off other tracers for the function, right?

AFAICT it's used only when there's single ftrace_ops registered
for the probe and if there are more ftrace_ops, ops->trampoline
is replaced by the generic one and ftrace will call ops->func
instead, right?

if we would not care about sharing function by multiple tracers,
we could make special 'exclusive' trampoline that would require
that no other tracer is (or will be) registered for the function
while the tracer is registered

then we could run BPF trampolines directly without 'direct' API
and use ftrace for mass attach

that is if we don't care about other tracers for the function,
which I guess was concern when the 'direct' API was introduced

jirka

> 
> One thing that needs to be fixed is the direct trampoline and function
> graph and kretprobes. As the direct trampoline will break both of them,
> with the bpf implementation to trace after it.
> 
> I would be interested in what a mass generic trampoline would look like, if
> it had to deal with handling functions with 1 parameter and one with 12
> parameters. From this thread, I was told it can currently only handle 6
> parameters on x86_64. Not sure how it works on x86_32.
> 
> > 
> > perhaps this is a good topic to discuss in one of the Thursday's BPF mtg?
> 
> I'm unaware of these meetings.
> 
> 
> -- Steve
> 

