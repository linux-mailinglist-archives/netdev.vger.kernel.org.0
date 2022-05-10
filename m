Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 905475209F0
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 02:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbiEJAWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 20:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbiEJAWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 20:22:13 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B5028AB84
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 17:18:17 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id b10-20020a170902bd4a00b0015e7ee90842so9015642plx.8
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 17:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=lnkTQgV2qrh+gbf1Aosc572kZFary2TCuRopidnSrV8=;
        b=d3LuCLf1mIYQIzpgHBzDoUhfEHYYUvqpEwKWTaFOdzLJDYWqm5AIYG8Tj/K5vteAik
         E9hQ+7NyOYyPX+waN8rITfqFYQRyrPwYocl7eA45c3urlEl27usL1NwHjkxP8BUt7Xhx
         6nAZgsYBz4wgmnl+O08B4FrW/92oLEm2VE+KGsjX+MQ+JjHzWte+h1lcPZ60gbP4/+nO
         6cgkK2W8754PZG/RAC7tmrYeJh+73GOqo1NfAP5OLX89RLBCsOLX8l2IwqmB+EHuu5h8
         Jt1Hf1OLhE4+AjFPxR+D8yCd5aZtG78LZIyZvaZDM0tPqWFVALIqmrIIkcsmvB4V5vBz
         JuOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=lnkTQgV2qrh+gbf1Aosc572kZFary2TCuRopidnSrV8=;
        b=V2P1GEERzTxftV35BVvJW2UyVSneKoFzo1d6O1jGJjkRuxzENdVCNjNa45kOP/2gKZ
         f+rKeNrvajgKfkyMcH3X0KCyJRzpVm7JdHnK+TQcNAVKVY1woOktW/AeYOzj8JhVieA+
         In5nWEEniAxLIRZ/1dqwTzKuVdCOJtDOOo7IqAdx2o0DEwzD3YZufICluTh333xPV9Lo
         4uFMEx3Ws9G2NjNAoH6DbX9VxkREXCjGYscTCPrif0yHBXwiJcFdWbr+gK9HFMPqN4aH
         2UMUYaecXfT+HhMvktX/SdQfyHedWq4onsCBD0FhW0jdKtS65rukeNeSU+mfvA/6l+z2
         g5LQ==
X-Gm-Message-State: AOAM533D9W7Qk0w2T6BUOzqG2smp8aUOkBIMVxlkLSV5uzj/WozYTpdL
        81VWBchLhpbsJpM7aixXf7cxeGl8HKd/oVIn
X-Google-Smtp-Source: ABdhPJwlRd2oDc7VlqrmSym6yiJH6uIZ5kWoeSe0XeAIWHiU8RTlTIUjQNGslcIlw9n4Cf0oExdUP/3WBSny7D1e
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a17:902:ecc7:b0:15e:8685:77d with SMTP
 id a7-20020a170902ecc700b0015e8685077dmr18756887plh.20.1652141896585; Mon, 09
 May 2022 17:18:16 -0700 (PDT)
Date:   Tue, 10 May 2022 00:17:58 +0000
Message-Id: <20220510001807.4132027-1-yosryahmed@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [RFC PATCH bpf-next 0/9] bpf: cgroup hierarchical stats collection
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series allows for using bpf to collect hierarchical cgroup
stats efficiently by integrating with the rstat framework. The rstat
framework provides an efficient way to collect cgroup stats and
propagate them through the cgroup hierarchy.

The last patch is a selftest that demonastrates the entire workflow.
The workflow consists of:
- bpf programs that collect per-cpu per-cgroup stats (tracing progs).
- bpf rstat flusher that contains the logic for aggregating stats
  across cpus and across the cgroup hierarchy.
- bpf cgroup_iter responsible for outputting the stats to userspace
  through reading a file in bpffs.

