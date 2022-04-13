Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77ED64FEE91
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 07:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbiDMFkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 01:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbiDMFkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 01:40:01 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2310731226;
        Tue, 12 Apr 2022 22:37:39 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KdWYX5q7pz1HBpK;
        Wed, 13 Apr 2022 13:36:48 +0800 (CST)
Received: from huawei.com (10.67.174.197) by kwepemi500013.china.huawei.com
 (7.221.188.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 13 Apr
 2022 13:37:23 +0800
From:   Xu Kuohai <xukuohai@huawei.com>
To:     <bpf@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>
CC:     Will Deacon <will@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, <x86@kernel.org>,
        <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Peter Collingbourne <pcc@google.com>,
        Daniel Kiss <daniel.kiss@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Steven Price <steven.price@arm.com>,
        Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Delyan Kratunov <delyank@fb.com>
Subject: [PATCH bpf-next 0/5] bpf trampoline for arm64
Date:   Wed, 13 Apr 2022 01:49:54 -0400
Message-ID: <20220413054959.1053668-1-xukuohai@huawei.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.197]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bpf trampoline support for arm64. Most of the logic is the same as
x86.

Tested on qemu, result:
 #55 fentry_fexit:OK
 #56 fentry_test:OK
 #58 fexit_sleep:OK
 #59 fexit_stress:OK
 #60 fexit_test:OK
 #67 get_func_args_test:OK
 #68 get_func_ip_test:OK
 #101 modify_return:OK

Xu Kuohai (5):
  arm64: ftrace: Add ftrace direct call support
  bpf: Move is_valid_bpf_tramp_flags() to the public trampoline code
  bpf, arm64: Impelment bpf_arch_text_poke() for arm64
  bpf, arm64: bpf trampoline for arm64
  selftests/bpf: Fix trivial typo in fentry_fexit.c

 arch/arm64/Kconfig                            |   2 +
 arch/arm64/include/asm/ftrace.h               |  10 +
 arch/arm64/kernel/asm-offsets.c               |   1 +
 arch/arm64/kernel/entry-ftrace.S              |  18 +-
 arch/arm64/net/bpf_jit.h                      |  14 +-
 arch/arm64/net/bpf_jit_comp.c                 | 390 +++++++++++++++++-
 arch/x86/net/bpf_jit_comp.c                   |  20 -
 include/linux/bpf.h                           |   5 +
 kernel/bpf/bpf_struct_ops.c                   |   4 +-
 kernel/bpf/trampoline.c                       |  36 +-
 .../selftests/bpf/prog_tests/fentry_fexit.c   |   4 +-
 11 files changed, 470 insertions(+), 34 deletions(-)

-- 
2.30.2

