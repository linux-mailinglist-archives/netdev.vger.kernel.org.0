Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 478D15FE23
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 23:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbfGDV1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 17:27:12 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38546 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727190AbfGDV1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 17:27:08 -0400
Received: by mail-wr1-f68.google.com with SMTP id p11so2361322wro.5
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 14:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rmj2fYUJnKNsAibTMScIgBH2oZ8fxdXPbaOiBceF+Hk=;
        b=rHckrcRir8FQOCmDB+8hpO9WLOd/6sDCHrC5GSG2kTguokRGyrIsxWxVV761YdaSMZ
         hdV9AiTUHvgm0R8gO3en/3DruXhtoAauw/+XVzcAdyeo8rMn5WNDCc4BW9WHeWaZuugc
         8jdZNZiVVNImAQrQQk5RT5DNe1U10wmfoEhksqGiP7pLkmt7VoWzI+1wTxW9+BUhbvLO
         Cv1ldRhygIxRJp/ByPfRBWyd7GLliTKM8iwp7UGbLdcOlA5HEfTTlLX07df9yxnxY61B
         lrPE4KZ9vp4YpijXmXdxbtRce/WRH7DjpBdxyQ41GUSIhnUTKTAIQAcHQ3H5kpUSCFhy
         q/cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rmj2fYUJnKNsAibTMScIgBH2oZ8fxdXPbaOiBceF+Hk=;
        b=TI7yKUiH3Amo0m555uZAu0h/KkBmyzirAyqAb0RA+WJn81hJ82Hfsz+R1JcQGdaYVX
         kiZKmVS84ZvVdIXwm78T0ZWIj2OQ/YFQiZlxix3LrhxwPB/F6mjB9M6loO/uzS5EqMDj
         2ObuJehxWsxtdvTjUh20UN0a/Bq2wmHMc5cT4XzXI/WpWh9iJ8noGgdrjrgxBxFqUgUW
         wuj8gWjMXOAD79cuCkfFglS3inNws48AA1pZof5F/Z/9C4MU08W2Q0ydVYibc5ZrHysI
         QZrsYEpDB6s8+mAXb0s2CgzKGcPKZKXTgDPo0t86sVyvBD/Kb2zzv3a6dhwaVkNcLWut
         mPDw==
X-Gm-Message-State: APjAAAUQ3TYkjPpWJUBR2oopfeYfEYs1QuFrt4p7CGsp9plN2yBv4G30
        c7wDA4pkiSdZTJke8cIfTIpMmA==
X-Google-Smtp-Source: APXvYqyKK0iKj2++0xhLdyJKPt1GvFmol8NMzEM8kwyggPmFJx/ef5aJ66ekIrY3aMvkeqjgqcNR0g==
X-Received: by 2002:a5d:55c2:: with SMTP id i2mr343874wrw.113.1562275626975;
        Thu, 04 Jul 2019 14:27:06 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id t17sm9716654wrs.45.2019.07.04.14.27.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 04 Jul 2019 14:27:06 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     ecree@solarflare.com, naveen.n.rao@linux.vnet.ibm.com,
        andriin@fb.com, jakub.kicinski@netronome.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [RFC bpf-next 3/8] bpf: migrate jit blinding to list patching infra
Date:   Thu,  4 Jul 2019 22:26:46 +0100
Message-Id: <1562275611-31790-4-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562275611-31790-1-git-send-email-jiong.wang@netronome.com>
References: <1562275611-31790-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

