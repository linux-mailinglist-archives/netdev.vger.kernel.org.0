Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B192EFAD8
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 23:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbhAHWKN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 8 Jan 2021 17:10:13 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44706 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725844AbhAHWKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 17:10:13 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 108M92G3030132
        for <netdev@vger.kernel.org>; Fri, 8 Jan 2021 14:09:32 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35wt06j002-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 14:09:32 -0800
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 8 Jan 2021 14:09:31 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 30BDE2ECD237; Fri,  8 Jan 2021 14:09:31 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Hao Luo <haoluo@google.com>
Subject: [PATCH v2 bpf-next 0/7] Support kernel module ksym variables
Date:   Fri, 8 Jan 2021 14:09:23 -0800
Message-ID: <20210108220930.482456-1-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-08_11:2021-01-07,2021-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 phishscore=0 suspectscore=0 mlxlogscore=881 clxscore=1034 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101080113
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for using kernel module global variables (__ksym externs in BPF
program). BPF verifier will now support ldimm64 with src_reg=BPF_PSEUDO_BTF_ID
and non-zero insn[1].imm field, specifying module BTF's FD. In such case,
module BTF object, similarly to BPF maps referenced from ldimm64 with
src_reg=BPF_PSEUDO_MAP_FD, will be recorded in bpf_progran's auxiliary data
and refcnt will be increased for both BTF object itself and its kernel module.
This makes sure kernel module won't be unloaded from under active attached BPF
program. These refcounts will be dropped when BPF program is unloaded.

New selftest validates all this is working as intended. bpf_testmod.ko is
extended with per-CPU variable. Selftests expects the latest pahole changes
(soon to be released as v1.20) to generate per-CPU variable BTF info for
kernel module.

v1->v2:
  - fixed few compiler warnings, posted as separate pre-patches;
rfc->v1:
  - use sys_membarrier(MEMBARRIER_CMD_GLOBAL) (Alexei).

Cc: Hao Luo <haoluo@google.com>
Andrii Nakryiko (7):
  bpf: add bpf_patch_call_args prototype to include/linux/bpf.h
  bpf: avoid warning when re-casting __bpf_call_base into
    __bpf_call_base_args
  bpf: declare __bpf_free_used_maps() unconditionally
  selftests/bpf: sync RCU before unloading bpf_testmod
  bpf: support BPF ksym variables in kernel modules
  libbpf: support kernel module ksym externs
  selftests/bpf: test kernel module ksym externs

 include/linux/bpf.h                           |  18 ++-
 include/linux/bpf_verifier.h                  |   3 +
 include/linux/btf.h                           |   3 +
 include/linux/filter.h                        |   2 +-
 kernel/bpf/btf.c                              |  31 +++-
 kernel/bpf/core.c                             |  23 +++
 kernel/bpf/verifier.c                         | 149 ++++++++++++++----
 tools/lib/bpf/libbpf.c                        |  47 ++++--
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   |   3 +
 .../selftests/bpf/prog_tests/btf_map_in_map.c |  33 ----
 .../selftests/bpf/prog_tests/ksyms_module.c   |  33 ++++
 .../selftests/bpf/progs/test_ksyms_module.c   |  26 +++
 tools/testing/selftests/bpf/test_progs.c      |  11 ++
 tools/testing/selftests/bpf/test_progs.h      |   1 +
 14 files changed, 300 insertions(+), 83 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_module.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_module.c

-- 
2.24.1

