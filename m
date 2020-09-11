Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 816C7265D27
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 11:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725784AbgIKJ7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 05:59:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45796 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725780AbgIKJ7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 05:59:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599818360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=umfS176nchuA3M5Cp4HyehVZfx3cPoV3pIXcITPig4A=;
        b=A48zFLDpMPClgU6+3AaHPRuw6nah6TaafL/0uSUnBqpszgV/rfexU+GDIUb8NaIbLjDL87
        6RPqvRlKVzbTHAmf6O7hiGWYOniFYR4CP0M8b0nQ7wFFy8T8tZzo6tTT4VNbpXuO1DDWRD
        3aoySU7O7XvWj3PX7oshyTJpMXyGft8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-gkOMtx4kP9mHfLL1IeQ-gw-1; Fri, 11 Sep 2020 05:59:17 -0400
X-MC-Unique: gkOMtx4kP9mHfLL1IeQ-gw-1
Received: by mail-wr1-f70.google.com with SMTP id i10so3315521wrq.5
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 02:59:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=umfS176nchuA3M5Cp4HyehVZfx3cPoV3pIXcITPig4A=;
        b=JNy6BVSqdHQY0uDTdyiJ+mvyqzomcyOeDBErE80dVuO6P//USaERHaxiRXaoJwTvcE
         x+1R+JaR6WGkGZ/L1WzO44opEIBf19C2NmVf0gc2+32b4b+1p6uhZ74gxO2e9I1SQWmo
         selEfHtpoaex6fZyLpDBD57zkVYBBGe5SJ+b8IcIZgyh1jQDP8+TmBn2+828Zo0Q+0o1
         FTm9H2W4Ux65sxOJSUKVChPhEaqMn2wkFzwBBI2kfWE43aa1XhUBjSZCEdlL08WRDaRY
         K39pC7AHm4CZ8pb4CmSehuUQuJW7l/gR+u3H0hDIZUTFkFk3jwV/WsvahD6J3bE6Vocc
         x/yA==
X-Gm-Message-State: AOAM530aKRIh1KXOGS/mb7L1do/dL6EZzKceSBK/8gv/+zy2Wtf/Q+eQ
        exrBgUS1Ok60VbWipGk4V8GG8IpqTBES4R08IelzIifcrmy/Ka0mzC13QzFO13t0WqbyWF7l/Cm
        xLnSdulKGjRwslSop
X-Received: by 2002:adf:ec82:: with SMTP id z2mr1239180wrn.214.1599818356316;
        Fri, 11 Sep 2020 02:59:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyO/mxZEEcF/23ntlbuzH00hfkwWWeSBDgHiiDlJGZU5sXIYJYLXkdMNjqZW8/bkbeIpCRQuw==
X-Received: by 2002:adf:ec82:: with SMTP id z2mr1239143wrn.214.1599818355804;
        Fri, 11 Sep 2020 02:59:15 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id t4sm3672988wrr.26.2020.09.11.02.59.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 02:59:15 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id CD5A91829D4; Fri, 11 Sep 2020 11:59:14 +0200 (CEST)
Subject: [PATCH RESEND bpf-next v3 0/9] bpf: Support multi-attach for freplace
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
Date:   Fri, 11 Sep 2020 11:59:14 +0200
Message-ID: <159981835466.134722.8652987144251743467.stgit@toke.dk>
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

Patch 3 changes prog_aux->linked_prog to be an embedded bpf_tracing_link that is
initialised at program load time. This nicely encapsulates both the trampoline
and the prog reference, and moves the release of these references into bpf_link
teardown. At raw_tracepoint_open() time (i.e., when the link is attached), it
will be removed from the extension prog, and primed as a regular bpf_link.

Based on these refactorings, it becomes pretty straight-forward to support
multiple-attach for freplace programs (patch 4). This is simply a matter of
creating a second bpf_tracing_link if a target is supplied to
raw_tracepoint_open().

Patch 5 is a port of Jiri Olsa's patch to support fentry/fexit on freplace
programs. His approach of getting the target type from the target program
reference no longer works after we've gotten rid of linked_prog (because the
bpf_tracing_link reference disappears on attach). Instead, we used the saved
reference to the target prog type that is also used to verify compatibility on
secondary freplace attachment.

Patches 6-7 are tools and libbpf updates, and patches 8-9 are selftests, the
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
https://git.kernel.org/pub/scm/linux/kernel/git/toke/linux.git/log/?h=bpf-freplace-multi-attach-alt-03

Changelog:

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

Toke Høiland-Jørgensen (8):
      bpf: change logging calls from verbose() to bpf_log() and use log pointer
      bpf: verifier: refactor check_attach_btf_id()
      bpf: wrap prog->aux->linked_prog in a bpf_tracing_link
      bpf: support attaching freplace programs to multiple attach points
      bpf: Fix context type resolving for extension programs
      tools: add new members to bpf_attr.raw_tracepoint in bpf.h
      libbpf: add support for supplying target to bpf_raw_tracepoint_open()
      selftests: add test for multiple attachments of freplace program


 include/linux/bpf.h                           |  33 ++-
 include/linux/bpf_verifier.h                  |   9 +
 include/uapi/linux/bpf.h                      |   6 +-
 kernel/bpf/btf.c                              |  22 +-
 kernel/bpf/core.c                             |   5 +-
 kernel/bpf/syscall.c                          | 161 +++++++++--
 kernel/bpf/trampoline.c                       |  34 ++-
 kernel/bpf/verifier.c                         | 251 ++++++++++--------
 tools/include/uapi/linux/bpf.h                |   6 +-
 tools/lib/bpf/bpf.c                           |  13 +-
 tools/lib/bpf/bpf.h                           |   9 +
 tools/lib/bpf/libbpf.map                      |   1 +
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  | 171 +++++++++---
 .../selftests/bpf/prog_tests/trace_ext.c      |  93 +++++++
 .../bpf/progs/freplace_get_constant.c         |  15 ++
 .../selftests/bpf/progs/test_trace_ext.c      |  18 ++
 .../bpf/progs/test_trace_ext_tracing.c        |  25 ++
 17 files changed, 683 insertions(+), 189 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_ext.c
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_get_constant.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_trace_ext.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_trace_ext_tracing.c

