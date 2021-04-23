Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0B03689CB
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 02:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240096AbhDWA1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 20:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240031AbhDWA1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 20:27:33 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FCFC06138D;
        Thu, 22 Apr 2021 17:26:57 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id m11so32931629pfc.11;
        Thu, 22 Apr 2021 17:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YbKUfdWF+ftmIy+2zx86e/NuR2FM7rZUXSxwMsvYoZQ=;
        b=gm4UTMcDgNXLRWkPYmII+6U9JzSNPP7NQrHTsoLNpVO0gtXpgHIRtJch3DhQbkUtO4
         t24T0q8gJtMFdY4xn2ZCnhHnzZIpDw4Ip3AkiCs2wqU3D/dvd9ibOEXNyxFk6lFSluA4
         hHD77JSYGl9gUXNb9SwDTIeiTC61VH5Ny2CbvJyNNwvtNXhhxj7vYmnu1GtV2g2fTnJ6
         DY1564b/LUpM3v8Uxlps6N0avJysUHMCMF3gxAstFeDEKTXtEM0+YRP26Uivbeg1+SDl
         tu0NjCE4oPJfRB58aCMYZmxpnZ8GyzTazIzbA/uVw51HDWUfsyOBnoPy+ByVDyoghbVs
         zDPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YbKUfdWF+ftmIy+2zx86e/NuR2FM7rZUXSxwMsvYoZQ=;
        b=IAQF2285tFYl1wa/tM575VaLNFYjgELchMsXPdyfnek60TbGQusL03yErVR16mmOAF
         oG5MJ91Q4YwN/03HetHNqmnQ6SmyW0ukiNKKjKaCy2QZmQJC+UkfF1ZsB8m2jDUQpqmU
         DDbpqtyYu4jqccCShTmUIMeQEOXAZOnbOAn36K0iFfK32CT2Qi9k640m42dZG8SL+7/L
         iM2DXfR7YTMAwOUgJU9Ap3BZiE1JLRUJ8qN/DMooexGYDmvcHPCHzwu9ptcGyrULYPBS
         //VLiibz7fC0bP9xYlyKBjSgLYFVoD14fnsxFcEXiBlSvPMNRl822sy1jfPRUcGHgX/k
         mb1g==
X-Gm-Message-State: AOAM530zoYbY7ET5So+J3g0jmOPaEI/wm5LWLx6tnmxwAWvUPuV+3MWL
        ygcVnCC21KexDQc8Ig0ycApJ3Iif6wQ=
X-Google-Smtp-Source: ABdhPJyy/4G/7l93BFM9jlpfcwntdYKtZyGrFqGnGGxSgyg7ymKco/QiAq6UNh7DPzItfb0D4SGVPw==
X-Received: by 2002:a05:6a00:1aca:b029:25a:b810:94c7 with SMTP id f10-20020a056a001acab029025ab81094c7mr1355224pfv.15.1619137616973;
        Thu, 22 Apr 2021 17:26:56 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id u12sm6390987pji.45.2021.04.22.17.26.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Apr 2021 17:26:56 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 bpf-next 06/16] bpf: Make btf_load command to be bpfptr_t compatible.
Date:   Thu, 22 Apr 2021 17:26:36 -0700
Message-Id: <20210423002646.35043-7-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Similar to prog_load make btf_load command to be availble to
bpf_prog_type_syscall program.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/btf.h  | 2 +-
 kernel/bpf/btf.c     | 8 ++++----
 kernel/bpf/syscall.c | 7 ++++---
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 3bac66e0183a..94a0c976c90f 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -21,7 +21,7 @@ extern const struct file_operations btf_fops;
 
 void btf_get(struct btf *btf);
 void btf_put(struct btf *btf);
-int btf_new_fd(const union bpf_attr *attr);
+int btf_new_fd(const union bpf_attr *attr, bpfptr_t uattr);
 struct btf *btf_get_by_fd(int fd);
 int btf_get_info_by_fd(const struct btf *btf,
 		       const union bpf_attr *attr,
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 0600ed325fa0..fbf6c06a9d62 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4257,7 +4257,7 @@ static int btf_parse_hdr(struct btf_verifier_env *env)
 	return 0;
 }
 
-static struct btf *btf_parse(void __user *btf_data, u32 btf_data_size,
+static struct btf *btf_parse(bpfptr_t btf_data, u32 btf_data_size,
 			     u32 log_level, char __user *log_ubuf, u32 log_size)
 {
 	struct btf_verifier_env *env = NULL;
@@ -4306,7 +4306,7 @@ static struct btf *btf_parse(void __user *btf_data, u32 btf_data_size,
 	btf->data = data;
 	btf->data_size = btf_data_size;
 
-	if (copy_from_user(data, btf_data, btf_data_size)) {
+	if (copy_from_bpfptr(data, btf_data, btf_data_size)) {
 		err = -EFAULT;
 		goto errout;
 	}
@@ -5780,12 +5780,12 @@ static int __btf_new_fd(struct btf *btf)
 	return anon_inode_getfd("btf", &btf_fops, btf, O_RDONLY | O_CLOEXEC);
 }
 
-int btf_new_fd(const union bpf_attr *attr)
+int btf_new_fd(const union bpf_attr *attr, bpfptr_t uattr)
 {
 	struct btf *btf;
 	int ret;
 
-	btf = btf_parse(u64_to_user_ptr(attr->btf),
+	btf = btf_parse(make_bpfptr(attr->btf, uattr.is_kernel),
 			attr->btf_size, attr->btf_log_level,
 			u64_to_user_ptr(attr->btf_log_buf),
 			attr->btf_log_size);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 2e9bc04fd821..9b3bc48b1cc6 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3831,7 +3831,7 @@ static int bpf_obj_get_info_by_fd(const union bpf_attr *attr,
 
 #define BPF_BTF_LOAD_LAST_FIELD btf_log_level
 
-static int bpf_btf_load(const union bpf_attr *attr)
+static int bpf_btf_load(const union bpf_attr *attr, bpfptr_t uattr)
 {
 	if (CHECK_ATTR(BPF_BTF_LOAD))
 		return -EINVAL;
@@ -3839,7 +3839,7 @@ static int bpf_btf_load(const union bpf_attr *attr)
 	if (!bpf_capable())
 		return -EPERM;
 
-	return btf_new_fd(attr);
+	return btf_new_fd(attr, uattr);
 }
 
 #define BPF_BTF_GET_FD_BY_ID_LAST_FIELD btf_id
@@ -4460,7 +4460,7 @@ static int __sys_bpf(int cmd, bpfptr_t uattr, unsigned int size)
 		err = bpf_raw_tracepoint_open(&attr);
 		break;
 	case BPF_BTF_LOAD:
-		err = bpf_btf_load(&attr);
+		err = bpf_btf_load(&attr, uattr);
 		break;
 	case BPF_BTF_GET_FD_BY_ID:
 		err = bpf_btf_get_fd_by_id(&attr);
@@ -4541,6 +4541,7 @@ BPF_CALL_3(bpf_sys_bpf, int, cmd, void *, attr, u32, attr_size)
 	case BPF_MAP_UPDATE_ELEM:
 	case BPF_MAP_FREEZE:
 	case BPF_PROG_LOAD:
+	case BPF_BTF_LOAD:
 		break;
 	/* case BPF_PROG_TEST_RUN:
 	 * is not part of this list to prevent recursive test_run
-- 
2.30.2

