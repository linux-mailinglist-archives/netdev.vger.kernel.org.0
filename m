Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2378427935E
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 23:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729610AbgIYVZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 17:25:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55385 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729389AbgIYVZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 17:25:08 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601069105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=aEnzxksqRh1B+nQ+8W94eyl0qY/PyM2cZQGSIIyPiRY=;
        b=b7ikav0ZXu5DizwgXbSw9TscrdBwyBdOXI34Zt5ynhCwTsczDn9NEv4Fghgoppt9NI170a
        OPv70jsdGTox7l6i2Ber7ImKeT3HQddGhehO7YdxsJiF3LYlbeWUl9wr1T/7dA+VtqRfV+
        CrvPy81OZOl4LNvyZuh3YK862TmV1ew=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-vhnsIe8wM4q8hhbws-_8Fw-1; Fri, 25 Sep 2020 17:25:02 -0400
X-MC-Unique: vhnsIe8wM4q8hhbws-_8Fw-1
Received: by mail-wr1-f71.google.com with SMTP id j7so1579259wro.14
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 14:25:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=aEnzxksqRh1B+nQ+8W94eyl0qY/PyM2cZQGSIIyPiRY=;
        b=SYNVIjDv1v/PLRnECl0RNr7KcKlXD8315rWP94UT38qdE+BiCRZiTTOHYxlclnW1Jx
         fqnFJULgKmLPYLYHAiC5jSQcl9YaxLgvFEy5jZlyvAzuveafzjJP8iMqhx0wmAAaX6VB
         RuST1qH/pM0C3Jmqy3I6EyYJ6U/xX0ypddKBiizkGxw6EQif1btupQXJ2dBDDerEbN9Y
         KoCpBTFfT+yagaB1Zo83TF68PppnEzdL0ClFMvAHk2Yp4AEVIqUctRw6hjIp3rl6sksg
         FbGMvbN9OmR6DM2OjLbZkkq1/c32hOuxFg00lOPGB8Egup0wDszW1u6ItcVdVnzgnNuM
         4aKg==
X-Gm-Message-State: AOAM5307tpLgqed8WvTlgD2Qjn75AQBRsSLfFjU+mow2gXaE4cdkUL8R
        TXk4jrvH+6tPk/u/od/5HwAOoPpsA79Rz+7/AADlgeNQVwJdT2s7bLIRkhvxPfTBFwkrpwqkdBw
        iAp8rHQH0vfjsa5ii
X-Received: by 2002:a1c:1f08:: with SMTP id f8mr498427wmf.168.1601069101170;
        Fri, 25 Sep 2020 14:25:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxCBIDtEUbf6PV8py/hqtMLm+4o7WhPSZZFZi/NKDCcIYsUFgi18SnmvBIQ9JMKm2u2lZQW6Q==
X-Received: by 2002:a1c:1f08:: with SMTP id f8mr498404wmf.168.1601069100906;
        Fri, 25 Sep 2020 14:25:00 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id a5sm4288286wrp.37.2020.09.25.14.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 14:25:00 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A5BAC183C5B; Fri, 25 Sep 2020 23:24:59 +0200 (CEST)
Subject: [PATCH bpf-next v9 00/11] bpf: Support multi-attach for freplace
 programs
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Fri, 25 Sep 2020 23:24:59 +0200
Message-ID: <160106909952.27725.8383447127582216829.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support attaching freplace BPF programs to multiple targets.
This is needed to support incremental attachment of multiple XDP programs using
the libxdp dispatcher model.

The first patch fixes an issue that came up in review: The verifier will
currently allow MODIFY_RETURN tracing functions to attach to other BPF programs,
even though it is pretty clear from the commit messages introducing the
functionality that this was not the intention. This patch is included in the
series because the subsequent refactoring patches touch the same code.

The next three patches are refactoring patches: Patch 2 is a trivial change to
the logging in the verifier, split out to make the subsequent refactor easier to
read. Patch 3 refactors check_attach_btf_id() so that the checks on program and
target compatibility can be reused when attaching to a secondary location.

