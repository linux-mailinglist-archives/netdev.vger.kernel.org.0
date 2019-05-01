Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1F310965
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 16:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfEAOoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 10:44:16 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35651 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726842AbfEAOoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 10:44:13 -0400
Received: by mail-wr1-f67.google.com with SMTP id f7so16316445wrs.2
        for <netdev@vger.kernel.org>; Wed, 01 May 2019 07:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=R5NJyV1hjYhiIxMl0WDYqEzgZX2KJpAy+fglipSN330=;
        b=N0SS+hChbOhzq4FCYezKyxVNOuBxsf5LM44SRzSXeLEklYOUQmFaFIhIt4Qk8lc7UT
         kC76pAT+MdmasCYnGWwSkD5AlJMf/HJnnAmTIJBdcg5uXlajcoY6dGiKjlauA/YlBbl6
         nwWp0ERgDNkvZFrnyWujLSgtWbIs7KB+UTvR6sy8f8pEEdLqYHPARZMQ4pcCYUnEF33M
         PBj2mfWExo9ZWanyDuAud2fuSQyzjYg1Wa74kCVeH0qTWT/uZUw0bqbAkt1oKZxspoFR
         QdEq1q/7/30XFjnYAZZ98/j17zYfLWfYphsCh2Og2lGNzSKEmxUIPYgZc8V+5tcItQ73
         WSWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=R5NJyV1hjYhiIxMl0WDYqEzgZX2KJpAy+fglipSN330=;
        b=AvVEUJFRNJkKR8R0DEjdgaYfNnXHb/oUGW+8NzMuQRhn+20HfdayLqPZ+MeqkK4hYq
         Vl4GOfvPSCZWJieGX3ecZnVBZ4Pjxv8lM2A+29Krl2+nmRCw8xl+3c2URPwBKu8cHOig
         BJu0kMCzTO0y1sdM9luT6DqkL5YVtrwvV1jgTaEODjbvDw0EHLWMIOHW/GpzxAu3wI2N
         hwsSDW0KqzuKZbrQhAZxFiV3Dkp5O4tOtMUQBwq5vlPWZQc/2jRaHkEmQZuE13s2gNBQ
         8yDg4Crd8nEDFkBUdZiG05Qxr253+fda3sYSe5nF0UUY6a5rdcV/lk0mUZRKRooK2Xe4
         lVdg==
X-Gm-Message-State: APjAAAWHy9vcv9kddGmUzZkxMGF7bf5mvMO+rYfGKZx4Yb3TKdi/rs4a
        hvJbfkmk/m49xoXHxJEy5qZJpg==
X-Google-Smtp-Source: APXvYqyCNXoS5hlq7HwGHlEthlc7x22BEHVjtAfvT20aVHeo/6TM3XuDnCSNC+TGOW3gTsRmzr1c1A==
X-Received: by 2002:adf:f6ca:: with SMTP id y10mr22262103wrp.241.1556721850755;
        Wed, 01 May 2019 07:44:10 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id g10sm36164976wrq.2.2019.05.01.07.44.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 01 May 2019 07:44:10 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v5 bpf-next 01/17] bpf: verifier: offer more accurate helper function arg and return type
Date:   Wed,  1 May 2019 15:43:46 +0100
Message-Id: <1556721842-29836-2-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556721842-29836-1-git-send-email-jiong.wang@netronome.com>
References: <1556721842-29836-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF helper call transfers execution from eBPF insns to native functions
while verifier insn walker only walks eBPF insns. So, verifier can only
knows argument and return value types from explicit helper function
prototype descriptions.

For 32-bit optimization, it is important to know whether argument (register
use from eBPF insn) and return value (register define from external
function) is 32-bit or 64-bit, so corresponding registers could be
zero-extended correctly.

For arguments, they are register uses, we conservatively treat all of them
as 64-bit at default, while the following new bpf_arg_type are added so we
could start to mark those frequently used helper functions with more
accurate argument type.

  ARG_CONST_SIZE32
  ARG_CONST_SIZE32_OR_ZERO
  ARG_ANYTHING32

