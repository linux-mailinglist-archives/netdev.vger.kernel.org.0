Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADEF52D63B
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 16:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239870AbiESOhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 10:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239803AbiESOhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 10:37:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2EAB79808C
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 07:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652971033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nuigQAW97z185pYVkfJOlg+wlqI3p7gPUl8yWY860tc=;
        b=FWeWC6dXfoAM0Kb1zQf2ifuNz3IstonhRSVQlf+HM5MRmu+3/vuVCEN14Efsun7U/OkDLa
        jFcuFeCE1CO3ETUAmJCfEBew/S71T5n7bwvVt1GluIu/MnRIyMiwAwE48eoOlRz9kSqvAG
        oXs/jCO60eWBZ5HFluAKNItojjn9XrI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-aO_ejIWoMNWNrp0QQQ9UdQ-1; Thu, 19 May 2022 10:37:10 -0400
X-MC-Unique: aO_ejIWoMNWNrp0QQQ9UdQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E8D53833295;
        Thu, 19 May 2022 14:37:09 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 337F67774;
        Thu, 19 May 2022 14:37:05 +0000 (UTC)
Date:   Thu, 19 May 2022 16:37:02 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 1/4] bpf_trace: check size for overflow in
 bpf_kprobe_multi_link_attach
Message-ID: <20220519143702.GA22773@asgard.redhat.com>
References: <cover.1652772731.git.esyr@redhat.com>
 <9e4171972a3d75e656073e0c25cd4071a6f652e4.1652772731.git.esyr@redhat.com>
 <CAEf4BzYpNZSY+D6_QP4NE2dN25g4wD43UmJyzmqXCL=HOE9HFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYpNZSY+D6_QP4NE2dN25g4wD43UmJyzmqXCL=HOE9HFA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 04:30:14PM -0700, Andrii Nakryiko wrote:
> On Tue, May 17, 2022 at 12:36 AM Eugene Syromiatnikov <esyr@redhat.com> wrote:
> >
> > Check that size would not overflow before calculation (and return
> > -EOVERFLOW if it will), to prevent potential out-of-bounds write
> > with the following copy_from_user.  Use kvmalloc_array
> > in copy_user_syms to prevent out-of-bounds write into syms
> > (and especially buf) as well.
> >
> > Fixes: 0dcac272540613d4 ("bpf: Add multi kprobe link")
> > Cc: <stable@vger.kernel.org> # 5.18
> > Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
> > ---
> >  kernel/trace/bpf_trace.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index 7141ca8..9c041be 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -2261,11 +2261,11 @@ static int copy_user_syms(struct user_syms *us, unsigned long __user *usyms, u32
> >         int err = -ENOMEM;
> >         unsigned int i;
> >
> > -       syms = kvmalloc(cnt * sizeof(*syms), GFP_KERNEL);
> > +       syms = kvmalloc_array(cnt, sizeof(*syms), GFP_KERNEL);
> >         if (!syms)
> >                 goto error;
> >
> > -       buf = kvmalloc(cnt * KSYM_NAME_LEN, GFP_KERNEL);
> > +       buf = kvmalloc_array(cnt, KSYM_NAME_LEN, GFP_KERNEL);
> >         if (!buf)
> >                 goto error;
> >
> > @@ -2461,7 +2461,8 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
> >         if (!cnt)
> >                 return -EINVAL;
> >
> > -       size = cnt * sizeof(*addrs);
> > +       if (check_mul_overflow(cnt, (u32)sizeof(*addrs), &size))
> > +               return -EOVERFLOW;
> >         addrs = kvmalloc(size, GFP_KERNEL);
> 
> any good reason not to use kvmalloc_array() here as well and delegate
> overflow to it. And then use long size (as expected by copy_from_user
> anyway) everywhere?

Just to avoid double calculation of size, otherwise I don't have
any significant prefernce, other than -EOVERFLOW would not be reported
separately (not sure if this a good or a bad thing), and that
it would be a bit more cumbersome to incorporate the Yonghong's
suggestion[1] about the INT_MAX check.

[1] https://lore.kernel.org/lkml/412bf136-6a5b-f442-1e84-778697e2b694@fb.com/

> >         if (!addrs)
> >                 return -ENOMEM;
> > --
> > 2.1.4
> >
> 

