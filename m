Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 480E16D57B9
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 06:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232736AbjDDEvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 00:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233150AbjDDEux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 00:50:53 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D49E2110;
        Mon,  3 Apr 2023 21:50:50 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so32748185pjt.5;
        Mon, 03 Apr 2023 21:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680583850; x=1683175850;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BGlR3BgQY7WI43Q4Q1n5v+gOkH/+j7VZUA+m+7jK1f8=;
        b=Heg8+BF/m/R9UnwyTMaSDVJtMfDV5t+cwFmyHuMNWtyjwbVZkma6AxHjZ7s4XXDXw3
         O+Br/wBixIQafmcm5M/3FKPPcPTanxKZaw7a6WC2UzfaOPn4sg54/9qfwMTIpRClNhfA
         5x29qwaT7woNmLFehU9qeBb46nWNN8APcAjs9rfxXQYpP1dKYlw3MJlBWRLO+smHcW1G
         Q3uuaPmdGYyhcUM3J4P+IUqDcFLOr6xCuDaXSNmL7U9+oq8FtfwloLyRLe0IaW9AgYcf
         uB+W19Hweh/DhKn2oT4oXZPdaEMjFxYqKqywKvRcgjQmMDRo7hmN88y33QAveySbyKV7
         oeew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680583850; x=1683175850;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BGlR3BgQY7WI43Q4Q1n5v+gOkH/+j7VZUA+m+7jK1f8=;
        b=jMF9A9zXKfypt9Y0divAblCvSm9PyM8td84wJsi+VyPPILVSFdfGV8qBEnXg/D0pUq
         qhHaJQXLnvuiemDL9FJes6YJjh4KQrTU7gIZhJ2IgW+L3yJILLflVF8vj2WGGfR406n9
         6wiBs7w1J1+ywhd1ZXRFesnTjNwhLbIbilI02NPTsYJzmRynT6KdIIae5G/9E9EricqK
         EfuV6Jj8RoqIrTcYuPIsid/qFTy9n/KUucAYZekKDkwea4krCmV69oJgQ+dq5dA8y4CP
         KIX4rgr//Cn5WheFUQA2b2d7NZvKjWXx0P7OxabhM+9fztUjc/2AK9OI/Bohcf/Eeqax
         46Ew==
X-Gm-Message-State: AAQBX9cOSzC2m5MHfeEF39yaDyeZ8KQBbFURXaZu7MJMznij7Dp5HkS3
        pU1asvLH66s116g6DEhn/w4=
X-Google-Smtp-Source: AKy350ZtZT0/tzFlkaRPB9xEExHjg+8DhH+pFNY9Ko3a7ttKFADQR2j7FFsCtbSBmevgKhRrcBoSzQ==
X-Received: by 2002:a17:902:c98a:b0:1a1:b3c0:4228 with SMTP id g10-20020a170902c98a00b001a1b3c04228mr1204410plc.19.1680583849609;
        Mon, 03 Apr 2023 21:50:49 -0700 (PDT)
Received: from dhcp-172-26-102-232.DHCP.thefacebook.com ([2620:10d:c090:400::5:3c8])
        by smtp.gmail.com with ESMTPSA id e8-20020a170902b78800b001a20791250esm7415104pls.22.2023.04.03.21.50.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 03 Apr 2023 21:50:49 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next 4/8] bpf: Teach verifier that certain helpers accept NULL pointer.
Date:   Mon,  3 Apr 2023 21:50:25 -0700
Message-Id: <20230404045029.82870-5-alexei.starovoitov@gmail.com>
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

