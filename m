Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45C8022F845
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 20:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732473AbgG0Sri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 14:47:38 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31364 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731730AbgG0Spd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 14:45:33 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RIiO5O009882
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 11:45:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=fAC2PoUpmM+xSKKjgTzoyxsYTyy5FV/86iqAGeXZoJA=;
 b=nAqJgK+LWW9mppz2snn+S2AleHbgYKl9bSy/zj5yZi8aPrVrirvul2ANggOEquizCt+V
 bWrJ0STxPXT8Ib/0FXMh0akhsmZMCpTONQvMnr6lU+pjXUT6jByKGntNE95EKVdOtZiv
 1UrLf+CHbgLRmfEQCG+j7MjbcZW5TBinwpI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32gj8kga56-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 11:45:31 -0700
Received: from intmgw001.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 11:45:15 -0700
Received: by devvm1096.prn0.facebook.com (Postfix, from userid 111017)
        id 8A9B01DAFE71; Mon, 27 Jul 2020 11:45:10 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm1096.prn0.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>, Roman Gushchin <guro@fb.com>
Smtp-Origin-Cluster: prn0c01
Subject: [PATCH bpf-next v2 00/35] bpf: switch to memcg-based memory accounting
Date:   Mon, 27 Jul 2020 11:44:31 -0700
Message-ID: <20200727184506.2279656-1-guro@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_13:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0 suspectscore=13
 bulkscore=0 priorityscore=1501 clxscore=1015 phishscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007270127
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently bpf is using the memlock rlimit for the memory accounting.
This approach has its downsides and over time has created a significant
amount of problems:

1) The limit is per-user, but because most bpf operations are performed
   as root, the limit has a little value.

2) It's hard to come up with a specific maximum value. Especially because
   the counter is shared with non-bpf users (e.g. memlock() users).
   Any specific value is either too low and creates false failures
   or too high and useless.

3) Charging is not connected to the actual memory allocation. Bpf code
   should manually calculate the estimated cost and precharge the counter=
,
   and then take care of uncharging, including all fail paths.
   It adds to the code complexity and makes it easy to leak a charge.

4) There is no simple way of getting the current value of the counter.
   We've used drgn for it, but it's far from being convenient.

5) Cryptic -EPERM is returned on exceeding the limit. Libbpf even had
   a function to "explain" this case for users.

In order to overcome these problems let's switch to the memcg-based
memory accounting of bpf objects. With the recent addition of the percpu
memory accounting, now it's possible to provide a comprehensive accountin=
g
of memory used by bpf programs and maps.

This approach has the following advantages:
1) The limit is per-cgroup and hierarchical. It's way more flexible and a=
llows
   a better control over memory usage by different workloads.

2) The actual memory consumption is taken into account. It happens automa=
tically
   on the allocation time if __GFP_ACCOUNT flags is passed. Uncharging is=
 also
   performed automatically on releasing the memory. So the code on the bp=
f side
   becomes simpler and safer.

3) There is a simple way to get the current value and statistics.

The patchset consists of the following parts:
1) memcg-based accounting for various bpf objects: progs and maps
2) removal of the rlimit-based accounting
3) removal of rlimit adjustments in userspace tools and tests

v2:
  - fixed build issue, caused by the remaining rlimit-based accounting
    for sockhash maps


