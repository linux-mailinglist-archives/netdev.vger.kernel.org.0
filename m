Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F2626A452
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 13:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726459AbgIOLni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 07:43:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47508 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726402AbgIOLlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 07:41:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600170065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=lVdU1+8kxfw+iqnZ6/wziKf6qV1Zbe2adj4szOHPMw8=;
        b=Ss8sTz2EHlCUUErQJzrRYx9p8puFFB729vT4wEg3aaR8QRfa1E5sGu8zfc7B1yg+UqCfY0
        oAmO7A7yyfrjo9Qbv4rMxVgRwrlAbIzNTsFQgSxt7zQxxMWkReK+Q2SdG17kHDjaszKMDW
        bz4PX+wxs6EggblWsowqmr1Xymk3XyQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-575-NUMIMujWNkuIFJyjvOk4aA-1; Tue, 15 Sep 2020 07:41:00 -0400
X-MC-Unique: NUMIMujWNkuIFJyjvOk4aA-1
Received: by mail-ej1-f70.google.com with SMTP id m24so1140489ejx.22
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 04:40:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=lVdU1+8kxfw+iqnZ6/wziKf6qV1Zbe2adj4szOHPMw8=;
        b=PyAfOJLiIFeAgYQGNOGbvVDgt50MUWxncOa6S7ddAuaax69a6xgF6nM85qQZsPIHe7
         P9Btjgkn9bjXnXklBq6cIAuggnGEjZGxBHqges+u7nJp6GxTWLfWYB6g1dRpRvh4Iv5B
         GHBbRGwfJgmyYpSSrYawfVhOBv1HvJoUuKBNAlJNartvx8jliHJmQkJ4IS0yWkT1YXq1
         t4BClpqGWwWv0FGMhaaTBjxNq+opIOfoyucYy2Dw7n0cLn6FQHjQpkmmknZjgwcRm/rX
         niVRuZJNZAvfXaGn7pcdYs/NbZgwgyRSvFbI5F1p7qPEZ7EmXll91tw9xs+BdXA4befs
         w+nw==
X-Gm-Message-State: AOAM532RUVxdfPFb2Ku4Fwtjybz5LxKaswKLfivAewdXO9wT54CJK/Jw
        2WYGfZtv2cCRAGTx5d2IDDVfen+hdf+RyZHt8+flcKIDdhpAcpac5kWLSUS163svXXmZym84IwH
        T5jHF+4DBCAmrBHIh
X-Received: by 2002:a50:a694:: with SMTP id e20mr21670405edc.114.1600170058700;
        Tue, 15 Sep 2020 04:40:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwS08+XSgFTEpXw7haRhZpgV8BuRw8UE1YuSjoL/UFtoCjxE6qC/Tv7pp4Dlq+wOVJX1ax4lg==
X-Received: by 2002:a50:a694:: with SMTP id e20mr21670367edc.114.1600170058224;
        Tue, 15 Sep 2020 04:40:58 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id z16sm11504222edr.56.2020.09.15.04.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 04:40:57 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0CADE1829CB; Tue, 15 Sep 2020 13:40:57 +0200 (CEST)
Subject: [PATCH bpf-next v5 0/8] bpf: Support multi-attach for freplace
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
Date:   Tue, 15 Sep 2020 13:40:57 +0200
Message-ID: <160017005691.98230.13648200635390228683.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support attaching freplace BPF programs to multiple targets.
This is needed to support incremental attachment of multiple XDP programs using
the libxdp dispatcher model.

The first three patches are refactoring patches: The first one is a trivial
change to the logging in the verifier, split out to make the subsequent refactor
easier to read. Patch 2 refactors check_attach_btf_id() so that the checks on
program and target compatibility can be reused when attaching to a secondary
location.

Patch 3 moves prog_aux->linked_prog and the trampoline to be embedded in
bpf_tracing_link on attach, and freed by the link release logic, and introduces
a mutex to protect the writing of the pointers in prog->aux.

Based on these refactorings, it becomes pretty straight-forward to support
multiple-attach for freplace programs (patch 4). This is simply a matter of
creating a second bpf_tracing_link if a target is supplied. However, for API
consistency with other types of link attach, this option is added to the
BPF_LINK_CREATE API instead of extending bpf_raw_tracepoint_open().

Patch 5 is a port of Jiri Olsa's patch to support fentry/fexit on freplace
programs. His approach of getting the target type from the target program
reference no longer works after we've gotten rid of linked_prog (because the
bpf_tracing_link reference disappears on attach). Instead, we used the saved
reference to the target prog type that is also used to verify compatibility on
secondary freplace attachment.

Patches 6 is the accompanying libbpf update, and patches 7-8 are selftests, the
first one for the multi-freplace functionality itself, and the second one is
Jiri's previous selftest for the fentry-to-freplace fix.

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
https://git.kernel.org/pub/scm/linux/kernel/git/toke/linux.git/log/?h=bpf-freplace-multi-attach-alt-05

Changelog:

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

Toke Høiland-Jørgensen (7):
      bpf: change logging calls from verbose() to bpf_log() and use log pointer
      bpf: verifier: refactor check_attach_btf_id()
      bpf: move prog->aux->linked_prog and trampoline into bpf_link on attach
      bpf: support attaching freplace programs to multiple attach points
      bpf: Fix context type resolving for extension programs
      libbpf: add support for freplace attachment in bpf_link_create
      selftests: add test for multiple attachments of freplace program


 include/linux/bpf.h                           |  24 +-
 include/linux/bpf_verifier.h                  |   9 +
 include/uapi/linux/bpf.h                      |   2 +
 kernel/bpf/btf.c                              |  15 +-
 kernel/bpf/core.c                             |   9 +-
 kernel/bpf/syscall.c                          | 118 +++++++++-
 kernel/bpf/trampoline.c                       |  32 ++-
 kernel/bpf/verifier.c                         | 211 +++++++++++-------
 tools/include/uapi/linux/bpf.h                |   2 +
 tools/lib/bpf/bpf.c                           |   1 +
 tools/lib/bpf/bpf.h                           |   3 +-
 tools/lib/bpf/libbpf.c                        |  24 +-
 tools/lib/bpf/libbpf.h                        |   3 +
 tools/lib/bpf/libbpf.map                      |   1 +
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  | 171 +++++++++++---
 .../selftests/bpf/prog_tests/trace_ext.c      | 113 ++++++++++
 .../bpf/progs/freplace_get_constant.c         |  15 ++
 .../selftests/bpf/progs/test_trace_ext.c      |  18 ++
 .../bpf/progs/test_trace_ext_tracing.c        |  25 +++
 19 files changed, 641 insertions(+), 155 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_ext.c
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_get_constant.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_trace_ext.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_trace_ext_tracing.c

