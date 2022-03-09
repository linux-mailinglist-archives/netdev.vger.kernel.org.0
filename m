Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C634B4D2EDB
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 13:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbiCIMPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 07:15:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbiCIMPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 07:15:51 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD5210CF30;
        Wed,  9 Mar 2022 04:14:52 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KD9xP1tBNz1GCH6;
        Wed,  9 Mar 2022 20:10:01 +0800 (CST)
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
Subject: [PATCH bpf-next 1/4] bpf, x86: Fall back to interpreter mode when extra pass fails
Date:   Wed, 9 Mar 2022 20:33:18 +0800
Message-ID: <20220309123321.2400262-2-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220309123321.2400262-1-houtao1@huawei.com>
References: <20220309123321.2400262-1-houtao1@huawei.com>
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

Extra pass for subprog jit may fail (e.g. due to bpf_jit_harden race),
but bpf_func is not cleared for the subprog and jit_subprogs will
succeed. The running of the bpf program may lead to oops because the
memory for the jited subprog image has already been freed.

So fall back to interpreter mode by clearing bpf_func/jited/jited_len
when extra pass fails.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 arch/x86/net/bpf_jit_comp.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index e6ff8f4f9ea4..ec3f00be2ac5 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -2335,7 +2335,13 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 						   sizeof(rw_header->size));
 				bpf_jit_binary_pack_free(header, rw_header);
 			}
+			/* Fall back to interpreter mode */
 			prog = orig_prog;
+			if (extra_pass) {
+				prog->bpf_func = NULL;
+				prog->jited = 0;
+				prog->jited_len = 0;
+			}
 			goto out_addrs;
 		}
 		if (image) {
@@ -2384,8 +2390,9 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 			 * Both cases are serious bugs and justify WARN_ON.
 			 */
 			if (WARN_ON(bpf_jit_binary_pack_finalize(prog, header, rw_header))) {
-				prog = orig_prog;
-				goto out_addrs;
+				/* header has been freed */
+				header = NULL;
+				goto out_image;
 			}
 
 			bpf_tail_call_direct_fixup(prog);
-- 
2.29.2

