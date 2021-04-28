Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E242D36D25C
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 08:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233399AbhD1GpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 02:45:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37248 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230504AbhD1GpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 02:45:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619592270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GcFLtrZTQ66M/cACjXXXvITRn+EI9P5exiJyCgqz4Dc=;
        b=FXjyh1Tgmt49fjoMhza9/KwPOZLlDY0b5hhet75yNeOiW247PbF7h8oedTVy/577Bz1Bji
        cpY47Qv6kmsPN2ULbqB+ruqwIABzLS9hVy4FnxAej3hWguBCZhh65pY1KKWX4LPkXh4XJQ
        XUEYqOius83IfEeU3c2evCHkd8kYuU4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-DQ9ABm1wMruripj_9_KIhQ-1; Wed, 28 Apr 2021 02:44:26 -0400
X-MC-Unique: DQ9ABm1wMruripj_9_KIhQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 566B4818400;
        Wed, 28 Apr 2021 06:44:25 +0000 (UTC)
Received: from krava (unknown [10.40.193.167])
        by smtp.corp.redhat.com (Postfix) with SMTP id B2D2B6BF6B;
        Wed, 28 Apr 2021 06:44:22 +0000 (UTC)
Date:   Wed, 28 Apr 2021 08:44:21 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH] bpf: Fix recursion check in trampoline
Message-ID: <YIkERXWzxGCZDCRc@krava>
References: <20210427224156.708231-1-jolsa@kernel.org>
 <CAADnVQKuBOc-jqaK1H5Usb6PKFWdbBoo8tzVOU2jzXwa1ENd0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQKuBOc-jqaK1H5Usb6PKFWdbBoo8tzVOU2jzXwa1ENd0g@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 27, 2021 at 06:10:32PM -0700, Alexei Starovoitov wrote:
> On Tue, Apr 27, 2021 at 3:42 PM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > The recursion check in __bpf_prog_enter and __bpf_prog_exit leaves
> > some (not inlined) functions unprotected:
> >
> > In __bpf_prog_enter:
> >   - migrate_disable is called before prog->active is checked
> >
> > In __bpf_prog_exit:
> >   - migrate_enable,rcu_read_unlock_strict are called after
> >     prog->active is decreased
> >
> > When attaching trampoline to them we get panic like:
> >
> >   traps: PANIC: double fault, error_code: 0x0
> >   double fault: 0000 [#1] SMP PTI
> >   RIP: 0010:__bpf_prog_enter+0x4/0x50
> >   ...
> >   Call Trace:
> >    <IRQ>
> >    bpf_trampoline_6442466513_0+0x18/0x1000
> >    migrate_disable+0x5/0x50
> >    __bpf_prog_enter+0x9/0x50
> >    bpf_trampoline_6442466513_0+0x18/0x1000
> >    migrate_disable+0x5/0x50
> >    __bpf_prog_enter+0x9/0x50
> >    bpf_trampoline_6442466513_0+0x18/0x1000
> >    migrate_disable+0x5/0x50
> >    __bpf_prog_enter+0x9/0x50
> >    bpf_trampoline_6442466513_0+0x18/0x1000
> >    migrate_disable+0x5/0x50
> >    ...
> >
> > Making the recursion check before the rest of the calls
> > in __bpf_prog_enter and as last call in __bpf_prog_exit.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  kernel/bpf/trampoline.c | 12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> >
> > diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> > index 4aa8b52adf25..301735f7e88e 100644
> > --- a/kernel/bpf/trampoline.c
> > +++ b/kernel/bpf/trampoline.c
> > @@ -558,12 +558,12 @@ static void notrace inc_misses_counter(struct bpf_prog *prog)
> >  u64 notrace __bpf_prog_enter(struct bpf_prog *prog)
> >         __acquires(RCU)
> >  {
> > -       rcu_read_lock();
> > -       migrate_disable();
> >         if (unlikely(__this_cpu_inc_return(*(prog->active)) != 1)) {
> >                 inc_misses_counter(prog);
> >                 return 0;
> >         }
> > +       rcu_read_lock();
> > +       migrate_disable();
> 
> That obviously doesn't work.
> After cpu_inc the task can migrate and cpu_dec
> will happen on a different cpu likely underflowing
> the counter into negative.

ugh right

> We can either mark migrate_disable as nokprobe/notrace or have bpf
> trampoline specific denylist.
> 

I was using notrace to disable that, but that would limit
other tracers.. I'll add bpf denylist

jirka

