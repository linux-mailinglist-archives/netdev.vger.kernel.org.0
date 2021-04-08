Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F3A358274
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 13:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbhDHLv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 07:51:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38244 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229751AbhDHLvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 07:51:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617882704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NICIum2EuzNORD4QCGBDgmSab6AN8JQE+M3SQck/dDM=;
        b=Kz41vsXU95Zmfz7c4BKc5QFvm6SVtqX3MUDonLI6olTxn0kZcsqWEF6v3sdY51e54sLSLt
        04/tn0qPP4SLMOsfuso3wVU9qgwW1YLrYzIRWcKbPlX2zHCfEnGGFiuK20T0ANjMKUvJAC
        yOhcxUK90rH/6PsQNMlq5uX5h6TmaKE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-tjhqI2ETPGmr9oqRzJu40A-1; Thu, 08 Apr 2021 07:51:40 -0400
X-MC-Unique: tjhqI2ETPGmr9oqRzJu40A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1EF49802B56;
        Thu,  8 Apr 2021 11:51:39 +0000 (UTC)
Received: from krava (unknown [10.40.195.201])
        by smtp.corp.redhat.com (Postfix) with SMTP id 2776E60BF1;
        Thu,  8 Apr 2021 11:51:32 +0000 (UTC)
Date:   Thu, 8 Apr 2021 13:51:32 +0200
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
Subject: Re: [PATCHv2 bpf-next 3/5] selftests/bpf: Add re-attach test to
 fexit_test
Message-ID: <YG7uRCXmbVbm/1ze@krava>
References: <20210406212913.970917-1-jolsa@kernel.org>
 <20210406212913.970917-4-jolsa@kernel.org>
 <CAEf4BzaHCkRm0nFLtWxOJCY5sAAEGYWvLZC+BAjhv4RijAp9oQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaHCkRm0nFLtWxOJCY5sAAEGYWvLZC+BAjhv4RijAp9oQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 03:51:46PM -0700, Andrii Nakryiko wrote:
> On Wed, Apr 7, 2021 at 4:21 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Adding the test to re-attach (detach/attach again) tracing
> > fexit programs, plus check that already linked program can't
> > be attached again.
> >
> > Fixing the number of check-ed results, which should be 8.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  .../selftests/bpf/prog_tests/fexit_test.c     | 48 +++++++++++++++----
> >  1 file changed, 38 insertions(+), 10 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_test.c b/tools/testing/selftests/bpf/prog_tests/fexit_test.c
> > index 78d7a2765c27..579e620e6612 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/fexit_test.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/fexit_test.c
> > @@ -3,20 +3,24 @@
> >  #include <test_progs.h>
> >  #include "fexit_test.skel.h"
> >
> > -void test_fexit_test(void)
> > +static __u32 duration;
> > +
> > +static int fexit_test(struct fexit_test *fexit_skel)
> >  {
> > -       struct fexit_test *fexit_skel = NULL;
> > +       struct bpf_link *link;
> >         int err, prog_fd, i;
> > -       __u32 duration = 0, retval;
> >         __u64 *result;
> > -
> > -       fexit_skel = fexit_test__open_and_load();
> > -       if (CHECK(!fexit_skel, "fexit_skel_load", "fexit skeleton failed\n"))
> > -               goto cleanup;
> > +       __u32 retval;
> >
> >         err = fexit_test__attach(fexit_skel);
> >         if (CHECK(err, "fexit_attach", "fexit attach failed: %d\n", err))
> > -               goto cleanup;
> > +               return err;
> > +
> > +       /* Check that already linked program can't be attached again. */
> > +       link = bpf_program__attach(fexit_skel->progs.test1);
> > +       if (CHECK(!IS_ERR(link), "fexit_attach_link",
> > +                 "re-attach without detach should not succeed"))
> > +               return -1;
> >
> >         prog_fd = bpf_program__fd(fexit_skel->progs.test1);
> >         err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
> > @@ -26,12 +30,36 @@ void test_fexit_test(void)
> >               err, errno, retval, duration);
> >
> >         result = (__u64 *)fexit_skel->bss;
> > -       for (i = 0; i < 6; i++) {
> > +       for (i = 0; i < 8; i++) {
> >                 if (CHECK(result[i] != 1, "result",
> >                           "fexit_test%d failed err %lld\n", i + 1, result[i]))
> > -                       goto cleanup;
> > +                       return -1;
> >         }
> >
> > +       fexit_test__detach(fexit_skel);
> > +
> > +       /* zero results for re-attach test */
> > +       for (i = 0; i < 8; i++)
> > +               result[i] = 0;
> 
> memset(fexit_skel->bss, 0, sizeof(*fexit_skel->bss)) ? ;)
> 
> and see my nits in previous patch about ASSERT over CHECK

sure ;-) thanks

jirka

