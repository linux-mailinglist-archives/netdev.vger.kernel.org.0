Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82BBE29B177
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 15:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896872AbgJ0Oah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 10:30:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37593 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1759193AbgJ0O2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 10:28:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603808897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LK7Mui4e4v09fi5cFY5cXbC0c03SKE7y2UkxK+apedU=;
        b=N+A3P/0t24GAjadqG3gKTbg9guh6oKa4FIwkTE378sp1UwdqO0zV9q0VINn8WntmruU0MI
        zLMNF72N4Gr+ZATxeuBlovza3ovnOTt3AxpSwhh92c29dtyt4oucoW8cHd2USEEqXowshd
        z99jHfBFMCt1yRnobeXGln5WnIJrPn8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-I0c1CvcnMYCLZwkTt-HFxA-1; Tue, 27 Oct 2020 10:28:14 -0400
X-MC-Unique: I0c1CvcnMYCLZwkTt-HFxA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66B0BAF9A9;
        Tue, 27 Oct 2020 14:28:12 +0000 (UTC)
Received: from krava (unknown [10.40.195.208])
        by smtp.corp.redhat.com (Postfix) with SMTP id C8AEB60C07;
        Tue, 27 Oct 2020 14:28:04 +0000 (UTC)
Date:   Tue, 27 Oct 2020 15:28:03 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Jesper Brouer <jbrouer@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [RFC bpf-next 00/16] bpf: Speed up trampoline attach
Message-ID: <20201027142803.GJ2900849@krava>
References: <20201022082138.2322434-1-jolsa@kernel.org>
 <20201022093510.37e8941f@gandalf.local.home>
 <20201022141154.GB2332608@krava>
 <20201022104205.728dd135@gandalf.local.home>
 <20201027043014.ebzcbzospzsaptvu@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027043014.ebzcbzospzsaptvu@ast-mbp.dhcp.thefacebook.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 09:30:14PM -0700, Alexei Starovoitov wrote:
> On Thu, Oct 22, 2020 at 10:42:05AM -0400, Steven Rostedt wrote:
> > On Thu, 22 Oct 2020 16:11:54 +0200
> > Jiri Olsa <jolsa@redhat.com> wrote:
> > 
> > > I understand direct calls as a way that bpf trampolines and ftrace can
> > > co-exist together - ebpf trampolines need that functionality of accessing
> > > parameters of a function as if it was called directly and at the same
> > > point we need to be able attach to any function and to as many functions
> > > as we want in a fast way
> > 
> > I was sold that bpf needed a quick and fast way to get the arguments of a
> > function, as the only way to do that with ftrace is to save all registers,
> > which, I was told was too much overhead, as if you only care about
> > arguments, there's much less that is needed to save.
> > 
> > Direct calls wasn't added so that bpf and ftrace could co-exist, it was
> > that for certain cases, bpf wanted a faster way to access arguments,
> > because it still worked with ftrace, but the saving of regs was too
> > strenuous.
> 
> Direct calls in ftrace were done so that ftrace and trampoline can co-exist.
> There is no other use for it.
> 
> Jiri,
> could you please redo your benchmarking hardcoding ftrace_managed=false ?
> If going through register_ftrace_direct() is indeed so much slower
> than arch_text_poke() then something gotta give.
> Either register_ftrace_direct() has to become faster or users
> have to give up on co-existing of bpf and ftrace.
> So far not a single user cared about using trampoline and ftrace together.
> So the latter is certainly an option.

I tried that, and IIRC it was not much faster, but I don't have details
on that.. but it should be quick check, I'll do it

anyway later I realized that for us we need ftrace to stay, so I abandoned
this idea ;-) and started to check on how to keep them both together and
just make it faster

also currently bpf trampolines will not work without ftrace being
enabled, because ftrace is doing the preparation work during compile,
and replaces all the fentry calls with nop instructions and the
replace code depends on those nops...  so if we go this way, we would
need to make this preparation code generic

> 
> Regardless, the patch 7 (rbtree of kallsyms) is probably good on its own.
> Can you benchmark it independently and maybe resubmit if it's useful
> without other patches?

yes, I'll submit that in separate patch

thanks,
jirka

