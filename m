Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C19569FC2B
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 20:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbjBVT3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 14:29:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232437AbjBVT3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 14:29:39 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9242E0FF
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 11:29:37 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-536bbaeceeaso88180157b3.11
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 11:29:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6tasE976sed6Z9eekcv/3y3HqpG7M1LvNFXgzwFh9Rk=;
        b=MKMHno+wsx9foc5KwhZQMbLnWr5HNiKCWvxRPdknfsHmV/b0GFXdSkeesCbvDHC2Ty
         N9Sv00E4OIuOitE400fJYQOSPC7O+JijnQIsWQ9mdJsxdJuE2rzP4Q3ydJ+Xv3qOxWV+
         1EP0Wznfhw5mgTlYlx3Ka2xCiE5HJs5sahb9zz6Ru82ntP4xhyk/YRvZX1UH7TWi0is2
         nx32DG0HarWrA/ao2c8MwOePvxgFZbHC+z3frPlbHSOFUoWvH5ydA4Bkw853LnwemR/P
         YN+R5JyGEI5Vf9BcBtU38GGZ6tcPd/s67R+8Jrj+MTy00I6yGi5ZQcJYoMRC0H/rziu+
         n3TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6tasE976sed6Z9eekcv/3y3HqpG7M1LvNFXgzwFh9Rk=;
        b=mm5prI4CjMstmefodcNS0p6tQu9xalRwpYfJ9qFQtfFa+j2PJrRmjwV0QEOAWbYSvR
         xZotd3kdGj87PI6kFGKMvuTunKod+9WXJCpolJJdaHx/Rs6xS68BEIRhtsXg2eEjo3NB
         Mwsc92GudHVg610yBJ4TKSOT3G0BbJltYUK9Bq4HF6qE7eU6tnzWCAY1gaW5D5UAUJjf
         TjhFJ2fseWCmFjSjOS4KMEmyNB1BC9pX2cST8szUzwZEutl+03DJWfLFFbujz4u56E6D
         /xIWsSw6NCdQ+Nxpty2UWp4kDRHEOGnNZDGszSnb233x7mQFI4Cfq1dzkm/JWDQjmNLe
         nPpg==
X-Gm-Message-State: AO0yUKX4OvAgA3y8Mi47VJL0FE7BxWxjORlyoHgJrE4/gBspiGLTt9V6
        yzs3iYAFSeRVl8Nz3vfrzUwEvffj0wA=
X-Google-Smtp-Source: AK7set/SJbJM8Dxbbt+8qEYFy5lTpS7wwzsR9FZD6mlxxuDkgAtg7r2wZSAItN2hh36FLwfRJrTiOgkMsA0=
X-Received: from edliaw.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:305d])
 (user=edliaw job=sendgmr) by 2002:a05:6902:1028:b0:a27:3ecd:6 with SMTP id
 x8-20020a056902102800b00a273ecd0006mr172380ybt.1.1677094177130; Wed, 22 Feb
 2023 11:29:37 -0800 (PST)
Date:   Wed, 22 Feb 2023 19:29:21 +0000
In-Reply-To: <20230222192925.1778183-1-edliaw@google.com>
Mime-Version: 1.0
References: <20230222192925.1778183-1-edliaw@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230222192925.1778183-2-edliaw@google.com>
Subject: [PATCH 4.14 v2 1/4] bpf: Do not use ax register in interpreter on div/mod
From:   Edward Liaw <edliaw@google.com>
To:     stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>
Cc:     bpf@vger.kernel.org, kernel-team@android.com,
        Edward Liaw <edliaw@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

Partially undo old commit 144cd91c4c2b ("bpf: move tmp variable into ax
register in interpreter"). The reason we need this here is because ax
register will be used for holding temporary state for div/mod instruction
which otherwise interpreter would corrupt. This will cause a small +8 byte
stack increase for interpreter, but with the gain that we can use it from
verifier rewrites as scratch register.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
[cascardo: This partial revert is needed in order to support using AX for
the following two commits, as there is no JMP32 on 4.19.y]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
[edliaw: Removed redeclaration of tmp]
Signed-off-by: Edward Liaw <edliaw@google.com>
---
 kernel/bpf/core.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 5d649983de07..4ddb846693bb 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -663,9 +663,6 @@ static int bpf_jit_blind_insn(const struct bpf_insn *from,
 	 * below.
 	 *
 	 * Constant blinding is only used by JITs, not in the interpreter.
-	 * The interpreter uses AX in some occasions as a local temporary
-	 * register e.g. in DIV or MOD instructions.
-	 *
 	 * In restricted circumstances, the verifier can also use the AX
 	 * register for rewrites as long as they do not interfere with
 	 * the above cases!
@@ -1060,22 +1057,22 @@ static unsigned int ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn,
 	ALU64_MOD_X:
 		if (unlikely(SRC == 0))
 			return 0;
-		div64_u64_rem(DST, SRC, &AX);
-		DST = AX;
+		div64_u64_rem(DST, SRC, &tmp);
+		DST = tmp;
 		CONT;
 	ALU_MOD_X:
 		if (unlikely((u32)SRC == 0))
 			return 0;
-		AX = (u32) DST;
-		DST = do_div(AX, (u32) SRC);
+		tmp = (u32) DST;
+		DST = do_div(tmp, (u32) SRC);
 		CONT;
 	ALU64_MOD_K:
-		div64_u64_rem(DST, IMM, &AX);
-		DST = AX;
+		div64_u64_rem(DST, IMM, &tmp);
+		DST = tmp;
 		CONT;
 	ALU_MOD_K:
-		AX = (u32) DST;
-		DST = do_div(AX, (u32) IMM);
+		tmp = (u32) DST;
+		DST = do_div(tmp, (u32) IMM);
 		CONT;
 	ALU64_DIV_X:
 		if (unlikely(SRC == 0))
@@ -1085,17 +1082,17 @@ static unsigned int ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn,
 	ALU_DIV_X:
 		if (unlikely((u32)SRC == 0))
 			return 0;
-		AX = (u32) DST;
-		do_div(AX, (u32) SRC);
-		DST = (u32) AX;
+		tmp = (u32) DST;
+		do_div(tmp, (u32) SRC);
+		DST = (u32) tmp;
 		CONT;
 	ALU64_DIV_K:
 		DST = div64_u64(DST, IMM);
 		CONT;
 	ALU_DIV_K:
-		AX = (u32) DST;
-		do_div(AX, (u32) IMM);
-		DST = (u32) AX;
+		tmp = (u32) DST;
+		do_div(tmp, (u32) IMM);
+		DST = (u32) tmp;
 		CONT;
 	ALU_END_TO_BE:
 		switch (IMM) {
-- 
2.39.2.637.g21b0678d19-goog

