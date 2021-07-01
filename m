Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A483B9675
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 21:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234174AbhGATX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 15:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233975AbhGATXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 15:23:25 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9117C061762;
        Thu,  1 Jul 2021 12:20:53 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id d12so7053364pgd.9;
        Thu, 01 Jul 2021 12:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=f2SUu3iT0Wce0h/ob6JKmABUNlZaN+fwjbxOyYm/eTE=;
        b=Lm5bfW1b2XhRnG6JZr3SiBK4K0SE+OgOSr2zH76SPsoQcvyouIAL5e9CvDUMaKA50c
         /y+HVuMTKdz4Ux78ouPihkjomsGjIGsvk2Uji9/ntYCKGWDfgK2Q1LZk4t+0keAXNcSn
         BaPEuffCujeVYR8Tppb4dC6EqIYncGqdEHe/WKe6Pf/qcNziHtmJLxkDXf3+IWUgJZxV
         tgFYFFThcLq5MzbZHZ168pKkS2vIQOd3+3RFGNjCjgrbLaJSeKuuqUTrY7iT32Fb2Hoy
         2hKsjSEZgPRIGe38velwrEnz7jF7wSTxpWs86XXLx+r6bmPg99T89YzTc75gSeut+8Zp
         XGeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=f2SUu3iT0Wce0h/ob6JKmABUNlZaN+fwjbxOyYm/eTE=;
        b=kHL0wiG4RFP0XCt9gwcUisFXjv3nTjhAz9gyUrAZixoMX7/0nrrHlbdRGIFWyH6b2y
         9N9DXVM+KfO412o+dwFFEWIOLYSW/nxaoOpnq8moRvwZDdPv2VxCFTDtOVBfufIF9l2T
         YE12vokVJB1KgvBRB6SUPeZL+l/OzREDBdCBd9rx8qu8YlMVmXPxrVAbs5N2wg/RYNWq
         CXbbPjqszQDI3LDLpECJvPxqR7Z3fxAQp3HDX2GFaJHx+HgIxK4b6TF7DWKbfQ/06mVy
         MvFhgq+TfnmUr7HHBxwF+zUY596epZ5QKNYReBsO2Q1NTmb5fBdaPcuya8/+119Rbhyo
         xahA==
X-Gm-Message-State: AOAM531F1jqhtxW+3cwpL26Ao9M0EI4vHSJcLAyfULpebsFTLr4oG8vA
        1UTGcm6FsL1hF3ASk7JHm/A=
X-Google-Smtp-Source: ABdhPJyqvae0eXNJ+qtGDoRG6cPSANSJFfeK6Imn7pWv2CaypIyC1W7k5a0zoFVKbTCmbgrShx6AdA==
X-Received: by 2002:a63:5b51:: with SMTP id l17mr1089364pgm.408.1625167253419;
        Thu, 01 Jul 2021 12:20:53 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:f1f2])
        by smtp.gmail.com with ESMTPSA id w8sm607725pgf.81.2021.07.01.12.20.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Jul 2021 12:20:52 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v4 bpf-next 3/9] bpf: Prevent pointer mismatch in bpf_timer_init.
Date:   Thu,  1 Jul 2021 12:20:38 -0700
Message-Id: <20210701192044.78034-4-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210701192044.78034-1-alexei.starovoitov@gmail.com>
References: <20210701192044.78034-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

bpf_timer_init() arguments are:
1. pointer to a timer (which is embedded in map element).
2. pointer to a map.
Make sure that pointer to a timer actually belongs to that map.

