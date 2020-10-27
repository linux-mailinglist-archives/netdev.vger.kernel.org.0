Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E3829C837
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 20:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502031AbgJ0TEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 15:04:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55529 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2444462AbgJ0TD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 15:03:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603825438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q2CJeMYkyNjE9PnW+lrgRZDLIfVrx6EFxXwVkjIxhTk=;
        b=DsKkAKZ7KhxG75Ih8RL8+FFPIzgurDPcm/2Y2Ov7wAdXS0tZOsB5IVOIHF9rV+sSq9dzpz
        dlKUQz4PlKx+xZIwb6EmxDvuVNpSYGXap5SxEZxg9yyLBsQrY4WuWMbZ8EcUkophR9WEIP
        H0lTDvWftaJKQOavTAFJ5GBWJx0T4y0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-RlzFLS3JMluhFqFa02oXmw-1; Tue, 27 Oct 2020 15:03:56 -0400
X-MC-Unique: RlzFLS3JMluhFqFa02oXmw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 24C2D80364D;
        Tue, 27 Oct 2020 19:03:53 +0000 (UTC)
Received: from krava (unknown [10.40.192.58])
        by smtp.corp.redhat.com (Postfix) with SMTP id 411BA5C1BB;
        Tue, 27 Oct 2020 19:03:45 +0000 (UTC)
Date:   Tue, 27 Oct 2020 20:03:45 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jesper Brouer <jbrouer@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [RFC bpf-next 13/16] libbpf: Add trampoline batch attach support
Message-ID: <20201027190345.GK2900849@krava>
References: <20201022082138.2322434-1-jolsa@kernel.org>
 <20201022082138.2322434-14-jolsa@kernel.org>
 <CAEf4Bzbch2SGNwG-tTUT6pPdDCsFyGPbS1Zkx4f6-nLmcv+wOA@mail.gmail.com>
 <20201025191147.GC2681365@krava>
 <CAEf4BzaJByux3tJ=r47pj4SSzbDEShTW6yBVJg+g1sWsLerdbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaJByux3tJ=r47pj4SSzbDEShTW6yBVJg+g1sWsLerdbQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 04:15:48PM -0700, Andrii Nakryiko wrote:
> On Sun, Oct 25, 2020 at 12:12 PM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Fri, Oct 23, 2020 at 01:09:26PM -0700, Andrii Nakryiko wrote:
> > > On Thu, Oct 22, 2020 at 2:03 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > > >
> > > > Adding trampoline batch attach support so it's possible to use
> > > > batch mode to load tracing programs.
> > > >
> > > > Adding trampoline_attach_batch bool to struct bpf_object_open_opts.
> > > > When set to true the bpf_object__attach_skeleton will try to load
> > > > all tracing programs via batch mode.
> > > >
> > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > > ---
> > >
> > > Assuming we go with the current kernel API for batch-attach, why can't
> > > libbpf just detect kernel support for it and just use it always,
> > > without requiring users to opt into anything?
> >
> > yea, it's rfc ;-) I wanted some simple usage of the
> > interface so it's obvious how it works
> >
> > if we'll end up with some batch interface I agree
> > we should use it as you suggested
> >
> > >
> > > But I'm also confused a bit how this is supposed to be used with BPF
> > > skeleton. You use case described in a cover letter (bpftrace glob
> > > attach, right?) would have a single BPF program attached to many
> > > different functions. While here you are trying to collect different
> > > programs and attach each one to its respective kernel function. Do you
> > > expect users to have hundreds of BPF programs in their skeletons? If
> > > not, I don't really see why adding this complexity. What am I missing?
> >
> > AFAIU when you use trampoline program you declare the attach point
> > at the load time, so you actually can't use same program for different
> > kernel functions - which would be great speed up actually, because
> > that's where the rest of the cycles in bpftrace is spent (in that cover
> > letter example) - load/verifier check of all those programs
> 
> Ah, I see, you are right. And yes, I agree, it would be nice to not
> have to clone the BPF program many times to attach to fentry/fexit, if
> the program itself doesn't really change.
> 
> >
> > it's different for kprobe where you hook single kprobe via multiple
> > kprobe perf events to different kernel function
> >
> > >
> > > Now it also seems weird to me for the kernel API to allow attaching
> > > many-to-many BPF programs-to-attach points. One BPF program-to-many
> > > attach points seems like a more sane and common requirement, no?
> >
> > right, but that's the consequence of what I wrote above
> 
> Well, maybe we should get rid of that limitation first ;)
>

I see this as 2 different things.. even when this would be
possible - attach single program to multiple trampolines,
you still need to install those trampolines via ftrace and
you'll end up in this discussion ;-)

jirka

