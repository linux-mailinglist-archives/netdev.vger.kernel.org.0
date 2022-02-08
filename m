Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53B084AD89B
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 14:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbiBHNP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 08:15:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348514AbiBHMeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 07:34:02 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6070C03FEC0;
        Tue,  8 Feb 2022 04:34:00 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4JtMlZ1JzFz1FCjK;
        Tue,  8 Feb 2022 20:29:46 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Tue, 8 Feb
 2022 20:33:57 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <houtao1@huawei.com>
Subject: [PATCH bpf-next v2] bpf: reject kfunc calls that overflow insn->imm
Date:   Tue, 8 Feb 2022 20:33:48 +0800
Message-ID: <20220208123348.40360-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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
v2:
 * instead of checking the overflow in selftests, just reject
   these kfunc calls directly in verifier

v1: https://lore.kernel.org/bpf/20220206043107.18549-1-houtao1@huawei.com
---
 kernel/bpf/verifier.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a39eedecc93a..fd836e64b701 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1832,6 +1832,13 @@ static struct btf *find_kfunc_desc_btf(struct bpf_verifier_env *env,
 	return btf_vmlinux ?: ERR_PTR(-ENOENT);
 }
 
+static inline bool is_kfunc_call_imm_overflowed(unsigned long addr)
+{
+	unsigned long offset = BPF_CALL_IMM(addr);
+
+	return (unsigned long)(s32)offset != offset;
+}
+
 static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id, s16 offset)
 {
 	const struct btf_type *func, *func_proto;
@@ -1925,6 +1932,12 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id, s16 offset)
 		return -EINVAL;
 	}
 
+	if (is_kfunc_call_imm_overflowed(addr)) {
+		verbose(env, "address of kernel function %s is out of range\n",
+			func_name);
+		return -EINVAL;
+	}
+
 	desc = &tab->descs[tab->nr_descs++];
 	desc->func_id = func_id;
 	desc->imm = BPF_CALL_IMM(addr);
-- 
2.29.2

