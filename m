Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607F02CAFAC
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 23:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404349AbgLAWCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 17:02:54 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42596 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387426AbgLAV7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 16:59:52 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0B1LrWbE006961
        for <netdev@vger.kernel.org>; Tue, 1 Dec 2020 13:59:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=ULqUM7c+Oil9akqzPThs+PS8DBwWwj0EJmAQn0ZO/Xc=;
 b=qTg1IgkHJNMPAyjDqkH+UV9Y1F7KkgVtjhjhGoOWQ6s9kKY3gSHml8ojOz59yf7IvB5/
 /rT5FssG/xF4IDcPGLQjzFOfXmuULYYo8KpxxuAmhE67oSXesVkGvhJ5Lxl8IrDMYUh4
 BdF67dx+gsQ9ywy/IFwK/vCCGvY+C6Dk1ic= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 354g9unrp3-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 13:59:09 -0800
Received: from intmgw001.06.prn3.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Dec 2020 13:59:09 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 3AD17197029E; Tue,  1 Dec 2020 13:59:06 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v9 00/34] bpf: switch to memcg-based memory accounting
Date:   Tue, 1 Dec 2020 13:58:26 -0800
Message-ID: <20201201215900.3569844-1-guro@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_11:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 suspectscore=38 clxscore=1015 impostorscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012010131
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently bpf is using the memlock rlimit for the memory accounting.
This approach has its downsides and over time has created a significant
amount of problems:

1) The limit is per-user, but because most bpf operations are performed
   as root, the limit has a little value.

2) It's hard to come up with a specific maximum value. Especially because
   the counter is shared with non-bpf use cases (e.g. memlock()).
   Any specific value is either too low and creates false failures
   or is too high and useless.

3) Charging is not connected to the actual memory allocation. Bpf code
   should manually calculate the estimated cost and charge the counter,
   and then take care of uncharging, including all fail paths.
   It adds to the code complexity and makes it easy to leak a charge.

4) There is no simple way of getting the current value of the counter.
   We've used drgn for it, but it's far from being convenient.

5) Cryptic -EPERM is returned on exceeding the limit. Libbpf even had
   a function to "explain" this case for users.

6) rlimits are generally considered as (at least partially) obsolete.
   They do not provide a comprehensive system for the control of physical
   resources: memory, cpu, io etc. All resource control developments
   in the recent years were related to cgroups.

In order to overcome these problems let's switch to the memory cgroup-bas=
ed
memory accounting of bpf objects. With the recent addition of the percpu
memory accounting, now it's possible to provide a comprehensive accountin=
g
of the memory used by bpf programs and maps.

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

Cgroup-based accounting adds new requirements:
1) The kernel config should have CONFIG_CGROUPS and CONFIG_MEMCG_KMEM ena=
bled.
   These options are usually enabled, maybe excluding tiny builds for emb=
edded
   devices.
2) The system should have a configured cgroup hierarchy, including reason=
able
   memory limits and/or guarantees. Modern systems usually delegate this =
task
   to systemd or similar task managers.

Without meeting these requirements there are no limits on how much memory=
 bpf
can use and a non-root user is able to hurt the system by allocating too =
much.
But because per-user rlimits do not provide a functional system to protec=
t
and manage physical resources anyway, anyone who seriously depends on it,
should use cgroups.

When a bpf map is created, the memory cgroup of the process which creates
the map is recorded. Subsequently all memory allocation related to the bp=
f map
are charged to the same cgroup. It includes allocations made from interru=
pts
and by any processes. Bpf program memory is charged to the memory cgroup =
of
a process which loads the program.

The patchset consists of the following parts:
1) 4 mm patches are required on the mm side, otherwise vmallocs cannot be=
 mapped
   to userspace
2) memcg-based accounting for various bpf objects: progs and maps
3) removal of the rlimit-based accounting
4) removal of rlimit adjustments in userspace samples


v9:
  - always charge the saved memory cgroup, by Daniel, Toke and Alexei
  - added bpf_map_kzalloc()
  - rebase and minor fixes

v8:
  - extended the cover letter to be more clear on new requirements, by Da=
niel
  - an approximate value is provided by map memlock info, by Alexei

v7:
  - introduced bpf_map_kmalloc_node() and bpf_map_alloc_percpu(), by Alex=
ei
  - switched allocations made from an interrupt context to new helpers,
    by Daniel
  - rebase and minor fixes

v6:
  - rebased to the latest version of the remote charging API
  - fixed signatures, added acks

v5:
  - rebased to the latest version of the remote charging API
  - implemented kmem accounting from an interrupt context, by Shakeel
  - rebased to latest changes in mm allowed to map vmallocs to userspace
  - fixed a build issue in kselftests, by Alexei
  - fixed a use-after-free bug in bpf_map_free_deferred()
  - added bpf line info coverage, by Shakeel
  - split bpf map charging preparations into a separate patch

v4:
  - covered allocations made from an interrupt context, by Daniel
  - added some clarifications to the cover letter

v3:
  - droped the userspace part for further discussions/refinements,
    by Andrii and Song

v2:
  - fixed build issue, caused by the remaining rlimit-based accounting
    for sockhash maps


