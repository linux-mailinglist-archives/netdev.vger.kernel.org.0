Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79E6E24A79D
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 22:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgHSUQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 16:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgHSUQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 16:16:00 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9AA4C061757;
        Wed, 19 Aug 2020 13:15:59 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id c15so12750412lfi.3;
        Wed, 19 Aug 2020 13:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xePC5tWQFk10rZ9I7pPcAR7hQMEhWEsraYFUVXFyhu4=;
        b=f9ikmvVOpDDy6zvzvci9P1KduZsWvp5SQZU6lu4xAojkBwg4XwDyGWrqzA5ygBa+En
         hZDDcmOC/LrvQrWGch0ibhfkMjJScoAaTfi2ZyfppYRCfmJnl1hktmms/dyVh9lVeufT
         UOcuwbEPHVv5WlPzeojYTmSwrzCqSTEJCZOwgrhATF9MFk9e52VKWQfO1aRlfL4wFycq
         f0XPA4/zR3VC0vcCvK/kAyhPw9HyZ5kXsKDEoX9wDhzZKRhAA6KDk4zVPGnmh0pVQ/26
         w61NpmiCtMFSnTJgbQUkZ47km6yiA6/POVmA40977jEowNMy2LpPVva6SFvOLGHbZ+5r
         K9yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xePC5tWQFk10rZ9I7pPcAR7hQMEhWEsraYFUVXFyhu4=;
        b=svFnxpUOoEJ2vABh6tLMljJCjt7s3q5gQxx0clLlIrseAh3w0fybIkw8Zf1s/aaiOz
         sttk0aZ/XODapcbH7QK8RtNU2VlsZlDwaztAgnhE7GagvG2/HKNNy9zg2gzY343oaXML
         I+78H2RaxxjjxD6KjuhchLSNJhadYLHwdHLJRio25OCKy5osf49HhJ3JdK3wXFZfnYJr
         CK57lyI9YhsXpXHYSJyvSDnu/O7PHsvclwKWTEoBpWqOMJwAYYSAMN4bYaDuIJVmanU8
         mWHt7E9j/wKgt4m25dZMbRLvIIMIkPpx2pWxA0GKM6J+yndfqKQFcpEu68vi9rH9WHkY
         iaqQ==
X-Gm-Message-State: AOAM532wGp0rYLaOeLsRprFyRTih3mZXmWrgjHmz7JfhJkwBU3mrWr9U
        cMDWpaJLDOMmhKcPyTbghOCU1O/+NT9g51lH38rP00fP
X-Google-Smtp-Source: ABdhPJxrJ74g+H/Tpf8BvpHfeai1Eh4nBaXGsdu1qcZ601EkPlV6Vf3/j3Fs/mJG7DAZ634mtwyr1f8xJNvrAufkn3w=
X-Received: by 2002:a05:6512:3610:: with SMTP id f16mr12837009lfs.8.1597868158219;
 Wed, 19 Aug 2020 13:15:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200818213356.2629020-1-andriin@fb.com> <20200818213356.2629020-5-andriin@fb.com>
 <e37c5162-3c94-4c73-d598-f2a048b2ff27@fb.com> <CAEf4BzZ8y=fFBhwP_+owtYA45WNaa324OVftUF3jW-=Mgy45Yw@mail.gmail.com>
In-Reply-To: <CAEf4BzZ8y=fFBhwP_+owtYA45WNaa324OVftUF3jW-=Mgy45Yw@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 19 Aug 2020 13:15:46 -0700
Message-ID: <CAADnVQLkAMqv0BC13=Z2U241a7EbeecAdTmwT9PCVRQiMEv=Sg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/7] libbpf: sanitize BPF program code for bpf_probe_read_{kernel,user}[_str]
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Wed, Aug 19, 2020 at 1:13 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Aug 18, 2020 at 6:42 PM Yonghong Song <yhs@fb.com> wrote:
> >
> >
> >
> > On 8/18/20 2:33 PM, Andrii Nakryiko wrote:
> > > Add BPF program code sanitization pass, replacing calls to BPF
> > > bpf_probe_read_{kernel,user}[_str]() helpers with bpf_probe_read[_str](), if
> > > libbpf detects that kernel doesn't support new variants.
> >
> > I know this has been merged. The whole patch set looks good to me.
> > A few nit or questions below.
> >
> > >
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > ---
> > >   tools/lib/bpf/libbpf.c | 80 ++++++++++++++++++++++++++++++++++++++++++
> > >   1 file changed, 80 insertions(+)
> > >
> > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > index ab0c3a409eea..bdc08f89a5c0 100644
> > > --- a/tools/lib/bpf/libbpf.c
> > > +++ b/tools/lib/bpf/libbpf.c
> > > @@ -180,6 +180,8 @@ enum kern_feature_id {
> > >       FEAT_ARRAY_MMAP,
> > >       /* kernel support for expected_attach_type in BPF_PROG_LOAD */
> > >       FEAT_EXP_ATTACH_TYPE,
> > > +     /* bpf_probe_read_{kernel,user}[_str] helpers */
> > > +     FEAT_PROBE_READ_KERN,
> > >       __FEAT_CNT,
> > >   };
> > >
> > > @@ -3591,6 +3593,27 @@ static int probe_kern_exp_attach_type(void)
> > >       return probe_fd(bpf_load_program_xattr(&attr, NULL, 0));
> > >   }
> > >
> > [...]
> > >
> > > +static bool insn_is_helper_call(struct bpf_insn *insn, enum bpf_func_id *func_id)
> > > +{
> > > +     __u8 class = BPF_CLASS(insn->code);
> > > +
> > > +     if ((class == BPF_JMP || class == BPF_JMP32) &&
> >
> > Do we support BPF_JMP32 + BPF_CALL ... as a helper call?
> > I am not aware of this.
>
> Verifier seems to support both. Check do_check in
> kernel/bpf/verifier.c, around line 9000. So I decided to also support
> it, even if Clang doesn't emit it (yet?).

please check few lines below 9000 ;)
jmp32 | call is rejected.
I would remove that from libbpf as well.
