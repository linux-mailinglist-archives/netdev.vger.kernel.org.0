Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA2E1A2C91
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 01:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgDHXtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 19:49:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35780 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726508AbgDHXtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 19:49:14 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 038NjDh5018870
        for <netdev@vger.kernel.org>; Wed, 8 Apr 2020 16:49:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=T+Xxnu6mDv2V43pUkjv1kG/eBz8L03T/l++6MNAe3BA=;
 b=ZQuBH5XqluxipwfGb3GsMzBu4b9mvdOuXfBnmFnyDdKeZXZ3D+oDeY1d6odKhSEsOvY4
 1SlzG2FaELCpRD6PQFb0VzXoZqZTce45wmZHl8DWOS+rDrWPeFplE4OGs19uNTf9Ka4D
 VPMvpPLc4/hkbyA6hsfwJAyTogt3kKrzb1I= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3091kvqp5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Apr 2020 16:49:13 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 8 Apr 2020 16:49:12 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 1FCED3700D98; Wed,  8 Apr 2020 16:25:20 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 00/16] bpf: implement bpf based dumping of kernel data structures
Date:   Wed, 8 Apr 2020 16:25:20 -0700
Message-ID: <20200408232520.2675265-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-08_09:2020-04-07,2020-04-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 malwarescore=0 priorityscore=1501 phishscore=0 suspectscore=0 adultscore=0
 spamscore=0 mlxscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080167
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

  In this patch set, we introduce bpf based dumping. Initial kernel chang=
es are
  still needed, but a data structure change will not require kernel chang=
es
  any more. bpf program itself is used to adapt to new data structure
  changes. This will give certain flexibility with guaranteed correctness=
.

  Here, kernel seq_ops is used to facilitate dumping, similar to current
  /proc and many other lossless kernel dumping facilities.

User Interfaces:
  1. A new mount file system, bpfdump at /sys/kernel/bpfdump is introduce=
d.
     Different from /sys/fs/bpf, this is a single user mount. Mount comma=
nd
     can be:
        mount -t bpfdump bpfdump /sys/kernel/bpfdump
  2. Kernel bpf dumpable data structures are represented as directories
     under /sys/kernel/bpfdump, e.g.,
       /sys/kernel/bpfdump/ipv6_route/
       /sys/kernel/bpfdump/netlink/
       /sys/kernel/bpfdump/bpf_map/
       /sys/kernel/bpfdump/task/
       /sys/kernel/bpfdump/task/file/
     In this patch set, we use "target" to represent a particular bpf
     supported data structure, for example, targets "ipv6_route",
     "netlink", "bpf_map", "task", "task/file", which are actual
     directory hierarchy relative to /sys/kernel/bpfdump/.

     Note that nested structures are supported for sub fields in a major
     data structure. For example, target "task/file" is to examine all op=
en
     files for all tasks (task_struct->files) as reference count and
     locks are needed to access task_struct->files safely.
  3. The bpftool command can be used to create a dumper:
       bpftool dumper pin <bpf_prog.o> <dumper_name>
     where the bpf_prog.o encodes the target information. For example, th=
e
     following dumpers can be created:
       /sys/kernel/bpfdump/ipv6_route/{my1, my2}
       /sys/kernel/bpfdump/task/file/{f1, f2}
  4. Use "cat <dumper>" to dump the contents.
     Use "rm -f <dumper>" to delete the dumper.
  5. An anonymous dumper can be created without pinning to a
     physical file. The fd will return to the application and
     the application can then "read" the contents.

Please see patch #14 and #15 for bpf programs and
bpf dumper output examples.

Two new helpers bpf_seq_printf() and bpf_seq_write() are introduced.
bpf_seq_printf() mostly for file based dumpers and bpf_seq_write()
mostly for anonymous dumpers.

Note that certain dumpers are namespace aware. For example,
task and task/... targets only iterate through current pid namespace.
ipv6_route and netlink will iterate through current net namespace.

For introspection, see patch #13,
  bpftool dumper show {target|dumper}
can show all targets and their function prototypes (for writing bpf
programs), or all dumpers with their associated bpf prog_id.
For any open file descriptors (anonymous or from dumper file),
  cat /proc/<pid>/fdinfo/<fd>
will show target and its associated prog_id as well.

