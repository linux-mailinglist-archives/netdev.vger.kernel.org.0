Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6BA1BAEF2
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 22:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgD0UMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 16:12:39 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51400 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725919AbgD0UMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 16:12:38 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03RKAj9B025684
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:12:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=ppiUiYcTNREpJMCXv9jCfRZetzLJRH4pmtu6ytKy4q8=;
 b=QNdrNq456wo+ey77058G5FAusGKBoP8ScpxKAQR7w0/2f+7BK9JrnbWYDCzykO8ngIVI
 KM4yvIEFiHD9c9pPIyZsHQKs92u6GsoDR/2xZ9URN1UrwNjgk8n9x9/yDa95yOeVPR6U
 M21nvehaz4oaTesqWu6i8z8hxA0Oj4dFGgw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30n515t6xj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:12:37 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 27 Apr 2020 13:12:36 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 3976D3700871; Mon, 27 Apr 2020 13:12:35 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v1 00/19] bpf: implement bpf iterator for kernel data
Date:   Mon, 27 Apr 2020 13:12:35 -0700
Message-ID: <20200427201235.2994549-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_15:2020-04-27,2020-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 malwarescore=0 impostorscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Motivation:
  The current way to dump kernel data structures mostly:
    1. /proc system
    2. various specific tools like "ss" which requires kernel support.
    3. drgn
  The dropback for the first two is that whenever you want to dump more, =
you
  need change the kernel. For example, Martin wants to dump socket local
  storage with "ss". Kernel change is needed for it to work ([1]).
  This is also the direct motivation for this work.

  drgn ([2]) solves this proble nicely and no kernel change is not needed=
.
  But since drgn is not able to verify the validity of a particular point=
er value,
  it might present the wrong results in rare cases.
 =20
  In this patch set, we introduce bpf iterator. Initial kernel changes ar=
e
  still needed for interested kernel data, but a later data structure cha=
nge
  will not require kernel changes any more. bpf program itself can adapt
  to new data structure changes. This will give certain flexibility with
  guaranteed correctness.
 =20
  In this patch set, kernel seq_ops is used to facilitate iterating throu=
gh
  kernel data, similar to current /proc and many other lossless kernel
  dumping facilities. In the future, different iterators can be
  implemented to trade off losslessness for other criteria e.g. no
  repeated object visits, etc.

User Interface:
  1. Similar to prog/map/link, the iterator can be pinned into a
     path within a bpffs mount point.
  2. The bpftool command can pin an iterator to a file
         bpftool iter pin <bpf_prog.o> <path>
  3. Use `cat <path>` to dump the contents.
     Use `rm -f <path>` to remove the pinned iterator.
  4. The anonymous iterator can be created as well.

  Please see patch #17 andd #18 for bpf programs and bpf iterator
  output examples.

  Note that certain iterators are namespace aware. For example,
  task and task_file targets only iterate through current pid namespace.
  ipv6_route and netlink will iterate through current net namespace.

  Please see individual patches for implementation details.

Performance:
  The bpf iterator provides in-kernel aggregation abilities
  for kernel data. This can greatly improve performance
  compared to e.g., iterating all process directories under /proc.
  For example, I did an experiment on my VM with an application forking
  different number of tasks and each forked process opening various numbe=
r
  of files. The following is the result with the latency with unit of mic=
roseconds:

    # of forked tasks   # of open files    # of bpf_prog calls  # latency=
 (us)
    100                 100                11503                7586
    1000                1000               1013203              709513
    10000               100                1130203              764519

  The number of bpf_prog calls may be more than forked tasks multipled by
  open files since there are other tasks running on the system.
  The bpf program is a do-nothing program. One millions of bpf calls take=
s
  less than one second.

Future Work:
  Although the initial motivation is from Martin's sk_local_storage,
  this patch didn't implement tcp6 sockets and sk_local_storage.
  The /proc/net/tcp6 involves three types of sockets, timewait,
  request and tcp6 sockets. Some kind of type casting or other
  mechanism is needed to handle all these socket types in one
  bpf program. This will be addressed in future work.

  Currently, we do not support kernel data generated under module.
  This requires some BTF work.

  More work for more iterators, e.g., bpf_progs, cgroups, bpf_map element=
s, etc.

Changelog:
  RFC v2 ([3]) -> non-RFC v1:
    - rename bpfdump to bpf_iter
    - use bpffs instead of a new file system
    - use bpf_link to streamline and simplify iterator creation.

References:
  [1]: https://lore.kernel.org/bpf/20200225230427.1976129-1-kafai@fb.com
  [2]: https://github.com/osandov/drgn
  [3]: https://lore.kernel.org/bpf/40e427e2-5b15-e9aa-e2cb-42dc1b53d047@g=
