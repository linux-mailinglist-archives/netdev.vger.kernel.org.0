Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F326759163B
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 22:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233735AbiHLU2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 16:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232487AbiHLU2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 16:28:08 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D99A1D59
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 13:28:06 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3230031a80fso15721087b3.5
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 13:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=y7zyZQpyvwcyrgKQBb7tjr8haOvA6ugjNFKM7h72Cu0=;
        b=VRTWj8gcht5FdlW2h03vk6MO0i/KKxVvSc+OhyeQUvNmJATUkS3Zo4C3LALOS70zUH
         +0FHI/IfeBuTVuU7GXnsA3J9XpPwsdqh1iS1aqE94dK38AEC+E2TKWFEiyallg5k97Ig
         AUp2N9cC/qAaIKMQ0x5C5wcAQtGwxfWt5AS+EFoNNUZUJDthc1QuQxzysJ5v4cI2lAM6
         SiQVPx6QJKF9y+tQ5r9TQ1qz0EscJiZ5Wrbz3Q1k0oGfXqtDNnlx7ymDJmXDR6UfBvch
         Juu0QKLeWDfFAJZ2mKG4PHYXfSOV/X6n4z45a7Vn6IayOHgqSzteyYQ2yhoZy7ZlCmS4
         6Wcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=y7zyZQpyvwcyrgKQBb7tjr8haOvA6ugjNFKM7h72Cu0=;
        b=WluBihKZprm3KCBpbMKHv3sNBZ+49jpI7yxcPl1oXETGejq3DFzqPm+Ipy3Tl8UkvQ
         1syW9IFh+EQ08KnTLzN+OQ3lkQFagZAcIlq5t22+xVKGllmLIBWS2SQvAv1M/zkXhA8u
         9NdmgiqDrPNk4eMLUgTXGQr0oPdWF2QpBVzwUQz2Gx7pGeGsHVaTiBzD8GoXclmRmhUe
         ZTRU/cectU+fNO11GSAfY/EL2fhSqOhoVfYk+4y5FB9X8YStYCx87i67fCk0Ma9HIAHy
         NQql3kF9SxnkfNeuMxLs8VoMXNE95XoX1Vn4KfO8Z9gDAnj0Yqg00DbVYIPp9Ku+tjy9
         KD9w==
X-Gm-Message-State: ACgBeo1Redj8uMl8VwVauBZuhx4HZUomGvBcSs9KjTagvvAk8GB8fa9D
        NtwGVbryOTeHMfNi/NhLXLJX+9oT+Js=
X-Google-Smtp-Source: AA6agR6M2bGeyiIwnjT76vuGf9CRnKkoBAbsu9gZGIuR37Vazxim7ayx9Qvx7ti2V1+kSuWbL7zWU9B2d+A=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2d4:203:da3d:b609:da67:694a])
 (user=haoluo job=sendgmr) by 2002:a0d:d70c:0:b0:31f:5bbc:de13 with SMTP id
 z12-20020a0dd70c000000b0031f5bbcde13mr5240628ywd.397.1660336085648; Fri, 12
 Aug 2022 13:28:05 -0700 (PDT)
Date:   Fri, 12 Aug 2022 13:27:57 -0700
Message-Id: <20220812202802.3774257-1-haoluo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH bpf-next v8 0/5] bpf: rstat: cgroup hierarchical stats
From:   Hao Luo <haoluo@google.com>
To:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        KP Singh <kpsingh@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Michal Koutny <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Yosry Ahmed <yosryahmed@google.com>,
        Hao Luo <haoluo@google.com>
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

This patch series allows for using bpf to collect hierarchical cgroup
stats efficiently by integrating with the rstat framework. The rstat
framework provides an efficient way to collect cgroup stats percpu and
propagate them through the cgroup hierarchy.

The stats are exposed to userspace in textual form by reading files in
bpffs, similar to cgroupfs stats by using a cgroup_iter program.
cgroup_iter is a type of bpf_iter. It walks over cgroups in four modes:
- walking a cgroup's descendants in pre-order.
- walking a cgroup's descendants in post-order.
- walking a cgroup's ancestors.
- process only a single object.

When attaching cgroup_iter, one needs to set a cgroup to the iter_link
created from attaching. This cgroup can be passed either as a file
descriptor or a cgroup id. That cgroup serves as the starting point of
the walk.

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

