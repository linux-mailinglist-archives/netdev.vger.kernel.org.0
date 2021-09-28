Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC70F41A597
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 04:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238559AbhI1CkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 22:40:11 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:26914 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238697AbhI1CkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 22:40:10 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HJNqp1ZWNzbmh1;
        Tue, 28 Sep 2021 10:34:14 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 28 Sep 2021 10:38:30 +0800
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Tue, 28 Sep
 2021 10:38:29 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next 0/5] introduce dummy BPF STRUCT_OPS
Date:   Tue, 28 Sep 2021 10:52:23 +0800
Message-ID: <20210928025228.88673-1-houtao1@huawei.com>
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

Now only the return value handling related test cases are supported,
if more is needed, we can add afterwards.

Comments are always welcome.
Regards,
Hou

Changelog:
* RFC: https://www.spinics.net/lists/bpf/msg46117.html


Hou Tao (5):
  bpf: add dummy BPF STRUCT_OPS for test purpose
  bpf: factor out a helper to prepare trampoline for struct_ops prog
  bpf: do .test_run in dummy BPF STRUCT_OPS
  bpf: hook .test_run for struct_ops program
  selftests/bpf: test return value handling for struct_ops prog

 include/linux/bpf.h                           |   5 +
 include/linux/bpf_dummy_ops.h                 |  25 ++
 kernel/bpf/bpf_struct_ops.c                   |  43 +++-
 kernel/bpf/bpf_struct_ops_types.h             |   2 +
 net/bpf/Makefile                              |   3 +
 net/bpf/bpf_dummy_struct_ops.c                | 220 ++++++++++++++++++
 .../selftests/bpf/prog_tests/dummy_st_ops.c   |  81 +++++++
 .../selftests/bpf/progs/dummy_st_ops.c        |  33 +++
 8 files changed, 403 insertions(+), 9 deletions(-)
 create mode 100644 include/linux/bpf_dummy_ops.h
 create mode 100644 net/bpf/bpf_dummy_struct_ops.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/dummy_st_ops.c
 create mode 100644 tools/testing/selftests/bpf/progs/dummy_st_ops.c

-- 
2.29.2