In current implementation, the userspace codes in libbpf and bpftool
are really rough. My implement for seq_ops operations for bpf_map,
task and task/file needs more expert scrutiny. I haven't really
thought about dumper file permission control, etc.

Although the initial motivation is from Martin's sk_local_storage,
this patch didn't implement tcp6 sockets and sk_local_storage.
The /proc/net/tcp6 involves three types of sockets, timewait,
request and tcp6 sockets. Some kind of type casting is needed
to convert socket_common to these three types of sockets based
on socket state. This will be addressed in future work.

Submit this as a RFC to get some comments as the implementation
is not complete.

References:
  [1]: https://lore.kernel.org/bpf/20200225230427.1976129-1-kafai@fb.com
  [2]: https://github.com/osandov/drgn

Yonghong Song (16):
  net: refactor net assignment for seq_net_private structure
  bpf: create /sys/kernel/bpfdump mount file system
  bpf: provide a way for targets to register themselves
  bpf: allow loading of a dumper program
  bpf: create file or anonymous dumpers
  bpf: add netlink and ipv6_route targets
  bpf: add bpf_map target
  bpf: add task and task/file targets
  bpf: add bpf_seq_printf and bpf_seq_write helpers
  bpf: support variable length array in tracing programs
  bpf: implement query for target_proto and file dumper prog_id
  tools/libbpf: libbpf support for bpfdump
  tools/bpftool: add bpf dumper support
  tools/bpf: selftests: add dumper programs for ipv6_route and netlink
  tools/bpf: selftests: add dumper progs for bpf_map/task/task_file
  tools/bpf: selftests: add a selftest for anonymous dumper

 fs/proc/proc_net.c                            |   5 +-
 include/linux/bpf.h                           |  13 +
 include/linux/seq_file_net.h                  |   8 +
 include/uapi/linux/bpf.h                      |  38 +-
 include/uapi/linux/magic.h                    |   1 +
 kernel/bpf/Makefile                           |   1 +
 kernel/bpf/btf.c                              |  25 +
 kernel/bpf/dump.c                             | 707 ++++++++++++++++++
 kernel/bpf/dump_task.c                        | 294 ++++++++
 kernel/bpf/syscall.c                          | 137 +++-
 kernel/bpf/verifier.c                         |  15 +
 kernel/trace/bpf_trace.c                      | 172 +++++
 net/ipv6/ip6_fib.c                            |  41 +-
 net/ipv6/route.c                              |  22 +
 net/netlink/af_netlink.c                      |  54 +-
 scripts/bpf_helpers_doc.py                    |   2 +
 tools/bpf/bpftool/dumper.c                    | 131 ++++
 tools/bpf/bpftool/main.c                      |   3 +-
 tools/bpf/bpftool/main.h                      |   1 +
 tools/include/uapi/linux/bpf.h                |  38 +-
 tools/lib/bpf/bpf.c                           |  33 +
 tools/lib/bpf/bpf.h                           |   5 +
 tools/lib/bpf/libbpf.c                        |  48 +-
 tools/lib/bpf/libbpf.h                        |   1 +
 tools/lib/bpf/libbpf.map                      |   3 +
 .../selftests/bpf/prog_tests/bpfdump_test.c   |  41 +
 .../selftests/bpf/progs/bpfdump_bpf_map.c     |  24 +
 .../selftests/bpf/progs/bpfdump_ipv6_route.c  |  63 ++
 .../selftests/bpf/progs/bpfdump_netlink.c     |  74 ++
 .../selftests/bpf/progs/bpfdump_task.c        |  21 +
 .../selftests/bpf/progs/bpfdump_task_file.c   |  24 +
 .../selftests/bpf/progs/bpfdump_test_kern.c   |  26 +
 32 files changed, 2055 insertions(+), 16 deletions(-)
 create mode 100644 kernel/bpf/dump.c
 create mode 100644 kernel/bpf/dump_task.c
 create mode 100644 tools/bpf/bpftool/dumper.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpfdump_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpfdump_bpf_map.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpfdump_ipv6_route.=
c
 create mode 100644 tools/testing/selftests/bpf/progs/bpfdump_netlink.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpfdump_task.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpfdump_task_file.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpfdump_test_kern.c

--=20
2.24.1

