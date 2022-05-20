Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38C2252E1CE
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 03:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344402AbiETBVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 21:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239345AbiETBVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 21:21:39 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808E227CC7
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 18:21:38 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id x4-20020a170902ec8400b0015f0c1ec803so3347899plg.15
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 18:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ysbiIUs5o2z/FDHftPdhza+ymeMilu85Me2zCte6Iv0=;
        b=RXxHWd/Y2k75L32XGdjIlD+Qco0V4mN2pXDBsLSot84ETRvW7QLrnjn12Egie/vtkO
         UyzP9yoAVnSTwdozqLuRPetCkzaknxUbUh/R5YU9r80HXFtDMtHmUCyJrfEOgjwyY9Zu
         yxpNQVABpbIXtuaBqaBfi/7WOUwjrkLQ58VvJMSHCjUvrSL3bQg0oLa1qk7hrYcUCnwV
         po5mgzouqPsmVAtbazRDZpYSpzhrOexeN8BcWodNhjxsmEbiznoM+pIdylPrKGtclNuz
         faxUrnWRmJK9EhT2j1XvnPDPjZRv7PAX2RjM4alvUCqx4o0Zq8xpwSL2LZtMUX4fzF9v
         WE5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ysbiIUs5o2z/FDHftPdhza+ymeMilu85Me2zCte6Iv0=;
        b=VAqnXUSIGun4kRxSHrDX4JxnQ7oMuilTy2pbCIa4LQmBENFNuZZ/KyEamP0zeUmxZ9
         VNxfTnhgV5V3l85iDRsAMV5elgVdEOGFauWo3KxpPHIgSrjhHSpQ7nuHOaKrTGbr/tpl
         q+0n67nM5StIQqCIX79IhfG5rbyUW+sYlgjzbAwj0C+2xgiA0+8obn+nXztorNd+lWow
         rqbcfwfD+q0hoadPcOyxGEIbtxvZIpZnNbmyuVXRLXGpIJcfJglpwpQNSu4Cg+VL0f+V
         8AdSDj07S7rk+DyDrthbXsNX00XzF2ZV8GLyyHDs3ceCsqfrUJFXOzxi9gVgikza54vH
         tmzw==
X-Gm-Message-State: AOAM533h1KAy/sUcahCTnvQEpPj/egPdOY3krw8NoZzmrUqREfxc742q
        4bfJ9Masex48kbFUtGo/CbgyveSXYz2J6ty0
X-Google-Smtp-Source: ABdhPJy/3YA5GyFnf3xfAhncHWKxi5JHgqVbNbBPrVqZD/tiLRzjn17hN6fXwqJOlaQ3SLErXdF3N9yZZaVoOk/j
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a63:2048:0:b0:3db:7de7:34b4 with SMTP
 id r8-20020a632048000000b003db7de734b4mr6387103pgm.105.1653009697865; Thu, 19
 May 2022 18:21:37 -0700 (PDT)
Date:   Fri, 20 May 2022 01:21:28 +0000
Message-Id: <20220520012133.1217211-1-yosryahmed@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH bpf-next v1 0/5] bpf: rstat: cgroup hierarchical stats
From:   Yosry Ahmed <yosryahmed@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>
Cc:     Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org,
        Yosry Ahmed <yosryahmed@google.com>
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
framework provides an efficient way to collect cgroup stats and
propagate them through the cgroup hierarchy.

* Background on rstat (I am using a subscriber analogy that is not
commonly used):

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

Patches in this series are based off two patches in the mailing list:
- bpf/btf: also allow kfunc in tracing and syscall programs
- btf: Add a new kfunc set which allows to mark a function to be
  sleepable

Both by Benjamin Tissoires, from different versions of his HID patch
series (the second patch seems to have been dropped in the last
version).

Patches in this series are organized as follows:
* The first patch adds a hook point, bpf_rstat_flush(), that is called
during rstat flushing. This allows bpf fentry programs to attach to it
to be called during rstat flushing (effectively registering themselves
as rstat flush callbacks).

* The second patch adds cgroup_rstat_updated() and cgorup_rstat_flush()
kfuncs, to allow bpf stat collectors and readers to communicate with rstat.

* The third patch is actually v2 of a previously submitted patch [1]
by Hao Luo. We agreed that it fits better as a part of this series. It
introduces cgroup_iter programs that can dump stats for cgroups to
userspace.
v1 - > v2:
- Getting the cgroup's reference at the time at attaching, instead of
  at the time when iterating. (Yonghong) (context [1])
- Remove .init_seq_private and .fini_seq_private callbacks for
  cgroup_iter. They are not needed now. (Yonghong)

* The fourth patch extends bpf selftests cgroup helpers, as necessary
for the following patch.

* The fifth  patch is a selftest that demonstrates the entire workflow.
It includes programs that collect, aggregate, and dump per-cgroup stats
by fully integrating with the rstat framework.

[1]https://lore.kernel.org/lkml/20220225234339.2386398-9-haoluo@google.com/

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


Hao Luo (1):
  bpf: Introduce cgroup iter

Yosry Ahmed (4):
  cgroup: bpf: add a hook for bpf progs to attach to rstat flushing
  cgroup: bpf: add cgroup_rstat_updated() and cgroup_rstat_flush()
    kfuncs
  selftests/bpf: extend cgroup helpers
  bpf: add a selftest for cgroup hierarchical stats collection

 include/linux/bpf.h                           |   2 +
 include/uapi/linux/bpf.h                      |   6 +
 kernel/bpf/Makefile                           |   3 +
 kernel/bpf/cgroup_iter.c                      | 148 ++++++++
 kernel/cgroup/rstat.c                         |  40 +++
 tools/include/uapi/linux/bpf.h                |   6 +
 tools/testing/selftests/bpf/cgroup_helpers.c  | 159 +++++---
 tools/testing/selftests/bpf/cgroup_helpers.h  |  14 +-
 .../test_cgroup_hierarchical_stats.c          | 339 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/bpf_iter.h  |   7 +
 .../selftests/bpf/progs/cgroup_vmscan.c       | 221 ++++++++++++
 11 files changed, 899 insertions(+), 46 deletions(-)
 create mode 100644 kernel/bpf/cgroup_iter.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_cgroup_hierarchical_stats.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_vmscan.c

-- 
2.36.1.124.g0e6072fb45-goog

