Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759FE360B42
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 16:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbhDOOBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 10:01:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21352 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233332AbhDOOBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 10:01:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618495237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7ZADjYvZPgffXHwepn6I/id7gQYL5ZurPv2O+3Y1vLM=;
        b=Th2llDtje30g1Z+rOs/wTNUqC25o1MCTj9cGNS5hI5jIdXaE5l3GXvaVPqYLLbJIACpsTE
        LBDcx7HuSLSyFJ0K97HEYsMmrus/H8DLB9dEZ8T9Apvb1I2duLc0x1ZQC06bjlCHKdDqW4
        FU8W0XrxZ6Egi7UaEydcwYKFrSavuRo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-rzKdtmDnOzGU8qei-nIt5w-1; Thu, 15 Apr 2021 10:00:35 -0400
X-MC-Unique: rzKdtmDnOzGU8qei-nIt5w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56808C73A9;
        Thu, 15 Apr 2021 14:00:33 +0000 (UTC)
Received: from krava (unknown [10.40.196.6])
        by smtp.corp.redhat.com (Postfix) with SMTP id 1F6456064B;
        Thu, 15 Apr 2021 14:00:25 +0000 (UTC)
Date:   Thu, 15 Apr 2021 16:00:25 +0200
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
Message-ID: <YHhG+dCWguqcl6FT@krava>
References: <20210413121516.1467989-1-jolsa@kernel.org>
 <CAEf4Bzazst1rBi4=LuP6_FnPXCRYBNFEtDnK3UVBj6Eo6xFNtQ@mail.gmail.com>
 <YHbd2CmeoaiLJj7X@krava>
 <CAEf4BzYyVj-Tjy9ZZdAU5nOtJ8_auvVobTT6pMqg8zPb9jj-Ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYyVj-Tjy9ZZdAU5nOtJ8_auvVobTT6pMqg8zPb9jj-Ow@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 03:46:49PM -0700, Andrii Nakryiko wrote:
> On Wed, Apr 14, 2021 at 5:19 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Tue, Apr 13, 2021 at 06:04:05PM -0700, Andrii Nakryiko wrote:
> > > On Tue, Apr 13, 2021 at 7:57 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > > >
> > > > hi,
> > > > sending another attempt on speeding up load of multiple probes
> > > > for bpftrace and possibly other tools (first post in [1]).
> > > >
> > > > This patchset adds support to attach bpf program directly to
> > > > ftrace probe as suggested by Steven and it speeds up loading
> > > > for bpftrace commands like:
> > > >
> > > >    # bpftrace -e 'kfunc:_raw_spin* { @[probe] = count(); }'
> > > >    # bpftrace -e 'kfunc:ksys_* { @[probe] = count(); }'
> > > >
> > > > Using ftrace with single bpf program for attachment to multiple
> > > > functions is much faster than current approach, where we need to
> > > > load and attach program for each probe function.
> > > >
> > >
> > > Ok, so first of all, I think it's super important to allow fast
> > > attachment of a single BPF program to multiple kernel functions (I
> > > call it mass-attachment). I've been recently prototyping a tool
> > > (retsnoop, [0]) that allows attaching fentry/fexit to multiple
> > > functions, and not having this feature turned into lots of extra code
> > > and slow startup/teardown speeds. So we should definitely fix that.
> > >
> > > But I think the approach you've taken is not the best one, even though
> > > it's a good starting point for discussion.
> > >
> > > First, you are saying function return attachment support is missing,
> > > but is not needed so far. I actually think that without func return
> > > the whole feature is extremely limiting. Not being able to measure
> > > function latency  by tracking enter/exit events is crippling for tons
> > > of useful applications. So I think this should go with both at the
> > > same time.
> > >
> > > But guess what, we already have a good BPF infra (BPF trampoline and
> > > fexit programs) that supports func exit tracing. Additionally, it
> > > supports the ability to read input arguments *on function exit*, which
> > > is something that kretprobe doesn't support and which is often a very
> > > limiting restriction, necessitating complicated logic to trace
> > > function entry just to store input arguments. It's a killer feature
> > > and one that makes fexit so much more useful than kretprobe.
> > >
> > > The only problem is that currently we have a 1:1:1 relationship
> > > between BPF trampoline, BPF program, and kernel function. I think we
> > > should allow to have a single BPF program, using a single BPF
> > > trampoline, but being able to attach to multiple kernel functions
> > > (1:1:N). This will allow to validate BPF program once, allocate only
> > > one dedicated BPF trampoline, and then (with appropriate attach API)
> > > attach them in a batch mode.
> >
> > heya,
> > I had some initial prototypes trying this way, but always ended up
> > in complicated code, that's why I turned to ftrace_ops.
> >
> > let's see if it'll make any sense to you ;-)
> >
> > 1) so let's say we have extra trampoline for the program (which
> > also seems a bit of waste since there will be just single record
> 
> BPF trampoline does more than just calls BPF program. At the very
> least it saves input arguments for fexit program to be able to access
> it. But given it's one BPF trampoline attached to thousands of
> functions, I don't see any problem there.
> 
> > in it, but sure) - this single trampoline can be easily attached
> > to multiple functions, but what about other trampolines/tools,
> > that want to trace the same function? we'd need some way for a
> > function to share/call multiple trampolines - I did not see easy
> > solution in here so I moved to another way..
> 
> The easiest would be to make the existing BPF trampoline to co-exist
> with this new multi-attach one. As to how, I don't know the code well
> enough yet to answer specifically.

I did not explore this possibility, because it seemed too
complicated ;-) I'll see if I can come up with something,
that we could start discussion for, so:

  - new trampoline type that would attach single program
    to multiple functions
  - it needs to 'co-exist' with current trampolines so
    both types could be attached to same function

> 
> >
> >
> > 2) we keep the trampoline:function relationship to 1:1 and allow
> > 'mass-attachment' program to register in multiple trampolines.
> > (it needs special hlist node for each attachment, but that's ok)
> >
> > the problem was that to make this fast, you don't want to attach/detach
> > program to trampolines one by one, you need to do it in batch,
> > so you can call ftrace API just once (ftrace API is another problem below)
> > and doing this in batch mode means, that you need to lock all the
> > related trampolines and not allow any change in them by another tools,
> > and that's where I couldn't find any easy solution.. you can't take
> > a lock for 100 trampolines.. and having some 'master' lock is tricky
> 
> So this generic fentry would have its own BPF trampoline. Now you need
> to attach it to 1000s of places with a single batch API call. We won't
> have to modify 100s of other BPF trampolines, if we can find a good
> way to let them co-exist.
> 
> 
> >
> > another problem is the ftrace API.. to make it fast we either
> > need to use ftrace_ops or create fast API to ftrace's direct
> > functions.. and that was rejected last time [1]
> 
> I don't read it as a rejection, just that ftrace infra needs to be
> improved to support. In any case, I haven't spent enough time thinking
> and digging through code, but I know that without fexit support this
> feature is useless in a lot of cases. And input argument reading in
> fexit is too good to give up at this point either.
> 
> >
> >
> > 3) bpf has support for batch interface already, but only if ftrace
> 
> It does? What is it? Last time I looked I didn't find anything like that.

trampolines uses text_poke_bp function (when ftrace is not compiled in
or the function is not ftrace-managed)

text_poke_bp is wrapper for text_poke_bp_batch to change 1 location,
text_poke_bp_batch allows to change more than one place with:

   text_poke_queue
   text_poke_queue
   ...
   text_poke_finish -> text_poke_flush -> text_poke_bp_batch

thanks,
jirka

