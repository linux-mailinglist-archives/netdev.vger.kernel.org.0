Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04BC59F191
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 05:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbiHXDBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 23:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232283AbiHXDBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 23:01:05 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524F075FEA
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 20:01:01 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-335cf0fd1a4so269828207b3.11
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 20:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=TNkjS55mmiuG/nNXXT7otwsDWdGujIUmSBLJns9oXwg=;
        b=tA8Sf9Ie5b+pkFAzHOlqT7QohdArBPRbuQ8x0j4fU7aj60aBKyu76d/vCvF1xUcArh
         6aEF5gCuBrnvbAyyWjMyBp96Ce07a9eN5j3hgY8I5yjkiG9u5LAGmqZEv2jAnR3VKVy1
         9HcN9HlYv/9V5pF7HBsIW/XKUrlo22OvDRP6bINOilrLBr2DDfSbryVLBl1UauCgBUql
         lkrBiG7MzGmaIivAoGH+bwfyfPXUinoaUIEM/yEgsBsMWUh/7H0cz88BuHBPQGsK3bpw
         qwdR7dMgZTuPu6T94pNoS3a58kTSd28t+WS5FKcQzIps3UX/GNRjuHnen4dGl01z/Pyh
         y6SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=TNkjS55mmiuG/nNXXT7otwsDWdGujIUmSBLJns9oXwg=;
        b=QoT7XcTVtnHR5xAUAGmTDAdb6HXr04FmOqbQh1zXF6rxY7YzpXTjE2DD3fD4mX8R/+
         bLNyBKMKHu09+K6sxHfB2u+83xZ/ng5uVn6IM2KXcL2hKdskejmRqB+mDZQ/czhzIj4r
         S8dGKxaWK5TAkJeRgpBl9fQATjvRnirXeZhgtPnJsY69UV5GacyIeO6TZ61oK3bljFgf
         xBvTb6ImsPnaRQ9Q9QOmo7/sO8b/IU6HdwqldNdoFHte6jpdhl7ClUT+OqMYDTWhWkTt
         Y1gDJ+R66cd542A6aJ3ykrS+9fRh55z9XyCIwMgq2Y1BDhuT5NA4/ctiDANoVwWY+3Es
         RzyQ==
X-Gm-Message-State: ACgBeo3DA+MWVAmdKpbiWnztg8RNVw/l9ff1T4oJmWraH3AVoe3b0CYd
        af7CMgSG+1lm0sZSR+nYlvgRjU/sDuo=
X-Google-Smtp-Source: AA6agR5AUiXj8JYAB0kctJ+HMX+bP08cz1YVxcCtP4KmvHiZKdRCw3SjukDO4/Fg41Ox9CDQSm2fGfzAm08=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2d4:203:87e3:473b:a297:1247])
 (user=haoluo job=sendgmr) by 2002:a25:415:0:b0:696:814:7c77 with SMTP id
 21-20020a250415000000b0069608147c77mr3814993ybe.36.1661310060518; Tue, 23 Aug
 2022 20:01:00 -0700 (PDT)
Date:   Tue, 23 Aug 2022 20:00:26 -0700
Message-Id: <20220824030031.1013441-1-haoluo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH bpf-next v9 0/5] bpf: rstat: cgroup hierarchical stats
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
        Jiri Olsa <jolsa@kernel.org>, Michal Koutny <mkoutny@suse.com>,
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
        autolearn=ham autolearn_force=no version=3.4.6
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
v8 -> v9:
- Make UNSPEC (an invalid option) as the default order for cgroup_iter.
- Use enum for specifying cgroup_iter order, instead of u32.
- Add BPF_ITER_RESHCED to cgroup_iter.

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
 include/uapi/linux/bpf.h                      |  30 ++
 kernel/bpf/Makefile                           |   3 +
 kernel/bpf/cgroup_iter.c                      | 284 ++++++++++++++
 kernel/cgroup/rstat.c                         |  48 +++
 tools/include/uapi/linux/bpf.h                |  30 ++
 tools/testing/selftests/bpf/cgroup_helpers.c  | 202 ++++++++--
 tools/testing/selftests/bpf/cgroup_helpers.h  |  19 +-
 .../selftests/bpf/prog_tests/btf_dump.c       |   4 +-
 .../prog_tests/cgroup_hierarchical_stats.c    | 357 ++++++++++++++++++
 .../selftests/bpf/prog_tests/cgroup_iter.c    | 224 +++++++++++
 tools/testing/selftests/bpf/progs/bpf_iter.h  |   7 +
 .../bpf/progs/cgroup_hierarchical_stats.c     | 226 +++++++++++
 .../testing/selftests/bpf/progs/cgroup_iter.c |  39 ++
 14 files changed, 1432 insertions(+), 49 deletions(-)
 create mode 100644 kernel/bpf/cgroup_iter.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_iter.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_iter.c

-- 
2.37.1.595.g718a3a8f04-goog

