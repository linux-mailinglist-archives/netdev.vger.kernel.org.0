Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1473D35F1D6
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 13:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235622AbhDNLC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 07:02:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49293 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235313AbhDNLC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 07:02:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618398125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s8RiYmm9jnM3VI4MYAD3H3NUBQ6LI4/LRxZI2EwGDII=;
        b=X6wM2igqptwLLsUvIXalEobKGIEAUIEDFfkasR16gIjzLx+/MNuQvmaZ2wAbHIGE/cn7KB
        YWnhzHml3twWNevhm1Hp7xe8J8PbQsuccd+3b010vz/r2sRrkg+9ZUIz+MJpigDPiXRYcC
        vJe/PKBUu6XPmqZZ/dXnvC8N9XRq6bc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-vCqtXdaxMeGgqVXOtvd0hg-1; Wed, 14 Apr 2021 07:02:03 -0400
X-MC-Unique: vCqtXdaxMeGgqVXOtvd0hg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5EDCF835B66;
        Wed, 14 Apr 2021 11:02:01 +0000 (UTC)
Received: from krava (unknown [10.40.196.56])
        by smtp.corp.redhat.com (Postfix) with SMTP id 40FDA83BE0;
        Wed, 14 Apr 2021 11:01:54 +0000 (UTC)
Date:   Wed, 14 Apr 2021 13:01:53 +0200
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
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Julia Lawall <julia.lawall@inria.fr>
Subject: Re: [PATCHv4 bpf-next 3/5] selftests/bpf: Add re-attach test to
 fexit_test
Message-ID: <YHbLoRp5zehaGiLM@krava>
References: <20210412162502.1417018-1-jolsa@kernel.org>
 <20210412162502.1417018-4-jolsa@kernel.org>
 <CAEf4BzYv_9Sa5Sa25-9s-9Fxasn9OuoRfggyOT9JcDcfrCkhEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYv_9Sa5Sa25-9s-9Fxasn9OuoRfggyOT9JcDcfrCkhEQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 02:55:32PM -0700, Andrii Nakryiko wrote:
> On Mon, Apr 12, 2021 at 9:30 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Adding the test to re-attach (detach/attach again) tracing
> > fexit programs, plus check that already linked program can't
> > be attached again.
> >
> > Also switching to ASSERT* macros.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  .../selftests/bpf/prog_tests/fexit_test.c     | 51 +++++++++++++------
> >  1 file changed, 36 insertions(+), 15 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_test.c b/tools/testing/selftests/bpf/prog_tests/fexit_test.c
> > index 78d7a2765c27..c48e10c138bc 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/fexit_test.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/fexit_test.c
> > @@ -3,35 +3,56 @@
> >  #include <test_progs.h>
> >  #include "fexit_test.skel.h"
> >
> > -void test_fexit_test(void)
> > +static int fexit_test(struct fexit_test *fexit_skel)
> >  {
> > -       struct fexit_test *fexit_skel = NULL;
> >         int err, prog_fd, i;
> >         __u32 duration = 0, retval;
> > +       struct bpf_link *link;
> >         __u64 *result;
> >
> > -       fexit_skel = fexit_test__open_and_load();
> > -       if (CHECK(!fexit_skel, "fexit_skel_load", "fexit skeleton failed\n"))
> > -               goto cleanup;
> > -
> >         err = fexit_test__attach(fexit_skel);
> > -       if (CHECK(err, "fexit_attach", "fexit attach failed: %d\n", err))
> > -               goto cleanup;
> > +       if (!ASSERT_OK(err, "fexit_attach"))
> > +               return err;
> > +
> > +       /* Check that already linked program can't be attached again. */
> > +       link = bpf_program__attach(fexit_skel->progs.test1);
> > +       if (!ASSERT_ERR_PTR(link, "fexit_attach_link"))
> > +               return -1;
> >
> >         prog_fd = bpf_program__fd(fexit_skel->progs.test1);
> >         err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
> >                                 NULL, NULL, &retval, &duration);
> > -       CHECK(err || retval, "test_run",
> > -             "err %d errno %d retval %d duration %d\n",
> > -             err, errno, retval, duration);
> > +       ASSERT_OK(err || retval, "test_run");
> 
> same as in previous patch
> 
> With this fixed, feel free to add my ack to this and previous patch. Thanks!

ok, thanks,
jirka

