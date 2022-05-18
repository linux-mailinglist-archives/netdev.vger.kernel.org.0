Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97E5452C749
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 01:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbiERXDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 19:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiERXDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 19:03:09 -0400
Received: from mail-ua1-x94a.google.com (mail-ua1-x94a.google.com [IPv6:2607:f8b0:4864:20::94a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E089FD1
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 16:03:07 -0700 (PDT)
Received: by mail-ua1-x94a.google.com with SMTP id i4-20020ab04744000000b003520c239119so1623885uac.18
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 16:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=rxWuq5Eq9rqU9PxUcN0z4xXoIEFi0i+qUjtJPDAZx/k=;
        b=rIKcbnBL3JN5WKyKtJyQVqOT6PxCDE4+aRM/ZCK/A3o8Wfl16hyne1D+KszZdgLuWm
         fCU7HEUTDZw1hTsBh1DTo4e0b5M+HIT1sBcXKjJxFo9rECHcxJW8xOsIKRYY3DNUBzhu
         44Qo3dGbHOo4/5iivn8BTUPElexp8h6JZCkJkgWQKqQm3iwEjEYlc+QsKcv9YX133ntS
         P1X/PTS/mZ3w4igmOpf1M9deAHVbKCURE/dfYda1UuoHYy+usWy7j4Rc1iGgKwe+fX/8
         2kdPS/liGUsf1HDDyEbJxzKDajKtzebDlgBlcamD1y6ctWrCL1RKlazOrdB3aliheRzY
         Z7eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=rxWuq5Eq9rqU9PxUcN0z4xXoIEFi0i+qUjtJPDAZx/k=;
        b=xqkn9Svx9GrZT0uVFSilDccyg+LBwTw0BejGVO9j9nDj00sbjbBa0XIxlcU2sCKYfF
         ag2LsFMzHLiHz4e/UMlkf0/18/4B+wfbLt4xlc65QVNtiuLO+dGjT7R7vuqmpVUC0ORC
         AmVc8q6MngzXZDHLaO2HDIsmt3Nf34mFP8Jk4lFART6jnjqak63fAkG4CxFmH4V0Suc9
         b6ELDRrKsCjRNW2XAUGcGIsJG8e8LaqXVdkn2dOP9XLETstyAXH7r7kShmRk6lEf3p2G
         h02JtsV9GgaSRho8592Q9ZmYWf5nYzABBIlzgPfpjRVJpWMZ5lgamdhANDxWUwWdhTjn
         X8oQ==
X-Gm-Message-State: AOAM531lPqt6+20x0Bsx0UeoRwDj5BhNe2cUeJ0dTmkwDYxXBtMIcP6N
        ce4otKlMIGuM7Y417EXqLVPb6NhHhhcbpI0FzY0yvXD0hPcaMnagHw3HaBHcyq36ldNOlua6XJy
        vBpZnV+MCrqnbvBPbE0v2i1vp82bbTcqoSiqQ5IYSgXMsFinxm6Q5yg==
X-Google-Smtp-Source: ABdhPJxbC6NHO5Blrz6es+xHjVpEwO/nnogItSvEYMXtjEZpB+z2PQgNj7Cx9un2nPXNwHY9kgPPlIw=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:f763:3448:2567:bf00])
 (user=sdf job=sendgmr) by 2002:a05:6902:18a:b0:64b:30ae:da2a with SMTP id
 t10-20020a056902018a00b0064b30aeda2amr1691592ybh.314.1652914533156; Wed, 18
 May 2022 15:55:33 -0700 (PDT)
Date:   Wed, 18 May 2022 15:55:20 -0700
Message-Id: <20220518225531.558008-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH bpf-next v7 00/11] bpf: cgroup_sock lsm flavor
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
* total of 10 (global) per-cgroup LSM attach points

Cc: ast@kernel.org
Cc: daniel@iogearbox.net
Cc: kafai@fb.com
Cc: kpsingh@kernel.org
Cc: jakub@cloudflare.com

