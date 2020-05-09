Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D823F1CC36B
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 19:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgEIR7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 13:59:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31442 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728162AbgEIR7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 13:59:10 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 049HsvfG007973
        for <netdev@vger.kernel.org>; Sat, 9 May 2020 10:59:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=aJhYXlqOvssUvhwGph4oSOsIcpmGJlCskjk2FUx4g1Y=;
 b=Du2O0hhdjU5ehxamM5FM7314Qh/7YoSIiQxB0M2Bv0Ygnifs4roOtPOqoHCEjAJvq8GV
 hzpk/u7Tou3+thF+l+2a4KffxhvxrPr7Hn0Cxak97hj2ncH904U45/8l7Kfach/GT4ky
 NskoguK2Iq/bUtycgY6aIKRJLhPT9an9anI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30wsca1h87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 09 May 2020 10:59:08 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sat, 9 May 2020 10:59:07 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 0FD6437008E2; Sat,  9 May 2020 10:58:59 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v4 00/21] bpf: implement bpf iterator for kernel data
Date:   Sat, 9 May 2020 10:58:59 -0700
Message-ID: <20200509175859.2474608-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-09_06:2020-05-08,2020-05-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090155
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

  In this patch set, we introduce bpf iterator. Initial kernel changes ar=
e
  still needed for interested kernel data, but a later data structure cha=
nge
  will not require kernel changes any more. bpf program itself can adapt
  to new data structure changes. This will give certain flexibility with
  guaranteed correctness.

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

  Please see patch #19 andd #20 for bpf programs and bpf iterator
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

  Although the initial motivation is from Martin's sk_local_storage,
  this patch didn't implement tcp6 sockets and sk_local_storage.
  The /proc/net/tcp6 involves three types of sockets, timewait,
  request and tcp6 sockets. Some kind of type casting or other
  mechanism is needed to handle all these socket types in one
  bpf program. This will be addressed in future work.

  Currently, we do not support kernel data generated under module.
  This requires some BTF work.

  More work for more iterators, e.g., tcp, udp, bpf_map elements, etc.

Changelog:
  v3 -> v4:
    - in bpf_seq_read(), if start() failed with an error, return that
      error to user space (Andrii)
    - in bpf_seq_printf(), if reading kernel memory failed for
      %s and %p{i,I}{4,6}, set buffer to empty string or address 0.
      Documented this behavior in uapi header (Andrii)
    - fix a few error handling issues for bpftool (Andrii)
    - A few other minor fixes and cosmetic changes.
  v2 -> v3:
    - add bpf_iter_unreg_target() to unregister a target, used in the
      error path of the __init functions.
    - handle err !=3D 0 before handling overflow (Andrii)
    - reference count "task" for task_file target (Andrii)
    - remove some redundancy for bpf_map/task/task_file targets
    - add bpf_iter_unreg_target() in ip6_route_cleanup()
    - Handling "%%" format in bpf_seq_printf() (Andrii)
    - implement auto-attach for bpf_iter in libbpf (Andrii)
    - add macros offsetof and container_of in bpf_helpers.h (Andrii)
    - add tests for auto-attach and program-return-1 cases
    - some other minor fixes
  v1 -> v2:
    - removed target_feature, using callback functions instead
    - checking target to ensure program specified btf_id supported (Marti=
n)
    - link_create change with new changes from Andrii
    - better handling of btf_iter vs. seq_file private data (Martin, Andr=
ii)
    - implemented bpf_seq_read() (Andrii, Alexei)
    - percpu buffer for bpf_seq_printf() (Andrii)
    - better syntax for BPF_SEQ_PRINTF macro (Andrii)
    - bpftool fixes (Quentin)
    - a lot of other fixes
  RFC v2 -> v1:
    - rename bpfdump to bpf_iter
    - use bpffs instead of a new file system
    - use bpf_link to streamline and simplify iterator creation.

References:
  [1]: https://lore.kernel.org/bpf/20200225230427.1976129-1-kafai@fb.com
  [2]: https://github.com/osandov/drgn

