Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1968C6D57B5
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 06:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbjDDEuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 00:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbjDDEun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 00:50:43 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5D219B6;
        Mon,  3 Apr 2023 21:50:42 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id n14so14321595plc.8;
        Mon, 03 Apr 2023 21:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680583841; x=1683175841;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XRV8NBbXdQHSBPKySVW/N3uls5gmhkscUAC+YSKpnxc=;
        b=CEtZ5kx0ey+K84A5EPxxTiDF3C8LXM+Nqaae32P42l/EVhmz9OzFlkAuJXGNxM5els
         EOBCq4FqvuGUU3OFgM34q7hQeDRD4VpY2jsW6zi3TBe0EShxqMLigicNwCMO2jb2t6R+
         aOsW6WoX9iJu1SUEIgL/sA6/ihvnnNjba+tFA7Bul2bxcWVcQOOm8lOPd4D3sr88cx41
         T/DPLXv+HgPFj7dL2VLyi/ywVY9OmGfGBU7Bx+luX/pKh1UY784aoAbE5OsGV/Xb5PmH
         MUcNZN33pXD1uGlxJkJuMUVokRBU9r07RVtffntIGCkeg6wgGjfZsRpMzfb89MauA0r0
         AwvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680583841; x=1683175841;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XRV8NBbXdQHSBPKySVW/N3uls5gmhkscUAC+YSKpnxc=;
        b=fxGMg5ADCOiU2Ib9s5h7xX+0OkHNNXQd3ZbwGZMRfbtqmyRAmvRDWNhQ46DD1StMzq
         xSkuyTR6L44d80VwfZIzfXCtdvO9QJ4dffSZATVwmwXUaJ9lyScGakDNdx0Qp9tCCwgu
         EOf8pQA5mmC4M/4Yw2xaIYN6Nevy1Pbb1f8WPffgvMuAmAeqcaP0BM4AnwibqCRJPRHZ
         dj6wvEDC/OiflQiPsgcIpMsUEj6rqqQUZGB3kvz6V2Evw7Sn/G5eZGmiMAeyoaUeJmbw
         lHzF67lOVeoIWfHMVbHNDZPExRj1rfonWn7JG3qXQhRQ45fmr4D/MMf5CQlgFJz5Ya6j
         Xing==
X-Gm-Message-State: AAQBX9c/NNY7FAhXuxSPXOn+Q/kEes1CroyXl5otQHS+vdZwbT6m2Pni
        tTnQKiKXy45zh2rOVm4JXODACVzHWCk=
X-Google-Smtp-Source: AKy350ZHeaL1bAGu0v2d8QAr0GViXxV6tRTHth6Lwr/pkWAe3BUc9e0tvqOCGIIipSQIZHcw9er0TA==
X-Received: by 2002:a17:90b:1d8e:b0:23f:29a:5554 with SMTP id pf14-20020a17090b1d8e00b0023f029a5554mr1159426pjb.48.1680583841398;
        Mon, 03 Apr 2023 21:50:41 -0700 (PDT)
Received: from dhcp-172-26-102-232.DHCP.thefacebook.com ([2620:10d:c090:400::5:3c8])
        by smtp.gmail.com with ESMTPSA id q3-20020a17090a938300b0023b15e61f07sm7085896pjo.12.2023.04.03.21.50.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 03 Apr 2023 21:50:41 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next 2/8] bpf: Remove unused arguments from btf_struct_access().
