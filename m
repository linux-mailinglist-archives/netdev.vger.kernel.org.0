Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994C25079AB
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 21:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357487AbiDSTDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 15:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357510AbiDSTDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 15:03:45 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B9D3F8AA
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 12:00:56 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2f182a726abso60709397b3.1
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 12:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ki5x64jpxillM4rjLMMwOyNeXUrOHy0mmqLpSxVVA7k=;
        b=GqtT1JDoHhnKMFQRCf0XJfUJyfAwom7JLQgK98B21O40PNLC4QqJtRE+ubHs4aKMgC
         MyxnIk+9Ap+MSCfo3mNF/JvDlHYeOTREydFKYacMw6BdtQOYRQbt/mBA9DDhclsztT9m
         2NthfSuNNV7Asq8xAFCiHQ8G8Ev/pRUingE3FyU0ODKilnIjDJMn8qnJB4nXy3ASoquA
         3gF5QQwVV/lkmYOOoq/TjvTkuFW5+9GAyDECQ42fwJl1Aa6aczrVJsaVjek4jRKvpZuF
         Z5uDv2UrodDVd1oIVQr10uN9cMx0OuxyXvTQUOQwcwsSbYyJ6THag7qI4M3g1F3FDCgC
         xN5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ki5x64jpxillM4rjLMMwOyNeXUrOHy0mmqLpSxVVA7k=;
        b=MEixdUauIrU6w0N972ngjiOzjCX5IXS4ftWCpig8hlgnj776M2BRgpTz4ywJ5qNrE6
         7Wk/E5DBV++nbOdg2MZtHW59o5AwcLuRY/V9EJkCc81eBJ9ahED/AGAwa35lWoBH1R1H
         V1LFaoWkLHKYV6KZVpVbQX+7T6Qf9JSbmeUt5rsZ97JdT2PKT3V7uISeGMwuNwhBMeEy
         9GVOqNXFtCt0SCVUby/4r/U6kPYbTMic8YRRQAmEGZBAANONBjZ5rvw7dF4HUxnDrzdW
         SbDcYiSG/LbpM6mPbpGgsgekXk0XJk119gUKrJLxZzkr4a9z+JNkDzP1CWcsGUxLE5Rm
         P4kA==
X-Gm-Message-State: AOAM532raeEA+2nNB74wOdsSgbEqpPuzzc4MoALIISR4YpdzTMGztXTK
        fmKX+2/I9dg0ZxhPPb1woL2mPfcUGO4kGT4YTuw5mzIPTQ3+JUXSU/L4Zj+anoRgARHmjw44KXl
        qR9u9HynPYYTIL4I8SMI87EmZDGvtP0+779FrZt4n7LkoxkeRTq6eIw==
X-Google-Smtp-Source: ABdhPJz2F4cplxzM4FtGL7Yml3tWUtWopJhoV6OAbCweuRz0FTCl6R+gG1IyMDeaJIE8q3sm/Q3IRAc=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:37f:6746:8e66:a291])
 (user=sdf job=sendgmr) by 2002:a0d:dc01:0:b0:2ec:2aed:5aa5 with SMTP id
 f1-20020a0ddc01000000b002ec2aed5aa5mr17104194ywe.235.1650394855513; Tue, 19
 Apr 2022 12:00:55 -0700 (PDT)
Date:   Tue, 19 Apr 2022 12:00:45 -0700
Message-Id: <20220419190053.3395240-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH bpf-next v5 0/8] bpf: cgroup_sock lsm flavor
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>, kafai@fb.com,
        kpsingh@kernel.org, jakub@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series implements new lsm flavor for attaching per-cgroup programs to
existing lsm hooks. The cgroup is taken out of 'current', unless
the first argument of the hook is 'struct socket'. In this case,
the cgroup association is taken out of socket. The attachment
looks like a regular per-cgroup attachment: we add new BPF_LSM_CGROUP
attach type which, together with attach_btf_id, signals per-cgroup lsm.
Behind the scenes, we allocate trampoline shim program and
attach to lsm. This program looks up cgroup from current/socket
and runs cgroup's effective prog array. The rest of the per-cgroup BPF
stays the same: hierarchy, local storage, retval conventions
(return 1 == success).

Current limitations:
* haven't considered sleepable bpf; can be extended later on
* not sure the verifier does the right thing with null checks;
  see latest selftest for details
* total of 10 (global) per-cgroup LSM attach points; this bloats
  bpf_cgroup a bit

Cc: ast@kernel.org
Cc: daniel@iogearbox.net
Cc: kafai@fb.com
Cc: kpsingh@kernel.org
Cc: jakub@cloudflare.com

v5:
- __cgroup_bpf_run_lsm_socket remove NULL sock/sk checks (Martin KaFai Lau)
- __cgroup_bpf_run_lsm_{socket,current} s/prog/shim_prog/ (Martin)
- make sure bpf_lsm_find_cgroup_shim works for hooks without args (Martin)
- __cgroup_bpf_attach make sure attach_btf_id is the same when replacing (Martin)
- call bpf_cgroup_lsm_shim_release only for LSM_CGROUP (Martin)
- drop BPF_LSM_CGROUP from bpf_attach_type_to_tramp (Martin)
- drop jited check from cgroup_shim_find (Martin)
- new patch to convert cgroup_bpf to hlist_node (Jakub Sitnicki)
- new shim flavor for 'struct sock' + list of exceptions (Martin)

v4:
- fix build when jit is on but syscall is off

v3:
- add BPF_LSM_CGROUP to bpftool
- use simple int instead of refcnt_t (to avoid use-after-free
  false positive)

v2:
- addressed build bot failures

Stanislav Fomichev (8):
  bpf: add bpf_func_t and trampoline helpers
  bpf: convert cgroup_bpf.progs to hlist
  bpf: per-cgroup lsm flavor
  bpf: minimize number of allocated lsm slots per program
  bpf: allow writing to a subset of sock fields from lsm progtype
  libbpf: add lsm_cgoup_sock type
  selftests/bpf: lsm_cgroup functional test
  selftests/bpf: verify lsm_cgroup struct sock access

 include/linux/bpf-cgroup-defs.h               |  12 +-
 include/linux/bpf-cgroup.h                    |   9 +-
 include/linux/bpf.h                           |  24 +-
 include/linux/bpf_lsm.h                       |   8 +
 include/uapi/linux/bpf.h                      |   1 +
 kernel/bpf/bpf_lsm.c                          | 116 ++++++
 kernel/bpf/btf.c                              |  11 +
 kernel/bpf/cgroup.c                           | 361 +++++++++++++++---
 kernel/bpf/syscall.c                          |  10 +
 kernel/bpf/trampoline.c                       | 206 ++++++++--
 kernel/bpf/verifier.c                         |   4 +-
 tools/bpf/bpftool/common.c                    |   1 +
 tools/include/uapi/linux/bpf.h                |   1 +
 tools/lib/bpf/libbpf.c                        |   2 +
 .../selftests/bpf/prog_tests/lsm_cgroup.c     | 213 +++++++++++
 .../testing/selftests/bpf/progs/lsm_cgroup.c  | 126 ++++++
 tools/testing/selftests/bpf/test_verifier.c   |  54 ++-
 .../selftests/bpf/verifier/lsm_cgroup.c       |  34 ++
 18 files changed, 1102 insertions(+), 91 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c
 create mode 100644 tools/testing/selftests/bpf/progs/lsm_cgroup.c
 create mode 100644 tools/testing/selftests/bpf/verifier/lsm_cgroup.c

-- 
2.36.0.rc0.470.gd361397f0d-goog

