Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6936D546B36
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 19:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349938AbiFJQ6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 12:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346656AbiFJQ6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 12:58:09 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5EA93122D
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 09:58:07 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id l5-20020a170902f68500b00167654aeba1so9720556plg.2
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 09:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=C2Epa9iSd5RL+UL7LHQMLz+46ZPmdUGYavsxZYIOEsA=;
        b=SFwikgVk1+rxTNNL9khMMp+uIIiUfVuSIFykBG+2oPoJD+DpOUs3j2gRKvFrIQqysP
         laYkFbJc8gOr2dGMAL4uNtFNB7LdhMb8m7GxY1+UDNU3FH5LfDhQUlFmZ5e7Gnp1V/k/
         0Ufsqasr2Pex6BKKnw/ScwgwUv+vTf1cmUAb1qW99uFZc9ZXlu7NUdtoxusVcojvkUcg
         axHicSs9tP176wiHfdhxR0Hogp26/CBc0OQnfbAATYyZaXecYBQN5EkDgQkWQTKOr3Eq
         hlEoaPCcK0OpCiRWTx/1mp1BirbHrdsVQOk4zimRp/kbyjHCYwbk8ApjBEVsdsWhhplY
         X1RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=C2Epa9iSd5RL+UL7LHQMLz+46ZPmdUGYavsxZYIOEsA=;
        b=rxgcU924/TDfJTHaRixNwcHKyT/APAQqGF1fhIATq9m/qlOLB9W9pXD3OhrXdNtenK
         pBIWu156lSIcTHwvok95ENViODm0mHwLeaCp0LMuPIiFU4Kr8+S0aR7MFPVvPuNPNOdU
         Og5cDPwHSw1FWq5GLKv+hYy2MW9h8PGo9SRKndAu1vbZRJqDWpqsBovRjpbpMbisiYLX
         N26Z8gJ4M7GumjAyFWM629BynySyS7dkeF64k8rIb6SjTvpcUbvyNPMAyHmK1jBXOh4l
         uMHnx6Slgz5EUWUsnn6rZ24tyDkG4PyhzKB5EtNk+Zv3nq3um13qyzO+TkHepS80U5tt
         SfCw==
X-Gm-Message-State: AOAM531bBt90++nyzELh7p48et0lzFv4Pg/ncDUZZm+UWzoRrioR1W42
        cFUA107BxNk+ACqrmoAhvws4QyvHEigCBZAgoTtTItx0FSLY6JsH5N/ijpTufRsQXUus0b0Oj5f
        +5TOdlOwiIPBwE5TjNaAsZi8T4NHX+1UmtroiGNclldChxpGl6Qdjog==
X-Google-Smtp-Source: ABdhPJxnbW9g3wVaD5uGrfJXYnSRSWQrTTOy2bmQqVaiXWGfPGD9c/jCd4EFIJRE/x1n5z/0qiJ8YeE=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90a:178f:b0:1e3:3ba:c185 with SMTP id
 q15-20020a17090a178f00b001e303bac185mr1248pja.1.1654880285301; Fri, 10 Jun
 2022 09:58:05 -0700 (PDT)
Date:   Fri, 10 Jun 2022 09:57:53 -0700
Message-Id: <20220610165803.2860154-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH bpf-next v9 00/10] bpf: cgroup_sock lsm flavor
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>, kafai@fb.com,
        kpsingh@kernel.org, jakub@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
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

v9:
Major change since last version is the switch to bpf_setsockopt to
change the socket state instead of letting the progs poke socket directly.
This, in turn, highlights the challenge that we need to care about whether
the socket is locked or not when we call bpf_setsockopt. (with my original
example selftest, the hooks are running early in the init phase for this
not to matter).

