Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0CAA24A7AB
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 22:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgHSUXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 16:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgHSUXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 16:23:37 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E557C061757;
        Wed, 19 Aug 2020 13:23:37 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id i10so14000419ybt.11;
        Wed, 19 Aug 2020 13:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cgctNDzTiUDyWoK2BE1O29xJ1zZR6h3UU06FVz042TU=;
        b=haTPxNLtVa7Kg15tdp5IiLxjwWPFePsTN8bzZka26oskN2hr+yxdjorBwM6LMPvRUX
         Xsp9FI/+o2Uq8H29Hlx6p0rn4voVJ6itkcWhlip/onodRMI4eZYrBXBMT2O5WUjG2j8U
         sJosjKesdr53kvirfDaYmRQ9o4+1UhfD9+uB2xO1zxBdW8VpK/ymVQmMSYA1X7Lkn49O
         AWWC4T6vlPLhMzuVciCCUYNp0oTnUZEzKSY+cVtdDSWMHFQMoPU3Vn6elsXh+GDie7tJ
         iOesmCIKiNQmD/cU6vVulEFyjL6hTfPkNNzfuh8EzORHzwXpFoTtqC0EK0yMJiGXKdMK
         QH+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cgctNDzTiUDyWoK2BE1O29xJ1zZR6h3UU06FVz042TU=;
        b=JP+Al3O/QvRJWyYCrPJ/wgYDqPbxQ+uH/WX2YrOVrDCb3SlVtdSDlxRdz5jlcywf3f
         nQ7lM+Vy3sQVLKVDgTKERNukFsnmH4KtQxRJEd0cAouALcMM3KCAIUunvIlewl5em6K5
         JfKfP5x0mRmbPAnzDfKPhUSTnBs+fWB0MxSsEL5oNeUj/6CQazpUlPOJ9fRJBSvt3Er9
         kPI1InPClOPkP0WP9b4AYtZlB4cU6L3JIFNcid6XIcYMl5WvDAq+YBnr05BovwKsFZ3a
         NuuTOc/XVAo1WYUoGmf4/hgpiStkYbLJFWUno2L63t8ALw19+DLkRc/tSysHoCnpyejY
         fGWQ==
X-Gm-Message-State: AOAM533j59yQvHO4vC3ggbbXCEyRofBrbmFbsFD8pRpdCOivtWjYqA5O
        0PSWPDT7coJmU0824v1tjlCNziwnY8RxXDTGsGQ=
X-Google-Smtp-Source: ABdhPJy7sK3pkx9KxSVgxSSo9T6zfdX/Hi73pPBp9PavbQCPS8D0fQOmlnT/hoiBT7AFvdgNray4/hPtvyWIIs9k1ec=
X-Received: by 2002:a25:824a:: with SMTP id d10mr240850ybn.260.1597868616268;
 Wed, 19 Aug 2020 13:23:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200818213356.2629020-1-andriin@fb.com> <20200818213356.2629020-5-andriin@fb.com>
 <e37c5162-3c94-4c73-d598-f2a048b2ff27@fb.com> <CAEf4BzZ8y=fFBhwP_+owtYA45WNaa324OVftUF3jW-=Mgy45Yw@mail.gmail.com>
 <CAADnVQLkAMqv0BC13=Z2U241a7EbeecAdTmwT9PCVRQiMEv=Sg@mail.gmail.com>
In-Reply-To: <CAADnVQLkAMqv0BC13=Z2U241a7EbeecAdTmwT9PCVRQiMEv=Sg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 19 Aug 2020 13:23:25 -0700
Message-ID: <CAEf4BzbXwU2pSjA3VvpnpeyX8a_yNkQHKy4MQbeWfJTLfE7xxg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/7] libbpf: sanitize BPF program code for bpf_probe_read_{kernel,user}[_str]
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 19, 2020 at 1:15 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Aug 19, 2020 at 1:13 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Aug 18, 2020 at 6:42 PM Yonghong Song <yhs@fb.com> wrote:
> > >
> > >
> > >
> > > On 8/18/20 2:33 PM, Andrii Nakryiko wrote:
> > > > Add BPF program code sanitization pass, replacing calls to BPF
> > > > bpf_probe_read_{kernel,user}[_str]() helpers with bpf_probe_read[_str](), if
> > > > libbpf detects that kernel doesn't support new variants.
> > >
> > > I know this has been merged. The whole patch set looks good to me.
> > > A few nit or questions below.
> > >
> > > >
> > > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > > ---
> > > >   tools/lib/bpf/libbpf.c | 80 ++++++++++++++++++++++++++++++++++++++++++
> > > >   1 file changed, 80 insertions(+)
> > > >
> > > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > > index ab0c3a409eea..bdc08f89a5c0 100644
> > > > --- a/tools/lib/bpf/libbpf.c
> > > > +++ b/tools/lib/bpf/libbpf.c
> > > > @@ -180,6 +180,8 @@ enum kern_feature_id {
> > > >       FEAT_ARRAY_MMAP,
> > > >       /* kernel support for expected_attach_type in BPF_PROG_LOAD */
> > > >       FEAT_EXP_ATTACH_TYPE,
> > > > +     /* bpf_probe_read_{kernel,user}[_str] helpers */
> > > > +     FEAT_PROBE_READ_KERN,
> > > >       __FEAT_CNT,
> > > >   };
> > > >
> > > > @@ -3591,6 +3593,27 @@ static int probe_kern_exp_attach_type(void)
> > > >       return probe_fd(bpf_load_program_xattr(&attr, NULL, 0));
> > > >   }
> > > >
> > > [...]
> > > >
> > > > +static bool insn_is_helper_call(struct bpf_insn *insn, enum bpf_func_id *func_id)
> > > > +{
> > > > +     __u8 class = BPF_CLASS(insn->code);
> > > > +
> > > > +     if ((class == BPF_JMP || class == BPF_JMP32) &&
> > >
> > > Do we support BPF_JMP32 + BPF_CALL ... as a helper call?
> > > I am not aware of this.
> >
> > Verifier seems to support both. Check do_check in
> > kernel/bpf/verifier.c, around line 9000. So I decided to also support
> > it, even if Clang doesn't emit it (yet?).
>
> please check few lines below 9000 ;)
> jmp32 | call is rejected.
> I would remove that from libbpf as well.

I've stared at that condition multiple times and didn't notice the
"class == BPF_JMP32" part... Yeah, sure, I'll drop that, of course.
