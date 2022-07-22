Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0455357E5D8
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 19:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235584AbiGVRsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 13:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbiGVRsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 13:48:43 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD850951CB
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 10:48:41 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id r142-20020a632b94000000b0041a18177a5dso2647930pgr.10
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 10:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=UyUTAWXY2X7Ah7B66gjrMw5pytdA/PXbXOomWNvEeu4=;
        b=ngpBh/IUZHhDQudw0NBRS6eJp0k0g/Snc2g0NBOVsHv/wQcYkt0l+UEhsXKCu+eejM
         AMhKjqPVoFU9oi2ibluyDp59JcRJNPjsOmboAZJXg6iRUnWCI6FzLg1MLJCRaKfXPHgL
         2v3eLNBDe6NQ+fs6UjlC8U9dJA7vT70xoNsVGC/R/y13iDAPMt8c1zhgBKZ6KzFnnP+k
         xBWnbQTX0FnGho2qGQxbcwZqMZjp3agbrQtUuMVfqABDi1t2weAWEHE7Azj10Z5bhY/p
         hJIypeVjMjYfot2phNe6bY4I+/70xKC2oznTR9+JLBbj8evJPPmv6M0yfl+XCD/CCP8L
         28zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=UyUTAWXY2X7Ah7B66gjrMw5pytdA/PXbXOomWNvEeu4=;
        b=Gq+kdfQxzKlob3lFPMNNr871KrwUoW0ClsuAiE2HIuvaFFn/hb9riWCt0PicZ5rjt8
         iDY371A0CD9ScrCV076T9/Lu9SDVcOODgQgmJs42L5agGCaN/AwsDe0EHg49RuBRRZUg
         uigCZjQjWRIW1/lhzkwRchZVnUXmiMih/DVyWpnI0yeMXQzgYBc9wErK1SiQS6FHIedC
         cKIoXxbddpoWJm+xEsRtf+6XtB20BBbSspR9LAN7cx2+wfqAYFWdYn1bzTxmOZsc5tpf
         U92pYiph6vdoX5TgCIMrTLc0kpDSQCUwFdg539TTQVrwunGRNqvsEc6kXc7IRiuwSxny
         mA/g==
X-Gm-Message-State: AJIora/pDcpF7hk1FKOHqdfBGrzB/Cv8dprNDKcKHfFP5st2K7eiCCM7
        h1ryFAr9h0Z5p/OT3iNMdqEffnEc/druvXTN
X-Google-Smtp-Source: AGRyM1v3LSHWNM0kw8aCul8CF8SYWemX3ff4Lm/DVrdYY2CQrbZa1lAcuHv2KYtIfRt9JYeXkKIvcmu2l/k7pNJi
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:aa7:888a:0:b0:52b:17e8:fd1 with SMTP id
 z10-20020aa7888a000000b0052b17e80fd1mr907090pfe.46.1658512121117; Fri, 22 Jul
 2022 10:48:41 -0700 (PDT)
Date:   Fri, 22 Jul 2022 17:48:21 +0000
Message-Id: <20220722174829.3422466-1-yosryahmed@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH bpf-next v5 0/8] bpf: rstat: cgroup hierarchical stats
From:   Yosry Ahmed <yosryahmed@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org,
        Yosry Ahmed <yosryahmed@google.com>
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

This patch series allows for using bpf to collect hierarchical cgroup
stats efficiently by integrating with the rstat framework. The rstat
framework provides an efficient way to collect cgroup stats percpu and
propagate them through the cgroup hierarchy.

The stats are exposed to userspace in textual form by reading files in
bpffs, similar to cgroupfs stats by using a cgroup_iter program.
cgroup_iter is a type of bpf_iter. It walks over cgroups in three modes:
- walking a cgroup's descendants in pre-order.
- walking a cgroup's descendants in post-order.
- walking a cgroup's ancestors.

When attaching cgroup_iter, one needs to set a cgroup to the iter_link
created from attaching. This cgroup is passed as a file descriptor and
serves as the starting point of the walk.

One can also terminate the walk early by returning 1 from the iter
program.

Note that because walking cgroup hierarchy holds cgroup_mutex, the iter
program is called with cgroup_mutex held.

** Background on rstat for stats collection **
(I am using a subscriber analogy that is not commonly used)

The rstat framework maintains a tree of cgroups that have updates and
which cpus have updates. A subscriber to the rstat framework maintains
their own stats. The framework is used to tell the subscriber when
and what to flush, for the most efficient stats propagation. The
workflow is as follows:

