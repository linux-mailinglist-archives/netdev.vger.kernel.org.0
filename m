Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E36664ED936
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 14:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233829AbiCaMF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 08:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbiCaMF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 08:05:57 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654093E0C6;
        Thu, 31 Mar 2022 05:04:09 -0700 (PDT)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KThjs5q9SzCqts;
        Thu, 31 Mar 2022 20:01:53 +0800 (CST)
Received: from huawei.com (10.175.112.60) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Thu, 31 Mar
 2022 20:04:07 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <houtao1@huawei.com>
Subject: [RFC PATCH bpf-next 0/2] bpf: Introduce ternary search tree for string key
Date:   Thu, 31 Mar 2022 20:28:20 +0800
Message-ID: <20220331122822.14283-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.112.60]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The initial motivation for the patchset is due to the suggestion of Alexei.
During the discuss of supporting of string key in hash-table, he saw the
space efficiency of ternary search tree under our early test and suggest
us to post it as a new bpf map [1].

Ternary search tree is a special trie where nodes are arranged in a
manner similar to binary search tree, but with up to three children
rather than two. The three children correpond to nodes whose value is
less than, equal to, and greater than the value of current node
respectively.

In ternary search tree map, only the valid content of string is saved.
The trailing null byte and unused bytes after it are not saved. If there
are common prefixes between these strings, the prefix is only saved once.
Compared with other space optimized trie (e.g. HAT-trie, succinct trie),
the advantage of ternary search tree is simple and being writeable.

Below are diagrams for ternary search map when inserting hello, he,
test and tea into it:

1. insert "hello"

        [ hello ]

2. insert "he": need split "hello" into "he" and "llo"

         [ he ]
            |
            *
            |
         [ llo ]

3. insert "test": add it as right child of "he"

         [ he ]
            |
            *-------x
            |       |
         [ llo ] [ test ]

5. insert "tea": split "test" into "te" and "st",
   and insert "a" as left child of "st"

         [ he ]
            |
     x------*-------x
     |      |       |
  [ ah ] [ llo ] [ te ]
                    |
                    *
                    |
                 [ st ]
                    |
               x----*
               |
             [ a ]

As showed in above diagrams, the common prefix between "test" and "tea"
is "te" and it only is saved once. Also add benchmarks to compare the
memory usage and lookup performance between ternary search tree and
hash table. When the common prefix is lengthy (~192 bytes) and the
length of suffix is about 64 bytes, there are about 2~3 folds memory
saving compared with hash table. But the memory saving comes at prices:
the lookup performance of tst is about 2~3 slower compared with hash
table. See more benchmark details on patch #2.

Comments and suggestions are always welcome.

Regards,
Tao

[1]: https://lore.kernel.org/bpf/CAADnVQJUJp3YBcpESwR3Q1U6GS1mBM=Vp-qYuQX7eZOaoLjdUA@mail.gmail.com/

Hou Tao (2):
  bpf: Introduce ternary search tree for string key
  selftests/bpf: add benchmark for ternary search tree map

 include/linux/bpf_types.h                     |   1 +
 include/uapi/linux/bpf.h                      |   1 +
 kernel/bpf/Makefile                           |   1 +
 kernel/bpf/bpf_tst.c                          | 411 +++++++++++++++++
 tools/include/uapi/linux/bpf.h                |   1 +
 tools/testing/selftests/bpf/Makefile          |   5 +-
 tools/testing/selftests/bpf/bench.c           |   6 +
 .../selftests/bpf/benchs/bench_tst_map.c      | 415 ++++++++++++++++++
 .../selftests/bpf/benchs/run_bench_tst.sh     |  54 +++
 tools/testing/selftests/bpf/progs/tst_bench.c |  70 +++
 10 files changed, 964 insertions(+), 1 deletion(-)
 create mode 100644 kernel/bpf/bpf_tst.c
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_tst_map.c
 create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_tst.sh
 create mode 100644 tools/testing/selftests/bpf/progs/tst_bench.c

-- 
2.31.1

