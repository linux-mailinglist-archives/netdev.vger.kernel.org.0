Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE09B3A3B05
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 06:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbhFKE2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 00:28:05 -0400
Received: from mail-pl1-f169.google.com ([209.85.214.169]:44766 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbhFKE16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 00:27:58 -0400
Received: by mail-pl1-f169.google.com with SMTP id b12so2178899plg.11;
        Thu, 10 Jun 2021 21:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=b04ZbZfXNU17yTm9QioThU9dkLDLTFowj6M7pOADCrw=;
        b=QaAk9PtLjUFJOyOhQx3cUzodKQ5+J2tJZXOfJvwlXZLHiBjk6TcvC2S+9z4sYshqO4
         atf9aRXAF84IpSGNj5D5JYOp1Ba6Kfr1Ff6eWRkFyqrWNq2IxKQaeGILmCHzAxswKQg6
         ANoY3jZijkeV+ihETJ91WuwcZ5mLZjZqKu/4jGFaShKGJ63mCOJWc9qH8Zv+B4BwfNFS
         IgMEQ5F0G+o8JKzGR6tIVGaCw0S4UGxYRQxty/IqWifaWNjtzY/w4U0F7jDvAzdiy2a+
         lt3zDXQO7hpnsMLkjGl6q+guN5T3IHqq786hsKIziHgug1eb+6hPRaAwLVjItdEGJCF2
         cDrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=b04ZbZfXNU17yTm9QioThU9dkLDLTFowj6M7pOADCrw=;
        b=D/Z9ELv+I5YBhdo5EKug5vUE/Si1HVNPGAIFtvwnjsY892ayTWMByNpxISU0t4+h/e
         mrGOsZZX7MVzIAl9/92Fm3FpXuCQaE3RIu484A0pg9BCgL2opo2GD51FPxwNxgDd9gIv
         o3amhBxcKSMnnnbxNoFLxDhcCk1AQrJ0CDp6yQgh1pc8/XSKBWyclYrIl6jCBUwf661x
         EWGmUEmBUmenRrxxVEu3ux2IEDRWQvS7+wvN7EuCo//uPTdThDvox1KSFOR3T0pa0Hpd
         S3aqwfdMelAN8gdttwVng7GbYUUG4iEV+v1BTZtAMZ9TMvUHxGI2NgI8mcx/CDAYJOnO
         DcBg==
X-Gm-Message-State: AOAM531ufqprhzJS2evC4YwnVdftqqRNaLxlYqvfFU+YpJmo81C6uXXy
        Cwceyr8VX5uOW4mmzWJkOsg=
X-Google-Smtp-Source: ABdhPJza/WscDTZpdUnlLk9DeAPModmYUTSdPSpCzbJjoqE3O62jYwSofy+RZ07BmPJRTmx6geF2Fg==
X-Received: by 2002:a17:902:a50c:b029:fe:c053:4ec5 with SMTP id s12-20020a170902a50cb02900fec0534ec5mr2142640plq.31.1623385485879;
        Thu, 10 Jun 2021 21:24:45 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:7360])
        by smtp.gmail.com with ESMTPSA id p11sm3942234pgn.65.2021.06.10.21.24.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Jun 2021 21:24:45 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 bpf-next 0/3] bpf: Introduce BPF timers.
Date:   Thu, 10 Jun 2021 21:24:39 -0700
Message-Id: <20210611042442.65444-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

v1->v2:
- Addressed great feedback from Andrii and Toke.
- Fixed race between parallel bpf_timer_*() ops.
- Fixed deadlock between timer callback and LRU eviction or bpf_map_delete/update.
- Disallowed mmap and global timers.
- Allow bpf_spin_lock and bpf_timer in an element. One of each.
- Fixed memory leaks due to map destruction and LRU eviction.
- Add support for specifying clockid in bpf_timer_init.
- Make bpf_timer helpers gpl_only.
- Fix key pointer in callback_fn when bpf_timer is inside array.
- A ton more tests.

The 1st patch implements interaction between bpf programs and bpf core.
The 2nd patch implements necessary safety checks.
The 3rd patch is the test.

Alexei Starovoitov (3):
  bpf: Introduce bpf_timer
  bpf: Add verifier checks for bpf_timer.
  selftests/bpf: Add bpf_timer test.

 include/linux/bpf.h                           |  47 ++-
 include/linux/btf.h                           |   1 +
 include/uapi/linux/bpf.h                      |  40 +++
 kernel/bpf/arraymap.c                         |  14 +
 kernel/bpf/btf.c                              |  77 ++++-
 kernel/bpf/hashtab.c                          |  56 +++-
 kernel/bpf/helpers.c                          | 227 ++++++++++++++
 kernel/bpf/local_storage.c                    |   4 +-
 kernel/bpf/map_in_map.c                       |   1 +
 kernel/bpf/syscall.c                          |  21 +-
 kernel/bpf/verifier.c                         | 133 ++++++++
 kernel/trace/bpf_trace.c                      |   2 +-
 scripts/bpf_doc.py                            |   2 +
 tools/include/uapi/linux/bpf.h                |  40 +++
 .../testing/selftests/bpf/prog_tests/timer.c  |  55 ++++
 tools/testing/selftests/bpf/progs/timer.c     | 293 ++++++++++++++++++
 16 files changed, 970 insertions(+), 43 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/timer.c
 create mode 100644 tools/testing/selftests/bpf/progs/timer.c

-- 
2.30.2

