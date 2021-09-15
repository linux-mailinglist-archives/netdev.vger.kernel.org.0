Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33DD140BE24
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 05:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236007AbhIODZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 23:25:16 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:16202 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235700AbhIODZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 23:25:15 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4H8QWy6qxgz1DH0g;
        Wed, 15 Sep 2021 11:22:54 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 11:23:51 +0800
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Wed, 15 Sep
 2021 11:23:50 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <houtao1@huawei.com>
Subject: [RFC PATCH bpf-next 0/3] introduce dummy BPF STRUCT_OPS
Date:   Wed, 15 Sep 2021 11:37:50 +0800
Message-ID: <20210915033753.1201597-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Currently the test of BPF STRUCT_OPS depends on the specific bpf
implementation of tcp_congestion_ops, but it can not cover all
basic functionalities (e.g, return value handling), so introduce
a dummy BPF STRUCT_OPS for test purpose.

The test procedure works in the following way:
(1) write to newly-created /sys/kernel/bpf_test/dummy_ops_ctl
The format is "test_case_N [option_integer_return]".

(2) test_case_N in bpf_testmod.ko will be call dummy_ops method
It will call bpf_get_dummy_ops() first to get the dummy_ops,
call its method, and check the return value of the method. If
the method succeeds and its return value is expected, the write
succeeds, else it fails.

But there is one concerns: the format of dummy_ops_ctl is too
simply. It can only check a integer state update from dummy_ops
method. If multiple states are updated in a dummy struct_ops
method, it can not verify these updates are expected in
bpf_testmod.ko. Are such test is needed here ?

Any comments are welcome.

Hou Tao (3):
  bpf: add dummy BPF STRUCT_OPS for test purpose
  selftests/bpf: call dummy struct_ops in bpf_testmode
  selftests/bpf: add test for BPF STRUCT_OPS

 include/linux/bpf_dummy_ops.h                 |  28 +++
 kernel/bpf/Kconfig                            |   7 +
 kernel/bpf/Makefile                           |   2 +
 kernel/bpf/bpf_dummy_struct_ops.c             | 173 ++++++++++++++++++
 kernel/bpf/bpf_struct_ops_types.h             |   4 +
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 152 ++++++++++++++-
 .../selftests/bpf/prog_tests/bpf_dummy_ops.c  |  95 ++++++++++
 .../selftests/bpf/progs/bpf_dummy_ops.c       |  34 ++++
 8 files changed, 493 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/bpf_dummy_ops.h
 create mode 100644 kernel/bpf/bpf_dummy_struct_ops.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_dummy_ops.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_dummy_ops.c

-- 
2.29.2

