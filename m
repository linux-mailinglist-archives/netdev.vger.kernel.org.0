Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 370A65FE29
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 23:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727615AbfGDV1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 17:27:18 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42869 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727587AbfGDV1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 17:27:12 -0400
Received: by mail-wr1-f66.google.com with SMTP id a10so6761593wrp.9
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 14:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lNkKViCQzxQqkTh3Lu8ktBdzdSShu4QxmbjgltdSKAQ=;
        b=u55oriLWdCX9+oMM0hunfsAIq9z4H2PWKhdS0GhBrsZ/kkrdW7C75rE4js7jnB8rSL
         rZyogVCCIiKrESpK85pogg66nYaUPEqQYEW+V+hudEnPMaI76OP7BsqkHASC0C0Vd5Mi
         HGHzoH9GiaXyrZ86vU8UUiYxeIgSrHjEg/aiNweb1sH/ZC5EbAACTmDx0AoxcByEclKd
         wMDfJ6zRKGjXpIF6jJ+737cb8Yv2SpbNQ4t9TanioRn//qa1DDnn8DgWO49rvyBkbAFE
         d1fskITjiNETNzp3xhhqRIsJFR5jt0FLLYInWST5B6yCDmtNcyirHZbL8S5/QYuyP4AF
         juaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lNkKViCQzxQqkTh3Lu8ktBdzdSShu4QxmbjgltdSKAQ=;
        b=jWC2THSWIBRnFgS3MBT5xq0/j914fx5nuPf9hOFaLe/qvjvnGmbDXEQAja6nyj8TY5
         hq+6pJcI8nOSNpNd5TctnZbAwuMiL/4heONndbfFGw2Xan5Wy9DFCMnDqS7Q/Hg3UO5e
         2QZsCDdGkeVuIFds2VSZJFQnq62940fpPwXXt+JrdqBHvYSCGDxWD7D1E485ErZl1dv4
         HV+pqQ+xBTq72tYmpLqjTqplFLOe2ijJLphMi9gNdKHitCYuQzUNlezQhR7fgRN8ygna
         vKV0kDLKrvMcT71VXQRwzN4IaxhC+zkg5EHvmSYzzS4+kTBlbpfHPicEcM5NpgsOS9kA
         U7oQ==
X-Gm-Message-State: APjAAAXDt8U6n+cMHj4egwjpp5PFDwmmUgXJ4UWr/oO9IpQMcD0ii85A
        x3P74Q2SNkdTjszXHeh6dhAsug==
X-Google-Smtp-Source: APXvYqzcO4nKDqpGMPxDsUnV0Q6mmNU460CJYUvO6lyPku9R9BzCqGziIJjTH5MtgfAIYRES1q5ssA==
X-Received: by 2002:adf:cd8c:: with SMTP id q12mr358745wrj.103.1562275629866;
        Thu, 04 Jul 2019 14:27:09 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id t17sm9716654wrs.45.2019.07.04.14.27.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 04 Jul 2019 14:27:08 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     ecree@solarflare.com, naveen.n.rao@linux.vnet.ibm.com,
        andriin@fb.com, jakub.kicinski@netronome.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [RFC bpf-next 6/8] bpf: migrate zero extension opt to list patching infra
Date:   Thu,  4 Jul 2019 22:26:49 +0100
Message-Id: <1562275611-31790-7-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562275611-31790-1-git-send-email-jiong.wang@netronome.com>
References: <1562275611-31790-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch migrate 32-bit zero extension insertion to new list patching
infrastructure.

Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 kernel/bpf/verifier.c | 45 +++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 30ed28e..58d6bbe 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8549,10 +8549,9 @@ static int opt_subreg_zext_lo32_rnd_hi32(struct bpf_verifier_env *env,
 					 const union bpf_attr *attr)
 {
 	struct bpf_insn *patch, zext_patch[2], rnd_hi32_patch[4];
-	struct bpf_insn_aux_data *aux = env->insn_aux_data;
-	int i, patch_len, delta = 0, len = env->prog->len;
-	struct bpf_insn *insns = env->prog->insnsi;
-	struct bpf_prog *new_prog;
+	struct bpf_list_insn *list, *elem;
+	struct bpf_insn_aux_data *aux;
+	int patch_len, ret = 0;
 	bool rnd_hi32;
 
 	rnd_hi32 = attr->prog_flags & BPF_F_TEST_RND_HI32;
@@ -8560,12 +8559,16 @@ static int opt_subreg_zext_lo32_rnd_hi32(struct bpf_verifier_env *env,
 	rnd_hi32_patch[1] = BPF_ALU64_IMM(BPF_MOV, BPF_REG_AX, 0);
 	rnd_hi32_patch[2] = BPF_ALU64_IMM(BPF_LSH, BPF_REG_AX, 32);
 	rnd_hi32_patch[3] = BPF_ALU64_REG(BPF_OR, 0, BPF_REG_AX);
-	for (i = 0; i < len; i++) {
-		int adj_idx = i + delta;
-		struct bpf_insn insn;
 
-		insn = insns[adj_idx];
-		if (!aux[adj_idx].zext_dst) {
+	list = bpf_create_list_insn(env->prog);
+	if (IS_ERR(list))
+		return PTR_ERR(list);
+
+	for (elem = list; elem; elem = elem->next) {
+		struct bpf_insn insn = elem->insn;
+
+		aux = &env->insn_aux_data[elem->orig_idx - 1];
+		if (!aux->zext_dst) {
 			u8 code, class;
 			u32 imm_rnd;
 
@@ -8584,13 +8587,13 @@ static int opt_subreg_zext_lo32_rnd_hi32(struct bpf_verifier_env *env,
 			if (is_reg64(env, &insn, insn.dst_reg, NULL, DST_OP)) {
 				if (class == BPF_LD &&
 				    BPF_MODE(code) == BPF_IMM)
-					i++;
+					elem = elem->next;
 				continue;
 			}
 
 			/* ctx load could be transformed into wider load. */
 			if (class == BPF_LDX &&
-			    aux[adj_idx].ptr_type == PTR_TO_CTX)
+			    aux->ptr_type == PTR_TO_CTX)
 				continue;
 
 			imm_rnd = get_random_int();
@@ -8611,16 +8614,18 @@ static int opt_subreg_zext_lo32_rnd_hi32(struct bpf_verifier_env *env,
 		patch = zext_patch;
 		patch_len = 2;
 apply_patch_buffer:
-		new_prog = bpf_patch_insn_data(env, adj_idx, patch, patch_len);
-		if (!new_prog)
-			return -ENOMEM;
-		env->prog = new_prog;
-		insns = new_prog->insnsi;
-		aux = env->insn_aux_data;
-		delta += patch_len - 1;
+		elem = bpf_patch_list_insn(elem, patch, patch_len);
+		if (IS_ERR(elem)) {
+			ret = PTR_ERR(elem);
+			goto free_list_ret;
+		}
 	}
-
-	return 0;
+	env = verifier_linearize_list_insn(env, list);
+	if (IS_ERR(env))
+		ret = PTR_ERR(env);
+free_list_ret:
+	bpf_destroy_list_insn(list);
+	return ret;
 }
 
 /* convert load instructions that access fields of a context type into a
-- 
2.7.4

