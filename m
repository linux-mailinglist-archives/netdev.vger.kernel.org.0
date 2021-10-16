Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85057430299
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 14:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235202AbhJPMfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 08:35:18 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:28951 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234762AbhJPMfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 08:35:17 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HWj9J6HS2zbmrT;
        Sat, 16 Oct 2021 20:28:36 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Sat, 16 Oct 2021 20:33:07 +0800
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Sat, 16 Oct
 2021 20:33:06 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next v2 0/5] introduce dummy BPF STRUCT_OPS
Date:   Sat, 16 Oct 2021 20:48:01 +0800
Message-ID: <20211016124806.1547989-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Currently the test of BPF STRUCT_OPS depends on the specific bpf
implementation (e.g, tcp_congestion_ops), but it can not cover all
basic functionalities (e.g, return value handling), so introduce
a dummy BPF STRUCT_OPS for test purpose.

Instead of loading a userspace-implemeted bpf_dummy_ops map into
kernel and calling the specific function by writing to sysfs provided
by bpf_testmode.ko, only loading bpf_dummy_ops related prog into
kernel and calling these prog by bpf_prog_test_run(). The latter
is more flexible and has no dependency on extra kernel module.

Now the return value handling is supported by test_1(...) ops,
and passing multiple arguments is supported by test_2(...) ops.
If more is needed, test_x(...) ops can be added afterwards.

Comments are always welcome.
Regards,
Hou

Change Log:
v2:
 * rebase on bpf-next
 * add test_2(...) ops to test the passing of multiple arguments
 * a new patch (patch #2) is added to factor out ctx access helpers
 * address comments from Martin & Andrii

v1: https://www.spinics.net/lists/bpf/msg46787.html

RFC: https://www.spinics.net/lists/bpf/msg46117.html

Hou Tao (5):
  bpf: factor out a helper to prepare trampoline for struct_ops prog
  bpf: factor out helpers to check ctx access for BTF function
  bpf: add dummy BPF STRUCT_OPS for test purpose
  bpf: hook .test_run for struct_ops program
  selftests/bpf: add test cases for struct_ops prog

 include/linux/bpf.h                           |  45 ++++
 kernel/bpf/bpf_struct_ops.c                   |  46 +++-
 kernel/bpf/bpf_struct_ops_types.h             |   1 +
 kernel/trace/bpf_trace.c                      |  16 +-
 net/bpf/Makefile                              |   3 +
 net/bpf/bpf_dummy_struct_ops.c                | 206 ++++++++++++++++++
 net/ipv4/bpf_tcp_ca.c                         |   9 +-
 .../selftests/bpf/prog_tests/dummy_st_ops.c   | 114 ++++++++++
 .../selftests/bpf/progs/dummy_st_ops.c        |  50 +++++
 9 files changed, 458 insertions(+), 32 deletions(-)
 create mode 100644 net/bpf/bpf_dummy_struct_ops.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/dummy_st_ops.c
 create mode 100644 tools/testing/selftests/bpf/progs/dummy_st_ops.c

-- 
2.29.2

