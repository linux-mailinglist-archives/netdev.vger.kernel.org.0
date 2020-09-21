Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1202272377
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 14:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgIUMN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 08:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbgIUMNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 08:13:24 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB34C0613D1
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 05:13:22 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id y15so12401327wmi.0
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 05:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ReOPTCTBI89zUNcN9aZJisi4S7TTo39X4bWkAmOczYk=;
        b=BUKKdNfhkrFr8+QFBgF7oDEnyUFywcrt2x94/PKwiJtYV+CKEv97YK+TKZOdy94ANZ
         kjKQ1kurSlIpzVE+/9slxlPmChzWtyF8O83ui1P4zddpJ0DvTE/VJjIGzRCQoev3guAX
         8L3+UmZXUQyI7//JYub1n/o3CBB4S7P7nkGJY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ReOPTCTBI89zUNcN9aZJisi4S7TTo39X4bWkAmOczYk=;
        b=EE/u89M1o3QIYnN72lnRgM4nopOFJduXiQEO4vE+TRLUKVH4y2VjmQ3nR+69vzI6rg
         umL3eaiENcgr+e9j3FniwbEoAAGZYvN8u4xAihm5HBNXW5YMweB5G1d1BDbXux7fNEf6
         VBEWbm8DE/XAlV9morNNbukPGB36o4n2pNTfmUcecqvqq1QTHe0YGpK0qNnzHse+b+UG
         NGfQ1XZMcbbaa/yAhlgNGtVw6flykfdoocVjuLyT4/mjao2KvRN99FA5DECYH346auac
         H3eIH65XAVFbr7lM73fOyu06tbFLFTIFX8Qg9W0bTOfuLzy4vECFbjMM+JqC/9CWip9f
         Z22w==
X-Gm-Message-State: AOAM531LoVPUSsr1JkDdrG11CyPNxmsBkCfS8zzQWi4rM35mtkITPoBC
        Uf8KzyZs2ZU/I0Ws+MJ2f5Ui17ysZHdxBw==
X-Google-Smtp-Source: ABdhPJzl/LJ/BwumR/eFyLYdKcUTfD8bMu+ABbnSiTZH9KhFmUJRtjXHa0O5fbPkcUWdj29WprB7Dw==
X-Received: by 2002:a1c:3d44:: with SMTP id k65mr29025265wma.132.1600690401340;
        Mon, 21 Sep 2020 05:13:21 -0700 (PDT)
Received: from antares.lan (5.4.6.2.d.5.3.3.f.8.1.6.b.2.d.8.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:8d2b:618f:335d:2645])
        by smtp.gmail.com with ESMTPSA id t15sm18466557wmj.15.2020.09.21.05.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 05:13:20 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next v4 05/11] bpf: make BTF pointer type checking generic
Date:   Mon, 21 Sep 2020 13:12:21 +0100
Message-Id: <20200921121227.255763-6-lmb@cloudflare.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921121227.255763-1-lmb@cloudflare.com>
References: <20200921121227.255763-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Perform BTF type checks if the register we're working on contains a BTF
pointer, rather than if the argument is for a BTF pointer. This is easier
to understand, and allows removing the code from the arg_type checking
section of the function.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
 kernel/bpf/verifier.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 9f95d6d55c5f..99c0d7adcb1e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4001,27 +4001,9 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 				goto err_type;
 		}
 	} else if (arg_type == ARG_PTR_TO_BTF_ID) {
-		const u32 *btf_id = fn->arg_btf_id[arg];
-
 		expected_type = PTR_TO_BTF_ID;
 		if (type != expected_type)
 			goto err_type;
-
-		if (!btf_id) {
-			verbose(env, "verifier internal error: missing BTF ID\n");
-			return -EFAULT;
-		}
-
-		if (!btf_struct_ids_match(&env->log, reg->off, reg->btf_id, *btf_id)) {
-			verbose(env, "R%d is of type %s but %s is expected\n",
-				regno, kernel_type_name(reg->btf_id), kernel_type_name(*btf_id));
-			return -EACCES;
-		}
-		if (!tnum_is_const(reg->var_off) || reg->var_off.value) {
-			verbose(env, "R%d is a pointer to in-kernel struct with non-zero offset\n",
-				regno);
-			return -EACCES;
-		}
 	} else if (arg_type == ARG_PTR_TO_SPIN_LOCK) {
 		if (meta->func_id == BPF_FUNC_spin_lock) {
 			if (process_spin_lock(env, regno, true))
@@ -4076,6 +4058,26 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 		return -EFAULT;
 	}
 
+	if (type == PTR_TO_BTF_ID) {
+		const u32 *btf_id = fn->arg_btf_id[arg];
+
+		if (!btf_id) {
+			verbose(env, "verifier internal error: missing BTF ID\n");
+			return -EFAULT;
+		}
+
+		if (!btf_struct_ids_match(&env->log, reg->off, reg->btf_id, *btf_id)) {
+			verbose(env, "R%d is of type %s but %s is expected\n",
+				regno, kernel_type_name(reg->btf_id), kernel_type_name(*btf_id));
+			return -EACCES;
+		}
+		if (!tnum_is_const(reg->var_off) || reg->var_off.value) {
+			verbose(env, "R%d is a pointer to in-kernel struct with non-zero offset\n",
+				regno);
+			return -EACCES;
+		}
+	}
+
 	if (arg_type == ARG_CONST_MAP_PTR) {
 		/* bpf_map_xxx(map_ptr) call: remember that map_ptr */
 		meta->map_ptr = reg->map_ptr;
-- 
2.25.1

