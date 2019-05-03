Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00B3712BC4
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 12:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbfECKoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 06:44:30 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45375 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfECKnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 06:43:47 -0400
Received: by mail-wr1-f68.google.com with SMTP id s15so7208887wra.12
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 03:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fkIQCc7bnGnQaoJb7qAmxjkc3iakEC8QnjdfLr6L3FA=;
        b=oxS58Qb+6m7Oamg+bOJI897rvdhZST5tGa36M2wDtrzF/bV7X/O7xlLgaHHxYDoXSj
         JVFDcQRM6BbuOqbjbn/Qd64HtcIsrgGRcO+FWOAh6zrYlgu4CvJw0x9tbsGbd+9dYbAT
         Lnxd9Fat4JQ5UQcbHe/CeO5Whf0f3vMAKkgaY3ZxhAuaF4kH1KD8njiybWDG1yz1mkOc
         +bympP1itn0xgW+DkOgc1bwxgXOI86b1PG6T9J2tIri7FzheCGF0vsOXX8D3tz/IEuYu
         qglxt+c0pgx0hkOpVBNs4KytqEF9ZW1vFsChxoEdi7SpAvd0ELR3g+utEFXM7rFWCJ54
         uJJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fkIQCc7bnGnQaoJb7qAmxjkc3iakEC8QnjdfLr6L3FA=;
        b=OsFmljt78jVlyu7kITavu1NkyZvxe0QGY+7F6uRt57HrZlNpiHC7yVAOU9jMmHN8mn
         cGiHksY6umwI1PqkDOFosmpf3ifzaRNm4BMvzSKSZZ67RpSotCXIDWHJ1/pcyJzXq838
         zKTXFdyP0N32ru5yIEyit8qEk/CJ/fCj1brpSQdaHNpbef65SOl+grp9aeaWo45PEuj3
         Vg31BidNHe2zFXJGfIo06da4r37K3kNK1RjwO6jrHQv10IxsWR5dZh13arFKi9AUX7d3
         SNgOloavwAZ6u41qoQ3W58j9jm13JxtzCv0KoyvFNyaufEt4d53/CXPE6jSG32ZcXqvT
         tXtQ==
X-Gm-Message-State: APjAAAXPlhH+X1ZhmRTStbR/FR7Ag4NH18lY69w1mWy36L3Ec6ieKKhC
        pp+KdIZNJ0IGHqX5HviZtVhQKA==
X-Google-Smtp-Source: APXvYqxLTDfgClIS3XLsjBBBfUqkw7COkO5O6PzBL9naymrwtdt7LEaTWe6JYlwYEdBSNfBoUdfOSQ==
X-Received: by 2002:adf:92e2:: with SMTP id 89mr6792425wrn.53.1556880226055;
        Fri, 03 May 2019 03:43:46 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id r29sm1716999wra.56.2019.05.03.03.43.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 03 May 2019 03:43:44 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v6 bpf-next 03/17] bpf: verifier: mark patched-insn with sub-register zext flag
Date:   Fri,  3 May 2019 11:42:30 +0100
Message-Id: <1556880164-10689-4-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com>
References: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com>
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
index 43ea665..b43e8a2 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1303,6 +1303,24 @@ static bool is_reg64(struct bpf_verifier_env *env, struct bpf_insn *insn,
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
@@ -7306,14 +7324,23 @@ static void convert_pseudo_ld_imm64(struct bpf_verifier_env *env)
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
@@ -7321,8 +7348,10 @@ static int adjust_insn_aux_data(struct bpf_verifier_env *env, u32 prog_len,
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
@@ -7355,7 +7384,7 @@ static struct bpf_prog *bpf_patch_insn_data(struct bpf_verifier_env *env, u32 of
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

