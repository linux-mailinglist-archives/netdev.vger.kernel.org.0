Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19A5348694
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 02:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235887AbhCYBvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 21:51:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:24946 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233541AbhCYBvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 21:51:32 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12P1pUYp024144
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 18:51:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=KY+WZnkEa22ickUop0q6SJahepXHa94vn9tr1IV0XK0=;
 b=p/LpBLTYO50yOgzox94G+pEyKRGovI1jyiZg4n/VoY5UdnLQh7knFl5Jz5wEIhan/O2u
 rgX7l/y1Vb0ujyVBm1DbOekUeDWgjdf9GpUjyKjoqwnDG9CLFqmpl9jCA9Y3NdhUh7oI
 zQjPXte07+AwCtHosPgqQrtju9KfEJBjS/M= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37fpbm8wp0-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 18:51:32 -0700
Received: from intmgw006.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 24 Mar 2021 18:51:25 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 2FF5A29429CE; Wed, 24 Mar 2021 18:51:24 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 bpf-next 00/14] bpf: Support calling kernel function
Date:   Wed, 24 Mar 2021 18:51:24 -0700
Message-ID: <20210325015124.1543397-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-24_14:2021-03-24,2021-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 malwarescore=0 clxscore=1015 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103250012
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

v2:
- Patch 2 in v1 is removed.  No need to support extern func in kernel.
  Changed libbpf to adjust the .ksyms datasec for extern func
  in patch 11. (Andrii)
- Name change: btf_check_func_arg_match() and btf_check_subprog_arg_match=
()
  in patch 2. (Andrii)
- Always set unreliable on any error in patch 2 since it does not
  matter. (Andrii)
- s/kern_func/kfunc/ and s/descriptor/desc/ in this set. (Andrii)
- Remove some unnecessary changes in disasm.h and disasm.c
  in patch 3.  In particular, no need to change the function
  signature in bpf_insn_revmap_call_t.  Also, removed the changes
  in print_bpf_insn().
- Fixed an issue in check_kfunc_call() when the calling kernel function
  returns a pointer in patch 3.  Added a selftest.
- Adjusted the verifier selftests due to the changes in the verifier log
  in patch 3.
- Fixed a comparison issue in kfunc_desc_cmp_by_imm() in patch 3. (Andrii=
)
- Name change: is_ldimm64_insn(),
  new helper: is_call_insn() in patch 10 (Andrii)
- Move btf_func_linkage() from btf.h to libbpf.c in patch 11. (Andrii)
- Fixed the linker error when CONFIG_BPF_SYSCALL is not defined.
  Moved the check_kfunc_call from filter.c to test_run.c in patch 14.
  (kernel test robot)

Martin KaFai Lau (14):
  bpf: Simplify freeing logic in linfo and jited_linfo
  bpf: Refactor btf_check_func_arg_match
  bpf: Support bpf program calling kernel function
  bpf: Support kernel function call in x86-32
  tcp: Rename bictcp function prefix to cubictcp
  bpf: tcp: Put some tcp cong functions in allowlist for bpf-tcp-cc
  libbpf: Refactor bpf_object__resolve_ksyms_btf_id
  libbpf: Refactor codes for finding btf id of a kernel symbol
  libbpf: Rename RELO_EXTERN to RELO_EXTERN_VAR
  libbpf: Record extern sym relocation first
  libbpf: Support extern kernel function
  bpf: selftests: Rename bictcp to bpf_cubic
  bpf: selftests: bpf_cubic and bpf_dctcp calling kernel functions
  bpf: selftests: Add kfunc_call test

 arch/x86/net/bpf_jit_comp.c                   |   5 +
 arch/x86/net/bpf_jit_comp32.c                 | 198 +++++++++
 include/linux/bpf.h                           |  34 +-
 include/linux/btf.h                           |   6 +
 include/linux/filter.h                        |   4 +-
 include/uapi/linux/bpf.h                      |   4 +
 kernel/bpf/btf.c                              | 218 ++++++----
 kernel/bpf/core.c                             |  47 +--
 kernel/bpf/disasm.c                           |  13 +-
 kernel/bpf/syscall.c                          |   4 +-
 kernel/bpf/verifier.c                         | 376 +++++++++++++++--
 net/bpf/test_run.c                            |  28 ++
 net/core/filter.c                             |   1 +
 net/ipv4/bpf_tcp_ca.c                         |  41 ++
 net/ipv4/tcp_cubic.c                          |  24 +-
 tools/include/uapi/linux/bpf.h                |   4 +
 tools/lib/bpf/libbpf.c                        | 389 +++++++++++++-----
 tools/testing/selftests/bpf/bpf_tcp_helpers.h |  29 +-
 .../selftests/bpf/prog_tests/kfunc_call.c     |  59 +++
 tools/testing/selftests/bpf/progs/bpf_cubic.c |  36 +-
 tools/testing/selftests/bpf/progs/bpf_dctcp.c |  22 +-
 .../selftests/bpf/progs/kfunc_call_test.c     |  47 +++
 .../bpf/progs/kfunc_call_test_subprog.c       |  42 ++
 tools/testing/selftests/bpf/verifier/calls.c  |  12 +-
 .../selftests/bpf/verifier/dead_code.c        |  10 +-
 25 files changed, 1334 insertions(+), 319 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/kfunc_call.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test_sub=
prog.c

--=20
2.30.2

