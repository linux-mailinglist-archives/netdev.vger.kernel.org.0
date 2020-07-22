Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9B2D229F8C
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 20:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732531AbgGVStx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 14:49:53 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27478 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732437AbgGVStv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 14:49:51 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 06MIZK6O026689
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 11:49:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=Wor6D2PKm8jkdJMCv/vXQDEMt2aEmQY5kQy4f8tqXJI=;
 b=DNQ9KAVCwcfYhHPcBNyf9Lp9GzL/ubdwJGG6kEmOnp/s/HnixI9JKFEGWRm49fkC1M/h
 GSJwH657nIcGdPHrg4pDj1TWhfkluQ0hyGmlUESV4ombwpWSyrzFx/k5s48acLA4NpN0
 hcZ65OpFPG3kO+ZeXrDxvLO2L0uTgEK81ik= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 32esdjgm7j-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 11:49:50 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 22 Jul 2020 11:49:47 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id BDCA73702F09; Wed, 22 Jul 2020 11:49:45 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v2 00/13] bpf: implement bpf iterator for map elements
Date:   Wed, 22 Jul 2020 11:49:45 -0700
Message-ID: <20200722184945.3777103-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_10:2020-07-22,2020-07-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 clxscore=1015
 malwarescore=0 spamscore=0 adultscore=0 impostorscore=0 phishscore=0
 suspectscore=8 bulkscore=0 priorityscore=1501 mlxlogscore=447
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007220119
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bpf iterator has been implemented for task, task_file,
bpf_map, ipv6_route, netlink, tcp and udp so far.

For map elements, there are two ways to traverse all elements from
user space:
  1. using BPF_MAP_GET_NEXT_KEY bpf subcommand to get elements
     one by one.
  2. using BPF_MAP_LOOKUP_BATCH bpf subcommand to get a batch of
     elements.
Both these approaches need to copy data from kernel to user space
in order to do inspection.

This patch implements bpf iterator for map elements.
User can have a bpf program in kernel to run with each map element,
do checking, filtering, aggregation, modifying values etc.
without copying data to user space.

Patch #1 and #2 are refactoring. Patch #3 implements readonly/readwrite
buffer support in verifier. Patches #4 - #7 implements map element
support for hash, percpu hash, lru hash lru percpu hash, array,
percpu array and sock local storage maps. Patches #8 - #9 are libbpf
and bpftool support. Patches #10 - #13 are selftests for implemented
map element iterators.

Changelogs:
  v1 -> v2:
    . support to modify map element values. (Alexei)
    . map key/values can be used with helper arguments
      for those arguments with ARG_PTR_TO_MEM or
      ARG_PTR_TO_INIT_MEM register type. (Alexei)
    . remove usused variable. (kernel test robot)

Yonghong Song (13):
  bpf: refactor bpf_iter_reg to have separate seq_info member
  bpf: refactor to provide aux info to bpf_iter_init_seq_priv_t
  bpf: support readonly/readwrite buffers in verifier
  bpf: implement bpf iterator for map elements
  bpf: implement bpf iterator for hash maps
  bpf: implement bpf iterator for array maps
  bpf: implement bpf iterator for sock local storage map
  tools/libbpf: add support for bpf map element iterator
  tools/bpftool: add bpftool support for bpf map element iterator
  selftests/bpf: add test for bpf hash map iterators
  selftests/bpf: add test for bpf array map iterators
  selftests/bpf: add a test for bpf sk_storage_map iterator
  selftests/bpf: add a test for out of bound rdonly buf access

 fs/proc/proc_net.c                            |   2 +-
 include/linux/bpf.h                           |  42 +-
 include/linux/proc_fs.h                       |   3 +-
 include/uapi/linux/bpf.h                      |   7 +
 kernel/bpf/arraymap.c                         | 138 ++++++
 kernel/bpf/bpf_iter.c                         |  89 +++-
 kernel/bpf/btf.c                              |  13 +
 kernel/bpf/hashtab.c                          | 194 ++++++++
 kernel/bpf/map_iter.c                         |  62 ++-
 kernel/bpf/task_iter.c                        |  18 +-
 kernel/bpf/verifier.c                         |  91 +++-
 net/core/bpf_sk_storage.c                     | 206 ++++++++
 net/ipv4/tcp_ipv4.c                           |  12 +-
 net/ipv4/udp.c                                |  12 +-
 net/ipv6/route.c                              |   8 +-
 net/netlink/af_netlink.c                      |   8 +-
 .../bpftool/Documentation/bpftool-iter.rst    |  18 +-
 tools/bpf/bpftool/bash-completion/bpftool     |  18 +-
 tools/bpf/bpftool/iter.c                      |  33 +-
 tools/include/uapi/linux/bpf.h                |   7 +
 tools/lib/bpf/bpf.c                           |   1 +
 tools/lib/bpf/bpf.h                           |   3 +-
 tools/lib/bpf/libbpf.c                        |  10 +-
 tools/lib/bpf/libbpf.h                        |   3 +-
 .../selftests/bpf/prog_tests/bpf_iter.c       | 442 ++++++++++++++++++
 .../bpf/progs/bpf_iter_bpf_array_map.c        |  40 ++
 .../bpf/progs/bpf_iter_bpf_hash_map.c         | 100 ++++
 .../bpf/progs/bpf_iter_bpf_percpu_array_map.c |  46 ++
 .../bpf/progs/bpf_iter_bpf_percpu_hash_map.c  |  50 ++
 .../bpf/progs/bpf_iter_bpf_sk_storage_map.c   |  34 ++
 .../selftests/bpf/progs/bpf_iter_test_kern5.c |  35 ++
 31 files changed, 1682 insertions(+), 63 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_bpf_array_=
map.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_bpf_hash_m=
ap.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_bpf_percpu=
_array_map.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_bpf_percpu=
_hash_map.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_sto=
rage_map.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern5=
.c

--=20
2.24.1

