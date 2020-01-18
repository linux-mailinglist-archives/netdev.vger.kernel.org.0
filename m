Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3ADF1417C2
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 14:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgARNt5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 18 Jan 2020 08:49:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49545 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726119AbgARNt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 08:49:57 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-94-NdrTT-lbOJSwe5B7hTSNAQ-1; Sat, 18 Jan 2020 08:49:52 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BD4F8017CC;
        Sat, 18 Jan 2020 13:49:51 +0000 (UTC)
Received: from krava.redhat.com (ovpn-204-18.brq.redhat.com [10.40.204.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C02CC84BD4;
        Sat, 18 Jan 2020 13:49:46 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>
Subject: [PATCHv2 0/6] bpf: Add trampoline helpers
Date:   Sat, 18 Jan 2020 14:49:39 +0100
Message-Id: <20200118134945.493811-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: NdrTT-lbOJSwe5B7hTSNAQ-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
adding helpers for trampolines and 2 other fixes to have kernel
support for loading trampoline programs in bcc/bpftrace.

Original rfc post [1].

Speedup output of perf bench while running klockstat.py
on kprobes vs trampolines:

    Without:
            $ perf bench sched messaging -l 50000
            ...
                 Total time: 18.571 [sec]

    With current kprobe tracing:
            $ perf bench sched messaging -l 50000
            ...
                 Total time: 183.395 [sec]

    With kfunc tracing:
            $ perf bench sched messaging -l 50000
            ...
                 Total time: 39.773 [sec]

v2 changes:
  - make the unwind work for dispatcher as well
  - added test for allowed trampolines count
  - used raw tp pt_regs nest-arrays for trampoline helpers

thanks,
jirka


[1] https://lore.kernel.org/netdev/20191229143740.29143-1-jolsa@kernel.org/
---
Jiri Olsa (6):
      bpf: Allow ctx access for pointers to scalar
      bpf: Add bpf_perf_event_output_kfunc
      bpf: Add bpf_get_stackid_kfunc
      bpf: Add bpf_get_stack_kfunc
      bpf: Allow to resolve bpf trampoline and dispatcher in unwind
      selftest/bpf: Add test for allowed trampolines count

 include/linux/bpf.h                                       |  12 +++++++++-
 kernel/bpf/btf.c                                          |  13 ++++++++++-
 kernel/bpf/core.c                                         |   2 ++
 kernel/bpf/dispatcher.c                                   |   4 ++--
 kernel/bpf/trampoline.c                                   |  76 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 kernel/trace/bpf_trace.c                                  |  96 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/prog_tests/trampoline_count.c | 112 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/test_trampoline_count.c |  21 ++++++++++++++++++
 8 files changed, 325 insertions(+), 11 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trampoline_count.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_trampoline_count.c

