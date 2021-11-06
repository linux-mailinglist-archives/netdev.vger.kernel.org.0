Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 567ED446E06
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 14:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbhKFNP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 09:15:59 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:26293 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233692AbhKFNP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 09:15:57 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Hmd3W3Wtwzbhb5;
        Sat,  6 Nov 2021 21:08:23 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sat, 6 Nov 2021 21:13:10 +0800
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Sat, 6 Nov
 2021 21:13:03 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [RFC PATCH bpf-next 0/2] introduce bpf_strncmp() helper
Date:   Sat, 6 Nov 2021 21:28:20 +0800
Message-ID: <20211106132822.1396621-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The motivation for introducing bpf_strncmp() helper comes from
two aspects:

(1) clang doesn't always replace strncmp() automatically
    (and don't known why)
In tracing program, sometimes we need to using a home-made
strncmp() to check whether or not the file name is expected.

(2) the performance of home-made strncmp is not so good
As shown in the benchmark of patch #2, the performance of
bpf_strncmp helper is 80% better than home-made strncmp under
x86-64, and 600% better under arm64 thanks to its arch-optimized
strncmp().

But i'm concernt about whether the API of bpf_strncmp() is OK.
Now the first argument must be a read-only null-terminated
string, it is enough for our file-name comparsion case because
the target file name is const and read-only, but may be not
usable for comparsion of two strings stored in writable-maps.

Any comments are welcome.

Regards,
Tao

Hou Tao (2):
  bpf: add bpf_strncmp helper
  selftests/bpf: add benchmark bpf_strcmp

 include/linux/bpf.h                           |   1 +
 include/uapi/linux/bpf.h                      |  11 ++
 kernel/bpf/helpers.c                          |  14 +++
 kernel/trace/bpf_trace.c                      |   2 +
 tools/include/uapi/linux/bpf.h                |  11 ++
 .../bpf/prog_tests/test_strncmp_helper.c      |  75 ++++++++++++
 .../selftests/bpf/progs/strncmp_helper.c      | 109 ++++++++++++++++++
 7 files changed, 223 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_strncmp_helper.c
 create mode 100644 tools/testing/selftests/bpf/progs/strncmp_helper.c

-- 
2.29.2