Patches in this series are organized as follows:
* Patches 1-2 introduce cgroup_iter prog, and a selftest.
* Patches 3-5 allow bpf programs to integrate with rstat by adding the
  necessary hook points and kfunc. A comprehensive selftest that
  demonstrates the entire workflow for using bpf and rstat to
  efficiently collect and output cgroup stats is added.

---
Changelog:
v7 -> v8:
- Removed the confusing BPF_ITER_DEFAULT (Andrii)
- s/SELF/SELF_ONLY/g
- Fixed typo (e.g. outputing) (Andrii)
- Use "descendants_pre", "descendants_post" etc. instead of "pre",
  "post" (Andrii)

v6 -> v7:
- Updated commit/comments in cgroup_iter for read() behavior (Yonghong)
- Extracted BPF_ITER_SELF and other options out of cgroup_iter, so
  that they can be used in other iters. Also renamed them. (Andrii)
- Supports both cgroup_fd and cgroup_id when specifying target cgroup.
  (Andrii)
- Avoided using macro for formatting expected output in cgroup_iter
  selftest. (Andrii)
- Applied 'static' on all vars and functions in cgroup_iter selftest.
  (Andrii)
- Fixed broken buf reading in cgroup_iter selftest. (Andrii)
- Switched to use bpf_link__destroy() unconditionally. (Andrii)
- Removed 'volatile' for non-const global vars in selftests. (Andrii)
- Started using bpf_core_enum_value() to get memory_cgrp_id. (Andrii)

v5 -> v6:
- Rebased on bpf-next
- Tidy up cgroup_hierarchical_stats test (Andrii)
  * 'static' and 'inline'
  * avoid using libbpf_get_error()
  * string literals of cgroup paths.
- Rename patch 8/8 to 'selftests/bpf' (Yonghong)
- Fix cgroup_iter comments (e.g. PAGE_SIZE and uapi) (Yonghong)
- Make sure further read() returns OK after previous read() finished
  properly (Yonghong)
- Release cgroup_mutex before the last call of show() (Kumar)

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
- Redesign of cgroup_iter from v1, based on Alexei's idea [1]:
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

cgroup_iter was originally introduced in a different patch series[2].
Hao and I agreed that it fits better as part of this series.
RFC v1 of this patch series had the following changes from [2]:
- Getting the cgroup's reference at the time at attaching, instead of
  at the time when iterating. (Yonghong)
- Remove .init_seq_private and .fini_seq_private callbacks for
  cgroup_iter. They are not needed now. (Yonghong)

[1] https://lore.kernel.org/bpf/20220520221919.jnqgv52k4ajlgzcl@MBP-98dd607d3435.dhcp.thefacebook.com/
[2] https://lore.kernel.org/lkml/20220225234339.2386398-9-haoluo@google.com/

Hao Luo (2):
  bpf: Introduce cgroup iter
  selftests/bpf: Test cgroup_iter.

Yosry Ahmed (3):
  cgroup: bpf: enable bpf programs to integrate with rstat
  selftests/bpf: extend cgroup helpers
  selftests/bpf: add a selftest for cgroup hierarchical stats collection

 include/linux/bpf.h                           |   8 +
 include/uapi/linux/bpf.h                      |  35 ++
 kernel/bpf/Makefile                           |   3 +
 kernel/bpf/cgroup_iter.c                      | 283 ++++++++++++++
 kernel/cgroup/rstat.c                         |  48 +++
 tools/include/uapi/linux/bpf.h                |  35 ++
 tools/testing/selftests/bpf/cgroup_helpers.c  | 202 ++++++++--
 tools/testing/selftests/bpf/cgroup_helpers.h  |  19 +-
 .../selftests/bpf/prog_tests/btf_dump.c       |   4 +-
 .../prog_tests/cgroup_hierarchical_stats.c    | 358 ++++++++++++++++++
 .../selftests/bpf/prog_tests/cgroup_iter.c    | 224 +++++++++++
 tools/testing/selftests/bpf/progs/bpf_iter.h  |   7 +
 .../bpf/progs/cgroup_hierarchical_stats.c     | 226 +++++++++++
 .../testing/selftests/bpf/progs/cgroup_iter.c |  39 ++
 14 files changed, 1442 insertions(+), 49 deletions(-)
 create mode 100644 kernel/bpf/cgroup_iter.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_iter.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_iter.c

-- 
2.37.1.595.g718a3a8f04-goog