Use map_uid (which is unique id of inner map) to reject:
inner_map1 = bpf_map_lookup_elem(outer_map, key1)
inner_map2 = bpf_map_lookup_elem(outer_map, key2)
if (inner_map1 && inner_map2) {
    timer = bpf_map_lookup_elem(inner_map1);
    if (timer)
        // mismatch would have been allowed
        bpf_timer_init(timer, inner_map2);
}

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf_verifier.h |  9 ++++++++-
 kernel/bpf/verifier.c        | 31 ++++++++++++++++++++++++++++---
 2 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index e774ecc1cd1f..5d3169b57e6e 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -53,7 +53,14 @@ struct bpf_reg_state {
 		/* valid when type == CONST_PTR_TO_MAP | PTR_TO_MAP_VALUE |
 		 *   PTR_TO_MAP_VALUE_OR_NULL
 		 */
-		struct bpf_map *map_ptr;
+		struct {
+			struct bpf_map *map_ptr;
+			/* To distinguish map lookups from outer map
+			 * the map_uid is non-zero for registers
+			 * pointing to inner maps.
+			 */
+			u32 map_uid;
+		};
 
 		/* for PTR_TO_BTF_ID */
 		struct {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2bb7cf7cb31f..62759164759d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -255,6 +255,7 @@ struct bpf_call_arg_meta {
 	int mem_size;
 	u64 msize_max_value;
 	int ref_obj_id;
+	int map_uid;
 	int func_id;
 	struct btf *btf;
 	u32 btf_id;
@@ -1135,6 +1136,10 @@ static void mark_ptr_not_null_reg(struct bpf_reg_state *reg)
 		if (map->inner_map_meta) {
 			reg->type = CONST_PTR_TO_MAP;
 			reg->map_ptr = map->inner_map_meta;
+			/* transfer reg's id which is unique for every map_lookup_elem
+			 * as UID of the inner map.
+			 */
+			reg->map_uid = reg->id;
 		} else if (map->map_type == BPF_MAP_TYPE_XSKMAP) {
 			reg->type = PTR_TO_XDP_SOCK;
 		} else if (map->map_type == BPF_MAP_TYPE_SOCKMAP ||
@@ -4708,6 +4713,7 @@ static int process_timer_func(struct bpf_verifier_env *env, int regno,
 		verbose(env, "verifier bug. Two map pointers in a timer helper\n");
 		return -EFAULT;
 	}
+	meta->map_uid = reg->map_uid;
 	meta->map_ptr = map;
 	return 0;
 }
@@ -5006,11 +5012,29 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 
 	if (arg_type == ARG_CONST_MAP_PTR) {
 		/* bpf_map_xxx(map_ptr) call: remember that map_ptr */
-		if (meta->map_ptr && meta->map_ptr != reg->map_ptr) {
-			verbose(env, "Map pointer doesn't match bpf_timer.\n");
-			return -EINVAL;
+		if (meta->map_ptr) {
+			/* Use map_uid (which is unique id of inner map) to reject:
+			 * inner_map1 = bpf_map_lookup_elem(outer_map, key1)
+			 * inner_map2 = bpf_map_lookup_elem(outer_map, key2)
+			 * if (inner_map1 && inner_map2) {
+			 *     timer = bpf_map_lookup_elem(inner_map1);
+			 *     if (timer)
+			 *         // mismatch would have been allowed
+			 *         bpf_timer_init(timer, inner_map2);
+			 * }
+			 *
+			 * Comparing map_ptr is enough to distinguish normal and outer maps.
+			 */
+			if (meta->map_ptr != reg->map_ptr ||
+			    meta->map_uid != reg->map_uid) {
+				verbose(env,
+					"timer pointer in R1 map_uid=%d doesn't match map pointer in R2 map_uid=%d\n",
+					meta->map_uid, reg->map_uid);
+				return -EINVAL;
+			}
 		}
 		meta->map_ptr = reg->map_ptr;
+		meta->map_uid = reg->map_uid;
 	} else if (arg_type == ARG_PTR_TO_MAP_KEY) {
 		/* bpf_map_xxx(..., map_ptr, ..., key) call:
 		 * check that [key, key + map->key_size) are within
@@ -6206,6 +6230,7 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 			return -EINVAL;
 		}
 		regs[BPF_REG_0].map_ptr = meta.map_ptr;
+		regs[BPF_REG_0].map_uid = meta.map_uid;
 		if (fn->ret_type == RET_PTR_TO_MAP_VALUE) {
 			regs[BPF_REG_0].type = PTR_TO_MAP_VALUE;
 			if (map_value_has_spin_lock(meta.map_ptr))
-- 
2.30.2

