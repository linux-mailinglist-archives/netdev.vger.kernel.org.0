Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35CE910966
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 16:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfEAOoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 10:44:17 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33114 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbfEAOoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 10:44:15 -0400
Received: by mail-wr1-f65.google.com with SMTP id e28so1770659wra.0
        for <netdev@vger.kernel.org>; Wed, 01 May 2019 07:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5gmdeCiumoo/+nRb5YIHgrhrVRpVHEnPYiT7ekQtPGI=;
        b=M+FIjdbGTZ1NOQyz89Sh4H79MO5GYfgMBj1x9D5597WEGpk/43BjKeLcBOet9CZZkh
         uyQYEFr3FXKrnItTOjsbV+OohdO9LckTv+XVI2BGgXFSMVi9Wp4zLQfATu62QB+OiZWV
         1wywX1Yq/5FHj6JS9OzCEOV5+DlcIGKeGgQS/IxP6FKf0z+OkPRmAtHkwr1JUHV6dutI
         1TCAoJlyWsmnIPTDPWwEFVxgMjVPHubRRKUUruFtgiCCkoi6dUNXbHSD72aElmo+76/Q
         4jJ2AgPG5QzrNp4aVVur2pwgJDcXYr+BI8RQm5E2UCZuzLLLHb0nVR5rghkkOzOiWkjY
         tiUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5gmdeCiumoo/+nRb5YIHgrhrVRpVHEnPYiT7ekQtPGI=;
        b=ngs311uW5nW6zIB3b3mvsXyvJVF0Ofh3oyQ1YO/MzI2B4TLJc56nVkgRlpnFInptw+
         NeCmUGzb6wUe2yIZ9YR+nj78LSMdMjpGeXOgynce2R9qwyeQRhMx8iNV30PPg6fQ+vzT
         L4FADQgwphcirtqBUr1LUpyBPjoPCW1XQPS7tX7lVySLVs4iOoFFmahm4QZgouj+6jX6
         0p1oAvni7l7PwIFFIpGEaCXz9V9vbJ7DQBXI2gFSvR33t51FMbNtch+nLPJyd8gq1Nag
         gUfqXewDtKjPqCS36Wf8YlBAZb3f6w0T9nTHH8SpS+rYzq0krL1DJ7zehJTn+bbzncMV
         BOFg==
X-Gm-Message-State: APjAAAVXfB1rYKVV2ErFsOknH5hvirjbP5QMT/Rkvdf3OX9J6eHxG7Cj
        MW2OmpiNh/qZPrYsgv15j2ZXfQ==
X-Google-Smtp-Source: APXvYqyB+dZRD1cCmcincSoQ/vVlb5zboKvqC7seyejLkJX0mzXxVCjnptfvaSJ3JtihB0m62QI+0A==
X-Received: by 2002:adf:dd12:: with SMTP id a18mr28127132wrm.188.1556721852933;
        Wed, 01 May 2019 07:44:12 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id g10sm36164976wrq.2.2019.05.01.07.44.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 01 May 2019 07:44:12 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v5 bpf-next 03/17] bpf: verifier: mark patched-insn with sub-register zext flag
Date:   Wed,  1 May 2019 15:43:48 +0100
Message-Id: <1556721842-29836-4-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556721842-29836-1-git-send-email-jiong.wang@netronome.com>
References: <1556721842-29836-1-git-send-email-jiong.wang@netronome.com>
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
index 6e62cc8..b75913c 100644
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

