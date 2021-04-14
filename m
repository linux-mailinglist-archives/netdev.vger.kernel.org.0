Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78FD235F1C7
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 12:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236614AbhDNK5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 06:57:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22174 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234570AbhDNK5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 06:57:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618397828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ELq9zKU27FitcY2T4bXBDMfbwmaQ/MzW+vSVnb6xYoY=;
        b=FahvouZkR79OBfIbB8yOLIsQST7YMUMvvFtlWe/RWQxBsc8VQ7e/TsDSYbgrDk4/IsHk4T
        z0WUEtav6mRI+hr3lN/U0hZ218IlBq4nbmdT6nc2Prh2Nf6Q6e9jPT+lyAB0xywewVjwMU
        7bX2sLU3b8J/sHty1+YNfy4ZaiaAFS0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-_-oPm9ukMmSefKA5ji6W9A-1; Wed, 14 Apr 2021 06:57:06 -0400
X-MC-Unique: _-oPm9ukMmSefKA5ji6W9A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A65FA10053E8;
        Wed, 14 Apr 2021 10:57:04 +0000 (UTC)
Received: from krava (unknown [10.40.196.56])
        by smtp.corp.redhat.com (Postfix) with SMTP id 1C27B60657;
        Wed, 14 Apr 2021 10:56:59 +0000 (UTC)
Date:   Wed, 14 Apr 2021 12:56:59 +0200
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
Subject: Re: [PATCHv4 bpf-next 2/5] selftests/bpf: Add re-attach test to
 fentry_test
Message-ID: <YHbKexxx+jyMeVnM@krava>
References: <20210412162502.1417018-1-jolsa@kernel.org>
 <20210412162502.1417018-3-jolsa@kernel.org>
 <CAEf4Bza6OXC4aVuxVGnn-DOANuFbnuJ++=q8fFpD-f48kb7_pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bza6OXC4aVuxVGnn-DOANuFbnuJ++=q8fFpD-f48kb7_pw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 02:54:10PM -0700, Andrii Nakryiko wrote:

SNIP

> >         __u32 duration = 0, retval;
> > +       struct bpf_link *link;
> >         __u64 *result;
> >
> > -       fentry_skel = fentry_test__open_and_load();
> > -       if (CHECK(!fentry_skel, "fentry_skel_load", "fentry skeleton failed\n"))
> > -               goto cleanup;
> > -
> >         err = fentry_test__attach(fentry_skel);
> > -       if (CHECK(err, "fentry_attach", "fentry attach failed: %d\n", err))
> > -               goto cleanup;
> > +       if (!ASSERT_OK(err, "fentry_attach"))
> > +               return err;
> > +
> > +       /* Check that already linked program can't be attached again. */
> > +       link = bpf_program__attach(fentry_skel->progs.test1);
> > +       if (!ASSERT_ERR_PTR(link, "fentry_attach_link"))
> > +               return -1;
> >
> >         prog_fd = bpf_program__fd(fentry_skel->progs.test1);
> >         err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
> >                                 NULL, NULL, &retval, &duration);
> > -       CHECK(err || retval, "test_run",
> > -             "err %d errno %d retval %d duration %d\n",
> > -             err, errno, retval, duration);
> > +       ASSERT_OK(err || retval, "test_run");
> 
> this is quite misleading, even if will result in a correct check. Toke
> did this in his patch set:
> 
> ASSERT_OK(err, ...);
> ASSERT_EQ(retval, 0, ...);
> 
> It is a better and more straightforward way to validate the checks
> instead of relying on (err || retval) -> bool (true) -> int (1) -> !=
> 0 chain.

ok, makes sense

SNIP

> > +void test_fentry_test(void)
> > +{
> > +       struct fentry_test *fentry_skel = NULL;
> > +       int err;
> > +
> > +       fentry_skel = fentry_test__open_and_load();
> > +       if (!ASSERT_OK_PTR(fentry_skel, "fentry_skel_load"))
> > +               goto cleanup;
> > +
> > +       err = fentry_test(fentry_skel);
> > +       if (!ASSERT_OK(err, "fentry_first_attach"))
> > +               goto cleanup;
> > +
> > +       err = fentry_test(fentry_skel);
> > +       ASSERT_OK(err, "fentry_second_attach");
> > +
> >  cleanup:
> >         fentry_test__destroy(fentry_skel);
> >  }
> > diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
> > index e87c8546230e..ee7e3b45182a 100644
> > --- a/tools/testing/selftests/bpf/test_progs.h
> > +++ b/tools/testing/selftests/bpf/test_progs.h
> > @@ -210,7 +210,7 @@ extern int test__join_cgroup(const char *path);
> >  #define ASSERT_ERR_PTR(ptr, name) ({                                   \
> >         static int duration = 0;                                        \
> >         const void *___res = (ptr);                                     \
> > -       bool ___ok = IS_ERR(___res)                                     \
> > +       bool ___ok = IS_ERR(___res);                                    \
> 
> heh, it probably deserves a separate patch with Fixes tag...

va bene

jirka

