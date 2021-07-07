Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 170C33BE1A7
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 05:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbhGGDzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 23:55:44 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:10282 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbhGGDzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 23:55:31 -0400
Received: from dggeme751-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GKQNT5lhGz1CG6f;
        Wed,  7 Jul 2021 11:47:21 +0800 (CST)
Received: from k03.huawei.com (10.67.174.111) by
 dggeme751-chm.china.huawei.com (10.3.19.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 7 Jul 2021 11:52:49 +0800
From:   He Fengqing <hefengqing@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [bpf-next 2/3] bpf: Fix a memory leak in an error handling path in 'bpf_patch_insn_data()'
Date:   Wed, 7 Jul 2021 04:38:10 +0000
Message-ID: <20210707043811.5349-3-hefengqing@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210707043811.5349-1-hefengqing@huawei.com>
References: <20210707043811.5349-1-hefengqing@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.111]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme751-chm.china.huawei.com (10.3.19.97)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In bpf_patch_insn_data function, if adjust_insn_aux_data() return error,
we need to free new_prog.

Signed-off-by: He Fengqing <hefengqing@huawei.com>
---
 kernel/bpf/verifier.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index be38bb930bf1..41109f49b724 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11501,8 +11501,11 @@ static struct bpf_prog *bpf_patch_insn_data(struct bpf_verifier_env *env, u32 of
 				env->insn_aux_data[off].orig_idx);
 		return NULL;
 	}
-	if (adjust_insn_aux_data(env, new_prog, off, len))
+	if (adjust_insn_aux_data(env, new_prog, off, len)) {
+		if (new_prog != env->prog)
+			bpf_prog_clone_free(new_prog);
 		return NULL;
+	}
 	adjust_subprog_starts(env, off, len);
 	adjust_poke_descs(new_prog, off, len);
 	return new_prog;
-- 
2.25.1

