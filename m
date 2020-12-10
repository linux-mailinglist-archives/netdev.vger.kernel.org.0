Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF082D6185
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 17:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387796AbgLJQSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 11:18:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33268 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731173AbgLJQRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 11:17:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607616965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tR+QcJGndhq60ixX8jaoR1LgoVq1+PJO8TnsgtbJBGk=;
        b=WNd/FLKDeQHHPkdLvWqmePxslPfiG718Btv+edJHqObUUd8fW5gpWEe9eC1IZoUaMUsZca
        vc/Rw2teoTesJc9TxaXh+cYmb1+NaucBLWP/JypQ2z5b9MSHlpo5gIgPzVUSwRsJ3DAEbx
        7QUCFxh2mQxBNqFPlpekHruYS36UCsw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-khxxPngNPR2AJ0HtOJstQA-1; Thu, 10 Dec 2020 11:16:01 -0500
X-MC-Unique: khxxPngNPR2AJ0HtOJstQA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 397BC180A095;
        Thu, 10 Dec 2020 16:15:59 +0000 (UTC)
Received: from krava (unknown [10.40.192.193])
        by smtp.corp.redhat.com (Postfix) with SMTP id 1128F60862;
        Thu, 10 Dec 2020 16:15:55 +0000 (UTC)
Date:   Thu, 10 Dec 2020 17:15:54 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Jackman <jackmanb@google.com>,
        KP Singh <kpsingh@google.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix selftest compilation on
 clang 11
Message-ID: <20201210161554.GF69683@krava>
References: <20201209142912.99145-1-jolsa@kernel.org>
 <CAEf4BzYBddPaEzRUs=jaWSo5kbf=LZdb7geAUVj85GxLQztuAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYBddPaEzRUs=jaWSo5kbf=LZdb7geAUVj85GxLQztuAQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 09, 2020 at 12:24:23PM -0800, Andrii Nakryiko wrote:
> On Wed, Dec 9, 2020 at 7:16 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > We can't compile test_core_reloc_module.c selftest with clang 11,
> > compile fails with:
> >
> >   CLNG-LLC [test_maps] test_core_reloc_module.o
> >   progs/test_core_reloc_module.c:57:21: error: use of unknown builtin \
> >   '__builtin_preserve_type_info' [-Wimplicit-function-declaration]
> >    out->read_ctx_sz = bpf_core_type_size(struct bpf_testmod_test_read_ctx);
> >
> > Skipping these tests if __builtin_preserve_type_info() is not
> > supported by compiler.
> >
> > Fixes: 6bcd39d366b6 ("selftests/bpf: Add CO-RE relocs selftest relying on kernel module BTF")
> > Fixes: bc9ed69c79ae ("selftests/bpf: Add tp_btf CO-RE reloc test for modules")
> 
> The test isn't really broken, so "Fixes: " tags seem wrong here.
> 
> Given core_relo tests have established `data.skip = true` mechanism,
> I'm fine with this patch. But moving forward I think we should
> minimize the amount of feature-detection and tests skipping in
> selftests. The point of selftests is to test the functionality at the
> intersection of 4 projects: kernel, libbpf, pahole and clang. We've
> stated before and I think it remains true that the expectation for
> anyone that wants to develop and run selftests is to track latests
> versions of all 4 of those, sometimes meaning nightly builds or
> building from sources. For clang, which is arguably the hardest of the
> 4 to build from sources, LLVM project publishes nightly builds for
> Ubuntu and Debian, which are very easy to use to get recent enough
> versions for selftests. That's exactly what libbpf CI is doing, BTW.
> 
> It's hard and time-consuming enough to develop these features, I'd
> rather keep selftests simpler, more manageable, and less brittle by
> not having excessive amount of feature detection and skipped
> selftests. I think that's the case for BPF atomics as well, btw (cc'ed
> Yonghong and Brendan).
> 
> To alleviate some of the pain of setting up the environment, one way
> would be to provide script and/or image to help bring up qemu VM for
> easier testing. To that end, KP Singh (cc'ed) was able to re-use
> libbpf CI's VM setup and make it easier for local development. I hope
> he can share this soon.

ok, that'd be great, thanks for taking this one

jirka

> 
> So given minimal additions code-wise, but also considering all the above:
> 
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  .../testing/selftests/bpf/progs/test_core_reloc_module.c  | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_module.c b/tools/testing/selftests/bpf/progs/test_core_reloc_module.c
> > index 56363959f7b0..f59f175c7baf 100644
> > --- a/tools/testing/selftests/bpf/progs/test_core_reloc_module.c
> > +++ b/tools/testing/selftests/bpf/progs/test_core_reloc_module.c
> > @@ -40,6 +40,7 @@ int BPF_PROG(test_core_module_probed,
> >              struct task_struct *task,
> >              struct bpf_testmod_test_read_ctx *read_ctx)
> >  {
> > +#if __has_builtin(__builtin_preserve_enum_value)
> >         struct core_reloc_module_output *out = (void *)&data.out;
> >         __u64 pid_tgid = bpf_get_current_pid_tgid();
> >         __u32 real_tgid = (__u32)(pid_tgid >> 32);
> > @@ -61,6 +62,9 @@ int BPF_PROG(test_core_module_probed,
> >         out->len_exists = bpf_core_field_exists(read_ctx->len);
> >
> >         out->comm_len = BPF_CORE_READ_STR_INTO(&out->comm, task, comm);
> > +#else
> > +       data.skip = true;
> > +#endif
> >
> >         return 0;
> >  }
> > @@ -70,6 +74,7 @@ int BPF_PROG(test_core_module_direct,
> >              struct task_struct *task,
> >              struct bpf_testmod_test_read_ctx *read_ctx)
> >  {
> > +#if __has_builtin(__builtin_preserve_enum_value)
> >         struct core_reloc_module_output *out = (void *)&data.out;
> >         __u64 pid_tgid = bpf_get_current_pid_tgid();
> >         __u32 real_tgid = (__u32)(pid_tgid >> 32);
> > @@ -91,6 +96,9 @@ int BPF_PROG(test_core_module_direct,
> >         out->len_exists = bpf_core_field_exists(read_ctx->len);
> >
> >         out->comm_len = BPF_CORE_READ_STR_INTO(&out->comm, task, comm);
> > +#else
> > +       data.skip = true;
> > +#endif
> >
> >         return 0;
> >  }
> > --
> > 2.26.2
> >
> 