Yonghong Song (21):
  bpf: implement an interface to register bpf_iter targets
  bpf: allow loading of a bpf_iter program
  bpf: support bpf tracing/iter programs for BPF_LINK_CREATE
  bpf: support bpf tracing/iter programs for BPF_LINK_UPDATE
  bpf: implement bpf_seq_read() for bpf iterator
  bpf: create anonymous bpf iterator
  bpf: create file bpf iterator
  bpf: implement common macros/helpers for target iterators
  bpf: add bpf_map iterator
  net: bpf: add netlink and ipv6_route bpf_iter targets
  bpf: add task and task/file iterator targets
  bpf: add PTR_TO_BTF_ID_OR_NULL support
  bpf: add bpf_seq_printf and bpf_seq_write helpers
  bpf: handle spilled PTR_TO_BTF_ID properly when checking
    stack_boundary
  bpf: support variable length array in tracing programs
  tools/libbpf: add bpf_iter support
  tools/libpf: add offsetof/container_of macro in bpf_helpers.h
  tools/bpftool: add bpf_iter support for bptool
  tools/bpf: selftests: add iterator programs for ipv6_route and netlink
  tools/bpf: selftests: add iter progs for bpf_map/task/task_file
  tools/bpf: selftests: add bpf_iter selftests

 fs/proc/proc_net.c                            |  19 +
 include/linux/bpf.h                           |  36 ++
 include/linux/bpf_types.h                     |   1 +
 include/linux/proc_fs.h                       |   3 +
 include/uapi/linux/bpf.h                      |  47 +-
 kernel/bpf/Makefile                           |   2 +-
 kernel/bpf/bpf_iter.c                         | 530 ++++++++++++++++++
 kernel/bpf/btf.c                              |  42 +-
 kernel/bpf/inode.c                            |   5 +-
 kernel/bpf/map_iter.c                         |  97 ++++
 kernel/bpf/syscall.c                          |  59 ++
 kernel/bpf/task_iter.c                        | 333 +++++++++++
 kernel/bpf/verifier.c                         |  42 +-
 kernel/trace/bpf_trace.c                      | 214 +++++++
 net/ipv6/ip6_fib.c                            |  65 ++-
 net/ipv6/route.c                              |  37 ++
 net/netlink/af_netlink.c                      |  87 ++-
 scripts/bpf_helpers_doc.py                    |   2 +
 .../bpftool/Documentation/bpftool-iter.rst    |  83 +++
 tools/bpf/bpftool/bash-completion/bpftool     |  13 +
 tools/bpf/bpftool/iter.c                      |  88 +++
 tools/bpf/bpftool/link.c                      |   1 +
 tools/bpf/bpftool/main.c                      |   3 +-
 tools/bpf/bpftool/main.h                      |   1 +
 tools/include/uapi/linux/bpf.h                |  47 +-
 tools/lib/bpf/bpf.c                           |  10 +
 tools/lib/bpf/bpf.h                           |   2 +
 tools/lib/bpf/bpf_helpers.h                   |  14 +
 tools/lib/bpf/bpf_tracing.h                   |  16 +
 tools/lib/bpf/libbpf.c                        |  52 ++
 tools/lib/bpf/libbpf.h                        |   9 +
 tools/lib/bpf/libbpf.map                      |   2 +
 .../selftests/bpf/prog_tests/bpf_iter.c       | 409 ++++++++++++++
 .../selftests/bpf/progs/bpf_iter_bpf_map.c    |  28 +
 .../selftests/bpf/progs/bpf_iter_ipv6_route.c |  62 ++
 .../selftests/bpf/progs/bpf_iter_netlink.c    |  66 +++
 .../selftests/bpf/progs/bpf_iter_task.c       |  25 +
 .../selftests/bpf/progs/bpf_iter_task_file.c  |  26 +
 .../selftests/bpf/progs/bpf_iter_test_kern1.c |   4 +
 .../selftests/bpf/progs/bpf_iter_test_kern2.c |   4 +
 .../selftests/bpf/progs/bpf_iter_test_kern3.c |  18 +
 .../selftests/bpf/progs/bpf_iter_test_kern4.c |  52 ++
 .../bpf/progs/bpf_iter_test_kern_common.h     |  22 +
 43 files changed, 2664 insertions(+), 14 deletions(-)
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
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern4=
.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern_=
common.h

--=20
2.24.1