A few helper functions shown up frequently inside Cilium bpf program are
updated using these new types.

For return values, they are register defs, we need to know accurate width
for correct zero extensions. Given most of the helper functions returning
integers return 32-bit value, a new RET_INTEGER64 is added to make those
functions return 64-bit value. All related helper functions are updated.

Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 include/linux/bpf.h      |  6 +++++-
 kernel/bpf/core.c        |  2 +-
 kernel/bpf/helpers.c     | 10 +++++-----
 kernel/bpf/verifier.c    | 15 ++++++++++-----
 kernel/trace/bpf_trace.c |  4 ++--
 net/core/filter.c        | 38 +++++++++++++++++++-------------------
 6 files changed, 42 insertions(+), 33 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 9a21848..11a5fb9 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -198,9 +198,12 @@ enum bpf_arg_type {
 
 	ARG_CONST_SIZE,		/* number of bytes accessed from memory */
 	ARG_CONST_SIZE_OR_ZERO,	/* number of bytes accessed from memory or 0 */
+	ARG_CONST_SIZE32,	/* Likewise, but size fits into 32-bit */
+	ARG_CONST_SIZE32_OR_ZERO,	/* Ditto */
 
 	ARG_PTR_TO_CTX,		/* pointer to context */
 	ARG_ANYTHING,		/* any (initialized) argument is ok */
+	ARG_ANYTHING32,		/* Likewise, but it is a 32-bit argument */
 	ARG_PTR_TO_SPIN_LOCK,	/* pointer to bpf_spin_lock */
 	ARG_PTR_TO_SOCK_COMMON,	/* pointer to sock_common */
 	ARG_PTR_TO_INT,		/* pointer to int */
@@ -210,7 +213,8 @@ enum bpf_arg_type {
 
 /* type of values returned from helper functions */
 enum bpf_return_type {
-	RET_INTEGER,			/* function returns integer */
+	RET_INTEGER,			/* function returns 32-bit integer */
+	RET_INTEGER64,			/* function returns 64-bit integer */
 	RET_VOID,			/* function doesn't return anything */
 	RET_PTR_TO_MAP_VALUE,		/* returns a pointer to map elem value */
 	RET_PTR_TO_MAP_VALUE_OR_NULL,	/* returns a pointer to map elem value or NULL */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index ace8c22..2792eda 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2067,7 +2067,7 @@ const struct bpf_func_proto bpf_tail_call_proto = {
 	.ret_type	= RET_VOID,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_CONST_MAP_PTR,
-	.arg3_type	= ARG_ANYTHING,
+	.arg3_type	= ARG_ANYTHING32,
 };
 
 /* Stub for JITs that only support cBPF. eBPF programs are interpreted.
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 4266ffd..60f6e31 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -157,7 +157,7 @@ BPF_CALL_0(bpf_ktime_get_ns)
 const struct bpf_func_proto bpf_ktime_get_ns_proto = {
 	.func		= bpf_ktime_get_ns,
 	.gpl_only	= true,
-	.ret_type	= RET_INTEGER,
+	.ret_type	= RET_INTEGER64,
 };
 
 BPF_CALL_0(bpf_get_current_pid_tgid)
@@ -173,7 +173,7 @@ BPF_CALL_0(bpf_get_current_pid_tgid)
 const struct bpf_func_proto bpf_get_current_pid_tgid_proto = {
 	.func		= bpf_get_current_pid_tgid,
 	.gpl_only	= false,
-	.ret_type	= RET_INTEGER,
+	.ret_type	= RET_INTEGER64,
 };
 
 BPF_CALL_0(bpf_get_current_uid_gid)
@@ -193,7 +193,7 @@ BPF_CALL_0(bpf_get_current_uid_gid)
 const struct bpf_func_proto bpf_get_current_uid_gid_proto = {
 	.func		= bpf_get_current_uid_gid,
 	.gpl_only	= false,
-	.ret_type	= RET_INTEGER,
+	.ret_type	= RET_INTEGER64,
 };
 
 BPF_CALL_2(bpf_get_current_comm, char *, buf, u32, size)
@@ -221,7 +221,7 @@ const struct bpf_func_proto bpf_get_current_comm_proto = {
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_UNINIT_MEM,
-	.arg2_type	= ARG_CONST_SIZE,
+	.arg2_type	= ARG_CONST_SIZE32,
 };
 
 #if defined(CONFIG_QUEUED_SPINLOCKS) || defined(CONFIG_BPF_ARCH_SPINLOCK)
@@ -331,7 +331,7 @@ BPF_CALL_0(bpf_get_current_cgroup_id)
 const struct bpf_func_proto bpf_get_current_cgroup_id_proto = {
 	.func		= bpf_get_current_cgroup_id,
 	.gpl_only	= false,
-	.ret_type	= RET_INTEGER,
+	.ret_type	= RET_INTEGER64,
 };
 
 #ifdef CONFIG_CGROUP_BPF
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2717172..07ab563 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2492,7 +2492,9 @@ static bool arg_type_is_mem_ptr(enum bpf_arg_type type)
 static bool arg_type_is_mem_size(enum bpf_arg_type type)
 {
 	return type == ARG_CONST_SIZE ||
-	       type == ARG_CONST_SIZE_OR_ZERO;
+	       type == ARG_CONST_SIZE_OR_ZERO ||
+	       type == ARG_CONST_SIZE32 ||
+	       type == ARG_CONST_SIZE32_OR_ZERO;
 }
 
 static bool arg_type_is_int_ptr(enum bpf_arg_type type)
@@ -2526,7 +2528,7 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 regno,
 	if (err)
 		return err;
 
-	if (arg_type == ARG_ANYTHING) {
+	if (arg_type == ARG_ANYTHING || arg_type == ARG_ANYTHING32) {
 		if (is_pointer_value(env, regno)) {
 			verbose(env, "R%d leaks addr into helper function\n",
 				regno);
@@ -2554,7 +2556,9 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 regno,
 			 type != expected_type)
 			goto err_type;
 	} else if (arg_type == ARG_CONST_SIZE ||
-		   arg_type == ARG_CONST_SIZE_OR_ZERO) {
+		   arg_type == ARG_CONST_SIZE_OR_ZERO ||
+		   arg_type == ARG_CONST_SIZE32 ||
+		   arg_type == ARG_CONST_SIZE32_OR_ZERO) {
 		expected_type = SCALAR_VALUE;
 		if (type != expected_type)
 			goto err_type;
@@ -2660,7 +2664,8 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 regno,
 					      meta->map_ptr->value_size, false,
 					      meta);
 	} else if (arg_type_is_mem_size(arg_type)) {
-		bool zero_size_allowed = (arg_type == ARG_CONST_SIZE_OR_ZERO);
+		bool zero_size_allowed = (arg_type == ARG_CONST_SIZE_OR_ZERO ||
+					  arg_type == ARG_CONST_SIZE32_OR_ZERO);
 
 		/* remember the mem_size which may be used later
 		 * to refine return values.
@@ -3333,7 +3338,7 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 	}
 
 	/* update return register (already marked as written above) */
-	if (fn->ret_type == RET_INTEGER) {
+	if (fn->ret_type == RET_INTEGER || fn->ret_type == RET_INTEGER64) {
 		/* sets type to SCALAR_VALUE */
 		mark_reg_unknown(env, regs, BPF_REG_0);
 	} else if (fn->ret_type == RET_VOID) {
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 8607aba..f300b68 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -370,7 +370,7 @@ BPF_CALL_2(bpf_perf_event_read, struct bpf_map *, map, u64, flags)
 static const struct bpf_func_proto bpf_perf_event_read_proto = {
 	.func		= bpf_perf_event_read,
 	.gpl_only	= true,
-	.ret_type	= RET_INTEGER,
+	.ret_type	= RET_INTEGER64,
 	.arg1_type	= ARG_CONST_MAP_PTR,
 	.arg2_type	= ARG_ANYTHING,
 };
@@ -503,7 +503,7 @@ BPF_CALL_0(bpf_get_current_task)
 static const struct bpf_func_proto bpf_get_current_task_proto = {
 	.func		= bpf_get_current_task,
 	.gpl_only	= true,
-	.ret_type	= RET_INTEGER,
+	.ret_type	= RET_INTEGER64,
 };
 
 BPF_CALL_2(bpf_current_task_under_cgroup, struct bpf_map *, map, u32, idx)
diff --git a/net/core/filter.c b/net/core/filter.c
index 27b0dc0..56063c1 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1695,9 +1695,9 @@ static const struct bpf_func_proto bpf_skb_store_bytes_proto = {
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_ANYTHING,
+	.arg2_type	= ARG_ANYTHING32,
 	.arg3_type	= ARG_PTR_TO_MEM,
-	.arg4_type	= ARG_CONST_SIZE,
+	.arg4_type	= ARG_CONST_SIZE32,
 	.arg5_type	= ARG_ANYTHING,
 };
 
@@ -1760,9 +1760,9 @@ static const struct bpf_func_proto bpf_flow_dissector_load_bytes_proto = {
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_ANYTHING,
+	.arg2_type	= ARG_ANYTHING32,
 	.arg3_type	= ARG_PTR_TO_UNINIT_MEM,
-	.arg4_type	= ARG_CONST_SIZE,
+	.arg4_type	= ARG_CONST_SIZE32,
 };
 
 BPF_CALL_5(bpf_skb_load_bytes_relative, const struct sk_buff *, skb,
@@ -1911,7 +1911,7 @@ static const struct bpf_func_proto bpf_l3_csum_replace_proto = {
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_ANYTHING,
+	.arg2_type	= ARG_ANYTHING32,
 	.arg3_type	= ARG_ANYTHING,
 	.arg4_type	= ARG_ANYTHING,
 	.arg5_type	= ARG_ANYTHING,
@@ -1964,7 +1964,7 @@ static const struct bpf_func_proto bpf_l4_csum_replace_proto = {
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_ANYTHING,
+	.arg2_type	= ARG_ANYTHING32,
 	.arg3_type	= ARG_ANYTHING,
 	.arg4_type	= ARG_ANYTHING,
 	.arg5_type	= ARG_ANYTHING,
@@ -2003,9 +2003,9 @@ static const struct bpf_func_proto bpf_csum_diff_proto = {
 	.pkt_access	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_MEM_OR_NULL,
-	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
+	.arg2_type	= ARG_CONST_SIZE32_OR_ZERO,
 	.arg3_type	= ARG_PTR_TO_MEM_OR_NULL,
-	.arg4_type	= ARG_CONST_SIZE_OR_ZERO,
+	.arg4_type	= ARG_CONST_SIZE32_OR_ZERO,
 	.arg5_type	= ARG_ANYTHING,
 };
 
@@ -2186,7 +2186,7 @@ static const struct bpf_func_proto bpf_redirect_proto = {
 	.func           = bpf_redirect,
 	.gpl_only       = false,
 	.ret_type       = RET_INTEGER,
-	.arg1_type      = ARG_ANYTHING,
+	.arg1_type      = ARG_ANYTHING32,
 	.arg2_type      = ARG_ANYTHING,
 };
 
@@ -2964,7 +2964,7 @@ static const struct bpf_func_proto bpf_skb_change_proto_proto = {
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_ANYTHING,
+	.arg2_type	= ARG_ANYTHING32,
 	.arg3_type	= ARG_ANYTHING,
 };
 
@@ -2984,7 +2984,7 @@ static const struct bpf_func_proto bpf_skb_change_type_proto = {
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_ANYTHING,
+	.arg2_type	= ARG_ANYTHING32,
 };
 
 static u32 bpf_skb_net_base_len(const struct sk_buff *skb)
@@ -3287,7 +3287,7 @@ static const struct bpf_func_proto bpf_skb_change_tail_proto = {
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_ANYTHING,
+	.arg2_type	= ARG_ANYTHING32,
 	.arg3_type	= ARG_ANYTHING,
 };
 
@@ -3883,7 +3883,7 @@ static const struct bpf_func_proto bpf_skb_get_tunnel_key_proto = {
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_PTR_TO_UNINIT_MEM,
-	.arg3_type	= ARG_CONST_SIZE,
+	.arg3_type	= ARG_CONST_SIZE32,
 	.arg4_type	= ARG_ANYTHING,
 };
 
@@ -3992,7 +3992,7 @@ static const struct bpf_func_proto bpf_skb_set_tunnel_key_proto = {
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_PTR_TO_MEM,
-	.arg3_type	= ARG_CONST_SIZE,
+	.arg3_type	= ARG_CONST_SIZE32,
 	.arg4_type	= ARG_ANYTHING,
 };
 
@@ -4091,7 +4091,7 @@ BPF_CALL_1(bpf_skb_cgroup_id, const struct sk_buff *, skb)
 static const struct bpf_func_proto bpf_skb_cgroup_id_proto = {
 	.func           = bpf_skb_cgroup_id,
 	.gpl_only       = false,
-	.ret_type       = RET_INTEGER,
+	.ret_type       = RET_INTEGER64,
 	.arg1_type      = ARG_PTR_TO_CTX,
 };
 
@@ -4116,7 +4116,7 @@ BPF_CALL_2(bpf_skb_ancestor_cgroup_id, const struct sk_buff *, skb, int,
 static const struct bpf_func_proto bpf_skb_ancestor_cgroup_id_proto = {
 	.func           = bpf_skb_ancestor_cgroup_id,
 	.gpl_only       = false,
-	.ret_type       = RET_INTEGER,
+	.ret_type       = RET_INTEGER64,
 	.arg1_type      = ARG_PTR_TO_CTX,
 	.arg2_type      = ARG_ANYTHING,
 };
@@ -4162,7 +4162,7 @@ BPF_CALL_1(bpf_get_socket_cookie, struct sk_buff *, skb)
 static const struct bpf_func_proto bpf_get_socket_cookie_proto = {
 	.func           = bpf_get_socket_cookie,
 	.gpl_only       = false,
-	.ret_type       = RET_INTEGER,
+	.ret_type       = RET_INTEGER64,
 	.arg1_type      = ARG_PTR_TO_CTX,
 };
 
@@ -4174,7 +4174,7 @@ BPF_CALL_1(bpf_get_socket_cookie_sock_addr, struct bpf_sock_addr_kern *, ctx)
 static const struct bpf_func_proto bpf_get_socket_cookie_sock_addr_proto = {
 	.func		= bpf_get_socket_cookie_sock_addr,
 	.gpl_only	= false,
-	.ret_type	= RET_INTEGER,
+	.ret_type	= RET_INTEGER64,
 	.arg1_type	= ARG_PTR_TO_CTX,
 };
 
@@ -4186,7 +4186,7 @@ BPF_CALL_1(bpf_get_socket_cookie_sock_ops, struct bpf_sock_ops_kern *, ctx)
 static const struct bpf_func_proto bpf_get_socket_cookie_sock_ops_proto = {
 	.func		= bpf_get_socket_cookie_sock_ops,
 	.gpl_only	= false,
-	.ret_type	= RET_INTEGER,
+	.ret_type	= RET_INTEGER64,
 	.arg1_type	= ARG_PTR_TO_CTX,
 };
 
-- 
2.7.4

