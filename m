Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEC937B7D
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 19:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbfFFRvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 13:51:50 -0400
Received: from mail-ua1-f74.google.com ([209.85.222.74]:38156 "EHLO
        mail-ua1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728816AbfFFRvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 13:51:49 -0400
Received: by mail-ua1-f74.google.com with SMTP id j22so607885uaq.5
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 10:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=JCwv+UD4yQBiRat0LbHtuxWmZ8WThdMX43Z60hYFlcA=;
        b=dcY56VPlNU1UmmXBB1IyITcEr//sUVUAdlNZy9SuAbRjX9y/SMTDEDPQdr+g7EEB6r
         ZOuf2dPmD+E495d2hfhPWCPPRFRjlcU/DTvh2Pk7IyB+gEv7RfzDUT8aDXbEHdyCTXvF
         z4vog1tCuslJzLz6rXp2mWCcUFzQFzP6RYPHdLKubVpNeu7vov1uJuaqh0r/hwYAfuMS
         TxD7DtwiEFKZuMOyDGk/Qf0dPM0wMbUGPvpkOctCJQY5/8/3XvBegwbdYwJOuitgeKh3
         Y4DiV2dI12XrTScKe6FWTXOIal8kgoQ148W17MaI+j3LDfY6xtJrJwWZgoD6RfegEbxZ
         NCfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=JCwv+UD4yQBiRat0LbHtuxWmZ8WThdMX43Z60hYFlcA=;
        b=fwlmGMEMJp5JD044niAtJ4pn/BnvZHScB/oTkTADlBSIWug2ZmERdUAoaBrWjbysD3
         X9mHIelbcz09PL9v50SFfcPgMIZUHGBzhDTcS5k948pBC18x5hUds+YlT3wBW0OAcYfV
         4/hlQJlP/JissyRCmUPcDF934yAA9xKDoScwCN9/29j34A+x9xxu/fBFHjczPri2X5Zr
         PqlyJvN+EUQOAIHRly/QCTiESjvdLKmBpBphwuxxfh+QsW6eekhhp/vmy+0ImxKe2RQq
         eTOE9elofeE09vRSntXX5PDA/y0gq8pe8bxb52kZqVK9uQ/0z0pvuufRE+WrH38w/kEB
         xVVw==
X-Gm-Message-State: APjAAAXbJNT57vGDUIkFIgWZQSmNWJYT+cR4zHFX4Wj22YhjOLGnI5Yi
        7hVWFwovLZysoZvQrCVgrHupRuZVZTfgkxnYmCGEwb9cAWWy/f4AWGjQe7yxMdwOIIt3FDrX7t8
        H778YRpc8Es8JrokhO/BQl6dv+D37CXDpDJRBSfxoniKY2a9x2HFQ8A==
X-Google-Smtp-Source: APXvYqwKk+I4HbuA4RcglkP8o46iI6xbteS+/MuFwJyr/XWMftq/+pw8TuJDIwz+Yidoj+OgCKZAOXQ=
X-Received: by 2002:a1f:a1c8:: with SMTP id k191mr6874449vke.77.1559843508489;
 Thu, 06 Jun 2019 10:51:48 -0700 (PDT)
Date:   Thu,  6 Jun 2019 10:51:38 -0700
Message-Id: <20190606175146.205269-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
Subject: [PATCH bpf-next v2 0/8] bpf: getsockopt and setsockopt hooks
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
 include/linux/bpf.h                           |  46 ++
 include/linux/bpf_types.h                     |   1 +
 include/linux/filter.h                        |  13 +
 include/uapi/linux/bpf.h                      |  14 +
 kernel/bpf/cgroup.c                           | 277 +++++++
 kernel/bpf/core.c                             |   9 +
 kernel/bpf/syscall.c                          |  19 +
 kernel/bpf/verifier.c                         |  15 +
 net/core/filter.c                             |   4 +-
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
 .../testing/selftests/bpf/progs/sockopt_sk.c  |  77 ++
 .../selftests/bpf/test_section_names.c        |  10 +
 tools/testing/selftests/bpf/test_sockopt.c    | 773 ++++++++++++++++++
 tools/testing/selftests/bpf/test_sockopt_sk.c | 156 ++++
 28 files changed, 1542 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/bpf/prog_cgroup_sockopt.rst
 create mode 100644 tools/testing/selftests/bpf/progs/sockopt_sk.c
 create mode 100644 tools/testing/selftests/bpf/test_sockopt.c
 create mode 100644 tools/testing/selftests/bpf/test_sockopt_sk.c

-- 
2.22.0.rc1.311.g5d7573a151-goog