Patch 4 moves prog_aux->linked_prog and the trampoline to be embedded in
bpf_tracing_link on attach, and freed by the link release logic, and introduces
a mutex to protect the writing of the pointers in prog->aux.

Based on these refactorings, it becomes pretty straight-forward to support
multiple-attach for freplace programs (patch 5). This is simply a matter of
creating a second bpf_tracing_link if a target is supplied. However, for API
consistency with other types of link attach, this option is added to the
BPF_LINK_CREATE API instead of extending bpf_raw_tracepoint_open().

Patch 6 is a port of Jiri Olsa's patch to support fentry/fexit on freplace
programs. His approach of getting the target type from the target program
reference no longer works after we've gotten rid of linked_prog (because the
bpf_tracing_link reference disappears on attach). Instead, we used the saved
reference to the target prog type that is also used to verify compatibility on
secondary freplace attachment.

Patches 7 is the accompanying libbpf update, and patches 8-11 are selftests:
patch 8 tests for the multi-freplace functionality itself; patch 9 is Jiri's
previous selftest for the fentry-to-freplace fix; patch 10 is a test for the
change introduced in patch 1, blocking MODIFY_RETURN functions from attaching to
other BPF programs; and finally, patch 11 removes the MODIFY_RETURN function
from test_overhead program in selftests, as this was never supposed to work in
the first place.

With this series, libxdp and xdp-tools can successfully attach multiple programs
one at a time. To play with this, use the 'freplace-multi-attach' branch of
xdp-tools:

$ git clone --recurse-submodules --branch freplace-multi-attach https://github.com/xdp-project/xdp-tools
$ cd xdp-tools/xdp-loader
$ make
$ sudo ./xdp-loader load veth0 ../lib/testing/xdp_drop.o
$ sudo ./xdp-loader load veth0 ../lib/testing/xdp_pass.o
$ sudo ./xdp-loader status

The series is also available here:
https://git.kernel.org/pub/scm/linux/kernel/git/toke/linux.git/log/?h=bpf-freplace-multi-attach-alt-09

Changelog:

v9:
  - Clarify commit message of patch 3
  - Add new struct bpf_attach_target_info for returning from
    bpf_check_attach_target() and passing to bpf_trampoline_get()
  - Move trampoline key computation into a helper
  - Make sure we don't break bpffs debug umh
  - Add some comment blocks explaining the logic flow in
    bpf_tracing_prog_attach()
  - s/tgt_/dst_/ in prog->aux, and for local variables using those members
  - Always drop dst_trampoline and dst_prog from prog->aux on first attach
  - Don't remove syscall fmod_ret test from selftest benchmarks
  - Add saved_ prefix to dst_{prog,attach}_type members in prog_aux
  - Drop prog argument from check_attach_modify_return()
  - Add comment about possible NULL of tr_link->tgt_prog on link_release()

v8:
  - Add a separate error message when trying to attach FMOD_REPLACE to tgt_prog
  - Better error messages in bpf_program__attach_freplace()
  - Don't lock mutex when setting tgt_* pointers in prog create and verifier
  - Remove fmod_ret programs from benchmarks in selftests (new patch 11)
  - Fix a few other nits in selftests

v7:
  - Add back missing ptype == prog->type check in link_create()
  - Use tracing_bpf_link_attach() instead of separate freplace_bpf_link_attach()
  - Don't break attachment of bpf_iters in libbpf (by clobbering link_create.iter_info)

v6:
  - Rebase to latest bpf-next
  - Simplify logic in bpf_tracing_prog_attach()
  - Don't create a new attach_type for link_create(), disambiguate on prog->type
    instead
  - Use raw_tracepoint_open() in libbpf bpf_program__attach_ftrace() if called
    with NULL target
  - Switch bpf_program__attach_ftrace() to take function name as parameter
    instead of btf_id
  - Add a patch disallowing MODIFY_RETURN programs from attaching to other BPF
    programs, and an accompanying selftest (patches 1 and 10)

