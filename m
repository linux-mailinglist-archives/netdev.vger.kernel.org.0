Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6EFE233AC8
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 23:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731011AbgG3VZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 17:25:56 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17250 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730672AbgG3VXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 17:23:20 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06ULEoGB026397
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 14:23:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=uM/CbB3u61KGIKkgXn+bc2q9njFLIQF3TmkjbVBY+fA=;
 b=GqZgB7xckcTNRBBL7SLDrtc/+/HhSddgNsF8l2YxfNe14ATjfX77PGI6eAozZ7Doqhlp
 pQiSDHqOGUYb2Ce/gj8LcagbYTHenDg/w0mFHERQV+qCbndBnw7ABPTW7aNRzXwVR8g1
 Iyeu9+bnMgS9cF3MtriF12wQmfyYfCHGQcM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32jp0uvkb9-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 14:23:18 -0700
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 30 Jul 2020 14:23:16 -0700
Received: by devvm1096.prn0.facebook.com (Postfix, from userid 111017)
        id 92CA920B009A; Thu, 30 Jul 2020 14:23:12 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm1096.prn0.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>, Roman Gushchin <guro@fb.com>
Smtp-Origin-Cluster: prn0c01
Subject: [PATCH bpf-next v3 00/29] bpf: switch to memcg-based memory accounting
Date:   Thu, 30 Jul 2020 14:22:41 -0700
Message-ID: <20200730212310.2609108-1-guro@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-30_15:2020-07-30,2020-07-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxscore=0 phishscore=0 priorityscore=1501 suspectscore=13 malwarescore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 impostorscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007300150
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
3) removal of rlimit adjustments in userspace samples

v3:
  - droped the userspace part for further discussions/refinements,
    by Andrii and Song
v2:
  - fixed build issue, caused by the remaining rlimit-based accounting
    for sockhash maps


Roman Gushchin (29):
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
  bpf: samples: do not touch RLIMIT_MEMLOCK

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
 .../selftests/bpf/progs/map_ptr_kern.c        |   5 -
 45 files changed, 94 insertions(+), 572 deletions(-)

--=20
2.26.2

