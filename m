Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860F12C9627
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 04:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387395AbgLAD5C convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 30 Nov 2020 22:57:02 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44498 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727774AbgLAD5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 22:57:02 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B13uLwY005658
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 19:56:21 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3547g8h5bn-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 19:56:21 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 30 Nov 2020 19:55:51 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 143442ECA628; Mon, 30 Nov 2020 19:55:47 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v2 bpf-next 0/8] Support BTF-powered BPF tracing programs for kernel modules
Date:   Mon, 30 Nov 2020 19:55:37 -0800
Message-ID: <20201201035545.3013177-1-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
X-FB-Internal: Safe
Content-Type: text/plain
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_12:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 clxscore=1034
 spamscore=0 suspectscore=0 phishscore=0 mlxscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010026
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Building on top of two previous patch sets ([0] and not yet landed [1]), this
patch sets extends kernel and libbpf with support for attaching BTF-powered
raw tracepoint (tp_btf) and tracing (fentry/fexit/fmod_ret/lsm) BPF programs
to BPF hooks defined in kernel modules.

Kernel UAPI for BPF_PROG_LOAD is extended with extra parameter
(attach_btf_obj_id) which allows to specify kernel module BTF in which the BTF
type is identifed by attach_btf_id.

From end user perspective there are no extra actions that need to happen.
Libbpf will continue searching across all kernel module BTFs, if desired
attach BTF type is not found in vmlinux. That way it doesn't matter if BPF
hook that user is trying to attach to is built-in into vmlinux image or is
loaded in kernel module.

Currently pahole doesn't generate BTF_KIND_FUNC info for ftrace-able static
functions in kernel modules, so expose traced function in bpf_sidecar.ko. Once
pahole is enhanced, we can go back to static function.

  [0] https://patchwork.kernel.org/project/netdevbpf/list/?series=380759&state=*
  [1] https://patchwork.kernel.org/project/netdevbpf/list/?series=393677&state=*

v1->v2:
  - avoid increasing bpf_reg_state by reordering fields (Alexei);
  - preserve btf_data_size in struct module;
  - rebase on top of v3 of patch [1].

Andrii Nakryiko (8):
  bpf: keep module's btf_data_size intact after load
  bpf: remove hard-coded btf_vmlinux assumption from BPF verifier
  bpf: allow to specify kernel module BTFs when attaching BPF programs
  libbpf: factor out low-level BPF program loading helper
  libbpf: support attachment of BPF tracing programs to kernel modules
  selftests/bpf: add tp_btf CO-RE reloc test for modules
  selftests/bpf: make bpf_testmod's traceable function global
  selftests/bpf: add fentry/fexit/fmod_ret selftest for kernel module

 include/linux/bpf.h                           |  13 +-
 include/linux/bpf_verifier.h                  |  28 +++-
 include/linux/btf.h                           |   7 +-
 include/uapi/linux/bpf.h                      |   1 +
 kernel/bpf/btf.c                              |  90 +++++++----
 kernel/bpf/syscall.c                          |  44 +++++-
 kernel/bpf/verifier.c                         |  77 ++++++----
 kernel/module.c                               |   1 -
 net/ipv4/bpf_tcp_ca.c                         |   3 +-
 tools/include/uapi/linux/bpf.h                |   1 +
 tools/lib/bpf/bpf.c                           | 101 ++++++++----
 tools/lib/bpf/libbpf.c                        | 145 +++++++++++++-----
 tools/lib/bpf/libbpf_internal.h               |  30 ++++
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   |   3 +-
 .../selftests/bpf/prog_tests/core_reloc.c     |   3 +-
 .../selftests/bpf/prog_tests/module_attach.c  |  53 +++++++
 .../bpf/progs/test_core_reloc_module.c        |  32 +++-
 .../selftests/bpf/progs/test_module_attach.c  |  66 ++++++++
 18 files changed, 546 insertions(+), 152 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/module_attach.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_module_attach.c

-- 
2.24.1