v7:
- there were a lot of comments last time, hope I didn't forget anything,
  some of the bigger ones:
  - Martin: use/extend BTF_SOCK_TYPE_SOCKET
  - Martin: expose bpf_set_retval
  - Martin: reject 'return 0' at the verifier for 'void' hooks
  - Martin: prog_query returns all BPF_LSM_CGROUP, prog_info
    returns attach_btf_func_id
  - Andrii: split libbpf changes
  - Andrii: add field access test to test_progs, not test_verifier (still
    using asm though)
- things that I haven't addressed, stating them here explicitly, let
  me know if some of these are still problematic:
  1. Andrii: exposing only link-based api: seems like the changes
     to support non-link-based ones are minimal, couple of lines,
     so seems like it worth having it?
  2. Alexei: applying cgroup_atype for all cgroup hooks, not only
     cgroup lsm: looks a bit harder to apply everywhere that I
     originally thought; with lsm cgroup, we have a shim_prog pointer where
     we store cgroup_atype; for non-lsm programs, we don't have a
     trace program where to store it, so we still need some kind
     of global table to map from "static" hook to "dynamic" slot.
     So I'm dropping this "can be easily extended" clause from the
     description for now. I have converted this whole machinery
     to an RCU-managed list to remove synchronize_rcu().
- also note that I had to introduce new bpf_shim_tramp_link and
  moved refcnt there; we need something to manage new bpf_tramp_link

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

Stanislav Fomichev (11):
  bpf: add bpf_func_t and trampoline helpers
  bpf: convert cgroup_bpf.progs to hlist
  bpf: per-cgroup lsm flavor
  bpf: minimize number of allocated lsm slots per program
  bpf: implement BPF_PROG_QUERY for BPF_LSM_CGROUP
  bpf: allow writing to a subset of sock fields from lsm progtype
  libbpf: implement bpf_prog_query_opts
  libbpf: add lsm_cgoup_sock type
  bpftool: implement cgroup tree for BPF_LSM_CGROUP
  selftests/bpf: lsm_cgroup functional test
  selftests/bpf: verify lsm_cgroup struct sock access

 arch/x86/net/bpf_jit_comp.c                   |  24 +-
 include/linux/bpf-cgroup-defs.h               |  11 +-
 include/linux/bpf-cgroup.h                    |   9 +-
 include/linux/bpf.h                           |  36 +-
 include/linux/bpf_lsm.h                       |   8 +
 include/linux/btf_ids.h                       |   3 +-
 include/uapi/linux/bpf.h                      |   6 +
 kernel/bpf/bpf_lsm.c                          | 103 ++++
 kernel/bpf/btf.c                              |  11 +
 kernel/bpf/cgroup.c                           | 487 +++++++++++++++---
 kernel/bpf/core.c                             |   2 +
 kernel/bpf/syscall.c                          |  14 +-
 kernel/bpf/trampoline.c                       | 244 ++++++++-
 kernel/bpf/verifier.c                         |  31 +-
 tools/bpf/bpftool/cgroup.c                    |  77 ++-
 tools/bpf/bpftool/common.c                    |   1 +
 tools/include/linux/btf_ids.h                 |   4 +-
 tools/include/uapi/linux/bpf.h                |   6 +
 tools/lib/bpf/bpf.c                           |  42 +-
 tools/lib/bpf/bpf.h                           |  15 +
 tools/lib/bpf/libbpf.c                        |   2 +
 tools/lib/bpf/libbpf.map                      |   1 +
 .../selftests/bpf/prog_tests/lsm_cgroup.c     | 346 +++++++++++++
 .../testing/selftests/bpf/progs/lsm_cgroup.c  | 160 ++++++
 24 files changed, 1480 insertions(+), 163 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c
 create mode 100644 tools/testing/selftests/bpf/progs/lsm_cgroup.c

-- 
2.36.1.124.g0e6072fb45-goog

