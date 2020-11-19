Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582A42B9E0A
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 00:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgKSXWv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 19 Nov 2020 18:22:51 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2792 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725890AbgKSXWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 18:22:51 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AJNJxra003335
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 15:22:50 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34wtheu7h1-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 15:22:50 -0800
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 19 Nov 2020 15:22:47 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id AF24B2EC9B9C; Thu, 19 Nov 2020 15:22:45 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 0/6] libbpf: add support for kernel module BTF CO-RE relocations
Date:   Thu, 19 Nov 2020 15:22:38 -0800
Message-ID: <20201119232244.2776720-1-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_14:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=862
 lowpriorityscore=0 bulkscore=0 phishscore=0 spamscore=0 adultscore=0
 impostorscore=0 clxscore=1015 priorityscore=1501 suspectscore=8 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190160
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement libbpf support for performing CO-RE relocations against types in
kernel module BTFs, in addition to existing vmlinux BTF support.

This is a first step towards fully supporting kernel module BTFs. Subsequent
patch sets will expand kernel and libbpf sides to allow using other
BTF-powered capabilities (fentry/fexit, struct_ops, ksym externs, etc). For
CO-RE relocations support, though, no extra kernel changes are necessary.

This patch set also sets up a convenient and fully-controlled custom kernel
module (called "bpf_sidecar"), that is a predictable playground for all the
BPF selftests, that rely on module BTFs.

Andrii Nakryiko (6):
  bpf: fix bpf_put_raw_tracepoint()'s use of __module_address()
  libbpf: add internal helper to load BTF data by FD
  libbpf: refactor CO-RE relocs to not assume a single BTF object
  libbpf: add kernel module BTF support for CO-RE relocations
  selftests/bpf: add bpf_sidecar kernel module for testing
  selftests/bpf: add CO-RE relocs selftest relying on kernel module BTF

 kernel/trace/bpf_trace.c                      |   6 +-
 tools/lib/bpf/btf.c                           |  61 +--
 tools/lib/bpf/libbpf.c                        | 352 ++++++++++++++----
 tools/lib/bpf/libbpf_internal.h               |   1 +
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |  12 +-
 .../selftests/bpf/bpf_sidecar/.gitignore      |   6 +
 .../selftests/bpf/bpf_sidecar/Makefile        |  20 +
 .../bpf/bpf_sidecar/bpf_sidecar-events.h      |  36 ++
 .../selftests/bpf/bpf_sidecar/bpf_sidecar.c   |  51 +++
 .../selftests/bpf/bpf_sidecar/bpf_sidecar.h   |  14 +
 .../selftests/bpf/prog_tests/core_reloc.c     |  72 +++-
 .../selftests/bpf/progs/core_reloc_types.h    |  17 +
 .../bpf/progs/test_core_reloc_module.c        |  66 ++++
 tools/testing/selftests/bpf/test_progs.c      |  52 +++
 15 files changed, 647 insertions(+), 120 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/bpf_sidecar/.gitignore
 create mode 100644 tools/testing/selftests/bpf/bpf_sidecar/Makefile
 create mode 100644 tools/testing/selftests/bpf/bpf_sidecar/bpf_sidecar-events.h
 create mode 100644 tools/testing/selftests/bpf/bpf_sidecar/bpf_sidecar.c
 create mode 100644 tools/testing/selftests/bpf/bpf_sidecar/bpf_sidecar.h
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_module.c

-- 
2.24.1