Date:   Mon,  3 Apr 2023 21:50:23 -0700
Message-Id: <20230404045029.82870-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230404045029.82870-1-alexei.starovoitov@gmail.com>
References: <20230404045029.82870-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Remove unused arguments from btf_struct_access() callback.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf.h              |  3 +--
 include/linux/filter.h           |  3 +--
 kernel/bpf/verifier.c            |  4 ++--
 net/bpf/bpf_dummy_struct_ops.c   | 12 +++++-------
 net/core/filter.c                | 13 +++++--------
 net/ipv4/bpf_tcp_ca.c            |  3 +--
 net/netfilter/nf_conntrack_bpf.c |  3 +--
 7 files changed, 16 insertions(+), 25 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 2d8f3f639e68..4f689dda748f 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -893,8 +893,7 @@ struct bpf_verifier_ops {
 				  struct bpf_prog *prog, u32 *target_size);
 	int (*btf_struct_access)(struct bpf_verifier_log *log,
 				 const struct bpf_reg_state *reg,
-				 int off, int size, enum bpf_access_type atype,
-				 u32 *next_btf_id, enum bpf_type_flag *flag);
+				 int off, int size);
 };
 
 struct bpf_prog_offload_ops {
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 23c08c31bea9..5364b0c52c1d 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -571,8 +571,7 @@ DECLARE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
 extern struct mutex nf_conn_btf_access_lock;
 extern int (*nfct_btf_struct_access)(struct bpf_verifier_log *log,
 				     const struct bpf_reg_state *reg,
-				     int off, int size, enum bpf_access_type atype,
-				     u32 *next_btf_id, enum bpf_type_flag *flag);
+				     int off, int size);
 
 typedef unsigned int (*bpf_dispatcher_fn)(const void *ctx,
 					  const struct bpf_insn *insnsi,
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 83984568ccb4..5ca520e5eddf 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5459,7 +5459,7 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
 	const struct btf_type *t = btf_type_by_id(reg->btf, reg->btf_id);
 	const char *tname = btf_name_by_offset(reg->btf, t->name_off);
 	enum bpf_type_flag flag = 0;
-	u32 btf_id;
+	u32 btf_id = 0;
 	int ret;
 
 	if (!env->allow_ptr_leaks) {
@@ -5509,7 +5509,7 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
 			verbose(env, "verifier internal error: reg->btf must be kernel btf\n");
 			return -EFAULT;
 		}
-		ret = env->ops->btf_struct_access(&env->log, reg, off, size, atype, &btf_id, &flag);
+		ret = env->ops->btf_struct_access(&env->log, reg, off, size);
 	} else {
 		/* Writes are permitted with default btf_struct_access for
 		 * program allocated objects (which always have ref_obj_id > 0),
diff --git a/net/bpf/bpf_dummy_struct_ops.c b/net/bpf/bpf_dummy_struct_ops.c
index 9535c8506cda..5918d1b32e19 100644
--- a/net/bpf/bpf_dummy_struct_ops.c
+++ b/net/bpf/bpf_dummy_struct_ops.c
@@ -173,14 +173,11 @@ static int bpf_dummy_ops_check_member(const struct btf_type *t,
 
 static int bpf_dummy_ops_btf_struct_access(struct bpf_verifier_log *log,
 					   const struct bpf_reg_state *reg,
-					   int off, int size, enum bpf_access_type atype,
-					   u32 *next_btf_id,
-					   enum bpf_type_flag *flag)
+					   int off, int size)
 {
 	const struct btf_type *state;
 	const struct btf_type *t;
 	s32 type_id;
-	int err;
 
 	type_id = btf_find_by_name_kind(reg->btf, "bpf_dummy_ops_state",
 					BTF_KIND_STRUCT);
@@ -194,9 +191,10 @@ static int bpf_dummy_ops_btf_struct_access(struct bpf_verifier_log *log,
 		return -EACCES;
 	}
 
-	err = btf_struct_access(log, reg, off, size, atype, next_btf_id, flag);
-	if (err < 0)
-		return err;
+	if (off + size > sizeof(struct bpf_dummy_ops_state)) {
+		bpf_log(log, "write access at off %d with size %d\n", off, size);
+		return -EACCES;
+	}
 
 	return NOT_INIT;
 }
diff --git a/net/core/filter.c b/net/core/filter.c
index 8b9f409a2ec3..1f2abf0f60e6 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8742,20 +8742,18 @@ EXPORT_SYMBOL_GPL(nf_conn_btf_access_lock);
 
 int (*nfct_btf_struct_access)(struct bpf_verifier_log *log,
 			      const struct bpf_reg_state *reg,
-			      int off, int size, enum bpf_access_type atype,
-			      u32 *next_btf_id, enum bpf_type_flag *flag);
+			      int off, int size);
 EXPORT_SYMBOL_GPL(nfct_btf_struct_access);
 
 static int tc_cls_act_btf_struct_access(struct bpf_verifier_log *log,
 					const struct bpf_reg_state *reg,
-					int off, int size, enum bpf_access_type atype,
-					u32 *next_btf_id, enum bpf_type_flag *flag)
+					int off, int size)
 {
 	int ret = -EACCES;
 
 	mutex_lock(&nf_conn_btf_access_lock);
 	if (nfct_btf_struct_access)
-		ret = nfct_btf_struct_access(log, reg, off, size, atype, next_btf_id, flag);
+		ret = nfct_btf_struct_access(log, reg, off, size);
 	mutex_unlock(&nf_conn_btf_access_lock);
 
 	return ret;
@@ -8822,14 +8820,13 @@ EXPORT_SYMBOL_GPL(bpf_warn_invalid_xdp_action);
 
 static int xdp_btf_struct_access(struct bpf_verifier_log *log,
 				 const struct bpf_reg_state *reg,
-				 int off, int size, enum bpf_access_type atype,
-				 u32 *next_btf_id, enum bpf_type_flag *flag)
+				 int off, int size)
 {
 	int ret = -EACCES;
 
 	mutex_lock(&nf_conn_btf_access_lock);
 	if (nfct_btf_struct_access)
-		ret = nfct_btf_struct_access(log, reg, off, size, atype, next_btf_id, flag);
+		ret = nfct_btf_struct_access(log, reg, off, size);
 	mutex_unlock(&nf_conn_btf_access_lock);
 
 	return ret;
diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index d6465876bbf6..4406d796cc2f 100644
--- a/net/ipv4/bpf_tcp_ca.c
+++ b/net/ipv4/bpf_tcp_ca.c
@@ -72,8 +72,7 @@ static bool bpf_tcp_ca_is_valid_access(int off, int size,
 
 static int bpf_tcp_ca_btf_struct_access(struct bpf_verifier_log *log,
 					const struct bpf_reg_state *reg,
-					int off, int size, enum bpf_access_type atype,
-					u32 *next_btf_id, enum bpf_type_flag *flag)
+					int off, int size)
 {
 	const struct btf_type *t;
 	size_t end;
diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index 002e9d24a1e9..3f821b7ba646 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -192,8 +192,7 @@ BTF_ID(struct, nf_conn___init)
 /* Check writes into `struct nf_conn` */
 static int _nf_conntrack_btf_struct_access(struct bpf_verifier_log *log,
 					   const struct bpf_reg_state *reg,
-					   int off, int size, enum bpf_access_type atype,
-					   u32 *next_btf_id, enum bpf_type_flag *flag)
+					   int off, int size)
 {
 	const struct btf_type *ncit, *nct, *t;
 	size_t end;
-- 
2.34.1

