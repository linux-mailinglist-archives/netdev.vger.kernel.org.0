Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6291D3C9552
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 02:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbhGOA5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 20:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbhGOA5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 20:57:23 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158ECC06175F;
        Wed, 14 Jul 2021 17:54:31 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id y4so4274024pgl.10;
        Wed, 14 Jul 2021 17:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Sz1A1OLl4QcaQGX4xosKw+1RxVwaK5Ff6lkJu1391iQ=;
        b=kIyhFlZRGZgYX7tT8eCdC2wLjAzXSnUeSxNFjdp2rPzjhZkJ02i0qVqWW9H+nmwS8C
         Pj6kYOVjyz95pajvHcVk+JDUo13ec6cWX8VTh1Q6tT8DOQOiKxhvjGW4S4jltPQZiRmu
         xJ2TnC+PDHqpOVqgChW7IJlGScvLfymLchHj2BEciU4+mypW+Lo5vK8PaS9ENMiM/U5z
         H4/NrrI94rA+5wyBYm68udIec7mNR9WfeIaiwU3XZEvp4s/lN8PDuQ7/9yjeG9LVsd08
         OL7ez2ugjvPOgLqFhdWR9vMsBFWFlZBjXzQ2kQCTktHoEmk8PucDsJEaa0Abjwu/+TQx
         pVtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Sz1A1OLl4QcaQGX4xosKw+1RxVwaK5Ff6lkJu1391iQ=;
        b=OhBwQmVn86yzFUPVSzw5Lyi1EOqgcaM6HpE0WBJvpsSSBnhXRL0siKlBTwGse6EUTk
         RlrRLUGyppywsH48lG5/7g2Z6D6s5YdJkpuKfIdx3ad9VUsq0uN8MXzf7X4tqhtL48ZJ
         E+VuMRnsub4QCbq61BZK0fE1okhs0p0Nv3u1QMwnk5UtzvxOh9/ya6GQqW7O8PSwvk6b
         HbP6I3RDox2k7iFzvijElmg2c6dA7kqjBR8nVTdTjZgW57f8KcYOv8jSfTFBNQAO31Ay
         W0UiPwWDfa8kvBi44QVNe6gd+16YQJ3paZ5yvg5x9PuZc9ULyMo5uBdea+d8ia2p7vE2
         +bdw==
X-Gm-Message-State: AOAM5338B15j6rEKs0rXTEiuPx/MG9fmN7XX1gf6kLtrgFGPIFGRlEqA
        CCvczmkFBkdPjfs5Q2sh/Os=
X-Google-Smtp-Source: ABdhPJw5BSpRPMWnE6DVNXUJW9LF6rkaIYF72DPl5+KJUJVh5e4Vw/WMGqY1gfX7mJI3wHQoSea/1g==
X-Received: by 2002:a63:d84b:: with SMTP id k11mr828791pgj.372.1626310470633;
        Wed, 14 Jul 2021 17:54:30 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:120c])
        by smtp.gmail.com with ESMTPSA id nl2sm3439011pjb.10.2021.07.14.17.54.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Jul 2021 17:54:30 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v7 bpf-next 05/11] bpf: Prevent pointer mismatch in bpf_timer_init.
Date:   Wed, 14 Jul 2021 17:54:11 -0700
Message-Id: <20210715005417.78572-6-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210715005417.78572-1-alexei.starovoitov@gmail.com>
References: <20210715005417.78572-1-alexei.starovoitov@gmail.com>
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
Acked-by: Andrii Nakryiko <andrii@kernel.org>
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

