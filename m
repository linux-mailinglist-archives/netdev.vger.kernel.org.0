Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53EF338D213
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 01:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbhEUXnu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 21 May 2021 19:43:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60882 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230114AbhEUXns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 19:43:48 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14LNfVUR023175
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 16:42:24 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 38p4yt5qh4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 16:42:24 -0700
Received: from intmgw002.06.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 16:42:22 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 475222EDB019; Fri, 21 May 2021 16:42:05 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 0/5] libbpf: error reporting changes for v1.0
Date:   Fri, 21 May 2021 16:42:03 -0700
Message-ID: <20210521234203.1283033-1-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: lRJDW8_3zl2px-rIv6x8S629G24xf495
X-Proofpoint-GUID: lRJDW8_3zl2px-rIv6x8S629G24xf495
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-21_11:2021-05-20,2021-05-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=804
 bulkscore=0 spamscore=0 suspectscore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 phishscore=0
 priorityscore=1501 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2105210136
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement error reporting changes discussed in "Libbpf: the road to v1.0"
([0]) document.

Libbpf gets a new API, libbpf_set_strict_mode() which accepts a set of flags
that turn on a set of libbpf 1.0 changes, that might be potentially breaking.
It's possible to opt-in into all current and future 1.0 features by specifying
LIBBPF_STRICT_ALL flag.

When some of the 1.0 "features" are requested, libbpf APIs might behave
differently. In this patch set a first set of changes are implemented, all
related to the way libbpf returns errors. See individual patches for details.

Patch #1 adds a no-op libbpf_set_strict_mode() functionality to enable
updating selftests.

Patch #2 gets rid of all the bad code patterns that will break in libbpf 1.0
(exact -1 comparison for low-level APIs, direct IS_ERR() macro usage to check
pointer-returning APIs for error, etc). These changes make selftest work in
both legacy and 1.0 libbpf modes. Selftests also opt-in into 100% libbpf 1.0
mode to automatically gain all the subsequent changes, which will come in
follow up patches.

Patch #3 streamlines error reporting for low-level APIs wrapping bpf() syscall.

Patch #4 streamlines errors for all the rest APIs.

Patch #5 ensures that BPF skeletons propagate errors properly as well, as
currently on error some APIs will return NULL with no way of checking exact
error code.

  [0] https://docs.google.com/document/d/1UyjTZuPFWiPFyKk1tV5an11_iaRuec6U-ZESZ54nNTY

