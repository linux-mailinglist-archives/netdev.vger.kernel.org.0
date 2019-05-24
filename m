Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C948329740
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 13:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391083AbfEXLfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 07:35:50 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43386 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390909AbfEXLfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 07:35:50 -0400
Received: by mail-wr1-f68.google.com with SMTP id l17so1262087wrm.10
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 04:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=I1hfffn436msqgFGWpQyLY1Lerd3i6WTxQeF86oeiLU=;
        b=VwEgRji++bwkwsgoKKVWySK/r8Ga8cwWLFoy/y1YGFlOt+v+sZeZGEvlBwldVAi7PO
         HSzHu3PyP+mrQbWBqkp22zMxW4nvH+Ojk9wUfIz3ZZ62U8yCLN/Hq42Usgc+vlWa7TQj
         w3WjzCMxUMqYYer+15tSXV1oCj5SOHEVyaUTSF6jowVBgg5UBSl1PLTSnfb9p30wWjgI
         /usXVCKztc9lDdr0oJsw+u00kLkHakdirUgm3Ghoh410KUtuigRgKWH+KRkJcOGptqBp
         l/Bf3vxbxKKhhRbWuFImDEP5lXeY4/tsM2C0mCH9D99oH75JQczhh1oNIo6xIl4TwWBH
         8+oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=I1hfffn436msqgFGWpQyLY1Lerd3i6WTxQeF86oeiLU=;
        b=e8hcev5blExFjJblZCsp5KxaGdL4uwCJN3kX+0SDVmS3brktvLp3P2Z5ohcHdTQmKa
         sJiyhLw+Z2i4Z6dCeOLC0yf/cqebw3g43BHj3JPrEXNM2qjx4Kq/FCqIvj54DtF0NJhx
         qkT5I2dSDscPUe9eFG1xgO/X5YAeyfC3xcbKERbpmgNLFOZv50MHZpqaokjqkGizvSmJ
         yxkaV7VAImU07/JgJ1+hlZCB3Ws9uU9Ag98lfLtOVO5vi2zkPxa4ugxyQpJ1Lwzf5lfA
         IP/UqCIf6KgX2cyATKzIVE+u+zXqP3eGK1pSJAAv0fznBFQY9FVhzF0Y7csfg5YlhJ8m
         YE1Q==
X-Gm-Message-State: APjAAAWSknEUPvUDm3Qsp39+NmaHvpGUkASdLT5E+a0OONK7M1AKC4YO
        rHpbI15bsShrdaQT8GLxJyMGUQ==
X-Google-Smtp-Source: APXvYqy2o1UiEiwaDSneG2lZT33mzwmP+LiIlr8X37j1az0foA6dp23Zl8gdGb0ADsfpWfaTHiLJnQ==
X-Received: by 2002:a5d:6406:: with SMTP id z6mr19983088wru.87.1558697748136;
        Fri, 24 May 2019 04:35:48 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id x22sm2462902wmi.4.2019.05.24.04.35.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 24 May 2019 04:35:47 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, davem@davemloft.net,
        paul.burton@mips.com, udknight@gmail.com, zlim.lnx@gmail.com,
        illusionist.neo@gmail.com, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, jakub.kicinski@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v8 bpf-next 02/16] bpf: verifier: mark patched-insn with sub-register zext flag
Date:   Fri, 24 May 2019 12:35:12 +0100
Message-Id: <1558697726-4058-3-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558697726-4058-1-git-send-email-jiong.wang@netronome.com>
References: <1558697726-4058-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patched insns do not go through generic verification, therefore doesn't has
zero extension information collected during insn walking.

We don't bother analyze them at the moment, for any sub-register def comes
from them, just conservatively mark it as needing zero extension.

Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 kernel/bpf/verifier.c | 37 +++++++++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index f6b4c71..a6af316 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1269,6 +1269,24 @@ static bool is_reg64(struct bpf_verifier_env *env, struct bpf_insn *insn,
 	return true;
 }
 
+/* Return TRUE if INSN doesn't have explicit value define. */
+static bool insn_no_def(struct bpf_insn *insn)
+{
+	u8 class = BPF_CLASS(insn->code);
+
+	return (class == BPF_JMP || class == BPF_JMP32 ||
+		class == BPF_STX || class == BPF_ST);
+}
+
+/* Return TRUE if INSN has defined any 32-bit value explicitly. */
+static bool insn_has_def32(struct bpf_verifier_env *env, struct bpf_insn *insn)
+{
+	if (insn_no_def(insn))
+		return false;
+
+	return !is_reg64(env, insn, insn->dst_reg, NULL, DST_OP);
+}
+
 static void mark_insn_zext(struct bpf_verifier_env *env,
 			   struct bpf_reg_state *reg)
 {
@@ -7298,14 +7316,23 @@ static void convert_pseudo_ld_imm64(struct bpf_verifier_env *env)
  * insni[off, off + cnt).  Adjust corresponding insn_aux_data by copying
  * [0, off) and [off, end) to new locations, so the patched range stays zero
  */
-static int adjust_insn_aux_data(struct bpf_verifier_env *env, u32 prog_len,
-				u32 off, u32 cnt)
+static int adjust_insn_aux_data(struct bpf_verifier_env *env,
+				struct bpf_prog *new_prog, u32 off, u32 cnt)
 {
 	struct bpf_insn_aux_data *new_data, *old_data = env->insn_aux_data;
+	struct bpf_insn *insn = new_prog->insnsi;
+	u32 prog_len;
 	int i;
 
+	/* aux info at OFF always needs adjustment, no matter fast path
+	 * (cnt == 1) is taken or not. There is no guarantee INSN at OFF is the
+	 * original insn at old prog.
+	 */
+	old_data[off].zext_dst = insn_has_def32(env, insn + off + cnt - 1);
+
 	if (cnt == 1)
 		return 0;
+	prog_len = new_prog->len;
 	new_data = vzalloc(array_size(prog_len,
 				      sizeof(struct bpf_insn_aux_data)));
 	if (!new_data)
@@ -7313,8 +7340,10 @@ static int adjust_insn_aux_data(struct bpf_verifier_env *env, u32 prog_len,
 	memcpy(new_data, old_data, sizeof(struct bpf_insn_aux_data) * off);
 	memcpy(new_data + off + cnt - 1, old_data + off,
 	       sizeof(struct bpf_insn_aux_data) * (prog_len - off - cnt + 1));
-	for (i = off; i < off + cnt - 1; i++)
+	for (i = off; i < off + cnt - 1; i++) {
 		new_data[i].seen = true;
+		new_data[i].zext_dst = insn_has_def32(env, insn + i);
+	}
 	env->insn_aux_data = new_data;
 	vfree(old_data);
 	return 0;
@@ -7347,7 +7376,7 @@ static struct bpf_prog *bpf_patch_insn_data(struct bpf_verifier_env *env, u32 of
 				env->insn_aux_data[off].orig_idx);
 		return NULL;
 	}
-	if (adjust_insn_aux_data(env, new_prog->len, off, len))
+	if (adjust_insn_aux_data(env, new_prog, off, len))
 		return NULL;
 	adjust_subprog_starts(env, off, len);
 	return new_prog;
-- 
2.7.4