bpf_[sk|inode|task|cgrp]_storage_[get|delete]() and bpf_get_socket_cookie() helpers
perform run-time check that sk|inode|task|cgrp pointer != NULL.
Teach verifier about this fact and allow bpf programs to pass
PTR_TO_BTF_ID | PTR_MAYBE_NULL into such helpers.
It will be used in the subsequent patch that will do
bpf_sk_storage_get(.., skb->sk, ...);
Even when 'skb' pointer is trusted the 'sk' pointer may be NULL.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/bpf_cgrp_storage.c  | 4 ++--
 kernel/bpf/bpf_inode_storage.c | 4 ++--
 kernel/bpf/bpf_task_storage.c  | 8 ++++----
 net/core/bpf_sk_storage.c      | 4 ++--
 net/core/filter.c              | 2 +-
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/kernel/bpf/bpf_cgrp_storage.c b/kernel/bpf/bpf_cgrp_storage.c
index d17d5b694668..d44fe8dd9732 100644
--- a/kernel/bpf/bpf_cgrp_storage.c
+++ b/kernel/bpf/bpf_cgrp_storage.c
@@ -224,7 +224,7 @@ const struct bpf_func_proto bpf_cgrp_storage_get_proto = {
 	.gpl_only	= false,
 	.ret_type	= RET_PTR_TO_MAP_VALUE_OR_NULL,
 	.arg1_type	= ARG_CONST_MAP_PTR,
-	.arg2_type	= ARG_PTR_TO_BTF_ID,
+	.arg2_type	= ARG_PTR_TO_BTF_ID_OR_NULL,
 	.arg2_btf_id	= &bpf_cgroup_btf_id[0],
 	.arg3_type	= ARG_PTR_TO_MAP_VALUE_OR_NULL,
 	.arg4_type	= ARG_ANYTHING,
@@ -235,6 +235,6 @@ const struct bpf_func_proto bpf_cgrp_storage_delete_proto = {
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_CONST_MAP_PTR,
-	.arg2_type	= ARG_PTR_TO_BTF_ID,
+	.arg2_type	= ARG_PTR_TO_BTF_ID_OR_NULL,
 	.arg2_btf_id	= &bpf_cgroup_btf_id[0],
 };
diff --git a/kernel/bpf/bpf_inode_storage.c b/kernel/bpf/bpf_inode_storage.c
index e17ad581b9be..a4d93df78c75 100644
--- a/kernel/bpf/bpf_inode_storage.c
+++ b/kernel/bpf/bpf_inode_storage.c
@@ -229,7 +229,7 @@ const struct bpf_func_proto bpf_inode_storage_get_proto = {
 	.gpl_only	= false,
 	.ret_type	= RET_PTR_TO_MAP_VALUE_OR_NULL,
 	.arg1_type	= ARG_CONST_MAP_PTR,
-	.arg2_type	= ARG_PTR_TO_BTF_ID,
+	.arg2_type	= ARG_PTR_TO_BTF_ID_OR_NULL,
 	.arg2_btf_id	= &bpf_inode_storage_btf_ids[0],
 	.arg3_type	= ARG_PTR_TO_MAP_VALUE_OR_NULL,
 	.arg4_type	= ARG_ANYTHING,
@@ -240,6 +240,6 @@ const struct bpf_func_proto bpf_inode_storage_delete_proto = {
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_CONST_MAP_PTR,
-	.arg2_type	= ARG_PTR_TO_BTF_ID,
+	.arg2_type	= ARG_PTR_TO_BTF_ID_OR_NULL,
 	.arg2_btf_id	= &bpf_inode_storage_btf_ids[0],
 };
diff --git a/kernel/bpf/bpf_task_storage.c b/kernel/bpf/bpf_task_storage.c
index d1af0c8f9ce4..adf6dfe0ba68 100644
--- a/kernel/bpf/bpf_task_storage.c
+++ b/kernel/bpf/bpf_task_storage.c
@@ -338,7 +338,7 @@ const struct bpf_func_proto bpf_task_storage_get_recur_proto = {
 	.gpl_only = false,
 	.ret_type = RET_PTR_TO_MAP_VALUE_OR_NULL,
 	.arg1_type = ARG_CONST_MAP_PTR,
-	.arg2_type = ARG_PTR_TO_BTF_ID,
+	.arg2_type = ARG_PTR_TO_BTF_ID_OR_NULL,
 	.arg2_btf_id = &btf_tracing_ids[BTF_TRACING_TYPE_TASK],
 	.arg3_type = ARG_PTR_TO_MAP_VALUE_OR_NULL,
 	.arg4_type = ARG_ANYTHING,
@@ -349,7 +349,7 @@ const struct bpf_func_proto bpf_task_storage_get_proto = {
 	.gpl_only = false,
 	.ret_type = RET_PTR_TO_MAP_VALUE_OR_NULL,
 	.arg1_type = ARG_CONST_MAP_PTR,
-	.arg2_type = ARG_PTR_TO_BTF_ID,
+	.arg2_type = ARG_PTR_TO_BTF_ID_OR_NULL,
 	.arg2_btf_id = &btf_tracing_ids[BTF_TRACING_TYPE_TASK],
 	.arg3_type = ARG_PTR_TO_MAP_VALUE_OR_NULL,
 	.arg4_type = ARG_ANYTHING,
@@ -360,7 +360,7 @@ const struct bpf_func_proto bpf_task_storage_delete_recur_proto = {
 	.gpl_only = false,
 	.ret_type = RET_INTEGER,
 	.arg1_type = ARG_CONST_MAP_PTR,
-	.arg2_type = ARG_PTR_TO_BTF_ID,
+	.arg2_type = ARG_PTR_TO_BTF_ID_OR_NULL,
 	.arg2_btf_id = &btf_tracing_ids[BTF_TRACING_TYPE_TASK],
 };
 
@@ -369,6 +369,6 @@ const struct bpf_func_proto bpf_task_storage_delete_proto = {
 	.gpl_only = false,
 	.ret_type = RET_INTEGER,
 	.arg1_type = ARG_CONST_MAP_PTR,
-	.arg2_type = ARG_PTR_TO_BTF_ID,
+	.arg2_type = ARG_PTR_TO_BTF_ID_OR_NULL,
 	.arg2_btf_id = &btf_tracing_ids[BTF_TRACING_TYPE_TASK],
 };
diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index 085025c7130a..d4172534dfa8 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -412,7 +412,7 @@ const struct bpf_func_proto bpf_sk_storage_get_tracing_proto = {
 	.gpl_only	= false,
 	.ret_type	= RET_PTR_TO_MAP_VALUE_OR_NULL,
 	.arg1_type	= ARG_CONST_MAP_PTR,
-	.arg2_type	= ARG_PTR_TO_BTF_ID,
+	.arg2_type	= ARG_PTR_TO_BTF_ID_OR_NULL,
 	.arg2_btf_id	= &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
 	.arg3_type	= ARG_PTR_TO_MAP_VALUE_OR_NULL,
 	.arg4_type	= ARG_ANYTHING,
@@ -424,7 +424,7 @@ const struct bpf_func_proto bpf_sk_storage_delete_tracing_proto = {
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_CONST_MAP_PTR,
-	.arg2_type	= ARG_PTR_TO_BTF_ID,
+	.arg2_type	= ARG_PTR_TO_BTF_ID_OR_NULL,
 	.arg2_btf_id	= &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
 	.allowed	= bpf_sk_storage_tracing_allowed,
 };
diff --git a/net/core/filter.c b/net/core/filter.c
index 1f2abf0f60e6..727c5269867d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4998,7 +4998,7 @@ const struct bpf_func_proto bpf_get_socket_ptr_cookie_proto = {
 	.func		= bpf_get_socket_ptr_cookie,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_BTF_ID_SOCK_COMMON,
+	.arg1_type	= ARG_PTR_TO_BTF_ID_SOCK_COMMON | PTR_MAYBE_NULL,
 };
 
 BPF_CALL_1(bpf_get_socket_cookie_sock_ops, struct bpf_sock_ops_kern *, ctx)
-- 
2.34.1

