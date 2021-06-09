Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A68C73A1743
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 16:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237441AbhFIObr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 10:31:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27290 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237126AbhFIObk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 10:31:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623248985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H8RcsyIoMjXKCq7+JXrB6crNX9qGN8S4TNZ/46I63zs=;
        b=fXi64QPls3QY7ieIMiEuF/Df4CbgsRW6VtutXy+aZOKqGZ24hH7JjcPJGovBlFIgZtF6oC
        8plBlmumqKPiy/GOdEhTegcXg6xgi0u+ksBe7RvQ//CcU4wJn+HaWUnD+mG7G6G8Q/WJY+
        7nvSIgK6rl6TnZXG7+uTNXnVeMpUq5E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-aflmTy7eOqq0BoAh858T0g-1; Wed, 09 Jun 2021 10:29:44 -0400
X-MC-Unique: aflmTy7eOqq0BoAh858T0g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 177A1101F7A6;
        Wed,  9 Jun 2021 14:29:42 +0000 (UTC)
Received: from krava (unknown [10.40.195.97])
        by smtp.corp.redhat.com (Postfix) with SMTP id 3A7675D6AD;
        Wed,  9 Jun 2021 14:29:39 +0000 (UTC)
Date:   Wed, 9 Jun 2021 16:29:38 +0200
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
Subject: Re: [PATCH 18/19] selftests/bpf: Add fentry/fexit multi func test
Message-ID: <YMDQUlS7C7D6Papd@krava>
References: <20210605111034.1810858-1-jolsa@kernel.org>
 <20210605111034.1810858-19-jolsa@kernel.org>
 <CAEf4BzZWMekJvmadz1wuFhmvRrGuSgHtLH1WoyY7t=C5gWVKoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZWMekJvmadz1wuFhmvRrGuSgHtLH1WoyY7t=C5gWVKoQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 08, 2021 at 10:41:37PM -0700, Andrii Nakryiko wrote:
> On Sat, Jun 5, 2021 at 4:13 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Adding selftest for fentry/fexit multi func test that attaches
> > to bpf_fentry_test* functions and checks argument values based
> > on the processed function.
> >
> > When multi_arg_check is used from 2 different places I'm getting
> > compilation fail, which I did not deciphered yet:
> >
> >   $ CLANG=/opt/clang/bin/clang LLC=/opt/clang/bin/llc make
> >     CLNG-BPF [test_maps] fentry_fexit_multi_test.o
> >   progs/fentry_fexit_multi_test.c:18:2: error: too many args to t24: i64 = \
> >   GlobalAddress<void (i64, i64, i64, i64, i64, i64, i64, i64*)* @multi_arg_check> 0, \
> >   progs/fentry_fexit_multi_test.c:18:2 @[ progs/fentry_fexit_multi_test.c:16:5 ]
> >           multi_arg_check(ip, a, b, c, d, e, f, &test1_arg_result);
> >           ^
> >   progs/fentry_fexit_multi_test.c:25:2: error: too many args to t32: i64 = \
> >   GlobalAddress<void (i64, i64, i64, i64, i64, i64, i64, i64*)* @multi_arg_check> 0, \
> >   progs/fentry_fexit_multi_test.c:25:2 @[ progs/fentry_fexit_multi_test.c:23:5 ]
> >           multi_arg_check(ip, a, b, c, d, e, f, &test2_arg_result);
> >           ^
> >   In file included from progs/fentry_fexit_multi_test.c:5:
> >   /home/jolsa/linux-qemu/tools/testing/selftests/bpf/multi_check.h:9:6: error: defined with too many args
> >   void multi_arg_check(unsigned long ip, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f, __u64 *test_result)
> >        ^
> >   /home/jolsa/linux-qemu/tools/testing/selftests/bpf/multi_check.h:9:6: error: defined with too many args
> >   /home/jolsa/linux-qemu/tools/testing/selftests/bpf/multi_check.h:9:6: error: defined with too many args
> >   5 errors generated.
> >   make: *** [Makefile:470: /home/jolsa/linux-qemu/tools/testing/selftests/bpf/fentry_fexit_multi_test.o] Error 1
> >
> > I can fix that by defining 2 separate multi_arg_check functions
> > with different names, which I did in follow up temporaary patch.
> > Not sure I'm hitting some clang/bpf limitation in here?
> 
> don't know about  clang limitations, but we should use static linking
> proper anyways

ok, will change

thanks,
jirka

