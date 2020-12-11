Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56952D6F48
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 05:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387443AbgLKE3B convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 10 Dec 2020 23:29:01 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64216 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2395378AbgLKE2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 23:28:48 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BB4DJtR013722
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 20:28:08 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35by3urpfs-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 20:28:08 -0800
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 10 Dec 2020 20:28:06 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 90F322ECB1A1; Thu, 10 Dec 2020 20:28:03 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH RFC bpf-next  0/4] Support kernel module ksym variables
Date:   Thu, 10 Dec 2020 20:27:30 -0800
Message-ID: <20201211042734.730147-1-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
X-FB-Internal: Safe
Content-Type: text/plain
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-11_01:2020-12-09,2020-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1034 impostorscore=0
 malwarescore=0 priorityscore=1501 mlxlogscore=999 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012110023
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This RFC is sent to show how ksym variable access in BPF program can be
supported for kernel modules and gather some feedback while necessary fixes
for pahole ([0]) are reviewed and hopefully will make it into 1.20 version.

This work builds on all the previous kernel and libbpf changes to support
kernel module BTFs. On top of that, BPF verifier will now support ldimm64 with
src_reg=BPF_PSEUDO_BTF_ID and non-zero insn[1].imm field, which contains BTF
FD for kernel module. In such case, used module BTF, similarly to used BPF
map, will be recorded and refcnt will be increased for both BTF object itself
and its kernel module. This makes sure kernel module won't be unloaded from
under active attached BPF program.

New selftest validates all this is working as intended. bpf_testmod.ko is
extended with per-CPU variable.

  [0] https://patchwork.kernel.org/project/netdevbpf/list/?series=400229&state=*

Andrii Nakryiko (4):
  selftests/bpf: sync RCU before unloading bpf_testmod
  bpf: support BPF ksym variables in kernel modules
  libbpf: support kernel module ksym externs
  selftests/bpf: test kernel module ksym externs

 include/linux/bpf.h                           |   9 ++
 include/linux/bpf_verifier.h                  |   3 +
 include/linux/btf.h                           |   3 +
 kernel/bpf/btf.c                              |  31 +++-
 kernel/bpf/core.c                             |  23 +++
 kernel/bpf/verifier.c                         | 149 ++++++++++++++----
 tools/lib/bpf/libbpf.c                        |  47 ++++--
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   |   3 +
 .../selftests/bpf/prog_tests/btf_map_in_map.c |  33 ----
 .../selftests/bpf/prog_tests/ksyms_module.c   |  33 ++++
 .../selftests/bpf/progs/test_ksyms_module.c   |  26 +++
 tools/testing/selftests/bpf/test_progs.c      |  40 +++++
 tools/testing/selftests/bpf/test_progs.h      |   1 +
 13 files changed, 321 insertions(+), 80 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_module.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_module.c

-- 
2.24.1

