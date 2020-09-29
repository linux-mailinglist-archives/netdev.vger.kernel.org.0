Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6A927CE38
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 14:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729648AbgI2Mzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 08:55:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49946 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729307AbgI2Mzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 08:55:48 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601384146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=z0mOWDzsWiiH8Jf3EZHvZUXIwlqc+nZpBB7WoCjGzR0=;
        b=U6xKmQgeZTOxHma+bXl/tqd03DS/64+7h10aKKPnDHq5TDoTtj9Fv6ps3JyN7izmKmD9Kw
        uWsFC290E5o/Y8Yyo1vTp5qr0pLm6/VZ07gqyg4/LmShFkLn8GSzfbtrPydx0Vj6BesHrh
        Tdy+SUsvIa+NuPo0jje2UqfPW4kybrA=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-MpTH4w3KM6OEjpa_se1KqA-1; Tue, 29 Sep 2020 08:55:43 -0400
X-MC-Unique: MpTH4w3KM6OEjpa_se1KqA-1
Received: by mail-oo1-f70.google.com with SMTP id p17so2011356ooe.22
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 05:55:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=z0mOWDzsWiiH8Jf3EZHvZUXIwlqc+nZpBB7WoCjGzR0=;
        b=SBHTViGWGyAnUH2DBEjrfuLozNa4nvernF84zegwydJxULaOgd/y/RPwLIae1uM71/
         Jm8rPUDS/Vd3rNBl4dJ69oho42SKotZR9IJpEA8uTkkINLqw8VEy248eqzjQET95egnj
         TeAQeoPHTpMN0aUAlxXkCKQ3sss6stwSxab50DVzBTBBFfKk6HXmTBrs00txjnXPq/xd
         5eeefr/r7EGdpNmltI45mfzdfwi3u0jvTgYAc+Fe7bYqIafzUQqPSmIann85oujKBd0j
         ye6GJiB8hqw4pV1AO9wDQJmbR57yaEmUMwqOwNk7wHINZvWuzFSQBZYWKJ7GpNZ9o73N
         rp9A==
X-Gm-Message-State: AOAM5317qGO+3CAXyqqWA6c5Vvmz3Hvy+SVVK7Qv368PStLL5U9uEpiy
        wKucCzIAPnLhOnZfuCq+7soVgo3jonWHiDlmOFLBIX5tLaSOVFr+6JqSRc5eelV8oGr9A69FTvF
        42oJow4UmOxRXzC/W
X-Received: by 2002:aca:4d89:: with SMTP id a131mr2465306oib.69.1601384142691;
        Tue, 29 Sep 2020 05:55:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz4l7INAd0F4fimbz0ScQfy2Erv8uNLc1Yx/zCDgGWmyl8VU2tz4FYUNW9aS8knL1nI4w4VzQ==
X-Received: by 2002:aca:4d89:: with SMTP id a131mr2465285oib.69.1601384142405;
        Tue, 29 Sep 2020 05:55:42 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id z5sm966850otp.16.2020.09.29.05.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 05:55:41 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 93FBE183C5B; Tue, 29 Sep 2020 14:45:49 +0200 (CEST)
Subject: [PATCH bpf-next v10 0/7] bpf: Support multi-attach for freplace
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
Date:   Tue, 29 Sep 2020 14:45:49 +0200
Message-ID: <160138354947.48470.11523413403103182788.stgit@toke.dk>
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

Patch 1 moves prog_aux->linked_prog and the trampoline to be embedded in
bpf_tracing_link on attach, and freed by the link release logic, and introduces
a mutex to protect the writing of the pointers in prog->aux.

Based on this refactoring (and previously applied patches), it becomes pretty
straight-forward to support multiple-attach for freplace programs (patch 2).
This is simply a matter of creating a second bpf_tracing_link if a target is
supplied. However, for API consistency with other types of link attach, this
option is added to the BPF_LINK_CREATE API instead of extending
bpf_raw_tracepoint_open().

Patch 3 is a port of Jiri Olsa's patch to support fentry/fexit on freplace
programs. His approach of getting the target type from the target program
reference no longer works after we've gotten rid of linked_prog (because the
bpf_tracing_link reference disappears on attach). Instead, we used the saved
reference to the target prog type that is also used to verify compatibility on
secondary freplace attachment.

Patch 4 is the accompanying libbpf update, and patches 5-7 are selftests: patch
5 tests for the multi-freplace functionality itself; patch 6 is Jiri's previous
selftest for the fentry-to-freplace fix; patch 7 is a test for the change
introduced in the previously-applied patches, blocking MODIFY_RETURN functions
from attaching to other BPF programs.

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
https://git.kernel.org/pub/scm/linux/kernel/git/toke/linux.git/log/?h=bpf-freplace-multi-attach-alt-10

Changelog:

v10:
  - Dial back the s/tgt_/dst_/ replacement a bit
  - Fix smatch warning (from ktest robot)
  - Rebase to bpf-next, drop already-applied patches

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

Toke Høiland-Jørgensen (6):
      bpf: move prog->aux->linked_prog and trampoline into bpf_link on attach
      bpf: support attaching freplace programs to multiple attach points
      bpf: Fix context type resolving for extension programs
      libbpf: add support for freplace attachment in bpf_link_create
      selftests: add test for multiple attachments of freplace program
      selftests: Add selftest for disallowing modify_return attachment to freplace


 include/linux/bpf.h                           |   2 +
 include/uapi/linux/bpf.h                      |   9 +-
 kernel/bpf/btf.c                              |   9 +-
 kernel/bpf/syscall.c                          | 132 +++++++++--
 kernel/bpf/verifier.c                         |  10 +
 tools/include/uapi/linux/bpf.h                |   9 +-
 tools/lib/bpf/bpf.c                           |  18 +-
 tools/lib/bpf/bpf.h                           |   3 +-
 tools/lib/bpf/libbpf.c                        |  44 +++-
 tools/lib/bpf/libbpf.h                        |   3 +
 tools/lib/bpf/libbpf.map                      |   1 +
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  | 212 +++++++++++++++---
 .../selftests/bpf/prog_tests/trace_ext.c      | 111 +++++++++
 .../selftests/bpf/progs/fmod_ret_freplace.c   |  14 ++
 .../bpf/progs/freplace_get_constant.c         |  15 ++
 .../selftests/bpf/progs/test_trace_ext.c      |  18 ++
 .../bpf/progs/test_trace_ext_tracing.c        |  25 +++
 17 files changed, 573 insertions(+), 62 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_ext.c
 create mode 100644 tools/testing/selftests/bpf/progs/fmod_ret_freplace.c
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_get_constant.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_trace_ext.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_trace_ext_tracing.c

