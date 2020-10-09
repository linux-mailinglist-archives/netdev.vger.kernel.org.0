Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275A9287FD0
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 03:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgJIBMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 21:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725979AbgJIBMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 21:12:45 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA1CC0613D2;
        Thu,  8 Oct 2020 18:12:44 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 144so5447696pfb.4;
        Thu, 08 Oct 2020 18:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=tKX1yfKcIGExoHeZgvKJt1aCLam1MYJYtCxwhZ1oZko=;
        b=Rn6R81cFvL+wjGROI8OhJITkV2oGD0TLdHGdY9V9YaUKipnB79Cne9JGTzRmMNpXX4
         CLyknA9ev8dj1MHvdntAeJGet4FYNGwvOnuCdZHzS2XfvR5CIF5Q4Kim0bA7riDZG7Ly
         Z5IOnzeqKcNyaocTUgq47ZQzoA+rQB+PRhJnl+qBYyDT3FgkI8/MMeSliDlMhLtin7Gc
         g8fa+0SfxPk+JsEOYNGYjbWb4u9u9e5pdpFb8XmNp3VKgdLvVyZtJwd7/ImgZi3iOt1X
         tj7T9tO6x3pHm8jKZ+3Co3QF5xrMk6lSbfJ4s29MvzjwyqhsPUNKTzzmbTmo2PeWuUP0
         x5eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tKX1yfKcIGExoHeZgvKJt1aCLam1MYJYtCxwhZ1oZko=;
        b=B3aCWk5pk1naGlD1hSwgBiXthLKpOKGvyU8QmrfXudbxhg8M9t2H64IDrYW9eGWiF8
         BbwhYX1TR4xt4bnGFv5KYUURFdBpvOLceCRkVQJzHDgo5AyGEv4alvx8+62rEJjqGPIs
         8uxHYHSU5eBX9mbFSfbz2U67Yu6Ap4i+hUjMc+YmOWhxXHeLoC64TN8OIteK71d4ueGk
         z7l5UqmZ+WDX0UfD1CtcJiECIDCEhzSeBtppFs8GGUrIOzdWMV8xKfv3RZt28P0nPgGn
         PbSDSYdZ4E0yMJ0G/SgX3HPJSCxj9Jr8gUac/tRtBXhRyAki19AjMNe+2ICwHX3hPFDg
         4gFw==
X-Gm-Message-State: AOAM530B1bXsPM3EkmHlPmPuJ1a8f4U28d9vQ+lYr4SoYmm3rHmVOk+s
        BcUPG/IqcBGaTQ3wcvAFBi0=
X-Google-Smtp-Source: ABdhPJyGkqIy/YaUlvIK91alaUAO8JVySv4DRq68dsctrmwfQBjJeKhKiSGpVCGcHHaSKdHFyDt5bQ==
X-Received: by 2002:a05:6a00:224e:b029:152:3cc8:4a84 with SMTP id i14-20020a056a00224eb02901523cc84a84mr10047512pfu.26.1602205963798;
        Thu, 08 Oct 2020 18:12:43 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id k15sm8275822pfp.217.2020.10.08.18.12.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Oct 2020 18:12:42 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 bpf-next 0/4] bpf: Make the verifier recognize llvm register allocation patterns.
Date:   Thu,  8 Oct 2020 18:12:36 -0700
Message-Id: <20201009011240.48506-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

v1->v2:
- fixed 32-bit mov issue spotted by John.
- allowed r2=r1; r3=r2; sequence as suggested by John.
- added comments, acks, more tests.

Make two verifier improvements:
- The llvm register allocator may use two different registers representing the
  same virtual register. Teach the verifier to recognize that.
- Track bounded scalar spill/fill.

The profiler[123] test in patch 3 will fail to load without patches 1 and 2.
The profiler[23] test may fail to load on older llvm due to speculative
code motion nd instruction combining optimizations that are fixed in
https://reviews.llvm.org/D85570

Alexei Starovoitov (3):
  bpf: Propagate scalar ranges through register assignments.
  selftests/bpf: Add profiler test
  selftests/bpf: Asm tests for the verifier regalloc tracking.

Yonghong Song (1):
  bpf: Track spill/fill of bounded scalars.

 kernel/bpf/verifier.c                         |  66 +-
 tools/testing/selftests/bpf/README.rst        |  38 +
 .../testing/selftests/bpf/prog_tests/align.c  |  16 +-
 .../selftests/bpf/prog_tests/test_profiler.c  |  72 ++
 tools/testing/selftests/bpf/progs/profiler.h  | 177 ++++
 .../selftests/bpf/progs/profiler.inc.h        | 969 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/profiler1.c |   6 +
 tools/testing/selftests/bpf/progs/profiler2.c |   6 +
 tools/testing/selftests/bpf/progs/profiler3.c |   6 +
 .../bpf/verifier/direct_packet_access.c       |   2 +-
 .../testing/selftests/bpf/verifier/regalloc.c | 243 +++++
 11 files changed, 1591 insertions(+), 10 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_profiler.c
 create mode 100644 tools/testing/selftests/bpf/progs/profiler.h
 create mode 100644 tools/testing/selftests/bpf/progs/profiler.inc.h
 create mode 100644 tools/testing/selftests/bpf/progs/profiler1.c
 create mode 100644 tools/testing/selftests/bpf/progs/profiler2.c
 create mode 100644 tools/testing/selftests/bpf/progs/profiler3.c
 create mode 100644 tools/testing/selftests/bpf/verifier/regalloc.c

-- 
2.23.0

