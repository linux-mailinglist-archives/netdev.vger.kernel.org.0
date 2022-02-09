Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39DCC4AEE14
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 10:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiBIJey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 04:34:54 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:37206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235468AbiBIJbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 04:31:22 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7EC3E010907;
        Wed,  9 Feb 2022 01:31:16 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JtvHp5ph0zbk5J;
        Wed,  9 Feb 2022 17:11:02 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Wed, 9 Feb
 2022 17:12:03 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <houtao1@huawei.com>
Subject: [PATCH bpf-next v3] bpf: reject kfunc calls that overflow insn->imm
Date:   Wed, 9 Feb 2022 17:11:53 +0800
Message-ID: <20220209091153.54116-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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

Now kfunc call uses s32 to represent the offset between the address
of kfunc and __bpf_call_base, but it doesn't check whether or not
s32 will be overflowed, so add an extra checking to reject these
invalid kfunc calls.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
v3:
 * call BPF_CALL_IMM() once (suggested by Yonghong)

v2: https://lore.kernel.org/bpf/20220208123348.40360-1-houtao1@huawei.com
 * instead of checking the overflow in selftests, just reject
   these kfunc calls directly in verifier

v1: https://lore.kernel.org/bpf/20220206043107.18549-1-houtao1@huawei.com
---
 kernel/bpf/verifier.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1ae41d0cf96c..eb72e6139e2b 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1842,6 +1842,7 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id, s16 offset)
 	struct bpf_kfunc_desc *desc;
 	const char *func_name;
 	struct btf *desc_btf;
+	unsigned long call_imm;
 	unsigned long addr;
 	int err;
 
@@ -1926,9 +1927,17 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id, s16 offset)
 		return -EINVAL;
 	}
 
+	call_imm = BPF_CALL_IMM(addr);
+	/* Check whether or not the relative offset overflows desc->imm */
+	if ((unsigned long)(s32)call_imm != call_imm) {
+		verbose(env, "address of kernel function %s is out of range\n",
+			func_name);
+		return -EINVAL;
+	}
+
 	desc = &tab->descs[tab->nr_descs++];
 	desc->func_id = func_id;
-	desc->imm = BPF_CALL_IMM(addr);
+	desc->imm = call_imm;
 	desc->offset = offset;
 	err = btf_distill_func_proto(&env->log, desc_btf,
 				     func_proto, func_name,
-- 
2.27.0

