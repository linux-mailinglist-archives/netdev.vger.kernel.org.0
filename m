Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE80B3A15B7
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 15:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236400AbhFINfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 09:35:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24893 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236336AbhFINfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 09:35:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623245623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ym1naShMb/FjUs80jLgteJ3jD85pxMGWwBsQDwktStk=;
        b=XcG/2lV21nmQQP5mnCH0jk/uX0tX2I+JunG3wqTlbqIkMt74Mb1+bwuoZb178B6lJyOYVV
        NhzauHAx72dCq80ARXDCIlA+sAj9ngXRIuVMsYPsYXnhMQiz+TAEpoCZm3htK/NQ3xbPY1
        cv+FOuLbjHBAW9ZD7dvChbSTxukJu+I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-bsp-ZMP3P1m4y1oE8edkQQ-1; Wed, 09 Jun 2021 09:33:42 -0400
X-MC-Unique: bsp-ZMP3P1m4y1oE8edkQQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0ED61100B3AF;
        Wed,  9 Jun 2021 13:33:40 +0000 (UTC)
Received: from krava (unknown [10.40.195.97])
        by smtp.corp.redhat.com (Postfix) with SMTP id 85F2060BD8;
        Wed,  9 Jun 2021 13:33:36 +0000 (UTC)
Date:   Wed, 9 Jun 2021 15:33:35 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCH 13/19] bpf: Add support to link multi func tracing program
Message-ID: <YMDDL9vNBysi3wfp@krava>
References: <20210605111034.1810858-1-jolsa@kernel.org>
 <20210605111034.1810858-14-jolsa@kernel.org>
 <CAADnVQJV+0SjqUrTw+3Y02tFedcAaPKJS-W8sQHw5YT4XUW0hQ@mail.gmail.com>
 <YL+0HLQ9oSrNM7ip@krava>
 <20210608184903.rgnv65jimekqugol@ast-mbp.dhcp.thefacebook.com>
 <YL/cIBArrCjhgyXt@krava>
 <CAADnVQ+zEdv8BfNHGYO=xi-ePwfoKQUd_yxmRB3jHByPmYxCWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQ+zEdv8BfNHGYO=xi-ePwfoKQUd_yxmRB3jHByPmYxCWw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 08, 2021 at 04:05:29PM -0700, Alexei Starovoitov wrote:
> On Tue, Jun 8, 2021 at 2:07 PM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Tue, Jun 08, 2021 at 11:49:03AM -0700, Alexei Starovoitov wrote:
> > > On Tue, Jun 08, 2021 at 08:17:00PM +0200, Jiri Olsa wrote:
> > > > On Tue, Jun 08, 2021 at 08:42:32AM -0700, Alexei Starovoitov wrote:
> > > > > On Sat, Jun 5, 2021 at 4:11 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > > > > >
> > > > > > Adding support to attach multiple functions to tracing program
> > > > > > by using the link_create/link_update interface.
> > > > > >
> > > > > > Adding multi_btf_ids/multi_btf_ids_cnt pair to link_create struct
> > > > > > API, that define array of functions btf ids that will be attached
> > > > > > to prog_fd.
> > > > > >
> > > > > > The prog_fd needs to be multi prog tracing program (BPF_F_MULTI_FUNC).
> > > > > >
> > > > > > The new link_create interface creates new BPF_LINK_TYPE_TRACING_MULTI
> > > > > > link type, which creates separate bpf_trampoline and registers it
> > > > > > as direct function for all specified btf ids.
> > > > > >
> > > > > > The new bpf_trampoline is out of scope (bpf_trampoline_lookup) of
> > > > > > standard trampolines, so all registered functions need to be free
> > > > > > of direct functions, otherwise the link fails.
> > > > >
> > > > > Overall the api makes sense to me.
> > > > > The restriction of multi vs non-multi is too severe though.
> > > > > The multi trampoline can serve normal fentry/fexit too.
> > > >
> > > > so multi trampoline gets called from all the registered functions,
> > > > so there would need to be filter for specific ip before calling the
> > > > standard program.. single cmp/jnz might not be that bad, I'll check
> > >
> > > You mean reusing the same multi trampoline for all IPs and regenerating
> > > it with a bunch of cmp/jnz checks? There should be a better way to scale.
> > > Maybe clone multi trampoline instead?
> > > IPs[1-10] will point to multi.
> > > IP[11] will point to a clone of multi that serves multi prog and
> > > fentry/fexit progs specific for that IP.
> >
> > ok, so we'd clone multi trampoline if there's request to attach
> > standard trampoline to some IP from multi trampoline
> >
> > .. and transform currently attached standard trampoline for IP
> > into clone of multi trampoline, if there's request to create
> > multi trampoline that covers that IP
> 
> yep. For every IP==btf_id there will be only two possible trampolines.
> Should be easy enough to track and transition between them.
> The standard fentry/fexit will only get negligible slowdown from
> going through multi.
> multi+fexit and fmod_ret needs to be thought through as well.
> That's why I thought that 'ip' at the end should simplify things.
> Only multi will have access to it.
> But we can store it first too. fentry/fexit will see ctx=r1 with +8 offset
> and will have normal args in ctx. Like ip isn't even there.
> While multi trampoline is always doing ip, arg1,arg2, .., arg6
> and passes ctx = &ip into multi prog and ctx = &arg1 into fentry/fexit.
> 'ret' for fexit is problematic though. hmm.
> Maybe such clone multi trampoline for specific ip with 2 args will do:
> ip, arg1, arg2, ret, 0, 0, 0, ret.

we could call multi progs first and setup new args
and call non-multi progs with that

jirka

> Then multi will have 6 args, though 3rd is actually ret.
> Then fexit will have ret in the right place and multi prog will have
> it as 7th arg.
> 

