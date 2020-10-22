Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 683C22960B9
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 16:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895076AbgJVOMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 10:12:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59061 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2443552AbgJVOMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 10:12:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603375929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9xm/wjrf+bJwVnEJL99y1rb6Xy0StOQXlEFvSqTpGFo=;
        b=CELH3up2Qk3d1FAPUDUcB6I0GB9HZfnjscqy6wAPaplJxmsfKzeZ3H62U9dvFuMWWFj7Gu
        iSNKuf7E9o1bRiv/fbABcN7Q1d1N1cqCw6u3/j5fEA8wC1Y+gFb8yo/wSsC1JnbLn3UtJi
        4cX0VweeX2rpBZJbqWHqYsKX4r69b+w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-549-3-nMc0O0MkqmeFiqWz2eKw-1; Thu, 22 Oct 2020 10:12:04 -0400
X-MC-Unique: 3-nMc0O0MkqmeFiqWz2eKw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C309E1006CA8;
        Thu, 22 Oct 2020 14:12:01 +0000 (UTC)
Received: from krava (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with SMTP id 38EA91002C01;
        Thu, 22 Oct 2020 14:11:55 +0000 (UTC)
Date:   Thu, 22 Oct 2020 16:11:54 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
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
Message-ID: <20201022141154.GB2332608@krava>
References: <20201022082138.2322434-1-jolsa@kernel.org>
 <20201022093510.37e8941f@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022093510.37e8941f@gandalf.local.home>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 09:35:10AM -0400, Steven Rostedt wrote:
> On Thu, 22 Oct 2020 10:21:22 +0200
> Jiri Olsa <jolsa@kernel.org> wrote:
> 
> > hi,
> > this patchset tries to speed up the attach time for trampolines
> > and make bpftrace faster for wildcard use cases like:
> > 
> >   # bpftrace -ve "kfunc:__x64_sys_s* { printf("test\n"); }"
> > 
> > Profiles show mostly ftrace backend, because we add trampoline
> > functions one by one and ftrace direct function registering is
> > quite expensive. Thus main change in this patchset is to allow
> > batch attach and use just single ftrace call to attach or detach
> > multiple ips/trampolines.
> 
> The issue I have with this change is that the purpose of the direct
> trampoline was to give bpf access to the parameters of a function as if it
> was called directly. That is, it could see the parameters of a function
> quickly. I even made the direct function work if it wanted to also trace
> the return code.
> 
> What the direct calls is NOT, is a generic tracing function tracer. If that
> is required, then bpftrace should be registering itself with ftrace.
> If you are attaching to a set of functions, where it becomes obvious that
> its not being used to access specific parameters, then that's an abuse of
> the direct calls.
> 
> We already have one generic function tracer, we don't need another.

I understand direct calls as a way that bpf trampolines and ftrace can
co-exist together - ebpf trampolines need that functionality of accessing
parameters of a function as if it was called directly and at the same
point we need to be able attach to any function and to as many functions
as we want in a fast way

the bpftrace example above did not use arguments for simplicity, but they
could have been there ... I think we could detect arguments presence in
ebpf programs and use ftrace_ops directly in case they are not needed

jirka

