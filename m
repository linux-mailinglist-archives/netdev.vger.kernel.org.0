Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 814D751568D
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 23:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236133AbiD2VTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 17:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235829AbiD2VTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 17:19:03 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6333C5522F
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 14:15:43 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2f7c322f770so85252347b3.20
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 14:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=4rrbqWIkzBFxWlYrTNfphM935o/i3z7llOTk0Sx5dmQ=;
        b=jQRYNBfiBPED907CoH0P6EsLo6/AcYtMk1dg2tlniADS8ZVZ4AGIvI37XQJyfORz4h
         TSRfFKOGWi+kJcexJYoqokUqwb7PoOeHdmBLZaS4TjbZ4ReNlMcNmeXOB5RK7ivZs+Wo
         xEjwNH42RY16+D5qWgRC7WFJyJjHORaFcCk+Jp8h+l1ZrXI/+Q6Twwi4NkOzQCkslWOn
         YO+nmHPxl+pBAy47Z4Z+tQ0WQtNrBxea65wtoPnTFDjYB54kqFzgApCo+QUTAHmd8IiM
         FClqKgIRLp7e6fM19IVq5t0ky0NxuJR910mtdnE77bGJl+F5ODcus6gTW7x9N40w3gMy
         DNGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=4rrbqWIkzBFxWlYrTNfphM935o/i3z7llOTk0Sx5dmQ=;
        b=v3rMvrJHbkTDyy54vRjgOwT1wxFHRago+KGVDjIZlRVpOody9E3+KAQ5WCZT03yMAg
         QRnxkoUhTYHpr25RC/9LBl2oeSvGhcZvLPbct7SMWjsRjXFMJVJuI/lyH6Mqh92mF1PN
         NeMYdBmugV63F/r03J4NvYb2piPAAPt7nQZClOP3uLZpVl2LUt+Ss79p6JypFb2qRtkh
         GICQed4/H6CUCeD/PylpVOJ2bgarsALch2FehzUytl6dDbfFBLW5I8q0xul5Mu+InrZ9
         FxSV5H2vMSROhmbHwzzNs38Y9dKYGIVTH4LiFDs70PcXDq6dYq/8b20xiuh4Oke/g2qM
         pemA==
X-Gm-Message-State: AOAM532hGkFmXaRndI9tSrSD7bi4MV4wS08WLqYim1dDJbHCqsFsfekP
        jcyxn1qtGNqS0s/OFEOK7GAdDaJWi69Hco+XZ76UsMZ91QsD5sd2FBu5JNJHvXbdAvyfifiaTK4
        ev6BgClAhhWdxzPKzUF5UgNuvGkiYB/nuaLvbCXPleY7/g3a2Xj+iCA==
X-Google-Smtp-Source: ABdhPJycglN1nrJ0Xx4drW6j4Tv/9u3FfA0VgHMgTNetJIOh7ciL+E/YDAOJRohyXGr2eey1OrTHP4Y=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:b0cc:7605:1029:2d96])
 (user=sdf job=sendgmr) by 2002:a25:cfd7:0:b0:648:4e70:a98 with SMTP id
 f206-20020a25cfd7000000b006484e700a98mr1476285ybg.368.1651266942572; Fri, 29
 Apr 2022 14:15:42 -0700 (PDT)
Date:   Fri, 29 Apr 2022 14:15:30 -0700
Message-Id: <20220429211540.715151-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH bpf-next v6 00/10] bpf: cgroup_sock lsm flavor
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>, kafai@fb.com,
        kpsingh@kernel.org, jakub@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
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

v6:
- remove active count & stats for shim program (Martin KaFai Lau)
- remove NULL/error check for btf_vmlinux (Martin)
- don't check cgroup_atype in bpf_cgroup_lsm_shim_release (Martin)
- use old_prog (instead of passed one) in __cgroup_bpf_detach (Martin)
- make sure attach_btf_id is the same in __cgroup_bpf_replace (Martin)
- enable cgroup local storage and test it (Martin)
- properly implement prog query and add bpftool & tests (Martin)
- prohibit non-shared cgroup storage mode for BPF_LSM_CGROUP (Martin)

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

Stanislav Fomichev (10):
  bpf: add bpf_func_t and trampoline helpers
  bpf: convert cgroup_bpf.progs to hlist
  bpf: per-cgroup lsm flavor
  bpf: minimize number of allocated lsm slots per program
  bpf: implement BPF_PROG_QUERY for BPF_LSM_CGROUP
  bpf: allow writing to a subset of sock fields from lsm progtype
  libbpf: add lsm_cgoup_sock type
  bpftool: implement cgroup tree for BPF_LSM_CGROUP
  selftests/bpf: lsm_cgroup functional test
  selftests/bpf: verify lsm_cgroup struct sock access

 arch/x86/net/bpf_jit_comp.c                   |  22 +-
 include/linux/bpf-cgroup-defs.h               |  11 +-
 include/linux/bpf-cgroup.h                    |   9 +-
 include/linux/bpf.h                           |  26 +-
 include/linux/bpf_lsm.h                       |   8 +
 include/uapi/linux/bpf.h                      |   2 +
 kernel/bpf/bpf_lsm.c                          | 117 ++++++
 kernel/bpf/btf.c                              |  11 +
 kernel/bpf/cgroup.c                           | 391 +++++++++++++++---
 kernel/bpf/syscall.c                          |  13 +-
 kernel/bpf/trampoline.c                       | 222 ++++++++--
 kernel/bpf/verifier.c                         |  35 +-
 tools/bpf/bpftool/cgroup.c                    | 138 +++++--
 tools/bpf/bpftool/common.c                    |   1 +
 tools/include/uapi/linux/bpf.h                |   2 +
 tools/lib/bpf/bpf.c                           |  42 +-
 tools/lib/bpf/bpf.h                           |  15 +
 tools/lib/bpf/libbpf.c                        |   2 +
 tools/lib/bpf/libbpf.map                      |   1 +
 .../selftests/bpf/prog_tests/lsm_cgroup.c     | 236 +++++++++++
 .../testing/selftests/bpf/progs/lsm_cgroup.c  | 160 +++++++
 tools/testing/selftests/bpf/test_verifier.c   |  54 ++-
 .../selftests/bpf/verifier/lsm_cgroup.c       |  34 ++
 23 files changed, 1406 insertions(+), 146 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c
 create mode 100644 tools/testing/selftests/bpf/progs/lsm_cgroup.c
 create mode 100644 tools/testing/selftests/bpf/verifier/lsm_cgroup.c

-- 
2.36.0.464.gb9c8b46e94-goog

