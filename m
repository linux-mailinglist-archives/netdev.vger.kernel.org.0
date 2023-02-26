Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C88E6A2EE2
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 09:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjBZIwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 03:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjBZIwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 03:52:10 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C6713DC4;
        Sun, 26 Feb 2023 00:52:08 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id bn17so1876286pgb.10;
        Sun, 26 Feb 2023 00:52:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7xc259GjUZKykJMU7oKtUYVSPSoBfPnEWYraBTaL9Ag=;
        b=cHl0KB/AGBGjY7M77CIvVjgWq1LBtJo2Rl11bDuc2TW7KSrz12FzEAjIvhEba4x2HE
         ZpWzZrwDokvS0ORv4O1iH5Mqe8VapmX7j/kuex+4V6tDjjWImb4wS44n6plyWKAvbmBw
         rr3+IYI18yZg/D4qXFWrD1QwAq6JrulqFB8yvJzb8bhWalNcC9S/uLwEja/pV4C2egYb
         ZJE/Lk0mX8DSrUdVNQQ6wC5nJEgpGgrCUnk5mUzLTT75TKEfxuxnQOa+2HeC+XRrh4qD
         5PbTGEr5npAjaxo46dy9+i0PFTl2u1Gy1Tb+2to5O99STIUfozsSMpMUz/qSK2TV1Isi
         mulA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7xc259GjUZKykJMU7oKtUYVSPSoBfPnEWYraBTaL9Ag=;
        b=HvODBEtg/OyYLV+619VdH3i1IlxaNj4VwJR8aYtqH4sirWlKMAfJ/+ELeLp3TAKp+V
         jr8HNSBu02cn8tx3ZsYckXGKDVFKROBBqiPQ1IPV7gMDQy37ObBXZNGJ37sAe3vTjYOt
         KSoMIHlR32BhLzTr/miBHX7ZZC8AQGHsOd4CXvJdIsz7hCU19hWXeLNyv865DajuKzXd
         Iw2llbJF6f0CtvoLmU8yLynDnHUyO/RqMflgIqvbuyLf1x9DWON33kOokynBHxSfL5kF
         O35hZcDKoiClpwGxwNj8Tp6/H0I6dH34QVyageDO0o4qXP0m9Fs0UQ6GcsmYxu5eVuWB
         q2NQ==
X-Gm-Message-State: AO0yUKWpb/+VeafDeWJFN9uIWr1j2SoSeH6yawckWYPfoGIuQFA0Zg5f
        pECvEcrAKITbfQ61FSiURQz8dAqOAt4=
X-Google-Smtp-Source: AK7set8S03mcth1Tu96Rz1I/lJacNXJ8ETIU+BpvU0Qvz9ek2mte3nCYF9RD5GNzCtgeb/KYSqr3Pg==
X-Received: by 2002:aa7:9681:0:b0:5a8:abd7:a9e8 with SMTP id f1-20020aa79681000000b005a8abd7a9e8mr18034797pfk.27.1677401527287;
        Sun, 26 Feb 2023 00:52:07 -0800 (PST)
Received: from gatsby.corp.tfbnw.net (75-172-126-232.tukw.qwest.net. [75.172.126.232])
        by smtp.gmail.com with ESMTPSA id s10-20020a62e70a000000b00592591d1634sm2227299pfh.97.2023.02.26.00.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 00:52:06 -0800 (PST)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     bpf@vger.kernel.org
Cc:     martin.lau@kernel.org, andrii@kernel.org, ast@kernel.org,
        memxor@gmail.com, daniel@iogearbox.net, netdev@vger.kernel.org,
        toke@kernel.org, Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH v12 bpf-next 05/10] bpf: Refactor verifier dynptr into get_dynptr_arg_reg
