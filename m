Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8BD374A06
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 23:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhEEVTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 17:19:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54115 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229893AbhEEVT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 17:19:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620249512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=klrjlzRftn/OLDoz6CbNP764fYwi7ksJGFLpycvEPzA=;
        b=gQVC3B/+ZbXPhjFaPK7GJG69wGySeumFE4HgJLJufjmLdLXLtCW39lXwJigrk9VtLTUiXy
        6FhMxjZddLho2Qz6KvMMeR1oAukcV5X19WInQ3cecUDMonGLxOadEyuYXgAhO2iXU4ivH6
        opPksVU57/4Gw9Lu8P/g8l3dB7vTldI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-BsUKAOmOP5CS8yXUw9pwDw-1; Wed, 05 May 2021 17:18:28 -0400
X-MC-Unique: BsUKAOmOP5CS8yXUw9pwDw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89AC18042A8;
        Wed,  5 May 2021 21:18:26 +0000 (UTC)
Received: from krava (unknown [10.40.192.93])
        by smtp.corp.redhat.com (Postfix) with SMTP id 09A5B10246F1;
        Wed,  5 May 2021 21:18:23 +0000 (UTC)
Date:   Wed, 5 May 2021 23:18:23 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [RFC] bpf: Fix crash on mm_init trampoline attachment
Message-ID: <YJMLn/xaybHKyA+r@krava>
References: <20210430134754.179242-1-jolsa@kernel.org>
 <CAEf4BzbEjvccUDabpTiPOiXK=vfcmHaXjeaTL8gCr08=6fBqhg@mail.gmail.com>
 <YJFM/iLKb1EWCYEx@krava>
 <CAEf4BzbY24gFqCORLiAFpSjrv_TUPMwvGzn96hGtk+eYVDnbSQ@mail.gmail.com>
 <CAADnVQKE-jXi22mrOvEX_PpjK5vxNrb6m6-G71iP5ih+R5svqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQKE-jXi22mrOvEX_PpjK5vxNrb6m6-G71iP5ih+R5svqA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 04, 2021 at 09:42:49PM -0700, Alexei Starovoitov wrote:
> On Tue, May 4, 2021 at 5:36 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, May 4, 2021 at 6:32 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > On Mon, May 03, 2021 at 03:45:28PM -0700, Andrii Nakryiko wrote:
> > > > On Fri, Apr 30, 2021 at 6:48 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > > > >
> > > > > There are 2 mm_init functions in kernel.
> > > > >
> > > > > One in kernel/fork.c:
> > > > >   static struct mm_struct *mm_init(struct mm_struct *mm,
> > > > >                                    struct task_struct *p,
> > > > >                                    struct user_namespace *user_ns)
> > > > >
> > > > > And another one in init/main.c:
> > > > >   static void __init mm_init(void)
> > > > >
> > > > > The BTF data will get the first one, which is most likely
> > > > > (in my case) mm_init from init/main.c without arguments.
> 
> did you hack pahole in some way to get to this point?
> I don't see this with pahole master.
> mm_init in BTF matches the one in init/main.c. The void one.
> Do you have two static mm_init-s in BTF somehow?

I have only one mm_init in BTF from init/main.c like you,
but the address in kallsyms is for the mm_init from kernel/fork.c

so we attach mm_init from kernel/fork.c with prototype from init/main.c

I'm seeing same problem also for 'receive_buf' function, which I did not post

> 
> In general it's possible to have different static funcs with the same
> name in kallsyms. I found 3 'seq_start' in my .config.
> So renaming static funcs is not an option.
> The simplest approach for now is to avoid emitting BTF
> if there is more than one func (that will prevent attaching because
> there won't be any BTF for that func).

sounds good.. will prepare the pahole change

> Long term I think BTF can store the .text offset and the verifier
> can avoid kallsym lookup.
> We do store insn_off in bpf_func_info for bpf progs.
> Something like this could be done for kernel and module funcs.
> But that's long term.
> 

ok, will check on this

jirka