- When a subscriber updates a cgroup on a cpu, it informs the rstat
  framework by calling cgroup_rstat_updated(cgrp, cpu).

- When a subscriber wants to read some stats for a cgroup, it asks
  the rstat framework to initiate a stats flush (propagation) by calling
  cgroup_rstat_flush(cgrp).

- When the rstat framework initiates a flush, it makes callbacks to
  subscribers to aggregate stats on cpus that have updates, and
  propagate updates to their parent.

Currently, the main subscribers to the rstat framework are cgroup
subsystems (e.g. memory, block). This patch series allow bpf programs to
become subscribers as well.

This patch series includes a resend of a patch from the mailing list by
Benjamin Tissoires to support sleepable kfuncs [1], modified to use the
new kfunc flags infrastructure.

Patches in this series are organized as follows:
* Patch 1 is the updated sleepable kfuncs patch.
* Patch 2 enables the use of cgroup_get_from_file() in cgroup1.
  This is useful because it enables cgroup_iter to work with cgroup1, and
  allows the entire stat collection workflow to be cgroup1-compatible.
* Patches 3-5 introduce cgroup_iter prog, and a selftest.
* Patches 6-8 allow bpf programs to integrate with rstat by adding the
  necessary hook points and kfunc. A comprehensive selftest that
  demonstrates the entire workflow for using bpf and rstat to
  efficiently collect and output cgroup stats is added.

---
Changelog:

v4 -> v5:
- Rebased on top of new kfunc flags infrastructure, updated patch 1 and
  patch 6 accordingly.
- Added docs for sleepable kfuncs.

v3 -> v4:
- cgroup_iter:
  * reorder fields in bpf_link_info to avoid break uapi (Yonghong)
  * comment the behavior when cgroup_fd=0 (Yonghong)
  * comment on the limit of number of cgroups supported by cgroup_iter.
    (Yonghong)
- cgroup_hierarchical_stats selftest:
  * Do not return -1 if stats are not found (causes overflow in userspace).
  * Check if child process failed to join cgroup.
  * Make buf and path arrays in get_cgroup_vmscan_delay() static.
  * Increase the test map sizes to accomodate cgroups that are not
    created by the test.

v2 -> v3:
- cgroup_iter:
  * Added conditional compilation of cgroup_iter.c in kernel/bpf/Makefile
    (kernel test) and dropped the !CONFIG_CGROUP patch.
  * Added validation of traversal_order when attaching (Yonghong).
  * Fixed previous wording "two modes" to "three modes" (Yonghong).
  * Fixed the btf_dump selftest broken by this patch (Yonghong).
  * Fixed ctx_arg_info[0] to use "PTR_TO_BTF_ID_OR_NULL" instead of
    "PTR_TO_BTF_ID", because the "cgroup" pointer passed to iter prog can
     be null.
- Use __diag_push to eliminate __weak noinline warning in
  bpf_rstat_flush().
- cgroup_hierarchical_stats selftest:
  * Added write_cgroup_file_parent() helper.
  * Added error handling for failed map updates.
  * Added null check for cgroup in vmscan_flush.
  * Fixed the signature of vmscan_[start/end].
  * Correctly return error code when attaching trace programs fail.
  * Make sure all links are destroyed correctly and not leaking in
    cgroup_hierarchical_stats selftest.
  * Use memory.reclaim instead of memory.high as a more reliable way to
    invoke reclaim.
  * Eliminated sleeps, the test now runs faster.

v1 -> v2:
- Redesign of cgroup_iter from v1, based on Alexei's idea [2]:
  * supports walking cgroup subtree.
  * supports walking ancestors of a cgroup. (Andrii)
  * supports terminating the walk early.
  * uses fd instead of cgroup_id as parameter for iter_link. Using fd is
    a convention in bpf.
  * gets cgroup's ref at attach time and deref at detach.
  * brought back cgroup1 support for cgroup_iter.
- Squashed the patches adding the rstat flush hook points and kfuncs
  (Tejun).
- Added a comment explaining why bpf_rstat_flush() needs to be weak
  (Tejun).
- Updated the final selftest with the new cgroup_iter design.
- Changed CHECKs in the selftest with ASSERTs (Yonghong, Andrii).
- Removed empty line at the end of the selftest (Yonghong).
- Renamed test files to cgroup_hierarchical_stats.c.
- Reordered CGROUP_PATH params order to match struct declaration
  in the selftest (Michal).
