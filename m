Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41420143C7A
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 13:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbgAUMFW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 Jan 2020 07:05:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25716 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728829AbgAUMFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 07:05:22 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-71-uFXlhn5TO0--SMKwk1f7_Q-1; Tue, 21 Jan 2020 07:05:17 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB3DE477;
        Tue, 21 Jan 2020 12:05:15 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D6F85C28D;
        Tue, 21 Jan 2020 12:05:12 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCHv3 0/6] bpf: Add trampoline helpers
Date:   Tue, 21 Jan 2020 13:05:06 +0100
Message-Id: <20200121120512.758929-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: uFXlhn5TO0--SMKwk1f7_Q-1
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

v3 changes:
  - added ack from John Fastabend for patch 1
  - move out is_bpf_image_address from is_bpf_text_address call [David]

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

 include/linux/bpf.h                                       |  12 +++++++++++-
 kernel/bpf/btf.c                                          |  13 ++++++++++++-
 kernel/bpf/dispatcher.c                                   |   4 ++--
 kernel/bpf/trampoline.c                                   |  82 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 kernel/extable.c                                          |   7 +++++--
 kernel/trace/bpf_trace.c                                  |  96 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/prog_tests/trampoline_count.c | 112 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/test_trampoline_count.c |  21 +++++++++++++++++++++
 8 files changed, 334 insertions(+), 13 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trampoline_count.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_trampoline_count.c

