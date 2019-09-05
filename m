Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1522AA743
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 17:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388258AbfIEP1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 11:27:12 -0400
Received: from mail-ua1-f73.google.com ([209.85.222.73]:38250 "EHLO
        mail-ua1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731588AbfIEP1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 11:27:12 -0400
Received: by mail-ua1-f73.google.com with SMTP id 46so431802uar.5
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 08:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Nl+R158SA53ROLBik0ktxdgdO0TsfvIUT2YNmNuqIYE=;
        b=Vj9vsJ9Ssuif2auvR/HFmfEc3R8VIW3FMgTUxPKPZrPdVAgBg5MSwqXqJZJvuHET8j
         FAuBRAvLk7aQQwnh8KpJJKfUcDQWIgb3thmAqfZiHOMTdWsNN5i3EuOUWWt9YKPDX4/T
         e//aUXDeSEZPpqYt3UK7kUtquS2DXxNhIwlxO5AANiPSNJEuwXMlchF4aQFWVSvTcUwl
         6I0c493yuOuFtEKKywdP64czeSQf5eL2aQ+vgDtsMUpIMPW0X3/K5F354lkTE3GZuTjt
         gAXFfbkZWIhtj6h5C0jQJh4HYTZ/W5wiZuRyoEqLUsHcL/MYE3Q0BqaaJTvUrVv31Jg4
         qROg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Nl+R158SA53ROLBik0ktxdgdO0TsfvIUT2YNmNuqIYE=;
        b=OFvXcuW5Ob3tWs8tLRe2lHTHXYM8Sxu9aXHV52yaYhEW9yv8YlVFc9pPP5heIDfQ7M
         e+X3Qd6H45R7uGJGpbc/Vp4deO7WL5x9B0BGUZ7YvKR2846/50cMH8UHOqhUJ/K6ybpP
         KzI+XyKyWoBc64zATfVnpo1CdYnpmS7zAj3uWr2MhIB66gSsZmBJs+ex1yVhW15kqo4L
         WgMObNUklalcmaQeKZSa0BpdnFtJlZi3g+ENVCX2vqHhrPqcMRSbHQmwH+0XQhtN7PnC
         6u/FjCsCuQdvbm62gFdd6hgFL/FlB8IAq218cFGq0iN3AQEh8hw6c9xZpuqGhKTDu15y
         J0aA==
X-Gm-Message-State: APjAAAWxKxjY5v02sE2wiSgc5/LI5bzCprpMXMvg1vdTpLw9lJiptfZX
        JDbMwKBBiTWfVM/p1rhNCt7LQ3+TOJavZ6/6Jy4hcUOyTi2EEc2SC/y2Nm7cQdjniZd6+yzKxyg
        KYQQLCJPdNG5fB7x5VcBZJQy+BRIHm9vHN6wPH5KSqlXR1Ct51joYYA==
X-Google-Smtp-Source: APXvYqzaIJkSUm7nMGuu4szIHT4bt97LorLT+UUcyaC6O3Pe7mIM3Vg1h+NOt/4/ygigJtEFZNorJAE=
X-Received: by 2002:ab0:2791:: with SMTP id t17mr1731060uap.101.1567697231316;
 Thu, 05 Sep 2019 08:27:11 -0700 (PDT)
Date:   Thu,  5 Sep 2019 08:27:03 -0700
Message-Id: <20190905152709.111193-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH bpf-next v2 0/6] selftests/bpf: move sockopt tests under test_progs
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that test_progs is shaping into more generic test framework,
let's convert sockopt tests to it. This requires adding
a helper to create and join a cgroup first (test__join_cgroup).
Since we already hijack stdout/stderr that shouldn't be
a problem (cgroup helpers log to stderr).

The rest of the patches just move sockopt tests files under prog_tests/
and do the required small adjustments.

v2:
* don't create a subtest per sockopt test, too verbose (Alexei
  Starovoitov)

Stanislav Fomichev (6):
  selftests/bpf: test_progs: add test__join_cgroup helper
  selftests/bpf: test_progs: convert test_sockopt
  selftests/bpf: test_progs: convert test_sockopt_sk
  selftests/bpf: test_progs: convert test_sockopt_multi
  selftests/bpf: test_progs: convert test_sockopt_inherit
  selftests/bpf: test_progs: convert test_tcp_rtt

 tools/testing/selftests/bpf/.gitignore        |   5 -
 tools/testing/selftests/bpf/Makefile          |  12 +--
 .../{test_sockopt.c => prog_tests/sockopt.c}  |  50 ++-------
 .../sockopt_inherit.c}                        | 102 ++++++++----------
 .../sockopt_multi.c}                          |  62 ++---------
 .../sockopt_sk.c}                             |  60 +++--------
 .../{test_tcp_rtt.c => prog_tests/tcp_rtt.c}  |  83 +++++---------
 tools/testing/selftests/bpf/test_progs.c      |  38 +++++++
 tools/testing/selftests/bpf/test_progs.h      |   4 +-
 9 files changed, 142 insertions(+), 274 deletions(-)
 rename tools/testing/selftests/bpf/{test_sockopt.c => prog_tests/sockopt.c} (96%)
 rename tools/testing/selftests/bpf/{test_sockopt_inherit.c => prog_tests/sockopt_inherit.c} (72%)
 rename tools/testing/selftests/bpf/{test_sockopt_multi.c => prog_tests/sockopt_multi.c} (83%)
 rename tools/testing/selftests/bpf/{test_sockopt_sk.c => prog_tests/sockopt_sk.c} (79%)
 rename tools/testing/selftests/bpf/{test_tcp_rtt.c => prog_tests/tcp_rtt.c} (76%)

-- 
2.23.0.187.g17f5b7556c-goog
