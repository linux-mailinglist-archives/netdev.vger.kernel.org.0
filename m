Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F873A173D
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 16:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235658AbhFIObV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 10:31:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43242 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234131AbhFIObR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 10:31:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623248962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hTwiR67jZpFVE/GSn9swecVU8qkqr7FazMmOKLue4Lc=;
        b=bQjx4XFFaTfuMAIvH6dqDHgpJvScJdFb39Oenq/IzAaKjQEHRMIMQee5zkoM7uGjlaDUQt
        FJ87S1tuhlKb1u/m3jkzfg5GwSEBYKXDMV2fCXA2j44H+Cu2MWulMX7rYY3bY6yJxznoTb
        zdRiZ8pwn/ADk7ang3K8gv68vOegDNg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-NKNt62mZPRW9Hh-2KWXHcg-1; Wed, 09 Jun 2021 10:29:18 -0400
X-MC-Unique: NKNt62mZPRW9Hh-2KWXHcg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E516101F7A4;
        Wed,  9 Jun 2021 14:29:16 +0000 (UTC)
Received: from krava (unknown [10.40.195.97])
        by smtp.corp.redhat.com (Postfix) with SMTP id 66A6D5D9DE;
        Wed,  9 Jun 2021 14:29:13 +0000 (UTC)
Date:   Wed, 9 Jun 2021 16:29:12 +0200
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
Message-ID: <YMDQOIhRh9tDy1Tg@krava>
References: <20210605111034.1810858-1-jolsa@kernel.org>
 <20210605111034.1810858-17-jolsa@kernel.org>
 <CAEf4BzbBGB+hm0LJRUWDi1EXRkbj86FDOt_ZHdQbT=za47p9ZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbBGB+hm0LJRUWDi1EXRkbj86FDOt_ZHdQbT=za47p9ZA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 08, 2021 at 10:40:24PM -0700, Andrii Nakryiko wrote:
> On Sat, Jun 5, 2021 at 4:12 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Adding selftest for fentry multi func test that attaches
> > to bpf_fentry_test* functions and checks argument values
> > based on the processed function.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  tools/testing/selftests/bpf/multi_check.h     | 52 +++++++++++++++++++
> >  .../bpf/prog_tests/fentry_multi_test.c        | 43 +++++++++++++++
> >  .../selftests/bpf/progs/fentry_multi_test.c   | 18 +++++++
> >  3 files changed, 113 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/multi_check.h
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/fentry_multi_test.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/fentry_multi_test.c
> >
> > diff --git a/tools/testing/selftests/bpf/multi_check.h b/tools/testing/selftests/bpf/multi_check.h
> > new file mode 100644
> > index 000000000000..36c2a93f9be3
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/multi_check.h
> 
> we have a proper static linking now, we don't have to use header
> inclusion hacks, let's do this properly?

ok, will change

> 
> > @@ -0,0 +1,52 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +
> > +#ifndef __MULTI_CHECK_H
> > +#define __MULTI_CHECK_H
> > +
> > +extern unsigned long long bpf_fentry_test[8];
> > +
> > +static __attribute__((unused)) inline
> > +void multi_arg_check(unsigned long ip, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f, __u64 *test_result)
> > +{
> > +       if (ip == bpf_fentry_test[0]) {
> > +               *test_result += (int) a == 1;
> > +       } else if (ip == bpf_fentry_test[1]) {
> > +               *test_result += (int) a == 2 && (__u64) b == 3;
> > +       } else if (ip == bpf_fentry_test[2]) {
> > +               *test_result += (char) a == 4 && (int) b == 5 && (__u64) c == 6;
> > +       } else if (ip == bpf_fentry_test[3]) {
> > +               *test_result += (void *) a == (void *) 7 && (char) b == 8 && (int) c == 9 && (__u64) d == 10;
> > +       } else if (ip == bpf_fentry_test[4]) {
> > +               *test_result += (__u64) a == 11 && (void *) b == (void *) 12 && (short) c == 13 && (int) d == 14 && (__u64) e == 15;
> > +       } else if (ip == bpf_fentry_test[5]) {
> > +               *test_result += (__u64) a == 16 && (void *) b == (void *) 17 && (short) c == 18 && (int) d == 19 && (void *) e == (void *) 20 && (__u64) f == 21;
> > +       } else if (ip == bpf_fentry_test[6]) {
> > +               *test_result += 1;
> > +       } else if (ip == bpf_fentry_test[7]) {
> > +               *test_result += 1;
> > +       }
> 
> why not use switch? and why the casting?

hum, for switch I'd need constants right? 

casting is extra ;-) wanted to check the actual argument types,
but probably makes no sense

will check

> 
> > +}
> > +
> 
> [...]
> 
> > diff --git a/tools/testing/selftests/bpf/progs/fentry_multi_test.c b/tools/testing/selftests/bpf/progs/fentry_multi_test.c
> > new file mode 100644
> > index 000000000000..a443fc958e5a
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/fentry_multi_test.c
> > @@ -0,0 +1,18 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <linux/bpf.h>
> > +#include <bpf/bpf_helpers.h>
> > +#include <bpf/bpf_tracing.h>
> > +#include "multi_check.h"
> > +
> > +char _license[] SEC("license") = "GPL";
> > +
> > +unsigned long long bpf_fentry_test[8];
> > +
> > +__u64 test_result = 0;
> > +
> > +SEC("fentry.multi/bpf_fentry_test*")
> 
> wait, that's a regexp syntax that libc supports?.. Not .*? We should
> definitely not provide btf__find_by_pattern_kind() API, I'd like to
> avoid explaining what flavors of regexps libbpf supports.

ok

thanks,
jirka

