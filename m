Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 865852852E9
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 22:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727204AbgJFUKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 16:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727127AbgJFUKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 16:10:03 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C77C061755;
        Tue,  6 Oct 2020 13:10:02 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id o9so1758060plx.10;
        Tue, 06 Oct 2020 13:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ViqdCo4o0O+NExoem/jRAvLb43o6kK5ej35o66QUcEg=;
        b=ZJoILrjzpMprejq7LHOXPKHzW6iPo2QAW/9amCDZsZCxtR44eZ7PGMV8uJk4r3KS26
         1jxcZ8pzVetT7mIFePeEUE8zncQ4TKYtuizSgHYzPGOCwxW//xMCkx7V5tPE3fU8mNHP
         +8kmUUP5sqLnyLvJiPUJwyeEiYsGbLPswRiGr9zMvFfddM59SWj9bImncAyBUiRW1icc
         +OtIALP7rAQefYepMi5drbjyMx5Q5hnmNO7JreI/2ZdUZ8c5gioR7DbbLW4Oi2aed64G
         q2MaPcE5T7aB2kvJ6roaFK/xjge7KzwdhqLgOVE8tA37e3CbXds6m80JtMqi5KDzyW64
         SPyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ViqdCo4o0O+NExoem/jRAvLb43o6kK5ej35o66QUcEg=;
        b=Yrp+cb8fHHw7o1BDyowiN7gzwFpbQfiXWDXU0RzWYcbqdbLpK3hfxfhkcnWzIKdeSc
         LgLXiSrp2s441gvjrnFiJwqQCC3hjjDV3LPiZ9oJ7hywau3OuIYjUjEq1ldhS/GoA1o8
         CETiMdUQ+EZwRdl0aXj1nSmafqykYdjodolKJ7J4McuBv/7+wWLJqOU0pEm45GJS/oZ8
         d0bjk0VHYN9T0DOZCnBLDJ+RXqWuvwH61zWKsH4KJ6RLqor8Hj6bTviNM2+PXLDpxwvj
         uTVWoeuoDU9G1TY3dLbiGH39gHpE5O9jyR+Egu7xkcJtw3dZNKNGU/5Hqffm4CLRCbTN
         uRbg==
X-Gm-Message-State: AOAM533/s/30zBqpzwhLPUKOQYKWFMa+4tB0JijfCi7bpczy5y4OKL8d
        zv8Gl5I1DgqSriTUK5EIQPE=
X-Google-Smtp-Source: ABdhPJxgnXL88ypCoQtC3raC9etyvJbgbM2TOuNc9ZZEFSoYFRB6n8xU2bWShczCcdRmO1M+rc1WCw==
X-Received: by 2002:a17:90a:8a10:: with SMTP id w16mr5649508pjn.177.1602015002414;
        Tue, 06 Oct 2020 13:10:02 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id u18sm4358162pgk.18.2020.10.06.13.10.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Oct 2020 13:10:01 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 2/3] bpf: Track spill/fill of bounded scalars.
Date:   Tue,  6 Oct 2020 13:09:54 -0700
Message-Id: <20201006200955.12350-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20201006200955.12350-1-alexei.starovoitov@gmail.com>
References: <20201006200955.12350-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

Under register pressure the llvm may spill registers with bounds into the stack.
The verifier has to track them through spill/fill otherwise many kinds of bound
errors will be seen. The spill/fill of induction variables was already
happening. This patch extends this logic from tracking spill/fill of a constant
into any bounded register. There is no need to track spill/fill of unbounded,
since no new information will be retrieved from the stack during register fill.

Though extra stack difference could cause state pruning to be less effective, no
adverse affects were seen from this patch on selftests and on cilium programs.

Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/verifier.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 09e17b483b0b..7553ef14c2b1 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2227,6 +2227,20 @@ static bool register_is_const(struct bpf_reg_state *reg)
 	return reg->type == SCALAR_VALUE && tnum_is_const(reg->var_off);
 }
 
+static bool __is_scalar_unbounded(struct bpf_reg_state *reg)
+{
+	return tnum_is_unknown(reg->var_off) &&
+	       reg->smin_value == S64_MIN && reg->smax_value == S64_MAX &&
+	       reg->umin_value == 0 && reg->umax_value == U64_MAX &&
+	       reg->s32_min_value == S32_MIN && reg->s32_max_value == S32_MAX &&
+	       reg->u32_min_value == 0 && reg->u32_max_value == U32_MAX;
+}
+
+static bool register_is_bounded(struct bpf_reg_state *reg)
+{
+	return reg->type == SCALAR_VALUE && !__is_scalar_unbounded(reg);
+}
+
 static bool __is_pointer_value(bool allow_ptr_leaks,
 			       const struct bpf_reg_state *reg)
 {
@@ -2278,7 +2292,7 @@ static int check_stack_write(struct bpf_verifier_env *env,
 	if (value_regno >= 0)
 		reg = &cur->regs[value_regno];
 
-	if (reg && size == BPF_REG_SIZE && register_is_const(reg) &&
+	if (reg && size == BPF_REG_SIZE && register_is_bounded(reg) &&
 	    !register_is_null(reg) && env->bpf_capable) {
 		if (dst_reg != BPF_REG_FP) {
 			/* The backtracking logic can only recognize explicit
-- 
2.23.0

