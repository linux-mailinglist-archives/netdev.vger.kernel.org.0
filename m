Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C25274858
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 20:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbgIVSjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 14:39:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32489 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726662AbgIVSir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 14:38:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600799924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=1ufYhZg07mVp/p55VuIHakTMZVtF1/iAU5XGfbdslF4=;
        b=J8sYjJEyNTUI92V22Y+vmsGMncGQ8XiMSICmNE1Bp3XsC4FEMLC/QYDDSKBPvrCeoDsV4b
        2x/viscDlD4NY4MjWqGVPngtouJeOp8MgRqadIChrTYsXdYetRiFaJksPMovWNDpg/NDaS
        uKBm1iKbuJJas1RtIUK5ZDh+1CJtVvc=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-nCiF5r8iODeH1wtz7q-EJQ-1; Tue, 22 Sep 2020 14:38:41 -0400
X-MC-Unique: nCiF5r8iODeH1wtz7q-EJQ-1
Received: by mail-pg1-f198.google.com with SMTP id 26so11280429pgp.2
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 11:38:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=1ufYhZg07mVp/p55VuIHakTMZVtF1/iAU5XGfbdslF4=;
        b=pYUf+PK4en978D5vugsbhylb/Bh1DIjYsDIwzy6m07nluG8kDK67gsQQYkaBz5Qrn/
         YHH2D6y9sVpShxEGVH3Q/6sOY18g/AeNSoXffaEkloC/wN0KSOd0QnManWz6LnvVfwwi
         ktHpKsz97Hq0QKPFT4PfXl5g5Hhb9c6BsM7BdwjE7/VmnkGsVVHSUFcqB+cFOD5e/u0T
         KFpLXd8jTWeSjVRqwd3VeAVytLFs15c9yzuaV3tlO8pM47AA1pOq9+1Kv1sJpeRAlhUZ
         Za379dxGuHMP4xioZ6ZPHNZJMGxSY9QUBfCAxvNyB+U4kbFPV8GcGWCUw+2vvshFmWZ2
         Nu1w==
X-Gm-Message-State: AOAM533bFA8SS5FarAT/iE+MzyJwdlc9XmtdvMkgGH/IuKqoLlUGn5X6
        fzapkVZRJf3JUTzEw3NDkNye7y9Gc71b5oQp5r9KV5PhfzSroRiAfXXtFGHU+NATKkAG1VQlIAc
        pdy5Fx8I/XPqTKZA6
X-Received: by 2002:a63:4459:: with SMTP id t25mr2694106pgk.104.1600799920402;
        Tue, 22 Sep 2020 11:38:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzlahJduRYzskcb7hU8ANN24M6Pmp2CE7YhqXKfGzU3JwaXKCB/Uk+xQ+1lyYFsovmXo6g+Ew==
X-Received: by 2002:a63:4459:: with SMTP id t25mr2694072pgk.104.1600799919938;
        Tue, 22 Sep 2020 11:38:39 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id v10sm2970061pjf.34.2020.09.22.11.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 11:38:39 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D19C3183A8F; Tue, 22 Sep 2020 20:38:33 +0200 (CEST)
Subject: [PATCH bpf-next v8 00/11] bpf: Support multi-attach for freplace
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
Date:   Tue, 22 Sep 2020 20:38:33 +0200
Message-ID: <160079991372.8301.10648588027560707258.stgit@toke.dk>
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
other BPF programs; and finally, patch 11 removes MODIFY_RETURN functions from
the benchmark and test_overhead programs in selftests, as these were never
supposed to work in the first place.

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
https://git.kernel.org/pub/scm/linux/kernel/git/toke/linux.git/log/?h=bpf-freplace-multi-attach-alt-08

Changelog:

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
      selftests: Remove fmod_ret from benchmarks and test_overhead


 include/linux/bpf.h                           |  26 +-
 include/linux/bpf_verifier.h                  |  14 +-
 include/uapi/linux/bpf.h                      |   9 +-
 kernel/bpf/btf.c                              |  21 +-
 kernel/bpf/core.c                             |   9 +-
 kernel/bpf/syscall.c                          | 135 ++++++++--
 kernel/bpf/trampoline.c                       |  32 ++-
 kernel/bpf/verifier.c                         | 250 ++++++++++--------
 tools/include/uapi/linux/bpf.h                |   9 +-
 tools/lib/bpf/bpf.c                           |  18 +-
 tools/lib/bpf/bpf.h                           |   3 +-
 tools/lib/bpf/libbpf.c                        |  44 ++-
 tools/lib/bpf/libbpf.h                        |   3 +
 tools/lib/bpf/libbpf.map                      |   1 +
 tools/testing/selftests/bpf/bench.c           |   5 -
 .../selftests/bpf/benchs/bench_rename.c       |  17 --
 .../selftests/bpf/benchs/bench_trigger.c      |  17 --
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  | 212 ++++++++++++---
 .../selftests/bpf/prog_tests/test_overhead.c  |  14 +-
 .../selftests/bpf/prog_tests/trace_ext.c      | 111 ++++++++
 .../selftests/bpf/progs/fmod_ret_freplace.c   |  14 +
 .../bpf/progs/freplace_get_constant.c         |  15 ++
 .../selftests/bpf/progs/test_overhead.c       |   6 -
 .../selftests/bpf/progs/test_trace_ext.c      |  18 ++
 .../bpf/progs/test_trace_ext_tracing.c        |  25 ++
 .../selftests/bpf/progs/trigger_bench.c       |   7 -
 26 files changed, 771 insertions(+), 264 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_ext.c
 create mode 100644 tools/testing/selftests/bpf/progs/fmod_ret_freplace.c
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_get_constant.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_trace_ext.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_trace_ext_tracing.c