Date:   Sun, 26 Feb 2023 00:51:15 -0800
Message-Id: <20230226085120.3907863-6-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230226085120.3907863-1-joannelkoong@gmail.com>
References: <20230226085120.3907863-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit refactors the logic for determining which register in a
function is the dynptr into "get_dynptr_arg_reg". This will be used
in the future when the dynptr reg for BPF_FUNC_dynptr_write will need
to be obtained in order to support writes for skb dynptrs.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 kernel/bpf/verifier.c | 80 +++++++++++++++++++++++++++----------------
 1 file changed, 50 insertions(+), 30 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a4cca21aefc3..cedd38292a62 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6689,6 +6689,28 @@ int check_func_arg_reg_off(struct bpf_verifier_env *env,
 	}
 }
 
+static struct bpf_reg_state *get_dynptr_arg_reg(struct bpf_verifier_env *env,
+						const struct bpf_func_proto *fn,
+						struct bpf_reg_state *regs)
+{
+	struct bpf_reg_state *state = NULL;
+	int i;
+
+	for (i = 0; i < MAX_BPF_FUNC_REG_ARGS; i++)
+		if (arg_type_is_dynptr(fn->arg_type[i])) {
+			if (state) {
+				verbose(env, "verifier internal error: multiple dynptr args\n");
+				return NULL;
+			}
+			state = &regs[BPF_REG_1 + i];
+		}
+
+	if (!state)
+		verbose(env, "verifier internal error: no dynptr arg found\n");
+
+	return state;
+}
+
 static int dynptr_id(struct bpf_verifier_env *env, struct bpf_reg_state *reg)
 {
 	struct bpf_func_state *state = func(env, reg);
@@ -8326,43 +8348,41 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 		}
 		break;
 	case BPF_FUNC_dynptr_data:
-		for (i = 0; i < MAX_BPF_FUNC_REG_ARGS; i++) {
-			if (arg_type_is_dynptr(fn->arg_type[i])) {
-				struct bpf_reg_state *reg = &regs[BPF_REG_1 + i];
-				int id, ref_obj_id;
-
-				if (meta.dynptr_id) {
-					verbose(env, "verifier internal error: meta.dynptr_id already set\n");
-					return -EFAULT;
-				}
-
-				if (meta.ref_obj_id) {
-					verbose(env, "verifier internal error: meta.ref_obj_id already set\n");
-					return -EFAULT;
-				}
+	{
+		struct bpf_reg_state *reg;
+		int id, ref_obj_id;
 
-				id = dynptr_id(env, reg);
-				if (id < 0) {
-					verbose(env, "verifier internal error: failed to obtain dynptr id\n");
-					return id;
-				}
+		reg = get_dynptr_arg_reg(env, fn, regs);
+		if (!reg)
+			return -EFAULT;
 
-				ref_obj_id = dynptr_ref_obj_id(env, reg);
-				if (ref_obj_id < 0) {
-					verbose(env, "verifier internal error: failed to obtain dynptr ref_obj_id\n");
-					return ref_obj_id;
-				}
 
-				meta.dynptr_id = id;
-				meta.ref_obj_id = ref_obj_id;
-				break;
-			}
+		if (meta.dynptr_id) {
+			verbose(env, "verifier internal error: meta.dynptr_id already set\n");
+			return -EFAULT;
 		}
-		if (i == MAX_BPF_FUNC_REG_ARGS) {
-			verbose(env, "verifier internal error: no dynptr in bpf_dynptr_data()\n");
+		if (meta.ref_obj_id) {
+			verbose(env, "verifier internal error: meta.ref_obj_id already set\n");
 			return -EFAULT;
 		}
+
+		id = dynptr_id(env, reg);
+		if (id < 0) {
+			verbose(env, "verifier internal error: failed to obtain dynptr id\n");
+			return id;
+		}
+
+		ref_obj_id = dynptr_ref_obj_id(env, reg);
+		if (ref_obj_id < 0) {
+			verbose(env, "verifier internal error: failed to obtain dynptr ref_obj_id\n");
+			return ref_obj_id;
+		}
+
+		meta.dynptr_id = id;
+		meta.ref_obj_id = ref_obj_id;
+
 		break;
+	}
 	case BPF_FUNC_user_ringbuf_drain:
 		err = __check_func_call(env, insn, insn_idx_p, meta.subprogno,
 					set_user_ringbuf_callback_state);
-- 
2.34.1

