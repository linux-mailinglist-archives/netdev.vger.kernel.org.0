Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8141E35F374
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 14:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350773AbhDNMUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 08:20:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34392 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350763AbhDNMUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 08:20:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618402790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3y1hOAy8sqIWrq2ANwHfRM7Gn7YUpu0kAsFFge1FT2A=;
        b=Cv0cPROilt6tFadAC2f7teOBodNQuaSScEZX64JUfACi/euCcW+8te3IKaT3PsUL2bVXON
        Szma1fSKHBKt1XJQw3QxFOEk23aYCg+E0n6Djbnm+jyD6W4duc/kQzbRqDAoZfGz6qFEh5
        3m/Ksp2rEahf8Nj7osKS2TKCSBo8P2o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-QpCczH7ANsmv_RI8zJ7YNA-1; Wed, 14 Apr 2021 08:19:48 -0400
X-MC-Unique: QpCczH7ANsmv_RI8zJ7YNA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C0F4319251A2;
        Wed, 14 Apr 2021 12:19:45 +0000 (UTC)
Received: from krava (unknown [10.40.196.56])
        by smtp.corp.redhat.com (Postfix) with SMTP id 7F97C9CA0;
        Wed, 14 Apr 2021 12:19:37 +0000 (UTC)
Date:   Wed, 14 Apr 2021 14:19:36 +0200
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
Subject: Re: [PATCHv2 RFC bpf-next 0/7] bpf: Add support for ftrace probe
Message-ID: <YHbd2CmeoaiLJj7X@krava>
References: <20210413121516.1467989-1-jolsa@kernel.org>
 <CAEf4Bzazst1rBi4=LuP6_FnPXCRYBNFEtDnK3UVBj6Eo6xFNtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzazst1rBi4=LuP6_FnPXCRYBNFEtDnK3UVBj6Eo6xFNtQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 06:04:05PM -0700, Andrii Nakryiko wrote:
> On Tue, Apr 13, 2021 at 7:57 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > hi,
> > sending another attempt on speeding up load of multiple probes
> > for bpftrace and possibly other tools (first post in [1]).
> >
> > This patchset adds support to attach bpf program directly to
> > ftrace probe as suggested by Steven and it speeds up loading
> > for bpftrace commands like:
> >
> >    # bpftrace -e 'kfunc:_raw_spin* { @[probe] = count(); }'
> >    # bpftrace -e 'kfunc:ksys_* { @[probe] = count(); }'
> >
> > Using ftrace with single bpf program for attachment to multiple
> > functions is much faster than current approach, where we need to
> > load and attach program for each probe function.
> >
> 
> Ok, so first of all, I think it's super important to allow fast
> attachment of a single BPF program to multiple kernel functions (I
> call it mass-attachment). I've been recently prototyping a tool
> (retsnoop, [0]) that allows attaching fentry/fexit to multiple
> functions, and not having this feature turned into lots of extra code
> and slow startup/teardown speeds. So we should definitely fix that.
> 
> But I think the approach you've taken is not the best one, even though
> it's a good starting point for discussion.
> 
> First, you are saying function return attachment support is missing,
> but is not needed so far. I actually think that without func return
> the whole feature is extremely limiting. Not being able to measure
> function latency  by tracking enter/exit events is crippling for tons
> of useful applications. So I think this should go with both at the
> same time.
> 
> But guess what, we already have a good BPF infra (BPF trampoline and
> fexit programs) that supports func exit tracing. Additionally, it
> supports the ability to read input arguments *on function exit*, which
> is something that kretprobe doesn't support and which is often a very
> limiting restriction, necessitating complicated logic to trace
> function entry just to store input arguments. It's a killer feature
> and one that makes fexit so much more useful than kretprobe.
> 
> The only problem is that currently we have a 1:1:1 relationship
> between BPF trampoline, BPF program, and kernel function. I think we
> should allow to have a single BPF program, using a single BPF
> trampoline, but being able to attach to multiple kernel functions
> (1:1:N). This will allow to validate BPF program once, allocate only
> one dedicated BPF trampoline, and then (with appropriate attach API)
> attach them in a batch mode.

heya,
I had some initial prototypes trying this way, but always ended up
in complicated code, that's why I turned to ftrace_ops.

let's see if it'll make any sense to you ;-)

1) so let's say we have extra trampoline for the program (which
also seems a bit of waste since there will be just single record
in it, but sure) - this single trampoline can be easily attached
to multiple functions, but what about other trampolines/tools,
that want to trace the same function? we'd need some way for a
function to share/call multiple trampolines - I did not see easy
solution in here so I moved to another way..