- Removed memory_subsys_enabled() and made sure memcg controller
  enablement checks make sense and are documented (Michal).

RFC v2 -> v1:
- Instead of introducing a new program type for rstat flushing, add an
  empty hook point, bpf_rstat_flush(), and use fentry bpf programs to
  attach to it and flush bpf stats.
- Instead of using helpers, use kfuncs for rstat functions.
- These changes simplify the patchset greatly, with minimal changes to
  uapi.

RFC v1 -> RFC v2:
- Instead of rstat flush programs attach to subsystems, they now attach
  to rstat (global flushers, not per-subsystem), based on discussions
  with Tejun. The first patch is entirely rewritten.
- Pass cgroup pointers to rstat flushers instead of cgroup ids. This is
  much more flexibility and less likely to need a uapi update later.
- rstat helpers are now only defined if CGROUP_CONFIG.
- Most of the code is now only defined if CGROUP_CONFIG and
  CONFIG_BPF_SYSCALL.
- Move rstat helper protos from bpf_base_func_proto() to
  tracing_prog_func_proto().
- rstat helpers argument (cgroup pointer) is now ARG_PTR_TO_BTF_ID, not
  ARG_ANYTHING.
- Rewrote the selftest to use the cgroup helpers.
- Dropped bpf_map_lookup_percpu_elem (already added by Feng).
- Dropped patch to support cgroup v1 for cgroup_iter.
- Dropped patch to define some cgroup_put() when !CONFIG_CGROUP. The
  code that calls it is no longer compiled when !CONFIG_CGROUP.

cgroup_iter was originally introduced in a different patch series[3].
Hao and I agreed that it fits better as part of this series.
RFC v1 of this patch series had the following changes from [3]:
- Getting the cgroup's reference at the time at attaching, instead of
  at the time when iterating. (Yonghong)
- Remove .init_seq_private and .fini_seq_private callbacks for
  cgroup_iter. They are not needed now. (Yonghong)

[1] https://lore.kernel.org/bpf/20220421140740.459558-5-benjamin.tissoires@redhat.com/
[2] https://lore.kernel.org/bpf/20220520221919.jnqgv52k4ajlgzcl@MBP-98dd607d3435.dhcp.thefacebook.com/
[3] https://lore.kernel.org/lkml/20220225234339.2386398-9-haoluo@google.com/
---

Benjamin Tissoires (1):
  btf: Add a new kfunc flag which allows to mark a function to be
    sleepable

Hao Luo (3):
  bpf, iter: Fix the condition on p when calling stop.
  bpf: Introduce cgroup iter
  selftests/bpf: Test cgroup_iter.

Yosry Ahmed (4):
  cgroup: enable cgroup_get_from_file() on cgroup1
  cgroup: bpf: enable bpf programs to integrate with rstat
  selftests/bpf: extend cgroup helpers
  bpf: add a selftest for cgroup hierarchical stats collection

 Documentation/bpf/kfuncs.rst                  |   6 +
 include/linux/bpf.h                           |   8 +
 include/linux/btf.h                           |   1 +
 include/uapi/linux/bpf.h                      |  30 ++
 kernel/bpf/Makefile                           |   3 +
 kernel/bpf/bpf_iter.c                         |   5 +
 kernel/bpf/btf.c                              |   9 +
 kernel/bpf/cgroup_iter.c                      | 252 ++++++++++++
 kernel/cgroup/cgroup.c                        |   5 -
 kernel/cgroup/rstat.c                         |  49 +++
 tools/include/uapi/linux/bpf.h                |  30 ++
 tools/testing/selftests/bpf/cgroup_helpers.c  | 201 ++++++++--
 tools/testing/selftests/bpf/cgroup_helpers.h  |  19 +-
 .../selftests/bpf/prog_tests/btf_dump.c       |   4 +-
 .../prog_tests/cgroup_hierarchical_stats.c    | 364 ++++++++++++++++++
 .../selftests/bpf/prog_tests/cgroup_iter.c    | 190 +++++++++
 tools/testing/selftests/bpf/progs/bpf_iter.h  |   7 +
 .../bpf/progs/cgroup_hierarchical_stats.c     | 239 ++++++++++++
 .../testing/selftests/bpf/progs/cgroup_iter.c |  39 ++
 19 files changed, 1407 insertions(+), 54 deletions(-)
 create mode 100644 kernel/bpf/cgroup_iter.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_iter.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_iter.c

-- 
2.37.1.359.gd136c6c3e2-goog