The first 3 patches include the new bpf rstat flusher program type and
the needed support in rstat code and libbpf. The rstat flusher program
is a callback that the rstat framework makes to bpf when a stat flush is
ongoing, similar to the css_rstat_flush() callback that rstat makes to
cgroup controllers. Each callback is parameterized by a (cgroup, cpu)
pair that has been updated. The program contains the logic for
aggregating the stats across cpus and across the cgroup hierarchy.
These programs can be attached to any cgroup subsystem, not only the
ones that implement the css_rstat_flush() callback in the kernel. This
gives bpf programs more flexibility, and more isolation from the kernel
implementation.

The following 2 patches add necessary helpers for the stats collection
workflow. Helpers that call into cgroup_rstat_updated() and
cgroup_rstat_flush() are added to allow bpf programs collecting stats to
tell the rstat framework that a cgroup has been updated, and to allow
bpf programs outputting stats to tell the rstat framework to flush the
stats before they are displayed to the user. An additional
bpf_map_lookup_percpu_elem is introduced to allow rstat flusher programs
to access percpu stats of the cpu being flushed.

The following 3 patches add the cgroup_iter program type (v2). This was
originally introduced by Hao as a part of a different series [1].
Their usecase is better showcased as part of this patch series. We also
make cgroup_get_from_id() cgroup v1 friendly to allow cgroup_iter programs
to display stats for cgroup v1 as well. This small change makes the
entire workflow cgroup v1 friendly without any other dedicated changes.

The final patch is a selftest demonstrating the entire workflow with a
set of bpf programs that collect per-cgroup latency of memcg reclaim.

[1]https://lore.kernel.org/lkml/20220225234339.2386398-9-haoluo@google.com/


Hao Luo (2):
  cgroup: Add cgroup_put() in !CONFIG_CGROUPS case
  bpf: Introduce cgroup iter

Yosry Ahmed (7):
  bpf: introduce CGROUP_SUBSYS_RSTAT program type
  cgroup: bpf: flush bpf stats on rstat flush
  libbpf: Add support for rstat progs and links
  bpf: add bpf rstat helpers
  bpf: add bpf_map_lookup_percpu_elem() helper
  cgroup: add v1 support to cgroup_get_from_id()
  bpf: add a selftest for cgroup hierarchical stats collection

 include/linux/bpf-cgroup-subsys.h             |  35 ++
 include/linux/bpf.h                           |   4 +
 include/linux/bpf_types.h                     |   2 +
 include/linux/cgroup-defs.h                   |   4 +
 include/linux/cgroup.h                        |   5 +
 include/uapi/linux/bpf.h                      |  45 +++
 kernel/bpf/Makefile                           |   3 +-
 kernel/bpf/arraymap.c                         |  11 +-
 kernel/bpf/cgroup_iter.c                      | 148 ++++++++
 kernel/bpf/cgroup_subsys.c                    | 212 +++++++++++
 kernel/bpf/hashtab.c                          |  25 +-
 kernel/bpf/helpers.c                          |  56 +++
 kernel/bpf/syscall.c                          |   6 +
 kernel/bpf/verifier.c                         |   6 +
 kernel/cgroup/cgroup.c                        |  16 +-
 kernel/cgroup/rstat.c                         |  11 +
 scripts/bpf_doc.py                            |   2 +
 tools/include/uapi/linux/bpf.h                |  45 +++
 tools/lib/bpf/bpf.c                           |   3 +
 tools/lib/bpf/bpf.h                           |   3 +
 tools/lib/bpf/libbpf.c                        |  35 ++
 tools/lib/bpf/libbpf.h                        |   3 +
 tools/lib/bpf/libbpf.map                      |   1 +
 .../test_cgroup_hierarchical_stats.c          | 335 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/bpf_iter.h  |   7 +
 .../selftests/bpf/progs/cgroup_vmscan.c       | 211 +++++++++++
 26 files changed, 1212 insertions(+), 22 deletions(-)
 create mode 100644 include/linux/bpf-cgroup-subsys.h
 create mode 100644 kernel/bpf/cgroup_iter.c
 create mode 100644 kernel/bpf/cgroup_subsys.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_cgroup_hierarchical_stats.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_vmscan.c

-- 
2.36.0.512.ge40c2bad7a-goog

