Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D70C6DC4C1
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 11:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjDJJAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 05:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjDJJAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 05:00:04 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4EF849E5
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 01:59:37 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-633a6bf6af9so396735b3a.0
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 01:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1681117177;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vmjzgy6aRksKW2xHyWe1W6xO2vj0DerqrAUjE2I1iOw=;
        b=fzN+MiU6321vicJhqAots7mAuz8s2SwEdyneHO35BP9aG2bAglabCDR54Dg9qrEr83
         jQ15bR6CYr5dUAFx3btvWSu4q0wh2xdC9AI5zFXRUD7ZY/+jLqDhTZ7ebRhX2fQ7Xbji
         oyim6f/nljWILB+xe3P0Y+xAHly9T71+sHq2/tU2W1qwgxSGru2YjnIcvZZxj70KUuxd
         ITED0LiGDwFlG3l1DXPvL+kufdE0cDlvLTH3uXjnSkSlZSouF+3YlSz/TwW7QTvXz+hM
         dtPJYVyO2pIwj7GoWgLaK7VN+mpiMeMMzhoh3EOzaEtfOdptBSbMKE4coq9IuZpcqLDZ
         fF7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681117177;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vmjzgy6aRksKW2xHyWe1W6xO2vj0DerqrAUjE2I1iOw=;
        b=QyqEL2snAwQhFTeWN5153tyaa+xfSV7MWFcZmjkw5RGZ7hq33ib/CaDxBUyrFuKUi4
         1zvQu+TgAhXoJOFl/JWoJGVifKfc/cQuUBs/AS0ECk0t08U1pbrIS1oYZvi6LB0Z80D4
         CoSFtOOFi6kcJTsRFpW9ASubVUOulh2e4wiE4YHC+tOII+ZRi5fCs4NTDsjcfk3Y5T18
         KAXJivM8bmY0i8adwgqDyLsmvAZaXeBXAr4sj3oHd0uCk3t4KrEQ7FapkLMtGt4oMfAY
         X9zeeE3HpOPZsC6lq44Yt0hURM3aY9GZNwQIckFuxumNaJHEQId+ykPT6FjjOy2JZOL1
         nMnQ==
X-Gm-Message-State: AAQBX9faYQU8H+YZjfpSYNKJUHrOXPwdr55jBCMWWHf4VXKZqEPHHi/A
        DOgrZ4NXSub35Aw/4zcHan15HQ==
X-Google-Smtp-Source: AKy350Z6VMnUO4zv6ubuAdli2LF9uiWGuFD6pJjud0oMYpPji4pcHarTnTjnf6UpzXThS/n+Pt6Ydg==
X-Received: by 2002:aa7:9464:0:b0:636:4850:7b9d with SMTP id t4-20020aa79464000000b0063648507b9dmr3859415pfq.0.1681117177404;
        Mon, 10 Apr 2023 01:59:37 -0700 (PDT)
Received: from C02F52LSML85.bytedance.net ([139.177.225.238])
        by smtp.gmail.com with ESMTPSA id s21-20020aa78295000000b0058bacd6c4e8sm7279526pfm.207.2023.04.10.01.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 01:59:37 -0700 (PDT)
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
Subject: [PATCH v3 2/2] selftests/bpf: Add test to access u32 ptr argument in tracing program
Date:   Mon, 10 Apr 2023 16:59:08 +0800
Message-Id: <20230410085908.98493-3-zhoufeng.zf@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20230410085908.98493-1-zhoufeng.zf@bytedance.com>
References: <20230410085908.98493-1-zhoufeng.zf@bytedance.com>
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

