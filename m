Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D08773A34D3
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 22:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbhFJUbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 16:31:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38951 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230299AbhFJUbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 16:31:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623356942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+liY71qkNc3av4c7FTZuDMakAHUn8vcZt9xyuXI59Mw=;
        b=NMiHq+xLaG0aS66S0VkgZ4/NjDENvA3DHk27oWqsaDRx+CyD98yxxXsFl9zWHwD4OPwTkx
        aUUCF3AoQg177b5IBX5y3I5kQkEdo2lYvQjYBgbutR0PeM0QXYSh526S3S1E2fKA6w/AFL
        7v5dAfDvNiarD8RZt1GATDfGRojVhd8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-Z0-QMy42MdWm-K9JbDkRkA-1; Thu, 10 Jun 2021 16:28:58 -0400
X-MC-Unique: Z0-QMy42MdWm-K9JbDkRkA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E16DC801B12;
        Thu, 10 Jun 2021 20:28:55 +0000 (UTC)
Received: from krava (unknown [10.40.195.165])
        by smtp.corp.redhat.com (Postfix) with SMTP id B372060CC9;
        Thu, 10 Jun 2021 20:28:52 +0000 (UTC)
Date:   Thu, 10 Jun 2021 22:28:51 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCH 16/19] selftests/bpf: Add fentry multi func test
Message-ID: <YMJ2A1hvmnDdFlRt@krava>
References: <20210605111034.1810858-1-jolsa@kernel.org>
 <20210605111034.1810858-17-jolsa@kernel.org>
 <CAEf4BzbBGB+hm0LJRUWDi1EXRkbj86FDOt_ZHdQbT=za47p9ZA@mail.gmail.com>
 <YMDQOIhRh9tDy1Tg@krava>
 <CAEf4Bzboi7Wsf94Z-0OjyYehjazELqdR-gWgxuS_y3AqzDY=rQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzboi7Wsf94Z-0OjyYehjazELqdR-gWgxuS_y3AqzDY=rQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 10:00:34AM -0700, Andrii Nakryiko wrote:
> On Wed, Jun 9, 2021 at 7:29 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Tue, Jun 08, 2021 at 10:40:24PM -0700, Andrii Nakryiko wrote:
> > > On Sat, Jun 5, 2021 at 4:12 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > > >
> > > > Adding selftest for fentry multi func test that attaches
> > > > to bpf_fentry_test* functions and checks argument values
> > > > based on the processed function.
> > > >
> > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > > ---
> > > >  tools/testing/selftests/bpf/multi_check.h     | 52 +++++++++++++++++++
> > > >  .../bpf/prog_tests/fentry_multi_test.c        | 43 +++++++++++++++
> > > >  .../selftests/bpf/progs/fentry_multi_test.c   | 18 +++++++
> > > >  3 files changed, 113 insertions(+)
> > > >  create mode 100644 tools/testing/selftests/bpf/multi_check.h
> > > >  create mode 100644 tools/testing/selftests/bpf/prog_tests/fentry_multi_test.c
> > > >  create mode 100644 tools/testing/selftests/bpf/progs/fentry_multi_test.c
> > > >
> > > > diff --git a/tools/testing/selftests/bpf/multi_check.h b/tools/testing/selftests/bpf/multi_check.h
> > > > new file mode 100644
> > > > index 000000000000..36c2a93f9be3
> > > > --- /dev/null
> > > > +++ b/tools/testing/selftests/bpf/multi_check.h
> > >
> > > we have a proper static linking now, we don't have to use header
> > > inclusion hacks, let's do this properly?
> >
> > ok, will change
> >
> > >
> > > > @@ -0,0 +1,52 @@
> > > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > > +
> > > > +#ifndef __MULTI_CHECK_H
> > > > +#define __MULTI_CHECK_H
> > > > +
> > > > +extern unsigned long long bpf_fentry_test[8];
> > > > +
> > > > +static __attribute__((unused)) inline
> > > > +void multi_arg_check(unsigned long ip, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f, __u64 *test_result)
> > > > +{
> > > > +       if (ip == bpf_fentry_test[0]) {
> > > > +               *test_result += (int) a == 1;
> > > > +       } else if (ip == bpf_fentry_test[1]) {
> > > > +               *test_result += (int) a == 2 && (__u64) b == 3;
> > > > +       } else if (ip == bpf_fentry_test[2]) {
> > > > +               *test_result += (char) a == 4 && (int) b == 5 && (__u64) c == 6;
> > > > +       } else if (ip == bpf_fentry_test[3]) {
> > > > +               *test_result += (void *) a == (void *) 7 && (char) b == 8 && (int) c == 9 && (__u64) d == 10;
> > > > +       } else if (ip == bpf_fentry_test[4]) {
> > > > +               *test_result += (__u64) a == 11 && (void *) b == (void *) 12 && (short) c == 13 && (int) d == 14 && (__u64) e == 15;
> > > > +       } else if (ip == bpf_fentry_test[5]) {
> > > > +               *test_result += (__u64) a == 16 && (void *) b == (void *) 17 && (short) c == 18 && (int) d == 19 && (void *) e == (void *) 20 && (__u64) f == 21;
> > > > +       } else if (ip == bpf_fentry_test[6]) {
> > > > +               *test_result += 1;
> > > > +       } else if (ip == bpf_fentry_test[7]) {
> > > > +               *test_result += 1;
> > > > +       }
> > >
> > > why not use switch? and why the casting?
> >
> > hum, for switch I'd need constants right?
> 
> doh, of course :)
> 
> but! you don't need to fill out bpf_fentry_test[] array from
> user-space, just use extern const void variables to get addresses of
> those functions:
> 
> extern const void bpf_fentry_test1 __ksym;
> extern const void bpf_fentry_test2 __ksym;
> ...

nice, will use that

jirka

