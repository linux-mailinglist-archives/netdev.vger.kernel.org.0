Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 882B6135080
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 01:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbgAIAfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 19:35:02 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58772 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726438AbgAIAfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 19:35:02 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0090Yvxt026117
        for <netdev@vger.kernel.org>; Wed, 8 Jan 2020 16:35:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=sPD6gzFPV9RTDwdoCRmGOHVw+Qd+TR1zIIDQRAEq1WM=;
 b=kTpFGC6PbpE8URrdcfSTSfCD3oMFHyIKoGdTuOJJgKdQHXi0RHiSfZp6YZVEfvzN2zwL
 rMnqJZRy/qRSHrDEUgQ2+BM7ySdHDi43mwNJUMBJZFYbDvQEkr3DPAOcFAw7W1jHRMoD
 sumne3C1OGHBswzrEXXB4ackQyg5Esmi7WQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2xdkut9w9d-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 16:35:01 -0800
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 8 Jan 2020 16:34:55 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 6C9B72942576; Wed,  8 Jan 2020 16:34:53 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v4 00/11] Introduce BPF STRUCT_OPS
Date:   Wed, 8 Jan 2020 16:34:53 -0800
Message-ID: <20200109003453.3854769-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-08_07:2020-01-08,2020-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=13 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 mlxlogscore=999 impostorscore=0
 priorityscore=1501 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001090003
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

v4:
- Expose tcp_ca_find() to tcp.h in patch 7.
  It is used to check the same bpf-tcp-cc
  does not exist to guarantee the register()
  will succeed.
- set_memory_ro() and then set_memory_x() only after all
  trampolines are written to the image in patch 6. (Daniel)
  spinlock is replaced by mutex because set_memory_*
  requires sleepable context.
  
v3:
- Fix kbuild error by considering CONFIG_BPF_SYSCALL (kbuild)
- Support anonymous bitfield in patch 4 (Andrii, Yonghong)
- Push boundary safety check to a specific arch's trampoline function
  (in patch 6) (Yonghong).
  Reuse the WANR_ON_ONCE check in arch_prepare_bpf_trampoline() in x86.
- Check module field is 0 in udata in patch 6 (Yonghong)
- Check zero holes in patch 6 (Andrii)
- s/_btf_vmlinux/btf/ in patch 5 and 7 (Andrii)
- s/check_xxx/is_xxx/ in patch 7 (Andrii)
- Use "struct_ops/" convention in patch 11 (Andrii)
- Use the skel instead of bpf_object in patch 11 (Andrii)
- libbpf: Decide BPF_PROG_TYPE_STRUCT_OPS at open phase by using
          find_sec_def()
- libbpf: Avoid a debug message at open phase (Andrii)
- libbpf: Add bpf_program__(is|set)_struct_ops() for consistency (Andrii)
- libbpf: Add "struct_ops" to section_defs (Andrii)
- libbpf: Some code shuffling in init_kern_struct_ops() (Andrii)
- libbpf: A few safety checks (Andrii)

v2:
- Dropped cubic for now.  They will be reposted
  once there are more clarity in "jiffies" on both
  bpf side (about the helper) and
  tcp_cubic side (some of jiffies usages are being replaced
  by tp->tcp_mstamp)
- Remove unnecssary check on bitfield support from btf_struct_access()
  (Yonghong)
- BTF_TYPE_EMIT macro (Yonghong, Andrii)
- value_name's length check to avoid an unlikely
  type match during truncation case (Yonghong)
- BUILD_BUG_ON to ensure no trampoline-image overrun
  in the future (Yonghong)
- Simplify get_next_key() (Yonghong)
- Added comment to explain how to check mandatory
  func ptr in net/ipv4/bpf_tcp_ca.c (Yonghong)
- Rename "__bpf_" to "bpf_struct_ops_" for value prefix (Andrii)
- Add comment to highlight the bpf_dctcp.c is not necessarily
  the same as tcp_dctcp.c. (Alexei, Eric)
- libbpf: Renmae "struct_ops" to ".struct_ops" for elf sec (Andrii)
- libbpf: Expose struct_ops as a bpf_map (Andrii)
- libbpf: Support multiple struct_ops in SEC(".struct_ops") (Andrii)
- libbpf: Add bpf_map__attach_struct_ops()  (Andrii)

Martin KaFai Lau (11):
  bpf: Save PTR_TO_BTF_ID register state when spilling to stack
  bpf: Avoid storing modifier to info->btf_id
  bpf: Add enum support to btf_ctx_access()
  bpf: Support bitfield read access in btf_struct_access
  bpf: Introduce BPF_PROG_TYPE_STRUCT_OPS
  bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS
  bpf: tcp: Support tcp_congestion_ops in bpf
  bpf: Add BPF_FUNC_tcp_send_ack helper
  bpf: Synch uapi bpf.h to tools/
  bpf: libbpf: Add STRUCT_OPS support
  bpf: Add bpf_dctcp example

 arch/x86/net/bpf_jit_comp.c                   |  18 +-
 include/linux/bpf.h                           |  79 ++-
 include/linux/bpf_types.h                     |   7 +
 include/linux/btf.h                           |  47 ++
 include/linux/filter.h                        |   2 +
 include/net/tcp.h                             |   2 +
 include/uapi/linux/bpf.h                      |  19 +-
 kernel/bpf/Makefile                           |   3 +
 kernel/bpf/bpf_struct_ops.c                   | 628 +++++++++++++++++
 kernel/bpf/bpf_struct_ops_types.h             |   9 +
 kernel/bpf/btf.c                              | 163 +++--
 kernel/bpf/map_in_map.c                       |   3 +-
 kernel/bpf/syscall.c                          |  69 +-
 kernel/bpf/trampoline.c                       |   8 +-
 kernel/bpf/verifier.c                         | 140 +++-
 net/core/filter.c                             |   2 +-
 net/ipv4/Makefile                             |   4 +
 net/ipv4/bpf_tcp_ca.c                         | 252 +++++++
 net/ipv4/tcp_cong.c                           |  16 +-
 net/ipv4/tcp_ipv4.c                           |   6 +-
 net/ipv4/tcp_minisocks.c                      |   4 +-
 net/ipv4/tcp_output.c                         |   4 +-
 tools/include/uapi/linux/bpf.h                |  19 +-
 tools/lib/bpf/bpf.c                           |  10 +-
 tools/lib/bpf/bpf.h                           |   5 +-
 tools/lib/bpf/libbpf.c                        | 649 +++++++++++++++++-
 tools/lib/bpf/libbpf.h                        |   5 +-
 tools/lib/bpf/libbpf.map                      |   3 +
 tools/lib/bpf/libbpf_probes.c                 |   2 +
 tools/testing/selftests/bpf/bpf_tcp_helpers.h | 228 ++++++
 .../selftests/bpf/prog_tests/bpf_tcp_ca.c     | 187 +++++
 tools/testing/selftests/bpf/progs/bpf_dctcp.c | 210 ++++++
 32 files changed, 2655 insertions(+), 148 deletions(-)
 create mode 100644 kernel/bpf/bpf_struct_ops.c
 create mode 100644 kernel/bpf/bpf_struct_ops_types.h
 create mode 100644 net/ipv4/bpf_tcp_ca.c
 create mode 100644 tools/testing/selftests/bpf/bpf_tcp_helpers.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_dctcp.c

-- 
2.17.1

