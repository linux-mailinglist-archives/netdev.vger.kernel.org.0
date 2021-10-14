Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC8242DB79
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 16:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbhJNO2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 10:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231822AbhJNO2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 10:28:12 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F073C061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 07:26:07 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id r7so20120178wrc.10
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 07:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RRur22NBusGD90t4t5587ekzz3x5I1RHcVLT1FRWOPw=;
        b=RmhVf07oF6025wnab8G9e3JeuNPyTuS8nYqhI375yVQIL0U9eUmLhzjtuwOVtNWage
         l9C1jkYM8uhpYDHf9otaq/XTvm2rgfq0akCikV7qkC4iTfaB4nKogtvA+vhRnruVnbD+
         cOkkxtYNiiEdWIWE4OgPf56KWAs6Yw/rBVpRQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RRur22NBusGD90t4t5587ekzz3x5I1RHcVLT1FRWOPw=;
        b=2d2Trox4IdSootnlVivkno7C/hpnheW4lbhK7aKCDPnMqQfpAiZqQ2VLlzTOkb4a4Z
         gXwlhNLaVA4zZrPh/jPCAwWS5UfSNL7jJfuoBc0DhC0lR5iN9gBXlx4UhqkVC1NUr9xe
         3NtNFo/Hssz+X+b3yJNdIplxyQNYOHfF+L/i5WBylh3XmiVC+zyvdp7vovXjoBKAG3OL
         m4Rsy6q/T/5kepZfOAMyjBcqNm7nL+2pVzGhuVIsHi0z2FLjtx8RWwa7WTUlf9zPd9oC
         9LDZzQ/jKP2t7OSkJzQHsvwREIM/hy+aiTONTmG9dognGLzyWEqKqvH/HO2f1zKNcuu5
         87VA==
X-Gm-Message-State: AOAM5327knjLXGf5QXFbNDBiCPM1fxrZb0dWj6DKIh5vSukSBj9Joy9U
        gyU0UDwrVVU8C0L6DqSNrQp7Yw==
X-Google-Smtp-Source: ABdhPJwA6roeFKn/hKn+FsDIjFD09EJZXyjCtR2peO46ZQ2mwsy86VrESVOK+e2yhDFIHOma2liu8w==
X-Received: by 2002:a05:6000:1aca:: with SMTP id i10mr7234743wry.207.1634221565929;
        Thu, 14 Oct 2021 07:26:05 -0700 (PDT)
Received: from antares.. (4.4.a.7.5.8.b.d.d.b.6.7.4.d.a.6.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:6ad4:76bd:db85:7a44])
        by smtp.gmail.com with ESMTPSA id e8sm3731111wrg.48.2021.10.14.07.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 07:26:05 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     nicolas.dichtel@6wind.com, luke.r.nels@gmail.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/3] bpf: define bpf_jit_alloc_exec_limit for arm64 JIT
Date:   Thu, 14 Oct 2021 15:25:52 +0100
Message-Id: <20211014142554.53120-3-lmb@cloudflare.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211014142554.53120-1-lmb@cloudflare.com>
References: <20211014142554.53120-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose the maximum amount of useable memory from the arm64 JIT.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 arch/arm64/net/bpf_jit_comp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 41c23f474ea6..803e7773fa86 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -1136,6 +1136,11 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
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

