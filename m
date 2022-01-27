Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8493A49F580
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 09:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243172AbiA1Il6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 03:41:58 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:17824 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243167AbiA1Ilz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 03:41:55 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JlWB820s3z9sbl;
        Fri, 28 Jan 2022 16:40:32 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Fri, 28 Jan
 2022 16:41:48 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <houtao1@huawei.com>, Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@arm.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH bpf-next v2 1/2] bpf, arm64: enable kfunc call
Date:   Thu, 27 Jan 2022 15:15:31 +0800
Message-ID: <20220127071532.384888-2-houtao1@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220127071532.384888-1-houtao1@huawei.com>
References: <20220127071532.384888-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit b2eed9b58811 ("arm64/kernel: kaslr: reduce module
randomization range to 2 GB"), for arm64 whether KASLR is enabled
or not, the module is placed within 2GB of the kernel region, so
s32 in bpf_kfunc_desc is sufficient to represente the offset of
module function relative to __bpf_call_base. The only thing needed
is to override bpf_jit_supports_kfunc_call().

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 arch/arm64/net/bpf_jit_comp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 6d92f363028c..e60c464004c2 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -1284,6 +1284,11 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	return prog;
 }
 
+bool bpf_jit_supports_kfunc_call(void)
+{
+	return true;
+}
+
 u64 bpf_jit_alloc_exec_limit(void)
 {
 	return VMALLOC_END - VMALLOC_START;
-- 
2.27.0

