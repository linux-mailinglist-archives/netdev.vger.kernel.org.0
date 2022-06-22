Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 255755550AE
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 18:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359834AbiFVQDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 12:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376590AbiFVQDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 12:03:49 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADEA023BC9
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 09:03:48 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id ie11-20020a17090b400b00b001eccac2af53so29075pjb.9
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 09:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=GNC+G/fXmodqxQrZLcadGmIDOE42uDr3Oxs+P8efPO4=;
        b=Mn8yLe0DZaPh0lw3JmOIbEIHYkB1QcH5QJCm54zhJ8nmW5xiW+GaytMUVYBtxFl4FP
         h5y4szuFDiE467dItcxBSRbeT7PmIcyF2g3wwWFxLgvr5Sg1uyFW1IGVS86OJT3pzcZq
         f+NNrN+zFo2/vpoaLvAa41g+J4mNG8KyVSMmOqh7LKx5fb884TVrqzzJSYWB9RgfqO2k
         nuYYFuqaY7+xxTlYzs3dSrDCSqyj1DEUb3P3ifJnjRvLTFuvsYA9XII2Z9Pk+7HAeeD5
         N3tO/ofcbyqvPeVkTxL1DEywu6noA8SIeBARmYuUBTYfWGTgENqp43+n/yjqdmu2Py6c
         WI9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=GNC+G/fXmodqxQrZLcadGmIDOE42uDr3Oxs+P8efPO4=;
        b=4oMwnVinCpT6+muUFbh/U3xpKRXka9KeBRbjI8M319py2ZfHN6B1HFrAqbVQvyaUxg
         eljurpd2dqSlO4ySOOZHhfEk9vsD3xWd25TSbGYj04D0m1BLlNyS3kPogJynHutm2dPK
         sidP1UofMi6jRDjzNYpd6fUtkOoMTZYVz2ggplJrhVQhlK48fbm0symt/yc/mT5CaILJ
         1BcbWOkgG9DDfczRUAEN1upCiYE9H5v4QbgEWh+BNmBI9IZ+TWtFcvgF14AaABBldwKc
         TrpCTyi0ryWNl+H5X1ZSeauVtvDM33grdb7Hs2fcQ4Ed7/nvsBw0+qdqZcMzAineTwX1
         lD9Q==
X-Gm-Message-State: AJIora+nX7jv/TCbLzBX+w2Fhj1dcZEciGzoM6Xk28y72enmB0UvqaIG
        XnorOrKmZAMaPd9hGNOH1WLE3CSawNchJi6wHl5fuemGTHNXTPp/0aOGRBWQ3sZjJhlS1f5NuVa
        4CkcqtPcxu/Af1SUUnqIasgjFZlcQEPYuI0WIkrnaUgQCi5Vc94sNXQ==
X-Google-Smtp-Source: AGRyM1tqmtB4TY6shamo3eKtk6Yi8L/gsks5wAlkmoVuxclDEsdVSTWp9iTFkPgLoEWVeDqnO/uMxV8=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:e5ca:b0:164:1958:c84a with SMTP id
 u10-20020a170902e5ca00b001641958c84amr34580170plf.72.1655913828106; Wed, 22
 Jun 2022 09:03:48 -0700 (PDT)
Date:   Wed, 22 Jun 2022 09:03:35 -0700
Message-Id: <20220622160346.967594-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH bpf-next v10 00/11] bpf: cgroup_sock lsm flavor
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

v10:
- Martin: reword commit message, drop outdated items
- Martin: remove rcu_real_lock from __cgroup_bpf_run_lsm_current
- Martin: remove CONFIG_BPF_LSM from cgroup_bpf_release
- Martin: fix leaking shim reference in bpf_cgroup_link_release
- Martin: WARN_ON_ONCE for bpf_trampoline_lookup in bpf_trampoline_unlink_cgroup_shim
- Martin: sync tools/include/linux/btf_ids.h
- Martin: move progs/flags closer to the places where they are used in __cgroup_bpf_query
- Martin: remove sk_clone_security & sctp_bind_connect from bpf_lsm_locked_sockopt_hooks
- Martin: try to determine vmlinux btf_id in bpftool
- Martin: update tools header in a separate commit
- Quentin: do libbpf_find_kernel_btf from the ops that need it
- WARN_ON_ONCE for bpf_cgroup_atype_put underflow
- lkp@intel.com: another build failure

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

Stanislav Fomichev (11):
  bpf: add bpf_func_t and trampoline helpers
  bpf: convert cgroup_bpf.progs to hlist
  bpf: per-cgroup lsm flavor
  bpf: minimize number of allocated lsm slots per program
  bpf: implement BPF_PROG_QUERY for BPF_LSM_CGROUP
  bpf: expose bpf_{g,s}etsockopt to lsm cgroup
  tools/bpf: Sync btf_ids.h to tools
  libbpf: add lsm_cgoup_sock type
  libbpf: implement bpf_prog_query_opts
  bpftool: implement cgroup tree for BPF_LSM_CGROUP
  selftests/bpf: lsm_cgroup functional test

 arch/x86/net/bpf_jit_comp.c                   |  24 +-
 include/linux/bpf-cgroup-defs.h               |  13 +-
 include/linux/bpf-cgroup.h                    |   9 +-
 include/linux/bpf.h                           |  44 ++-
 include/linux/bpf_lsm.h                       |   7 +
 include/linux/btf_ids.h                       |   3 +-
 include/uapi/linux/bpf.h                      |   4 +
 kernel/bpf/bpf_lsm.c                          |  81 ++++
 kernel/bpf/btf.c                              |   1 +
 kernel/bpf/cgroup.c                           | 350 ++++++++++++++----
 kernel/bpf/core.c                             |   9 +
 kernel/bpf/syscall.c                          |  18 +-
 kernel/bpf/trampoline.c                       | 262 +++++++++++--
 kernel/bpf/verifier.c                         |  32 ++
 net/core/filter.c                             |  60 ++-
 tools/bpf/bpftool/cgroup.c                    | 109 ++++--
 tools/include/linux/btf_ids.h                 |  35 +-
 tools/include/uapi/linux/bpf.h                |   4 +
 tools/lib/bpf/bpf.c                           |  38 +-
 tools/lib/bpf/bpf.h                           |  15 +
 tools/lib/bpf/libbpf.c                        |   3 +
 tools/lib/bpf/libbpf.map                      |   1 +
 .../selftests/bpf/prog_tests/lsm_cgroup.c     | 277 ++++++++++++++
 .../selftests/bpf/prog_tests/resolve_btfids.c |   2 +-
 .../selftests/bpf/progs/bpf_tracing_net.h     |   1 +
 .../testing/selftests/bpf/progs/lsm_cgroup.c  | 180 +++++++++
 26 files changed, 1416 insertions(+), 166 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c
 create mode 100644 tools/testing/selftests/bpf/progs/lsm_cgroup.c

-- 
2.37.0.rc0.104.g0611611a94-goog