2) we keep the trampoline:function relationship to 1:1 and allow
'mass-attachment' program to register in multiple trampolines.
(it needs special hlist node for each attachment, but that's ok)

the problem was that to make this fast, you don't want to attach/detach
program to trampolines one by one, you need to do it in batch,
so you can call ftrace API just once (ftrace API is another problem below)
and doing this in batch mode means, that you need to lock all the
related trampolines and not allow any change in them by another tools,
and that's where I couldn't find any easy solution.. you can't take
a lock for 100 trampolines.. and having some 'master' lock is tricky

another problem is the ftrace API.. to make it fast we either
need to use ftrace_ops or create fast API to ftrace's direct
functions.. and that was rejected last time [1]


3) bpf has support for batch interface already, but only if ftrace
is not in the way..  compile without ftrace is not an option for us,
so I was also thinking about some way to bypass ftrace and allow
any trace engine to own some function.. so whoever takes it first
(ftrace or bpf) can use it, the other one will see -EBUSY and once
the tool is done, the function is free to take


[1] https://lore.kernel.org/bpf/20201022104205.728dd135@gandalf.local.home/#t

> 
> We'll probably have to abandon direct memory read for input arguments,
> but for these mass-attachment scenarios that's rarely needed at all.
> Just allowing to read input args as u64 and providing traced function
> IP would be enough to do a lot. BPF trampoline can just
> unconditionally save the first 6 arguments, similarly how we do it
> today for a specific BTF function, just always 6.

yes, we don't need arguments just function ip/id to tell what
function we just trace

> 
> As for attachment, dedicating an entire new FD for storing functions
> seems like an overkill. I think BPF_LINK_CREATE is the right place to
> do this, providing an array of BTF IDs to identify all functions to be
> attached to. It's both simple and efficient.

that fd can be closed right after link is created ;-)

I used it because it seemed simpler than the array approach,
and also for the ftrace_location check when adding the function
to the object - so you know it's under ftrace - when it passed,
the attach will most likely pass as well - so tools is just adding
IDs and the objects keeps only the good ones ;-)

but that ftrace_location info can be found in user space as well,
so it's definitely possible to prepare 'good' BTF IDs in userspace
and use array

> 
> We'll get to libbpf APIs and those pseudo-regexp usage a bit later, I
> don't think we need to discuss that at this stage yet :)
> 
> So, WDYT about BPF trampoline-based generic fentry/fexit with mass-attach API?

I'll double check the ftrace graph support for ftrace_ops ;-)

let's see if we could find some solutions for the problems I
described above.. or most likely another better way to do this,
that'd be great

> 
>   [0] https://github.com/anakryiko/retsnoop

nice tool, could it be also part of bcc?

thanks,
jirka

> 
> > Also available in
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
> >   bpf/ftrace
> >
> > thanks,
> > jirka
> >
> >
> > [1] https://lore.kernel.org/bpf/20201022082138.2322434-1-jolsa@kernel.org/
> > ---
> > Jiri Olsa (7):
> >       bpf: Move bpf_prog_start/end functions to generic place
> >       bpf: Add bpf_functions object
> >       bpf: Add support to attach program to ftrace probe
> >       libbpf: Add btf__find_by_pattern_kind function
> >       libbpf: Add support to load and attach ftrace probe
> >       selftests/bpf: Add ftrace probe to fentry test
> >       selftests/bpf: Add ftrace probe test
> >
> >  include/uapi/linux/bpf.h                             |   8 ++++
> >  kernel/bpf/syscall.c                                 | 381 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  kernel/bpf/trampoline.c                              |  97 ---------------------------------------
> >  kernel/bpf/verifier.c                                |  27 +++++++++++
> >  net/bpf/test_run.c                                   |   1 +
> >  tools/include/uapi/linux/bpf.h                       |   8 ++++
> >  tools/lib/bpf/bpf.c                                  |  12 +++++
> >  tools/lib/bpf/bpf.h                                  |   5 +-
> >  tools/lib/bpf/btf.c                                  |  67 +++++++++++++++++++++++++++
> >  tools/lib/bpf/btf.h                                  |   3 ++
> >  tools/lib/bpf/libbpf.c                               |  74 ++++++++++++++++++++++++++++++
> >  tools/lib/bpf/libbpf.map                             |   1 +
> >  tools/testing/selftests/bpf/prog_tests/fentry_test.c |   5 +-
> >  tools/testing/selftests/bpf/prog_tests/ftrace_test.c |  48 +++++++++++++++++++
> >  tools/testing/selftests/bpf/progs/fentry_test.c      |  16 +++++++
> >  tools/testing/selftests/bpf/progs/ftrace_test.c      |  17 +++++++
> >  16 files changed, 671 insertions(+), 99 deletions(-)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/ftrace_test.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/ftrace_test.c
> >
> 