v5:
  - Fix typo in inline function definition of bpf_trampoline_get()
  - Don't put bpf_tracing_link in prog->aux, use a mutex to protect tgt_prog and
    trampoline instead, and move them to the link on attach.
  - Restore Jiri as author of the last selftest patch

v4:
  - Cleanup the refactored check_attach_btf_id() to make the logic easier to follow
  - Fix cleanup paths for bpf_tracing_link
  - Use xchg() for removing the bpf_tracing_link from prog->aux and restore on (some) failures
  - Use BPF_LINK_CREATE operation to create link with target instead of extending raw_tracepoint_open
  - Fold update of tools/ UAPI header into main patch
  - Update arg dereference patch to use skeletons and set_attach_target()

v3:
  - Get rid of prog_aux->linked_prog entirely in favour of a bpf_tracing_link
  - Incorporate Jiri's fix for attaching fentry to freplace programs

v2:
  - Drop the log arguments from bpf_raw_tracepoint_open
  - Fix kbot errors
  - Rebase to latest bpf-next

---

Jiri Olsa (1):
      selftests/bpf: Adding test for arg dereference in extension trace

Toke Høiland-Jørgensen (10):
      bpf: disallow attaching modify_return tracing functions to other BPF programs
      bpf: change logging calls from verbose() to bpf_log() and use log pointer
      bpf: verifier: refactor check_attach_btf_id()
      bpf: move prog->aux->linked_prog and trampoline into bpf_link on attach
      bpf: support attaching freplace programs to multiple attach points
      bpf: Fix context type resolving for extension programs
      libbpf: add support for freplace attachment in bpf_link_create
      selftests: add test for multiple attachments of freplace program
      selftests: Add selftest for disallowing modify_return attachment to freplace
      selftests: Remove fmod_ret from test_overhead


 include/linux/bpf.h                           |  36 +-
 include/linux/bpf_verifier.h                  |  18 +-
 include/uapi/linux/bpf.h                      |   9 +-
 kernel/bpf/btf.c                              |  27 +-
 kernel/bpf/core.c                             |   9 +-
 kernel/bpf/preload/iterators/iterators.bpf.c  |   4 +-
 kernel/bpf/preload/iterators/iterators.skel.h | 444 +++++++++---------
 kernel/bpf/syscall.c                          | 180 ++++++-
 kernel/bpf/trampoline.c                       |  34 +-
 kernel/bpf/verifier.c                         | 263 ++++++-----
 tools/include/uapi/linux/bpf.h                |   9 +-
 tools/lib/bpf/bpf.c                           |  18 +-
 tools/lib/bpf/bpf.h                           |   3 +-
 tools/lib/bpf/libbpf.c                        |  44 +-
 tools/lib/bpf/libbpf.h                        |   3 +
 tools/lib/bpf/libbpf.map                      |   1 +
 tools/testing/selftests/bpf/bench.c           |   3 -
 .../selftests/bpf/benchs/bench_rename.c       |  17 -
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  | 212 +++++++--
 .../selftests/bpf/prog_tests/test_overhead.c  |  14 +-
 .../selftests/bpf/prog_tests/trace_ext.c      | 111 +++++
 .../selftests/bpf/progs/fmod_ret_freplace.c   |  14 +
 .../bpf/progs/freplace_get_constant.c         |  15 +
 .../selftests/bpf/progs/test_overhead.c       |   6 -
 .../selftests/bpf/progs/test_trace_ext.c      |  18 +
 .../bpf/progs/test_trace_ext_tracing.c        |  25 +
 26 files changed, 1052 insertions(+), 485 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_ext.c
 create mode 100644 tools/testing/selftests/bpf/progs/fmod_ret_freplace.c
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_get_constant.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_trace_ext.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_trace_ext_tracing.c

