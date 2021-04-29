Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC02E36E982
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 13:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbhD2LZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 07:25:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52083 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230148AbhD2LZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 07:25:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619695472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2Hrmp60pTQWrZ956xjnp/+jusKgysHgdmxCB+fDAXuY=;
        b=RdP8Mckq3ByCNAUG27u4muYGU7ARZPTbTq4aRFPP5WDKCfB9RTXkahiBgNGvqIAJUjHYa4
        +1i6ZKzdDykBHV9UU9Ylv2P2YAFgV775UBA9OUrARFgSYDg1WimIoifRVfXCQBSKlDSq5R
        0cyv/Aukay9f4anxAULV+jBW+TbZuPo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-cP75KLOLOPOBAS6YB3g0RQ-1; Thu, 29 Apr 2021 07:24:30 -0400
X-MC-Unique: cP75KLOLOPOBAS6YB3g0RQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A41538189C3;
        Thu, 29 Apr 2021 11:24:28 +0000 (UTC)
Received: from krava (unknown [10.40.195.102])
        by smtp.corp.redhat.com (Postfix) with SMTP id F2265100164C;
        Thu, 29 Apr 2021 11:24:25 +0000 (UTC)
Date:   Thu, 29 Apr 2021 13:24:25 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH] bpf: Add deny list of btf ids check for tracing and ext
 programs
Message-ID: <YIqXaet5A1TqtIOD@krava>
References: <20210428161802.771519-1-jolsa@kernel.org>
 <CAEf4BzY8m5v0LY7eC1p-_xHg8yZms5HCS6D5AyRL7uFZfbKkKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzY8m5v0LY7eC1p-_xHg8yZms5HCS6D5AyRL7uFZfbKkKw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 28, 2021 at 12:41:34PM -0700, Andrii Nakryiko wrote:
> On Wed, Apr 28, 2021 at 9:19 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > The recursion check in __bpf_prog_enter and __bpf_prog_exit
> > leaves some (not inlined) functions unprotected:
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
> > Fixing this by adding deny list of btf ids for tracing
> > and ext programs and checking btf id during program
> > verification. Adding above functions to this list.
> >
> > Suggested-by: Alexei Starovoitov <ast@kernel.org>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  kernel/bpf/verifier.c | 15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> >
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 2579f6fbb5c3..4ffd64eaffda 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -13112,6 +13112,17 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
> >         return 0;
> >  }
> >
> > +BTF_SET_START(btf_id_deny)
> > +BTF_ID_UNUSED
> > +#ifdef CONFIG_SMP
> > +BTF_ID(func, migrate_disable)
> > +BTF_ID(func, migrate_enable)
> > +#endif
> > +#if !defined CONFIG_PREEMPT_RCU && !defined CONFIG_TINY_RCU
> > +BTF_ID(func, rcu_read_unlock_strict)
> > +#endif
> > +BTF_SET_END(btf_id_deny)
> > +
> >  static int check_attach_btf_id(struct bpf_verifier_env *env)
> >  {
> >         struct bpf_prog *prog = env->prog;
> > @@ -13171,6 +13182,10 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
> >                 ret = bpf_lsm_verify_prog(&env->log, prog);
> >                 if (ret < 0)
> >                         return ret;
> > +       } else if ((prog->type == BPF_PROG_TYPE_TRACING ||
> > +                   prog->type == BPF_PROG_TYPE_EXT) &&
> 
> BPF_PROG_TYP_EXT can only replace other BPF programs/subprograms, it
> can't replace kernel functions, so the deny list shouldn't be checked
> for them.

right, will send new version

jirka

> 
> > +                  btf_id_set_contains(&btf_id_deny, btf_id)) {
> > +               return -EINVAL;
> >         }
> >
> >         key = bpf_trampoline_compute_key(tgt_prog, prog->aux->attach_btf, btf_id);
> > --
> > 2.30.2
> >
> 

