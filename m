Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0574D239C48
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 23:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbgHBVwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 17:52:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23881 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726988AbgHBVwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 17:52:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596405124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=52YrAGsMm86F8tDDrhoSNESMd7vkOsJ5D+tkoIF8gVQ=;
        b=eBd5rtNv7B5/hNS7r8S0PxMENN4BzxNgvfLRdJPY4cxzWjyT4fAc8K7C3p284xW6Cq/5Rl
        NWS6tFAfmdglcNcVoWmJUN325cv5csoHb7OjJS3c878Uzk0TI79aP0xsNvVtAmrTKyZjOt
        ZcR9aeCj4IhVZxQGgVaX2wh7/RMVFTs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-dlsyN5QAMcOe1Ak3zhWAQQ-1; Sun, 02 Aug 2020 17:52:00 -0400
X-MC-Unique: dlsyN5QAMcOe1Ak3zhWAQQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB3D758;
        Sun,  2 Aug 2020 21:51:58 +0000 (UTC)
Received: from krava (unknown [10.40.192.18])
        by smtp.corp.redhat.com (Postfix) with SMTP id 9B9B210013C1;
        Sun,  2 Aug 2020 21:51:56 +0000 (UTC)
Date:   Sun, 2 Aug 2020 23:51:55 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH bpf-next] tools build: propagate build failures from
 tools/build/Makefile.build
Message-ID: <20200802215155.GB139381@krava>
References: <20200731024244.872574-1-andriin@fb.com>
 <20200802161106.GA127459@krava>
 <CAEf4Bzb=LBGsORPCh90=PF=WL+rdOKiBf8yDfJNwd8p2AKUK1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzb=LBGsORPCh90=PF=WL+rdOKiBf8yDfJNwd8p2AKUK1A@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 02, 2020 at 11:22:07AM -0700, Andrii Nakryiko wrote:
> On Sun, Aug 2, 2020 at 9:11 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Thu, Jul 30, 2020 at 07:42:44PM -0700, Andrii Nakryiko wrote:
> > > The '&&' command seems to have a bad effect when $(cmd_$(1)) exits with
> > > non-zero effect: the command failure is masked (despite `set -e`) and all but
> > > the first command of $(dep-cmd) is executed (successfully, as they are mostly
> > > printfs), thus overall returning 0 in the end.
> >
> > nice, thanks for digging into this,
> > any idea why is the failure masked?
> 
> Two things.
> 
> 1. In make, assume you have command f = a in one function and g = b; c
> in another. If you write f && g, you end up with (a && b); c, right?
> 
> 2. Try this shell script:
> 
> set -ex
> false && true
> true
> 
> It will return success. It won't execute the first true command, as
> expected, but won't terminate the shell as you'd expect from set -e.
> 
> So basically, having a "logical operator" in a sequence of commands
> negates the effect of `set -e`. Intuitively I'd expect that from ||,
> but seems like && does that as well. if [] has similar effect -- any
> failing command in an if check doesn't trigger an early termination of
> a script.

nice, thanks for explanation

jirka

> 
> >
> > Acked-by: Jiri Olsa <jolsa@redhat.com>
> >
> > jirka
> >
> > >
> > > This means in practice that despite compilation errors, tools's build Makefile
> > > will return success. We see this very reliably with libbpf's Makefile, which
> > > doesn't get compilation error propagated properly. This in turns causes issues
> > > with selftests build, as well as bpftool and other projects that rely on
> > > building libbpf.
> > >
> > > The fix is simple: don't use &&. Given `set -e`, we don't need to chain
> > > commands with &&. The shell will exit on first failure, giving desired
> > > behavior and propagating error properly.
> > >
> > > Cc: Jiri Olsa <jolsa@kernel.org>
> > > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > > Fixes: 275e2d95591e ("tools build: Move dependency copy into function")
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > ---
> > >
> > > I'm sending this against bpf-next tree, given libbpf is affected enough for me
> > > to debug this fun problem that no one seemed to notice (or care, at least) in
> > > almost 5 years. If there is a better kernel tree, please let me know.
> > >
> > >  tools/build/Build.include | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/tools/build/Build.include b/tools/build/Build.include
> > > index 9ec01f4454f9..585486e40995 100644
> > > --- a/tools/build/Build.include
> > > +++ b/tools/build/Build.include
> > > @@ -74,7 +74,8 @@ dep-cmd = $(if $(wildcard $(fixdep)),
> > >  #                   dependencies in the cmd file
> > >  if_changed_dep = $(if $(strip $(any-prereq) $(arg-check)),         \
> > >                    @set -e;                                         \
> > > -                  $(echo-cmd) $(cmd_$(1)) && $(dep-cmd))
> > > +                  $(echo-cmd) $(cmd_$(1));                         \
> > > +                  $(dep-cmd))
> > >
> > >  # if_changed      - execute command if any prerequisite is newer than
> > >  #                   target, or command line has changed
> > > --
> > > 2.24.1
> > >
> >
> 