Andrii Nakryiko (5):
  libbpf: add libbpf_set_strict_mode() API to turn on libbpf 1.0
    behaviors
  selftests/bpf: turn on libbpf 1.0 mode and fix all IS_ERR checks
  libbpf: streamline error reporting for low-level APIs
  libbpf: streamline error reporting for high-level APIs
  bpftool: set errno on skeleton failures and propagate errors

 tools/bpf/bpftool/gen.c                       |  27 +-
 tools/lib/bpf/Makefile                        |   1 +
 tools/lib/bpf/bpf.c                           | 168 ++++--
 tools/lib/bpf/bpf_prog_linfo.c                |  18 +-
 tools/lib/bpf/btf.c                           | 302 +++++-----
 tools/lib/bpf/btf_dump.c                      |  14 +-
 tools/lib/bpf/libbpf.c                        | 519 ++++++++++--------
 tools/lib/bpf/libbpf.h                        |   1 +
 tools/lib/bpf/libbpf.map                      |   5 +
 tools/lib/bpf/libbpf_errno.c                  |   7 +-
 tools/lib/bpf/libbpf_internal.h               |  53 ++
 tools/lib/bpf/libbpf_legacy.h                 |  59 ++
 tools/lib/bpf/linker.c                        |  22 +-
 tools/lib/bpf/netlink.c                       |  81 +--
 tools/lib/bpf/ringbuf.c                       |  26 +-
 tools/testing/selftests/bpf/bench.c           |   1 +
 .../selftests/bpf/benchs/bench_rename.c       |   2 +-
 .../selftests/bpf/benchs/bench_ringbufs.c     |   6 +-
 .../selftests/bpf/benchs/bench_trigger.c      |   2 +-
 .../selftests/bpf/prog_tests/attach_probe.c   |  12 +-
 .../selftests/bpf/prog_tests/bpf_iter.c       |  31 +-
 .../selftests/bpf/prog_tests/bpf_tcp_ca.c     |   8 +-
 tools/testing/selftests/bpf/prog_tests/btf.c  |  93 ++--
 .../selftests/bpf/prog_tests/btf_dump.c       |   8 +-
 .../selftests/bpf/prog_tests/btf_write.c      |   4 +-
 .../bpf/prog_tests/cg_storage_multi.c         |  84 +--
 .../bpf/prog_tests/cgroup_attach_multi.c      |   2 +-
 .../selftests/bpf/prog_tests/cgroup_link.c    |  14 +-
 .../bpf/prog_tests/cgroup_skb_sk_lookup.c     |   2 +-
 .../selftests/bpf/prog_tests/check_mtu.c      |   2 +-
 .../selftests/bpf/prog_tests/core_reloc.c     |  15 +-
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  |  25 +-
 .../selftests/bpf/prog_tests/flow_dissector.c |   2 +-
 .../bpf/prog_tests/flow_dissector_reattach.c  |  10 +-
 .../bpf/prog_tests/get_stack_raw_tp.c         |  10 +-
 .../prog_tests/get_stackid_cannot_attach.c    |   9 +-
 .../selftests/bpf/prog_tests/hashmap.c        |   9 +-
 .../selftests/bpf/prog_tests/kfree_skb.c      |  19 +-
 .../selftests/bpf/prog_tests/ksyms_btf.c      |   3 +-
 .../selftests/bpf/prog_tests/link_pinning.c   |   7 +-
 .../selftests/bpf/prog_tests/obj_name.c       |   8 +-
 .../selftests/bpf/prog_tests/perf_branches.c  |   4 +-
 .../selftests/bpf/prog_tests/perf_buffer.c    |   2 +-
 .../bpf/prog_tests/perf_event_stackmap.c      |   3 +-
 .../selftests/bpf/prog_tests/probe_user.c     |   7 +-
 .../selftests/bpf/prog_tests/prog_run_xattr.c |   4 +-
 .../bpf/prog_tests/raw_tp_test_run.c          |   4 +-
 .../selftests/bpf/prog_tests/rdonly_maps.c    |   7 +-
 .../bpf/prog_tests/reference_tracking.c       |   2 +-
 .../selftests/bpf/prog_tests/resolve_btfids.c |   2 +-
 .../selftests/bpf/prog_tests/ringbuf_multi.c  |   2 +-
 .../bpf/prog_tests/select_reuseport.c         |  53 +-
 .../selftests/bpf/prog_tests/send_signal.c    |   3 +-
 .../selftests/bpf/prog_tests/sk_lookup.c      |   2 +-
 .../selftests/bpf/prog_tests/sock_fields.c    |  14 +-
 .../selftests/bpf/prog_tests/sockmap_basic.c  |   8 +-
 .../selftests/bpf/prog_tests/sockmap_ktls.c   |   2 +-
 .../selftests/bpf/prog_tests/sockmap_listen.c |  10 +-
 .../bpf/prog_tests/stacktrace_build_id_nmi.c  |   3 +-
 .../selftests/bpf/prog_tests/stacktrace_map.c |   2 +-
 .../bpf/prog_tests/stacktrace_map_raw_tp.c    |   5 +-
 .../bpf/prog_tests/tcp_hdr_options.c          |  15 +-
 .../selftests/bpf/prog_tests/test_overhead.c  |  12 +-
 .../bpf/prog_tests/trampoline_count.c         |  14 +-
 .../selftests/bpf/prog_tests/udp_limit.c      |   7 +-
 .../selftests/bpf/prog_tests/xdp_bpf2bpf.c    |   2 +-
 .../selftests/bpf/prog_tests/xdp_link.c       |   8 +-
 tools/testing/selftests/bpf/test_maps.c       | 168 +++---
 tools/testing/selftests/bpf/test_progs.c      |   3 +
 tools/testing/selftests/bpf/test_progs.h      |   9 +-
 .../selftests/bpf/test_tcpnotify_user.c       |   7 +-
 71 files changed, 1123 insertions(+), 952 deletions(-)
 create mode 100644 tools/lib/bpf/libbpf_legacy.h

-- 
2.30.2

