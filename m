Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55EA16976D2
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 07:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbjBOG73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 01:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233738AbjBOG7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 01:59:02 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64C1367CA;
        Tue, 14 Feb 2023 22:58:18 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id z3so5766595pfw.7;
        Tue, 14 Feb 2023 22:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PkrxNSBc4D7rcxty2/2ffquFhy3Sey3noDAgZjbMOHI=;
        b=TPMYoiC3DFNN2M6k4gS0YtDSqHQGr28xWHB6K9OHYcxeeHN7fNMGBZyLRy4BmmFs0q
         /GJeZDYcKsJApQKpQ/Zx97e24474lV4/9Nbq3ipgG/J3FdlA5ln30kTcBAkgaBWU7pgY
         gdhVH4/8bA3jIzvpe2Y/o+k+h3Le4qQqfOIOuVY0XM7ZpB0mjOBAXNRrvJQ6H/+irYD1
         oFX58pkZhYJ2n+tcPSgqs2wdvDpfv8P12xpovtvnw2XZjbDwLdTUy/oPLRaSd/Dh8QEQ
         dnrwjA0fDSz3YsAiQQQ9fD/pdypwYtifisL3MmC6OJyzCPOrTCk4wtn+dIBKI2ooW1qX
         ujfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PkrxNSBc4D7rcxty2/2ffquFhy3Sey3noDAgZjbMOHI=;
        b=4OhHwEJ8QhyxeWIxGom8N218Yf8qyeBk77DBD/zH9jgjcNnrn7bPSMp2Gc2XhbYqZG
         zzkIUsWH64oufJRmHKkTm35M/5cEDFhmEAwk827dyoVzbkGCwuQO59+bKOqlzUeqf8Tz
         zScvK0JBdGPPKZ4cNIaKMzvr4Wf5qd10hBxWutpxzQPZiQ8Ld2LE93CucBiYPllsg5zG
         5nCCP4GjT+oaBIHxG+YHRvQBO0Q6SdPE49l2jX+rMioyAhnJeduBQAPk2IePHH2SCgeZ
         oVNPijf8GPg6ule9TdQcFlNQ33T3MTc6vaCtPnU0MpfmA5cXAwHnrAUps3ILe2wZ7npQ
         VlVA==
X-Gm-Message-State: AO0yUKUcJ76lTIOOGzqu4lwJrN4kDANTSSqk6PZLeNa3xP/FyeFHiBFf
        wwmV675C/2uwb62GTci/hO8=
X-Google-Smtp-Source: AK7set/mKlcMSg5igXjAB3mMYN4pa4AoQ6kgQwvBiATal0wgSl1CUr02NBKUw/KF1CvhvTSJLX7lpA==
X-Received: by 2002:a62:170a:0:b0:5a8:b082:19dc with SMTP id 10-20020a62170a000000b005a8b08219dcmr1410484pfx.11.1676444296117;
        Tue, 14 Feb 2023 22:58:16 -0800 (PST)
Received: from localhost.localdomain ([2620:10d:c090:400::5:d0de])
        by smtp.gmail.com with ESMTPSA id s19-20020aa78d53000000b00593a01d93ecsm10814058pfe.208.2023.02.14.22.58.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Feb 2023 22:58:15 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next 0/4] bpf: Introduce kptr_rcu.
Date:   Tue, 14 Feb 2023 22:58:08 -0800
Message-Id: <20230215065812.7551-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

The __kptr_ref turned out to be too limited, since any "trusted" pointer access
requires bpf_kptr_xchg() which is impractical when the same pointer needs
to be dereferenced by multiple cpus.
The __kptr "untrusted" only access isn't very useful in practice.
Rename __kptr to __kptr_untrusted with eventual goal to deprecate it,
and rename __kptr_ref to __kptr, since that looks to be more common use of kptrs.
Introduce __kptr_rcu that can be directly dereferenced and used similar
to native kernel C code.
Once bpf_cpumask and task_struct kfuncs are converted to observe RCU GP
when refcnt goes to zero, both __kptr and __kptr_untrusted can be deprecated
and __kptr_rcu can become the only __kptr tag.

Alexei Starovoitov (4):
  bpf: Rename __kptr_ref -> __kptr and __kptr -> __kptr_untrusted.
  bpf: Introduce kptr_rcu.
  selftests/bpf: Add a test case for kptr_rcu.
  selftests/bpf: Tweak cgroup kfunc test.

 Documentation/bpf/bpf_design_QA.rst           |  4 +--
 Documentation/bpf/cpumasks.rst                |  4 +--
 Documentation/bpf/kfuncs.rst                  |  2 +-
 include/linux/bpf.h                           | 15 ++++++---
 include/linux/bpf_verifier.h                  |  2 +-
 kernel/bpf/btf.c                              | 26 +++++++++++++--
 kernel/bpf/syscall.c                          |  4 +++
 kernel/bpf/verifier.c                         | 33 ++++++++++++-------
 tools/lib/bpf/bpf_helpers.h                   |  3 +-
 tools/testing/selftests/bpf/progs/cb_refs.c   |  2 +-
 .../selftests/bpf/progs/cgrp_kfunc_common.h   |  2 +-
 .../selftests/bpf/progs/cgrp_kfunc_failure.c  |  2 +-
 .../selftests/bpf/progs/cgrp_kfunc_success.c  |  9 ++++-
 .../selftests/bpf/progs/cpumask_common.h      |  2 +-
 .../selftests/bpf/progs/jit_probe_mem.c       |  2 +-
 tools/testing/selftests/bpf/progs/lru_bug.c   |  2 +-
 tools/testing/selftests/bpf/progs/map_kptr.c  | 15 +++++++--
 .../selftests/bpf/progs/map_kptr_fail.c       |  6 ++--
 .../selftests/bpf/progs/task_kfunc_common.h   |  2 +-
 tools/testing/selftests/bpf/test_verifier.c   | 22 ++++++-------
 20 files changed, 109 insertions(+), 50 deletions(-)

-- 
2.30.2

