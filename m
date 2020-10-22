Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66CD7295A07
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 10:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895058AbgJVIVz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 22 Oct 2020 04:21:55 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:55500 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2895052AbgJVIVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 04:21:55 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-UXij8cUAMvG-Ypff4P0s4Q-1; Thu, 22 Oct 2020 04:21:48 -0400
X-MC-Unique: UXij8cUAMvG-Ypff4P0s4Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD2A4800461;
        Thu, 22 Oct 2020 08:21:45 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F2B760BFA;
        Thu, 22 Oct 2020 08:21:39 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jesper Brouer <jbrouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: [RFC bpf-next 00/16] bpf: Speed up trampoline attach
Date:   Thu, 22 Oct 2020 10:21:22 +0200
Message-Id: <20201022082138.2322434-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
this patchset tries to speed up the attach time for trampolines
and make bpftrace faster for wildcard use cases like:

  # bpftrace -ve "kfunc:__x64_sys_s* { printf("test\n"); }"

Profiles show mostly ftrace backend, because we add trampoline
functions one by one and ftrace direct function registering is
quite expensive. Thus main change in this patchset is to allow
batch attach and use just single ftrace call to attach or detach
multiple ips/trampolines.

This patchset also contains other speedup changes that showed
up in profiles:

  - delayed link free
    to bypass detach cycles completely

  - kallsyms rbtree search
    change linear search to rb tree search

For clean attach workload I added also new attach selftest,
which is not meant to be merged but is used to show profile
results.

Following numbers show speedup after applying specific change
on top of the previous (and including the previous changes).

profiled with: 'perf stat -r 5 -e cycles:k,cycles:u ...'

For bpftrace:

  # bpftrace -ve "kfunc:__x64_sys_s* { printf("test\n"); } i:ms:10 { printf("exit\n"); exit();}"

  - base

      3,290,457,628      cycles:k         ( +-  0.27% )
        933,581,973      cycles:u         ( +-  0.20% )

      50.25 +- 4.79 seconds time elapsed  ( +-  9.53% )

  + delayed link free

      2,535,458,767      cycles:k         ( +-  0.55% )
        940,046,382      cycles:u         ( +-  0.27% )

      33.60 +- 3.27 seconds time elapsed  ( +-  9.73% )

  + kallsym rbtree search

      2,199,433,771      cycles:k         ( +-  0.55% )
        936,105,469      cycles:u         ( +-  0.37% )

      26.48 +- 3.57 seconds time elapsed  ( +- 13.49% )

  + batch support

      1,456,854,867      cycles:k         ( +-  0.57% )
        937,737,431      cycles:u         ( +-  0.13% )

      12.44 +- 2.98 seconds time elapsed  ( +- 23.95% )

  + rcu fix

      1,427,959,119      cycles:k         ( +-  0.87% )
        930,833,507      cycles:u         ( +-  0.23% )

      14.53 +- 3.51 seconds time elapsed  ( +- 24.14% )


For attach_test numbers do not show direct time speedup when
using the batch support, but show big decrease in kernel cycles.
It seems the time is spent in rcu waiting, which I tried to
address in most likely wrong rcu fix:

  # ./test_progs -t attach_test

  - base

      1,350,136,760      cycles:k         ( +-  0.07% )
         70,591,712      cycles:u         ( +-  0.26% )

      24.26 +- 2.82 seconds time elapsed  ( +- 11.62% )

  + delayed link free

        996,152,309      cycles:k         ( +-  0.37% )
         69,263,150      cycles:u         ( +-  0.50% )

      15.63 +- 1.80 seconds time elapsed  ( +- 11.51% )

  + kallsym rbtree search

        390,217,706      cycles:k         ( +-  0.66% )
         68,999,019      cycles:u         ( +-  0.46% )

      14.11 +- 2.11 seconds time elapsed  ( +- 14.98% )

  + batch support

         37,410,887      cycles:k         ( +-  0.98% )
         70,062,158      cycles:u         ( +-  0.39% )

      26.80 +- 4.10 seconds time elapsed  ( +- 15.31% )

  + rcu fix

         36,812,432      cycles:k         ( +-  2.52% )
         69,907,191      cycles:u         ( +-  0.38% )

      15.04 +- 2.94 seconds time elapsed  ( +- 19.54% )


I still need to go through the changes and double check them,
also those ftrace changes are most likely wrong and most likely
I broke few tests (hence it's RFC), but I wonder you guys would
like this batch solution and if there are any thoughts on that.

Also available in
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  bpf/batch

thanks,
jirka


---
Jiri Olsa (16):
      ftrace: Add check_direct_entry function
      ftrace: Add adjust_direct_size function
      ftrace: Add get/put_direct_func function
      ftrace: Add ftrace_set_filter_ips function
      ftrace: Add register_ftrace_direct_ips function
      ftrace: Add unregister_ftrace_direct_ips function
      kallsyms: Use rb tree for kallsyms name search
      bpf: Use delayed link free in bpf_link_put
      bpf: Add BPF_TRAMPOLINE_BATCH_ATTACH support
      bpf: Add BPF_TRAMPOLINE_BATCH_DETACH support
      bpf: Sync uapi bpf.h to tools
      bpf: Move synchronize_rcu_mult for batch processing (NOT TO BE MERGED)
      libbpf: Add trampoline batch attach support
      libbpf: Add trampoline batch detach support
      selftests/bpf: Add trampoline batch test
      selftests/bpf: Add attach batch test (NOT TO BE MERGED)

 include/linux/bpf.h                                       |  18 +++++-
 include/linux/ftrace.h                                    |   7 +++
 include/uapi/linux/bpf.h                                  |   8 +++
 kernel/bpf/syscall.c                                      | 125 ++++++++++++++++++++++++++++++++++----
 kernel/bpf/trampoline.c                                   |  95 +++++++++++++++++++++++------
 kernel/kallsyms.c                                         |  95 ++++++++++++++++++++++++++---
 kernel/trace/ftrace.c                                     | 304 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------
 net/bpf/test_run.c                                        |  55 +++++++++++++++++
 tools/include/uapi/linux/bpf.h                            |   8 +++
 tools/lib/bpf/bpf.c                                       |  24 ++++++++
 tools/lib/bpf/bpf.h                                       |   2 +
 tools/lib/bpf/libbpf.c                                    | 126 ++++++++++++++++++++++++++++++++++++++-
 tools/lib/bpf/libbpf.h                                    |   5 +-
 tools/lib/bpf/libbpf.map                                  |   2 +
 tools/testing/selftests/bpf/prog_tests/attach_test.c      |  27 +++++++++
 tools/testing/selftests/bpf/prog_tests/trampoline_batch.c |  45 ++++++++++++++
 tools/testing/selftests/bpf/progs/attach_test.c           |  62 +++++++++++++++++++
 tools/testing/selftests/bpf/progs/trampoline_batch_test.c |  75 +++++++++++++++++++++++
 18 files changed, 995 insertions(+), 88 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/attach_test.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trampoline_batch.c
 create mode 100644 tools/testing/selftests/bpf/progs/attach_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/trampoline_batch_test.c

