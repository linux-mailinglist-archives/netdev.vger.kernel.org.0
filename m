Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54926DAA65
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 10:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240374AbjDGIrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 04:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240332AbjDGIrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 04:47:03 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A36DA256
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 01:47:02 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id 20so359260plk.10
        for <netdev@vger.kernel.org>; Fri, 07 Apr 2023 01:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1680857221;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vmjzgy6aRksKW2xHyWe1W6xO2vj0DerqrAUjE2I1iOw=;
        b=R19VL0csBPbWvcgvmXecbzxFCkoToYH65diKdOlEF9KJ/fEYiWe37kKhzwJoq70D/C
         Oo+Wfsg7HRJ4da903PbxzU++qNf8IHdRLW3w0tJvetNpXiN4ZlLhtK1GnlWwQ4Ws0bCh
         o0ryF+AcZPFBXUve+oRoD6FFsQUF8t+FVSRFJcF22Y/f52ElJGYZb0U0mrpr2rZ0rKOO
         viD5AXfUBZ5gyoOGuxMxwOTXcbG/HJEaOBflD7lF5qC+YY9ESVQ/0S3W21LDzN6MfmE+
         OydadRLL5SvuJ/oglzCl73BXA4sIFWY5w9+LHsbi0Bn7Z5gKnJCROgaIQiFs/cMwN3FP
         rJoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680857221;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vmjzgy6aRksKW2xHyWe1W6xO2vj0DerqrAUjE2I1iOw=;
        b=Wv444FV1clPrLcsINxhy90mHg0VAYvp1PLfghSw0UPWSYspfuhUl+909NP31/5Q34d
         mHZfJLCP1A0DiwMl4KoPvSdm/Vo4V6PSY+TnvgFpKgNJuG6ExMfh4RdmrB5iuODsak72
         HmrBq8b0b9xgpQ5hMPu36aYYXGkqD9GK0rQE0k0QiO4p/IazUcMtZvEb3o/Xt7FRYY+4
         hA8CES5SEm+9uWrLBt+vebPsNhFUJ0jbD//orNj0tq7dCloaFDNDJjYE8Kb7pJ+VbP8b
         SgG6N+K7K5gVjs8Taqako63CPdS+7JOmAvWehBcIq/W9IwbZ/6My+Ou6QiIAXT04iUqX
         I5RQ==
X-Gm-Message-State: AAQBX9fnhVGsvV4e8FKPXPchLjCeNso0XuSxTF9in6cB95gmTPxJit5c
        F17GbtF8xPZuVahkvEpC4E8vJg==
X-Google-Smtp-Source: AKy350ak8Z2sVLnknesb8rdNJcheWrbfZoigZ/kr+Zq60kGlUKezCUKJy/ma6QUMi7cvv7oDlZUXOg==
X-Received: by 2002:a17:90b:1bd1:b0:23c:fef0:d441 with SMTP id oa17-20020a17090b1bd100b0023cfef0d441mr1578447pjb.33.1680857221702;
        Fri, 07 Apr 2023 01:47:01 -0700 (PDT)
Received: from C02F52LSML85.bytedance.net ([139.177.225.238])
        by smtp.gmail.com with ESMTPSA id s13-20020a17090a5d0d00b0023b3d80c76csm2333676pji.4.2023.04.07.01.46.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 01:47:01 -0700 (PDT)
From:   Feng zhou <zhoufeng.zf@bytedance.com>
To:     martin.lau@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mykolal@fb.com, shuah@kernel.org
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        yangzhenze@bytedance.com, wangdongdong.6@bytedance.com,
        zhouchengming@bytedance.com, zhoufeng.zf@bytedance.com
Subject: [PATCH v2 2/2] selftests/bpf: Add test to access u32 ptr argument in tracing program
Date:   Fri,  7 Apr 2023 16:46:08 +0800
Message-Id: <20230407084608.62296-3-zhoufeng.zf@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20230407084608.62296-1-zhoufeng.zf@bytedance.com>
References: <20230407084608.62296-1-zhoufeng.zf@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Feng Zhou <zhoufeng.zf@bytedance.com>

Adding verifier test for accessing u32 pointer argument in
tracing programs.

The test program loads 1nd argument of bpf_fentry_test9 function
which is u32 pointer and checks that verifier allows that.

Co-developed-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
---
 net/bpf/test_run.c                                  |  8 +++++++-
 .../testing/selftests/bpf/verifier/btf_ctx_access.c | 13 +++++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index f1652f5fbd2e..68bdfc041a7b 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -541,6 +541,11 @@ int noinline bpf_fentry_test8(struct bpf_fentry_test_t *arg)
 	return (long)arg->a;
 }
 
+__bpf_kfunc u32 bpf_fentry_test9(u32 *a)
+{
+	return *a;
+}
+
 __bpf_kfunc int bpf_modify_return_test(int a, int *b)
 {
 	*b += 1;
@@ -855,7 +860,8 @@ int bpf_prog_test_run_tracing(struct bpf_prog *prog,
 		    bpf_fentry_test5(11, (void *)12, 13, 14, 15) != 65 ||
 		    bpf_fentry_test6(16, (void *)17, 18, 19, (void *)20, 21) != 111 ||
 		    bpf_fentry_test7((struct bpf_fentry_test_t *)0) != 0 ||
-		    bpf_fentry_test8(&arg) != 0)
+		    bpf_fentry_test8(&arg) != 0 ||
+		    bpf_fentry_test9(&retval) != 0)
 			goto out;
 		break;
 	case BPF_MODIFY_RETURN:
diff --git a/tools/testing/selftests/bpf/verifier/btf_ctx_access.c b/tools/testing/selftests/bpf/verifier/btf_ctx_access.c
index 6340db6b46dc..0484d3de040d 100644
--- a/tools/testing/selftests/bpf/verifier/btf_ctx_access.c
+++ b/tools/testing/selftests/bpf/verifier/btf_ctx_access.c
@@ -10,3 +10,16 @@
 	.expected_attach_type = BPF_TRACE_FENTRY,
 	.kfunc = "bpf_modify_return_test",
 },
+
+{
+	"btf_ctx_access u32 pointer accept",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, 0),	/* load 1nd argument value (u32 pointer) */
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_TRACING,
+	.expected_attach_type = BPF_TRACE_FENTRY,
+	.kfunc = "bpf_fentry_test9",
+},
-- 
2.20.1

