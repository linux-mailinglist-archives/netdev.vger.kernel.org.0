Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9349053786D
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 12:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234510AbiE3I6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 04:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234068AbiE3I6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 04:58:34 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63ACC762AA;
        Mon, 30 May 2022 01:58:33 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4LBTpQ1zKHzDqZ2;
        Mon, 30 May 2022 16:58:22 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 30 May 2022 16:58:31 +0800
Received: from k04.huawei.com (10.67.174.115) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 30 May 2022 16:58:31 +0800
From:   Pu Lehui <pulehui@huawei.com>
To:     <bpf@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Pu Lehui <pulehui@huawei.com>
Subject: [PATCH bpf-next v3 0/6] Support riscv jit to provide
Date:   Mon, 30 May 2022 17:28:09 +0800
Message-ID: <20220530092815.1112406-1-pulehui@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.115]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500019.china.huawei.com (7.185.36.180)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

patch 1 fix an issue that could not print bpf line info due
to data inconsistency in 32-bit environment.

patch 2 add support for riscv jit to provide bpf_line_info.
"test_progs -a btf" and "test_bpf.ko" all test pass, as well
as "test_verifier" and "test_progs" with no new failure ceses.

patch 3-6 make some trival cleanup.

v3:
- split kernel changes, libbpf changes, and selftests/bpf changes
into separate patches. (Andrii)
- shorten the name of jited_linfo_addr to avoid line break. (John)
- rename prologue_offset to body_len to make it more sense. (Luke)

v2: https://lore.kernel.org/bpf/20220429014240.3434866-1-pulehui@huawei.com
- Remove some trivial code

v1: https://lore.kernel.org/bpf/20220426140924.3308472-1-pulehui@huawei.com

Pu Lehui (6):
  bpf: Unify data extension operation of jited_ksyms and jited_linfo
  riscv, bpf: Support riscv jit to provide bpf_line_info
  bpf: Correct the comment about insn_to_jit_off
  libbpf: Unify memory address casting operation style
  selftests/bpf: Unify memory address casting operation style
  selftests/bpf: Remove the casting about jited_ksyms and jited_linfo

 arch/riscv/net/bpf_jit.h                     |  1 +
 arch/riscv/net/bpf_jit_core.c                |  8 +++++++-
 kernel/bpf/core.c                            |  2 +-
 kernel/bpf/syscall.c                         |  5 +++--
 tools/lib/bpf/bpf_prog_linfo.c               |  9 +++++----
 tools/testing/selftests/bpf/prog_tests/btf.c | 18 +++++++++---------
 6 files changed, 26 insertions(+), 17 deletions(-)

-- 
2.25.1

