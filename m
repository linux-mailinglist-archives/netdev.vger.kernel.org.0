Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59022266115
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 16:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbgIKOR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 10:17:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50472 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726148AbgIKNNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 09:13:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599829984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9TIqk7eBgs5tB6pCcXxagdTDlYZxFeTUz0Ppy5BYt68=;
        b=Zy2yfxCSNHOfA1K4zM5IPffkYvMnqdy6xfExc79b7x0j3lT/VrP3ceoiUA4Hdv9a+1A6J0
        Nk4iABQWnDzsaB0rwcn/LhCXicijvz628f1/y47eA0+GboM02nDazoRPK2ZOR4dr3x4ZGX
        JF8iABrBCF7F9nHC2ElWcKVM/mRJyuA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-CeaVsGeqNjerP5_QcR_yxw-1; Fri, 11 Sep 2020 09:04:27 -0400
X-MC-Unique: CeaVsGeqNjerP5_QcR_yxw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 200F2800FFF;
        Fri, 11 Sep 2020 13:04:25 +0000 (UTC)
Received: from krava (unknown [10.40.192.120])
        by smtp.corp.redhat.com (Postfix) with SMTP id 82CFD75129;
        Fri, 11 Sep 2020 13:04:22 +0000 (UTC)
Date:   Fri, 11 Sep 2020 15:04:21 +0200
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
Subject: Re: [PATCH bpf-next] selftests/bpf: Check trampoline execution in
 d_path test
Message-ID: <20200911130421.GC1714160@krava>
References: <20200910122224.1683258-1-jolsa@kernel.org>
 <CAEf4BzbVT+DmjPXLrcFG0ZFMCw0P_cb0W9abiaygfBAFu+nh7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbVT+DmjPXLrcFG0ZFMCw0P_cb0W9abiaygfBAFu+nh7Q@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 03:22:10PM -0700, Andrii Nakryiko wrote:
> On Thu, Sep 10, 2020 at 5:25 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Some kernels builds might inline vfs_getattr call within
> > fstat syscall code path, so fentry/vfs_getattr trampoline
> > is not called.
> >
> > I'm not sure how to handle this in some generic way other
> > than use some other function, but that might get inlined at
> > some point as well.
> >
> > Adding flags that indicate trampolines were called and failing
> > the test if neither of them got called.
> >
> >   $ sudo ./test_progs -t d_path
> >   test_d_path:PASS:setup 0 nsec
> >   ...
> >   trigger_fstat_events:PASS:trigger 0 nsec
> >   test_d_path:FAIL:124 trampolines not called
> >   #22 d_path:FAIL
> >   Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED
> >
> > If only one trampoline is called, it's still enough to test
> > the helper, so only warn about missing trampoline call and
> > continue in test.
> >
> >   $ sudo ./test_progs -t d_path -v
> >   test_d_path:PASS:setup 0 nsec
> >   ...
> >   trigger_fstat_events:PASS:trigger 0 nsec
> >   fentry/vfs_getattr not called
> >   #22 d_path:OK
> >   Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
> >
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > ---
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> 
> >  .../testing/selftests/bpf/prog_tests/d_path.c | 25 +++++++++++++++----
> >  .../testing/selftests/bpf/progs/test_d_path.c |  7 ++++++
> >  2 files changed, 27 insertions(+), 5 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/d_path.c b/tools/testing/selftests/bpf/prog_tests/d_path.c
> > index fc12e0d445ff..ec15f7d1dd0a 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/d_path.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/d_path.c
> > @@ -120,26 +120,41 @@ void test_d_path(void)
> >         if (err < 0)
> >                 goto cleanup;
> >
> > +       if (!bss->called_stat && !bss->called_close) {
> > +               PRINT_FAIL("trampolines not called\n");
> > +               goto cleanup;
> > +       }
> > +
> > +       if (!bss->called_stat) {
> > +               fprintf(stdout, "fentry/vfs_getattr not called\n");
> > +               goto cleanup;
> > +       }
> > +
> > +       if (!bss->called_close) {
> > +               fprintf(stdout, "fentry/filp_close not called\n");
> > +               goto cleanup;
> > +       }
> 
> not sure why you didn't go with `if (CHECK(!bss->called_close, ...`
> for these checks, would even save you some typing.

ok

> 
> > +
> >         for (int i = 0; i < MAX_FILES; i++) {
> > -               CHECK(strncmp(src.paths[i], bss->paths_stat[i], MAX_PATH_LEN),
> > +               CHECK(bss->called_stat && strncmp(src.paths[i], bss->paths_stat[i], MAX_PATH_LEN),
> >                       "check",
> >                       "failed to get stat path[%d]: %s vs %s\n",
> >                       i, src.paths[i], bss->paths_stat[i]);
> > -               CHECK(strncmp(src.paths[i], bss->paths_close[i], MAX_PATH_LEN),
> > +               CHECK(bss->called_close && strncmp(src.paths[i], bss->paths_close[i], MAX_PATH_LEN),
> >                       "check",
> >                       "failed to get close path[%d]: %s vs %s\n",
> >                       i, src.paths[i], bss->paths_close[i]);
> >                 /* The d_path helper returns size plus NUL char, hence + 1 */
> > -               CHECK(bss->rets_stat[i] != strlen(bss->paths_stat[i]) + 1,
> > +               CHECK(bss->called_stat && bss->rets_stat[i] != strlen(bss->paths_stat[i]) + 1,
> >                       "check",
> >                       "failed to match stat return [%d]: %d vs %zd [%s]\n",
> >                       i, bss->rets_stat[i], strlen(bss->paths_stat[i]) + 1,
> >                       bss->paths_stat[i]);
> > -               CHECK(bss->rets_close[i] != strlen(bss->paths_stat[i]) + 1,
> > +               CHECK(bss->called_close && bss->rets_close[i] != strlen(bss->paths_close[i]) + 1,
> >                       "check",
> >                       "failed to match stat return [%d]: %d vs %zd [%s]\n",
> >                       i, bss->rets_close[i], strlen(bss->paths_close[i]) + 1,
> > -                     bss->paths_stat[i]);
> > +                     bss->paths_close[i]);
> 
> 
> those `bss->called_xxx` guard conditions are a bit lost on reading, if
> you reordered CHECKs, you could be more explicit:
> 
> if (bss->called_stat) {
>     CHECK(...);
>     CHECK(...);
> }
> if (bss->called_close) { ... }

ok, will change

thanks,
jirka

