Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59B5053AD23
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 21:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiFATGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 15:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiFATGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 15:06:39 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DB01C0C86
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 12:06:36 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id m11-20020a25710b000000b0065d4a4abca1so2162533ybc.18
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 12:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=uLhEAF6ELM6OcR0UTHc6s4fCUiCOGO02IN2U67aZoh4=;
        b=Fwl4joEJQzmwoYj3HlsKYdl1hXxIYFc5D6x4vyQKCB0qiIe0S4misb63UMAR0AYmxI
         12MBp2yZQ2ZXLHH+TxIQYGh3X3Qb+aJJD6NBTLCHqYeArk4CqWcDJ8+E8AaR8wkI9Iwe
         ANz6nB40LOl3dySTnLPPU/5SfFv6cg58NCJwCgFiCB+COCo18osVgfpt03M/0G1RW0D5
         sKvkI56HxajxE5eU6DCkrwFcbl+cqWVn36jGtG9d1cr1HfS19U3tsfnxSwGgVn5Xi4Tw
         LFL1wBiG2HkTytJNEhWZFBiUpSAikUiqWV6V3/DXd5XvMS/Fv88mZCIebQZm4xlJ0n2q
         OHkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=uLhEAF6ELM6OcR0UTHc6s4fCUiCOGO02IN2U67aZoh4=;
        b=CgxT3VZL/QKIFAe+3n4/KM+zEmz/f8JbapmvexfHGdsdFXIVMrJ7drjJeKfsAK5UHH
         /KsrAh4E8K+fhcDY3Senvlt8FEdGwypso3au5ZnqMrSHFE5bQDzNJ5i8/Mhq85rJ8dST
         UzJgBbJOdmiRfy422ql8FfAWZiMsCVPHFm3goYNpnmfsV+Bzebm+GS5fBxxOtPGmRPLC
         /w8I8zC/xyqetWLh5qqHjEIeQ1tG1WfSwgf7uJyoxvkIPNN22ye6TADo8KCar6iXG9UE
         Vvv5+GzUMFBfWe5VeAJi4klGleH/RWeoflWEd1P59zWCcDiNR0axDmGA5mFVMl40DPUp
         MVYQ==
X-Gm-Message-State: AOAM5315t+MD+p0t7GGUm1/sf7mfZ5Gjy3Dqkg+s55a4M8179iv4Gm/l
        +Jn+2/yphEIqnMP11e+RaqFpAQpKszbnjDeePR9GHev2wVnkhXKn2g8OLStRMNfNB5Yi4+9qWV5
        y8iAuLyTwpQyguINs/4/LnxR/oPbJti0Z87xMAxFCkXHrsYXH4cnHHg==
X-Google-Smtp-Source: ABdhPJxQYxaZskSSXuvhK0PDgYyyfr2SGwTr4nIHdJmQ34vAIcgYF7xLFVjs3uAtuVuOLhLn0Sveb3k=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a81:a507:0:b0:300:5bfe:e682 with SMTP id
 u7-20020a81a507000000b003005bfee682mr1069826ywg.337.1654110140371; Wed, 01
 Jun 2022 12:02:20 -0700 (PDT)
Date:   Wed,  1 Jun 2022 12:02:07 -0700
Message-Id: <20220601190218.2494963-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH bpf-next v8 00/11] bpf: cgroup_sock lsm flavor
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
  bpf: allow writing to a subset of sock fields from lsm progtype
  libbpf: add lsm_cgoup_sock type
  libbpf: implement bpf_prog_query_opts
  bpftool: implement cgroup tree for BPF_LSM_CGROUP
  selftests/bpf: lsm_cgroup functional test
  selftests/bpf: verify lsm_cgroup struct sock access

 arch/x86/net/bpf_jit_comp.c                   |  24 +-
 include/linux/bpf-cgroup-defs.h               |  13 +-
 include/linux/bpf-cgroup.h                    |   9 +-
 include/linux/bpf.h                           |  39 +-
 include/linux/bpf_lsm.h                       |   7 +
 include/linux/btf_ids.h                       |   3 +-
 include/uapi/linux/bpf.h                      |   4 +
 kernel/bpf/bpf_lsm.c                          | 101 +++++
 kernel/bpf/btf.c                              |  11 +
 kernel/bpf/cgroup.c                           | 370 ++++++++++++++----
 kernel/bpf/core.c                             |   9 +
 kernel/bpf/syscall.c                          |  16 +-
 kernel/bpf/trampoline.c                       | 251 ++++++++++--
 kernel/bpf/verifier.c                         |  35 +-
 tools/bpf/bpftool/cgroup.c                    |  79 ++--
 tools/include/linux/btf_ids.h                 |   4 +-
 tools/include/uapi/linux/bpf.h                |   4 +
 tools/lib/bpf/bpf.c                           |  40 +-
 tools/lib/bpf/bpf.h                           |  15 +
 tools/lib/bpf/libbpf.c                        |   3 +
 tools/lib/bpf/libbpf.map                      |   2 +-
 .../selftests/bpf/prog_tests/lsm_cgroup.c     | 346 ++++++++++++++++
 .../testing/selftests/bpf/progs/lsm_cgroup.c  | 160 ++++++++
 23 files changed, 1394 insertions(+), 151 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c
 create mode 100644 tools/testing/selftests/bpf/progs/lsm_cgroup.c

-- 
2.36.1.255.ge46751e96f-goog

