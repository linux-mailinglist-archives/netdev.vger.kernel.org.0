Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93BCB4D2ED8
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 13:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbiCIMPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 07:15:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbiCIMPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 07:15:50 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53B910CF2B;
        Wed,  9 Mar 2022 04:14:51 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KDB1L6070zfYkm;
        Wed,  9 Mar 2022 20:13:26 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Wed, 9 Mar
 2022 20:14:49 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        KP Singh <kpsingh@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next 0/4] fixes for bpf_jit_harden race
Date:   Wed, 9 Mar 2022 20:33:17 +0800
Message-ID: <20220309123321.2400262-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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

Now bpf_jit_harden will be tested twice for each subprog if there are
subprogs in bpf program and constant blinding may increase the length of
program, so when running "./test_progs -t subprogs" and toggling
bpf_jit_harden between 0 and 2, extra pass in bpf_int_jit_compile() may
fail because constant blinding increases the length of subprog and
the length is mismatched with the first pass.

The failure uncovers several issues in error handling of jit_subprogs()
and bpf_int_jit_compile():
(1) jit_subprogs() continues even when extra pass for one subprogs fails
It may leads to oops during to UAF. Fixed in patch #1.

(2) jit_subprogs() doesn't do proper cleanup for other subprogs which
    have not went through the extra pass.
It will lead to oops and memory leak. Fixed in patch #2. Other arch JIT
may have the same problem, and will fix later if the proposed fix for
x86-64 is accepted.

(3) bpf_int_jit_compile() may fail due to inconsistent twice read values
    from bpf_jit_harden
Fixed in patch #3 by caching the value of bpf_jit_blinding_enabled().

Patch #4 just adds a test to ensure these problem are fixed.

Comments and suggestions are welcome.

Regards,
Tao

Hou Tao (4):
  bpf, x86: Fall back to interpreter mode when extra pass fails
  bpf: Introduce bpf_int_jit_abort()
  bpf: Fix net.core.bpf_jit_harden race
  selftests/bpf: Test subprog jit when toggle bpf_jit_harden repeatedly

 arch/x86/net/bpf_jit_comp.c                   | 35 ++++++++-
 include/linux/filter.h                        |  2 +
 kernel/bpf/core.c                             | 12 ++-
 kernel/bpf/verifier.c                         |  8 +-
 .../selftests/bpf/prog_tests/subprogs.c       | 77 ++++++++++++++++---
 5 files changed, 120 insertions(+), 14 deletions(-)

-- 
2.29.2

