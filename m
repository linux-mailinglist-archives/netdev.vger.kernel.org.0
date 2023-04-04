Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA2D6D57B3
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 06:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233114AbjDDEul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 00:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbjDDEuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 00:50:39 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202981FFA;
        Mon,  3 Apr 2023 21:50:38 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id x37so18880962pga.1;
        Mon, 03 Apr 2023 21:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680583837; x=1683175837;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6UeHRiVQiuVug2QCd8JwR0rmeb9wuxhyGp0d7KYKKh4=;
        b=YjhtQMC5KdKYLRhNcL68YCcISrdhyw0BU09+Sa4milJHnV7L52FcXOJa19gFHP2J9D
         SxV9BbjtDfpyVakP/dToVgfIUEduZTX5XWIQQ2sNYJmPSBvjXm3vAEpO6eBzTAA9dyYz
         P6t79TkM8+x/rNcgEiytlu/dZ5CXsl0hArXvkHRDlvhDb5QBEc/6Xpr9tzyKYbwCt056
         STYw07dKSTrN6B9QeLvWKyMLCRROA1GoCLs1B991F2axupGhmZ3WQxZoCK263lIHvKJY
         A0ShE+qBX7ez8WJmvAlMvorfGNBRLROJMCIpdR06qbtAvP7OtfDyP3p3hzcCL3Bsozs3
         LS5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680583837; x=1683175837;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6UeHRiVQiuVug2QCd8JwR0rmeb9wuxhyGp0d7KYKKh4=;
        b=t3qMCSJEKjw1ipaEwIZw3D6Mhi7Bn61S/WbnDd9pRUhyE1m62ZP4kFV4oY9e1fOrqS
         SSOf0r1/KNy7R1u+yS0PuntAVzl9iD4iEmxI9uIBq/vjX8nkjrN0tNgDTf4IQIM5dcU5
         InJISpVbYoOt/vckS0bnBDwvzBkaRur1yw0iAwmShVRtg16NF6MgHp8TKVMleIUH0BDF
         Y7fQfJt4exeExS1rAXsllEkG5Kfbh9PCsTfIZLEnmoqlMdcsXdZvbMwwrOdgqjY7ytuO
         o2qLvwWQkW5dRW8Kl2eIj7Vi2ZJlzDb1BsCyTq34mVqtuV/xeCSI/cYQaoAZPd+5n0EV
         y/iA==
X-Gm-Message-State: AAQBX9dgduyvGOYqwBQr3+FWWwmY7GO2GJq8cJz3FIs3CaiXOTBDcLWh
        6v/LQmb+VP366Ok3l2we12A=
X-Google-Smtp-Source: AKy350YP5txTp/G8xZ+MFDk18m1wHMa+Df7WAXsXso5vRDs9x81U4Co1LP3OjCu2cM16QX1GGn/bbw==
X-Received: by 2002:aa7:978a:0:b0:627:f9ac:8a31 with SMTP id o10-20020aa7978a000000b00627f9ac8a31mr987238pfp.2.1680583837343;
        Mon, 03 Apr 2023 21:50:37 -0700 (PDT)
Received: from dhcp-172-26-102-232.DHCP.thefacebook.com ([2620:10d:c090:400::5:3c8])
        by smtp.gmail.com with ESMTPSA id c7-20020aa78e07000000b005abc30d9445sm7749554pfr.180.2023.04.03.21.50.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 03 Apr 2023 21:50:36 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next 1/8] bpf: Invoke btf_struct_access() callback only for writes.
Date:   Mon,  3 Apr 2023 21:50:22 -0700
Message-Id: <20230404045029.82870-2-alexei.starovoitov@gmail.com>
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

Remove duplicated if (atype == BPF_READ) btf_struct_access() from
btf_struct_access() callback and invoke it only for writes.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/verifier.c          | 2 +-
 net/bpf/bpf_dummy_struct_ops.c | 2 +-
 net/core/filter.c              | 6 ------
 net/ipv4/bpf_tcp_ca.c          | 3 ---
 4 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index eaf9c5291cf0..83984568ccb4 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5504,7 +5504,7 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
 		return -EACCES;
 	}
 
-	if (env->ops->btf_struct_access && !type_is_alloc(reg->type)) {
+	if (env->ops->btf_struct_access && !type_is_alloc(reg->type) && atype == BPF_WRITE) {
 		if (!btf_is_kernel(reg->btf)) {
 			verbose(env, "verifier internal error: reg->btf must be kernel btf\n");
 			return -EFAULT;
diff --git a/net/bpf/bpf_dummy_struct_ops.c b/net/bpf/bpf_dummy_struct_ops.c
index ff4f89a2b02a..9535c8506cda 100644
--- a/net/bpf/bpf_dummy_struct_ops.c
+++ b/net/bpf/bpf_dummy_struct_ops.c
@@ -198,7 +198,7 @@ static int bpf_dummy_ops_btf_struct_access(struct bpf_verifier_log *log,
 	if (err < 0)
 		return err;
 
-	return atype == BPF_READ ? err : NOT_INIT;
+	return NOT_INIT;
 }
 
 static const struct bpf_verifier_ops bpf_dummy_verifier_ops = {
diff --git a/net/core/filter.c b/net/core/filter.c
index 3370efad1dda..8b9f409a2ec3 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8753,9 +8753,6 @@ static int tc_cls_act_btf_struct_access(struct bpf_verifier_log *log,
 {
 	int ret = -EACCES;
 
-	if (atype == BPF_READ)
-		return btf_struct_access(log, reg, off, size, atype, next_btf_id, flag);
-
 	mutex_lock(&nf_conn_btf_access_lock);
 	if (nfct_btf_struct_access)
 		ret = nfct_btf_struct_access(log, reg, off, size, atype, next_btf_id, flag);
@@ -8830,9 +8827,6 @@ static int xdp_btf_struct_access(struct bpf_verifier_log *log,
 {
 	int ret = -EACCES;
 
-	if (atype == BPF_READ)
-		return btf_struct_access(log, reg, off, size, atype, next_btf_id, flag);
-
 	mutex_lock(&nf_conn_btf_access_lock);
 	if (nfct_btf_struct_access)
 		ret = nfct_btf_struct_access(log, reg, off, size, atype, next_btf_id, flag);
diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index ea21c96c03aa..d6465876bbf6 100644
--- a/net/ipv4/bpf_tcp_ca.c
+++ b/net/ipv4/bpf_tcp_ca.c
@@ -78,9 +78,6 @@ static int bpf_tcp_ca_btf_struct_access(struct bpf_verifier_log *log,
 	const struct btf_type *t;
 	size_t end;
 
-	if (atype == BPF_READ)
-		return btf_struct_access(log, reg, off, size, atype, next_btf_id, flag);
-
 	t = btf_type_by_id(reg->btf, reg->btf_id);
 	if (t != tcp_sock_type) {
 		bpf_log(log, "only read is supported\n");
-- 
2.34.1

