Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAB3D3C7AD3
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 03:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237311AbhGNBI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 21:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237290AbhGNBIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 21:08:23 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0645BC0613DD;
        Tue, 13 Jul 2021 18:05:32 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id s18so298959pgg.8;
        Tue, 13 Jul 2021 18:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pVGZvz1JUJtcejayKWYanycok+YdZfJAa8MgXs3EF8U=;
        b=JaJkHZVGIuA6wIeUqZfPRAaN/F2T6FIv6NDuAlE+E3JWBgM32F1ulG3A0WFIHSCJm2
         N/uZh78W6jkWB2b4xmcGxbeMJo/wDgYDe19c3Ko4S3Ud484hyPmM14JIXKLyRKki2Ipo
         1vAfcc4UQ6arn4KJIArXhT3eRtnrTwXc/KapdY17ImbvwJ1qpkXJ1NwWIAGSGkr5VY59
         t8ZUSWqQ9/8NuWP+OzX/FIK9szA7tQSfjQVQRyvA7oBv1QC+tvbip5DXte+9tik8oXC1
         44idetF+bX9XSxJlLgx5MppanLj3haruILdcaORtl7CUeiZx3Ixa0vtQj4yu2GxeYyGG
         KIbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pVGZvz1JUJtcejayKWYanycok+YdZfJAa8MgXs3EF8U=;
        b=DrYoHCqjeJkXPt5r51XCtaUZ/5Lxd2rn5YyxrxcNcby3XKP8fUqQRYAudGbfNrUMwA
         A5qaVEEYxb4YKGW6f/kpudcTcjSf8W7yfLLJ4ZQzKZQlxukg8c0FFheYL6tP2AzD9PxG
         VXwqBZkPSoi2c28jG3giAWLhiQHguX4cvfgJk+8K7DcqQii7IMPRaQeFykGbw4BPRVIp
         bTbPiSMnyfHNXfcnFtdUS6IoRWVfFT4XrcEj+s14LOOnW3Gl6Ucg6YWyPNmxuHYk27l7
         52DbtJ6coy25h+AbzpJaofS0Pgc9XN8I8Vr6vhQ+efV+AGkUqHUOn1M6mB8fBB6YjVEL
         mRVg==
X-Gm-Message-State: AOAM533vQb0MlfwBY/GxnOse0pfAYVrYyvpnETOleBALV57uMcKkjVf6
        GjztyC3BoaC7/AEsD1NVb6E=
X-Google-Smtp-Source: ABdhPJzi2EfGWek+ei7NiW5O83gfhrRgpQxrYL7h3gk3VtYK1ap0CG3/EhzwXnIxRS5BCkWLIto+EA==
X-Received: by 2002:a63:dc4e:: with SMTP id f14mr6638304pgj.378.1626224731615;
        Tue, 13 Jul 2021 18:05:31 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:10f1])
        by smtp.gmail.com with ESMTPSA id cx4sm4073560pjb.53.2021.07.13.18.05.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Jul 2021 18:05:31 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v6 bpf-next 05/11] bpf: Prevent pointer mismatch in bpf_timer_init.
Date:   Tue, 13 Jul 2021 18:05:13 -0700
Message-Id: <20210714010519.37922-6-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210714010519.37922-1-alexei.starovoitov@gmail.com>
References: <20210714010519.37922-1-alexei.starovoitov@gmail.com>
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
Acked-by: Martin KaFai Lau <kafai@fb.com>
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
index e44c36107d11..cb393de3c818 100644
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
@@ -6204,6 +6228,7 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 			return -EINVAL;
 		}
 		regs[BPF_REG_0].map_ptr = meta.map_ptr;
+		regs[BPF_REG_0].map_uid = meta.map_uid;
 		if (fn->ret_type == RET_PTR_TO_MAP_VALUE) {
 			regs[BPF_REG_0].type = PTR_TO_MAP_VALUE;
 			if (map_value_has_spin_lock(meta.map_ptr))
-- 
2.30.2

