Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1614D2A148
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 00:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404402AbfEXW1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 18:27:25 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42457 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404394AbfEXW1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 18:27:25 -0400
Received: by mail-wr1-f67.google.com with SMTP id l2so11385619wrb.9
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 15:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=I1hfffn436msqgFGWpQyLY1Lerd3i6WTxQeF86oeiLU=;
        b=xrhB4gr/HTDtY1wiBV1H1RNKAVHMSVtP5dY/YlJ/dLG0agcoaH0e6ybS0vbIeYPp5M
         Tlz9s8vjtnkeleCdbA8Piz8TGT6oh4d09JnGuu+gwLNhPJRN5vQjWWIvsnVbTxBO1E/z
         vYYe4aCL4RLMZ66hrPX3TbOlIrbpn9jtJQTaV2hPuUMu49AksQiC0LoTrN+0/F7LRgrj
         cGMk1T7dUd+KEkFW4v7wHUmxAKwkpcqQ1f9lg+X3MySBPaNrJlqMk0CNl4wY4gM2X9a8
         CDx7J/UzjJCtX7zI2Z/sCiTRmsamsHxtyv+m0j8Q7iFxPeIQWYF3tmzCXHEiHKf8SN4x
         LeLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=I1hfffn436msqgFGWpQyLY1Lerd3i6WTxQeF86oeiLU=;
        b=XUc7X9UVvFvz0/x0blj/6wiiVQgSM18wlsnzEph5L6cz08ET1hP1GXHjn6STkBWkAc
         Cxe5VZEOWHIwg8DwEzSN2cz+wQS//SBBVa3kWPrUf+Inrg44gJS5N6usz1NemCOCbWSM
         O/0szvMNnaUnxk4Rx3Be1AFnJ+W5+XQcaaPfJrr9N1UhOVKeH/IreOiCQnLKFho8c0Hj
         XBYx4Y5NFSIq3AT8feQVreOnZf8tDvFosj/BA1f07YBQHPqdH3Nc3GxdDAq752u1oCyy
         r4xRNFC6Eqr+7EUwEjQUY+6mmhIJ+lt4HMxHujXcMN/KPa+HbNx7zsYVNDkV1RzP6dff
         tc0g==
X-Gm-Message-State: APjAAAUbjqFqzzwI8hUG9hT/oPSPV5ZgwjHP1uHdowzO1RG9iYRbOGDf
        tu7VCQ+0+CK9EDmY9jA2Lnh0qA==
X-Google-Smtp-Source: APXvYqwwCCa9jOqgea7wfz8+XQvN5C9Zj6qyw+3/qxE1FRJl5YuwENRf9PksliClq8s6ljKD6/pSvg==
X-Received: by 2002:adf:e9ca:: with SMTP id l10mr134069wrn.47.1558736843343;
        Fri, 24 May 2019 15:27:23 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id y10sm7194961wmg.8.2019.05.24.15.27.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 24 May 2019 15:27:22 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, davem@davemloft.net,
        paul.burton@mips.com, udknight@gmail.com, zlim.lnx@gmail.com,
        illusionist.neo@gmail.com, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, jakub.kicinski@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v9 bpf-next 02/17] bpf: verifier: mark patched-insn with sub-register zext flag
Date:   Fri, 24 May 2019 23:25:13 +0100
Message-Id: <1558736728-7229-3-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558736728-7229-1-git-send-email-jiong.wang@netronome.com>
References: <1558736728-7229-1-git-send-email-jiong.wang@netronome.com>
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

