Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B661C6130D9
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 08:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiJaHBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 03:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJaHA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 03:00:58 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7183F9590;
        Mon, 31 Oct 2022 00:00:57 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4N13rW5pnszJnNL;
        Mon, 31 Oct 2022 14:58:03 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 31 Oct
 2022 15:00:54 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>
CC:     <john.fastabend@gmail.com>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>,
        <jolsa@kernel.org>, <lmb@cloudflare.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH bpf-next] bpf: fix memory leak in grow_stack_state()
Date:   Mon, 31 Oct 2022 15:08:12 +0800
Message-ID: <20221031070812.339883-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The realloc_array() fails, but the previous memory is not released.
However, state->stack and state->refs are set to NULL. This will
cause memory leakage.

The memory leak information is as follows:
unreferenced object 0xffff888019801800 (size 256):
  comm "bpf_repo", pid 6490, jiffies 4294959200 (age 17.170s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000b211474b>] __kmalloc_node_track_caller+0x45/0xc0
    [<0000000086712a0b>] krealloc+0x83/0xd0
    [<00000000139aab02>] realloc_array+0x82/0xe2
    [<00000000b1ca41d1>] grow_stack_state+0xfb/0x186
    [<00000000cd6f36d2>] check_mem_access.cold+0x141/0x1341
    [<0000000081780455>] do_check_common+0x5358/0xb350
    [<0000000015f6b091>] bpf_check.cold+0xc3/0x29d
    [<000000002973c690>] bpf_prog_load+0x13db/0x2240
    [<00000000028d1644>] __sys_bpf+0x1605/0x4ce0
    [<00000000053f29bd>] __x64_sys_bpf+0x75/0xb0
    [<0000000056fedaf5>] do_syscall_64+0x35/0x80
    [<000000002bd58261>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: c69431aab67a ("bpf: verifier: Improve function state reallocation")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 kernel/bpf/verifier.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 7f0a9f6cb889..c0b0cc2891e3 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1027,12 +1027,16 @@ static void *copy_array(void *dst, const void *src, size_t n, size_t size, gfp_t
  */
 static void *realloc_array(void *arr, size_t old_n, size_t new_n, size_t size)
 {
+	void *old_arr = arr;
+
 	if (!new_n || old_n == new_n)
 		goto out;
 
 	arr = krealloc_array(arr, new_n, size, GFP_KERNEL);
-	if (!arr)
+	if (!arr) {
+		kfree(old_arr);
 		return NULL;
+	}
 
 	if (new_n > old_n)
 		memset(arr + old_n * size, 0, (new_n - old_n) * size);
-- 
2.17.1

