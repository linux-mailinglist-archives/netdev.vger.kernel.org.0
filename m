Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F6043E149
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 14:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbhJ1MzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 08:55:15 -0400
Received: from mail-lj1-f178.google.com ([209.85.208.178]:34810 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhJ1MzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 08:55:15 -0400
Received: by mail-lj1-f178.google.com with SMTP id h11so10565855ljk.1;
        Thu, 28 Oct 2021 05:52:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xrmACLrClol1Ht1AqRT5BlRPbvf71eFZVnNxO5q/rNI=;
        b=QWhpwM4mY2+NcYr72FKWuy7tTDke5SRPDtEGsazMiaqEd02RZStgJGcGbR/yjAYS8A
         HkWDjSCSsc3aXKG3+cx3mSLaR5Rb82BVxm78Jp/GOJgIIntMixZVuLF853S/NeGE5fmw
         bkLmMyEvvZqxbKcM8z134eE3eJbZt7LRhXbdVz4muWkMKqIced412p1jrvMNm5jASjy0
         1Vbx2suDf1XPxqHxmTZdwiyG3+VWy0SmB1mRaNBDei34CumVKO0/XgP7fpOrcj1h9d1L
         VcmSscXBd0is/4I30xNI4jgoiM7436fzjN7sqnfhuaK0IubV1gH2soDUou29vI1yZrcl
         yiTA==
X-Gm-Message-State: AOAM5313qAK5PIHUZi1ZIMByTRPtubhvEC1IQavANbUpu6404TfpJsjt
        VHYlj2w9ldonC3SRwLfXgsOA0YzvBRI=
X-Google-Smtp-Source: ABdhPJyQuQYnh4pcXTg5UYacz2zwAvAPf7Nnyl+A/VS8XnK9ZOgp2IkFx0P7Wfl5aBeow658nwCU2w==
X-Received: by 2002:a2e:9d88:: with SMTP id c8mr4662425ljj.276.1635425567390;
        Thu, 28 Oct 2021 05:52:47 -0700 (PDT)
Received: from kladdkakan.. ([185.213.154.234])
        by smtp.gmail.com with ESMTPSA id p10sm282150ljm.53.2021.10.28.05.52.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 05:52:46 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH bpf] riscv, bpf: Fix potential NULL dereference
Date:   Thu, 28 Oct 2021 14:51:15 +0200
Message-Id: <20211028125115.514587-1-bjorn@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf_jit_binary_free() function requires a non-NULL argument. When
the RISC-V BPF JIT fails to converge in NR_JIT_ITERATIONS steps,
jit_data->header will be NULL, which triggers a NULL
dereference. Avoid this by checking the argument, prior calling the
function.

Fixes: ca6cb5447cec ("riscv, bpf: Factor common RISC-V JIT code")
Signed-off-by: Björn Töpel <bjorn@kernel.org>
---
 arch/riscv/net/bpf_jit_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/net/bpf_jit_core.c b/arch/riscv/net/bpf_jit_core.c
index 0fee2cbaaf53..753d85bdfad0 100644
--- a/arch/riscv/net/bpf_jit_core.c
+++ b/arch/riscv/net/bpf_jit_core.c
@@ -125,7 +125,8 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 
 	if (i == NR_JIT_ITERATIONS) {
 		pr_err("bpf-jit: image did not converge in <%d passes!\n", i);
-		bpf_jit_binary_free(jit_data->header);
+		if (jit_data->header)
+			bpf_jit_binary_free(jit_data->header);
 		prog = orig_prog;
 		goto out_offset;
 	}

base-commit: 72f898ca0ab85fde6facf78b14d9f67a4a7b32d1
-- 
2.32.0

