Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA13235DE7F
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 14:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345479AbhDMMQf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 13 Apr 2021 08:16:35 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:52094 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231329AbhDMMQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 08:16:17 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-4x3DzP0wMy64Z040bCIsnQ-1; Tue, 13 Apr 2021 08:15:50 -0400
X-MC-Unique: 4x3DzP0wMy64Z040bCIsnQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B7B23101521A;
        Tue, 13 Apr 2021 12:15:20 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.196.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 136B010023B0;
        Tue, 13 Apr 2021 12:15:16 +0000 (UTC)
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
Subject: [PATCHv2 RFC bpf-next 0/7] bpf: Add support for ftrace probe
Date:   Tue, 13 Apr 2021 14:15:09 +0200
Message-Id: <20210413121516.1467989-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
sending another attempt on speeding up load of multiple probes
for bpftrace and possibly other tools (first post in [1]).

This patchset adds support to attach bpf program directly to
ftrace probe as suggested by Steven and it speeds up loading
for bpftrace commands like:

   # bpftrace -e 'kfunc:_raw_spin* { @[probe] = count(); }'
   # bpftrace -e 'kfunc:ksys_* { @[probe] = count(); }'

Using ftrace with single bpf program for attachment to multiple
functions is much faster than current approach, where we need to
load and attach program for each probe function.

Also available in
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  bpf/ftrace

thanks,
jirka


[1] https://lore.kernel.org/bpf/20201022082138.2322434-1-jolsa@kernel.org/
---
Jiri Olsa (7):
      bpf: Move bpf_prog_start/end functions to generic place
      bpf: Add bpf_functions object
      bpf: Add support to attach program to ftrace probe
      libbpf: Add btf__find_by_pattern_kind function
      libbpf: Add support to load and attach ftrace probe
      selftests/bpf: Add ftrace probe to fentry test
      selftests/bpf: Add ftrace probe test

 include/uapi/linux/bpf.h                             |   8 ++++
 kernel/bpf/syscall.c                                 | 381 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/bpf/trampoline.c                              |  97 ---------------------------------------
 kernel/bpf/verifier.c                                |  27 +++++++++++
 net/bpf/test_run.c                                   |   1 +
 tools/include/uapi/linux/bpf.h                       |   8 ++++
 tools/lib/bpf/bpf.c                                  |  12 +++++
 tools/lib/bpf/bpf.h                                  |   5 +-
 tools/lib/bpf/btf.c                                  |  67 +++++++++++++++++++++++++++
 tools/lib/bpf/btf.h                                  |   3 ++
 tools/lib/bpf/libbpf.c                               |  74 ++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.map                             |   1 +
 tools/testing/selftests/bpf/prog_tests/fentry_test.c |   5 +-
 tools/testing/selftests/bpf/prog_tests/ftrace_test.c |  48 +++++++++++++++++++
 tools/testing/selftests/bpf/progs/fentry_test.c      |  16 +++++++
 tools/testing/selftests/bpf/progs/ftrace_test.c      |  17 +++++++
 16 files changed, 671 insertions(+), 99 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ftrace_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/ftrace_test.c

