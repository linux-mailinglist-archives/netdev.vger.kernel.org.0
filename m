Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3ADE4B4D9E
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 12:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237905AbiBNLSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 06:18:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350684AbiBNLST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 06:18:19 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCF366214;
        Mon, 14 Feb 2022 02:51:30 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Jy1BP4Jkzz1FD9x;
        Mon, 14 Feb 2022 18:47:09 +0800 (CST)
Received: from huawei.com (10.175.112.60) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Mon, 14 Feb
 2022 18:51:28 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <houtao1@huawei.com>
Subject: [RFC PATCH bpf-next v2 0/3] bpf: support string key in htab
Date:   Mon, 14 Feb 2022 19:13:34 +0800
Message-ID: <20220214111337.3539-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.112.60]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

In order to use string as hash-table key, key_size must be the storage
size of longest string. If there are large differencies in string
length, the hash distribution will be sub-optimal due to the unused
zero bytes in shorter strings and the lookup will be inefficient due to
unnecessary memcmp().

Also it is possible the unused part of string key returned from bpf helper
(e.g. bpf_d_path) is not mem-zeroed and if using it directly as lookup key,
the lookup will fail with -ENOENT (as reported in [1]).

The patchset tries to address the inefficiency by adding support for
string key. There is extensibility problem in v1 because the string key
and its optimization is only available for string-only key. To make it
extensible, v2 introduces bpf_str_key_stor and bpf_str_key_desc and enforce
the layout of hash key struct through BTF as follows:

	>the start of hash key
	...
	[struct bpf_str_key_desc m;]
	...
	[struct bpf_str_key_desc n;]
	...
	struct bpf_str_key_stor z;
	unsigned char raw[N];
	>the end of hash key

So if there is string-only key, the struct of hash key will be:

	struct key {
		struct bpf_str_key_stor comm;
		unsigend char raw[128];
	};

And if there are other fields in hash key, the struct will be:

	struct key {
		int pid;
		struct bpf_str_key_stor comm;
		unsigned char raw[128];
	};

If there are multiple string in hash, the struct will become as:

	struct key {
		int pid;
		struct bpf_str_key_desc path;
		struct bpf_str_key_desc comm;
		unsigned char raw[128 + 128];
	};

See patch #1 and #3 for more details on how these key are manipulated and
used. Patch #2 adds a simple test to demonstrate how string key solves the
reported problem ([1]) due to unused part in hash key.

There are about 180% and 170% improvment in benchmark under x86-64 and
arm64 when key_size is 252. About 280% and %270 when key size is greater
than 512.

Also testing the performance improvment by using all files under linux
kernel sources as the string key input. There are about 74k files and the
maximum string length is 101. When key_size is 108, there are about 71%
and 39% win under x86-64 and arm64 in lookup performance, and when key_size
is 252, the win increases to 150% and 94% respectively.

The patchset is still in early stage of development, so any comments and
suggestions are always welcome.

Regards,
Tao

Change Log
v2:
  * make string key being extensible for no-string-only hash key

v1: https://lore.kernel.org/bpf/20211219052245.791605-1-houtao1@huawei.com/

[1]: https://lore.kernel.org/bpf/20211120051839.28212-2-yunbo.xufeng@linux.alibaba.com

Hou Tao (3):
  bpf: add support for string in hash table key
  selftests/bpf: add a simple test for htab str key
  selftests/bpf: add benchmark for string-key hash table

 include/linux/btf.h                           |   3 +
 include/uapi/linux/bpf.h                      |  19 +
 kernel/bpf/btf.c                              |  39 ++
 kernel/bpf/hashtab.c                          | 162 ++++++-
 tools/include/uapi/linux/bpf.h                |  19 +
 tools/testing/selftests/bpf/Makefile          |   4 +-
 tools/testing/selftests/bpf/bench.c           |  14 +
 .../selftests/bpf/benchs/bench_str_htab.c     | 449 ++++++++++++++++++
 .../testing/selftests/bpf/benchs/run_htab.sh  |  11 +
 .../selftests/bpf/prog_tests/str_key.c        |  71 +++
 .../selftests/bpf/progs/str_htab_bench.c      | 224 +++++++++
 tools/testing/selftests/bpf/progs/str_key.c   |  75 +++
 12 files changed, 1064 insertions(+), 26 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_str_htab.c
 create mode 100755 tools/testing/selftests/bpf/benchs/run_htab.sh
 create mode 100644 tools/testing/selftests/bpf/prog_tests/str_key.c
 create mode 100644 tools/testing/selftests/bpf/progs/str_htab_bench.c
 create mode 100644 tools/testing/selftests/bpf/progs/str_key.c

-- 
2.25.4

