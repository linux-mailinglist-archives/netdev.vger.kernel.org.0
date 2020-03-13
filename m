Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36EE31841DD
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 08:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgCMH4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 03:56:11 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32006 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726464AbgCMH4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 03:56:11 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02D7rj8X003847
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 00:56:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=BIF+5CYAkd9IPXwEHks5M7IGzncNGEgnEWJtzXAmHYA=;
 b=QIVyIuLSBRY7UsoFVbVa8Vx9c8fNVVVlKgJBpGIX7qNUffSDF5J+d9mWQImQYAlNIKDk
 6Ciq/xixnAbGwKP8bCWLXp/6qUoWs3wVXdUrsNohBGHDx5cgIH7cbn7eVhzr3QNZ2WRg
 AFsBzpkCzSR6BQVMsJiguJ5xdd3cUgVHxTE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yqt96aw59-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 00:56:10 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 13 Mar 2020 00:56:07 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 71D1B2EC2DC7; Fri, 13 Mar 2020 00:56:01 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/4] CO-RE candidate matching fix and tracing test
Date:   Fri, 13 Mar 2020 00:54:37 -0700
Message-ID: <20200313075442.4071486-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-13_03:2020-03-11,2020-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 clxscore=1015 spamscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 suspectscore=8 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003130044
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set fixes bug in CO-RE relocation candidate finding logic, which
currently allows matching against forward declarations, functions, and other
named types, even though it makes no sense to even attempt. As part of
verifying the fix, add test using vmlinux.h with preserve_access_index
attribute and utilizing struct pt_regs heavily to trace nanosleep syscall
using 5 different types of tracing BPF programs.

This test also demonstrated problems using struct pt_regs in syscall
tracepoints and required a new set of macro, which were added in patch #3 into
bpf_tracing.h.

Patch #1 fixes annoying issue with selftest failure messages being out of
sync.

Andrii Nakryiko (4):
  selftests/bpf: ensure consistent test failure output
  libbpf: ignore incompatible types with matching name during CO-RE
    relocation
  libbpf: provide CO-RE variants of PT_REGS macros
  selftests/bpf: add vmlinux.h selftest exercising tracing of syscalls

 tools/lib/bpf/bpf_tracing.h                   | 103 ++++++++++++++++++
 tools/lib/bpf/libbpf.c                        |   4 +
 tools/testing/selftests/bpf/Makefile          |   7 +-
 .../selftests/bpf/prog_tests/vmlinux.c        |  43 ++++++++
 .../selftests/bpf/progs/test_vmlinux.c        |  98 +++++++++++++++++
 tools/testing/selftests/bpf/test_progs.c      |  10 +-
 tools/testing/selftests/bpf/test_progs.h      |   8 +-
 7 files changed, 263 insertions(+), 10 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/vmlinux.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_vmlinux.c

-- 
2.17.1

