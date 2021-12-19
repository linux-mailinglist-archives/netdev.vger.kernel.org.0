Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029F3479F39
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 06:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbhLSFHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 00:07:32 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:33870 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbhLSFHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 00:07:31 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JGrLP2KgBzcbqy;
        Sun, 19 Dec 2021 13:07:09 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Sun, 19 Dec
 2021 13:07:29 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>,
        <yunbo.xufeng@linux.alibaba.com>
Subject: [RFC PATCH bpf-next 0/3] support string key for hash-table
Date:   Sun, 19 Dec 2021 13:22:42 +0800
Message-ID: <20211219052245.791605-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

In order to use string as hash-table key, key_size must be the storage
size of longest string. If there are large differencies in string
length, the hash distribution will be sub-optimal due to the unused
zero bytes in shorter strings and the lookup will be inefficient due to
unnecessary memcpy().

Also it is possible the unused part of string key returned from bpf helper
(e.g. bpf_d_path) is not mem-zeroed and if using it directly as lookup key,
the lookup will fail with -ENOENT (as reported in [1]).

The patchset tries to address the inefficiency by adding support for
string key. During the key comparison, the string length is checked
first to reduce the uunecessary memcmp. Also update the hash function
from jhash() to full_name_hash() to reduce hash collision of string key.

There are about 16% and 106% improvment in benchmark under x86-64 and
arm64 when key_size is 256. About 45% and %161 when key size is greater
than 1024.

Also testing the performance improvment by using all files under linux
kernel sources as the string key input. There are about 74k files and the
maximum string length is 101. When key_size is 104, there are about 9%
and 35% win under x86-64 and arm64 in lookup performance, and when key_size
is 256, the win increases to 78% and 109% respectively.

Beside the optimization of lookup for string key, it seems that the
allocated space for BPF_F_NO_PREALLOC-case can also be optimized. More
trials and tests will be conducted if the idea of string key is accepted.

Comments are always welcome.

Regards,
Tao

[1]: https://lore.kernel.org/bpf/20211120051839.28212-2-yunbo.xufeng@linux.alibaba.com

Hou Tao (3):
  bpf: factor out helpers for htab bucket and element lookup
  bpf: add BPF_F_STR_KEY to support string key in htab
  selftests/bpf: add benchmark for string-key hash-table

 include/uapi/linux/bpf.h                      |   3 +
 kernel/bpf/hashtab.c                          | 448 +++++++++++-------
 tools/include/uapi/linux/bpf.h                |   3 +
 tools/testing/selftests/bpf/Makefile          |   4 +-
 tools/testing/selftests/bpf/bench.c           |  10 +
 .../selftests/bpf/benchs/bench_str_htab.c     | 255 ++++++++++
 .../testing/selftests/bpf/benchs/run_htab.sh  |  14 +
 .../selftests/bpf/progs/str_htab_bench.c      | 123 +++++
 8 files changed, 685 insertions(+), 175 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_str_htab.c
 create mode 100755 tools/testing/selftests/bpf/benchs/run_htab.sh
 create mode 100644 tools/testing/selftests/bpf/progs/str_htab_bench.c

-- 
2.29.2