For now, I've added two btf id lists:
* hooks where we know the socket is locked and it's safe to call bpf_setsockopt
* hooks where we know the socket is _not_ locked, but the hook works on
  the socket that's not yet exposed to userspace so it should be safe
  (for this mode, special new set of bpf_{s,g}etsockopt helpers
   is added; they don't have sock_owned_by_me check)

Going forward, for the rest of the hooks, this might be a good motivation
to expand lsm cgroup to support sleeping bpf and allow the callers to
lock/unlock sockets or have a new bpf_setsockopt variant that does the
locking.

- ifdef around cleanup in cgroup_bpf_release
- Andrii: a few nits in libbpf patches
- Martin: remove unused btf_id_set_index
- Martin: bring back refcnt for cgroup_atype
- Martin: make __cgroup_bpf_query a bit more readable
- Martin: expose dst_prog->aux->attach_btf as attach_btf_obj_id as well
- Martin: reorg check_return_code path for BPF_LSM_CGROUP
- Martin: return directly from check_helper_call (instead of goto err)
- Martin: add note to new warning in check_return_code, print only for void hooks
- Martin: remove confusing shim reuse
- Martin: use bpf_{s,g}etsockopt instead of poking into socket data
- Martin: use CONFIG_CGROUP_BPF in bpf_prog_alloc_no_stats/bpf_prog_free_deferred

v8:
- CI: fix compile issue
- CI: fix broken bpf_cookie
- Yonghong: remove __bpf_trampoline_unlink_prog comment
- Yonghong: move cgroup_atype around to fill the gap
- Yonghong: make bpf_lsm_find_cgroup_shim void
- Yonghong: rename regs to args
- Yonghong: remove if(current) check
- Martin: move refcnt into bpf_link
- Martin: move shim management to bpf_link ops
- Martin: use cgroup_atype for shim only
- Martin: go back to arrays for managing cgroup_atype(s)
- Martin: export bpf_obj_id(aux->attach_btf)
- Andrii: reorder SEC_DEF("lsm_cgroup+")
- Andrii: OPTS_SET instead of OPTS_HAS
- Andrii: rename attach_btf_func_id
- Andrii: move into 1.0 map

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

Stanislav Fomichev (10):
  bpf: add bpf_func_t and trampoline helpers
  bpf: convert cgroup_bpf.progs to hlist
  bpf: per-cgroup lsm flavor
  bpf: minimize number of allocated lsm slots per program
  bpf: implement BPF_PROG_QUERY for BPF_LSM_CGROUP
  bpf: expose bpf_{g,s}etsockopt to lsm cgroup
  libbpf: add lsm_cgoup_sock type
  libbpf: implement bpf_prog_query_opts
  bpftool: implement cgroup tree for BPF_LSM_CGROUP
  selftests/bpf: lsm_cgroup functional test

 arch/x86/net/bpf_jit_comp.c                   |  24 +-
 include/linux/bpf-cgroup-defs.h               |  13 +-
 include/linux/bpf-cgroup.h                    |   9 +-
 include/linux/bpf.h                           |  39 +-
 include/linux/bpf_lsm.h                       |   7 +
 include/linux/btf_ids.h                       |   3 +-
 include/uapi/linux/bpf.h                      |   4 +
 kernel/bpf/bpf_lsm.c                          |  83 ++++
 kernel/bpf/btf.c                              |   1 +
 kernel/bpf/cgroup.c                           | 360 ++++++++++++++----
 kernel/bpf/core.c                             |   9 +
 kernel/bpf/syscall.c                          |  18 +-
 kernel/bpf/trampoline.c                       | 262 +++++++++++--
 kernel/bpf/verifier.c                         |  32 ++
 net/core/filter.c                             |  60 ++-
 tools/bpf/bpftool/cgroup.c                    |  80 ++--
 tools/include/linux/btf_ids.h                 |   4 +-
 tools/include/uapi/linux/bpf.h                |   4 +
 tools/lib/bpf/bpf.c                           |  38 +-
 tools/lib/bpf/bpf.h                           |  15 +
 tools/lib/bpf/libbpf.c                        |   3 +
 tools/lib/bpf/libbpf.map                      |   1 +
 .../selftests/bpf/prog_tests/lsm_cgroup.c     | 277 ++++++++++++++
 .../selftests/bpf/progs/bpf_tracing_net.h     |   1 +
 .../testing/selftests/bpf/progs/lsm_cgroup.c  | 180 +++++++++
 25 files changed, 1369 insertions(+), 158 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c
 create mode 100644 tools/testing/selftests/bpf/progs/lsm_cgroup.c

-- 
2.36.1.476.g0c4daa206d-goog

