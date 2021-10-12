Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6112442A69A
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237056AbhJLOBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 10:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237043AbhJLOBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 10:01:48 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7D1C061570
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 06:59:46 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id o20so67084562wro.3
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 06:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RRur22NBusGD90t4t5587ekzz3x5I1RHcVLT1FRWOPw=;
        b=IC5ozrF9Fk4ixO/DmQRRJMfZtKF6X8P2Ryj8v5lwwJxe5XfnWU+4ZZAuSYNZu6x9sS
         DXZexMvs47MlKlqoLqZLMSEbSEKBca1l1BMWzZJoZu75yFID9Ntfht+KNGsbvl/71EKz
         QX0FYxEJpnbdFK5AcNhBGSIanCrbBeD5LCqYw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RRur22NBusGD90t4t5587ekzz3x5I1RHcVLT1FRWOPw=;
        b=BrduZVDQjwW2aL1YUWvw0elUW/L4ALc8SJQq1Nzx0PZW6nlPZ3G1oVp4RfamJAwRhr
         CCOaT0uFEzLY9KuqGTgd7JHig/QLAxnus9beqsmjgjhnHChU+pEh086wuz9b0VBNQkgR
         mnBNcdYxZIS4IuEBqNhwWqeHn37eUp4fgtfPwm9fJw0MJc0ggkOpeRy56L7aM5xiqeDW
         crOOjeBKd8WbfgUHQj6sG3WlxAtEjA5xh0K7qG8W5F31uLTtvSH9WUX2s8MHFD+jLoXZ
         6JSnaZuIBjMutOhyPw2A11nEb0EF800CwOJ9yTIkP9at7UqdhN+kpIOpEUkgICxOqbxf
         /M/Q==
X-Gm-Message-State: AOAM533JQKIQNJ3t/sjbKuut3MpRPyb2Ctg72Szw3ksRp8oVvTBuTmVB
        dwiaRqhA5ecYsn7lA1cP97eGGA==
X-Google-Smtp-Source: ABdhPJxf/VwuPji5uxceSTpnmSLkaPpvhVEEb0uqqN73zLEcFZ32FGEir2cODYh83eyZ/x+JVR7VLg==
X-Received: by 2002:adf:b1c4:: with SMTP id r4mr32357486wra.428.1634047184896;
        Tue, 12 Oct 2021 06:59:44 -0700 (PDT)
Received: from antares.. (d.5.b.3.f.b.d.4.c.0.9.7.6.8.3.1.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:1386:790c:4dbf:3b5d])
        by smtp.gmail.com with ESMTPSA id o6sm14875894wri.49.2021.10.12.06.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 06:59:44 -0700 (PDT)
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
Subject: [PATCH v2 2/4] bpf: define bpf_jit_alloc_exec_limit for arm64 JIT
Date:   Tue, 12 Oct 2021 14:59:33 +0100
Message-Id: <20211012135935.37054-3-lmb@cloudflare.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211012135935.37054-1-lmb@cloudflare.com>
References: <20211012135935.37054-1-lmb@cloudflare.com>
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

