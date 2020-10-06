Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58B62852E5
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 22:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbgJFUKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 16:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgJFUKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 16:10:00 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B69C061755;
        Tue,  6 Oct 2020 13:09:58 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id a200so4851328pfa.10;
        Tue, 06 Oct 2020 13:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=loeTujUvUb/0HI096FZ57WB/c/2Sekja4BM3rNC7GNQ=;
        b=gW26kaZp/grOzAuJAXDEIOL3r11a1h9TfhvQSj7gr8Tx6rAGWJEXLODvMxCAV6m5Vq
         0Fc/TiePIPnBCGQ3it9EfaB8jBxrCB9S+GBjuPfXyTJ502d3udecg0x1kAsoova0cJRn
         gfsVUOVjilaGY/5WFdpZT9Jjw6ORiLcsPqL2/IC/BOf8LwmDEQb0BMLV79h3Z8BXu9dO
         AMpRFsbvW1Sfav8graf4/li6Y/E9qjihpSpxvLPmOGq1wtCjrZSxYtcJZcDKml0plGmF
         AmAfU91EzjqUF29RFfgC+AGkNc9okezDFRQBw1MuZJJ+AFWQsRCcsct3u3ivoX2ly2gQ
         Kxgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=loeTujUvUb/0HI096FZ57WB/c/2Sekja4BM3rNC7GNQ=;
        b=e2oqQKfrMIkTcGIpsBYZno4LVnd7FliAW3La2VFZUpb4P3FoiClytxBMJit9Fcs1yn
         ZPKLb471NXN30lvcxiPb6Ca/6pvyzpR/sHhh7q9+pxslcHzB+ul0JFvEXF4Olx7rvsnI
         bJB/UREoBHissx0UkK1HgXfKXf7e3rUHgW1Y1fNH4LkYpWR3s1vrJHQgQ12kQ9zetFEq
         IJJ9RHAEXHaBZJ73gm1X9yRLx6q/ZRFiKhgMo+1vw+83+SHLB+T6CmL/d67Yczvvh8PH
         sPpTGMHvSeoAFozgI4eDkGbsUhyZRG7EjoFuSxAbYP2e9wvwWPmJWv8nl7NUmeYgWfng
         1P6g==
X-Gm-Message-State: AOAM531J3NwX1kM7VevQ3WROGWeZzvkuF9xWX8XL0SzlItkCg0GEELVA
        Kw1Xuny1rIPJkfVi1R7Uy5Y=
X-Google-Smtp-Source: ABdhPJyiSZgIr0UYRFSjpoXH06GyQig80tfkCSpfxCN7/1Sk6NcQiK3JDPgwCCuEP31Hg0hlM8/8tg==
X-Received: by 2002:a63:581e:: with SMTP id m30mr5545298pgb.20.1602014998399;
        Tue, 06 Oct 2020 13:09:58 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id u18sm4358162pgk.18.2020.10.06.13.09.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Oct 2020 13:09:57 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 0/3] bpf: Make the verifier recognize llvm register allocation patterns.
Date:   Tue,  6 Oct 2020 13:09:52 -0700
Message-Id: <20201006200955.12350-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Make two verifier improvements:
- The llvm register allocator may use two different registers representing the
same virtual register. Teach the verifier to recognize that.
- Track bounded scalar spill/fill.

The 'profiler' test in patch 3 will fail to load without patches 1 and 2.

Alexei Starovoitov (2):
  bpf: Propagate scalar ranges through register assignments.
  selftests/bpf: Add profiler test

Yonghong Song (1):
  bpf: Track spill/fill of bounded scalars.

 kernel/bpf/verifier.c                         |  54 +-
 .../testing/selftests/bpf/prog_tests/align.c  |  16 +-
 .../selftests/bpf/prog_tests/test_profiler.c  |  72 ++
 tools/testing/selftests/bpf/progs/profiler.h  | 177 ++++
 .../selftests/bpf/progs/profiler.inc.h        | 969 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/profiler1.c |   6 +
 tools/testing/selftests/bpf/progs/profiler2.c |   6 +
 tools/testing/selftests/bpf/progs/profiler3.c |   6 +
 .../bpf/verifier/direct_packet_access.c       |   2 +-
 9 files changed, 1298 insertions(+), 10 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_profiler.c
 create mode 100644 tools/testing/selftests/bpf/progs/profiler.h
 create mode 100644 tools/testing/selftests/bpf/progs/profiler.inc.h
 create mode 100644 tools/testing/selftests/bpf/progs/profiler1.c
 create mode 100644 tools/testing/selftests/bpf/progs/profiler2.c
 create mode 100644 tools/testing/selftests/bpf/progs/profiler3.c

-- 
2.23.0

