Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E41261EEBF
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 10:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbiKGJXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 04:23:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbiKGJXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 04:23:49 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C70656E;
        Mon,  7 Nov 2022 01:23:48 -0800 (PST)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N5QlJ0H8NzRnsk;
        Mon,  7 Nov 2022 17:23:40 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 17:23:46 +0800
Received: from ubuntu1804.huawei.com (10.67.174.61) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 17:23:45 +0800
From:   Yang Jihong <yangjihong1@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>,
        <illusionist.neo@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <mykolal@fb.com>, <shuah@kernel.org>,
        <benjamin.tissoires@redhat.com>, <memxor@gmail.com>,
        <asavkov@redhat.com>, <delyank@fb.com>, <bpf@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>
CC:     <yangjihong1@huawei.com>
Subject: [PATCH bpf v2 0/5] bpf: Support kernel function call in 32-bit ARM
Date:   Mon, 7 Nov 2022 17:20:27 +0800
Message-ID: <20221107092032.178235-1-yangjihong1@huawei.com>
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

1. Patch1 is dependent patch to fix zext extension error in 32-bit ARM.
2. Patch2 and patch3 solve the problem that the bpf check fails because
   load's mem size is modified in CO_RE from the kernel and user modes,
   Currently, there are different opinions and a final solution needs to
   be selected.
3. Patch4 supports bpf fkunc in 32-bit ARM for EABI.
4. Patch5 is used to add test cases to cover some parameter scenarios
   states by AAPCS.

The following is the test_progs result in the 32-bit ARM environment:

  # uname -m
  armv7l
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


Yang Jihong (5):
  bpf: Adapt 32-bit return value kfunc for 32-bit ARM when zext
    extension
  bpf: Adjust sk size check for sk in bpf_skb_is_valid_access for CO_RE
    in 32-bit arch
  libbpf: Skip adjust mem size for load pointer in 32-bit arch in CO_RE
  bpf: Add kernel function call support in 32-bit ARM for EABI
  bpf:selftests: Add kfunc_call test for mixing 32-bit and 64-bit
    parameters

 arch/arm/net/bpf_jit_32.c                     | 142 ++++++++++++++++++
 kernel/bpf/verifier.c                         |   3 +
 net/bpf/test_run.c                            |  18 +++
 net/core/filter.c                             |   8 +-
 tools/lib/bpf/libbpf.c                        |  34 ++++-
 .../selftests/bpf/prog_tests/kfunc_call.c     |   3 +
 .../selftests/bpf/progs/kfunc_call_test.c     |  52 +++++++
 7 files changed, 254 insertions(+), 6 deletions(-)

-- 
2.30.GIT