mail.com/T/

Yonghong Song (19):
  net: refactor net assignment for seq_net_private structure
  bpf: implement an interface to register bpf_iter targets
  bpf: add bpf_map iterator
  bpf: allow loading of a bpf_iter program
  bpf: support bpf tracing/iter programs for BPF_LINK_CREATE
  bpf: support bpf tracing/iter programs for BPF_LINK_UPDATE
  bpf: create anonymous bpf iterator
  bpf: create file bpf iterator
  bpf: add PTR_TO_BTF_ID_OR_NULL support
  bpf: add netlink and ipv6_route targets
  bpf: add task and task/file targets
  bpf: add bpf_seq_printf and bpf_seq_write helpers
  bpf: handle spilled PTR_TO_BTF_ID properly when checking
    stack_boundary
  bpf: support variable length array in tracing programs
  tools/libbpf: add bpf_iter support
  tools/bpftool: add bpf_iter support for bptool
  tools/bpf: selftests: add iterator programs for ipv6_route and netlink
  tools/bpf: selftests: add iter progs for bpf_map/task/task_file
  tools/bpf: selftests: add bpf_iter selftests

 fs/proc/proc_net.c                            |   5 +-
 include/linux/bpf.h                           |  33 ++
 include/linux/seq_file_net.h                  |   8 +
 include/uapi/linux/bpf.h                      |  38 +-
 kernel/bpf/Makefile                           |   2 +-
 kernel/bpf/bpf_iter.c                         | 358 ++++++++++++++++++
 kernel/bpf/btf.c                              |  38 +-
 kernel/bpf/inode.c                            |  28 ++
 kernel/bpf/map_iter.c                         | 107 ++++++
 kernel/bpf/syscall.c                          |  62 ++-
 kernel/bpf/task_iter.c                        | 319 ++++++++++++++++
 kernel/bpf/verifier.c                         |  47 ++-
 kernel/trace/bpf_trace.c                      | 159 ++++++++
 net/ipv6/ip6_fib.c                            |  71 +++-
 net/ipv6/route.c                              |  30 ++
 net/netlink/af_netlink.c                      |  99 ++++-
 scripts/bpf_helpers_doc.py                    |   2 +
 .../bpftool/Documentation/bpftool-iter.rst    |  71 ++++
 tools/bpf/bpftool/bash-completion/bpftool     |  13 +
 tools/bpf/bpftool/iter.c                      |  84 ++++
 tools/bpf/bpftool/main.c                      |   3 +-
 tools/bpf/bpftool/main.h                      |   1 +
 tools/include/uapi/linux/bpf.h                |  38 +-
 tools/lib/bpf/bpf.c                           |  11 +
 tools/lib/bpf/bpf.h                           |   2 +
 tools/lib/bpf/bpf_tracing.h                   |  23 ++
 tools/lib/bpf/libbpf.c                        |  60 +++
 tools/lib/bpf/libbpf.h                        |  11 +
 tools/lib/bpf/libbpf.map                      |   7 +
 .../selftests/bpf/prog_tests/bpf_iter.c       | 180 +++++++++
 .../selftests/bpf/progs/bpf_iter_bpf_map.c    |  32 ++
 .../selftests/bpf/progs/bpf_iter_ipv6_route.c |  69 ++++
 .../selftests/bpf/progs/bpf_iter_netlink.c    |  77 ++++
 .../selftests/bpf/progs/bpf_iter_task.c       |  29 ++
 .../selftests/bpf/progs/bpf_iter_task_file.c  |  28 ++
 .../selftests/bpf/progs/bpf_iter_test_kern1.c |   4 +
 .../selftests/bpf/progs/bpf_iter_test_kern2.c |   4 +
 .../selftests/bpf/progs/bpf_iter_test_kern3.c |  18 +
 .../bpf/progs/bpf_iter_test_kern_common.h     |  22 ++
 39 files changed, 2174 insertions(+), 19 deletions(-)
 create mode 100644 kernel/bpf/bpf_iter.c
 create mode 100644 kernel/bpf/map_iter.c
 create mode 100644 kernel/bpf/task_iter.c
 create mode 100644 tools/bpf/bpftool/Documentation/bpftool-iter.rst
 create mode 100644 tools/bpf/bpftool/iter.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_iter.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_bpf_map.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_ipv6_route=
.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_netlink.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_file.=
c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern1=
.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern2=
.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern3=
.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern_=
common.h

--=20
2.24.1

