Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAC527237C
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 14:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgIUMNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 08:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726868AbgIUMNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 08:13:32 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B16C0613CF
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 05:13:30 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id t10so12500088wrv.1
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 05:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3KZMLXl2fC0iCquVi/3iwrXDPrg7a43iWJkQ4tbiTeM=;
        b=jWLeWmTpb+UuYQCmoAM7QxX2APPc/eISUrCG2U+nnsgejMoTKfkGG6z3/+1HLn1d5X
         9I11SEfaS0M0nGpu30zB2D5pP7zHJgePYZBspM2AFJdatsq5bMj5Kq5wkES6yaH/sK6x
         x0OHk1o01ME6hKOYAlqv/v/UAdw8Nl8M4r5oU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3KZMLXl2fC0iCquVi/3iwrXDPrg7a43iWJkQ4tbiTeM=;
        b=ibDup9Km8fS7VBI5cRFY+mZrKR7iOnseOCFjjQjtTC7uVmErKPo9eNpSbLp09tOu+Q
         QZhvLhPhS4TJLykzF8fR26OlTm0LyNRZCp4y3BQn5YJ8satIE/uB7iKqtDVY7aK+cYbk
         WJS5jZ9eKA28VB5/go5r3HWCQI/cixbfc4FvgbLLutd2MXj8qKicMQcnl0H4+u3Y1Udq
         U0rrw9+Duueo9xf2qKOmPYDArkY2XPFT63EP1/eKteWgfplosZMoMGVNcI/OPL5u4mQZ
         nzfkDYm41QgjywrYBC3vTeVTLkXd5NyUFjw9pFzyajNl4ouJ20RR39osC3IZ4x4X8GBs
         6fUg==
X-Gm-Message-State: AOAM532CXfpOUBWVZ6kab96piNVIPFWaCgq95WYgyn3+Xp0b4F2v06+0
        b72bUyB/ua6JWr6vUYGH8bOcEw==
X-Google-Smtp-Source: ABdhPJxc4U2oEMGf9RzHy2hs5g/26ZLWs1nO5/L9LFOjK1zHZzHSgSh9yQO0QF0I8sHQMciku7FQfQ==
X-Received: by 2002:adf:f24f:: with SMTP id b15mr55854284wrp.301.1600690409555;
        Mon, 21 Sep 2020 05:13:29 -0700 (PDT)
Received: from antares.lan (5.4.6.2.d.5.3.3.f.8.1.6.b.2.d.8.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:8d2b:618f:335d:2645])
        by smtp.gmail.com with ESMTPSA id t15sm18466557wmj.15.2020.09.21.05.13.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 05:13:28 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next v4 11/11] bpf: use a table to drive helper arg type checks
Date:   Mon, 21 Sep 2020 13:12:27 +0100
Message-Id: <20200921121227.255763-12-lmb@cloudflare.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921121227.255763-1-lmb@cloudflare.com>
References: <20200921121227.255763-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mapping between bpf_arg_type and bpf_reg_type is encoded in a big
hairy if statement that is hard to follow. The debug output also leaves
to be desired: if a reg_type doesn't match we only print one of the
options, instead printing all the valid ones.

Convert the if statement into a table which is then used to drive type
checking. If none of the reg_types match we print all options, e.g.:

    R2 type=rdonly_buf expected=fp, pkt, pkt_meta, map_value

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/bpf.h   |   1 +
 kernel/bpf/verifier.c | 183 +++++++++++++++++++++++++-----------------
 2 files changed, 110 insertions(+), 74 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 732e2f144b6d..4ca817a9195c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -292,6 +292,7 @@ enum bpf_arg_type {
 	ARG_PTR_TO_ALLOC_MEM,	/* pointer to dynamically allocated memory */
 	ARG_PTR_TO_ALLOC_MEM_OR_NULL,	/* pointer to dynamically allocated memory or NULL */
 	ARG_CONST_ALLOC_SIZE_OR_ZERO,	/* number of allocated bytes requested */
+	__BPF_ARG_TYPE_MAX,
 };
 
 /* type of values returned from helper functions */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d64ac79982ad..b5c00d08f9c0 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3856,12 +3856,6 @@ static bool arg_type_is_mem_size(enum bpf_arg_type type)
 	       type == ARG_CONST_SIZE_OR_ZERO;
 }
 
