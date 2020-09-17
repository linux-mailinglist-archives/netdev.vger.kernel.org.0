Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F3826E68F
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 22:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgIQUUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 16:20:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51328 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726551AbgIQUUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 16:20:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600374007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Y/gm/lqx1rB+klxtCVXjA/M0emGyI14+LImzRquikw0=;
        b=gfn7ZHAHUhetjKXk7ZG4p7qw80tF1dBWJ9skeVex8vHE2i60j9tY8vPATPdJRCsvKWtCDv
        9nd0CmbqvjiVYUlabp3QEevTTEIxXtw678Gs/NNtEOYRFVzfdsFTT6VP0e3beNLVTA5c4k
        7cixPSTolGGavc4oC86ZxyceHf8WJZI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-G7CImC-7Pb2eTJMSepjkNA-1; Thu, 17 Sep 2020 16:20:04 -0400
X-MC-Unique: G7CImC-7Pb2eTJMSepjkNA-1
Received: by mail-ed1-f69.google.com with SMTP id i22so1393569edu.1
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 13:20:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=Y/gm/lqx1rB+klxtCVXjA/M0emGyI14+LImzRquikw0=;
        b=GHO8RwtlyrwAmZ5QcV0xf/c5HGABX3QiTeLhvms9lXyJ3zcSuV8kN+ho7hp5RnMrAS
         5IH4YLRmlVrX+rZOtQTERlsRs/zrYlwjhsA4K6wca8tb6AqIbcHxzbQo+jM5c6v/b6mS
         dY3fnjEKwUeOT1nD369+YcBgleFltVCRKgpWqEVMxKTCMaNpWt3G78fnwTMLolVJujNB
         b9YiMu7jJIaB34T0qZ/n6vFbvaKqnt84r1KHrJwGRCnZ22H+3tiiMvjj1TAlpCFAJqeB
         8cYknGqziZgUTi8B0XPSemL5cGZpWk1UH5uE8VuXr6D9FG+l4Irn3pNbtr0b3yqmim3n
         KKwg==
X-Gm-Message-State: AOAM530vDYzfMGvPWeUqaIA4twtHOn8Vce6W9L+kQNNsSq0GnY4Lzt/Z
        Ig61fV9Wc1QEIL0bhljnNDtUbt3QuI7ifcQiMkiDN0vBzRGD2ln2OJOsgkSfm6L2iPUysbE7ozB
        vQmcdjWl4iSCoNbI3
X-Received: by 2002:a17:906:4e4a:: with SMTP id g10mr31503553ejw.274.1600374002460;
        Thu, 17 Sep 2020 13:20:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9Hic0whsoTUweQJ68zOVwjwPa9dGu40GsFYMsZk094psyGbsiKkBquOxWnQHpFyDf0tQngQ==
X-Received: by 2002:a17:906:4e4a:: with SMTP id g10mr31503526ejw.274.1600374002030;
        Thu, 17 Sep 2020 13:20:02 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id h13sm691706ejl.77.2020.09.17.13.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 13:20:01 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id AD54F183A90; Thu, 17 Sep 2020 22:20:00 +0200 (CEST)
Subject: [PATCH bpf-next v6 00/10] bpf: Support multi-attach for freplace
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
Date:   Thu, 17 Sep 2020 22:20:00 +0200
Message-ID: <160037400056.28970.7647821897296177963.stgit@toke.dk>
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
serise because the subsequent refactoring patches touch the same code.

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

Patches 7 is the accompanying libbpf update, and patches 8-10 are selftests:
patch 8 tests for the multi-freplace functionality itself, patch 9 is Jiri's
previous selftest for the fentry-to-freplace fix, and patch 10 is a test for
the change introduced in patch 1, blocking MODIFY_RETURN functions from
attaching to other BPF programs.

With this series, libxdp and xdp-tools can successfully attach multiple programs
one at a time. To play with this, use the 'freplace-multi-attach' branch of
xdp-tools:

$ git clone --recurse-submodules --branch freplace-multi-attach https://github.com/xdp-project/xdp-tools
$ cd xdp-tools
$ make
$ sudo ./xdp-loader/xdp-loader load veth0 lib/testing/xdp_drop.o
$ sudo ./xdp-loader/xdp-loader load veth0 lib/testing/xdp_pass.o
$ sudo ./xdp-loader/xdp-loader status

The series is also available here:
https://git.kernel.org/pub/scm/linux/kernel/git/toke/linux.git/log/?h=bpf-freplace-multi-attach-alt-06

Changelog:

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

Toke Høiland-Jørgensen (9):
      bpf: disallow attaching modify_return tracing functions to other BPF programs
      bpf: change logging calls from verbose() to bpf_log() and use log pointer
      bpf: verifier: refactor check_attach_btf_id()
      bpf: move prog->aux->linked_prog and trampoline into bpf_link on attach
      bpf: support attaching freplace programs to multiple attach points
      bpf: Fix context type resolving for extension programs
      libbpf: add support for freplace attachment in bpf_link_create
      selftests: add test for multiple attachments of freplace program
      selftests: Add selftest for disallowing modify_return attachment to freplace


 include/linux/bpf.h                           |  26 +-
 include/linux/bpf_verifier.h                  |  14 +-
 include/uapi/linux/bpf.h                      |   9 +-
 kernel/bpf/btf.c                              |  21 +-
 kernel/bpf/core.c                             |   9 +-
 kernel/bpf/syscall.c                          | 136 ++++++++--
 kernel/bpf/trampoline.c                       |  32 ++-
 kernel/bpf/verifier.c                         | 247 ++++++++++--------
 tools/include/uapi/linux/bpf.h                |   9 +-
 tools/lib/bpf/bpf.c                           |   1 +
 tools/lib/bpf/bpf.h                           |   3 +-
 tools/lib/bpf/libbpf.c                        |  36 ++-
 tools/lib/bpf/libbpf.h                        |   3 +
 tools/lib/bpf/libbpf.map                      |   1 +
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  | 225 +++++++++++++---
 .../selftests/bpf/prog_tests/trace_ext.c      | 111 ++++++++
 .../selftests/bpf/progs/fmod_ret_freplace.c   |  14 +
 .../bpf/progs/freplace_get_constant.c         |  15 ++
 .../selftests/bpf/progs/test_trace_ext.c      |  18 ++
 .../bpf/progs/test_trace_ext_tracing.c        |  25 ++
 20 files changed, 765 insertions(+), 190 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_ext.c
 create mode 100644 tools/testing/selftests/bpf/progs/fmod_ret_freplace.c
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_get_constant.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_trace_ext.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_trace_ext_tracing.c

