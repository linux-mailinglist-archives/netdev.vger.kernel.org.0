Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C49440061
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 18:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhJ2Qde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 12:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbhJ2Qdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 12:33:33 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF50C061570;
        Fri, 29 Oct 2021 09:31:05 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id np13so7557928pjb.4;
        Fri, 29 Oct 2021 09:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T3OPcmxm4qLv6/ei2QAhpCB8buOjbln8YASKJJNXtx4=;
        b=LRD8pnDBrm14OnEiRvAhNEVhAX9bWETfgLgZvVKZzM3g0KsrSB/5GimaKxxZMA7vvb
         bWhV4ZwJ8rkhuXYO+3cM00RdZBX5Zb9JXAt4uNftT9msZReHPQqYHkUe2d1T1WEWe4um
         //UU4OVL3D9dnXJirMMBmKrZN/ohhp+HQSuaqESNZO1u7Z/ecZUnQ5yjfEBUXPUa0eZ8
         IwvvKJr3BPycUS6QDc7WYmw0Xiov/HhfLD1Sii/QoE2P9HuBbx0JlxKrbPZakieJ9M7Y
         W6pZ9PTBqIKxZiM+AucjmglJ4GBt/wckTmJPJxZlDVpgt4gLHvfhmnFuJDvwFNX20bK3
         ZKOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T3OPcmxm4qLv6/ei2QAhpCB8buOjbln8YASKJJNXtx4=;
        b=no5yUU7qvHwwAOU3aVaOq3j6lgOWN2l/ofxji7Ssp6R9/06Pjfts3ET3khmdcLGgGc
         wCrhKq0MZd7gCQ68Q6o6WM23WYAt396M/gHmRDstI3yCVq59Rh6Z4cE3kdVtTAn7qy+K
         HomII6vuVjT8Vyd6hzVZKL/SY6ctrzq1M+CrOHeZN62YAl+IlTgGQLYHD66f92wBrVto
         7pV0aFP5XoE8XUA/LL4qEIe9AGxO4tgVTKOyrvDbA+0hUaI13cFwocMqLPtYrRgBvGTv
         xWdv1QD4C0oNSEOKQGUjohfCrri4zHtd3gsPR+f2P+tntUqSY4NMqvatJskWZgsUlNa+
         MOcQ==
X-Gm-Message-State: AOAM532kWsAB/GwPNJ+Wi8rT9vVy5DskMthS8Rc299fqpXxEv02ZlpHc
        1N8HtIlf3QjjqMZZQ4OfPdY=
X-Google-Smtp-Source: ABdhPJx2ncfNKU+IZxYbrVEHf+NBQAyC42obZrzKG2xFZ/ZTkoygibHypAWSYXkeYEsTjVBVQOhHvw==
X-Received: by 2002:a17:90b:3511:: with SMTP id ls17mr20953908pjb.145.1635525064812;
        Fri, 29 Oct 2021 09:31:04 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:76b2])
        by smtp.gmail.com with ESMTPSA id x20sm6318286pjp.48.2021.10.29.09.31.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 29 Oct 2021 09:31:04 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next] bpf: Fix propagation of bounds from 64-bit min/max into 32-bit and var_off.
Date:   Fri, 29 Oct 2021 09:31:02 -0700
Message-Id: <20211029163102.80290-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Before this fix:
166: (b5) if r2 <= 0x1 goto pc+22
from 166 to 189: R2=invP(id=1,umax_value=1,var_off=(0x0; 0xffffffff))

After this fix:
166: (b5) if r2 <= 0x1 goto pc+22
from 166 to 189: R2=invP(id=1,umax_value=1,var_off=(0x0; 0x1))

While processing BPF_JLE the reg_set_min_max() would set true_reg->umax_value = 1
and call __reg_combine_64_into_32(true_reg).

Without the fix it would not pass the condition:
if (__reg64_bound_u32(reg->umin_value) && __reg64_bound_u32(reg->umax_value))

since umin_value == 0 at this point.
Before commit 10bf4e83167c the umin was incorrectly ingored.
The commit 10bf4e83167c fixed the correctness issue, but pessimized
propagation of 64-bit min max into 32-bit min max and corresponding var_off.

Fixes: 10bf4e83167c ("bpf: Fix propagation of 32 bit unsigned bounds from 64 bit bounds")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/verifier.c                               | 2 +-
 tools/testing/selftests/bpf/verifier/array_access.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 3c8aa7df1773..29671ed49ee8 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1425,7 +1425,7 @@ static bool __reg64_bound_s32(s64 a)
 
 static bool __reg64_bound_u32(u64 a)
 {
-	return a > U32_MIN && a < U32_MAX;
+	return a >= U32_MIN && a <= U32_MAX;
 }
 
 static void __reg_combine_64_into_32(struct bpf_reg_state *reg)
diff --git a/tools/testing/selftests/bpf/verifier/array_access.c b/tools/testing/selftests/bpf/verifier/array_access.c
index 1b1c798e9248..1b138cd2b187 100644
--- a/tools/testing/selftests/bpf/verifier/array_access.c
+++ b/tools/testing/selftests/bpf/verifier/array_access.c
@@ -186,7 +186,7 @@
 	},
 	.fixup_map_hash_48b = { 3 },
 	.errstr_unpriv = "R0 leaks addr",
-	.errstr = "R0 unbounded memory access",
+	.errstr = "invalid access to map value, value_size=48 off=44 size=8",
 	.result_unpriv = REJECT,
 	.result = REJECT,
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
-- 
2.30.2

