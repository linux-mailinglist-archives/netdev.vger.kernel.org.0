Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96DB287FD4
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 03:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730038AbgJIBMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 21:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgJIBMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 21:12:47 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D6EC0613D2;
        Thu,  8 Oct 2020 18:12:47 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id h2so3631165pll.11;
        Thu, 08 Oct 2020 18:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oWSvJ+rWKZMheuz0pqnRW7O1PJlBra3FOC/0Erku6ZM=;
        b=RZ6dkBkd3wtLIHnrI/e6sEOjJZsUOjkIRJ2bErt/Y0WZ30BHj0qXcjexvwiUDHSGtG
         IfmmF3PdVoGTXgwB6wbXHbccbA+3M/5Rs6oF19BJymb/8HzblLVJ7CZNXe6OGHwNRbpu
         tCBR5Qvw9LIFJdkBed7nuOxKob7i8x/zA6FfxIUh1ShhqlCWU2ajHKlne6CuXBLEY9ML
         mcssadg5QfDgeMDRIkE67aimqFavnGNtNMoEErekfR7FeTAm19x0Y5uSs+fYf/vKLVl1
         zSdM0OuSfBHC6A3Ixuv4+3BHNvGGPvULtwchqBiUXjXyweCvyNhsysrjdeDuyiPzhftH
         nZdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oWSvJ+rWKZMheuz0pqnRW7O1PJlBra3FOC/0Erku6ZM=;
        b=q+ZCQeQhzzCt98C4ZVYaZt374u0efUa8fxZvjRyyghVcbcKgdNAu8GYLB/a3m+q7HR
         zneQ8g4jJz3qygFmjSw27F2XstzymRPIruyki4Wd365V4mEZ30lEtGHyvgiGjGUtySMK
         DeZNyeCIT1a+yRNEsLWezk54iTTmO5kXeAoGmdAWUu3AoBTt2/Ku83aZq/JYOm0RIgbw
         xpv1ElDKkxTG3Fz8mIyXKbOCnjXxe7q0c7v5aGFtvOGnGSdJ9l6bEDLKodyAQo/y92sE
         RE0MygbD2zph2kEKtj44LJrR75tiiAG58RU2gcTZ8eCf+hgm4+fnY2xa26hAMpN5wJbe
         1/OA==
X-Gm-Message-State: AOAM5327/lbNq0kOZp52Nfb+64f9jbi5QphofPZjsXxBazUxKcKpbOY1
        AcaReNEHQ0Gn858g5Sxze0U=
X-Google-Smtp-Source: ABdhPJwbVYbVR1WrQ7qrqZT+uK81zxFPpHvsm9D2khcxhL2AfrAhsfwr8F8jWkA6U72MUeovV+wh+w==
X-Received: by 2002:a17:902:7286:b029:d4:bb66:3f10 with SMTP id d6-20020a1709027286b02900d4bb663f10mr3281217pll.52.1602205967202;
        Thu, 08 Oct 2020 18:12:47 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id k15sm8275822pfp.217.2020.10.08.18.12.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Oct 2020 18:12:46 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 bpf-next 2/4] bpf: Track spill/fill of bounded scalars.
Date:   Thu,  8 Oct 2020 18:12:38 -0700
Message-Id: <20201009011240.48506-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20201009011240.48506-1-alexei.starovoitov@gmail.com>
References: <20201009011240.48506-1-alexei.starovoitov@gmail.com>
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
Acked-by: Andrii Nakryiko <andrii@kernel.org>
---
 kernel/bpf/verifier.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ba96f7e9bbc0..f3e36eade3d4 100644
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