-static bool arg_type_is_alloc_mem_ptr(enum bpf_arg_type type)
-{
-	return type == ARG_PTR_TO_ALLOC_MEM ||
-	       type == ARG_PTR_TO_ALLOC_MEM_OR_NULL;
-}
-
 static bool arg_type_is_alloc_size(enum bpf_arg_type type)
 {
 	return type == ARG_CONST_ALLOC_SIZE_OR_ZERO;
@@ -3910,14 +3904,115 @@ static int resolve_map_arg_type(struct bpf_verifier_env *env,
 	return 0;
 }
 
+struct bpf_reg_types {
+	const enum bpf_reg_type types[10];
+};
+
+static const struct bpf_reg_types map_key_value_types = {
+	.types = {
+		PTR_TO_STACK,
+		PTR_TO_PACKET,
+		PTR_TO_PACKET_META,
+		PTR_TO_MAP_VALUE,
+	},
+};
+
+static const struct bpf_reg_types sock_types = {
+	.types = {
+		PTR_TO_SOCK_COMMON,
+		PTR_TO_SOCKET,
+		PTR_TO_TCP_SOCK,
+		PTR_TO_XDP_SOCK,
+	},
+};
+
+static const struct bpf_reg_types mem_types = {
+	.types = {
+		PTR_TO_STACK,
+		PTR_TO_PACKET,
+		PTR_TO_PACKET_META,
+		PTR_TO_MAP_VALUE,
+		PTR_TO_MEM,
+		PTR_TO_RDONLY_BUF,
+		PTR_TO_RDWR_BUF,
+	},
+};
+
+static const struct bpf_reg_types int_ptr_types = {
+	.types = {
+		PTR_TO_STACK,
+		PTR_TO_PACKET,
+		PTR_TO_PACKET_META,
+		PTR_TO_MAP_VALUE,
+	},
+};
+
+static const struct bpf_reg_types fullsock_types = { .types = { PTR_TO_SOCKET } };
+static const struct bpf_reg_types scalar_types = { .types = { SCALAR_VALUE } };
+static const struct bpf_reg_types context_types = { .types = { PTR_TO_CTX } };
+static const struct bpf_reg_types alloc_mem_types = { .types = { PTR_TO_MEM } };
+static const struct bpf_reg_types const_map_ptr_types = { .types = { CONST_PTR_TO_MAP } };
+static const struct bpf_reg_types btf_ptr_types = { .types = { PTR_TO_BTF_ID } };
+static const struct bpf_reg_types spin_lock_types = { .types = { PTR_TO_MAP_VALUE } };
+
+static const struct bpf_reg_types *compatible_reg_types[] = {
+	[ARG_PTR_TO_MAP_KEY]		= &map_key_value_types,
+	[ARG_PTR_TO_MAP_VALUE]		= &map_key_value_types,
+	[ARG_PTR_TO_UNINIT_MAP_VALUE]	= &map_key_value_types,
+	[ARG_PTR_TO_MAP_VALUE_OR_NULL]	= &map_key_value_types,
+	[ARG_CONST_SIZE]		= &scalar_types,
+	[ARG_CONST_SIZE_OR_ZERO]	= &scalar_types,
+	[ARG_CONST_ALLOC_SIZE_OR_ZERO]	= &scalar_types,
+	[ARG_CONST_MAP_PTR]		= &const_map_ptr_types,
+	[ARG_PTR_TO_CTX]		= &context_types,
+	[ARG_PTR_TO_CTX_OR_NULL]	= &context_types,
+	[ARG_PTR_TO_SOCK_COMMON]	= &sock_types,
+	[ARG_PTR_TO_SOCKET]		= &fullsock_types,
+	[ARG_PTR_TO_SOCKET_OR_NULL]	= &fullsock_types,
+	[ARG_PTR_TO_BTF_ID]		= &btf_ptr_types,
+	[ARG_PTR_TO_SPIN_LOCK]		= &spin_lock_types,
+	[ARG_PTR_TO_MEM]		= &mem_types,
+	[ARG_PTR_TO_MEM_OR_NULL]	= &mem_types,
+	[ARG_PTR_TO_UNINIT_MEM]		= &mem_types,
+	[ARG_PTR_TO_ALLOC_MEM]		= &alloc_mem_types,
+	[ARG_PTR_TO_ALLOC_MEM_OR_NULL]	= &alloc_mem_types,
+	[ARG_PTR_TO_INT]		= &int_ptr_types,
+	[ARG_PTR_TO_LONG]		= &int_ptr_types,
+	[__BPF_ARG_TYPE_MAX]		= NULL,
+};
+
+static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
+			  const struct bpf_reg_types *compatible)
+{
+	struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
+	enum bpf_reg_type expected, type = reg->type;
+	int i, j;
+
+	for (i = 0; i < ARRAY_SIZE(compatible->types); i++) {
+		expected = compatible->types[i];
+		if (expected == NOT_INIT)
+			break;
+
+		if (type == expected)
+			return 0;
+	}
+
+	verbose(env, "R%d type=%s expected=", regno, reg_type_str[type]);
+	for (j = 0; j + 1 < i; j++)
+		verbose(env, "%s, ", reg_type_str[compatible->types[j]]);
+	verbose(env, "%s\n", reg_type_str[compatible->types[j]]);
+	return -EACCES;
+}
+
 static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 			  struct bpf_call_arg_meta *meta,
 			  const struct bpf_func_proto *fn)
 {
 	u32 regno = BPF_REG_1 + arg;
 	struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
-	enum bpf_reg_type expected_type, type = reg->type;
 	enum bpf_arg_type arg_type = fn->arg_type[arg];
+	const struct bpf_reg_types *compatible;
+	enum bpf_reg_type type = reg->type;
 	int err = 0;
 
 	if (arg_type == ARG_DONTCARE)
@@ -3956,72 +4051,16 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 		 */
 		goto skip_type_check;
 
-	if (arg_type == ARG_PTR_TO_MAP_KEY ||
-	    arg_type == ARG_PTR_TO_MAP_VALUE ||
-	    arg_type == ARG_PTR_TO_UNINIT_MAP_VALUE ||
-	    arg_type == ARG_PTR_TO_MAP_VALUE_OR_NULL) {
-		expected_type = PTR_TO_STACK;
-		if (!type_is_pkt_pointer(type) &&
-		    type != PTR_TO_MAP_VALUE &&
-		    type != expected_type)
-			goto err_type;
-	} else if (arg_type == ARG_CONST_SIZE ||
-		   arg_type == ARG_CONST_SIZE_OR_ZERO ||
-		   arg_type == ARG_CONST_ALLOC_SIZE_OR_ZERO) {
-		expected_type = SCALAR_VALUE;
-		if (type != expected_type)
-			goto err_type;
-	} else if (arg_type == ARG_CONST_MAP_PTR) {
-		expected_type = CONST_PTR_TO_MAP;
-		if (type != expected_type)
-			goto err_type;
-	} else if (arg_type == ARG_PTR_TO_CTX ||
-		   arg_type == ARG_PTR_TO_CTX_OR_NULL) {
-		expected_type = PTR_TO_CTX;
-		if (type != expected_type)
-			goto err_type;
-	} else if (arg_type == ARG_PTR_TO_SOCK_COMMON) {
-		expected_type = PTR_TO_SOCK_COMMON;
-		/* Any sk pointer can be ARG_PTR_TO_SOCK_COMMON */
-		if (!type_is_sk_pointer(type))
-			goto err_type;
-	} else if (arg_type == ARG_PTR_TO_SOCKET ||
-		   arg_type == ARG_PTR_TO_SOCKET_OR_NULL) {
-		expected_type = PTR_TO_SOCKET;
-		if (type != expected_type)
-			goto err_type;
-	} else if (arg_type == ARG_PTR_TO_BTF_ID) {
-		expected_type = PTR_TO_BTF_ID;
-		if (type != expected_type)
-			goto err_type;
-	} else if (arg_type == ARG_PTR_TO_SPIN_LOCK) {
-		expected_type = PTR_TO_MAP_VALUE;
-		if (type != expected_type)
-			goto err_type;
-	} else if (arg_type_is_mem_ptr(arg_type)) {
-		expected_type = PTR_TO_STACK;
-		if (!type_is_pkt_pointer(type) &&
-		    type != PTR_TO_MAP_VALUE &&
-		    type != PTR_TO_MEM &&
-		    type != PTR_TO_RDONLY_BUF &&
-		    type != PTR_TO_RDWR_BUF &&
-		    type != expected_type)
-			goto err_type;
-	} else if (arg_type_is_alloc_mem_ptr(arg_type)) {
-		expected_type = PTR_TO_MEM;
-		if (type != expected_type)
-			goto err_type;
-	} else if (arg_type_is_int_ptr(arg_type)) {
-		expected_type = PTR_TO_STACK;
-		if (!type_is_pkt_pointer(type) &&
-		    type != PTR_TO_MAP_VALUE &&
-		    type != expected_type)
-			goto err_type;
-	} else {
-		verbose(env, "unsupported arg_type %d\n", arg_type);
+	compatible = compatible_reg_types[arg_type];
+	if (!compatible) {
+		verbose(env, "verifier internal error: unsupported arg type %d\n", arg_type);
 		return -EFAULT;
 	}
 
+	err = check_reg_type(env, regno, compatible);
+	if (err)
+		return err;
+
 	if (type == PTR_TO_BTF_ID) {
 		const u32 *btf_id = fn->arg_btf_id[arg];
 
@@ -4174,10 +4213,6 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 	}
 
 	return err;
-err_type:
-	verbose(env, "R%d type=%s expected=%s\n", regno,
-		reg_type_str[type], reg_type_str[expected_type]);
-	return -EACCES;
 }
 
 static bool may_update_sockmap(struct bpf_verifier_env *env, int func_id)
-- 
2.25.1

