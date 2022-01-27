Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B529649DC61
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 09:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237703AbiA0IRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 03:17:30 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:32065 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237716AbiA0IR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 03:17:29 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4JktdQ6Ypfz1FD6m;
        Thu, 27 Jan 2022 16:13:30 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Thu, 27 Jan
 2022 16:17:25 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Brendan Jackman <jackmanb@google.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <houtao1@huawei.com>
Subject: [PATCH bpf-next] bpf, x86: remove unnecessary handling of BPF_SUB atomic op
Date:   Thu, 27 Jan 2022 16:32:40 +0800
Message-ID: <20220127083240.1425481-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the LLVM commit (https://reviews.llvm.org/D72184),
sync_fetch_and_sub() is implemented as a negation followed by
sync_fetch_and_add(), so there will be no BPF_SUB op and just
remove it.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 arch/x86/net/bpf_jit_comp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index ce1f86f245c9..5d643ebb1e56 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -787,7 +787,6 @@ static int emit_atomic(u8 **pprog, u8 atomic_op,
 	/* emit opcode */
 	switch (atomic_op) {
 	case BPF_ADD:
-	case BPF_SUB:
 	case BPF_AND:
 	case BPF_OR:
 	case BPF_XOR:
-- 
2.29.2

