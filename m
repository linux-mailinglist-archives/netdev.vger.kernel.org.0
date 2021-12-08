Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A45046CB66
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 04:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243801AbhLHDI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 22:08:28 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:28286 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243835AbhLHDI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 22:08:26 -0500
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J8288504BzbjHm;
        Wed,  8 Dec 2021 11:04:40 +0800 (CST)
Received: from ubuntu1804.huawei.com (10.67.174.58) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 8 Dec 2021 11:04:53 +0800
From:   Xiu Jianfeng <xiujianfeng@huawei.com>
To:     <akpm@linux-foundation.org>, <keescook@chromium.org>,
        <laniel_francis@privacyrequired.com>,
        <andriy.shevchenko@linux.intel.com>, <adobriyan@gmail.com>,
        <linux@roeck-us.net>, <andreyknvl@gmail.com>, <dja@axtens.net>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: [PATCH -next 2/2] bpf: use memset_range helper in __mark_reg_known
Date:   Wed, 8 Dec 2021 11:04:51 +0800
Message-ID: <20211208030451.219751-3-xiujianfeng@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211208030451.219751-1-xiujianfeng@huawei.com>
References: <20211208030451.219751-1-xiujianfeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.174.58]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the open-coded memset with memset_range helper to simplify
the code, there is no functional change in this patch.

Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
---
 kernel/bpf/verifier.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 7a20e12f2e45..317f259c0103 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1099,9 +1099,8 @@ static void ___mark_reg_known(struct bpf_reg_state *reg, u64 imm)
  */
 static void __mark_reg_known(struct bpf_reg_state *reg, u64 imm)
 {
-	/* Clear id, off, and union(map_ptr, range) */
-	memset(((u8 *)reg) + sizeof(reg->type), 0,
-	       offsetof(struct bpf_reg_state, var_off) - sizeof(reg->type));
+	/* Clear off, union(map_ptr, range), id, and ref_obj_id */
+	memset_range(reg, 0, off, ref_obj_id);
 	___mark_reg_known(reg, imm);
 }
 
-- 
2.17.1

