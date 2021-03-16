Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E6D33CA9A
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 02:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbhCPBNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 21:13:52 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18754 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229893AbhCPBNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 21:13:39 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12G1DJ3a015859
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 18:13:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=SSlcw44ZdLt+nv9IDd9xfmkLGqiOj28rAtwVIxK++tM=;
 b=N/ifcZFlnid+Cr9sScntCt51t4JnSmZlTqy6ngGkhzAaSacFRklSUzeexL3d7SUpO8UE
 61IA9SOmKd70BeyDEH+HA9mftnaerhzPbNz4VMDif2fyHDWaCtYUgHAxcamE8sVrOKYJ
 4yInvc/WHfYZ/bu/ceP2V01xAgH4mjDK0eQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 378v3q3pnt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 18:13:38 -0700
Received: from intmgw002.06.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 15 Mar 2021 18:13:37 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 577C22942B4F; Mon, 15 Mar 2021 18:13:36 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 00/15] Support calling kernel function
Date:   Mon, 15 Mar 2021 18:13:36 -0700
Message-ID: <20210316011336.4173585-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-15_15:2021-03-15,2021-03-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 clxscore=1015 bulkscore=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103160005
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support to allow bpf program calling kernel function.

The use case included in this set is to allow bpf-tcp-cc to directly
call some tcp-cc helper functions (e.g. "tcp_cong_avoid_ai()").  Those
functions have already been used by some kernel tcp-cc implementations.

This set will also allow the bpf-tcp-cc program to directly call the
kernel tcp-cc implementation,  For example, a bpf_dctcp may only want to
implement its own dctcp_cwnd_event() and reuse other dctcp_*() directly
from the kernel tcp_dctcp.c instead of reimplementing (or
copy-and-pasting) them.

The tcp-cc kernel functions mentioned above will be white listed
for the struct_ops bpf-tcp-cc programs to use in a later patch.
The white listed functions are not bounded to a fixed ABI contract.
Those functions have already been used by the existing kernel tcp-cc.
If any of them has changed, both in-tree and out-of-tree kernel tcp-cc
implementations have to be changed.  The same goes for the struct_ops
bpf-tcp-cc programs which have to be adjusted accordingly.

Please see individual patch for details.

Martin KaFai Lau (15):
  bpf: Simplify freeing logic in linfo and jited_linfo
  bpf: btf: Support parsing extern func
  bpf: Refactor btf_check_func_arg_match
  bpf: Support bpf program calling kernel function
  bpf: Support kernel function call in x86-32
  tcp: Rename bictcp function prefix to cubictcp
  bpf: tcp: White list some tcp cong functions to be called by
    bpf-tcp-cc
  libbpf: Refactor bpf_object__resolve_ksyms_btf_id
  libbpf: Refactor codes for finding btf id of a kernel symbol
  libbpf: Rename RELO_EXTERN to RELO_EXTERN_VAR
  libbpf: Record extern sym relocation first
  libbpf: Support extern kernel function
  bpf: selftests: Rename bictcp to bpf_cubic
  bpf: selftest: bpf_cubic and bpf_dctcp calling kernel functions
  bpf: selftest: Add kfunc_call test

 arch/x86/net/bpf_jit_comp.c                   |   5 +
 arch/x86/net/bpf_jit_comp32.c                 | 198 +++++++++
 include/linux/bpf.h                           |  24 ++
 include/linux/btf.h                           |   6 +
 include/linux/filter.h                        |   4 +-
 include/uapi/linux/bpf.h                      |   4 +
 kernel/bpf/btf.c                              | 270 ++++++++-----
 kernel/bpf/core.c                             |  47 +--
 kernel/bpf/disasm.c                           |  32 +-
 kernel/bpf/disasm.h                           |   3 +-
 kernel/bpf/syscall.c                          |   4 +-
 kernel/bpf/verifier.c                         | 380 ++++++++++++++++--
 net/bpf/test_run.c                            |  11 +
 net/core/filter.c                             |  11 +
 net/ipv4/bpf_tcp_ca.c                         |  41 ++
 net/ipv4/tcp_cubic.c                          |  24 +-
 tools/bpf/bpftool/xlated_dumper.c             |   3 +-
 tools/include/uapi/linux/bpf.h                |   4 +
 tools/lib/bpf/btf.c                           |  32 +-
 tools/lib/bpf/btf.h                           |   5 +
 tools/lib/bpf/libbpf.c                        | 316 ++++++++++-----
 tools/testing/selftests/bpf/bpf_tcp_helpers.h |  29 +-
 tools/testing/selftests/bpf/prog_tests/btf.c  | 154 ++++++-
 .../selftests/bpf/prog_tests/kfunc_call.c     |  61 +++
 tools/testing/selftests/bpf/progs/bpf_cubic.c |  36 +-
 tools/testing/selftests/bpf/progs/bpf_dctcp.c |  22 +-
 .../selftests/bpf/progs/kfunc_call_test.c     |  48 +++
 .../bpf/progs/kfunc_call_test_subprog.c       |  31 ++
 28 files changed, 1454 insertions(+), 351 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/kfunc_call.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test_sub=
prog.c

--=20
2.30.2

