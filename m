Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E52C16178D0
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 09:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbiKCIgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 04:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiKCIgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 04:36:13 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B8926DF;
        Thu,  3 Nov 2022 01:36:12 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N2xpD3fL5zpW5r;
        Thu,  3 Nov 2022 16:32:36 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 16:36:10 +0800
Received: from ubuntu1804.huawei.com (10.67.174.61) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 16:36:09 +0800
From:   Yang Jihong <yangjihong1@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>,
        <illusionist.neo@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <mykolal@fb.com>, <shuah@kernel.org>,
        <benjamin.tissoires@redhat.com>, <memxor@gmail.com>,
        <delyank@fb.com>, <asavkov@redhat.com>, <colin.i.king@gmail.com>,
        <bpf@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>
CC:     <yangjihong1@huawei.com>
Subject: [PATCH 0/4] bpf: Support kernel function call in 32-bit ARM
Date:   Thu, 3 Nov 2022 16:32:50 +0800
Message-ID: <20221103083254.237646-1-yangjihong1@huawei.com>
X-Mailer: git-send-email 2.30.GIT
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.61]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. Patch 1 and Patch 2 are dependent patches to resolve the BPF check error in
   32-bit ARM.
2. Patch 3 supports bpf fkunc in 32-bit ARM.
3. Patch 4 is used to add test cases to cover some parameter scenarios states
   by AAPCS.

The following is the test_progs result in the 32-bit ARM environment:

  # uname -a
  Linux qemuarm32 6.1.0-rc3+ #2 SMP Thu Nov  3 15:31:29 CST 2022 armv7l armv7l armv7l GNU/Linux
  # echo 1 > /proc/sys/net/core/bpf_jit_enable
  # ./test_progs -t kfunc_call
  #1/1     kfunc_call/kfunc_syscall_test_fail:OK
  #1/2     kfunc_call/kfunc_syscall_test_null_fail:OK
  #1/3     kfunc_call/kfunc_call_test_get_mem_fail_rdonly:OK
  #1/4     kfunc_call/kfunc_call_test_get_mem_fail_use_after_free:OK
  #1/5     kfunc_call/kfunc_call_test_get_mem_fail_oob:OK
  #1/6     kfunc_call/kfunc_call_test_get_mem_fail_not_const:OK
  #1/7     kfunc_call/kfunc_call_test_mem_acquire_fail:OK
  #1/8     kfunc_call/kfunc_call_test1:OK
  #1/9     kfunc_call/kfunc_call_test2:OK
  #1/10    kfunc_call/kfunc_call_test4:OK
  #1/11    kfunc_call/kfunc_call_test_ref_btf_id:OK
  #1/12    kfunc_call/kfunc_call_test_get_mem:OK
  #1/13    kfunc_call/kfunc_syscall_test:OK
  #1/14    kfunc_call/kfunc_syscall_test_null:OK
  #1/17    kfunc_call/destructive:OK

Yang Jihong (4):
  bpf: Adapt 32-bit return value kfunc for 32-bit ARM when zext
    extension
  bpf: Remove size check for sk in bpf_skb_is_valid_access for 32-bit
    architecture
  bpf: Add kernel function call support in 32-bit ARM
  bpf:selftests: Add kfunc_call test for mixing 32-bit and 64-bit
    parameters

 arch/arm/net/bpf_jit_32.c                     | 130 ++++++++++++++++++
 kernel/bpf/verifier.c                         |   3 +
 net/bpf/test_run.c                            |   6 +
 net/core/filter.c                             |   2 -
 .../selftests/bpf/prog_tests/kfunc_call.c     |   1 +
 .../selftests/bpf/progs/kfunc_call_test.c     |  23 ++++
 6 files changed, 163 insertions(+), 2 deletions(-)

-- 
2.30.GIT

