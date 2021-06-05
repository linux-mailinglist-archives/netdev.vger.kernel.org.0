Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B780039C7B4
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 13:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhFELMe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 5 Jun 2021 07:12:34 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:50047 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229933AbhFELMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 07:12:34 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-KyvyrXyPNyKsUF9eqffobQ-1; Sat, 05 Jun 2021 07:10:40 -0400
X-MC-Unique: KyvyrXyPNyKsUF9eqffobQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 508E7801817;
        Sat,  5 Jun 2021 11:10:38 +0000 (UTC)
Received: from krava.cust.in.nbox.cz (unknown [10.40.192.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 32DCA614FD;
        Sat,  5 Jun 2021 11:10:35 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: [RFCv3 00/19] x86/ftrace/bpf: Add batch support for direct/tracing attach
Date:   Sat,  5 Jun 2021 13:10:15 +0200
Message-Id: <20210605111034.1810858-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
saga continues.. ;-) previous post is in here [1]

After another discussion with Steven, he mentioned that if we fix
the ftrace graph problem with direct functions, he'd be open to
add batch interface for direct ftrace functions.

He already had prove of concept fix for that, which I took and broke
up into several changes. I added the ftrace direct batch interface
and bpf new interface on top of that.

It's not so many patches after all, so I thought having them all
together will help the review, because they are all connected.
However I can break this up into separate patchsets if necessary.

This patchset contains:

  1) patches (1-4) that fix the ftrace graph tracing over the function
     with direct trampolines attached
  2) patches (5-8) that add batch interface for ftrace direct function
     register/unregister/modify
  3) patches (9-19) that add support to attach BPF program to multiple
     functions

In nutshell:

Ad 1) moves the graph tracing setup before the direct trampoline
prepares the stack, so they don't clash

Ad 2) uses ftrace_ops interface to register direct function with
all functions in ftrace_ops filter.

Ad 3) creates special program and trampoline type to allow attachment
of multiple functions to single program.

There're more detailed desriptions in related changelogs.

I have working bpftrace multi attachment code on top this. I briefly
checked retsnoop and I think it could use the new API as well.


Also available at:
  https://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  bpf/batch

thanks,
jirka


[1] https://lore.kernel.org/bpf/20210413121516.1467989-1-jolsa@kernel.org/

---
Jiri Olsa (17):
      x86/ftrace: Remove extra orig rax move
      tracing: Add trampoline/graph selftest
      ftrace: Add ftrace_add_rec_direct function
      ftrace: Add multi direct register/unregister interface
      ftrace: Add multi direct modify interface
      ftrace/samples: Add multi direct interface test module
      bpf, x64: Allow to use caller address from stack
      bpf: Allow to store caller's ip as argument
      bpf: Add support to load multi func tracing program
      bpf: Add bpf_trampoline_alloc function
      bpf: Add support to link multi func tracing program
      libbpf: Add btf__find_by_pattern_kind function
      libbpf: Add support to link multi func tracing program
      selftests/bpf: Add fentry multi func test
      selftests/bpf: Add fexit multi func test
      selftests/bpf: Add fentry/fexit multi func test
      selftests/bpf: Temporary fix for fentry_fexit_multi_test

Steven Rostedt (VMware) (2):
      x86/ftrace: Remove fault protection code in prepare_ftrace_return
      x86/ftrace: Make function graph use ftrace directly

 arch/x86/include/asm/ftrace.h                                    |   9 ++++--
 arch/x86/kernel/ftrace.c                                         |  71 ++++++++++++++++++++++-----------------------
 arch/x86/kernel/ftrace_64.S                                      |  30 +------------------
 arch/x86/net/bpf_jit_comp.c                                      |  31 ++++++++++++++------
 include/linux/bpf.h                                              |  14 +++++++++
 include/linux/ftrace.h                                           |  22 ++++++++++++++
 include/uapi/linux/bpf.h                                         |  12 ++++++++
 kernel/bpf/btf.c                                                 |   5 ++++
 kernel/bpf/syscall.c                                             | 220 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 kernel/bpf/trampoline.c                                          |  83 ++++++++++++++++++++++++++++++++++++++---------------
 kernel/bpf/verifier.c                                            |   3 +-
 kernel/trace/fgraph.c                                            |   8 ++++--
 kernel/trace/ftrace.c                                            | 211 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------
 kernel/trace/trace_selftest.c                                    |  49 ++++++++++++++++++++++++++++++-
 samples/ftrace/Makefile                                          |   1 +
 samples/ftrace/ftrace-direct-multi.c                             |  52 +++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h                                   |  12 ++++++++
 tools/lib/bpf/bpf.c                                              |  11 ++++++-
 tools/lib/bpf/bpf.h                                              |   4 ++-
 tools/lib/bpf/btf.c                                              |  68 +++++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/btf.h                                              |   3 ++
 tools/lib/bpf/libbpf.c                                           |  72 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/multi_check.h                        |  53 ++++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/prog_tests/fentry_fexit_multi_test.c |  52 +++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/prog_tests/fentry_multi_test.c       |  43 +++++++++++++++++++++++++++
 tools/testing/selftests/bpf/prog_tests/fexit_multi_test.c        |  44 ++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/fentry_fexit_multi_test.c      |  31 ++++++++++++++++++++
 tools/testing/selftests/bpf/progs/fentry_multi_test.c            |  20 +++++++++++++
 tools/testing/selftests/bpf/progs/fexit_multi_test.c             |  22 ++++++++++++++
 29 files changed, 1121 insertions(+), 135 deletions(-)
 create mode 100644 samples/ftrace/ftrace-direct-multi.c
 create mode 100644 tools/testing/selftests/bpf/multi_check.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/fentry_fexit_multi_test.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/fentry_multi_test.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/fexit_multi_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/fentry_fexit_multi_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/fentry_multi_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/fexit_multi_test.c

