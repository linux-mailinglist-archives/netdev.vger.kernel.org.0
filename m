Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC75D358276
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 13:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhDHLwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 07:52:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32126 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230467AbhDHLwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 07:52:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617882745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MWJaHVEJz9Bs+VHn+Aq32G9w7AQs9UnfAKmIch1UF70=;
        b=L85kIoXRP/zgHcOqsHyzqIFsnhuuQnqY7qo5qm7t7FCOBadI2PcaqazEOFHf/vK1GP00fx
        Y/f7hTiU05kaA9bbu7touBc435fX8sCKYzpobNIdrVIFkG+l1/BUdyUM/7rASoFQMD0YmG
        zpeP6Winjda+g8kH5TMnkUgOUS5W8Zk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-x3yUfOVaO6GXPJgjiI0okA-1; Thu, 08 Apr 2021 07:52:23 -0400
X-MC-Unique: x3yUfOVaO6GXPJgjiI0okA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A9F90BBEE6;
        Thu,  8 Apr 2021 11:52:21 +0000 (UTC)
Received: from krava (unknown [10.40.195.201])
        by smtp.corp.redhat.com (Postfix) with SMTP id E5FF45C1C5;
        Thu,  8 Apr 2021 11:52:18 +0000 (UTC)
Date:   Thu, 8 Apr 2021 13:52:18 +0200
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
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCHv2 bpf-next 2/5] selftests/bpf: Add re-attach test to
 fentry_test
Message-ID: <YG7uckNf7skULOCN@krava>
References: <20210406212913.970917-1-jolsa@kernel.org>
 <20210406212913.970917-3-jolsa@kernel.org>
 <CAEf4Bzagf5H31H8uSuMiVDpE5a6tgDOsZkJdmMK0hGhVDADRHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzagf5H31H8uSuMiVDpE5a6tgDOsZkJdmMK0hGhVDADRHQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 03:47:30PM -0700, Andrii Nakryiko wrote:
> On Wed, Apr 7, 2021 at 4:21 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Adding the test to re-attach (detach/attach again) tracing
> > fentry programs, plus check that already linked program can't
> > be attached again.
> >
> > Fixing the number of check-ed results, which should be 8.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  .../selftests/bpf/prog_tests/fentry_test.c    | 48 +++++++++++++++----
> >  1 file changed, 38 insertions(+), 10 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/fentry_test.c b/tools/testing/selftests/bpf/prog_tests/fentry_test.c
> > index 04ebbf1cb390..1f7566e772e9 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/fentry_test.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/fentry_test.c
> > @@ -3,20 +3,24 @@
> >  #include <test_progs.h>
> >  #include "fentry_test.skel.h"
> >
> > -void test_fentry_test(void)
> > +static __u32 duration;
> > +
> > +static int fentry_test(struct fentry_test *fentry_skel)
> >  {
> > -       struct fentry_test *fentry_skel = NULL;
> > +       struct bpf_link *link;
> >         int err, prog_fd, i;
> > -       __u32 duration = 0, retval;
> >         __u64 *result;
> > -
> > -       fentry_skel = fentry_test__open_and_load();
> > -       if (CHECK(!fentry_skel, "fentry_skel_load", "fentry skeleton failed\n"))
> > -               goto cleanup;
> > +       __u32 retval;
> >
> >         err = fentry_test__attach(fentry_skel);
> >         if (CHECK(err, "fentry_attach", "fentry attach failed: %d\n", err))
> > -               goto cleanup;
> > +               return err;
> > +
> > +       /* Check that already linked program can't be attached again. */
> > +       link = bpf_program__attach(fentry_skel->progs.test1);
> > +       if (CHECK(!IS_ERR(link), "fentry_attach_link",
> 
> if (!ASSERT_ERR_PTR(link, "fentry_attach_link")) ?

ok

> 
> > +                 "re-attach without detach should not succeed"))
> > +               return -1;
> >
> >         prog_fd = bpf_program__fd(fentry_skel->progs.test1);
> >         err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
> > @@ -26,12 +30,36 @@ void test_fentry_test(void)
> >               err, errno, retval, duration);
> >
> >         result = (__u64 *)fentry_skel->bss;
> > -       for (i = 0; i < 6; i++) {
> > +       for (i = 0; i < 8; i++) {
> 
> how about using sizeof(*fentry_skel->bss) / sizeof(__u64) ?

ok

> 
> >                 if (CHECK(result[i] != 1, "result",
> >                           "fentry_test%d failed err %lld\n", i + 1, result[i]))
> > -                       goto cleanup;
> > +                       return -1;
> >         }
> >
> > +       fentry_test__detach(fentry_skel);
> > +
> > +       /* zero results for re-attach test */
> > +       for (i = 0; i < 8; i++)
> > +               result[i] = 0;
> > +       return 0;
> > +}
> > +
> > +void test_fentry_test(void)
> > +{
> > +       struct fentry_test *fentry_skel = NULL;
> > +       int err;
> > +
> > +       fentry_skel = fentry_test__open_and_load();
> > +       if (CHECK(!fentry_skel, "fentry_skel_load", "fentry skeleton failed\n"))
> > +               goto cleanup;
> > +
> > +       err = fentry_test(fentry_skel);
> > +       if (CHECK(err, "fentry_test", "first attach failed\n"))
> > +               goto cleanup;
> > +
> > +       err = fentry_test(fentry_skel);
> > +       CHECK(err, "fentry_test", "second attach failed\n");
> 
> overall: please try to use ASSERT_xxx macros, they are easier to
> follow and require less typing

ok, will check

thanks,
jirka

