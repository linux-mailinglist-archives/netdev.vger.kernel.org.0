Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B042D11EF4A
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 01:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbfLNArm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 19:47:42 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60524 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726735AbfLNArl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 19:47:41 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBE0UUFk009094
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 16:47:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=PdoHcF1sSefnzJKV/8VlDU0q8PiPGoEX50uiRJLmqSo=;
 b=bnJLgH6syALZnbXsLau4QEkC9oMPybEEB6EiH5aQi7bslVFHlD4Fx1BSRLvV8EYlsljX
 vLhzMYXarlcp4/yCsNKRCTuARfu8olLibvKQtJpQuvWnrureHvXSnXCGYLWtA8DF6SLB
 5p/PezT2wU0u6Jhq/UB1u5jKxmgM83kiyao= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wvkm20g0k-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 16:47:40 -0800
Received: from intmgw001.05.ash5.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Dec 2019 16:47:38 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 7E5372943AB4; Fri, 13 Dec 2019 16:47:37 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 00/13] Introduce BPF STRUCT_OPS
Date:   Fri, 13 Dec 2019 16:47:37 -0800
Message-ID: <20191214004737.1652076-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_09:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=306 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 clxscore=1015 suspectscore=13 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912140001
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduces BPF STRUCT_OPS.  It is an infra to allow
implementing some specific kernel's function pointers in BPF.
The first use case included in this series is to implement
TCP congestion control algorithm in BPF  (i.e. implement
struct tcp_congestion_ops in BPF).

There has been attempt to move the TCP CC to the user space
(e.g. CCP in TCP).   The common arguments are faster turn around,
get away from long-tail kernel versions in production...etc,
which are legit points.

BPF has been the continuous effort to join both kernel and
userspace upsides together (e.g. XDP to gain the performance
advantage without bypassing the kernel).  The recent BPF
advancements (in particular BTF-aware verifier, BPF trampoline,
BPF CO-RE...) made implementing kernel struct ops (e.g. tcp cc)
possible in BPF.

The idea is to allow implementing tcp_congestion_ops in bpf.
It allows a faster turnaround for testing algorithm in the
production while leveraging the existing (and continue growing) BPF
feature/framework instead of building one specifically for
userspace TCP CC.

Please see individual patch for details.

The bpftool support will be posted in follow-up patches.

Martin KaFai Lau (13):
  bpf: Save PTR_TO_BTF_ID register state when spilling to stack
  bpf: Avoid storing modifier to info->btf_id
  bpf: Add enum support to btf_ctx_access()
  bpf: Support bitfield read access in btf_struct_access
  bpf: Introduce BPF_PROG_TYPE_STRUCT_OPS
  bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS
  bpf: tcp: Support tcp_congestion_ops in bpf
  bpf: Add BPF_FUNC_tcp_send_ack helper
  bpf: Add BPF_FUNC_jiffies
  bpf: Synch uapi bpf.h to tools/
  bpf: libbpf: Add STRUCT_OPS support
  bpf: Add bpf_dctcp example
  bpf: Add bpf_cubic example

 arch/x86/net/bpf_jit_comp.c                   |  10 +-
 include/linux/bpf.h                           |  80 ++-
 include/linux/bpf_types.h                     |   7 +
 include/linux/btf.h                           |  45 ++
 include/linux/filter.h                        |   2 +
 include/net/tcp.h                             |   1 +
 include/uapi/linux/bpf.h                      |  33 +-
 kernel/bpf/Makefile                           |   2 +-
 kernel/bpf/bpf_struct_ops.c                   | 585 +++++++++++++++++
 kernel/bpf/bpf_struct_ops_types.h             |   9 +
 kernel/bpf/btf.c                              | 132 ++--
 kernel/bpf/core.c                             |   1 +
 kernel/bpf/helpers.c                          |  25 +
 kernel/bpf/map_in_map.c                       |   3 +-
 kernel/bpf/syscall.c                          |  64 +-
 kernel/bpf/trampoline.c                       |   5 +-
 kernel/bpf/verifier.c                         | 140 +++-
 net/core/filter.c                             |   4 +-
 net/ipv4/Makefile                             |   4 +
 net/ipv4/bpf_tcp_ca.c                         | 247 ++++++++
 net/ipv4/tcp_cong.c                           |  14 +-
 net/ipv4/tcp_ipv4.c                           |   6 +-
 net/ipv4/tcp_minisocks.c                      |   4 +-
 net/ipv4/tcp_output.c                         |   4 +-
 tools/include/uapi/linux/bpf.h                |  33 +-
 tools/lib/bpf/bpf.c                           |  10 +-
 tools/lib/bpf/bpf.h                           |   5 +-
 tools/lib/bpf/libbpf.c                        | 599 +++++++++++++++++-
 tools/lib/bpf/libbpf.h                        |   3 +-
 tools/lib/bpf/libbpf_probes.c                 |   2 +
 tools/testing/selftests/bpf/bpf_tcp_helpers.h | 228 +++++++
 .../selftests/bpf/prog_tests/bpf_tcp_ca.c     | 220 +++++++
 tools/testing/selftests/bpf/progs/bpf_cubic.c | 502 +++++++++++++++
 tools/testing/selftests/bpf/progs/bpf_dctcp.c | 194 ++++++
 34 files changed, 3089 insertions(+), 134 deletions(-)
 create mode 100644 kernel/bpf/bpf_struct_ops.c
 create mode 100644 kernel/bpf/bpf_struct_ops_types.h
 create mode 100644 net/ipv4/bpf_tcp_ca.c
 create mode 100644 tools/testing/selftests/bpf/bpf_tcp_helpers.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_cubic.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_dctcp.c

-- 
2.17.1

