Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8DD416FB9
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 11:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245448AbhIXJ5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 05:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245367AbhIXJ5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 05:57:51 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A6DC061574
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 02:56:18 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id t8so25771848wri.1
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 02:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3h7c0XVFr6N3jiF/U6QxDBsNOiGNhPsYCa4Km18D0Hc=;
        b=vKOH360OkdUSeBBmWUFXZK8VGjn3L5JmXcL6+bqa2xj579UoV2NU1xzoSlFrm708mm
         h5Jt8GHJe3mtqjujsS/u/O/LAfckAQvQGenJ/qLfLVMgl12xKd1MKcLBy/7EFiXXmBoL
         69vXNFZ3z7kgjYILbRfdlOFB2Q/ewIENfeeLg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3h7c0XVFr6N3jiF/U6QxDBsNOiGNhPsYCa4Km18D0Hc=;
        b=TyVVXu0zLsSE1g0hafoARPJ1bQPOtGjxk5u+HVXOy52ZjEZNR5eEsPA6k4GDAynCcX
         Mr6CYeeyY1wFiOjOGO8HhTmPgzQEJC5dbnDU/C482Oc7nKyxCU1P0rOnycp6UJXS4CF0
         F2Ddy9HcVjPAN5RXaKOtGrhqhiz0BwXrHKvhhbTCyPpnHNbFMIdumEwdwSwAZe/lUNuE
         K0b3QFwEcdzaoOvmUvWYT7/Z83usu7fV9t0eoiL6gMxcrfSsnAbkHH1iqQsy2TiuMdQS
         NkCYf91lpCQXU2ccef06bdDr7bGPIq5cQOTlwkHqwdE3JcXQo+XNiBpglL1D2iLyQn8m
         /h/Q==
X-Gm-Message-State: AOAM530RAQ4sHIsBE2uyntAa85UJ1UzWhqYVFmhaO0OCmZl72aFqEDgE
        o1apxDnMSkSoH31EDkvmyNWPNQ==
X-Google-Smtp-Source: ABdhPJxtHe+PjtTgQIuOLwSiU1zls++8SImNRIUOHlY0ZtTilLz8T0M+r62uqddhxQXzeoDR4eMiBA==
X-Received: by 2002:a05:6000:1379:: with SMTP id q25mr10131509wrz.280.1632477376986;
        Fri, 24 Sep 2021 02:56:16 -0700 (PDT)
Received: from antares.. (1.8.8.f.e.b.b.b.5.6.9.e.c.8.5.0.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:58c:e965:bbbe:f881])
        by smtp.gmail.com with ESMTPSA id v20sm7871106wra.73.2021.09.24.02.56.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 02:56:16 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     Luke Nelson <luke.r.nels@gmail.com>, Xi Wang <xi.wang@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 1/4] bpf: define bpf_jit_alloc_exec_limit for riscv JIT
Date:   Fri, 24 Sep 2021 10:55:39 +0100
Message-Id: <20210924095542.33697-2-lmb@cloudflare.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924095542.33697-1-lmb@cloudflare.com>
References: <20210924095542.33697-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose the maximum amount of useable memory from the sparcv JIT.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 arch/riscv/net/bpf_jit_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/riscv/net/bpf_jit_core.c b/arch/riscv/net/bpf_jit_core.c
index fed86f42dfbe..0fee2cbaaf53 100644
--- a/arch/riscv/net/bpf_jit_core.c
+++ b/arch/riscv/net/bpf_jit_core.c
@@ -166,6 +166,11 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	return prog;
 }
 
+u64 bpf_jit_alloc_exec_limit(void)
+{
+	return BPF_JIT_REGION_SIZE;
+}
+
 void *bpf_jit_alloc_exec(unsigned long size)
 {
 	return __vmalloc_node_range(size, PAGE_SIZE, BPF_JIT_REGION_START,
-- 
2.30.2