List linerization function will figure out the new jump destination of
patched/blinded jumps. No need of destination adjustment inside
bpf_jit_blind_insn any more.

Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 kernel/bpf/core.c | 76 ++++++++++++++++++++++++++-----------------------------
 1 file changed, 36 insertions(+), 40 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index e60703e..c3a5f84 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1162,7 +1162,6 @@ static int bpf_jit_blind_insn(const struct bpf_insn *from,
 {
 	struct bpf_insn *to = to_buff;
 	u32 imm_rnd = get_random_int();
-	s16 off;
 
 	BUILD_BUG_ON(BPF_REG_AX  + 1 != MAX_BPF_JIT_REG);
 	BUILD_BUG_ON(MAX_BPF_REG + 1 != MAX_BPF_JIT_REG);
@@ -1234,13 +1233,10 @@ static int bpf_jit_blind_insn(const struct bpf_insn *from,
 	case BPF_JMP | BPF_JSGE | BPF_K:
 	case BPF_JMP | BPF_JSLE | BPF_K:
 	case BPF_JMP | BPF_JSET | BPF_K:
-		/* Accommodate for extra offset in case of a backjump. */
-		off = from->off;
-		if (off < 0)
-			off -= 2;
 		*to++ = BPF_ALU64_IMM(BPF_MOV, BPF_REG_AX, imm_rnd ^ from->imm);
 		*to++ = BPF_ALU64_IMM(BPF_XOR, BPF_REG_AX, imm_rnd);
-		*to++ = BPF_JMP_REG(from->code, from->dst_reg, BPF_REG_AX, off);
+		*to++ = BPF_JMP_REG(from->code, from->dst_reg, BPF_REG_AX,
+				    from->off);
 		break;
 
 	case BPF_JMP32 | BPF_JEQ  | BPF_K:
@@ -1254,14 +1250,10 @@ static int bpf_jit_blind_insn(const struct bpf_insn *from,
 	case BPF_JMP32 | BPF_JSGE | BPF_K:
 	case BPF_JMP32 | BPF_JSLE | BPF_K:
 	case BPF_JMP32 | BPF_JSET | BPF_K:
-		/* Accommodate for extra offset in case of a backjump. */
-		off = from->off;
-		if (off < 0)
-			off -= 2;
 		*to++ = BPF_ALU32_IMM(BPF_MOV, BPF_REG_AX, imm_rnd ^ from->imm);
 		*to++ = BPF_ALU32_IMM(BPF_XOR, BPF_REG_AX, imm_rnd);
 		*to++ = BPF_JMP32_REG(from->code, from->dst_reg, BPF_REG_AX,
-				      off);
+				      from->off);
 		break;
 
 	case BPF_LD | BPF_IMM | BPF_DW:
@@ -1332,10 +1324,9 @@ void bpf_jit_prog_release_other(struct bpf_prog *fp, struct bpf_prog *fp_other)
 struct bpf_prog *bpf_jit_blind_constants(struct bpf_prog *prog)
 {
 	struct bpf_insn insn_buff[16], aux[2];
-	struct bpf_prog *clone, *tmp;
-	int insn_delta, insn_cnt;
-	struct bpf_insn *insn;
-	int i, rewritten;
+	struct bpf_list_insn *list, *elem;
+	struct bpf_prog *clone, *ret_prog;
+	int rewritten;
 
 	if (!bpf_jit_blinding_enabled(prog) || prog->blinded)
 		return prog;
@@ -1344,43 +1335,48 @@ struct bpf_prog *bpf_jit_blind_constants(struct bpf_prog *prog)
 	if (!clone)
 		return ERR_PTR(-ENOMEM);
 
-	insn_cnt = clone->len;
-	insn = clone->insnsi;
+	list = bpf_create_list_insn(clone);
+	if (IS_ERR(list))
+		return (struct bpf_prog *)list;
+
+	/* kill uninitialized warning on some gcc versions. */
+	memset(&aux, 0, sizeof(aux));
+
+	for (elem = list; elem; elem = elem->next) {
+		struct bpf_list_insn *next = elem->next;
+		struct bpf_insn insn = elem->insn;
 
-	for (i = 0; i < insn_cnt; i++, insn++) {
 		/* We temporarily need to hold the original ld64 insn
 		 * so that we can still access the first part in the
 		 * second blinding run.
 		 */
-		if (insn[0].code == (BPF_LD | BPF_IMM | BPF_DW) &&
-		    insn[1].code == 0)
-			memcpy(aux, insn, sizeof(aux));
+		if (insn.code == (BPF_LD | BPF_IMM | BPF_DW)) {
+			struct bpf_insn next_insn = next->insn;
 
-		rewritten = bpf_jit_blind_insn(insn, aux, insn_buff);
+			if (next_insn.code == 0) {
+				aux[0] = insn;
+				aux[1] = next_insn;
+			}
+		}
+
+		rewritten = bpf_jit_blind_insn(&insn, aux, insn_buff);
 		if (!rewritten)
 			continue;
 
-		tmp = bpf_patch_insn_single(clone, i, insn_buff, rewritten);
-		if (IS_ERR(tmp)) {
-			/* Patching may have repointed aux->prog during
-			 * realloc from the original one, so we need to
-			 * fix it up here on error.
-			 */
-			bpf_jit_prog_release_other(prog, clone);
-			return tmp;
+		elem = bpf_patch_list_insn(elem, insn_buff, rewritten);
+		if (IS_ERR(elem)) {
+			ret_prog = (struct bpf_prog *)elem;
+			goto free_list_ret;
 		}
-
-		clone = tmp;
-		insn_delta = rewritten - 1;
-
-		/* Walk new program and skip insns we just inserted. */
-		insn = clone->insnsi + i + insn_delta;
-		insn_cnt += insn_delta;
-		i        += insn_delta;
 	}
 
-	clone->blinded = 1;
-	return clone;
+	clone = bpf_linearize_list_insn(clone, list);
+	if (!IS_ERR(clone))
+		clone->blinded = 1;
+	ret_prog = clone;
+free_list_ret:
+	bpf_destroy_list_insn(list);
+	return ret_prog;
 }
 #endif /* CONFIG_BPF_JIT */
 
-- 
2.7.4

