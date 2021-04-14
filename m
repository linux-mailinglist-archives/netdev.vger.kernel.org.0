Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1267535F1C4
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 12:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233467AbhDNKzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 06:55:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54609 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232910AbhDNKzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 06:55:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618397684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ieI7qTBn6GqAPqvEII3jgRrqEuYuZz29QYT+fhzGUmI=;
        b=ODu7kBLrdEOjNZsM77WAZ9mim9aHs3vbR776D51/br0RG6fqrfZpLr9TRoMZKtVNYnhFre
        9hEg4hFZdRllJaYsKcvRt7NI1M3l+KY+YpS/t7mrHgXNVmPmVbS9xuFJCuGilKIkwSs1QQ
        HTI8s0ktq5gSn3b3JdMddcz3wovIzCo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-h9uyCyV8Ps2beIGSHaIdWg-1; Wed, 14 Apr 2021 06:54:41 -0400
X-MC-Unique: h9uyCyV8Ps2beIGSHaIdWg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 931138030BB;
        Wed, 14 Apr 2021 10:54:39 +0000 (UTC)
Received: from krava (unknown [10.40.196.56])
        by smtp.corp.redhat.com (Postfix) with SMTP id 3F90551DCB;
        Wed, 14 Apr 2021 10:54:32 +0000 (UTC)
Date:   Wed, 14 Apr 2021 12:54:31 +0200
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
Subject: Re: [PATCHv4 bpf-next 4/5] selftests/bpf: Add re-attach test to lsm
 test
Message-ID: <YHbJ54+KIY6kEHyd@krava>
References: <20210412162502.1417018-1-jolsa@kernel.org>
 <20210412162502.1417018-5-jolsa@kernel.org>
 <CAEf4BzZfGccOFt6hJgRyONexLyVvV4q6ydQ86zeOBFnjo8PS0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZfGccOFt6hJgRyONexLyVvV4q6ydQ86zeOBFnjo8PS0w@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 02:57:26PM -0700, Andrii Nakryiko wrote:
> On Mon, Apr 12, 2021 at 9:31 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Adding the test to re-attach (detach/attach again) lsm programs,
> > plus check that already linked program can't be attached again.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  .../selftests/bpf/prog_tests/test_lsm.c       | 48 +++++++++++++++----
> >  1 file changed, 38 insertions(+), 10 deletions(-)
> >
> 
> Surprised you didn't switch this one to ASSERT, but ok, we can do it
> some other time ;)

yep, I commented on that in the previous version ;-)

  - used ASSERT* macros apart from lsm test, which is using
    CHECKs all over the place [Andrii]

I think it should go to separate patch, so it won't shade
the actual change

jirka

> 
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> 
> 
> > diff --git a/tools/testing/selftests/bpf/prog_tests/test_lsm.c b/tools/testing/selftests/bpf/prog_tests/test_lsm.c
> > index 2755e4f81499..d492e76e01cf 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/test_lsm.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/test_lsm.c
> > @@ -18,6 +18,8 @@ char *CMD_ARGS[] = {"true", NULL};
> >  #define GET_PAGE_ADDR(ADDR, PAGE_SIZE)                                 \
> >         (char *)(((unsigned long) (ADDR + PAGE_SIZE)) & ~(PAGE_SIZE-1))
> >
> 
> [...]
> 