Roman Gushchin (35):
  bpf: memcg-based memory accounting for bpf progs
  bpf: memcg-based memory accounting for bpf maps
  bpf: refine memcg-based memory accounting for arraymap maps
  bpf: refine memcg-based memory accounting for cpumap maps
  bpf: memcg-based memory accounting for cgroup storage maps
  bpf: refine memcg-based memory accounting for devmap maps
  bpf: refine memcg-based memory accounting for hashtab maps
  bpf: memcg-based memory accounting for lpm_trie maps
  bpf: memcg-based memory accounting for bpf ringbuffer
  bpf: memcg-based memory accounting for socket storage maps
  bpf: refine memcg-based memory accounting for sockmap and sockhash
    maps
  bpf: refine memcg-based memory accounting for xskmap maps
  bpf: eliminate rlimit-based memory accounting for arraymap maps
  bpf: eliminate rlimit-based memory accounting for bpf_struct_ops maps
  bpf: eliminate rlimit-based memory accounting for cpumap maps
  bpf: eliminate rlimit-based memory accounting for cgroup storage maps
  bpf: eliminate rlimit-based memory accounting for devmap maps
  bpf: eliminate rlimit-based memory accounting for hashtab maps
  bpf: eliminate rlimit-based memory accounting for lpm_trie maps
  bpf: eliminate rlimit-based memory accounting for queue_stack_maps
    maps
  bpf: eliminate rlimit-based memory accounting for reuseport_array maps
  bpf: eliminate rlimit-based memory accounting for bpf ringbuffer
  bpf: eliminate rlimit-based memory accounting for sockmap and sockhash
    maps
  bpf: eliminate rlimit-based memory accounting for stackmap maps
  bpf: eliminate rlimit-based memory accounting for socket storage maps
  bpf: eliminate rlimit-based memory accounting for xskmap maps
  bpf: eliminate rlimit-based memory accounting infra for bpf maps
  bpf: eliminate rlimit-based memory accounting for bpf progs
  bpf: libbpf: cleanup RLIMIT_MEMLOCK usage
  bpf: bpftool: do not touch RLIMIT_MEMLOCK
  bpf: runqslower: don't touch RLIMIT_MEMLOCK
  bpf: selftests: delete bpf_rlimit.h
  bpf: selftests: don't touch RLIMIT_MEMLOCK
  bpf: samples: do not touch RLIMIT_MEMLOCK
  perf: don't touch RLIMIT_MEMLOCK

 include/linux/bpf.h                           |  23 ---
 kernel/bpf/arraymap.c                         |  30 +---
 kernel/bpf/bpf_struct_ops.c                   |  19 +--
 kernel/bpf/core.c                             |  20 +--
 kernel/bpf/cpumap.c                           |  20 +--
 kernel/bpf/devmap.c                           |  23 +--
 kernel/bpf/hashtab.c                          |  33 +---
 kernel/bpf/local_storage.c                    |  38 ++---
 kernel/bpf/lpm_trie.c                         |  17 +-
 kernel/bpf/queue_stack_maps.c                 |  16 +-
 kernel/bpf/reuseport_array.c                  |  12 +-
 kernel/bpf/ringbuf.c                          |  33 ++--
 kernel/bpf/stackmap.c                         |  16 +-
 kernel/bpf/syscall.c                          | 152 ++----------------
 net/core/bpf_sk_storage.c                     |  23 +--
 net/core/sock_map.c                           |  40 ++---
 net/xdp/xskmap.c                              |  13 +-
 samples/bpf/hbm.c                             |   1 -
 samples/bpf/map_perf_test_user.c              |  11 --
 samples/bpf/offwaketime_user.c                |   2 -
 samples/bpf/sockex2_user.c                    |   2 -
 samples/bpf/sockex3_user.c                    |   2 -
 samples/bpf/spintest_user.c                   |   2 -
 samples/bpf/syscall_tp_user.c                 |   2 -
 samples/bpf/task_fd_query_user.c              |   5 -
 samples/bpf/test_lru_dist.c                   |   3 -
 samples/bpf/test_map_in_map_user.c            |   9 --
 samples/bpf/test_overhead_user.c              |   2 -
 samples/bpf/trace_event_user.c                |   2 -
 samples/bpf/tracex2_user.c                    |   6 -
 samples/bpf/tracex3_user.c                    |   6 -
 samples/bpf/tracex4_user.c                    |   6 -
 samples/bpf/tracex5_user.c                    |   3 -
 samples/bpf/tracex6_user.c                    |   3 -
 samples/bpf/xdp1_user.c                       |   6 -
 samples/bpf/xdp_adjust_tail_user.c            |   6 -
 samples/bpf/xdp_monitor_user.c                |   6 -
 samples/bpf/xdp_redirect_cpu_user.c           |   6 -
 samples/bpf/xdp_redirect_map_user.c           |   6 -
 samples/bpf/xdp_redirect_user.c               |   6 -
 samples/bpf/xdp_router_ipv4_user.c            |   6 -
 samples/bpf/xdp_rxq_info_user.c               |   6 -
 samples/bpf/xdp_sample_pkts_user.c            |   6 -
 samples/bpf/xdp_tx_iptunnel_user.c            |   6 -
 samples/bpf/xdpsock_user.c                    |   7 -
 tools/bpf/bpftool/common.c                    |   7 -
 tools/bpf/bpftool/feature.c                   |   2 -
 tools/bpf/bpftool/main.h                      |   2 -
 tools/bpf/bpftool/map.c                       |   2 -
 tools/bpf/bpftool/pids.c                      |   1 -
 tools/bpf/bpftool/prog.c                      |   3 -
 tools/bpf/bpftool/struct_ops.c                |   2 -
 tools/bpf/runqslower/runqslower.c             |  16 --
 tools/lib/bpf/libbpf.c                        |  31 +---
 tools/lib/bpf/libbpf.h                        |   5 -
 tools/perf/builtin-trace.c                    |  10 --
 tools/perf/tests/builtin-test.c               |   6 -
 tools/perf/util/Build                         |   1 -
 tools/perf/util/rlimit.c                      |  29 ----
 tools/perf/util/rlimit.h                      |   6 -
 tools/testing/selftests/bpf/bench.c           |  16 --
 tools/testing/selftests/bpf/bpf_rlimit.h      |  28 ----
 .../selftests/bpf/flow_dissector_load.c       |   1 -
 .../selftests/bpf/get_cgroup_id_user.c        |   1 -
 .../bpf/prog_tests/select_reuseport.c         |   1 -
 .../selftests/bpf/prog_tests/sk_lookup.c      |   1 -
 .../selftests/bpf/progs/bpf_iter_bpf_map.c    |   5 +-
 .../selftests/bpf/progs/map_ptr_kern.c        |   5 -
 tools/testing/selftests/bpf/test_btf.c        |   1 -
 .../selftests/bpf/test_cgroup_storage.c       |   1 -
 tools/testing/selftests/bpf/test_dev_cgroup.c |   1 -
 tools/testing/selftests/bpf/test_lpm_map.c    |   1 -
 tools/testing/selftests/bpf/test_lru_map.c    |   1 -
 tools/testing/selftests/bpf/test_maps.c       |   1 -
 tools/testing/selftests/bpf/test_netcnt.c     |   1 -
 tools/testing/selftests/bpf/test_progs.c      |   1 -
 .../selftests/bpf/test_skb_cgroup_id_user.c   |   1 -
 tools/testing/selftests/bpf/test_sock.c       |   1 -
 tools/testing/selftests/bpf/test_sock_addr.c  |   1 -
 .../testing/selftests/bpf/test_sock_fields.c  |   1 -
 .../selftests/bpf/test_socket_cookie.c        |   1 -
 tools/testing/selftests/bpf/test_sockmap.c    |   1 -
 tools/testing/selftests/bpf/test_sysctl.c     |   1 -
 tools/testing/selftests/bpf/test_tag.c        |   1 -
 .../bpf/test_tcp_check_syncookie_user.c       |   1 -
 .../testing/selftests/bpf/test_tcpbpf_user.c  |   1 -
 .../selftests/bpf/test_tcpnotify_user.c       |   1 -
 tools/testing/selftests/bpf/test_verifier.c   |   1 -
 .../testing/selftests/bpf/test_verifier_log.c |   2 -
 tools/testing/selftests/bpf/xdping.c          |   6 -
 tools/testing/selftests/net/reuseport_bpf.c   |  20 ---
 91 files changed, 97 insertions(+), 794 deletions(-)
 delete mode 100644 tools/perf/util/rlimit.c
 delete mode 100644 tools/perf/util/rlimit.h
 delete mode 100644 tools/testing/selftests/bpf/bpf_rlimit.h

--=20
2.26.2