Roman Gushchin (34):
  mm: memcontrol: use helpers to read page's memcg data
  mm: memcontrol/slab: use helpers to access slab page's memcg_data
  mm: introduce page memcg flags
  mm: convert page kmemcg type to a page memcg flag
  bpf: memcg-based memory accounting for bpf progs
  bpf: prepare for memcg-based memory accounting for bpf maps
  bpf: memcg-based memory accounting for bpf maps
  bpf: refine memcg-based memory accounting for arraymap maps
  bpf: refine memcg-based memory accounting for cpumap maps
  bpf: memcg-based memory accounting for cgroup storage maps
  bpf: refine memcg-based memory accounting for devmap maps
  bpf: refine memcg-based memory accounting for hashtab maps
  bpf: memcg-based memory accounting for lpm_trie maps
  bpf: memcg-based memory accounting for bpf ringbuffer
  bpf: memcg-based memory accounting for bpf local storage maps
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
  bpf: eliminate rlimit-based memory accounting for xskmap maps
  bpf: eliminate rlimit-based memory accounting for bpf local storage
    maps
  bpf: eliminate rlimit-based memory accounting infra for bpf maps
  bpf: eliminate rlimit-based memory accounting for bpf progs
  bpf: samples: do not touch RLIMIT_MEMLOCK

 fs/buffer.c                                   |   2 +-
 fs/iomap/buffered-io.c                        |   2 +-
 include/linux/bpf.h                           |  57 +++--
 include/linux/memcontrol.h                    | 215 +++++++++++++++-
 include/linux/mm.h                            |  22 --
 include/linux/mm_types.h                      |   5 +-
 include/linux/page-flags.h                    |  11 +-
 include/trace/events/writeback.h              |   2 +-
 kernel/bpf/arraymap.c                         |  30 +--
 kernel/bpf/bpf_local_storage.c                |  20 +-
 kernel/bpf/bpf_struct_ops.c                   |  19 +-
 kernel/bpf/core.c                             |  22 +-
 kernel/bpf/cpumap.c                           |  37 +--
 kernel/bpf/devmap.c                           |  25 +-
 kernel/bpf/hashtab.c                          |  43 ++--
 kernel/bpf/local_storage.c                    |  44 +---
 kernel/bpf/lpm_trie.c                         |  19 +-
 kernel/bpf/queue_stack_maps.c                 |  16 +-
 kernel/bpf/reuseport_array.c                  |  12 +-
 kernel/bpf/ringbuf.c                          |  35 +--
 kernel/bpf/stackmap.c                         |  16 +-
 kernel/bpf/syscall.c                          | 234 +++++++-----------
 kernel/fork.c                                 |   7 +-
 mm/debug.c                                    |   4 +-
 mm/huge_memory.c                              |   4 +-
 mm/memcontrol.c                               | 139 +++++------
 mm/page_alloc.c                               |   8 +-
 mm/page_io.c                                  |   6 +-
 mm/slab.h                                     |  38 +--
 mm/workingset.c                               |   2 +-
 net/core/sock_map.c                           |  42 +---
 net/xdp/xskmap.c                              |  15 +-
 samples/bpf/map_perf_test_user.c              |   6 -
 samples/bpf/offwaketime_user.c                |   6 -
 samples/bpf/sockex2_user.c                    |   2 -
 samples/bpf/sockex3_user.c                    |   2 -
 samples/bpf/spintest_user.c                   |   6 -
 samples/bpf/syscall_tp_user.c                 |   2 -
 samples/bpf/task_fd_query_user.c              |   6 -
 samples/bpf/test_lru_dist.c                   |   3 -
 samples/bpf/test_map_in_map_user.c            |   6 -
 samples/bpf/test_overhead_user.c              |   2 -
 samples/bpf/trace_event_user.c                |   2 -
 samples/bpf/tracex2_user.c                    |   6 -
 samples/bpf/tracex3_user.c                    |   6 -
 samples/bpf/tracex4_user.c                    |   6 -
 samples/bpf/tracex5_user.c                    |   3 -
 samples/bpf/tracex6_user.c                    |   3 -
 samples/bpf/xdp1_user.c                       |   6 -
 samples/bpf/xdp_adjust_tail_user.c            |   6 -
 samples/bpf/xdp_monitor_user.c                |   5 -
 samples/bpf/xdp_redirect_cpu_user.c           |   6 -
 samples/bpf/xdp_redirect_map_user.c           |   6 -
 samples/bpf/xdp_redirect_user.c               |   6 -
 samples/bpf/xdp_router_ipv4_user.c            |   6 -
 samples/bpf/xdp_rxq_info_user.c               |   6 -
 samples/bpf/xdp_sample_pkts_user.c            |   6 -
 samples/bpf/xdp_tx_iptunnel_user.c            |   6 -
 samples/bpf/xdpsock_user.c                    |   7 -
 .../selftests/bpf/progs/bpf_iter_bpf_map.c    |   2 +-
 .../selftests/bpf/progs/map_ptr_kern.c        |   7 -
 61 files changed, 533 insertions(+), 762 deletions(-)

--=20
2.26.2

