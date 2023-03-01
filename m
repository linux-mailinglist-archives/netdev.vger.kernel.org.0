Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8F606A703F
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 16:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbjCAPvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 10:51:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbjCAPvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 10:51:19 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD66547402;
        Wed,  1 Mar 2023 07:51:06 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id bn17so7964232pgb.10;
        Wed, 01 Mar 2023 07:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677685866;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L2UtJlExuvFSR1bwoqpcsYEUjDe96/jLX9Zu/ggBW4E=;
        b=Fk5bt0705UsGrMetmczQCY/1CP0bXk0rymQpp5Wt5VSrnARvPKvhgHcA9SvqCrbHv8
         SaDYPNLkar9wMN+bY1CfZFkb7U97tFLvnrsrWBzSPVruHfqCjYCYgisRD792G5vTdjZK
         Y5qtVkRH6+XaB8P0dZLzaLoc2bNKGrR2tafoPU6QzkZd98Rc9/TIPvmJL2yvDlY9f57X
         sKlvHl29moT7naC3r4xGzxaJj4BbV8shusOsgIi+Vdp+ub+pG9xR/ED4Py6xuAhosxVS
         YUXaZccoe8yqt+ctufdsj4ZWR79v103sJAY+y5v3eU1sIdcetokjeZykbmcVabPP604b
         K+tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677685866;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L2UtJlExuvFSR1bwoqpcsYEUjDe96/jLX9Zu/ggBW4E=;
        b=rOpfBUXsFX0gqdNprh7slzwgzxJ8XXIqfwaZ7HhRYdiWXA9WieVZp1QH5f1lKhdRtt
         gwWPJwzsFdn3thATLH1xxJwC3krNR4XlHaXxBtPwSJYYU3GQ6hlrupptMSa98wCLtNjy
         I3jtCx7ukflrObP5DQUXxdGs3XwwDyl02z7OahiLlNBdMRM0FpQc0sE7GOpUht2hWzql
         PYTnCg/U/9reBzm3oTTND3HYfXwHvs9duOqx5Po/B0igGgGbC+yaSUxAifvURV36/pnr
         VUWG7ecLYpOqNqxC/N1D0tSfpwsow/6ZMO1Z8f8MpNQkzBwsmm/autxHpLIjbpRUcCFy
         +teA==
X-Gm-Message-State: AO0yUKUwuIWGL7d70qZ+/f90UBm9lBsXx+6M2Ts6pHKlBjGeQkrQkjNC
        fu7X034YlD0ITWqP/pd8ii2ibDX+fyU=
X-Google-Smtp-Source: AK7set8XEHBlG4768pLonz+sRi1CEZ7ORkvO1mlln74b73CQ9BT1HDEWzoMZRKaOus7UVmBHoemfOA==
X-Received: by 2002:aa7:9f85:0:b0:60b:e13:a10b with SMTP id z5-20020aa79f85000000b0060b0e13a10bmr670971pfr.3.1677685865728;
        Wed, 01 Mar 2023 07:51:05 -0800 (PST)
Received: from gatsby.corp.tfbnw.net (75-172-126-232.tukw.qwest.net. [75.172.126.232])
        by smtp.gmail.com with ESMTPSA id c9-20020a637249000000b00502f20aa4desm7589490pgn.70.2023.03.01.07.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 07:51:05 -0800 (PST)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     bpf@vger.kernel.org
Cc:     martin.lau@kernel.org, andrii@kernel.org, ast@kernel.org,
        memxor@gmail.com, daniel@iogearbox.net, netdev@vger.kernel.org,
        toke@kernel.org, Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH v13 bpf-next 05/10] bpf: Refactor verifier dynptr into get_dynptr_arg_reg
Date:   Wed,  1 Mar 2023 07:49:48 -0800
Message-Id: <20230301154953.641654-6-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230301154953.641654-1-joannelkoong@gmail.com>
References: <20230301154953.641654-1-joannelkoong@gmail.com>
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
index 82e39fc5ed05..8fd2f26a8977 100644
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

