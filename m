Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E41731C932
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 12:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhBPK7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 05:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhBPK7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 05:59:07 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A656C061574
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 02:58:17 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id v1so12368141wrd.6
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 02:58:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zXqgmXSGO2OfxbM787pr/fo3adQzSE3XAY09QFycryU=;
        b=wFr3e5P4VYoR7vnRPBjrDjDE2+e8s3Iprkn/Z9+CCbyTrL+Uv6A/JOKbWhCPo56/I9
         uUMLI0UQinS4Ybq4s4iz1naybV0LsBr+y/t0enI9OgXQhGRqepIawS/A0dFbdsIOyqJy
         3m/vOeYBhslEX8d3XChmhtQWGGkiez063rasg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zXqgmXSGO2OfxbM787pr/fo3adQzSE3XAY09QFycryU=;
        b=Q41QWW4qeZBYynoSMEaUFFnF+Uri8QR4ozqIK7KWHFN1StBucM9lZtNX7FC6dELKnu
         TMHa47gfOf1KkDaOrHTM5k7fz8M/+zLz14W1hfKB7C8W9NAb2Jc8czEPkGraGUVRhUmB
         I8qznTI6t1jViDnGkFOCFDMFmL3uFX41lq07mcJYkg5fEtX7FvKGj2uGa2DptCM0nSMR
         HPZwBpxZ1wuJ3KcDLoXfmTdp3DN/yIUZQpFlJ0ckB7+bqTSJAsnNJyp6Qb2OIaObnF2k
         k9RThwMcyQcm0w/ZHOkT4wPrzJDO2tDFlqxUrWwpHkxrWLBMbsSCLFB9nbS2sakjhLJG
         e4cg==
X-Gm-Message-State: AOAM531Ndpl/noPVNZJBFWLsQ/IPctDdaGev5ftIc4Q9Vh7pBPG6nMoZ
        4gF9SaGu5OZf0JdE++pkmZnSQA==
X-Google-Smtp-Source: ABdhPJxPu+mQfUsUJP3uh7BIhcSbMhQoXkDcblnv7J079B+o50BUhyfoTNA5Sj/UMcbowxzYFuKieA==
X-Received: by 2002:adf:f80e:: with SMTP id s14mr6445421wrp.363.1613473096077;
        Tue, 16 Feb 2021 02:58:16 -0800 (PST)
Received: from antares.lan (111.253.187.81.in-addr.arpa. [81.187.253.111])
        by smtp.gmail.com with ESMTPSA id l1sm2820238wmi.48.2021.02.16.02.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 02:58:15 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        jakub@cloudflare.com
Cc:     kernel-team@cloudflare.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next 0/8] PROG_TEST_RUN support for sk_lookup programs
Date:   Tue, 16 Feb 2021 10:57:05 +0000
Message-Id: <20210216105713.45052-1-lmb@cloudflare.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't have PROG_TEST_RUN support for sk_lookup programs at the
moment. So far this hasn't been a problem, since we can run our
tests in a separate network namespace. For benchmarking it's nice
to have PROG_TEST_RUN, so I've gone and implemented it.

Multiple sk_lookup programs can be attached at once to the same
netns. This can't be expressed with the current PROG_TEST_RUN
API, so I'm proposing to extend it with an array of prog_fd.

Patches 1-2 are clean ups. Patches 3-4 add the new UAPI and
implement PROG_TEST_RUN for sk_lookup. Patch 5 adds a new
function to libbpf to access multi prog tests. Patches 6-8 add
tests.

Andrii, for patch 4 I decided on the following API:

    int bpf_prog_test_run_array(__u32 *prog_fds, __u32 prog_fds_cnt,
                                struct bpf_test_run_opts *opts)

To be consistent with the rest of libbpf it would be better
to take int *prog_fds, but I think then the function would have to
convert the array to account for platforms where

    sizeof(int) != sizeof(__u32)

Please let me know what your preference is.

Lorenz Bauer (8):
  bpf: consolidate shared test timing code
  bpf: add for_each_bpf_prog helper
  bpf: allow multiple programs in BPF_PROG_TEST_RUN
  bpf: add PROG_TEST_RUN support for sk_lookup programs
  tools: libbpf: allow testing program types with multi-prog semantics
  selftests: bpf: convert sk_lookup multi prog tests to PROG_TEST_RUN
  selftests: bpf: convert sk_lookup ctx access tests to PROG_TEST_RUN
  selftests: bpf: check that PROG_TEST_RUN repeats as requested

 include/linux/bpf-netns.h                     |   2 +
 include/linux/bpf.h                           |  24 +-
 include/linux/filter.h                        |   4 +-
 include/uapi/linux/bpf.h                      |  11 +-
 kernel/bpf/net_namespace.c                    |   2 +-
 kernel/bpf/syscall.c                          |  73 +++++-
 net/bpf/test_run.c                            | 230 +++++++++++++-----
 net/core/filter.c                             |   1 +
 tools/include/uapi/linux/bpf.h                |  11 +-
 tools/lib/bpf/bpf.c                           |  16 +-
 tools/lib/bpf/bpf.h                           |   3 +
 tools/lib/bpf/libbpf.map                      |   1 +
 .../selftests/bpf/prog_tests/prog_run_xattr.c |  51 +++-
 .../selftests/bpf/prog_tests/sk_lookup.c      | 172 +++++++++----
 .../selftests/bpf/progs/test_sk_lookup.c      |  62 +++--
 15 files changed, 499 insertions(+), 164 deletions(-)

-- 
2.27.0

