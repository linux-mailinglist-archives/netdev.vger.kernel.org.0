Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 597E91A6B08
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 19:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729039AbgDMLfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 07:35:12 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:58814 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728960AbgDMLfL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 07:35:11 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id AD1E02C3D16DCE273A7E;
        Mon, 13 Apr 2020 19:35:07 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Mon, 13 Apr 2020 19:35:06 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <andriin@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] bpf: remove set but not used variable 'dst_known'
Date:   Mon, 13 Apr 2020 19:37:03 +0800
Message-ID: <20200413113703.194287-1-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

kernel/bpf/verifier.c:5603:18: warning: variable ‘dst_known’
set but not used [-Wunused-but-set-variable]

It is not used since commit f1174f77b50c ("bpf/verifier:
rework value tracking")

Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 kernel/bpf/verifier.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 04c6630cc18f..c9f50969a689 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5600,7 +5600,7 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 {
 	struct bpf_reg_state *regs = cur_regs(env);
 	u8 opcode = BPF_OP(insn->code);
-	bool src_known, dst_known;
+	bool src_known;
 	s64 smin_val, smax_val;
 	u64 umin_val, umax_val;
 	s32 s32_min_val, s32_max_val;
@@ -5622,7 +5622,6 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 
 	if (alu32) {
 		src_known = tnum_subreg_is_const(src_reg.var_off);
-		dst_known = tnum_subreg_is_const(dst_reg->var_off);
 		if ((src_known &&
 		     (s32_min_val != s32_max_val || u32_min_val != u32_max_val)) ||
 		    s32_min_val > s32_max_val || u32_min_val > u32_max_val) {
@@ -5634,7 +5633,6 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 		}
 	} else {
 		src_known = tnum_is_const(src_reg.var_off);
-		dst_known = tnum_is_const(dst_reg->var_off);
 		if ((src_known &&
 		     (smin_val != smax_val || umin_val != umax_val)) ||
 		    smin_val > smax_val || umin_val > umax_val) {
-- 
2.17.1

