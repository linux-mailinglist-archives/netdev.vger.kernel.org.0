Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03F2B48B1D
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 20:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbfFQSBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 14:01:13 -0400
Received: from mail-oi1-f201.google.com ([209.85.167.201]:38424 "EHLO
        mail-oi1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbfFQSBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 14:01:12 -0400
Received: by mail-oi1-f201.google.com with SMTP id u8so3842935oie.5
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 11:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=aylUCySTNEKJOP8yIf7R50JrzoL6yFjGGe08TnHjVYY=;
        b=Ai/imhiQkdaviyPUTXYiRAKTbr+6kz6b8/sY7JfeYmo170pr1V1gKLB3VaqgIFni28
         6TqbH+pJ1yBAJfYb8LyCJyK98unJIQ0aqEyVLm2s3LLEj4AUoyS2TZRt4CelIqQw93ND
         MPYscrh2BSg4ODcQLWicLiOEcG/t+DHcpE1EPEP/s6aUcgHyWTgInceCGg+i2d0yoESl
         WEuJ1+pQH4Xy/SzAk774gr4UI2t7DQh1sc+H2ClTd159gpYqyLAGTYxyjPYwx0soCQ1y
         2pQbZpxK+RPTbtZYFw0hz9LfhFFu/GfUm+UzYcWDmQuA1lOWgDi6S4zna4SD2nyRjGPZ
         3O4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=aylUCySTNEKJOP8yIf7R50JrzoL6yFjGGe08TnHjVYY=;
        b=Q2eELacgBkNLxUpvbxHiQZuVLEsN1OV6O9gNZMqhl7UOCcGn5JK9a8mfTO2sEaRSgD
         7bP7xwPzbuRsQWhbEw9H+hCMw4O0RuAh/NSKpOAK7WNUX3MN31BhAAk/22erElH3ZmrU
         f+Gi5H02HtlMk9Qag5NQu7REk95Fr5lfY6Hl91WDbdy+TfBzWwipFm1ZVZScrygWrj+r
         RidOnwoon/39CmC1m3jj9vA9kiTCCnCrK/Mbo4dmR9PDhObBspsn/EEQ5+JvPGnITx1v
         9Jre291jWtsCeT6EFbHjhy+tKdHnlGDKXOACNc1edp385dp7cf+HD5YBo4BmIEwZQkOn
         hJzQ==
X-Gm-Message-State: APjAAAWIpfhM8Wf8hUF6aDeLIMGMUKnXn0I8oSh6T1L4vjkvBVedC4/P
        k7IC+74hVW6UUDbL1V55ZFDY4XyofF5hYFRXIVmynVy4SqxlW2zJZjvVp0nB29NRVlRubvnQFYs
        xxEtSyrUSpgZgbVR9brH6VOWUWBdeXix9/O0v60lsoU4ybOblMKvXKA==
X-Google-Smtp-Source: APXvYqyDhEbCzPGAXg3K2dUWjcpazmj1/cuBZM9zVCD5WooJN61Q+bu/FG7JU1l17BxncuVXzCwv9CY=
X-Received: by 2002:aca:b788:: with SMTP id h130mr4957050oif.85.1560794471847;
 Mon, 17 Jun 2019 11:01:11 -0700 (PDT)
Date:   Mon, 17 Jun 2019 11:01:00 -0700
Message-Id: <20190617180109.34950-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v6 0/9] bpf: getsockopt and setsockopt hooks
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series implements two new per-cgroup hooks: getsockopt and
setsockopt along with a new sockopt program type. The idea is pretty
similar to recently introduced cgroup sysctl hooks, but
implementation is simpler (no need to convert to/from strings).

What this can be applied to:
* move business logic of what tos/priority/etc can be set by
  containers (either pass or reject)
* handle existing options (or introduce new ones) differently by
  propagating some information in cgroup/socket local storage

Compared to a simple syscall/{g,s}etsockopt tracepoint, those
hooks are context aware. Meaning, they can access underlying socket
and use cgroup and socket local storage.

v6:
* rework cgroup chaining; stop as soon as bpf program returns
  0 or 2; see patch with the documentation for the details

Stanislav Fomichev (9):
  bpf: implement getsockopt and setsockopt hooks
  bpf: sync bpf.h to tools/
  libbpf: support sockopt hooks
  selftests/bpf: test sockopt section name
  selftests/bpf: add sockopt test
  selftests/bpf: add sockopt test that exercises sk helpers
  selftests/bpf: add sockopt test that exercises BPF_F_ALLOW_MULTI
  bpf: add sockopt documentation
  bpftool: support cgroup sockopt

 Documentation/bpf/index.rst                   |   1 +
 Documentation/bpf/prog_cgroup_sockopt.rst     |  72 ++
 include/linux/bpf-cgroup.h                    |  29 +
 include/linux/bpf.h                           |  46 ++
 include/linux/bpf_types.h                     |   1 +
 include/linux/filter.h                        |  13 +
 include/uapi/linux/bpf.h                      |  13 +
 kernel/bpf/cgroup.c                           | 260 ++++++
 kernel/bpf/core.c                             |   9 +
 kernel/bpf/syscall.c                          |  19 +
 kernel/bpf/verifier.c                         |  15 +
 net/core/filter.c                             |   2 +-
 net/socket.c                                  |  18 +
 .../bpftool/Documentation/bpftool-cgroup.rst  |   7 +-
 .../bpftool/Documentation/bpftool-prog.rst    |   2 +-
 tools/bpf/bpftool/bash-completion/bpftool     |   8 +-
 tools/bpf/bpftool/cgroup.c                    |   5 +-
 tools/bpf/bpftool/main.h                      |   1 +
 tools/bpf/bpftool/prog.c                      |   3 +-
 tools/include/uapi/linux/bpf.h                |  14 +
 tools/lib/bpf/libbpf.c                        |   5 +
 tools/lib/bpf/libbpf_probes.c                 |   1 +
 tools/testing/selftests/bpf/.gitignore        |   3 +
 tools/testing/selftests/bpf/Makefile          |   6 +-
 .../testing/selftests/bpf/progs/sockopt_sk.c  |  82 ++
 .../selftests/bpf/test_section_names.c        |  10 +
 tools/testing/selftests/bpf/test_sockopt.c    | 773 ++++++++++++++++++
 .../selftests/bpf/test_sockopt_multi.c        | 264 ++++++
 tools/testing/selftests/bpf/test_sockopt_sk.c | 185 +++++
 29 files changed, 1857 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/bpf/prog_cgroup_sockopt.rst
 create mode 100644 tools/testing/selftests/bpf/progs/sockopt_sk.c
 create mode 100644 tools/testing/selftests/bpf/test_sockopt.c
 create mode 100644 tools/testing/selftests/bpf/test_sockopt_multi.c
 create mode 100644 tools/testing/selftests/bpf/test_sockopt_sk.c

-- 
2.22.0.410.gd8fdbe21b5-goog
