Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73B875187E
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 18:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbfFXQYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 12:24:33 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:54849 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbfFXQYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 12:24:33 -0400
Received: by mail-pl1-f202.google.com with SMTP id u10so7576643plq.21
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 09:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=gJjoc/vA2MwOJQXfSjPAcEIAUZ/pXhZszpshpqeoUyA=;
        b=Mvlzw0tXcjSCRt10cAQKg9EoR075HjNNgCpN3L6sFOvYVYY5u8dUyZdKmkTOJneNLc
         oa4GPIe02DO+GaBB2ah084nojog4vvGO8nkIsff6EA38E4dSZRsLmdVGBCRUnnU3I4kc
         FfmqjH6TXi0YfosUSvvVe8MwuOR1GSWYGgQwjnUQPsLXWbLC7QQ2xGiD+y4BfcU0Ocvc
         geTjx0eIHXZ9J52rVBTx3yOE6QAB1kAdUXt2JCn2XKKA35d/0dw3re/58Fj/Fkkx/8hO
         /i6OgxUhe02ZTBQoTvh7xcdFsjkVqprZaWRE5UUrZMu6xy+vIU14bKPq7gnRv/1JUQ+2
         e+ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=gJjoc/vA2MwOJQXfSjPAcEIAUZ/pXhZszpshpqeoUyA=;
        b=cOINKwN9R/R80k6n8Vn4c+8nlUJiWalUDoDWcu7NrhAFldD8OBBi2rXPRKC3XgPcC2
         EpKkwzXjjwr2FKbwzxWPElElTLilylbJxfQgv3ajLjC80aIErOUj/1JnkePjuZnU3Ns+
         DwMUuaQHhRgKxxXP4pVxrsexMcAlcJjc5+uzGyckapZNvsOT7Ma21pgXdXWyzKSXvPu7
         4Q9MfcDmPm/ddrWU9hcUupVeNWFFeP+cvbhn4ke0YczMsmKxodcdioqW84dIodQiPyos
         o8M0w9a1nQaRqAmAWiljph4N42M1gu5orgCtL5eUUalrCGrjeai4M2Q86uSgunz4cIVV
         LP+A==
X-Gm-Message-State: APjAAAUBJW690l0JCgKFuxsfdV9pk7wleMrwLv/YFl0WulJmpncE2aUy
        eTxfLVSymBcnefxM858xqinS6oF7PdihgvWhR4KX43mpH3/gV6jEpoFDHYbmQxkWd7OePXBLn3C
        zU/o8TgQSvgcj7W2pQX5boe2PbAPx2enSmF65id+mKIb9EU7sVBJwzw==
X-Google-Smtp-Source: APXvYqxFjeI+OpY3olG9wgcR20HJBbFH39lZVOpBz6lgShOUJmHzLNE+XqeLbAOO4QseMqmtsJSsAqE=
X-Received: by 2002:a65:42c3:: with SMTP id l3mr33742791pgp.372.1561393472209;
 Mon, 24 Jun 2019 09:24:32 -0700 (PDT)
Date:   Mon, 24 Jun 2019 09:24:20 -0700
Message-Id: <20190624162429.16367-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v8 0/9] bpf: getsockopt and setsockopt hooks
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
 Documentation/bpf/prog_cgroup_sockopt.rst     |  82 ++
 include/linux/bpf-cgroup.h                    |  43 +
 include/linux/bpf.h                           |   2 +
 include/linux/bpf_types.h                     |   1 +
 include/linux/filter.h                        |  14 +
 include/uapi/linux/bpf.h                      |  14 +
 kernel/bpf/cgroup.c                           | 317 +++++++
 kernel/bpf/core.c                             |   9 +
 kernel/bpf/syscall.c                          |  19 +
 kernel/bpf/verifier.c                         |  13 +
 net/core/filter.c                             |   2 +-
 net/socket.c                                  |  16 +
 .../bpftool/Documentation/bpftool-cgroup.rst  |   7 +-
 .../bpftool/Documentation/bpftool-prog.rst    |   3 +-
 tools/bpf/bpftool/bash-completion/bpftool     |   9 +-
 tools/bpf/bpftool/cgroup.c                    |   5 +-
 tools/bpf/bpftool/main.h                      |   1 +
 tools/bpf/bpftool/prog.c                      |   3 +-
 tools/include/uapi/linux/bpf.h                |  14 +
 tools/lib/bpf/libbpf.c                        |   5 +
 tools/lib/bpf/libbpf_probes.c                 |   1 +
 tools/testing/selftests/bpf/.gitignore        |   3 +
 tools/testing/selftests/bpf/Makefile          |   6 +-
 .../selftests/bpf/progs/sockopt_multi.c       |  53 ++
 .../testing/selftests/bpf/progs/sockopt_sk.c  |  91 ++
 .../selftests/bpf/test_section_names.c        |  10 +
 tools/testing/selftests/bpf/test_sockopt.c    | 892 ++++++++++++++++++
 .../selftests/bpf/test_sockopt_multi.c        | 276 ++++++
 tools/testing/selftests/bpf/test_sockopt_sk.c | 185 ++++
 30 files changed, 2087 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/bpf/prog_cgroup_sockopt.rst
 create mode 100644 tools/testing/selftests/bpf/progs/sockopt_multi.c
 create mode 100644 tools/testing/selftests/bpf/progs/sockopt_sk.c
 create mode 100644 tools/testing/selftests/bpf/test_sockopt.c
 create mode 100644 tools/testing/selftests/bpf/test_sockopt_multi.c
 create mode 100644 tools/testing/selftests/bpf/test_sockopt_sk.c

-- 
2.22.0.410.gd8fdbe21b5-goog
