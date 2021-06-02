Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB13399571
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 23:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhFBVcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 17:32:13 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:46992 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbhFBVcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 17:32:12 -0400
Received: by mail-wr1-f45.google.com with SMTP id a11so1801676wrt.13;
        Wed, 02 Jun 2021 14:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4s+WtVD0z1zrvcjIi7mvIhu9JKhygKLIdbwXXCCDpJ8=;
        b=UOENaWmX3PzGWYoKPFhCQXlJ9/5W38ns2q5K3buxLEbFhE0ynImXXyXe0xjWaUw+2k
         3+HrtTIKZNHqHbPiOVtemxOy27y0wGopobb4amoi+NnmxXjOhatFWAoBLD/1dwECQvrb
         76+T7NF9tD5xlnQ7EFqs6SrBVxRihaibGjEqi2PuMRhbTmheHCdCIdRW3Qcfc8HBhss1
         0hugAJNGNvrWgLacfV+jzs0ATYO7VeUNzAMvq19O9/7PAU7y0ydzdJWkrAxXmbcUi4hO
         C+r0lGgqUNzttSv8I7Rj38rxxUZjbg9ss5eXjhx8UilqupeVKU1cm8j0SQ48/seiaoyL
         BepQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4s+WtVD0z1zrvcjIi7mvIhu9JKhygKLIdbwXXCCDpJ8=;
        b=sELs9bzCVuZ58J9AGg6QIF3qlTemapa8ETXaI3qFuR7pBk5t1jXdVuBy3nD6r/9s6e
         5kdYSOOM44Bn3i/MYf69YURD7BOSK4/hv9Uv0dRSbSS7Pt9Si/6ChodfbVUKNGl3+ijK
         k1L5511FHNkCV3bYs6qImQnp0xfklBTA0VX2PWJpq7w8Llpnr/xXVVdjlweiZUNv0EDR
         xNbPvBcgHIUPMwRWc3sae9twMvfUFGOCmpg7SDnFRdlXP5cJGgoSNQokBdfPW1uQhKq8
         XCANvw0wbku4x8OPsFkmQaZSxtpzBmY5xYaBYtTKeVHiuckRCBI0zuRs7HgG2Q/H4JLT
         g9KQ==
X-Gm-Message-State: AOAM531f2UvGhP9W46ptHN8K+jTj34EvLI7IwxhGSCMy8zckFMySqDOz
        ArwNgthOJ3A9bcKqNpE4id1A27TAqGLafw==
X-Google-Smtp-Source: ABdhPJzjiDdoclNUldyrUeLFcTnrcPHIcR9mw6VbQ4HURvNHqRXQdc6ch3lj36KtL5Jsp1ptwwIdxg==
X-Received: by 2002:adf:ef06:: with SMTP id e6mr24281131wro.393.1622669367880;
        Wed, 02 Jun 2021 14:29:27 -0700 (PDT)
Received: from localhost.localdomain ([185.199.80.151])
        by smtp.gmail.com with ESMTPSA id 62sm1272616wrm.1.2021.06.02.14.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 14:29:27 -0700 (PDT)
From:   Kurt Manucredo <fuzzybritches0@gmail.com>
To:     syzbot+bed360704c521841c85d@syzkaller.appspotmail.com
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com, nathan@kernel.org,
        ndesaulniers@google.com, clang-built-linux@googlegroups.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org, gregkh@linuxfoundation.org,
        Kurt Manucredo <fuzzybritches0@gmail.com>
Subject: [PATCH v3] bpf: core: fix shift-out-of-bounds in ___bpf_prog_run
Date:   Wed,  2 Jun 2021 21:27:26 +0000
Message-Id: <20210602212726.7-1-fuzzybritches0@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <000000000000c2987605be907e41@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UBSAN: shift-out-of-bounds in kernel/bpf/core.c:1414:2
shift exponent 248 is too large for 32-bit type 'unsigned int'

Reported-and-tested-by: syzbot+bed360704c521841c85d@syzkaller.appspotmail.com
Signed-off-by: Kurt Manucredo <fuzzybritches0@gmail.com>
---

https://syzkaller.appspot.com/bug?id=edb51be4c9a320186328893287bb30d5eed09231

Changelog:
----------
v3 - Make it clearer what the fix is for.
v2 - Fix shift-out-of-bounds in ___bpf_prog_run() by adding boundary
check in check_alu_op() in verifier.c.
v1 - Fix shift-out-of-bounds in ___bpf_prog_run() by adding boundary
check in ___bpf_prog_run().

Hi everyone,

I hope this fixes it!

kind regards

 kernel/bpf/verifier.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 94ba5163d4c5..04e3bf344ecd 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7880,13 +7880,25 @@ static int check_alu_op(struct bpf_verifier_env *env, struct bpf_insn *insn)
 			return -EINVAL;
 		}
 
-		if ((opcode == BPF_LSH || opcode == BPF_RSH ||
-		     opcode == BPF_ARSH) && BPF_SRC(insn->code) == BPF_K) {
+		if (opcode == BPF_LSH || opcode == BPF_RSH ||
+		     opcode == BPF_ARSH) {
 			int size = BPF_CLASS(insn->code) == BPF_ALU64 ? 64 : 32;
 
-			if (insn->imm < 0 || insn->imm >= size) {
-				verbose(env, "invalid shift %d\n", insn->imm);
-				return -EINVAL;
+			if (BPF_SRC(insn->code) == BPF_K) {
+				if (insn->imm < 0 || insn->imm >= size) {
+					verbose(env, "invalid shift %d\n", insn->imm);
+					return -EINVAL;
+				}
+			}
+			if (BPF_SRC(insn->code) == BPF_X) {
+				struct bpf_reg_state *src_reg;
+
+				src_reg = &regs[insn->src_reg];
+				if (src_reg->umax_value >= size) {
+					verbose(env, "invalid shift %lld\n",
+							src_reg->umax_value);
+					return -EINVAL;
+				}
 			}
 		}
 
-- 
2.30.2

