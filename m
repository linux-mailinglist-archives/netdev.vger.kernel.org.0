Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 271F334293F
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 01:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhCTAAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 20:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbhCTAAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 20:00:04 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7688AC061761
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 17:00:04 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id u8so33131960qvm.5
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 17:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=oRO6V4kyhNwQVkxp5wVbKiww18hZhgJE1+XBqqpontc=;
        b=VQh+b2d6VkDVIwEEIF+paEKHKEfS0TJoMYaysVLIkKKNcJhMCLGIVu95R+5VnR+tu2
         hod1FyumjnvNRY/4uoelmWc2S2H3GiQNi8JdCXGJrQUhsfG5SNhqePX23QyyZ5sXzf/T
         ftdozoHDn6kEblaYjZ6lr26oEUYVyLZRbgNost/pr0FEtZWy0giO2o8JyyC30CSLxIYH
         mUpsGgTJOrHFNmNV3Ed/ZjvZQJLuKRk5eXPRstjQgaqI354oEEhqw9mZBzw03eRVkr6N
         ff/L7GiO32Cfedjyx7Ebr3bGOHS/o6HYuvQg3N21FEC/xDm30FGfwWfLXUl3MdAK3gUn
         O0nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=oRO6V4kyhNwQVkxp5wVbKiww18hZhgJE1+XBqqpontc=;
        b=AQkvvP1QRIvR8m9l7ny95rfWVkdenagA0T1AV2n1hyHS9v87JomTFxk03mEL/Yz0hw
         6NOCkIV5CGDDU3+vMBbrDp/mbRln8qcR2vuQdrUH/Je3301aIlqND4SUGjc1rW9UiHsC
         cMjGFsVBSpa8ncXNoxq4JxGYGFDEb9jjngGyRG+EiblnCBdoh7YIM7KAWX0ofNu7jhGE
         P1vRLtbazGMXRXD2VNVnZsgTfy2OyliKTasWyOWIAoMRU+Bb/Z3P8twwGB2NIYWLKoem
         DXFFoR6npVEgAXPIohYdP2R2SGz+vAyD9KTWXXf0WEd5NqWTDoKeuPrc93AmwCefBEL0
         cX5A==
X-Gm-Message-State: AOAM5327WDIlfoHobRFFFwPGdXeyK78juwMGFE6WnJVB6pwOgoECMX32
        KPbXdv1WJ9OgR41dHHB6wjj7ssZLDxHoUhkX7ZcFhHRIW1T7pqAQ7AMjrHo91WGFRv9WM0g7FEr
        k2gyK/pCa7u3lqxR5x0MRgO8UhGb05v+2OeNApT3aF79MmBIIx8zIwg==
X-Google-Smtp-Source: ABdhPJxxoeyk2e7+jO81gnWwZkF5t6YzHc9GgpqG0Tc6GN6B5aRFsd8KkR8zISnPEJ2qi6/O4Agns+U=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:c149:3008:7703:e722])
 (user=sdf job=sendgmr) by 2002:a0c:df02:: with SMTP id g2mr11730912qvl.40.1616198403418;
 Fri, 19 Mar 2021 17:00:03 -0700 (PDT)
Date:   Fri, 19 Mar 2021 17:00:01 -0700
Message-Id: <20210320000001.915366-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH bpf] bpf: use NOP_ATOMIC5 instead of emit_nops(&prog, 5) for BPF_TRAMP_F_CALL_ORIG
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__bpf_arch_text_poke does rewrite only for atomic nop5, emit_nops(xxx, 5)
emits non-atomic one which breaks fentry/fexit with k8 atomics:

P6_NOP5 == P6_NOP5_ATOMIC (0f1f440000 == 0f1f440000)
K8_NOP5 != K8_NOP5_ATOMIC (6666906690 != 6666666690)

Can be reproduced by doing "ideal_nops = k8_nops" in "arch_init_ideal_nops()
and running fexit_bpf2bpf selftest.

Fixes: e21aa341785c ("bpf: Fix fexit trampoline.")
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 arch/x86/net/bpf_jit_comp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 72b5a57e9e31..b35fc8023884 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -2012,7 +2012,8 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 		/* remember return value in a stack for bpf prog to access */
 		emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -8);
 		im->ip_after_call = prog;
-		emit_nops(&prog, 5);
+		memcpy(prog, ideal_nops[NOP_ATOMIC5], X86_PATCH_SIZE);
+		prog += X86_PATCH_SIZE;
 	}
 
 	if (fmod_ret->nr_progs) {
-- 
2.31.0.rc2.261.g7f71774620-goog

