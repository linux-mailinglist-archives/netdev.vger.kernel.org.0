Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBAC660F45B
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 12:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235039AbiJ0KDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 06:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234997AbiJ0KDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 06:03:14 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD51D48CAC;
        Thu, 27 Oct 2022 03:02:59 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Myh3j1T3qzpVxx;
        Thu, 27 Oct 2022 17:59:29 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 18:02:55 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <yhs@fb.com>, <joe@wand.net.nz>
Subject: [PATCH net] bpf: Fix memory leaks in __check_func_call
Date:   Thu, 27 Oct 2022 18:23:33 +0800
Message-ID: <1666866213-4394-1-git-send-email-wangyufen@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kmemleak reports this issue:

unreferenced object 0xffff88817139d000 (size 2048):
  comm "test_progs", pid 33246, jiffies 4307381979 (age 45851.820s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000045f075f0>] kmalloc_trace+0x27/0xa0
    [<0000000098b7c90a>] __check_func_call+0x316/0x1230
    [<00000000b4c3c403>] check_helper_call+0x172e/0x4700
    [<00000000aa3875b7>] do_check+0x21d8/0x45e0
    [<000000001147357b>] do_check_common+0x767/0xaf0
    [<00000000b5a595b4>] bpf_check+0x43e3/0x5bc0
    [<0000000011e391b1>] bpf_prog_load+0xf26/0x1940
    [<0000000007f765c0>] __sys_bpf+0xd2c/0x3650
    [<00000000839815d6>] __x64_sys_bpf+0x75/0xc0
    [<00000000946ee250>] do_syscall_64+0x3b/0x90
    [<0000000000506b7f>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

The root case here is: In function prepare_func_exit(), the callee is
not released in the abnormal scenario after "state->curframe--;".

In addition, function __check_func_call() has a similar problem. In
the abnormal scenario before "state->curframe++;", the callee is alse
not released.

Fixes: 69c087ba6225 ("bpf: Add bpf_for_each_map_elem() helper")
Fixes: fd978bf7fd31 ("bpf: Add reference tracking to verifier")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
---
 kernel/bpf/verifier.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 014ee09..bff8477 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6736,11 +6736,11 @@ static int __check_func_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 	/* Transfer references to the callee */
 	err = copy_reference_state(callee, caller);
 	if (err)
-		return err;
+		goto err;
 
 	err = set_callee_state_cb(env, caller, callee, *insn_idx);
 	if (err)
-		return err;
+		goto err;
 
 	clear_caller_saved_regs(env, caller->regs);
 
@@ -6757,6 +6757,10 @@ static int __check_func_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 		print_verifier_state(env, callee, true);
 	}
 	return 0;
+
+err:
+	kfree(callee);
+	return err;
 }
 
 int map_set_for_each_callback_args(struct bpf_verifier_env *env,
@@ -6954,7 +6958,7 @@ static int prepare_func_exit(struct bpf_verifier_env *env, int *insn_idx)
 	struct bpf_verifier_state *state = env->cur_state;
 	struct bpf_func_state *caller, *callee;
 	struct bpf_reg_state *r0;
-	int err;
+	int ret;
 
 	callee = state->frame[state->curframe];
 	r0 = &callee->regs[BPF_REG_0];
@@ -6977,11 +6981,13 @@ static int prepare_func_exit(struct bpf_verifier_env *env, int *insn_idx)
 
 		if (r0->type != SCALAR_VALUE) {
 			verbose(env, "R0 not a scalar value\n");
-			return -EACCES;
+			ret = -EACCES;
+			goto out;
 		}
 		if (!tnum_in(range, r0->var_off)) {
 			verbose_invalid_scalar(env, r0, &range, "callback return", "R0");
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out;
 		}
 	} else {
 		/* return to the caller whatever r0 had in the callee */
@@ -6995,9 +7001,9 @@ static int prepare_func_exit(struct bpf_verifier_env *env, int *insn_idx)
 	 */
 	if (!callee->in_callback_fn) {
 		/* Transfer references to the caller */
-		err = copy_reference_state(caller, callee);
-		if (err)
-			return err;
+		ret = copy_reference_state(caller, callee);
+		if (ret)
+			goto out;
 	}
 
 	*insn_idx = callee->callsite + 1;
@@ -7008,9 +7014,10 @@ static int prepare_func_exit(struct bpf_verifier_env *env, int *insn_idx)
 		print_verifier_state(env, caller, true);
 	}
 	/* clear everything in the callee */
+out:
 	free_func_state(callee);
 	state->frame[state->curframe + 1] = NULL;
-	return 0;
+	return ret;
 }
 
 static void do_refine_retval_range(struct bpf_reg_state *regs, int ret_type,
-- 
1.8.3.1

