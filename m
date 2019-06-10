Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A12763B985
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbfFJQeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 12:34:25 -0400
Received: from mail-vs1-f74.google.com ([209.85.217.74]:39424 "EHLO
        mail-vs1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727986AbfFJQeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 12:34:25 -0400
Received: by mail-vs1-f74.google.com with SMTP id y70so3229874vsc.6
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 09:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=WTJ0CLWWhp91boKJRzsc1QxdiFix806yxAsK82lwins=;
        b=VR3Q2lkJUDVvdBszcGrz/TkrHsxBfNsCPlb1XzX2K/bP0YDNw+BSHtov/YBzq4wHLq
         oZFJsM7TAc2hP3fhvQA0C4KzpepgQ2CSu9vhSA1klixENWXv74gKfvFWu7hpLq2v9w8Z
         PEDzD1CF+Ao/0Hfu5lSGpgjy/htcZp7OQlO+nV8gxnATyntN/WolqQ5kFoZmK51mDIIq
         Nit7k8Yk2DILCs76GPSMY1J91xxQlPPeVR3VRcd06o/73uz8RI8Oci6+SGOVrGMoENlU
         97QIxxu2kQuzUC0CLhB3PMLt18YGs4WblXaYAAxFlQkD64mBX1fV7DF+a3XzRkDL+mXM
         yLPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=WTJ0CLWWhp91boKJRzsc1QxdiFix806yxAsK82lwins=;
        b=jU0JhLNXmCQrXuXmXx/dXjCTbE2WzOz+UFo8uIMhXipErTPUuuOPbZPsJJGjNpTaVl
         h3yxWQFkD1bAuKruA2oKRrk5zFvPFDcVP1SpNiCeMzN0nyteuKwW0HPvw1OH9Mvu7a8s
         OvzFjy3UPGRK1PAwdLP3id3uyYjcaTtRboOJmfJRcMAiQEYKODSTZGCmXttCuIy2jboP
         HZ4hnQPn7YUljuYonZMm7xqSm0bIh9+08DZqCk3WN1LNP0AWFaDAfwgk6KY1Hivb1y72
         rk3L+papPK6nriCW1JFirTYLabyobT8F3bahEDzdPvB5XBou5EwooA8PqiPR1pFCjSgj
         Ir3g==
X-Gm-Message-State: APjAAAW6DCqsNqNYJAazWZG88bNy8WYZWolE4jN3z4IN/CdJDFZGweQL
        pq7rC2dTrbGzrz3LNuXI5pHZ8gbB9Ydu5tX0KjIbiPmQpZZ05o8qiAaQs3q9mAhSPlWtzoYITdl
        NO+71xD1WgJFkA1UnJ1VM6kGSoOj/lpUukg1o1lXgFwIqnJ7uwvHkUA==
X-Google-Smtp-Source: APXvYqyTH5vQBy+TeDL2fFHLQxIvj7F6k90vf/dWf+3yvjjbN3VGdnuj4qUzSpY2+s9gzggvTb6wUBk=
X-Received: by 2002:a9f:2372:: with SMTP id 105mr4190313uae.85.1560184464300;
 Mon, 10 Jun 2019 09:34:24 -0700 (PDT)
Date:   Mon, 10 Jun 2019 09:34:13 -0700
Message-Id: <20190610163421.208126-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
Subject: [PATCH bpf-next v4 0/8] bpf: getsockopt and setsockopt hooks
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

Stanislav Fomichev (8):
  bpf: implement getsockopt and setsockopt hooks
  bpf: sync bpf.h to tools/
  libbpf: support sockopt hooks
  selftests/bpf: test sockopt section name
  selftests/bpf: add sockopt test
  selftests/bpf: add sockopt test that exercises sk helpers
  bpf: add sockopt documentation
  bpftool: support cgroup sockopt

 Documentation/bpf/index.rst                   |   1 +
 Documentation/bpf/prog_cgroup_sockopt.rst     |  39 +
 include/linux/bpf-cgroup.h                    |  29 +
 include/linux/bpf.h                           |  45 +
 include/linux/bpf_types.h                     |   1 +
 include/linux/filter.h                        |  13 +
 include/uapi/linux/bpf.h                      |  13 +
 kernel/bpf/cgroup.c                           | 262 ++++++
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
 tools/testing/selftests/bpf/.gitignore        |   2 +
 tools/testing/selftests/bpf/Makefile          |   4 +-
 .../testing/selftests/bpf/progs/sockopt_sk.c  |  67 ++
 .../selftests/bpf/test_section_names.c        |  10 +
 tools/testing/selftests/bpf/test_sockopt.c    | 773 ++++++++++++++++++
 tools/testing/selftests/bpf/test_sockopt_sk.c | 156 ++++
 28 files changed, 1514 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/bpf/prog_cgroup_sockopt.rst
 create mode 100644 tools/testing/selftests/bpf/progs/sockopt_sk.c
 create mode 100644 tools/testing/selftests/bpf/test_sockopt.c
 create mode 100644 tools/testing/selftests/bpf/test_sockopt_sk.c

-- 
2.22.0.rc2.383.gf4fbbf30c2-goog
